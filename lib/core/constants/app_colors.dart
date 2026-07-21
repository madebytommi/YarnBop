import 'package:flutter/material.dart';

/// 2010s Web Nostalgia Color Palette as specified in DESIGN_SYSTEM.md
class AppColors {
  AppColors._();

  // Primary Brand (Top Bars & Active States)
  static const Color primaryBlue = Color(0xFF1DA1F2);
  static const Color navyBlue = Color(0xFF36465D);

  // Canvas & Content
  static const Color backgroundCanvas = Color(0xFFF5F8FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderGray = Color(0xFFE6E6E6);

  // Typography
  static const Color textDarkCharcoal = Color(0xFF14171A);
  static const Color textMutedGray = Color(0xFF657786);

  // Movable Line Highlighter Overlay
  static const Color highlighterYellow = Color(0xFFFFF9C4);
  static const Color highlighterYellowOpacity = Color(0x80FFF9C4); // 50% opacity
  static const Color highlighterBorder = Color(0xCCC8B400);

  // Overlay Counter Widget (Rigid Dark Badge)
  static const Color counterWidgetBg = Color(0xD914171A); // 85% opacity dark charcoal
  static const Color counterText = Color(0xFFFFFFFF);
}
