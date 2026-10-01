import 'package:flutter/material.dart';

/// Brand palette for مُجتمعي — Apex's design language (getapex.tech) in
/// its light variant: cool off-white canvas, white cards with hairline
/// borders, ink near-black text, and Apex's blue → purple → pink
/// gradient as the signature accent.
///
/// The historical names (teal, navy, gold…) are kept so every screen
/// picks up the new look without per-screen changes: `teal` is now the
/// primary accent, `navy` the dark "hero" surface.
class AppColors {
  AppColors._();

  // Apex signature
  static const apexBlue = Color(0xFF3D6BFF);
  static const apexPurple = Color(0xFFA855F7);
  static const apexPink = Color(0xFFFF3D8A);

  static const brandGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [apexBlue, apexPurple, apexPink],
  );

  /// Soft wash for banners/headers (Apex's translucent tri-colour wash).
  static const softGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFE9EEFF), Color(0xFFF4EBFF), Color(0xFFFFEAF2)],
  );

  static const teal = apexBlue; // primary actions / accents
  static const tealLight = Color(0xFFC9D6FF);
  static const navy = Color(0xFF0E1220); // dark hero cards
  static const gold = Color(0xFFF59E0B); // warm accent / ratings

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
  static const categoryShops = Color(0xFFFF3D8A); // المحلات
  static const categoryUnion = apexBlue; // اتحاد الملاك
  static const categoryRealEstate = Color(0xFF06B6D4); // عقارات
  static const categoryJobs = apexPurple; // وظائف
  static const categoryMaintenance = Color(0xFF10B981); // الصيانة والخدمات
  static const categorySos = Color(0xFFEF4444); // SOS طوارئ
  static const categoryLostFound = Color(0xFF6366F1); // المفقودات والأمانات
  static const categoryRecycling = Color(0xFF22C55E); // تدوير وتوفير
}
