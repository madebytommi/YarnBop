import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// AppTheme enforcing the 2010s Web Nostalgia aesthetic rules in DESIGN_SYSTEM.md
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false, // Embracing 2010s grid structure over Material 3 floating bubbly styles
      scaffoldBackgroundColor: AppColors.backgroundCanvas,
      primaryColor: AppColors.primaryBlue,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0.0, // Grid style with distinct borders instead of elevated cards
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderGray, width: 1.0),
          borderRadius: BorderRadius.circular(4.0), // 4px sharp rounded corners
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF0C85D0), width: 1.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
