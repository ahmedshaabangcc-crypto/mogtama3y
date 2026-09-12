import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../union/union_service.dart';

/// Real peer-to-peer real estate listings — see
/// backend/migrations/0023_real_estate.sql.
class RealEstateService {
  RealEstateService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// Active listings, with [hide_from_own_building] actually enforced
  /// client-side against the caller's own building (unlike the
  /// pre-existing marketplace flag, which nothing ever filters on).
  static Future<List<Map<String, dynamic>>> fetchListings({String? dealType}) async {
    var query = _client.from('real_estate_listings').select('*, owner:profiles(full_name, phone)').eq('status', 'active');
    if (dealType != null) {
      query = query.eq('deal_type', dealType);
    }
    final rows = await query.order('created_at', ascending: false).limit(30);
    final listings = List<Map<String, dynamic>>.from(rows as List);

    final membership = await UnionService.fetchMyMembership();
    final myBuildingId = membership?['building_id'] as String?;
    if (myBuildingId == null) return listings;
    return listings.where((l) => !(l['hide_from_own_building'] == true && l['building_id'] == myBuildingId)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchMyListings() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client.from('real_estate_listings').select().eq('owner_id', userId).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> createListing({
    required String dealType,
    required String title,
    required String description,
    required double price,
    double? areaSqm,
    int? bedrooms,
    int? bathrooms,
    required bool hideFromOwnBuilding,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');

    final membership = await UnionService.fetchMyMembership();
    if (membership == null || membership['status'] != 'verified') {
      throw Exception('يجب الانضمام لعمارتك وتوثيق حسابك أولاً قبل نشر إعلان عقاري');
    }

    await _client.from('real_estate_listings').insert({
      'owner_id': userId,
      'building_id': membership['building_id'],
      'unit_id': membership['unit_id'],
      'deal_type': dealType,
      'title': title,
      'description': description,
      'price': price,
      'area_sqm': areaSqm,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'hide_from_own_building': hideFromOwnBuilding,
    });
  }

  static Future<void> removeListing(String listingId) async {
    await _client.from('real_estate_listings').update({'status': 'removed'}).eq('id', listingId);
  }

  static Future<void> expressInterest(String listingId) async {
    await _client.rpc('express_interest_in_listing', params: {'p_listing_id': listingId});
  }
}
