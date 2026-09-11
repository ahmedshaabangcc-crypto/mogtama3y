import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real notifications — see backend/migrations/0016_notifications.sql.
/// Rows are only ever created from inside other SECURITY DEFINER
/// functions (e.g. review_union_member, create_union_due), never
/// inserted directly by the client.
class NotificationsService {
  NotificationsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchMine() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client.from('notifications').select().eq('user_id', userId).order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> markRead(String id) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', id);
  }

  static Future<void> markAllRead() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return;
    await _client.from('notifications').update({'is_read': true}).eq('user_id', userId).eq('is_read', false);
  }
}
