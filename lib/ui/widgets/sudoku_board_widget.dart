import 'package:flutter/material.dart';

import '../../logic/hint_engine.dart';
import '../../models/board.dart';
import '../../models/puzzle_shape.dart';
import '../../models/settings.dart';
import '../highlight_colors.dart';
import 'hint_lines.dart';

/// Renders [board]'s full grid - a plain 9x9 for the classic layout, or a
/// Samurai board's 21x21 bounding shape with its blank corner gaps - as a
/// single [CustomPaint], with tap position converted to a (row, col) by
/// dividing by the cell size rather than relying on one Flutter widget per
/// cell for hit-testing.
///
/// Stays square (or whatever aspect [PuzzleShape.height]/`width` implies -
/// 1:1 for both current shapes) and centered via [AspectRatio] so it scales
/// cleanly from a narrow phone in portrait mode up to a wide desktop
/// browser window.
class SudokuBoardWidget extends StatelessWidget {
  final Board board;
  final Board? solution;
  final int? selectedRow;
  final int? selectedCol;
  final bool highlightEnabled;
  final HighlightColor highlightColor;
  final bool showErrors;
  final void Function(int row, int col) onCellTap;

  /// When the last hint was a hidden single, the specific unit kind (row,
  /// column or box) whose analysis forced it - narrows peer highlighting
  /// down to just that unit instead of every unit the selected cell
  /// belongs to, so the player sees exactly which constraint did the work.
  /// `null` for every other technique, where every unit matters.
  final HintUnitType? hintFocusUnit;

  /// The hint being walked through, if any, and which stage of it is
  /// showing (1 = nudge, 2 = explanation, 3 = answer). Stage 1 only tints
  /// the step's region; from stage 2 on the cells forming the pattern are
  /// marked too, and candidates the step would cross out are drawn struck
  /// through (and their cells tinted) so the player can see what it does.
  final HintStep? hintStep;
  final int hintStage;

  /// Soft amber used for hint tints - deliberately not the player's chosen
  /// highlight color, so a hint never reads as a selection.
  static const hintColor = hintAmber;

  const SudokuBoardWidget({
    super.key,
    required this.board,
    required this.solution,
    required this.selectedRow,
    required this.selectedCol,
    required this.highlightEnabled,
    required this.highlightColor,
    required this.showErrors,
    required this.onCellTap,
    this.hintFocusUnit,
    this.hintStep,
    this.hintStage = 1,
  });

  bool get _hasSelection => selectedRow != null && selectedCol != null;

  static bool _matchesFocus(UnitKind kind, HintUnitType focus) => switch (focus) {
        HintUnitType.row => kind == UnitKind.row,
        HintUnitType.column => kind == UnitKind.column,
        HintUnitType.box => kind == UnitKind.box,
      };

  /// A peer is any cell sharing at least one of the selected cell's units -
  /// on a classic board that's exactly "same row, column or box"; at a
  /// Samurai shared-box cell the selected cell has extra row/column units
  /// (one set per grid it belongs to), so its peers correctly span both
  /// grids without any special-casing here.
  ///
  /// Public (rather than the usual private helper) so tests can check the
  /// highlight logic directly against a plain [SudokuBoardWidget] instance,
  /// without needing to pump a widget tree and dig through however the
  /// board happens to render it.
  bool isPeerHighlighted(int row, int col) {
    if (!_hasSelection) return false;
    final selectedUnits = board.unitsContaining(selectedRow!, selectedCol!);
    final focus = hintFocusUnit;
    final relevantUnits =
        focus == null ? selectedUnits : selectedUnits.where((u) => _matchesFocus(u.kind, focus));
    return relevantUnits.any((u) => u.cells.contains((row, col)));
  }

  /// A thick line belongs at global coordinate [c] (a row or column index)
  /// whenever it's a multiple of the box size - true for every real box
  /// boundary AND every constituent grid's outer edge in any of these
  /// layouts, since two 9x9 grids can only share exactly one box (what
  /// makes Samurai/Twin/Gattai-8/Sohei recognizable as that pattern at all)
  /// by sitting a multiple of `kBoxSize` apart - so every grid's origin,
  /// and therefore every one of its box boundaries and edges, always lands
  /// on a global multiple of `kBoxSize`. Using that directly - instead of
  /// asking whether two specific cells share a box - guarantees every
  /// vertical line lines up with every other vertical line at the same
  /// column across the whole shape, and likewise for rows, rather than
  /// relying on that falling out of the box-sharing check by coincidence.
  static bool _isBoxBoundary(int c) => c % kBoxSize == 0;

