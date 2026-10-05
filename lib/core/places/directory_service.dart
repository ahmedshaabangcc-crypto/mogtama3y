import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_flavor.dart';

SupabaseClient get _db => Supabase.instance.client;

/// Egypt business directory (public.directory_places, from Overture Maps —
/// migration 0058): ~300k places with Arabic categories and phone numbers,
/// stored in our own database, so browsing it costs nothing per request.
class DirectoryService {
  DirectoryService._();

  /// Shown under directory listings (licence attribution).
  static const attribution = 'بيانات الأماكن: © Overture Maps Foundation';

  static Future<List<Map<String, dynamic>>> nearby({
    required double lat,
    required double lng,
    String? category,
    double km = 3,
    int limit = 60,
  }) async {
    final rows = await _db.rpc('nearby_directory', params: {
      'p_lat': lat,
      'p_lng': lng,
      'p_km': km,
      'p_category': category,
      'p_limit': limit,
    });
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<List<Map<String, dynamic>>> search(String query, {double? lat, double? lng}) async {
    final rows = await _db.rpc('search_directory', params: {'p_query': query, 'p_lat': lat, 'p_lng': lng, 'p_limit': 40});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// wa.me link (Egyptian mobile 01xxxxxxxxx → 201xxxxxxxxx) with a
  /// customer's message to a shop that isn't on مُجتمعي yet: their request,
  /// plus an invitation to open a free store and answer it.
  static Uri whatsappToShop(String whatsapp, {required String shopName, required String request}) {
    final number = '2${whatsapp.replaceAll(RegExp(r'[^0-9]'), '')}';
    final text = 'السلام عليكم يا $shopName 👋\n'
        'لقيت محلكم على مُجتمعي وعايز أطلب:\n$request\n\n'
        '— لو حابب تستقبل طلبات زباين منطقتك أونلاين ببلاش ومن غير عمولة، افتح متجرك في دقيقتين: $tajerUrl';
    return Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(text)}');
  }
}
