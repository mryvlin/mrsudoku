import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/hint_engine.dart';
import '../hint_text.dart';
import 'hint_lines.dart';

/// A small schematic per technique: `E` marks the cells that form the
/// pattern, `X` the cells a digit is ruled out of (or removed from), `.` an
/// unrelated cell. Hand-drawn rather than derived from a real board - it
/// shows the shape of the technique, which is what the guide is for.
const Map<GuideTopic, List<String>> _diagrams = {
  GuideTopic.nakedSingle: [
    '..E..',
    '..E..',
    'EETEE',
    '..E..',
    '..E..',
  ],
  GuideTopic.hiddenSingle: [
    'XXXXEXXXX',
  ],
  GuideTopic.nakedPair: [
    'EE.X..XX.',
  ],
  GuideTopic.pointing: [
    '.........',
    'E.E.X.X.X',
    '.........',
  ],
  GuideTopic.hiddenPair: [
    '..E..E...',
  ],
  GuideTopic.nakedTriple: [
    'EEE.X..X.',
  ],
  GuideTopic.xWing: [
    'E..E.',
    'X..X.',
    'X..X.',
    'E..E.',
    'X..X.',
  ],
  GuideTopic.xyWing: [
    'E..E',
    '....',
    '....',
    'E..X',
  ],
  GuideTopic.swordfish: [
    'E.E..',
    'X.X.X',
    'E...E',
    'X.X.X',
    '..E.E',
  ],
};

/// The structure lines drawn over the schematics of the fish and wings, in
/// the same style the board uses for a real hint (see [paintHintLines]).
const Map<GuideTopic, List<HintLine>> _diagramLines = {
  GuideTopic.xWing: [
    HintLine((0, 0), (0, 3), HintLineRole.base),
    HintLine((3, 0), (3, 3), HintLineRole.base),
    HintLine((0, 0), (4, 0), HintLineRole.cover),
    HintLine((0, 3), (4, 3), HintLineRole.cover),
  ],
  GuideTopic.swordfish: [
    HintLine((0, 0), (0, 2), HintLineRole.base),
    HintLine((2, 0), (2, 4), HintLineRole.base),
    HintLine((4, 2), (4, 4), HintLineRole.base),
    HintLine((0, 0), (4, 0), HintLineRole.cover),
    HintLine((0, 2), (4, 2), HintLineRole.cover),
    HintLine((0, 4), (4, 4), HintLineRole.cover),
  ],
  GuideTopic.xyWing: [
    HintLine((0, 0), (0, 3), HintLineRole.link),
    HintLine((0, 0), (3, 0), HintLineRole.link),
    HintLine((0, 3), (3, 3), HintLineRole.rule),
    HintLine((3, 0), (3, 3), HintLineRole.rule),
  ],
};

/// Opens the guide for the technique behind [step]: its name, a schematic
/// of the pattern and the rule in plain words.
void showTechniqueGuide(BuildContext context, GuideTopic topic) {
  final l10n = AppLocalizations.of(context)!;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(guideTitle(topic, l10n)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: TechniqueDiagram(topic: topic)),
            const SizedBox(height: 8),
            Text(l10n.guideLegend, style: Theme.of(context).textTheme.bodySmall),
            if (_diagramLines.containsKey(topic))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(l10n.guideLegendLines, style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            Text(guideBody(topic, l10n)),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('guide-close'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.guideClose),
        ),
      ],
    ),
  );
}

/// Draws [topic]'s schematic (see [_diagrams]).
class TechniqueDiagram extends StatelessWidget {
  final GuideTopic topic;

  const TechniqueDiagram({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final rows = _diagrams[topic]!;
    const cell = 22.0;
    return SizedBox(
      width: rows.first.length * cell,
      height: rows.length * cell,
      child: CustomPaint(
        painter: _DiagramPainter(
          rows: rows,
          cell: cell,
          line: Theme.of(context).colorScheme.outline,
          fill: Theme.of(context).colorScheme.surfaceContainerHighest,
          pattern: hintAmber,
          ruledOut: Theme.of(context).colorScheme.error,
          lines: _diagramLines[topic] ?? const [],
        ),
      ),
    );
  }
}

class _DiagramPainter extends CustomPainter {
  final List<String> rows;
  final double cell;
  final Color line;
  final Color fill;
  final Color pattern;
  final Color ruledOut;
  final List<HintLine> lines;

  _DiagramPainter({
    required this.rows,
    required this.cell,
    required this.line,
    required this.fill,
    required this.pattern,
    required this.ruledOut,
    required this.lines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint();
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = line;
    final thick = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = line;

    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < rows[r].length; c++) {
        final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
        final mark = rows[r][c];
        fillPaint.color = switch (mark) {
          'E' || 'T' => pattern.withValues(alpha: 0.7),
          'X' => ruledOut.withValues(alpha: 0.18),
          _ => fill,
        };
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, linePaint);
        if (mark == 'X') {
          canvas.drawLine(
            rect.topLeft + Offset(cell * 0.28, cell * 0.28),
            rect.bottomRight - Offset(cell * 0.28, cell * 0.28),
            Paint()
              ..strokeWidth = 1.4
              ..color = ruledOut,
          );
          canvas.drawLine(
            rect.topRight + Offset(-cell * 0.28, cell * 0.28),
            rect.bottomLeft + Offset(cell * 0.28, -cell * 0.28),
            Paint()
              ..strokeWidth = 1.4
              ..color = ruledOut,
          );
        }
      }
    }
    paintHintLines(
      canvas,
      lines,
      center: (cellPos) => Offset((cellPos.$2 + 0.5) * cell, (cellPos.$1 + 0.5) * cell),
      width: cell * 0.12,
      ruleColor: ruledOut,
    );
    // Nine-wide diagrams are one row/column of a real board: mark its box
    // boundaries like the board does.
    if (rows.first.length == 9) {
      for (final c in [3, 6]) {
        canvas.drawLine(Offset(c * cell, 0), Offset(c * cell, rows.length * cell), thick);
      }
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, rows.first.length * cell, rows.length * cell), thick);
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) => false;
}
