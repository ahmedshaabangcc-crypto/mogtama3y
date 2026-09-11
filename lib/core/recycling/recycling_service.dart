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

  static Future<void> placeBid({required String listingId, required double amount}) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('recycling_bids').insert({
      'listing_id': listingId,
      'bidder_id': userId,
      'amount': amount,
    });
  }

  /// Ends the auction by accepting the current highest bid (seller-only,
  /// enforced by RLS since only the seller can update their own listing).
  static Future<void> acceptTopBid(String listingId) async {
    final bids = await _client.from('recycling_bids').select('id, amount').eq('listing_id', listingId).order('amount', ascending: false).limit(1);
    final topBid = bids.isEmpty ? null : bids.first;
    await _client.from('recycling_listings').update({
      'status': 'ended',
      if (topBid != null) 'winning_bid_id': topBid['id'],
    }).eq('id', listingId);
  }
}
