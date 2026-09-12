import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real building-wide neighbor chat — see
/// backend/migrations/0025_building_chat.sql. A flat group chat scoped
/// to one building; every verified member reads and writes to the same
/// stream (no threads, no direct messages).
class BuildingChatService {
  BuildingChatService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchMessages(String buildingId) async {
    final rows = await _client
        .from('building_chat_messages')
        .select('*, sender:profiles(full_name)')
        .eq('building_id', buildingId)
        .order('created_at', ascending: true)
        .limit(200);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<Map<String, dynamic>?> fetchLastMessage(String buildingId) async {
    return _client
        .from('building_chat_messages')
        .select('body, created_at')
        .eq('building_id', buildingId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  static Future<void> sendMessage({required String buildingId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('building_chat_messages').insert({
      'building_id': buildingId,
      'sender_id': userId,
      'body': body,
    });
  }
}
