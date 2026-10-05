import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get _db => Supabase.instance.client;

/// People nearby, friends and private chat — migration 0062.
///
/// Visibility is opt-in ([setDiscoverable]); positions are stored rounded
/// to ~550 m and others only ever get a rough `distance_label`. Chat is
/// friends-only. Friend states: 'none' | 'sent' | 'received' | 'friends'.
class PeopleService {
  PeopleService._();

  /// {discoverable: bool, area: String?, updated_at: String?}
  static Future<Map<String, dynamic>> myPresence() async =>
      Map<String, dynamic>.from(await _db.rpc('get_my_presence') as Map);

  /// Turn "اظهر للناس اللي حواليك" on (needs the position) or off (erases it).
  static Future<void> setDiscoverable(bool on, {double? lat, double? lng, String? area}) =>
      _db.rpc('set_discoverable', params: {'p_on': on, 'p_lat': lat, 'p_lng': lng, 'p_area': area});

  /// [{user_id, full_name, avatar_url, is_verified, area, distance_label, state}]
  static Future<List<Map<String, dynamic>>> nearby({required double lat, required double lng, double km = 3}) async {
    final rows = await _db.rpc('nearby_people', params: {'p_lat': lat, 'p_lng': lng, 'p_km': km});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Returns the new state: 'sent', or 'friends' when they had already asked.
  static Future<String> sendRequest(String userId) async =>
      await _db.rpc('send_friend_request', params: {'p_user': userId}) as String;

  static Future<void> respond(String userId, {required bool accept}) =>
      _db.rpc('respond_friend_request', params: {'p_user': userId, 'p_accept': accept});

  /// Unfriend, or cancel a request (either direction).
  static Future<void> remove(String userId) => _db.rpc('remove_friend', params: {'p_user': userId});

  /// Friends and pending requests: [{user_id, full_name, avatar_url,
  /// is_verified, state, last_message, last_message_at, unread}] —
  /// incoming requests first, then by latest activity.
  static Future<List<Map<String, dynamic>>> myFriends() async {
    final rows = await _db.rpc('my_friends');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> block(String userId) => _db.rpc('block_user', params: {'p_user': userId});
  static Future<void> unblock(String userId) => _db.rpc('unblock_user', params: {'p_user': userId});
  static Future<void> report(String userId, String reason) => _db.rpc('flag_user', params: {'p_user': userId, 'p_reason': reason});

  static Future<void> send(String toUserId, String body) =>
      _db.rpc('send_direct_message', params: {'p_to': toUserId, 'p_body': body});

  /// The conversation, oldest first: [{id, mine, body, created_at, read_at}].
  /// Also marks their messages to me as read.
  static Future<List<Map<String, dynamic>>> messages(String userId) async {
    final rows = await _db.rpc('fetch_direct_messages', params: {'p_user': userId});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Super admin: reports about people.
  static Future<List<Map<String, dynamic>>> adminFlags() async {
    final rows = await _db.rpc('admin_list_user_flags');
    return List<Map<String, dynamic>>.from(rows as List);
  }
}
