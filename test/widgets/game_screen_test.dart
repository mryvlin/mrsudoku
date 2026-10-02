import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/l10n/app_localizations.dart';
import 'package:mrsudoku/logic/candidates.dart';
import 'package:mrsudoku/logic/providers.dart';
import 'package:mrsudoku/models/board.dart';
import 'package:mrsudoku/models/difficulty.dart';
import 'package:mrsudoku/models/game_state.dart';
import 'package:mrsudoku/ui/screens/game_screen.dart';
import 'package:mrsudoku/ui/widgets/sudoku_board_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _filledCellCount(Board board) {
  var count = 0;
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      if (!board.cellAt(r, c).isEmpty) count++;
    }
  }
  return count;
}

/// Taps the board at (row, col), in cell coordinates - the board now paints
/// its own grid on a single canvas rather than one tappable widget per
/// cell, so a tap needs a pixel offset instead of a `find.byKey`.
Future<void> _tapCell(WidgetTester tester, int row, int col) async {
  final boardRect = tester.getRect(find.byType(SudokuBoardWidget));
  final cellSize = boardRect.width / kBoardSize; // classic layout only: square, 9x9
  await tester.tapAt(boardRect.topLeft + Offset((col + 0.5) * cellSize, (row + 0.5) * cellSize));
}

(int, int) _firstEmptyCell(GameState state) {
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      if (state.board.cellAt(r, c).isEmpty) return (r, c);
    }
  }
  throw StateError('no empty cell found');
}

Future<ProviderContainer> _startedContainer(
  WidgetTester tester, {
  Difficulty difficulty = Difficulty.easy,
}) async {
  SharedPreferences.setMockInitialValues({});
  final container = ProviderContainer();
  addTearDown(container.dispose);
  // startNewGame -> PuzzleGenerationService.generate uses compute(), which
  // spawns a real isolate. That needs genuine event-loop pumping, which the
  // fake-time zone testWidgets normally runs in does not provide - hence
  // runAsync (see WidgetTester.runAsync docs on real async work in tests).
  await tester.runAsync(
    () => container.read(gameControllerProvider.notifier).startNewGame(
      difficulty,
      maxMistakes: 3,
      errorLimitEnabled: true,
      maxHints: 5,
    ),
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const GameScreen(),
      ),
    ),
  );
  await tester.pump();
  return container;
}

