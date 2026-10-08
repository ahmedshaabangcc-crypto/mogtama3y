import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Apex light theme: Almarai for headings, IBM Plex Sans Arabic for body
/// text, large soft corners, pill buttons, white app bar with a hairline.
class AppTheme {
  AppTheme._();

  static const radius = 22.0;

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.crystal,
        primary: AppColors.crystal,
        secondary: AppColors.crystalLight,
        tertiary: AppColors.crystalDeep,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      splashFactory: InkSparkle.splashFactory,
    );

    TextStyle heading(double size, FontWeight weight) => _almarai(fontSize: size, fontWeight: weight, color: AppColors.ink, height: 1.35);

    const pill = StadiumBorder();
    return base.copyWith(
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(base.textTheme).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink).copyWith(
            headlineLarge: heading(30, FontWeight.w800),
            headlineMedium: heading(24, FontWeight.w800),
            headlineSmall: heading(20, FontWeight.w700),
            titleLarge: heading(19, FontWeight.w700),
            titleMedium: heading(16, FontWeight.w700),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.border,
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        titleTextStyle: _almarai(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.ink),
        iconTheme: const IconThemeData(color: AppColors.ink),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.night,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: _almarai(fontWeight: FontWeight.w800, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.crystal,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.crystal.withValues(alpha: 0.4),
          shape: pill,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: _almarai(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border, width: 1.2),
          shape: pill,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: _almarai(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.crystal,
          shape: pill,
          textStyle: _almarai(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.crystal,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.crystal, width: 1.5)),
        labelStyle: const TextStyle(color: AppColors.inkSecondary),
        hintStyle: const TextStyle(color: AppColors.inkMuted),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.crystal,
        labelStyle: GoogleFonts.ibmPlexSansArabic(fontSize: 12, color: AppColors.ink),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.crystal,
        unselectedLabelColor: AppColors.inkMuted,
        indicatorColor: AppColors.crystal,
        labelStyle: _almarai(fontWeight: FontWeight.w800, fontSize: 13),
        dividerColor: AppColors.border,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: GoogleFonts.ibmPlexSansArabic(color: Colors.white),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        titleTextStyle: _almarai(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}

/// Almarai for headings, falling back to IBM Plex Sans Arabic for glyphs
/// Almarai lacks (e.g. ✓) — otherwise they render as empty boxes.
TextStyle _almarai({double? fontSize, FontWeight? fontWeight, Color? color, double? height}) =>
    GoogleFonts.almarai(fontSize: fontSize, fontWeight: fontWeight, color: color, height: height)
        .copyWith(fontFamilyFallback: [GoogleFonts.ibmPlexSansArabic().fontFamily!]);
