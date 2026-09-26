import 'package:supabase_flutter/supabase_flutter.dart';

/// Phone numbers are no longer selectable from `profiles` directly
/// (migration 0038) — the server decides who may see whose number via
/// the `get_contact_phones` RPC: your own, a president/board member
/// reviewing their building's members, an owner viewing their tenants,
/// a super admin, or a seller whose active listing shows the number.
class ContactPhones {
  ContactPhones._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// user id -> phone, only for the ids the caller is allowed to see.
  static Future<Map<String, String>> fetch(Iterable<String> userIds) async {
    final ids = userIds.toSet().toList();
    if (ids.isEmpty || _client.auth.currentUser == null) return {};
    final rows = await _client.rpc('get_contact_phones', params: {'p_user_ids': ids});
    return {
      for (final row in List<Map<String, dynamic>>.from(rows as List))
        row['user_id'] as String: row['phone'] as String,
    };
  }

  /// Fills `row[profileKey]['phone']` in place for every row, looking up
  /// the user id at `row[userIdKey]`. Rows whose phone isn't visible to
  /// the caller are left without one.
  static Future<void> attach(
    List<Map<String, dynamic>> rows, {
    required String userIdKey,
    required String profileKey,
  }) async {
    final phones = await fetch(rows.map((r) => r[userIdKey]).whereType<String>());
    for (final row in rows) {
      final profile = row[profileKey];
      final phone = phones[row[userIdKey]];
      if (profile is Map<String, dynamic> && phone != null) {
        profile['phone'] = phone;
      }
    }
  }
}
