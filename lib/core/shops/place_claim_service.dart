import 'package:supabase_flutter/supabase_flutter.dart';

/// «استلم محلك جاهز» (0111): the owner of a directory place turns it into a
/// store already filled with its name, address, location and number.
class PlaceClaimService {
  PlaceClaimService._();

  static SupabaseClient get _client => Supabase.instance.client;

  /// The claim link a place's owner opens (dalil pages, WhatsApp outreach).
  static String claimUrl(String placeId) => 'https://tajer.mogtama3y.com/#/claim/$placeId';

  /// What the claim page shows; null when the place isn't in the directory.
  static Future<Map<String, dynamic>?> info(String placeId) async {
    final r = await _client.rpc('place_claim_info', params: {'p_place': placeId});
    return r == null ? null : Map<String, dynamic>.from(r as Map);
  }

  /// Creates the caller's store from the place →
  /// {shop_id, claim_id, status: 'approved' | 'pending'}.
  static Future<Map<String, dynamic>> claim({
    required String placeId,
    required String slug,
    required String whatsapp,
    String? name,
    String? category,
  }) async {
    final r = await _client.rpc('claim_place_as_shop', params: {
      'p_place': placeId,
      'p_slug': slug,
      'p_whatsapp': whatsapp,
      'p_name': name,
      'p_category': category,
    });
    return Map<String, dynamic>.from(r as Map);
  }
}
