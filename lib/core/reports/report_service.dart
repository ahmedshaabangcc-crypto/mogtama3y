import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../geo/admin_areas.dart';
import '../geo/user_country.dart';

SupabaseClient get _db => Supabase.instance.client;

/// Report categories — must match the check in migration 0060.
const reportCategories = <(String, IconData, Color)>[
  ('نظافة وقمامة', Icons.delete_outline_rounded, Color(0xFF2E7D32)),
  ('إشغالات طريق', Icons.storefront_outlined, Color(0xFF6D4C41)),
  ('حفر ورصف', Icons.construction_rounded, Color(0xFFEF6C00)),
  ('مياه وصرف', Icons.water_drop_outlined, Color(0xFF0277BD)),
  ('إنارة وكهرباء', Icons.lightbulb_outline_rounded, Color(0xFFF9A825)),
  ('مخالفات بناء', Icons.apartment_rounded, Color(0xFF5D4037)),
  ('مرور وتوكتوك', Icons.traffic_rounded, Color(0xFF455A64)),
  ('حيوانات ضالة', Icons.pets_rounded, Color(0xFF8D6E63)),
  ('مخالفة خطرة', Icons.warning_amber_rounded, Color(0xFFE65100)),
  ('مخالفة شديدة الخطورة', Icons.dangerous_rounded, Color(0xFFC62828)),
  ('أخرى', Icons.more_horiz_rounded, Color(0xFF607D8B)),
];

(IconData, Color) reportCategoryStyle(String? category) {
  for (final (name, icon, color) in reportCategories) {
    if (name == category) return (icon, color);
  }
  return (Icons.report_outlined, const Color(0xFF607D8B));
}

/// Status → (label, colour), matching report_status_label() in 0060.
const reportStatuses = <String, (String, Color)>{
  'new': ('جديد', Color(0xFF607D8B)),
  'reviewing': ('قيد المراجعة', Color(0xFFF9A825)),
  'routed': ('اتبعت للجهة المختصة', Color(0xFF1565C0)),
  'resolved': ('اتحلّ', Color(0xFF2E7D32)),
  'rejected': ('مرفوض / مكرر', Color(0xFFC62828)),
};

/// The division (governorate / region / emirate…) of a point — the
/// nearest division capital inside the point's country (Egypt's 27
/// governorates unchanged). Good enough to sort the admin queue; the
/// district comes from Google's geocoder.
String governorateOf(double lat, double lng) => divisionAt(lat, lng);

/// Divisions of the country the feeds show (filters): Egypt's governorates
/// for Egyptian users, Saudi regions, UAE emirates…
List<String> get reportGovernorates => adminAreaNames(UserCountry.feedCountry);

/// Divisions of the user's own country (pickers of new listings / forms).
List<String> get myGovernorates => adminAreaNames(UserCountry.iso.value);

/// Divisions for an entity of [country] (editing an existing row).
List<String> governoratesFor(String? country) => adminAreaNames(country ?? UserCountry.iso.value);

/// Community reports — migration 0060.
class ReportService {
  ReportService._();

  static const disclaimer = 'مُجتمعي منصة مجتمعية مش جهة حكومية — بنوصّل بلاغك للجهة المختصة ونتابعه معاها.';

  /// Share link with a preview (photo + title) for TikTok/Facebook/WhatsApp;
  /// it opens the report in the app.
  /// Video links people can attach (must match the check in migration 0063).
  static final videoLinkPattern = RegExp(r'^https://([a-z0-9-]+\.)*(tiktok\.com|youtube\.com|youtu\.be|facebook\.com|fb\.watch|instagram\.com)/', caseSensitive: false);

  static String shareUrl(String id) => 'https://dalil.mogtama3y.com/r/$id';

  static Future<String> submit({
    required String category,
    required String description,
    required List<String> photos,
    required double lat,
    required double lng,
    String? governorate,
    String? district,
    bool hideIdentity = false,
    String? videoUrl,
    String? videoLink,
  }) async {
    final id = await _db.rpc('submit_report', params: {
      'p_category': category,
      'p_description': description,
      'p_photos': photos,
      'p_lat': lat,
      'p_lng': lng,
      'p_governorate': governorate,
      'p_district': district,
      'p_hide_identity': hideIdentity,
      'p_video_url': videoUrl,
      'p_video_link': videoLink,
    });
    return id as String;
  }

  /// Without a location (or [country] given) the feed is one country's
  /// reports: [country], else the feed country (0093).
  static Future<List<Map<String, dynamic>>> list({double? lat, double? lng, double km = 5, String? category, String? status, bool mine = false, String? country}) async {
    final rows = await _db.rpc('list_reports', params: {
      'p_country': mine ? null : (country ?? (lat == null ? UserCountry.feedCountry : null)),
      'p_lat': lat,
      'p_lng': lng,
      'p_km': km,
      'p_category': category,
      'p_status': status,
      'p_mine': mine,
      'p_limit': 100,
    });
    return [for (final r in rows as List) Map<String, dynamic>.from(r as Map)];
  }

  static Future<Map<String, dynamic>?> get(String id) async {
    final r = await _db.rpc('get_report', params: {'p_id': id});
    return r == null ? null : Map<String, dynamic>.from(r as Map);
  }

  static Future<bool> toggleVote(String id) async => await _db.rpc('toggle_report_vote', params: {'p_id': id}) as bool;

  static Future<List<Map<String, dynamic>>> adminList({String? status, String? category, String? governorate, String? country}) async {
    final rows = await _db.rpc('admin_list_reports', params: {'p_status': status, 'p_category': category, 'p_governorate': governorate, 'p_country': country});
    return [for (final r in rows as List) Map<String, dynamic>.from(r as Map)];
  }

  static Future<void> adminUpdate(
    String id, {
    required String status,
    String? statusNote,
    String? routedTo,
    String? routedNote,
    String? afterPhoto,
    bool? hidden,
  }) async {
    await _db.rpc('admin_update_report', params: {
      'p_id': id,
      'p_status': status,
      'p_status_note': statusNote,
      'p_routed_to': routedTo,
      'p_routed_note': routedNote,
      'p_after_photo': afterPhoto,
      'p_is_hidden': hidden,
    });
  }

  /// "مفتوح من 3 أيام" / "اتحل بعد يومين".
  static String ageLabel(Map<String, dynamic> r) {
    final created = DateTime.tryParse(r['created_at'] as String? ?? '');
    if (created == null) return '';
    final end = r['status'] == 'resolved' ? DateTime.tryParse(r['resolved_at'] as String? ?? '') ?? DateTime.now() : DateTime.now();
    final days = end.difference(created).inDays;
    final span = days <= 0 ? 'النهارده' : (days == 1 ? 'يوم' : (days == 2 ? 'يومين' : '$days أيام'));
    if (r['status'] == 'resolved') return days <= 0 ? 'اتحلّ في نفس اليوم' : 'اتحلّ بعد $span';
    if (r['status'] == 'rejected') return '';
    return days <= 0 ? 'اتبلّغ النهارده' : 'مفتوح من $span';
  }
}
