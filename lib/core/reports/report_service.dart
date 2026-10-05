import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

/// Governorate capitals — the nearest one names the governorate of a
/// report (good enough to sort the admin queue; the district comes from
/// Google's geocoder).
const _governorates = <(String, double, double)>[
  ('القاهرة', 30.0444, 31.2357), ('الجيزة', 30.0131, 31.2089), ('الإسكندرية', 31.2001, 29.9187),
  ('القليوبية', 30.4659, 31.1848), ('الشرقية', 30.5877, 31.502), ('الدقهلية', 31.0409, 31.3785),
  ('الغربية', 30.7865, 31.0004), ('المنوفية', 30.5536, 31.0094), ('البحيرة', 31.0341, 30.4682),
  ('كفر الشيخ', 31.1107, 30.9388), ('دمياط', 31.4165, 31.8133), ('بورسعيد', 31.2653, 32.3019),
  ('الإسماعيلية', 30.5965, 32.2715), ('السويس', 29.9668, 32.5498), ('الفيوم', 29.3084, 30.8428),
  ('بني سويف', 29.0661, 31.0994), ('المنيا', 28.1099, 30.7503), ('أسيوط', 27.1809, 31.1837),
  ('سوهاج', 26.5591, 31.6957), ('قنا', 26.1551, 32.716), ('الأقصر', 25.6872, 32.6396),
  ('أسوان', 24.0889, 32.8998), ('البحر الأحمر', 27.2579, 33.8116), ('جنوب سيناء', 27.9158, 34.33),
  ('شمال سيناء', 31.1316, 33.7984), ('مطروح', 31.3543, 27.2373), ('الوادي الجديد', 25.4390, 30.5586),
];

String governorateOf(double lat, double lng) {
  var best = _governorates.first.$1;
  var bestD = double.infinity;
  for (final (name, la, ln) in _governorates) {
    final d = (lat - la) * (lat - la) + (lng - ln) * (lng - ln);
    if (d < bestD) {
      best = name;
      bestD = d;
    }
  }
  return best;
}

List<String> get reportGovernorates => [for (final g in _governorates) g.$1];

/// Community reports — migration 0060.
class ReportService {
  ReportService._();

  static const disclaimer = 'مُجتمعي منصة مجتمعية مش جهة حكومية — بنوصّل بلاغك للجهة المختصة ونتابعه معاها.';

  /// Share link with a preview (photo + title) for TikTok/Facebook/WhatsApp;
  /// it opens the report in the app.
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
    });
    return id as String;
  }

  static Future<List<Map<String, dynamic>>> list({double? lat, double? lng, double km = 5, String? category, String? status, bool mine = false}) async {
    final rows = await _db.rpc('list_reports', params: {
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

  static Future<List<Map<String, dynamic>>> adminList({String? status, String? category, String? governorate}) async {
    final rows = await _db.rpc('admin_list_reports', params: {'p_status': status, 'p_category': category, 'p_governorate': governorate});
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
