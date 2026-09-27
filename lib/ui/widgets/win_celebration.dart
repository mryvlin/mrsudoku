import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../models/board.dart';

/// Shows the solved board "exploding" - every entered digit flies outward
/// from the cell it was sitting in, spinning and growing as if rushing
/// toward the viewer - as a full-screen overlay when the player solves the
/// puzzle. This is the one spot in the app where Flame earns its keep over
/// plain Flutter widgets - this many independently animated, overlapping
/// components would be awkward to hand-roll with `AnimatedContainer`/
/// `Tween`s.
///
/// [boardRect] must be the board's on-screen rect in global coordinates
/// (e.g. from a `RenderBox.localToGlobal`/`.size` on the board widget) so
/// each digit's flight can start exactly where it was showing on screen.
void showWinCelebration(
  BuildContext context, {
  required Board board,
  required Rect boardRect,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => IgnorePointer(
      child: GameWidget(
        game: _ExplosionGame(
          board: board,
          boardRect: boardRect,
          onFinished: () => entry.mounted ? entry.remove() : null,
        ),
      ),
    ),
  );
  overlay.insert(entry);
}

class _ExplosionGame extends FlameGame {
  final Board board;
  final Rect boardRect;
  final VoidCallback onFinished;
  final Random _random = Random();
  bool _spawned = false;

  _ExplosionGame({required this.board, required this.boardRect, required this.onFinished});

  // GameWidget always paints a DecoratedBox behind the game using this
  // color (see its use of Game.backgroundColor()), and the default is
  // opaque black - without this override the "overlay" would black out
  // the whole screen instead of showing the exploding digits over the
  // board and win dialog.
  @override
  Color backgroundColor() => const Color(0x00000000);

  static const _colors = [
    Colors.amber,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.white,
  ];

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_spawned || size.x == 0) return;
    _spawned = true;
    _explode();
  }

  void _explode() {
    final shape = board.shape;
    final cellSize = boardRect.width / shape.width;
    final centerX = boardRect.left + boardRect.width / 2;
    final centerY = boardRect.top + boardRect.height / 2;

    for (final (row, col) in shape.activeCells) {
      final value = board.cellAt(row, col).value;
      if (value == 0) continue;

      final x = boardRect.left + (col + 0.5) * cellSize;
      final y = boardRect.top + (row + 0.5) * cellSize;

      // Direction radially outward from the board's center, so digits fly
      // apart from where they sat rather than in a uniformly random spray.
      // A cell right at dead center has a near-zero radial vector, so it
      // falls back to a random direction instead of an undefined one.
      var dirX = x - centerX;
      var dirY = y - centerY;
      final dist = sqrt(dirX * dirX + dirY * dirY);
      if (dist < 1) {
        final angle = _random.nextDouble() * 2 * pi;
        dirX = cos(angle);
        dirY = sin(angle);
      } else {
        dirX /= dist;
        dirY /= dist;
      }
      // Jitter the angle so the burst doesn't look perfectly symmetric.
      final jitter = (_random.nextDouble() - 0.5) * (pi / 3);
      final cosJ = cos(jitter), sinJ = sin(jitter);
      final jitteredX = dirX * cosJ - dirY * sinJ;
      final jitteredY = dirX * sinJ + dirY * cosJ;

      final travel = 260 + _random.nextDouble() * 420;
      final duration = 1.0 + _random.nextDouble() * 0.5;
      final spinTurns = (_random.nextDouble() - 0.5) * 4;

      final text = TextComponent(
        text: '$value',
        position: Vector2(x, y),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: cellSize * 0.6,
            fontWeight: FontWeight.w800,
            color: _colors[_random.nextInt(_colors.length)],
          ),
        ),
      )
        ..add(MoveByEffect(
          Vector2(jitteredX, jitteredY) * travel,
          EffectController(duration: duration, curve: Curves.easeOutCubic),
        ))
        // Growing as it flies is what sells "towards the screen" - like the
        // digit is rushing at the viewer rather than just sliding away.
        ..add(ScaleEffect.to(
          Vector2.all(2.5 + _random.nextDouble() * 3),
          EffectController(duration: duration, curve: Curves.easeIn),
        ))
        ..add(RotateEffect.by(
          spinTurns * 2 * pi,
          EffectController(duration: duration, curve: Curves.easeOut),
        ))
        ..add(OpacityEffect.to(
          0,
          EffectController(duration: duration * 0.4, startDelay: duration * 0.55),
        ));

      add(text);
    }

    Future<void>.delayed(const Duration(milliseconds: 1700), onFinished);
  }
}
