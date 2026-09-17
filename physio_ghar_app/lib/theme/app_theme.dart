import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2F5D50);
  static const Color primaryDark = Color(0xFF1E2A2E);
  static const Color secondary = Color(0xFFD1E8D5);
  static const Color accentYellow = Color(0xFFFEF3C7);
  static const Color accentYellowText = Color(0xFFD97706);
  
  static const Color background = Color(0xFFFBFBF8);
  static const Color surface = Colors.white;
  
  static const Color border = Color(0xFFEEF1EE);
  static const Color textMain = Color(0xFF1E2A2E);
  static const Color textMuted = Color(0xFF4A5854);
  static const Color textSubtle = Color(0xFF8FA8A0);
  
  static const Color error = Color(0xFFC84B48);
  static const Color success = Color(0xFF2E7D32);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fraunces(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
        titleLarge: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
        bodyLarge: GoogleFonts.inter(fontSize: 14, color: AppColors.textMain),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
        bodySmall: GoogleFonts.inter(fontSize: 11, color: AppColors.textSubtle),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}