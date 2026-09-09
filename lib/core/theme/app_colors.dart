import 'package:flutter/material.dart';

/// Brand palette for مُجتمعي, derived from the Stitch design screens
/// and the logo identity (design/social-kit.html).
class AppColors {
  AppColors._();

  static const teal = Color(0xFF0E6B55); // trust / verified accents
  static const tealLight = Color(0xFF9FE1CB);
  static const navy = Color(0xFF12233F); // headers, dark surfaces
  static const gold = Color(0xFFC99A3D); // warm accent

  static const bg = Color(0xFFF4F6F2);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEAEFEA);
  static const ink = Color(0xFF13221C);
  static const inkSecondary = Color(0xFF4E5C55);
  static const inkMuted = Color(0xFF8A968F);
  static const border = Color(0x2413221C);

  /// Category colors — one per home-grid section, matching the 9-icon
  /// grid in screen [01].
  static const categoryUsedMarket = Color(0xFFE8912B); // سوق المستعمل
  static const categoryShops = Color(0xFFD8433A); // المحلات
  static const categoryUnion = Color(0xFF2E7FD6); // اتحاد الملاك
  static const categoryRealEstate = Color(0xFF1E7FA0); // عقارات
  static const categoryJobs = Color(0xFF7A4FC9); // وظائف
  static const categoryMaintenance = Color(0xFF189E6C); // الصيانة والخدمات
  static const categorySos = Color(0xFFD8433A); // SOS طوارئ
  static const categoryLostFound = Color(0xFF6D5BD0); // المفقودات والأمانات
  static const categoryRecycling = Color(0xFF189E6C); // تدوير وتوفير
}
