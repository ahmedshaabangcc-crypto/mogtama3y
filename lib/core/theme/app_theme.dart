import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.teal,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
    );

    return base.copyWith(
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.reemKufi(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineMedium: GoogleFonts.reemKufi(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleLarge: GoogleFonts.reemKufi(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.teal,
        unselectedItemColor: AppColors.inkMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
