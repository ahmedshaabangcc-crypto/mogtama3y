import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_flavor.dart';
import '../geo/phones.dart';

SupabaseClient get _db => Supabase.instance.client;

/// The business directory (public.directory_places): ~300k Egyptian places
/// from Overture Maps (0058), plus — anywhere in the Arab world (0094) —
/// places imported from OpenStreetMap when someone opens them, places users
/// add («ضيف محل») and merchants' shops. Stored in our own database, so
/// browsing it costs nothing per request.
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

  /// An OpenStreetMap row (OsmPlace.toRow) → ours, once (0094). Returns
  /// the directory id to open (an existing place when it was already ours).
  static Future<String> importOsm(Map<String, dynamic> row) async {
    final r = await _db.rpc('directory_import_osm', params: {
      'p_osm_type': row['osm_type'],
      'p_osm_id': row['osm_id'],
      'p_name': row['name'],
      'p_category': row['category'],
      'p_lat': row['lat'],
      'p_lng': row['lng'],
      'p_phone': row['phone'],
      'p_website': row['website'],
      'p_opening_hours': row['opening_hours'],
      'p_kind': row['kind'],
      'p_address': row['address'],
    });
    return r as String;
  }

  /// «ضيف محل» (0094): signed-in, Arab world only, 5 a day. Returns the
  /// new place's id (or the existing one with the same name at that spot).
  static Future<String> addPlace({
    required String name,
    required String category,
    required double lat,
    required double lng,
    String? phone,
    String? whatsapp,
    String? openingHours,
    String? address,
  }) async {
    final r = await _db.rpc('directory_add_place', params: {
      'p_name': name,
      'p_category': category,
      'p_lat': lat,
      'p_lng': lng,
      'p_phone': phone,
      'p_whatsapp': whatsapp,
      'p_opening_hours': openingHours,
      'p_address': address,
    });
    return r as String;
  }

  /// «بلّغ عن محل غلط» (0095): reason keys → the labels the sheet shows.
  static const reportReasons = <String, String>{
    'closed': 'المحل مقفول نهائياً',
    'wrong_location': 'المكان غلط على الخريطة',
    'wrong_info': 'الاسم أو الرقم غلط',
    'duplicate': 'مكرر',
    'fake': 'مش محل / إعلان مزيف أو مسيء',
    'other': 'حاجة تانية',
  };

  /// Signed-in only, 10 a day; reporting the same place again returns the
  /// open report. [suggestion]: name / phone / category (wrong_info).
  static Future<String> reportPlace(String placeId, String reason, {String? note, Map<String, String>? suggestion}) async {
    final r = await _db.rpc('report_directory_place', params: {
      'p_place_id': placeId,
      'p_reason': reason,
      'p_note': note,
      'p_suggestion': (suggestion == null || suggestion.isEmpty) ? null : suggestion,
    });
    return r as String;
  }

  // ---- super admin («بلاغات الأماكن»)

  /// Places with open reports ('open') or hidden places ('hidden').
  static Future<List<Map<String, dynamic>>> adminPlaceReports({String filter = 'open'}) async {
    final rows = await _db.rpc('admin_list_place_reports', params: {'p_filter': filter});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> adminResolveReports(String placeId, {String status = 'dismissed'}) =>
      _db.rpc('admin_resolve_place_report', params: {'p_place_id': placeId, 'p_status': status});

  /// null = keep; an empty [phone] removes it.
  static Future<void> adminUpdatePlace(String placeId, {String? name, String? phone, String? category}) =>
      _db.rpc('admin_update_directory_place', params: {'p_place_id': placeId, 'p_name': name, 'p_phone': phone, 'p_category': category});

  static Future<void> adminSetHidden(String placeId, bool hidden) =>
      _db.rpc('admin_set_place_hidden', params: {'p_place_id': placeId, 'p_hidden': hidden});

  static Future<void> adminDeletePlace(String placeId) => _db.rpc('admin_delete_directory_place', params: {'p_place_id': placeId});

  /// wa.me link (stored number: 01… Egypt, or E.164) with a
  /// customer's message to a shop that isn't on مُجتمعي yet: their request,
  /// plus an invitation to open a free store and answer it.
  static Uri whatsappToShop(String whatsapp, {required String shopName, required String request}) {
    final text = 'السلام عليكم يا $shopName 👋\n'
        'لقيت محلكم على مُجتمعي وعايز أطلب:\n$request\n\n'
        '— لو حابب تستقبل طلبات زباين منطقتك أونلاين ببلاش ومن غير عمولة، افتح متجرك في دقيقتين: $tajerUrl';
    return waLink(whatsapp, text: text);
  }
}