void main() {
  testWidgets('tapping a cell then a number enters that value on the board', (tester) async {
    final container = await _startedContainer(tester);
    final pos = _firstEmptyCell(container.read(gameControllerProvider)!);
    final correctValue =
        container.read(gameControllerProvider)!.solution.cellAt(pos.$1, pos.$2).value;

    await _tapCell(tester, pos.$1, pos.$2);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('numpad-$correctValue')));
    await tester.pump();

    expect(
      container.read(gameControllerProvider)!.board.cellAt(pos.$1, pos.$2).value,
      correctValue,
    );

    // Flush the debounced autosave timer inputNumber scheduled, so the test
    // doesn't end with a pending Timer.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('notes mode enters a pencil mark instead of a value', (tester) async {
    final container = await _startedContainer(tester);
    final pos = _firstEmptyCell(container.read(gameControllerProvider)!);
    final candidate =
        Candidates.forCell(container.read(gameControllerProvider)!.board, pos.$1, pos.$2).first;

    await _tapCell(tester, pos.$1, pos.$2);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('toolbar-notes')));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('numpad-$candidate')));
    await tester.pump();

    final cell = container.read(gameControllerProvider)!.board.cellAt(pos.$1, pos.$2);
    expect(cell.value, 0);
    expect(cell.notes, contains(candidate));

    // Flush the debounced autosave timer inputNumber scheduled, so the test
    // doesn't end with a pending Timer.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('undo button reverts the last entered value', (tester) async {
    final container = await _startedContainer(tester);
    final pos = _firstEmptyCell(container.read(gameControllerProvider)!);
    final correctValue =
        container.read(gameControllerProvider)!.solution.cellAt(pos.$1, pos.$2).value;

    await _tapCell(tester, pos.$1, pos.$2);
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('numpad-$correctValue')));
    await tester.pump();
    expect(
      container.read(gameControllerProvider)!.board.cellAt(pos.$1, pos.$2).value,
      correctValue,
    );

    await tester.tap(find.byKey(const ValueKey('toolbar-undo')));
    await tester.pump();

    expect(container.read(gameControllerProvider)!.board.cellAt(pos.$1, pos.$2).value, 0);

    // Flush the debounced autosave timers inputNumber/undo scheduled, so
    // the test doesn't end with a pending Timer.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a hint walks through nudge, explanation and answer, and only the answer places it', (tester) async {
    // The default 800x600 test surface is too short for the full game UI
    // plus the hint banner - the banner's action button ends up laid out
    // off-screen and untappable. Use a taller, phone-like viewport instead.
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await _startedContainer(tester);
    final filledBefore = _filledCellCount(container.read(gameControllerProvider)!.board);
    final hintsBefore = container.read(gameControllerProvider)!.hintsRemaining;
    final l10n = AppLocalizations.of(tester.element(find.byType(GameScreen)))!;

    // Stage 1: a nudge. Nothing placed, nothing selected, nothing spent.
    await tester.tap(find.byKey(const ValueKey('toolbar-hint')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('hint-panel')), findsOneWidget);
    expect(find.text(l10n.hintMore), findsOneWidget);
    expect(container.read(gameControllerProvider)!.hasSelection, isFalse);

    // Stage 2: the technique. The Hint button advances too, like "More help".
    await tester.tap(find.byKey(const ValueKey('toolbar-hint')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.hintShowAnswer), findsOneWidget);
    expect(_filledCellCount(container.read(gameControllerProvider)!.board), filledBefore);

    // Stage 3: the answer, still not applied or charged for.
    await tester.tap(find.text(l10n.hintShowAnswer));
    await tester.pumpAndSettle();
    expect(find.text(l10n.hintPlace), findsOneWidget);
    expect(_filledCellCount(container.read(gameControllerProvider)!.board), filledBefore);
    expect(container.read(gameControllerProvider)!.hintsRemaining, hintsBefore);

    await tester.tap(find.text(l10n.hintPlace));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('hint-panel')), findsNothing);
    expect(_filledCellCount(container.read(gameControllerProvider)!.board), filledBefore + 1);
    expect(container.read(gameControllerProvider)!.hintsRemaining, hintsBefore - 1);

    // Flush the debounced autosave timer confirmHint scheduled, so the test
    // doesn't end with a pending Timer.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Back returns a hint to its nudge, and the technique guide is reachable from stage 2', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _startedContainer(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(GameScreen)))!;

    await tester.tap(find.byKey(const ValueKey('toolbar-hint')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.hintStageLabel(1, 3)), findsOneWidget);

    await tester.tap(find.text(l10n.hintMore));
    await tester.pumpAndSettle();
    expect(find.text(l10n.hintStageLabel(2, 3)), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-guide')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('hint-back')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.hintStageLabel(1, 3)), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-guide')), findsNothing);

    await tester.tap(find.text(l10n.hintCancel));
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('cancelling a hint spends nothing and leaves the board alone', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await _startedContainer(tester);
    final before = container.read(gameControllerProvider)!;
    final l10n = AppLocalizations.of(tester.element(find.byType(GameScreen)))!;

    await tester.tap(find.byKey(const ValueKey('toolbar-hint')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.hintCancel));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('hint-panel')), findsNothing);
    expect(container.read(gameControllerProvider)!.hintsRemaining, before.hintsRemaining);
    expect(_filledCellCount(container.read(gameControllerProvider)!.board), _filledCellCount(before.board));
  });

  testWidgets('a hint is dropped when the player changes the board while it is showing', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await _startedContainer(tester);
    await tester.tap(find.byKey(const ValueKey('toolbar-hint')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('hint-panel')), findsOneWidget);

    final pos = _firstEmptyCell(container.read(gameControllerProvider)!);
    container.read(gameControllerProvider.notifier).selectCell(pos.$1, pos.$2);
    container.read(gameControllerProvider.notifier).inputNumber(
          container.read(gameControllerProvider)!.solution.cellAt(pos.$1, pos.$2).value,
        );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('hint-panel')), findsNothing);

    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the auto-solve toolbar button toggles GameState.autoSolveSingles', (tester) async {
    // An Easy puzzle is solvable start-to-finish with naked singles alone
    // (see Difficulty.maxAllowedTechniqueRank), so turning auto-solve on
    // would immediately win it, and a won game locks out the second toggle
    // this test needs. Expert always needs more than naked singles, so it
    // can't complete (and lock the toggle) on its own like that.
    final container = await _startedContainer(tester, difficulty: Difficulty.expert);
    expect(container.read(gameControllerProvider)!.autoSolveSingles, isFalse);

    await tester.tap(find.byKey(const ValueKey('toolbar-autosolve')));
    await tester.pump();

    expect(container.read(gameControllerProvider)!.autoSolveSingles, isTrue);

    await tester.tap(find.byKey(const ValueKey('toolbar-autosolve')));
    await tester.pump();

    expect(container.read(gameControllerProvider)!.autoSolveSingles, isFalse);

    // Flush whatever debounced autosave the toggles scheduled, so the test
    // doesn't end with a pending Timer.
    await tester.pump(const Duration(seconds: 1));
  });
}
