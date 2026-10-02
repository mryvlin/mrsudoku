import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/l10n/app_localizations.dart';
import 'package:mrsudoku/logic/hint_engine.dart';
import 'package:mrsudoku/ui/hint_text.dart';

void main() {
  final de = lookupAppLocalizations(const Locale('de'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('a naked single is described with its row/column/value, in each locale', () {
    const step = HintStep(row: 2, col: 4, value: 7, technique: SolvingTechnique.nakedSingle);

    expect(describeHint(step, de), 'Naked Single: Zeile 3, Spalte 5 hat nur einen möglichen Kandidaten: 7.');
    expect(describeHint(step, en), 'Naked Single: Row 3, column 5 has only one possible candidate: 7.');
  });

  test('a hidden single names the unit that forced it: row', () {
    const step = HintStep(
      row: 0,
      col: 8,
      value: 2,
      technique: SolvingTechnique.hiddenSingle,
      singleKind: SingleKind.hidden,
      hiddenUnit: HintUnitType.row,
    );

    expect(describeHint(step, de), contains('In Zeile 1 kann die 2 nur noch in Zeile 1, Spalte 9 stehen.'));
  });

  test('a hidden single names the unit that forced it: column', () {
    const step = HintStep(
      row: 3,
      col: 1,
      value: 9,
      technique: SolvingTechnique.hiddenSingle,
      singleKind: SingleKind.hidden,
      hiddenUnit: HintUnitType.column,
    );

    expect(describeHint(step, de), contains('In Spalte 2 kann die 9 nur noch in Zeile 4, Spalte 2 stehen.'));
  });

  test('a hidden single names the unit that forced it: box', () {
    const step = HintStep(
      row: 4,
      col: 4,
      value: 5,
      technique: SolvingTechnique.hiddenSingle,
      singleKind: SingleKind.hidden,
      hiddenUnit: HintUnitType.box,
    );

    // Box index is derived from (row, col): (4~/3)*3 + (4~/3) + 1 = 5.
    expect(describeHint(step, de), contains('In Box 5 kann die 5 nur noch in Zeile 5, Spalte 5 stehen.'));
  });

  test('an elimination tier prepends its lead-in before the base explanation', () {
    const step = HintStep(row: 0, col: 0, value: 1, technique: SolvingTechnique.pairElimination);

    final message = describeHint(step, de);
    expect(message, startsWith('Kandidaten-Ausschluss'));
    expect(message, contains('Nach Ausschluss durch ein Paar-Muster'));
    expect(message, contains('Zeile 1, Spalte 1 hat nur einen möglichen Kandidaten: 1.'));
  });

  test('an XY-Wing step prepends its lead-in before the base explanation', () {
    const step = HintStep(row: 0, col: 0, value: 1, technique: SolvingTechnique.xyWing);

    final message = describeHint(step, de);
    expect(message, startsWith('XY-Wing'));
    expect(message, contains('Nach Ausschluss durch ein XY-Wing-Muster'));
    expect(message, contains('Zeile 1, Spalte 1 hat nur einen möglichen Kandidaten: 1.'));
  });

  test('a Swordfish step prepends its lead-in before the base explanation', () {
    const step = HintStep(row: 0, col: 0, value: 1, technique: SolvingTechnique.swordfish);

    final message = describeHint(step, de);
    expect(message, startsWith('Swordfish'));
    expect(message, contains('Nach Ausschluss durch ein Swordfish-Muster'));
    expect(message, contains('Zeile 1, Spalte 1 hat nur einen möglichen Kandidaten: 1.'));
  });

  test('the backtracking fallback ignores row/col/value and just reveals directly', () {
    const step = HintStep(row: 0, col: 0, value: 9, technique: SolvingTechnique.backtracking);

    expect(describeHint(step, de), de.hintDirectReveal);
    expect(describeHint(step, en), en.hintDirectReveal);
  });

  group('tiered hint text', () {
    final pair = HintStep.elimination(
      pattern: EliminationPattern.nakedPair,
      removals: const [(0, 2, 4), (0, 3, 7)],
      evidenceCells: const [(0, 0), (0, 1)],
      evidenceDigits: const {4, 7},
      regionCells: const [(0, 0), (0, 1), (0, 2), (0, 3)],
    );

    test('the nudge says what kind of step is nearby without naming cell or digit', () {
      const place = HintStep(row: 2, col: 4, value: 7, technique: SolvingTechnique.nakedSingle);

      expect(describeHintNudge(place, en), en.hintNudgePlace);
      expect(describeHintNudge(pair, en), en.hintNudgeEliminate);
      expect(describeHintNudge(place, en), isNot(contains('7')));
    });

    test('a single\'s explanation names the technique but not the digit', () {
      const naked = HintStep(row: 2, col: 4, value: 7, technique: SolvingTechnique.nakedSingle);
      const hidden = HintStep(
        row: 0,
        col: 8,
        value: 2,
        technique: SolvingTechnique.hiddenSingle,
        singleKind: SingleKind.hidden,
        hiddenUnit: HintUnitType.row,
      );

      expect(describeHintExplanation(naked, en), startsWith('Naked Single'));
      expect(describeHintExplanation(naked, en), isNot(contains('7')));
      expect(describeHintExplanation(hidden, en), contains('row 1'));
      expect(describeHintExplanation(hidden, en), isNot(contains('2')));
    });

    test('an elimination explanation names the pattern and its digits, in each locale', () {
      expect(describeHintExplanation(pair, en), allOf(startsWith('Naked Pair'), contains('4, 7')));
      expect(describeHintExplanation(pair, de), allOf(startsWith('Naked Pair'), contains('4, 7')));
    });

    test('every elimination pattern has an explanation in both locales', () {
      for (final pattern in EliminationPattern.values) {
        final step = HintStep.elimination(
          pattern: pattern,
          removals: const [(0, 0, 5)],
          evidenceCells: const [(0, 1)],
          evidenceDigits: const {5},
          regionCells: const [(0, 0), (0, 1)],
        );
        expect(describeHintExplanation(step, en), isNotEmpty);
        expect(describeHintExplanation(step, de), isNotEmpty);
      }
    });

    test('the answer of an elimination counts the cells that lose a candidate', () {
      final one = HintStep.elimination(
        pattern: EliminationPattern.nakedPair,
        removals: const [(0, 2, 4), (0, 2, 7)],
        evidenceCells: const [(0, 0), (0, 1)],
        evidenceDigits: const {4, 7},
        regionCells: const [(0, 0)],
      );

      expect(describeHint(one, en), contains('marked cell.'));
      expect(describeHint(pair, en), contains('2 marked cells'));
      expect(describeHint(pair, de), contains('2 markierten Zellen'));
    });
  });

  group('mistake hints and guide topics', () {
    final wrongValue = HintStep.fix(kind: HintKind.fixValue, row: 1, col: 1);
    final wrongNotes = HintStep.fix(kind: HintKind.fixNotes, row: 1, col: 1);

    test('mistake hints have their own text at every stage', () {
      for (final l10n in [en, de]) {
        expect(describeHintNudge(wrongValue, l10n), l10n.hintNudgeFix);
        expect(describeHintExplanation(wrongValue, l10n), l10n.hintExplainWrongValue);
        expect(describeHint(wrongValue, l10n), l10n.hintAnswerWrongValue);
        expect(describeHintExplanation(wrongNotes, l10n), l10n.hintExplainWrongNotes);
        expect(describeHint(wrongNotes, l10n), l10n.hintAnswerWrongNotes);
        expect(describeHintTitle(wrongValue, l10n), l10n.hintTitleMistake);
        expect(describeHintTitle(wrongNotes, l10n), l10n.hintTitleNotes);
      }
    });

    test('mistake hints and the direct reveal have no guide topic', () {
      expect(guideTopicOf(wrongValue), isNull);
      expect(guideTopicOf(wrongNotes), isNull);
      expect(
        guideTopicOf(const HintStep(row: 0, col: 0, value: 1, technique: SolvingTechnique.backtracking)),
        isNull,
      );
    });

    test('every topic has a title and a body in both locales', () {
      for (final topic in GuideTopic.values) {
        for (final l10n in [en, de]) {
          expect(guideTitle(topic, l10n), isNotEmpty);
          expect(guideBody(topic, l10n).length, greaterThan(40));
        }
      }
    });

    test('topics follow the pattern, telling pairs from pointing pairs', () {
      HintStep elimination(EliminationPattern pattern) => HintStep.elimination(
            pattern: pattern,
            removals: const [(0, 0, 1)],
            evidenceCells: const [(0, 1)],
            evidenceDigits: const {1},
            regionCells: const [(0, 0)],
          );

      expect(guideTopicOf(elimination(EliminationPattern.nakedPair)), GuideTopic.nakedPair);
      expect(guideTopicOf(elimination(EliminationPattern.pointing)), GuideTopic.pointing);
      expect(guideTopicOf(elimination(EliminationPattern.swordfish)), GuideTopic.swordfish);
      expect(
        guideTopicOf(const HintStep(row: 0, col: 0, value: 1, technique: SolvingTechnique.nakedSingle)),
        GuideTopic.nakedSingle,
      );
    });
  });
}
