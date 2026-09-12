import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real union community feed — see
/// backend/migrations/0029_union_feed.sql. Was previously reachable
/// from the home screen with zero auth check and 100% fabricated
/// content (fake building, fake residents, fake engagement) — fixed as
/// a priority trust issue, not just an incomplete feature.
class PostsService {
  PostsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchPosts(String buildingId) async {
    final rows = await _client.rpc('fetch_building_posts', params: {'p_building_id': buildingId});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<Set<String>> fetchMyReactedPostIds(List<String> postIds) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null || postIds.isEmpty) return {};
    final rows = await _client.from('post_reactions').select('post_id').eq('user_id', userId).inFilter('post_id', postIds);
    return List<Map<String, dynamic>>.from(rows as List).map((r) => r['post_id'] as String).toSet();
  }

  static Future<void> createPost({required String buildingId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('posts').insert({
      'building_id': buildingId,
      'author_id': userId,
      'body': body,
    });
  }

  static Future<void> toggleReaction({required String postId, required bool currentlyReacted}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    if (currentlyReacted) {
      await _client.from('post_reactions').delete().eq('post_id', postId).eq('user_id', userId);
    } else {
      await _client.from('post_reactions').insert({'post_id': postId, 'user_id': userId});
    }
  }

  static Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    final rows = await _client
        .from('post_comments')
        .select('*, author:profiles(full_name)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> addComment({required String postId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('post_comments').insert({
      'post_id': postId,
      'author_id': userId,
      'body': body,
    });
  }
}
