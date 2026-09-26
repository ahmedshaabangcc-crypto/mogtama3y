import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

/// Real recycling/بيكيا auction listings + bids — see
/// backend/migrations/0011_recycling.sql.
class RecyclingService {
  RecyclingService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchActiveLots() async {
    final rows = await _client
        .from('recycling_listings')
        .select('*, seller:profiles(full_name, is_verified), recycling_bids!recycling_bids_listing_id_fkey(id, bidder_id, amount, created_at)')
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(30);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<Map<String, dynamic>> fetchLot(String listingId) async {
    return await _client
        .from('recycling_listings')
        .select('*, seller:profiles(full_name, is_verified), recycling_bids!recycling_bids_listing_id_fkey(id, bidder_id, amount, created_at)')
        .eq('id', listingId)
        .single();
  }

  static Future<void> createLot({
    required String category,
    required String title,
    required String description,
    required double? estimatedWeightKg,
    required String locationNote,
    required Duration auctionDuration,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('recycling_listings').insert({
      'seller_id': userId,
      'category': category,
      'title': title,
      'description': description,
      'estimated_weight_kg': estimatedWeightKg,
      'location_note': locationNote,
      'auction_ends_at': DateTime.now().add(auctionDuration).toUtc().toIso8601String(),
    });
  }

  /// Server-checked bid (migration 0046): the auction must be open, the
  /// amount positive and above the current top bid, and not your own lot.
  static Future<void> placeBid({required String listingId, required double amount}) async {
    await _client.rpc('place_recycling_bid', params: {'p_listing_id': listingId, 'p_amount': amount});
  }

  /// Ends the auction by accepting the current highest bid — seller only,
  /// and the server picks the real top bid (migration 0046).
  static Future<void> acceptTopBid(String listingId) async {
    await _client.rpc('accept_recycling_top_bid', params: {'p_listing_id': listingId});
  }
}