  Map<(int, int), _CellVisual> _buildVisuals(ThemeData theme, Color resolvedHighlight) {
    final shape = board.shape;
    final selectedValue = _hasSelection ? board.cellAt(selectedRow!, selectedCol!).value : 0;
    final highlightedValue = highlightEnabled ? selectedValue : 0;
    final visuals = <(int, int), _CellVisual>{};

    final hint = hintStep;
    final hintRegion = hint == null ? const <(int, int)>{} : hint.regionCells.toSet();
    final showDetail = hint != null && hintStage >= 2;
    final hintEvidence = showDetail ? hint.evidenceCells.toSet() : const <(int, int)>{};
    final hintStrikes = <(int, int), Set<int>>{
      if (showDetail)
        for (final (r, c, _) in hint.removals) (r, c): {},
    };
    if (showDetail) {
      for (final (r, c, digit) in hint.removals) {
        hintStrikes[(r, c)]!.add(digit);
      }
    }

    for (final (row, col) in shape.activeCells) {
      final cell = board.cellAt(row, col);
      final isSelected = _hasSelection && row == selectedRow && col == selectedCol;
      final isPeer = highlightEnabled && !isSelected && isPeerHighlighted(row, col);
      final isSameValue =
          highlightEnabled && !isSelected && selectedValue != 0 && cell.value == selectedValue;
      final hasMatchingNote =
          highlightedValue != 0 && cell.isEmpty && cell.notes.contains(highlightedValue);
      final isError = showErrors &&
          solution != null &&
          !cell.isEmpty &&
          cell.value != solution!.cellAt(row, col).value;
      final isHighlightedValue = isSelected || isSameValue;

      final background = isSelected
          ? resolvedHighlight.withValues(alpha: 0.35)
          : isSameValue
              ? resolvedHighlight.withValues(alpha: 0.20)
              : hasMatchingNote
                  ? resolvedHighlight.withValues(alpha: 0.12)
                  : isPeer
                      ? resolvedHighlight.withValues(alpha: 0.08)
                      : theme.colorScheme.surface;

      var tintedBackground = background;
      if (hintRegion.contains((row, col))) {
        tintedBackground = Color.alphaBlend(
          hintColor.withValues(alpha: hintStage == 1 ? 0.22 : 0.12),
          tintedBackground,
        );
      }
      if (hintStrikes.containsKey((row, col))) {
        tintedBackground = Color.alphaBlend(theme.colorScheme.error.withValues(alpha: 0.16), tintedBackground);
      }
      if (hintEvidence.contains((row, col))) {
        tintedBackground = Color.alphaBlend(hintColor.withValues(alpha: 0.55), tintedBackground);
      }

      final valueColor = cell.isEmpty
          ? null
          : isError
              ? theme.colorScheme.error
              : isHighlightedValue
                  ? resolvedHighlight
                  : cell.isGiven
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.primary;

      visuals[(row, col)] = _CellVisual(
        value: cell.value,
        notes: cell.notes,
        background: tintedBackground,
        strikeDigits: hintStrikes[(row, col)] ?? const <int>{},
        valueColor: valueColor,
        valueWeight: isHighlightedValue
            ? FontWeight.w800
            : (cell.isGiven ? FontWeight.w700 : FontWeight.w500),
        // The outline of the playable area is thick on every side: an edge
        // with no active neighbor (including the board's own edge) is an
        // outer edge. Interior box boundaries are drawn by the cell on
        // their right/bottom side only.
        isThickLeft: !shape.activeCells.contains((row, col - 1)),
        isThickTop: !shape.activeCells.contains((row - 1, col)),
        isThickRight: !shape.activeCells.contains((row, col + 1)) ||
            (col + 1 < shape.width && _isBoxBoundary(col + 1)),
        isThickBottom: !shape.activeCells.contains((row + 1, col)) ||
            (row + 1 < shape.height && _isBoxBoundary(row + 1)),
      );
    }
    return visuals;
  }

