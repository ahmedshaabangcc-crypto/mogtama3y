import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

// Labels for the coded columns — keys must match the checks in
// migration 0070_event_halls.sql.

const hallTypes = <String, String>{
  'wedding': 'قاعة أفراح',
  'events': 'قاعة مناسبات وحفلات',
  'conference': 'قاعة مؤتمرات',
  'rooftop_garden': 'روف / جاردن',
  'hotel': 'قاعة فندق',
  'club': 'نادي',
  'cafe_restaurant': 'كافيه / مطعم لمناسبات صغيرة',
  'boat': 'يخت / مركب',
};

const hallOccasions = <String, String>{
  'wedding': 'فرح',
  'engagement': 'خطوبة',
  'katb_ketab': 'كتب كتاب',
  'birthday': 'عيد ميلاد',
  'condolence': 'عزا',
  'conference': 'مؤتمر / اجتماع',
  'graduation': 'تخرج',
};

const hallIncluded = <String, String>{
  'buffet': 'بوفيه',
  'dj': 'دي جي',
  'photography': 'تصوير',
  'kosha_decor': 'كوشة وديكور',
  'air_conditioned': 'مكيفة',
  'parking': 'جراج',
  'prayer_room': 'مكان للصلاة',
  'bride_room': 'غرفة عروسة',
};

const hallIncludedIcons = <String, IconData>{
  'buffet': Icons.restaurant_rounded,
  'dj': Icons.music_note_rounded,
  'photography': Icons.photo_camera_outlined,
  'kosha_decor': Icons.auto_awesome_outlined,
  'air_conditioned': Icons.ac_unit_rounded,
  'parking': Icons.local_parking_rounded,
  'prayer_room': Icons.mosque_outlined,
  'bride_room': Icons.face_retouching_natural_outlined,
};

/// "يبدأ من 30,000 ج.م" / "يبدأ من 450 ج.م للفرد", or "السعر بالاتفاق".
String hallPrice(Map<String, dynamic> h) {
  final price = h['price_from'] as num?;
  if (price == null) return 'السعر بالاتفاق';
  return 'يبدأ من ${NumberFormat('#,##0').format(price)} ج.م${h['price_per_person'] == true ? ' للفرد' : ''}';
}

/// "من 100 لـ 400 فرد" or "لحد 60 فرد".
String hallCapacity(Map<String, dynamic> h) {
  final min = h['capacity_min'] as int?;
  final max = h['capacity_max'] as int?;
  if (max == null) return '';
  return min == null ? 'لحد $max فرد' : 'من $min لـ $max فرد';
}

/// Filters for [HallService.fetch]; nulls mean "any".
class HallFilters {
  const HallFilters({this.hallType, this.occasion, this.governorate, this.area, this.guests, this.priceMax, this.query});

  final String? hallType;
  final String? occasion;
  final String? governorate;
  final String? area;

  /// Number of guests — only halls whose capacity fits it.
  final int? guests;
  final num? priceMax;
  final String? query;

  /// How many filters (beyond the type chips and search) are on.
  int get activeCount => [occasion, governorate, area, guests, priceMax].where((v) => v != null).length;

  HallFilters copyWith({String? hallType, bool clearHallType = false, String? query}) => HallFilters(
        hallType: clearHallType ? null : (hallType ?? this.hallType),
        occasion: occasion,
        governorate: governorate,
        area: area,
        guests: guests,
        priceMax: priceMax,
        query: query ?? this.query,
      );
}

/// Event venues — migration 0070.
class HallService {
  HallService._();

  static const _table = 'event_halls';

  static String shareUrl(String id) => 'https://mogtama3y.com/#/halls/$id';

  static String _clean(String? s) => s?.trim().replaceAll(RegExp(r'[%,()*]'), ' ') ?? '';

  /// Active halls matching [f], featured first then newest.
  static Future<List<Map<String, dynamic>>> fetch([HallFilters f = const HallFilters(), int limit = 60]) async {
    var q = _db.from(_table).select().eq('is_active', true);
    if (f.hallType != null) q = q.eq('hall_type', f.hallType!);
    if (f.occasion != null) q = q.contains('occasions', [f.occasion!]);
    if (f.governorate != null) q = q.eq('governorate', f.governorate!);
    final area = _clean(f.area);
    if (area.isNotEmpty) q = q.ilike('area', '%$area%');
    if (f.guests != null) {
      q = q.gte('capacity_max', f.guests!).or('capacity_min.is.null,capacity_min.lte.${f.guests!}');
    }
    if (f.priceMax != null) q = q.lte('price_from', f.priceMax!);
    final text = _clean(f.query);
    if (text.isNotEmpty) q = q.ilike('name', '%$text%');
    final rows = await q.order('is_featured', ascending: false).order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  static Future<Map<String, dynamic>?> get(String id) async =>
      await _db.from(_table).select().eq('id', id).maybeSingle();

  /// The signed-in user's halls (shown and hidden).
  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _db.from(_table).select().eq('owner_id', uid).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// Lists a hall for the signed-in user; returns its id.
  static Future<String> create(Map<String, dynamic> data) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw StateError('not signed in');
    final row = await _db.from(_table).insert({...data, 'owner_id': uid}).select('id').single();
    return row['id'] as String;
  }

  static Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.from(_table).update(data).eq('id', id);
  }

  static Future<void> setActive(String id, bool active) => update(id, {'is_active': active});

  static Future<void> delete(String id) async {
    await _db.from(_table).delete().eq('id', id);
  }

  /// "أنا مهتم" — notifies the owner in the app.
  static Future<void> expressInterest(String id) async {
    await _db.rpc('express_interest_in_hall', params: {'p_hall_id': id});
  }
}
