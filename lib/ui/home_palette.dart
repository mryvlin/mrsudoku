import 'package:flutter/material.dart';

/// Fixed dark color palette for the Home screen's redesign - deliberately
/// independent of `Theme.of(context)`/[AppThemeMode], since this look is
/// meant to always show regardless of the user's light/dark/system theme
/// setting (a distinct visual identity for the landing screen, not a theme
/// variant). Shared between `home_screen.dart` and `leaderboard_widget.dart`
/// so the leaderboard card's colors and the screen around it stay in sync.
class HomePalette {
  const HomePalette._();

  static const background = Color(0xFF0A0A12);
  static const card = Color(0xFF15151F);
  static const border = Color(0xFF2A2A3D);
  static const primaryText = Colors.white;
  static const mutedText = Color(0xFF8A8AA3);
  static const gold = Color(0xFFFFC940);

  static const accent = Color(0xFF3D7EF5);
}