  @override
  Widget build(BuildContext context) {
    final shape = board.shape;
    final theme = Theme.of(context);
    final resolvedHighlight = highlightColor.resolve(theme.brightness);
    final visuals = _buildVisuals(theme, resolvedHighlight);
    final highlightedValue =
        highlightEnabled && _hasSelection ? board.cellAt(selectedRow!, selectedCol!).value : 0;

    return AspectRatio(
      aspectRatio: shape.width / shape.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / shape.width;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final col = (details.localPosition.dx / cellSize).floor();
              final row = (details.localPosition.dy / cellSize).floor();
              if (shape.activeCells.contains((row, col))) onCellTap(row, col);
            },
            child: CustomPaint(
              size: constraints.biggest,
              painter: _BoardPainter(
                visuals: visuals,
                cellSize: cellSize,
                thinBorderColor: theme.colorScheme.outlineVariant,
                thickBorderColor: theme.colorScheme.outline,
                valueStyle: theme.textTheme.headlineSmall ?? const TextStyle(),
                noteStyle: theme.textTheme.labelSmall ?? const TextStyle(),
                noteColor: theme.colorScheme.onSurfaceVariant,
                strikeColor: theme.colorScheme.error,
                hintLines: hintStep != null && hintStage >= 2 ? hintStep!.lines : const [],
                highlightColor: resolvedHighlight,
                highlightedValue: highlightedValue,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Everything a cell needs to be painted, precomputed once per build so
/// [_BoardPainter.paint] is pure geometry/canvas calls with no theme or
/// highlight-rule logic of its own.
class _CellVisual {
  final int value;
  final Set<int> notes;
  final Color background;

  /// Candidates a hint would cross out of this cell - drawn struck through
  /// in the note grid, whether or not the player had noted them.
  final Set<int> strikeDigits;
  final Color? valueColor;
  final FontWeight valueWeight;
  final bool isThickLeft;
  final bool isThickTop;
  final bool isThickRight;
  final bool isThickBottom;

  const _CellVisual({
    required this.value,
    required this.notes,
    required this.background,
    required this.strikeDigits,
    required this.valueColor,
    required this.valueWeight,
    required this.isThickLeft,
    required this.isThickTop,
    required this.isThickRight,
    required this.isThickBottom,
  });
}

class _BoardPainter extends CustomPainter {
  final Map<(int, int), _CellVisual> visuals;
  final double cellSize;
  final Color thinBorderColor;
  final Color thickBorderColor;
  final TextStyle valueStyle;
  final TextStyle noteStyle;
  final Color noteColor;
  final Color strikeColor;
  final List<HintLine> hintLines;
  final Color highlightColor;
  final int highlightedValue;

  _BoardPainter({
    required this.visuals,
    required this.cellSize,
    required this.thinBorderColor,
    required this.thickBorderColor,
    required this.valueStyle,
    required this.noteStyle,
    required this.noteColor,
    required this.strikeColor,
    required this.hintLines,
    required this.highlightColor,
    required this.highlightedValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..style = PaintingStyle.fill;
    final thinBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = thinBorderColor;
    final thickBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = thickBorderColor;

    // Backgrounds are filled in their own pass, before any border is drawn.
    // A border stroke has width and straddles the line between two cells,
    // bleeding half its width into the neighbor's rect - if that neighbor's
    // background were filled afterward (as when both were painted in one
    // combined per-cell pass), its fill would paint back over that bleed,
    // blending a highlighted cell's tint into the border color and making
    // the shared edge look like a smudged, doubled line. Painting every
    // background first means no fill ever runs after any border exists.
    for (final entry in visuals.entries) {
      final (row, col) = entry.key;
      final rect = Rect.fromLTWH(col * cellSize, row * cellSize, cellSize, cellSize);
      backgroundPaint.color = entry.value.background;
      canvas.drawRect(rect, backgroundPaint);
    }

    // A hint's structure lines (fish lines, wing links) go over the tints
    // but under the borders and digits drawn next.
    paintHintLines(
      canvas,
      hintLines,
      center: (cell) => Offset((cell.$2 + 0.5) * cellSize, (cell.$1 + 0.5) * cellSize),
      width: cellSize * 0.1,
      ruleColor: strikeColor,
    );

    for (final entry in visuals.entries) {
      final (row, col) = entry.key;
      final visual = entry.value;
      final rect = Rect.fromLTWH(col * cellSize, row * cellSize, cellSize, cellSize);

      canvas.drawLine(rect.topRight, rect.bottomRight, visual.isThickRight ? thickBorder : thinBorder);
      canvas.drawLine(rect.bottomLeft, rect.bottomRight, visual.isThickBottom ? thickBorder : thinBorder);
      if (visual.isThickLeft) canvas.drawLine(rect.topLeft, rect.bottomLeft, thickBorder);
      if (visual.isThickTop) canvas.drawLine(rect.topLeft, rect.topRight, thickBorder);

      if (visual.value != 0) {
        _paintText(
          canvas,
          '${visual.value}',
          rect.center,
          valueStyle.copyWith(
            color: visual.valueColor,
            fontWeight: visual.valueWeight,
            fontSize: cellSize * 0.6,
          ),
        );
      } else if (visual.notes.isNotEmpty || visual.strikeDigits.isNotEmpty) {
        _paintNotes(canvas, rect, visual.notes, visual.strikeDigits);
      }
    }
  }

  void _paintNotes(Canvas canvas, Rect rect, Set<int> notes, Set<int> struck) {
    final subSize = rect.width / 3;
    for (final digit in {...notes, ...struck}) {
      final localIndex = digit - 1;
      final center = Offset(
        rect.left + (localIndex % 3) * subSize + subSize / 2,
        rect.top + (localIndex ~/ 3) * subSize + subSize / 2,
      );
      final isStruck = struck.contains(digit);
      final isMatching = !isStruck && digit == highlightedValue;
      if (isMatching) {
        final badge = RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: subSize * 0.8, height: subSize * 0.72),
          const Radius.circular(3),
        );
        canvas.drawRRect(
          badge,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = highlightColor,
        );
      }
      _paintText(
        canvas,
        '$digit',
        center,
        noteStyle.copyWith(
          color: isStruck
              ? strikeColor
              : isMatching
                  ? highlightColor
                  : noteColor,
          fontWeight: isMatching || isStruck ? FontWeight.w800 : null,
          height: 1,
          fontSize: subSize * 0.6,
        ),
      );
      if (isStruck) {
        final half = subSize * 0.34;
        canvas.drawLine(
          center + Offset(-half, half),
          center + Offset(half, -half),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..color = strikeColor,
        );
      }
    }
  }

  void _paintText(Canvas canvas, String text, Offset center, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) => true;
}
