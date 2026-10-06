import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

// Labels for the coded columns — keys must match the checks in
// migration 0072_kids_gear.sql.

const kidsCategories = <String, String>{
  'stroller': 'عربيات أطفال',
  'car_seat': 'كراسي عربية',
  'crib': 'سراير ومهود',
  'high_chair': 'كراسي أكل',
  'toys': 'لعب',
  'clothes': 'هدوم',
  'school': 'شنط ومستلزمات مدرسة',
  'books': 'كتب وقصص',
  'feeding': 'مستلزمات رضاعة',
  'furniture': 'أثاث أوضة أطفال',
  'bikes': 'دراجات وسكوترات',
  'other': 'تانية',
};

const kidsCategoryIcons = <String, IconData>{
  'stroller': Icons.child_friendly_rounded,
  'car_seat': Icons.airline_seat_recline_normal_rounded,
  'crib': Icons.crib_rounded,
  'high_chair': Icons.chair_alt_rounded,
  'toys': Icons.toys_rounded,
  'clothes': Icons.checkroom_rounded,
  'school': Icons.backpack_rounded,
  'books': Icons.menu_book_rounded,
  'feeding': Icons.baby_changing_station_rounded,
  'furniture': Icons.bed_rounded,
  'bikes': Icons.pedal_bike_rounded,
  'other': Icons.category_rounded,
};

const kidsConditions = <String, String>{
  'new': 'جديد',
  'like_new': 'زي الجديد',
  'good': 'مستعمل حالة كويسة',
  'needs_repair': 'محتاج تصليح',
};

const kidsAgeRanges = <String, String>{
  '0_6m': '0-6 شهور',
  '6_12m': '6-12 شهر',
  '1_3y': '1-3 سنين',
  '3_6y': '3-6 سنين',
  '6_12y': '6-12 سنة',
  '12_plus': '12+ سنة',
};

const kidsGenders = <String, String>{
  'any': 'الاتنين',
  'boy': 'ولد',
  'girl': 'بنت',
};

/// Categories where a safety reminder is shown (car seats and cribs).
const kidsSafetyCategories = {'car_seat', 'crib'};

const kidsSafetyNote = 'اتأكد من سلامة كرسي العربية والسرير قبل الشراء: مفيش كسر أو شروخ، الأحزمة والأقفال شغالة، ومش عدّى عليه حادثة.';

/// "2,500 ج.م" or "ببلاش" for a giveaway.
String kidsPrice(Map<String, dynamic> item) =>
    item['is_free'] == true ? 'ببلاش' : '${NumberFormat('#,##0').format(item['price'] ?? 0)} ج.م';

/// Filters for [KidsService.fetch]; nulls mean "any".
class KidsFilters {
  const KidsFilters({
    this.category,
    this.condition,
    this.ageRange,
    this.governorate,
    this.area,
    this.priceMax,
    this.freeOnly = false,
    this.query,
  });

  final String? category;
  final String? condition;
  final String? ageRange;
  final String? governorate;
  final String? area;
  final num? priceMax;
  final bool freeOnly;
  final String? query;

  /// How many filters (beyond the category chip and search) are on.
  int get activeCount => [condition, ageRange, governorate, area, priceMax].where((v) => v != null).length + (freeOnly ? 1 : 0);

  KidsFilters copyWith({String? category, bool clearCategory = false, String? query}) => KidsFilters(
        category: clearCategory ? null : (category ?? this.category),
        condition: condition,
        ageRange: ageRange,
        governorate: governorate,
        area: area,
        priceMax: priceMax,
        freeOnly: freeOnly,
        query: query ?? this.query,
      );

  /// Same category / search, new sheet filters.
  KidsFilters withSheet(KidsFilters s) => KidsFilters(
        category: category,
        condition: s.condition,
        ageRange: s.ageRange,
        governorate: s.governorate,
        area: s.area,
        priceMax: s.priceMax,
        freeOnly: s.freeOnly,
        query: query,
      );
}

/// Kids & baby gear — migration 0072.
class KidsService {
  KidsService._();

  static const _table = 'kids_listings';

  /// Every column guests may read (the phone is for signed-in users only).
  static const _publicCols =
      'id, owner_id, category, title, condition, age_range, gender, clothes_size, brand, price, is_free, swap_allowed, '
      'governorate, area, description, images, phone_on_whatsapp, is_active, is_sold, created_at, updated_at';

  static String shareUrl(String id) => 'https://mogtama3y.com/#/kids/$id';

  static String _clean(String s) => s.trim().replaceAll(RegExp(r'[%,()*]'), ' ');

  /// Active, unsold listings matching [f], newest first.
  static Future<List<Map<String, dynamic>>> fetch([KidsFilters f = const KidsFilters(), int limit = 60]) async {
    var q = _db.from(_table).select(_publicCols).eq('is_active', true).eq('is_sold', false);
    if (f.category != null) q = q.eq('category', f.category!);
    if (f.condition != null) q = q.eq('condition', f.condition!);
    if (f.ageRange != null) q = q.eq('age_range', f.ageRange!);
    if (f.governorate != null) q = q.eq('governorate', f.governorate!);
    final area = _clean(f.area ?? '');
    if (area.isNotEmpty) q = q.ilike('area', '%$area%');
    if (f.freeOnly) {
      q = q.eq('is_free', true);
    } else if (f.priceMax != null) {
      // A giveaway always fits a budget.
      q = q.or('is_free.eq.true,price.lte.${f.priceMax}');
    }
    final text = _clean(f.query ?? '');
    if (text.isNotEmpty) q = q.ilike('title', '%$text%');
    final rows = await q.order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// One listing; signed-in users also get the phone number.
  static Future<Map<String, dynamic>?> get(String id) async =>
      await _db.from(_table).select(_db.auth.currentUser == null ? _publicCols : '*').eq('id', id).maybeSingle();

  /// The signed-in user's listings (active, sold and hidden).
  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _db.from(_table).select().eq('owner_id', uid).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// Posts a listing for the signed-in user; returns its id.
  static Future<String> create(Map<String, dynamic> data) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw StateError('not signed in');
    final row = await _db.from(_table).insert({...data, 'owner_id': uid}).select('id').single();
    return row['id'] as String;
  }

  static Future<void> update(String id, Map<String, dynamic> data) async {
    await _db.from(_table).update(data).eq('id', id);
  }

  static Future<void> setSold(String id, bool sold) => update(id, {'is_sold': sold});

  static Future<void> setActive(String id, bool active) => update(id, {'is_active': active});

  static Future<void> delete(String id) async {
    await _db.from(_table).delete().eq('id', id);
  }

  /// "أنا مهتم" — notifies the owner.
  static Future<void> expressInterest(String id) async {
    await _db.rpc('express_interest_in_kids_item', params: {'p_listing_id': id});
  }

  /// wa.me link for an Egyptian mobile (01xxxxxxxxx → 201xxxxxxxxx).
  static Uri whatsappUri(String phone, String title) =>
      Uri.parse('https://wa.me/2$phone?text=${Uri.encodeComponent('السلام عليكم، بخصوص إعلانك «$title» على مُجتمعي')}');
}
