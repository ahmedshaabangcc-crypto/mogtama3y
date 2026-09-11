import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'places_config.dart';

const _typeLabels = {
  'supermarket': 'سوبر ماركت',
  'grocery_or_supermarket': 'بقالة',
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
/// see backend/migrations/0012_shops.sql. Uses the Places API (Legacy)
/// Text Search endpoint since it needs only a single GET with the key.
class PlacesService {
  PlacesService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetchImportedShops() async {
    final rows = await _client.from('shops').select().order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Searches Google Places for [query] (e.g. "سوبر ماركت في المعادي")
  /// and upserts the results into `shops`, then returns the current
  /// full shop list.
  static Future<List<Map<String, dynamic>>> importFromGoogle(String query) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
      'query': query,
      'key': PlacesConfig.apiKey,
    });
    final response = await http.get(uri);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') {
      throw Exception(body['error_message'] as String? ?? 'تعذر البحث عبر خرائط Google ($status)');
    }
    final results = (body['results'] as List?) ?? const [];
    if (results.isNotEmpty) {
      final rows = results.map((r) {
        final place = r as Map<String, dynamic>;
        final location = (place['geometry'] as Map<String, dynamic>?)?['location'] as Map<String, dynamic>?;
        return {
          'source': 'google_imported',
          'google_place_id': place['place_id'],
          'name': place['name'],
          'category': _categoryFor(place['types'] as List<dynamic>?),
          'address': place['formatted_address'],
          'lat': location?['lat'],
          'lng': location?['lng'],
          'rating': place['rating'],
          'rating_count': place['user_ratings_total'] ?? 0,
        };
      }).toList();
      await _client.from('shops').upsert(rows, onConflict: 'google_place_id', ignoreDuplicates: true);
    }
    return fetchImportedShops();
  }
}
