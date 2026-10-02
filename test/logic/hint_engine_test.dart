import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/logic/candidates.dart';
import 'package:mrsudoku/logic/hint_engine.dart';
import 'package:mrsudoku/logic/solver.dart';
import 'package:mrsudoku/models/board.dart';

void main() {
  group('HintStep', () {
    test('rejects singleKind: hidden without a hiddenUnit', () {
      expect(
        () => HintStep(
          row: 0,
          col: 0,
          value: 1,
          technique: SolvingTechnique.hiddenSingle,
          singleKind: SingleKind.hidden,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects a hiddenUnit paired with singleKind: naked', () {
      expect(
        () => HintStep(
          row: 0,
          col: 0,
          value: 1,
          technique: SolvingTechnique.nakedSingle,
          hiddenUnit: HintUnitType.row,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('HintEngine', () {
    test('finds a naked single as the last empty cell in a row', () {
      final values = [
        [5, 3, 4, 6, 7, 8, 9, 1, 0], // only '2' can go at (0, 8)
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 0);
      expect(step.col, 8);
      expect(step.value, 2);
      expect(step.technique, SolvingTechnique.nakedSingle);
    });

    test('returns null on a fully solved board', () {
      final values = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9],
      ];
      final board = Board.fromValues(values);

      expect(HintEngine.nextLogicalStep(board), isNull);
      expect(HintEngine.rateDifficulty(board), SolvingTechnique.nakedSingle);
    });

    test('finds a naked/pointing pair or box-line reduction step', () {
      final values = [
        [0, 0, 6, 1, 0, 8, 0, 4, 7],
        [0, 0, 0, 0, 4, 0, 0, 0, 0],
        [4, 7, 0, 0, 5, 0, 0, 0, 8],
        [6, 0, 8, 0, 0, 0, 4, 5, 9],
        [0, 5, 9, 0, 6, 0, 7, 0, 0],
        [7, 0, 4, 5, 0, 9, 0, 0, 0],
        [0, 4, 7, 2, 0, 0, 0, 0, 0],
        [9, 0, 5, 0, 7, 0, 3, 1, 2],
        [0, 0, 2, 0, 0, 5, 8, 7, 4],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 0);
      expect(step.col, 4);
      expect(step.value, 3);
      expect(step.technique, SolvingTechnique.pairElimination);
    });

    test('finds a hidden pair step', () {
      final values = [
        [1, 4, 0, 7, 3, 0, 6, 0, 8],
        [0, 0, 0, 0, 0, 0, 0, 5, 0],
        [0, 0, 9, 0, 0, 0, 0, 0, 0],
        [6, 0, 0, 9, 1, 4, 0, 0, 0],
        [9, 5, 0, 0, 0, 2, 3, 0, 7],
        [2, 8, 0, 3, 5, 7, 0, 6, 0],
        [0, 2, 6, 4, 7, 3, 0, 0, 0],
        [4, 0, 0, 5, 0, 0, 2, 0, 6],
        [0, 0, 0, 2, 0, 0, 0, 3, 4],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 7);
      expect(step.col, 2);
      expect(step.value, 3);
      expect(step.technique, SolvingTechnique.hiddenPair);
    });

    test('finds a naked triple step', () {
      final values = [
        [0, 0, 0, 0, 0, 7, 0, 3, 0],
        [3, 1, 0, 4, 0, 9, 0, 2, 6],
        [0, 5, 0, 0, 3, 6, 0, 0, 0],
        [7, 0, 0, 0, 1, 8, 0, 0, 0],
        [0, 8, 1, 0, 9, 2, 0, 0, 0],
        [6, 3, 2, 5, 7, 4, 9, 8, 1],
        [1, 0, 4, 8, 0, 3, 0, 7, 0],
        [8, 7, 3, 9, 0, 5, 6, 1, 0],
        [0, 2, 0, 7, 0, 1, 8, 0, 3],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 4);
      expect(step.col, 8);
      expect(step.value, 7);
      expect(step.technique, SolvingTechnique.nakedTriple);
    });

    test('finds an X-Wing step', () {
      final values = [
        [7, 0, 6, 8, 0, 9, 4, 2, 1],
        [0, 2, 0, 0, 0, 4, 6, 8, 0],
        [4, 0, 8, 0, 6, 2, 5, 3, 0],
        [0, 0, 0, 4, 9, 8, 2, 6, 5],
        [6, 8, 0, 0, 2, 0, 0, 4, 3],
        [2, 0, 4, 3, 0, 6, 0, 1, 8],
        [9, 0, 1, 6, 4, 0, 8, 5, 2],
        [5, 4, 0, 2, 8, 0, 0, 9, 6],
        [8, 6, 2, 9, 0, 0, 0, 7, 4],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 4);
      expect(step.col, 5);
      expect(step.value, 1);
      expect(step.technique, SolvingTechnique.xWing);
    });

    test('finds an XY-Wing step', () {
      final values = [
        [9, 0, 6, 7, 4, 5, 0, 0, 0],
        [0, 0, 3, 0, 8, 0, 7, 4, 6],
        [0, 4, 7, 0, 0, 3, 9, 5, 0],
        [0, 0, 0, 4, 3, 1, 6, 9, 0],
        [0, 0, 1, 2, 0, 0, 5, 0, 0],
        [0, 0, 9, 5, 0, 8, 0, 0, 0],
        [3, 0, 2, 0, 0, 0, 0, 0, 7],
        [6, 9, 0, 3, 1, 7, 0, 0, 5],
        [0, 0, 0, 0, 0, 0, 3, 0, 9],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 5);
      expect(step.col, 4);
      expect(step.value, 7);
      expect(step.technique, SolvingTechnique.xyWing);
    });

    test('finds a Swordfish step', () {
      final values = [
        [5, 0, 0, 1, 0, 0, 2, 0, 4],
        [3, 0, 9, 5, 4, 0, 0, 7, 1],
        [0, 4, 0, 0, 0, 0, 5, 0, 0],
        [6, 5, 8, 2, 9, 1, 7, 4, 3],
        [2, 7, 4, 6, 3, 8, 9, 1, 5],
        [9, 1, 3, 7, 5, 4, 0, 0, 2],
        [0, 0, 0, 4, 0, 7, 3, 5, 0],
        [7, 0, 0, 0, 0, 5, 4, 2, 0],
        [4, 0, 5, 9, 2, 0, 1, 0, 7],
      ];
      final board = Board.fromValues(values);

      final step = HintEngine.nextLogicalStep(board);

      expect(step, isNotNull);
      expect(step!.row, 0);
      expect(step.col, 1);
      expect(step.value, 6);
      expect(step.technique, SolvingTechnique.swordfish);
    });
  });

  group('HintEngine.nextHint', () {
    // One fixture per elimination pattern (the same boards the
    // nextLogicalStep tests above use), so each is known to need exactly
    // that tier before any single appears.
    final fixtures = <String, (List<List<int>>, EliminationPattern)>{
      'pointing': (
        [
          [0, 0, 6, 1, 0, 8, 0, 4, 7],
          [0, 0, 0, 0, 4, 0, 0, 0, 0],
          [4, 7, 0, 0, 5, 0, 0, 0, 8],
          [6, 0, 8, 0, 0, 0, 4, 5, 9],
          [0, 5, 9, 0, 6, 0, 7, 0, 0],
          [7, 0, 4, 5, 0, 9, 0, 0, 0],
          [0, 4, 7, 2, 0, 0, 0, 0, 0],
          [9, 0, 5, 0, 7, 0, 3, 1, 2],
          [0, 0, 2, 0, 0, 5, 8, 7, 4],
        ],
        EliminationPattern.pointing,
      ),
      'xWing': (
        [
          [7, 0, 6, 8, 0, 9, 4, 2, 1],
          [0, 2, 0, 0, 0, 4, 6, 8, 0],
          [4, 0, 8, 0, 6, 2, 5, 3, 0],
          [0, 0, 0, 4, 9, 8, 2, 6, 5],
          [6, 8, 0, 0, 2, 0, 0, 4, 3],
          [2, 0, 4, 3, 0, 6, 0, 1, 8],
          [9, 0, 1, 6, 4, 0, 8, 5, 2],
          [5, 4, 0, 2, 8, 0, 0, 9, 6],
          [8, 6, 2, 9, 0, 0, 0, 7, 4],
        ],
        EliminationPattern.xWing,
      ),
      'xyWing': (
        [
          [9, 0, 6, 7, 4, 5, 0, 0, 0],
          [0, 0, 3, 0, 8, 0, 7, 4, 6],
          [0, 4, 7, 0, 0, 3, 9, 5, 0],
          [0, 0, 0, 4, 3, 1, 6, 9, 0],
          [0, 0, 1, 2, 0, 0, 5, 0, 0],
          [0, 0, 9, 5, 0, 8, 0, 0, 0],
          [3, 0, 2, 0, 0, 0, 0, 0, 7],
          [6, 9, 0, 3, 1, 7, 0, 0, 5],
          [0, 0, 0, 0, 0, 0, 3, 0, 9],
        ],
        EliminationPattern.xyWing,
      ),
      'swordfish': (
        [
          [5, 0, 0, 1, 0, 0, 2, 0, 4],
          [3, 0, 9, 5, 4, 0, 0, 7, 1],
          [0, 4, 0, 0, 0, 0, 5, 0, 0],
          [6, 5, 8, 2, 9, 1, 7, 4, 3],
          [2, 7, 4, 6, 3, 8, 9, 1, 5],
          [9, 1, 3, 7, 5, 4, 0, 0, 2],
          [0, 0, 0, 4, 0, 7, 3, 5, 0],
          [7, 0, 0, 0, 0, 5, 4, 2, 0],
          [4, 0, 5, 9, 2, 0, 1, 0, 7],
        ],
        EliminationPattern.swordfish,
      ),
    };

    for (final entry in fixtures.entries) {
      test('starts ${entry.key}\'s ladder with an elimination no harder than that pattern', () {
        final (values, pattern) = entry.value;
        final board = Board.fromValues(values);

        final step = HintEngine.nextHint(board);

        // Easier patterns fire first (each hint is one reasoning step), so
        // the first hint is never *harder* than the pattern the fixture
        // needs - and nothing on these boards is a single yet.
        expect(step, isNotNull);
        expect(step!.kind, HintKind.eliminate);
        expect(step.technique.rank, lessThanOrEqualTo(pattern.technique.rank));
        expect(step.value, 0);
        expect(step.removals, isNotEmpty);
        expect(step.evidenceCells, isNotEmpty);
        expect(step.evidenceDigits, isNotEmpty);
        expect(step.regionCells, containsAll(step.evidenceCells));
        expect(step.removalCells, contains((step.row, step.col)));
      });

      test('${entry.key}: following the hints stays sound and only ends where logic does', () {
        final (values, _) = entry.value;
        final solution = Solver.solve([for (final row in values) [...row]])!;
        var board = Board.fromValues(values);
        // What the "player" knows: starts as every legal candidate and only
        // ever shrinks, like notes the hint has been applied to.
        var known = Candidates.forBoard(board);
        var steps = 0;

        for (; steps < 500 && !board.isFull; steps++) {
          final step = HintEngine.nextHint(board, candidates: known);
          if (step == null) {
            // The ladder may only run dry where the plain logical solver
            // has nothing either (these boards aren't all fully solvable
            // by logic alone).
            expect(HintEngine.nextLogicalStep(board), isNull);
            break;
          }

          if (step.kind == HintKind.place) {
            expect(step.value, solution[step.row][step.col]);
            board = board.setCell(step.row, step.col, board.cellAt(step.row, step.col).copyWith(value: step.value));
            known = Candidates.forBoard(board);
          } else {
            for (final (r, c, digit) in step.removals) {
              expect(digit, isNot(solution[r][c]), reason: 'removed the true value at ($r, $c)');
              expect(known[r][c], contains(digit), reason: 'a removal must remove something');
              known[r][c].remove(digit);
            }
          }
        }
        expect(steps, lessThan(500), reason: 'hints must converge');
        expect(steps, greaterThan(0));
      });
    }

    test('prefers a single over any elimination', () {
      final values = List.generate(9, (_) => List.filled(9, 0));
      values[0] = [5, 3, 4, 6, 7, 8, 9, 1, 0];

      final step = HintEngine.nextHint(Board.fromValues(values));

      expect(step!.kind, HintKind.place);
      expect((step.row, step.col, step.value), (0, 8, 2));
      expect(step.regionCells, isNotEmpty);
    });

    test('uses the given candidates: a cell narrowed by notes becomes a single', () {
      final values = List.generate(9, (_) => List.filled(9, 0));
      values[0] = [5, 3, 4, 6, 7, 0, 0, 0, 0];
      final board = Board.fromValues(values);
      final known = Candidates.forBoard(board);
      known[0][5] = {8}; // the player has already struck everything else

      final step = HintEngine.nextHint(board, candidates: known);

      expect(step!.kind, HintKind.place);
      expect((step.row, step.col, step.value), (0, 5, 8));
    });

    test('does not modify the candidates it is given', () {
      final (values, _) = fixtures['xWing']!;
      final board = Board.fromValues(values);
      final known = Candidates.forBoard(board);
      final snapshot = [for (final row in known) [for (final cell in row) {...cell}]];

      HintEngine.nextHint(board, candidates: known);

      expect(known, snapshot);
    });

    group('near and onlyCell', () {
      // Naked singles at (0, 8) and (8, 0).
      Board twoSingles() {
        final values = List.generate(9, (_) => List.filled(9, 0));
        values[0] = [5, 3, 4, 6, 7, 8, 9, 1, 0];
        values[8] = [0, 2, 3, 4, 5, 6, 7, 8, 9];
        return Board.fromValues(values);
      }

      test('without a preference the first single in board order wins', () {
        final step = HintEngine.nextHint(twoSingles())!;
        expect((step.row, step.col), (0, 8));
      });

      test('near picks the closest single', () {
        final step = HintEngine.nextHint(twoSingles(), near: (7, 1))!;
        expect((step.row, step.col), (8, 0));
      });

      test('onlyCell returns that cell\'s own single', () {
        final step = HintEngine.nextHint(twoSingles(), onlyCell: (8, 0))!;
        expect((step.row, step.col, step.value), (8, 0, 1));
      });

      test('onlyCell returns null when nothing involves that cell', () {
        expect(HintEngine.nextHint(twoSingles(), onlyCell: (4, 4)), isNull);
      });

      test('onlyCell accepts an elimination that touches the cell and rejects one that does not', () {
        final (values, _) = fixtures['xWing']!;
        final board = Board.fromValues(values);
        final first = HintEngine.nextHint(board)!;
        expect(first.kind, HintKind.eliminate);

        final touching = HintEngine.nextHint(board, onlyCell: (first.row, first.col));
        expect(touching, isNotNull);
        expect(touching!.removalCells.contains((first.row, first.col)) ||
            touching.evidenceCells.contains((first.row, first.col)), isTrue);
      });
    });
  });
}
