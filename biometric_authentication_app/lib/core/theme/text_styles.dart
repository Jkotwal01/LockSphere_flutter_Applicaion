import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AppTextStyles {
  // Statement Styles (Manrope)
  static TextStyle get displayLg => GoogleFonts.manrope(
        fontSize: 56, // 3.5rem equivalent roughly
        fontWeight: FontWeight.w800,
        color: AppTheme.onSurface,
        letterSpacing: -1.5,
      );

  static TextStyle get displayMd => GoogleFonts.manrope(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppTheme.onSurface,
        letterSpacing: -1.0,
      );

  static TextStyle get headlineSm => GoogleFonts.manrope(
        fontSize: 24, // 1.5rem
        fontWeight: FontWeight.w600,
        color: AppTheme.onSurface,
        letterSpacing: -0.5,
      );

  static TextStyle get titleSm => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.primary,
        letterSpacing: 0.1,
      );

  // Body & Utility Styles (Inter)
  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14, // 0.875rem
        fontWeight: FontWeight.w400,
        color: AppTheme.onSurface,
        height: 1.5,
      );
      
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16, // 1rem
        fontWeight: FontWeight.w400,
        color: AppTheme.onSurface,
        height: 1.5,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 11, // 0.6875rem
        fontWeight: FontWeight.w500,
        color: AppTheme.onSurface.withOpacity(0.7),
        letterSpacing: 0.5,
      );
}
