import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/logic/hint_engine.dart';
import 'package:mrsudoku/models/board.dart';
import 'package:mrsudoku/models/settings.dart';
import 'package:mrsudoku/ui/widgets/sudoku_board_widget.dart';

/// Set of every cell (as "row-col") the board reports as peer-highlighted
/// for the given selection/focus-unit combination. Calls
/// [SudokuBoardWidget.isPeerHighlighted] directly rather than pumping a
/// widget tree - the highlight rule is plain logic over [Board], unrelated
/// to how the board happens to render its cells.
Set<String> _peerHighlightedCells({
  required int selectedRow,
  required int selectedCol,
  HintUnitType? hintFocusUnit,
}) {
  final widget = SudokuBoardWidget(
    board: Board.empty(),
    solution: null,
    selectedRow: selectedRow,
    selectedCol: selectedCol,
    highlightEnabled: true,
    highlightColor: HighlightColor.red,
    showErrors: false,
    hintFocusUnit: hintFocusUnit,
    onCellTap: (row, col) {},
  );

  // isPeerHighlighted alone doesn't exclude the selected cell (it trivially
  // shares every one of its own units with itself) - the board widget only
  // treats it as a peer highlight when combined with "not selected" at the
  // render site, so match that here too.
  final result = <String>{};
  for (var r = 0; r < kBoardSize; r++) {
    for (var c = 0; c < kBoardSize; c++) {
      if ((r, c) == (selectedRow, selectedCol)) continue;
      if (widget.isPeerHighlighted(r, c)) result.add('$r-$c');
    }
  }
  return result;
}

void main() {
  const row = 4, col = 4; // center cell, box (1, 1)

  test('with no hint focus, the full row+column+box is highlighted', () {
    final highlighted = _peerHighlightedCells(selectedRow: row, selectedCol: col);

    for (var c = 0; c < kBoardSize; c++) {
      if (c != col) expect(highlighted, contains('$row-$c'), reason: 'row peer $row-$c');
    }
    for (var r = 0; r < kBoardSize; r++) {
      if (r != row) expect(highlighted, contains('$r-$col'), reason: 'column peer $r-$col');
    }
    expect(highlighted, contains('3-3'));
    // A cell sharing none of row/column/box must not be highlighted.
    expect(highlighted, isNot(contains('0-0')));
  });

  test('a row hint focus highlights only the row', () {
    final highlighted = _peerHighlightedCells(
      selectedRow: row,
      selectedCol: col,
      hintFocusUnit: HintUnitType.row,
    );

    expect(highlighted, {for (var c = 0; c < kBoardSize; c++) if (c != col) '$row-$c'});
  });

  test('a column hint focus highlights only the column', () {
    final highlighted = _peerHighlightedCells(
      selectedRow: row,
      selectedCol: col,
      hintFocusUnit: HintUnitType.column,
    );

    expect(highlighted, {for (var r = 0; r < kBoardSize; r++) if (r != row) '$r-$col'});
  });

  test('a box hint focus highlights only the 3x3 box', () {
    final highlighted = _peerHighlightedCells(
      selectedRow: row,
      selectedCol: col,
      hintFocusUnit: HintUnitType.box,
    );

    final expected = <String>{
      for (var r = 3; r < 6; r++)
        for (var c = 3; c < 6; c++)
          if (r != row || c != col) '$r-$c',
    };
    expect(highlighted, expected);
  });

  group('hint overlay', () {
    // A naked pair in row 0: (0,0) and (0,1) both only {1, 2}, so 1 and 2
    // can be crossed out of (0,2) - which has no notes of its own, so the
    // struck-through digits are painted from the step alone.
    final step = HintStep.elimination(
      pattern: EliminationPattern.nakedPair,
      removals: const [(0, 2, 1), (0, 2, 2)],
      evidenceCells: const [(0, 0), (0, 1)],
      evidenceDigits: const {1, 2},
      regionCells: [for (var c = 0; c < 9; c++) (0, c)],
    );

    for (final stage in [1, 2, 3]) {
      testWidgets('renders an elimination step at stage $stage without errors', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 360,
              child: SudokuBoardWidget(
                board: Board.empty(),
                solution: null,
                selectedRow: null,
                selectedCol: null,
                highlightEnabled: true,
                highlightColor: HighlightColor.red,
                showErrors: false,
                hintStep: step,
                hintStage: stage,
                onCellTap: (row, col) {},
              ),
            ),
          ),
        ));

        expect(tester.takeException(), isNull);
        expect(find.byType(SudokuBoardWidget), findsOneWidget);
      });
    }

    testWidgets('renders a fish with base and cover lines at stage 2', (tester) async {
      final fish = HintStep.elimination(
        pattern: EliminationPattern.xWing,
        removals: const [(1, 0, 3)],
        evidenceCells: const [(0, 0), (0, 3), (3, 0), (3, 3)],
        evidenceDigits: const {3},
        regionCells: const [(0, 0), (0, 3), (3, 0), (3, 3)],
        lines: const [
          HintLine((0, 0), (0, 8), HintLineRole.base),
          HintLine((3, 0), (3, 8), HintLineRole.base),
          HintLine((0, 0), (8, 0), HintLineRole.cover),
          HintLine((0, 3), (8, 3), HintLineRole.cover),
        ],
      );
      final wing = HintStep.elimination(
        pattern: EliminationPattern.xyWing,
        removals: const [(3, 3, 3)],
        evidenceCells: const [(0, 0), (0, 3), (3, 0)],
        evidenceDigits: const {1, 2, 3},
        regionCells: const [(0, 0)],
        lines: const [
          HintLine((0, 0), (0, 3), HintLineRole.link),
          HintLine((0, 0), (3, 0), HintLineRole.link),
          HintLine((0, 3), (3, 3), HintLineRole.rule),
          HintLine((3, 0), (3, 3), HintLineRole.rule),
        ],
      );

      for (final step in [fish, wing]) {
        for (final stage in [1, 2, 3]) {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 360,
                height: 360,
                child: SudokuBoardWidget(
                  board: Board.empty(),
                  solution: null,
                  selectedRow: null,
                  selectedCol: null,
                  highlightEnabled: true,
                  highlightColor: HighlightColor.red,
                  showErrors: false,
                  hintStep: step,
                  hintStage: stage,
                  onCellTap: (row, col) {},
                ),
              ),
            ),
          ));
          expect(tester.takeException(), isNull, reason: '${step.pattern} stage $stage');
        }
      }
    });
  });
}
