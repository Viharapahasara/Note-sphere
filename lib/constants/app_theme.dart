import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Main background color for all screens
      scaffoldBackgroundColor: AppColors.kdarkNavy, //[cite: 1]
      fontFamily: 'Nunito',
      // Primary color scheme mapping
      colorScheme: const ColorScheme.dark(
        primary:
            AppColors.kamberOrange, //[cite: 1] Action buttons and highlights
        secondary: AppColors.kskyBlue, //[cite: 1] Secondary accents and icons
        surface: AppColors.kdeepBlue, //[cite: 1] Cards and dialog backgrounds
        onPrimary: Colors.white, // Text color on primary buttons
        onSecondary:
            AppColors.kdarkNavy, //[cite: 1] Text color on secondary components
        onSurface:
            AppColors.kpeachCream, //[cite: 1] Main text color on surfaces
      ),

      // AppBar styling
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kdarkNavy, //[cite: 1]
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.kpeachCream), //[cite: 1]
        titleTextStyle: TextStyle(
          color: AppColors.kpeachCream, //[cite: 1]
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card styling
      cardTheme: CardThemeData(
        color: AppColors.kdeepBlue, //[cite: 1]
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Primary button styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kamberOrange, //[cite: 1]
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
