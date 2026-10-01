import 'package:supabase_flutter/supabase_flutter.dart';

/// Imports real nearby shops from Google Places into the `shops` table —
/// see backend/migrations/0012_shops.sql.
///
/// Google calls go through the `places` Edge Function (migration 0041,
/// backend/functions/places) so the API key never ships to the browser.
class PlacesService {
  PlacesService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchImportedShops() async {
    final rows = await _client.from('shops').select().order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Calls the `places` Edge Function (backend/functions/places) — the
  /// Google API key lives only there, never in this app. Errors come back
  /// as the function's own Arabic message where it has one.
  static Future<Map<String, dynamic>> _invoke(Map<String, dynamic> body) async {
    try {
      final res = await _client.functions.invoke('places', body: body);
      return Map<String, dynamic>.from(res.data as Map);
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map ? details['error'] as String? : null;
      throw Exception(message ?? 'تعذر البحث عبر خرائط Google (${e.status})');
    }
  }

  /// Searches Google Places for [query] (e.g. "سوبر ماركت في المعادي");
  /// the Edge Function upserts the results into `shops` server-side.
  /// Returns the current full shop list.
  static Future<List<Map<String, dynamic>>> importFromGoogle(String query) async {
    await _invoke({'action': 'import_shops', 'query': query});
    return fetchImportedShops();
  }

  /// Resolves [lat]/[lng] to a human-readable "district / city" label
  /// (Geocoding API, via the Edge Function). Null when it can't.
  static Future<String?> resolveAreaLabel({required double lat, required double lng}) async {
    final result = await _invoke({'action': 'geocode', 'lat': lat, 'lng': lng});
    return result['area'] as String?;
  }

  /// Plain Google Places text search that does NOT touch the `shops`
  /// table — used to resolve a real-world place (e.g. a building) to
  /// its Google `id`/lat/lng so callers can dedupe against it. See
  /// backend/migrations/0017_buildings_registry.sql.
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    final result = await _invoke({'action': 'search', 'query': query});
    return List<Map<String, dynamic>>.from(result['places'] as List);
  }

  /// "اكتشف حواليك": businesses of [category] within ~3 km of [lat]/[lng],
  /// nearest first, live from Google Maps (not stored). Works for guests.
  static Future<List<Map<String, dynamic>>> nearby({required double lat, required double lng, required String category}) async {
    final result = await _invoke({'action': 'nearby', 'lat': lat, 'lng': lng, 'category': category});
    return List<Map<String, dynamic>>.from(result['places'] as List);
  }

  /// One business's page: photos, hours, phone, website, and whether it
  /// already has a مُجتمعي store.
  static Future<Map<String, dynamic>> placeDetails(String placeId) async {
    final result = await _invoke({'action': 'details', 'place_id': placeId});
    return Map<String, dynamic>.from(result['place'] as Map);
  }

  /// Creates (or returns) the shop row for a Google place so its owner can
  /// file an ownership claim. Signed-in users only.
  static Future<Map<String, dynamic>> ensureShopForPlace(String placeId) async {
    final result = await _invoke({'action': 'ensure_shop', 'place_id': placeId});
    return Map<String, dynamic>.from(result['shop'] as Map);
  }

  /// Submits a real ownership-claim request for [shopId] — goes into a
  /// pending review queue (shop_claim_requests), not an instant claim.
  static Future<void> submitClaimRequest({
    required String shopId,
    required String verificationMethod,
    String? documentUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('shop_claim_requests').insert({
      'shop_id': shopId,
      'requester_id': userId,
      'verification_method': verificationMethod,
      'document_url': ?documentUrl,
    });
  }
}
