import 'package:supabase_flutter/supabase_flutter.dart';

/// Building members' names as the signed-in user may see them: a member
/// who chose «إظهار اسم العائلة فقط» shows as «عائلة + family name» to
/// other residents, while the president/board (and the member) see the
/// full name. Resolved server-side by building_member_names (migration
/// 0077), so the rule lives in one place.
class MemberNames {
  MemberNames._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// user_id → display name for [buildingId]. Empty on any error, so the
  /// caller falls back to whatever name it already has.
  static Future<Map<String, String>> fetch(String buildingId) async {
    try {
      final rows = await _client.rpc('building_member_names', params: {'p_building_id': buildingId});
      return {
        for (final r in List<Map<String, dynamic>>.from(rows as List))
          if (r['user_id'] != null && r['display_name'] != null) r['user_id'] as String: r['display_name'] as String,
      };
    } catch (_) {
      return const {};
    }
  }

  /// Saves the «اسم العائلة فقط» choice on the caller's membership(s).
  static Future<void> setFamilyNameOnly(bool value, {String? buildingId}) async {
    await _client.rpc('set_my_name_privacy', params: {'p_family_only': value, 'p_building_id': buildingId});
  }
}
