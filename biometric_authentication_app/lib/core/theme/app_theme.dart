import 'package:flutter/material.dart';

class AppTheme {
  // Level 0 - Base
  static const Color surface = Color(0xFF10141A);
  // Level 1 - Sections
  static const Color surfaceContainerLow = Color(0xFF181C22);
  // Level 2 - Interative Cards
  static const Color surfaceContainer = Color(0xFF1C2026);
  // Level 3 - High details/modals
  static const Color surfaceContainerHighest = Color(0xFF31353C);

  // Primary brand
  static const Color primary = Color(0xFFB2C5FF);
  // Authoritative background for buttons
  static const Color primaryContainer = Color(0xFF0052CC);

  // Text
  static const Color onSurface = Color(0xFFDFE2EB);
  static const Color outlineVariant = Color(0x26DFE2EB); // 15% opacity

  // State colors
  static const Color success = Color(0xFF4CAF82);
  static const Color tertiary = Color(0xFFFFB59B); // Standby
  static const Color error = Color(0xFFCF3C3C);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        surface: surface,
        onSurface: onSurface,
        secondary: tertiary,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          color: onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: primary, // text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF14181F), // surfaceContainerLowest conceptually
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1), // inner glow conceptual
        ),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
