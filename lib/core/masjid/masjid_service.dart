import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_flavor.dart';

/// «مسجدي» — backend/migrations/0080_masjid.sql. Public reads work for
/// guests; everything that writes goes through RLS (content) or the
/// SECURITY DEFINER RPCs (claims, pledges, sponsorships, entries, follows).
/// The app never collects money: pledges are records the mosque confirms.
class MasjidService {
  MasjidService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static List<Map<String, dynamic>> _rows(dynamic r) => (r as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();

  /// Share link of a mosque page (the masjid app's own domain).
  static String shareUrl(String id) => '$masjidUrl/#/masjid/$id';

  static const roleTitles = {'imam': 'إمام', 'khatib': 'خطيب', 'amin': 'أمين المسجد', 'board': 'عضو مجلس إدارة المسجد'};

  static const permissionLabels = {
    'posts': 'الإعلانات',
    'lessons': 'الدروس والحلقات',
    'needs': 'الاحتياجات والمساهمات',
    'orphans': 'كفالة الأيتام',
    'competitions': 'المسابقات',
    'settings': 'بيانات المسجد والإقامة',
  };

  static const audienceLabels = {'all': 'للجميع', 'men': 'رجال', 'women': 'سيدات', 'kids': 'أطفال'};

  static const postKinds = {'announcement': 'إعلان', 'event': 'مناسبة', 'urgent': 'تنبيه عاجل', 'janaza': 'صلاة جنازة'};

  // ------------------------------------------------------------- browse
  static Future<List<Map<String, dynamic>>> nearby(double lat, double lng, {double km = 5, int limit = 40}) async =>
      _rows(await _db.rpc('nearby_mosques', params: {'p_lat': lat, 'p_lng': lng, 'p_km': km, 'p_limit': limit}));

  static Future<List<Map<String, dynamic>>> search(String q, {double? lat, double? lng}) async =>
      _rows(await _db.rpc('search_mosques', params: {'p_query': q, 'p_lat': lat, 'p_lng': lng, 'p_limit': 30}));

  static Future<Map<String, dynamic>?> get(String id) async {
    final r = await _db.rpc('get_mosque', params: {'p_id': id});
    return r == null ? null : Map<String, dynamic>.from(r as Map);
  }

  static Future<String> addMosque({required String name, required double lat, required double lng, String? address, String? area, String? governorate}) async {
    final r = await _db.rpc('masjid_add_mosque', params: {
      'p_name': name,
      'p_lat': lat,
      'p_lng': lng,
      'p_address': address,
      'p_area': area,
      'p_governorate': governorate,
    });
    return r as String;
  }

  // ------------------------------------------------------------- follow
  static Future<void> follow(String id, {required bool follow, bool notify = true}) =>
      _db.rpc('masjid_follow', params: {'p_mosque': id, 'p_follow': follow, 'p_notify': notify});

  static Future<List<Map<String, dynamic>>> followed() async => _rows(await _db.rpc('my_followed_mosques'));

  static Future<List<Map<String, dynamic>>> managed() async => _rows(await _db.rpc('my_managed_mosques'));

  // -------------------------------------------------------------- claims
  static Future<void> claim(String mosqueId, {required String role, required String phone, String? docPath, String? note}) =>
      _db.rpc('masjid_claim', params: {'p_mosque': mosqueId, 'p_role': role, 'p_phone': phone, 'p_doc_path': docPath, 'p_note': note});

  static Future<List<Map<String, dynamic>>> myClaims() async => _rows(await _db.rpc('masjid_my_claims'));

  static Future<List<Map<String, dynamic>>> adminClaims({String? status = 'pending'}) async =>
      _rows(await _db.rpc('admin_list_mosque_claims', params: {'p_status': status}));

  static Future<void> adminReview(String claimId, {required bool approve, String? note}) =>
      _db.rpc('admin_review_mosque_claim', params: {'p_claim': claimId, 'p_approve': approve, 'p_note': note});

  // ---------------------------------------------------------------- team
  static Future<List<Map<String, dynamic>>> team(String mosqueId) async => _rows(await _db.rpc('masjid_team', params: {'p_mosque': mosqueId}));

  static Future<String> addHelper(String mosqueId, {required String phone, required List<String> permissions, String? title}) async =>
      (await _db.rpc('masjid_add_helper', params: {'p_mosque': mosqueId, 'p_phone': phone, 'p_permissions': permissions, 'p_title': title})) as String;

  static Future<void> removeHelper(String mosqueId, String userId) =>
      _db.rpc('masjid_remove_helper', params: {'p_mosque': mosqueId, 'p_user': userId});

  static Future<void> updateSettings(String mosqueId, Map<String, dynamic> values) =>
      _db.rpc('masjid_update_settings', params: {'p_mosque': mosqueId, 'p': values});

  // --------------------------------------------------------------- posts
  static Future<List<Map<String, dynamic>>> posts(String mosqueId) async => _rows(await _db
      .from('mosque_posts')
      .select('id, kind, title, body, pinned, created_at')
      .eq('mosque_id', mosqueId)
      .order('pinned', ascending: false)
      .order('created_at', ascending: false)
      .limit(30));

  static Future<void> savePost(String mosqueId, {String? id, required String kind, required String title, String? body, bool pinned = false}) async {
    final row = {'kind': kind, 'title': title, 'body': body, 'pinned': pinned};
    if (id == null) {
      await _db.from('mosque_posts').insert({...row, 'mosque_id': mosqueId});
    } else {
      await _db.from('mosque_posts').update(row).eq('id', id);
    }
  }

  static Future<void> deleteRow(String table, String id) => _db.from(table).delete().eq('id', id);

  // ------------------------------------------------------------- lessons
  static Future<List<Map<String, dynamic>>> lessons(String mosqueId) async => _rows(await _db
      .from('mosque_lessons')
      .select('id, kind, title, sheikh, weekdays, start_time, after_prayer, audience, location, notes')
      .eq('mosque_id', mosqueId)
      .eq('active', true)
      .order('created_at')
      .limit(60));

  static Future<void> saveLesson(String mosqueId, Map<String, dynamic> row, {String? id}) async {
    if (id == null) {
      await _db.from('mosque_lessons').insert({...row, 'mosque_id': mosqueId});
    } else {
      await _db.from('mosque_lessons').update(row).eq('id', id);
    }
  }

  // --------------------------------------------------------------- needs
  static Future<List<Map<String, dynamic>>> needs(String mosqueId) async =>
      _rows(await _db.rpc('masjid_needs', params: {'p_mosque': mosqueId, 'p_include_closed': true}));

  static Future<void> saveNeed(String mosqueId, Map<String, dynamic> row, {String? id}) async {
    if (id == null) {
      await _db.from('mosque_needs').insert({...row, 'mosque_id': mosqueId});
    } else {
      await _db.from('mosque_needs').update(row).eq('id', id);
    }
  }

  static Future<void> setNeedStatus(String needId, String status) =>
      _db.rpc('masjid_set_need_status', params: {'p_need': needId, 'p_status': status});

  static Future<void> pledge(String needId, double amount, {String? note, bool anonymous = false}) =>
      _db.rpc('masjid_pledge', params: {'p_need': needId, 'p_amount': amount, 'p_note': note, 'p_anonymous': anonymous});

  static Future<List<Map<String, dynamic>>> contributions(String needId) async =>
      _rows(await _db.rpc('masjid_need_contributions', params: {'p_need': needId}));

  static Future<void> confirmContribution(String id) => _db.rpc('masjid_confirm_contribution', params: {'p_id': id});

  static Future<void> cancelContribution(String id) => _db.rpc('masjid_cancel_contribution', params: {'p_id': id});

  static Future<void> addCash(String needId, double amount, {String? donorName, String? note}) => _db.rpc('masjid_add_cash',
      params: {'p_need': needId, 'p_amount': amount, 'p_donor_name': donorName, 'p_note': note, 'p_anonymous': donorName == null || donorName.isEmpty});

  // ------------------------------------------------------------- orphans
  static Future<List<Map<String, dynamic>>> orphanPrograms(String mosqueId) async =>
      _rows(await _db.rpc('masjid_orphan_programs', params: {'p_mosque': mosqueId}));

  static Future<void> saveOrphanProgram(String mosqueId, Map<String, dynamic> row, {String? id}) async {
    if (id == null) {
      await _db.from('mosque_orphan_programs').insert({...row, 'mosque_id': mosqueId});
    } else {
      await _db.from('mosque_orphan_programs').update(row).eq('id', id);
    }
  }

  static Future<void> sponsor(String programId, double monthly, {String? note}) =>
      _db.rpc('masjid_sponsor', params: {'p_program': programId, 'p_monthly_amount': monthly, 'p_note': note});

  static Future<void> setSponsorshipStatus(String id, String status) =>
      _db.rpc('masjid_set_sponsorship_status', params: {'p_id': id, 'p_status': status});

  static Future<List<Map<String, dynamic>>> orphanSponsors(String programId) async =>
      _rows(await _db.rpc('masjid_orphan_sponsors', params: {'p_program': programId}));

  static Future<List<Map<String, dynamic>>> mySponsorships() async => _rows(await _db.rpc('masjid_my_sponsorships'));

  // -------------------------------------------------------- competitions
  static Future<List<Map<String, dynamic>>> competitions(String mosqueId) async => _rows(await _db
      .from('mosque_competitions')
      .select('id, title, description, schedule, registration_deadline, starts_on, status, results_published, created_at, '
          'mosque_competition_levels(id, name, details, age_group, sort)')
      .eq('mosque_id', mosqueId)
      .order('created_at', ascending: false)
      .limit(20));

  static Future<Map<String, Map<String, dynamic>>> competitionCounts(String mosqueId) async {
    final rows = _rows(await _db.rpc('masjid_competition_counts', params: {'p_mosque': mosqueId}));
    return {for (final r in rows) r['competition_id'] as String: r};
  }

  static Future<String> saveCompetition(String mosqueId, Map<String, dynamic> row, {String? id}) async {
    if (id == null) {
      final r = await _db.from('mosque_competitions').insert({...row, 'mosque_id': mosqueId}).select('id').single();
      return r['id'] as String;
    }
    await _db.from('mosque_competitions').update(row).eq('id', id);
    return id;
  }

  static Future<void> addLevel(String competitionId, String mosqueId, {required String name, String? details, String? ageGroup, int sort = 0}) =>
      _db.from('mosque_competition_levels').insert({
        'competition_id': competitionId,
        'mosque_id': mosqueId,
        'name': name,
        'details': details,
        'age_group': ageGroup,
        'sort': sort,
      });

  static Future<void> register(String competitionId, String levelId, {required String name, int? age, String? phone}) => _db.rpc(
      'masjid_register_competition',
      params: {'p_competition': competitionId, 'p_level': levelId, 'p_name': name, 'p_age': age, 'p_phone': phone});

  static Future<void> withdraw(String entryId) => _db.rpc('masjid_withdraw_entry', params: {'p_entry': entryId});

  static Future<List<Map<String, dynamic>>> entries(String competitionId) async =>
      _rows(await _db.rpc('masjid_competition_entries', params: {'p_competition': competitionId}));

  static Future<void> setResult(String entryId, {double? score, int? rank, String? note}) =>
      _db.rpc('masjid_set_entry_result', params: {'p_entry': entryId, 'p_score': score, 'p_rank': rank, 'p_note': note});

  static Future<void> publishResults(String competitionId, bool publish) =>
      _db.rpc('masjid_publish_results', params: {'p_competition': competitionId, 'p_publish': publish});

  static Future<List<Map<String, dynamic>>> results(String competitionId) async =>
      _rows(await _db.rpc('masjid_competition_results', params: {'p_competition': competitionId}));
}

/// "1,000" — Arabic-friendly money without decimals.
String masjidMoney(num? v) {
  final n = (v ?? 0).round();
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '${n < 0 ? '-' : ''}$b';
}

/// «اتدفع 500 من 1000 — باقي 500».
String needProgressText(num confirmed, num target) {
  final left = target - confirmed;
  if (left <= 0) return 'اكتمل بفضل الله: اتدفع ${masjidMoney(confirmed)} من ${masjidMoney(target)} ج.م';
  return 'اتدفع ${masjidMoney(confirmed)} من ${masjidMoney(target)} — باقي ${masjidMoney(left)} ج.م';
}
