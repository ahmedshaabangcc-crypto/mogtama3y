import 'package:flutter/widgets.dart';

/// A stand-in photo for a directory place, by its category (or a
/// technician's trade): the directory has no photos of its own, so a
/// restaurant shows food, a pharmacy medicine, a café coffee… Reuses the
/// starter-catalog photos (web/catalog) and the home section photos.
/// Null when nothing fits — callers fall back to an icon.
ImageProvider? placeImage(String? category) {
  const catalog = {
    'سوبر ماركت وبقالة': 'spices',
    'صيدليات': 'painkiller',
    'مطاعم': 'koshari',
    'كافيهات': 'turkish-coffee',
    'حلويات ومخبوزات': 'kunafa',
    'صحة وعيادات': 'bandage',
    'ملابس وأزياء': 'shirt',
    'إلكترونيات وموبايلات': 'charger',
    'أدوات منزلية وأثاث': 'cookware',
    'تجميل وعناية': 'moisturizer',
    'هدايا ومكتبات': 'cake',
    'رياضة': 'sneakers',
  };
  const assets = {
    'صيانة وخدمات منزلية': 'maintenance',
    'سباكة': 'maintenance',
    'كهرباء': 'maintenance',
    'تكييف وتبريد': 'maintenance',
    'نجارة': 'maintenance',
    'دهانات': 'maintenance',
    'أخرى': 'maintenance',
    'عقارات': 'real_estate',
    'تعليم': 'jobs',
    'خدمات وشركات': 'jobs',
    'محلات متنوعة': 'shops',
  };
  final slug = catalog[category];
  if (slug != null) return NetworkImage('https://mogtama3y.com/catalog/$slug.jpg');
  final asset = assets[category];
  if (asset != null) return AssetImage('assets/images/home/$asset.jpg');
  return null;
}
