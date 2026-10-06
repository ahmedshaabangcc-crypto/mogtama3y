import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

// Labels for the coded columns — keys must match the checks in
// migration 0069_tutoring.sql.

const tutorSubjects = <String, String>{
  'arabic': 'عربي',
  'english': 'إنجليزي',
  'math': 'رياضيات',
  'science': 'علوم',
  'physics': 'فيزياء',
  'chemistry': 'كيمياء',
  'biology': 'أحياء',
  'social_studies': 'دراسات',
  'french': 'فرنساوي',
  'german': 'ألماني',
  'quran': 'قرآن',
  'programming': 'برمجة',
  'music': 'موسيقى',
  'drawing': 'رسم',
  'other': 'تانية',
};

const tutorStages = <String, String>{
  'primary': 'ابتدائي',
  'preparatory': 'إعدادي',
  'secondary': 'ثانوي',
  'university': 'جامعة',
  'adults': 'كبار / كورسات',
};

const tutorCurricula = <String, String>{
  'arabic': 'عربي',
  'languages': 'لغات',
  'ig': 'IG',
  'american': 'أمريكان',
  'ib': 'IB',
};

const tutorModes = <String, String>{
  'student_home': 'في البيت عند الطالب',
  'tutor_place': 'عند المدرس',
  'center': 'سنتر',
  'online': 'أونلاين',
};

const tutorPriceUnits = <String, String>{
  'session': 'الحصة',
  'month': 'الشهر',
};

/// "250 ج.م / الحصة".
String tutorPrice(num? price, String? unit) =>
    '${NumberFormat('#,##0').format(price ?? 0)} ج.م / ${tutorPriceUnits[unit] ?? 'الحصة'}';

/// Labels for a list of codes, e.g. subjects → "رياضيات، فيزياء".
String tutorLabels(Object? codes, Map<String, String> labels) =>
    ((codes as List?)?.cast<String>() ?? const []).map((c) => labels[c] ?? c).join('، ');

/// Egyptian mobile in the 01xxxxxxxxx form: Arabic-Indic digits, spaces,
/// dashes and a +20 / 0020 prefix are accepted and normalised. Null if
/// it isn't a valid mobile number.
String? normaliseTutorPhone(String raw) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  var d = raw.split('').map((c) {
    final i = arabic.indexOf(c);
    return i >= 0 ? '$i' : c;
  }).join().replaceAll(RegExp(r'[^0-9]'), '');
  if (d.startsWith('0020')) d = d.substring(4);
  if (d.startsWith('20') && d.length == 12) d = d.substring(2);
  if (d.length == 10 && d.startsWith('1')) d = '0$d';
  return RegExp(r'^01[0125]\d{8}$').hasMatch(d) ? d : null;
}

/// Filters for [TutoringService.fetch]; nulls mean "any".
class TutorFilters {
  const TutorFilters({
    this.subject,
    this.stage,
    this.mode,
    this.governorate,
    this.area,
    this.priceMax,
    this.priceUnit,
  });

  final String? subject;
  final String? stage;
  final String? mode;
  final String? governorate;
  final String? area;
  final num? priceMax;
  final String? priceUnit;

  /// How many filters (beyond the subject chips) are on.
  int get activeCount => [stage, mode, governorate, area, priceMax, priceUnit].where((v) => v != null).length;

  TutorFilters withSubject(String? subject) => TutorFilters(
        subject: subject,
        stage: stage,
        mode: mode,
        governorate: governorate,
        area: area,
        priceMax: priceMax,
        priceUnit: priceUnit,
      );
}

/// Private tutoring — migration 0069.
class TutoringService {
  TutoringService._();

  static const _table = 'tutor_listings';

  static String shareUrl(String id) => 'https://mogtama3y.com/#/tutoring/$id';

  /// Active listings matching [f], newest first.
  static Future<List<Map<String, dynamic>>> fetch([TutorFilters f = const TutorFilters(), int limit = 60]) async {
    var q = _db.from(_table).select().eq('is_active', true);
    if (f.subject != null) q = q.contains('subjects', [f.subject!]);
    if (f.stage != null) q = q.contains('stages', [f.stage!]);
    if (f.mode != null) q = q.contains('modes', [f.mode!]);
    if (f.governorate != null) q = q.eq('governorate', f.governorate!);
    final area = f.area?.trim().replaceAll(RegExp(r'[%,()*]'), ' ') ?? '';
    if (area.isNotEmpty) q = q.ilike('area', '%$area%');
    if (f.priceMax != null) q = q.lte('price', f.priceMax!);
    if (f.priceUnit != null) q = q.eq('price_unit', f.priceUnit!);
    final rows = await q.order('created_at', ascending: false).limit(limit);
    return List<Map<String, dynamic>>.from(rows);
  }

  static Future<Map<String, dynamic>?> get(String id) async =>
      await _db.from(_table).select().eq('id', id).maybeSingle();

  /// The signed-in user's listings (active and hidden).
  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _db.from(_table).select().eq('owner_id', uid).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  /// The signed-in user's profile phone, to prefill the contact fields.
  static Future<String?> myPhone() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return null;
    final row = await _db.from('profiles').select('phone').eq('id', uid).maybeSingle();
    return row?['phone'] as String?;
  }

  /// Posts a listing for the signed-in user; returns its id. The name and
  /// photo shown come from the profile (a trigger fills them).
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

  /// "عايز أحجز" — notifies the tutor.
  static Future<void> expressInterest(String id) async {
    await _db.rpc('express_interest_in_tutor', params: {'p_listing_id': id});
  }
}
