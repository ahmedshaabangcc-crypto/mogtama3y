import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

// Labels for the coded columns — keys must match the checks in
// migration 0071_pets.sql.

const petKinds = <String, String>{
  'sale': 'للبيع',
  'adoption': 'للتبني',
  'mating': 'تزاوج',
  'lost': 'مفقود',
  'found': 'لقيته',
  'supplies': 'مستلزمات',
};

const petAnimals = <String, String>{
  'cat': 'قطط',
  'dog': 'كلاب',
  'bird': 'طيور',
  'fish': 'أسماك',
  'rabbit': 'أرانب',
  'turtle': 'سلاحف',
  'hamster': 'هامستر',
  'other': 'تانية',
};

const petGenders = <String, String>{
  'male': 'ذكر',
  'female': 'أنثى',
  'unknown': 'غير معروف',
};

const petConditions = <String, String>{
  'new': 'جديد',
  'used': 'مستعمل',
};

/// How a closed listing ended (quick close from "إعلاناتي").
const petOutcomes = <String, String>{
  'reunited': 'اتلقى ورجع لأهله',
  'adopted': 'اتبنى',
  'sold': 'اتباع',
};

/// Adoption, lost and found are always free — no price field.
bool petKindIsFree(String? kind) => kind == 'adoption' || kind == 'lost' || kind == 'found';

/// Lost / found reports carry the last-seen date and place.
bool petKindIsLostFound(String? kind) => kind == 'lost' || kind == 'found';

IconData petAnimalIcon(String? animal) => switch (animal) {
      'bird' => Icons.flutter_dash_rounded,
      'fish' => Icons.set_meal_rounded,
      _ => Icons.pets_rounded,
    };

/// "2,500 ج.م", or the free label for adoption / lost / found.
String petPrice(Map<String, dynamic> item) {
  final kind = item['kind'] as String?;
  if (kind == 'adoption') return 'ببلاش للتبني';
  if (petKindIsLostFound(kind)) return petKinds[kind]!;
  final price = item['price'] as num?;
  if (price == null || price <= 0) return kind == 'mating' ? 'بالاتفاق' : '';
  return '${NumberFormat('#,##0').format(price)} ج.م';
}

/// Filters for [PetService.fetch]; nulls mean "any".
class PetFilters {
  const PetFilters({this.kind, this.animal, this.governorate, this.area, this.priceMax, this.query});

  final String? kind;
  final String? animal;
  final String? governorate;
  final String? area;
  final num? priceMax;
  final String? query;

  /// How many sheet filters (beyond the chips) are on.
  int get activeCount => [governorate, area, priceMax].where((v) => v != null).length;

  PetFilters copyWith({String? kind, String? animal, bool clearKind = false, bool clearAnimal = false, String? query}) => PetFilters(
        kind: clearKind ? null : (kind ?? this.kind),
        animal: clearAnimal ? null : (animal ?? this.animal),
        governorate: governorate,
        area: area,
        priceMax: priceMax,
        query: query ?? this.query,
      );

  PetFilters withSheet({String? governorate, String? area, num? priceMax}) =>
      PetFilters(kind: kind, animal: animal, governorate: governorate, area: area, priceMax: priceMax, query: query);
}

/// Pets — migration 0071.
class PetService {
  PetService._();

  static const _table = 'pet_listings';

  /// Every readable column: the phone is not one of them (column grants),
  /// it comes per listing from [phone].
  static const _cols = 'id, owner_id, kind, animal, breed, age_text, gender, vaccinated, condition, title, '
      'description, price, negotiable, governorate, area, last_seen_date, last_seen_area, has_whatsapp, '
      'images, is_active, outcome, created_at, updated_at';

  static String shareUrl(String id) => 'https://mogtama3y.com/#/pets/$id';

  /// Active listings matching [f], newest first.
  static Future<List<Map<String, dynamic>>> fetch([PetFilters f = const PetFilters(), int limit = 60]) async {
    var q = _db.from(_table).select(_cols).eq('is_active', true);
    if (f.kind != null) q = q.eq('kind', f.kind!);
    if (f.animal != null) q = q.eq('animal', f.animal!);
    if (f.governorate != null) q = q.eq('governorate', f.governorate!);
    final area = _clean(f.area);
    if (area.isNotEmpty) q = q.ilike('area', '%$area%');
    if (f.priceMax != null) q = q.lte('price', f.priceMax!);
    final text = _clean(f.query);
    if (text.isNotEmpty) q = q.or('title.ilike.%$text%,breed.ilike.%$text%');
    final rows = await q.order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  // Characters that would break a PostgREST filter.
  static String _clean(String? s) => s?.trim().replaceAll(RegExp(r'[%,()*.:]'), ' ').trim() ?? '';

  static Future<Map<String, dynamic>?> get(String id) async =>
      await _db.from(_table).select(_cols).eq('id', id).maybeSingle();

  /// The signed-in user's listings (active and closed).
  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _db.from(_table).select(_cols).eq('owner_id', uid).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// The poster's phone (signed-in users only).
  static Future<String?> phone(String id) async =>
      await _db.rpc('pet_listing_phone', params: {'p_listing_id': id}) as String?;

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

  /// Hide / show again (showing clears a quick-close outcome).
  static Future<void> setActive(String id, bool active) =>
      update(id, {'is_active': active, if (active) 'outcome': null});

  /// Quick close: "اتلقى" / "اتبنى" / "اتباع" (the row goes inactive).
  static Future<void> close(String id, String outcome) => update(id, {'outcome': outcome, 'is_active': false});

  static Future<void> delete(String id) async {
    await _db.from(_table).delete().eq('id', id);
  }

  /// "أنا مهتم" / "عندي معلومة" — notifies the owner.
  static Future<void> expressInterest(String id) async {
    await _db.rpc('express_interest_in_pet', params: {'p_listing_id': id});
  }
}
