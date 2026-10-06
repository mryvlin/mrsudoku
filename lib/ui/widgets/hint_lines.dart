import 'dart:ui';

import '../../logic/hint_engine.dart';

/// The amber that marks a hint's cells and base lines - deliberately not the
/// player's chosen highlight color, so a hint never reads as a selection.
const Color hintAmber = Color(0xFFFFB300);

/// Cover lines of a fish, drawn in a second color so they can be told from
/// the base lines.
const Color hintCoverTeal = Color(0xFF26A69A);

/// Draws a hint's structure lines (see [HintLine]) onto [canvas], between
/// the points [center] maps their end cells to. Shared by the board and the
/// technique guide's schematics so they look the same: base and link lines
/// solid amber, cover lines solid teal, rule lines dashed in [ruleColor].
void paintHintLines(
  Canvas canvas,
  List<HintLine> lines, {
  required Offset Function((int, int) cell) center,
  required double width,
  required Color ruleColor,
}) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = width;

  // Rule lines first, so the solid lines that matter sit on top of them.
  for (final line in lines.where((l) => l.role == HintLineRole.rule)) {
    paint.color = ruleColor.withValues(alpha: 0.75);
    _dashed(canvas, center(line.from), center(line.to), paint, width * 1.6);
  }
  for (final line in lines.where((l) => l.role != HintLineRole.rule)) {
    paint.color = (line.role == HintLineRole.cover ? hintCoverTeal : hintAmber).withValues(alpha: 0.8);
    canvas.drawLine(center(line.from), center(line.to), paint);
  }
}

void _dashed(Canvas canvas, Offset a, Offset b, Paint paint, double dash) {
  final delta = b - a;
  final length = delta.distance;
  if (length == 0) return;
  final direction = delta / length;
  for (var travelled = 0.0; travelled < length; travelled += dash * 2) {
    final end = travelled + dash > length ? length : travelled + dash;
    canvas.drawLine(a + direction * travelled, a + direction * end, paint);
  }
}
