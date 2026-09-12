import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real "جروب الحي" (neighborhood group) — a tier above the building
/// union. See backend/migrations/0028_neighborhood_groups.sql.
/// Membership is self-declared with no verification, per Ahmed's
/// explicit instruction.
class NeighborhoodService {
  NeighborhoodService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchMyNeighborhoods() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client
        .from('neighborhood_members')
        .select('neighborhood:neighborhoods(id, name, city, governorate)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String> joinOrCreate({
    required String name,
    String? googlePlaceId,
    String? city,
    String? governorate,
    double? lat,
    double? lng,
  }) async {
    final result = await _client.rpc('join_or_create_neighborhood', params: {
      'p_name': name,
      'p_google_place_id': googlePlaceId,
      'p_city': city,
      'p_governorate': governorate,
      'p_lat': lat,
      'p_lng': lng,
    });
    return result as String;
  }

  static Future<void> leave(String neighborhoodId) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return;
    await _client.from('neighborhood_members').delete().eq('neighborhood_id', neighborhoodId).eq('user_id', userId);
  }

  static Future<List<Map<String, dynamic>>> fetchPosts(String neighborhoodId) async {
    final rows = await _client
        .from('neighborhood_posts')
        .select('*, author:profiles(full_name)')
        .eq('neighborhood_id', neighborhoodId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> createPost({required String neighborhoodId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('neighborhood_posts').insert({
      'neighborhood_id': neighborhoodId,
      'author_id': userId,
      'body': body,
    });
  }

  static Future<List<Map<String, dynamic>>> fetchChatMessages(String neighborhoodId) async {
    final rows = await _client
        .from('neighborhood_chat_messages')
        .select('*, sender:profiles(full_name)')
        .eq('neighborhood_id', neighborhoodId)
        .order('created_at', ascending: true)
        .limit(200);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> sendChatMessage({required String neighborhoodId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('neighborhood_chat_messages').insert({
      'neighborhood_id': neighborhoodId,
      'sender_id': userId,
      'body': body,
    });
  }
}
