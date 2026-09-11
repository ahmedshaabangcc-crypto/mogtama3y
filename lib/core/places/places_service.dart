import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'places_config.dart';

const _typeLabels = {
  'supermarket': 'سوبر ماركت',
  'grocery_store': 'بقالة',
  'pharmacy': 'صيدلية',
  'bakery': 'مخبز',
  'restaurant': 'مطعم',
  'cafe': 'كافيه',
  'convenience_store': 'محل تجاري',
  'hardware_store': 'أدوات منزلية',
  'clothing_store': 'ملابس',
  'laundry': 'مغسلة',
};

String _categoryFor(List<dynamic>? types) {
  if (types == null) return 'محل تجاري';
  for (final t in types) {
    final label = _typeLabels[t as String];
    if (label != null) return label;
  }
  return 'محل تجاري';
}

/// Imports real nearby shops from Google Places into the `shops` table —
/// see backend/migrations/0012_shops.sql.
///
/// Uses the **Places API (New)** `searchText` endpoint, not the legacy
/// Places API — the legacy REST endpoints are server-only and reject
/// direct browser calls with a CORS failure (confirmed live: it worked
/// fine from a plain server-side request but failed with "Failed to
/// fetch" from an actual browser tab). The new API explicitly supports
/// being called from client-side JavaScript/web.
class PlacesService {
  PlacesService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchImportedShops() async {
    final rows = await _client.from('shops').select().order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Builds a real, directly-loadable image URL from a Places (New)
  /// photo resource name (e.g. "places/ABC/photos/XYZ").
  static String photoUrlFor(String photoName, {int maxWidthPx = 640}) {
    return Uri.https('places.googleapis.com', '/v1/$photoName/media', {
      'maxWidthPx': '$maxWidthPx',
      'key': PlacesConfig.apiKey,
    }).toString();
  }

  /// Searches Google Places for [query] (e.g. "سوبر ماركت في المعادي")
  /// and upserts the results into `shops`, then returns the current
  /// full shop list.
  static Future<List<Map<String, dynamic>>> importFromGoogle(String query) async {
    final response = await http.post(
      Uri.https('places.googleapis.com', '/v1/places:searchText'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': PlacesConfig.apiKey,
        'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.userRatingCount,places.types,places.photos',
      },
      body: jsonEncode({'textQuery': query, 'languageCode': 'ar'}),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      final message = (body['error'] as Map<String, dynamic>?)?['message'] as String?;
      throw Exception(message ?? 'تعذر البحث عبر خرائط Google (${response.statusCode})');
    }
    final places = (body['places'] as List?) ?? const [];
    if (places.isNotEmpty) {
      final rows = places.map((p) {
        final place = p as Map<String, dynamic>;
        final location = place['location'] as Map<String, dynamic>?;
        final photos = place['photos'] as List<dynamic>?;
        final photoName = (photos != null && photos.isNotEmpty) ? (photos.first as Map<String, dynamic>)['name'] as String? : null;
        return {
          'source': 'google_imported',
          'google_place_id': place['id'],
          'name': (place['displayName'] as Map<String, dynamic>?)?['text'],
          'category': _categoryFor(place['types'] as List<dynamic>?),
          'address': place['formattedAddress'],
          'lat': location?['latitude'],
          'lng': location?['longitude'],
          'rating': place['rating'],
          'rating_count': place['userRatingCount'] ?? 0,
          if (photoName != null) 'cover_image_url': photoUrlFor(photoName),
        };
      }).toList();
      await _client.from('shops').upsert(rows, onConflict: 'google_place_id', ignoreDuplicates: true);
    }
    return fetchImportedShops();
  }

  /// Submits a real ownership-claim request for [shopId] — goes into a
  /// pending review queue (shop_claim_requests), not an instant claim.
  static Future<void> submitClaimRequest({
    required String shopId,
    required String verificationMethod,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('يجب تسجيل الدخول أولاً');
    await _client.from('shop_claim_requests').insert({
      'shop_id': shopId,
      'requester_id': userId,
      'verification_method': verificationMethod,
    });
  }
}
