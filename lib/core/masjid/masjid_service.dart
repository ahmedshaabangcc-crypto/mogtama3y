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
    'chat': 'شات المسجد والأعضاء',
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

  // --------------------------------------------- members (0081)
  /// «انضم للمسجد» — also follows it (notifications on).
  static Future<void> join(String id, {bool? primary}) => _db.rpc('masjid_join', params: {'p_mosque': id, 'p_primary': primary});

  static Future<void> leave(String id) => _db.rpc('masjid_leave', params: {'p_mosque': id});

  static Future<void> setPrimary(String id) => _db.rpc('masjid_set_primary', params: {'p_mosque': id});

  /// [{id, name, address, area, lat, lng, verified, is_primary, member_count, unread, last_message_at, joined_at}]
  static Future<List<Map<String, dynamic>>> myMosques() async => _rows(await _db.rpc('my_mosques'));

  /// Mosques within [radiusM] metres (within = true), or the nearest few
  /// beyond (within = false): [{…, member_count, distance_m, within, is_member}].
  static Future<List<Map<String, dynamic>>> joinCandidates(double lat, double lng, {int radiusM = 500, int fallback = 5}) async =>
      _rows(await _db.rpc('masjid_join_candidates', params: {'p_lat': lat, 'p_lng': lng, 'p_radius_m': radiusM, 'p_fallback': fallback}));

  /// «قريب منك»: [{kind: urgent|lesson|need|competition, item_id, mosque_id, mosque_name, distance_km, title, subtitle, extra, at}]
  static Future<List<Map<String, dynamic>>> nearbyFeed({double? lat, double? lng, double km = 3}) async =>
      _rows(await _db.rpc('masjid_nearby_feed', params: {'p_lat': lat, 'p_lng': lng, 'p_km': km, 'p_limit': 30}));

  /// Moderators: [{user_id, full_name, joined_at, is_admin, messages, sanction, sanction_until}]
  static Future<List<Map<String, dynamic>>> members(String id) async => _rows(await _db.rpc('masjid_members', params: {'p_mosque': id}));

  // ------------------------------------------------ mosque chat (0081)
  /// Oldest first: [{id, author_id, author_name, author_is_admin, body, reply_to, reply_name, reply_body, created_at, mine}]
  static Future<List<Map<String, dynamic>>> chatMessages(String id, {String? after, String? before, int limit = 60}) async =>
      _rows(await _db.rpc('masjid_chat_messages', params: {'p_mosque': id, 'p_after': after, 'p_before': before, 'p_limit': limit}));

  static Future<void> chatSend(String id, String body, {String? replyTo}) =>
      _db.rpc('masjid_chat_send', params: {'p_mosque': id, 'p_body': body, 'p_reply_to': replyTo});

  static Future<void> chatMarkRead(String id) => _db.rpc('masjid_chat_mark_read', params: {'p_mosque': id});

  /// True when the message is now hidden.
  static Future<bool> chatReport(String messageId, String reason) async =>
      await _db.rpc('masjid_chat_report', params: {'p_message': messageId, 'p_reason': reason}) == true;

  /// Own message: deleted. Moderator: hidden.
  static Future<void> chatDelete(String messageId, {String? reason}) =>
      _db.rpc('masjid_chat_delete', params: {'p_message': messageId, 'p_reason': reason});

  /// [kind] 'mute' (needs [minutes]) or 'ban' ([minutes] null = permanent).
  static Future<void> chatSanction(String mosqueId, String userId, String kind, {int? minutes, String? reason}) => _db.rpc('masjid_chat_sanction',
      params: {'p_mosque': mosqueId, 'p_user': userId, 'p_kind': kind, 'p_minutes': minutes, 'p_reason': reason});

  static Future<void> chatLift(String mosqueId, String userId) => _db.rpc('masjid_chat_lift', params: {'p_mosque': mosqueId, 'p_user': userId});

  static Future<List<Map<String, dynamic>>> adminChatReports() async => _rows(await _db.rpc('admin_mosque_chat_reports'));

  static Future<void> adminChatRestore(String messageId) => _db.rpc('admin_restore_mosque_chat_message', params: {'p_message': messageId});

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
