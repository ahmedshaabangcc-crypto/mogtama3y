import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real buyer/seller chat for سوق المستعمل listings — see
/// backend/migrations/0035_marketplace_chat.sql. A conversation is
/// identified by (listingId, buyerId); the seller is always
/// marketplace_listings.seller_id.
class MarketplaceChatService {
  MarketplaceChatService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchMessages({required String listingId, required String buyerId}) async {
    final rows = await _client
        .from('marketplace_messages')
        // marketplace_messages has two FKs to profiles (buyer_id,
        // sender_id) — name the sender one explicitly to avoid
        // PostgREST's PGRST201 ambiguous-embed error.
        .select('*, sender:profiles!marketplace_messages_sender_id_fkey(full_name)')
        .eq('listing_id', listingId)
        .eq('buyer_id', buyerId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> sendMessage({required String listingId, required String buyerId, required String body}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('marketplace_messages').insert({
      'listing_id': listingId,
      'buyer_id': buyerId,
      'sender_id': userId,
      'body': body,
    });
  }

  /// One row per conversation the caller is part of (as buyer or as the
  /// listing's seller), newest first — powers the "المحادثات" inbox.
  static Future<List<Map<String, dynamic>>> fetchMyConversations() async {
    final rows = await _client.rpc('fetch_marketplace_conversations');
    final list = List<Map<String, dynamic>>.from(rows as List);
    list.sort((a, b) => (b['last_message_at'] as String).compareTo(a['last_message_at'] as String));
    return list;
  }
}
