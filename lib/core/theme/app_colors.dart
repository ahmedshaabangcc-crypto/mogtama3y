import 'package:flutter/material.dart';

/// Brand palette for مُجتمعي — light canvas (cool off-white, white cards
/// with hairline borders, ink text) with a dark "crystal glass" accent:
/// deep sapphire/navy with a light sheen band, used for every button,
/// highlight and the brand gradient. No pink/red outside error states.
///
/// The historical names (teal, navy, gold…) are kept so every screen
/// picks up the look without per-screen changes: `teal` is the primary
/// accent, `navy` the dark "hero" surface.
class AppColors {
  AppColors._();

  // Crystal accent
  static const crystal = Color(0xFF1B3A6E); // primary: deep sapphire
  static const crystalLight = Color(0xFF3D68B0); // sheen / highlights
  static const crystalDeep = Color(0xFF0A1630); // darkest edge

  /// Dark glass gradient with a soft light band, like cut crystal.
  static const brandGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF34598F), Color(0xFF15295A), crystalDeep, Color(0xFF1E3C72)],
    stops: [0.0, 0.4, 0.72, 1.0],
  );

  /// Soft cool wash for banners/headers.
  static const softGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFE3EAF6), Color(0xFFEEF2F9), Color(0xFFE6ECF6)],
  );

  /// "Blue hour" surfaces taken from the hero artwork: night-navy canvas,
  /// frosted glass panels and warm window-light amber.
  static const night = Color(0xFF0B1530);
  static const nightMid = Color(0xFF14244B);
  static const sky = Color(0xFF5D77A8);
  static const glass = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x2EFFFFFF);
  static const nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF13234A), night, Color(0xFF09122A)],
    stops: [0.0, 0.45, 1.0],
  );

  static const teal = crystal; // primary actions / accents
  static const tealLight = Color(0xFFC8D4EA);
  static const navy = Color(0xFF0E1220); // dark hero cards
  static const gold = Color(0xFFF2B661); // warm window-light amber

  static const bg = Color(0xFFF6F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEEF1F8);
  static const ink = Color(0xFF0B0E12);
  static const inkSecondary = Color(0xFF4A5068);
  static const inkMuted = Color(0xFF8B90A6);
  static const border = Color(0x140B0E12);

  static const success = Color(0xFF10B981);

  /// Category colors — vivid, one per home-grid section.
  static const categoryUsedMarket = Color(0xFFFF8A3D); // سوق المستعمل
  static const categoryShops = Color(0xFF0D9488); // المحلات
  static const categoryUnion = crystal; // اتحاد الملاك
  static const categoryRealEstate = Color(0xFF06B6D4); // عقارات
  static const categoryJobs = crystalLight; // وظائف
  static const categoryMaintenance = Color(0xFF10B981); // الصيانة والخدمات
  static const categorySos = Color(0xFFEF4444); // SOS طوارئ
  static const categoryLostFound = Color(0xFF6366F1); // المفقودات والأمانات
  static const categoryRecycling = Color(0xFF22C55E); // تدوير وتوفير
}
