import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

List<Map<String, dynamic>> _rows(dynamic rows) => List<Map<String, dynamic>>.from(rows as List);

/// «غرف الدردشة» — public chat rooms (migration 0078, مُجتمعي only).
///
/// Messages never carry an account id: `author` is an opaque room id of
/// the writer (stable across nickname changes). Anyone can read; writing
/// needs a verified phone and a room nickname (checked server-side).
class RoomsService {
  RoomsService._();

  /// Active rooms, most active first: [{id, name, description, kind,
  /// governorate, area, icon, online_count, recent_count, last_message_at,
  /// near}] — near 1 = your district, 2 = your governorate, 0 = neither.
  static Future<List<Map<String, dynamic>>> rooms() async => _rows(await _db.rpc('list_chat_rooms'));

  /// The room plus what I may do there: {name, …, online_count, signed_in,
  /// phone_verified, nickname, public_id, can_write, blocked_reason
  /// ('guest'|'no_phone'|'no_nickname'|'muted'|'banned'|'archived'),
  /// sanction_until, is_admin, can_moderate}. Null when it doesn't exist.
  static Future<Map<String, dynamic>?> room(String id) async {
    final r = await _db.rpc('get_chat_room', params: {'p_room': id});
    return r == null ? null : Map<String, dynamic>.from(r as Map);
  }

  /// Oldest first: [{id, author, nickname, verified, body, reply_to,
  /// reply_nickname, reply_body, created_at, mine}].
  static Future<List<Map<String, dynamic>>> messages(String roomId, {String? after, String? before, int limit = 60}) async =>
      _rows(await _db.rpc('room_messages', params: {'p_room': roomId, 'p_after': after, 'p_before': before, 'p_limit': limit}));

  /// [{author, nickname, verified, is_me}]
  static Future<List<Map<String, dynamic>>> online(String roomId) async => _rows(await _db.rpc('room_online', params: {'p_room': roomId}));

  /// "I'm here" — returns the online count.
  static Future<int> heartbeat(String roomId) async => (await _db.rpc('room_heartbeat', params: {'p_room': roomId}) as num).toInt();

  static Future<void> leave(String roomId) => _db.rpc('room_leave', params: {'p_room': roomId});

  /// {signed_in, phone_verified, nickname, public_id, can_change_at}
  static Future<Map<String, dynamic>> myProfile() async => Map<String, dynamic>.from(await _db.rpc('my_chat_profile') as Map);

  static Future<String> setNickname(String nickname) async =>
      await _db.rpc('set_chat_nickname', params: {'p_nickname': nickname}) as String;

  static Future<void> send(String roomId, String body, {String? replyTo}) =>
      _db.rpc('send_room_message', params: {'p_room': roomId, 'p_body': body, 'p_reply_to': replyTo});

  /// True when the message is now hidden.
  static Future<bool> report(String messageId, String reason) async =>
      await _db.rpc('report_room_message', params: {'p_message': messageId, 'p_reason': reason}) == true;

  static Future<void> ignore(String author, {bool on = true}) => _db.rpc('room_ignore', params: {'p_author': author, 'p_on': on});

  /// [{author, nickname}]
  static Future<List<Map<String, dynamic>>> ignored() async => _rows(await _db.rpc('my_room_ignores'));

  /// «كلّمه خاص» — a normal friend request. Returns 'sent' / 'friends'.
  static Future<String> friendRequest(String author) async =>
      await _db.rpc('room_friend_request', params: {'p_author': author}) as String;

  // ---- room moderators and the super admin
  static Future<void> hide(String messageId, {String? reason}) =>
      _db.rpc('mod_hide_room_message', params: {'p_message': messageId, 'p_reason': reason});

  /// Moderator: in that room (≤ 7 days). Super admin: every room (≤ 30 days).
  static Future<void> mute(String messageId, int minutes, {String? reason}) =>
      _db.rpc('mod_mute_room_user', params: {'p_message': messageId, 'p_minutes': minutes, 'p_reason': reason});

  // ---- super admin
  static Future<List<Map<String, dynamic>>> adminRooms() async => _rows(await _db.rpc('admin_list_chat_rooms'));

  static Future<String> adminSaveRoom({
    String? id,
    required String name,
    String? description,
    required String kind,
    String? governorate,
    String? area,
    String? icon,
    int sortOrder = 100,
    bool isActive = true,
  }) async =>
      await _db.rpc('admin_save_chat_room', params: {
        'p_id': id,
        'p_name': name,
        'p_description': description,
        'p_kind': kind,
        'p_governorate': governorate,
        'p_area': area,
        'p_icon': icon,
        'p_sort_order': sortOrder,
        'p_is_active': isActive,
      }) as String;

  static Future<void> adminSetModerator(String roomId, String nickname, {bool on = true}) =>
      _db.rpc('admin_set_room_moderator', params: {'p_room': roomId, 'p_nickname': nickname, 'p_on': on});

  /// [{user_id, nickname, full_name, email, created_at}]
  static Future<List<Map<String, dynamic>>> adminModerators(String roomId) async =>
      _rows(await _db.rpc('admin_list_room_moderators', params: {'p_room': roomId}));

  /// Reported or hidden messages with the real account behind each.
  static Future<List<Map<String, dynamic>>> adminReports() async => _rows(await _db.rpc('admin_room_reports'));

  /// A room's latest messages with nickname → real name / email.
  static Future<List<Map<String, dynamic>>> adminMessages(String roomId) async =>
      _rows(await _db.rpc('admin_room_messages', params: {'p_room': roomId, 'p_limit': 150}));

  static Future<void> adminRestore(String messageId) => _db.rpc('admin_restore_room_message', params: {'p_message': messageId});
  static Future<void> adminDelete(String messageId) => _db.rpc('admin_delete_room_message', params: {'p_message': messageId});

  /// Ban the author from every room; [hours] null = permanent.
  static Future<void> adminBan(String messageId, {int? hours, String? reason}) =>
      _db.rpc('admin_ban_chat_user', params: {'p_message': messageId, 'p_hours': hours, 'p_reason': reason});

  static Future<List<Map<String, dynamic>>> adminSanctions() async => _rows(await _db.rpc('admin_list_chat_sanctions'));
  static Future<void> adminLift(String sanctionId) => _db.rpc('admin_lift_chat_sanction', params: {'p_id': sanctionId});

  static Future<List<String>> adminBannedWords() async => [
        // setof text: plain strings (or {fn: value} rows, depending on the API version).
        for (final w in await _db.rpc('admin_list_banned_words') as List) w is Map ? '${w.values.first}' : '$w',
      ];
  static Future<void> adminSetBannedWord(String word, {bool on = true}) =>
      _db.rpc('admin_set_banned_word', params: {'p_word': word, 'p_on': on});

  static Future<List<Map<String, dynamic>>> adminLog() async => _rows(await _db.rpc('admin_chat_mod_log'));

  /// «امسح الرسايل الأقدم من 30 يوم» — returns how many were deleted.
  static Future<int> purgeOld() async => (await _db.rpc('purge_old_room_messages') as num).toInt();
}
