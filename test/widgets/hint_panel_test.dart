import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/l10n/app_localizations.dart';
import 'package:mrsudoku/logic/hint_engine.dart';
import 'package:mrsudoku/models/settings.dart';
import 'package:mrsudoku/ui/hint_text.dart';
import 'package:mrsudoku/ui/widgets/hint_panel.dart';
import 'package:mrsudoku/ui/widgets/technique_guide.dart';

void main() {
  final pair = HintStep.elimination(
    pattern: EliminationPattern.nakedPair,
    removals: const [(0, 2, 4), (0, 3, 7)],
    evidenceCells: const [(0, 0), (0, 1)],
    evidenceDigits: const {4, 7},
    regionCells: const [(0, 0), (0, 1), (0, 2), (0, 3)],
  );
  const single = HintStep(row: 2, col: 4, value: 7, technique: SolvingTechnique.nakedSingle);
  final mistake = HintStep.fix(kind: HintKind.fixValue, row: 1, col: 1);

  Future<AppLocalizations> pumpPanel(
    WidgetTester tester, {
    required HintStep step,
    int stage = 2,
    HintStyle style = HintStyle.standard,
    bool whyExpanded = false,
    int hintsRemaining = 3,
    List<String>? log,
  }) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: HintPanel(
            step: step,
            stage: stage,
            style: style,
            whyExpanded: whyExpanded,
            hintsRemaining: hintsRemaining,
            onBack: () => log?.add('back'),
            onNext: () => log?.add('next'),
            onCancel: () => log?.add('cancel'),
            onApply: () => log?.add('apply'),
            onToggleWhy: () => log?.add('why'),
          ),
        ),
      ),
    ));
    return AppLocalizations.of(tester.element(find.byType(HintPanel)))!;
  }

  testWidgets('stage 1 is a bare nudge: no technique name, no back button', (tester) async {
    final l10n = await pumpPanel(tester, step: pair, stage: 1);

    expect(find.text(l10n.hintPanelTitle), findsOneWidget);
    expect(find.text(describeHintNudge(pair, l10n)), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-back')), findsNothing);
    expect(find.byKey(const ValueKey('hint-guide')), findsNothing);
    expect(find.text(l10n.hintMore), findsOneWidget);
    expect(find.text(l10n.hintStageLabel(1, 3)), findsOneWidget);
  });

  testWidgets('stage 2 names the technique, explains it and offers back, why and the guide', (tester) async {
    final l10n = await pumpPanel(tester, step: pair, stage: 2);

    expect(find.text(l10n.techniqueNakedPair), findsOneWidget);
    expect(find.text(describeHintExplanation(pair, l10n)), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-back')), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-why')), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-guide')), findsOneWidget);
    expect(find.text(l10n.hintShowAnswer), findsOneWidget);
  });

  testWidgets('the rule behind the technique is hidden until asked for in the standard style', (tester) async {
    final log = <String>[];
    final l10n = await pumpPanel(tester, step: pair, log: log);
    expect(find.byKey(const ValueKey('hint-why-text')), findsNothing);

    await tester.tap(find.text(l10n.hintWhy));
    expect(log, ['why']);

    await pumpPanel(tester, step: pair, whyExpanded: true);
    expect(find.byKey(const ValueKey('hint-why-text')), findsOneWidget);
    expect(find.text(guideBody(GuideTopic.nakedPair, l10n)), findsOneWidget);
  });

  testWidgets('the beginner style always shows the rule and has no why button', (tester) async {
    await pumpPanel(tester, step: pair, style: HintStyle.beginner);

    expect(find.byKey(const ValueKey('hint-why-text')), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-why')), findsNothing);
  });

  testWidgets('the minimal style names the technique without its explanation sentence', (tester) async {
    final l10n = await pumpPanel(tester, step: pair, style: HintStyle.minimal);

    expect(find.text(l10n.techniqueNakedPair), findsOneWidget);
    expect(find.text(describeHintExplanation(pair, l10n)), findsNothing);
  });

  testWidgets('a mistake hint keeps its sentence in the minimal style and has no guide', (tester) async {
    final l10n = await pumpPanel(tester, step: mistake, style: HintStyle.minimal);

    expect(find.text(l10n.hintExplainWrongValue), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-guide')), findsNothing);
    expect(find.byKey(const ValueKey('hint-why')), findsNothing);
  });

  testWidgets('the last stage offers the right apply label per kind', (tester) async {
    var l10n = await pumpPanel(tester, step: single, stage: 3);
    expect(find.text(l10n.hintPlace), findsOneWidget);

    l10n = await pumpPanel(tester, step: pair, stage: 3);
    expect(find.text(l10n.hintApplyEliminations), findsOneWidget);

    l10n = await pumpPanel(tester, step: mistake, stage: 3);
    expect(find.text(l10n.hintRemoveNumber), findsOneWidget);

    l10n = await pumpPanel(tester, step: HintStep.fix(kind: HintKind.fixNotes, row: 0, col: 0), stage: 3);
    expect(find.text(l10n.hintResetNotes), findsOneWidget);
  });

  testWidgets('with no hints left the answer can be read but not applied', (tester) async {
    final log = <String>[];
    final l10n = await pumpPanel(tester, step: single, stage: 3, hintsRemaining: 0, log: log);

    expect(find.text(l10n.hintNoHintsLeft), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('hint-next')), warnIfMissed: false);
    expect(log, isEmpty);
  });

  testWidgets('the direct reveal skips the stage controls', (tester) async {
    const reveal = HintStep(row: 0, col: 0, value: 9, technique: SolvingTechnique.backtracking);
    final l10n = await pumpPanel(tester, step: reveal, stage: 3);

    expect(find.text(l10n.hintDirectReveal), findsOneWidget);
    expect(find.byKey(const ValueKey('hint-back')), findsNothing);
    expect(find.text(l10n.hintStageLabel(3, 3)), findsNothing);
  });

  testWidgets('the buttons call their callbacks', (tester) async {
    final log = <String>[];
    final l10n = await pumpPanel(tester, step: pair, stage: 2, log: log);

    await tester.tap(find.text(l10n.hintBack));
    await tester.tap(find.text(l10n.hintCancel));
    await tester.tap(find.text(l10n.hintShowAnswer));

    expect(log, ['back', 'cancel', 'next']);
  });

  testWidgets('the info button opens the technique guide, which closes again', (tester) async {
    final l10n = await pumpPanel(tester, step: pair, stage: 2);

    await tester.tap(find.byKey(const ValueKey('hint-guide')));
    await tester.pumpAndSettle();

    expect(find.byType(TechniqueDiagram), findsOneWidget);
    expect(find.text(guideBody(GuideTopic.nakedPair, l10n)), findsOneWidget);
    expect(find.text(l10n.guideLegend), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('guide-close')));
    await tester.pumpAndSettle();
    expect(find.byType(TechniqueDiagram), findsNothing);
  });

  testWidgets('every guide topic draws its diagram without errors', (tester) async {
    for (final topic in GuideTopic.values) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: TechniqueDiagram(topic: topic)))));
      expect(tester.takeException(), isNull, reason: '$topic');
    }
  });
}
