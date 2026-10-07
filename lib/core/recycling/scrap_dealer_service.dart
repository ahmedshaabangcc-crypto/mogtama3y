import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../location/where.dart';

SupabaseClient get _db => Supabase.instance.client;

/// Scrap materials — keys must match the checks in
/// backend/migrations/0075_scrap_dealers.sql.
const scrapMaterials = <String, String>{
  'iron': 'حديد',
  'copper': 'نحاس',
  'aluminum': 'ألومنيوم',
  'paper_cardboard': 'كرتون/ورق',
  'plastic': 'بلاستيك',
  'electronics': 'أجهزة كهربائية',
  'furniture': 'أثاث/بيكيا',
  'other': 'أخرى',
};

/// The old category enum each material belongs to (the server derives the
/// lot's category the same way).
const scrapMaterialCategory = <String, String>{
  'iron': 'metal',
  'copper': 'metal',
  'aluminum': 'metal',
  'paper_cardboard': 'paper_cardboard',
  'plastic': 'plastic',
  'electronics': 'electronics',
  'furniture': 'furniture',
  'other': 'other',
};

const scrapCategoryLabels = <String, String>{
  'metal': 'معادن',
  'plastic': 'بلاستيك',
  'electronics': 'إلكترونيات',
  'furniture': 'أثاث',
  'paper_cardboard': 'ورق وكرتون',
  'other': 'أخرى',
};

/// "نحاس" for a lot with a material, else its old category label.
String scrapLotMaterialLabel(Map<String, dynamic> lot) {
  final material = lot['material'] as String?;
  if (material != null) return scrapMaterials[material] ?? material;
  final category = lot['category'] as String? ?? 'other';
  return scrapCategoryLabels[category] ?? category;
}

/// "مدينة نصر، القاهرة" / "القاهرة" / null.
String? scrapPlaceLabel(Map<String, dynamic> row) {
  final parts = [row['area'], row['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).toList();
  return parts.isEmpty ? null : parts.join('، ');
}

const scrapDealerStatusLabels = <String, String>{
  'pending': 'قيد المراجعة',
  'verified': 'موثّق ✓',
  'rejected': 'مرفوض',
};

/// 01xxxxxxxxx from whatever the profile holds (+20…, 0020…, spaces).
String? normalizeEgyptMobile(String? raw) {
  if (raw == null) return null;
  var d = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (d.startsWith('0020')) d = d.substring(4);
  if (d.startsWith('20') && d.length == 12) d = '0${d.substring(2)}';
  if (d.length == 10 && d.startsWith('1')) d = '0$d';
  return RegExp(r'^01[0125][0-9]{8}$').hasMatch(d) ? d : null;
}

final scrapWhatsappPattern = RegExp(r'^01[0125][0-9]{8}$');

Uri scrapWhatsappUri(String phone, String text) {
  final number = normalizeEgyptMobile(phone) ?? phone;
  return Uri.parse('https://wa.me/2$number?text=${Uri.encodeComponent(text)}');
}

/// The user's position, asking for permission first. Throws an Arabic
/// message when location is off or refused.
Future<Position> scrapMyPosition() async {
  if (!await Geolocator.isLocationServiceEnabled()) throw 'شغّل الـ GPS (الموقع) وجرّب تاني';
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    throw 'محتاجين إذن الموقع عشان نحدد مكانك';
  }
  return Where.current();
}

/// Scrap dealers ("تجار الخردة") — migration 0075.
class ScrapDealerService {
  ScrapDealerService._();

  /// The signed-in user's dealer row, or null if they never registered.
  static Future<Map<String, dynamic>?> myDealer() async {
    final uid = AuthService.currentUser?.id;
    if (uid == null) return null;
    return await _db.from('scrap_dealers').select().eq('user_id', uid).maybeSingle();
  }

  /// Registers (insert) or edits (update) the caller's dealer row. The
  /// server keeps the status: a new row is pending, and a new business
  /// name or document sends a verified/rejected dealer back to review.
  static Future<void> save({
    required bool isNew,
    required String businessName,
    required String whatsapp,
    required List<String> materials,
    required String? governorate,
    required List<String> areas,
    required double? radiusKm,
    required double? baseLat,
    required double? baseLng,
    required String? docPath,
  }) async {
    final uid = AuthService.currentUser?.id;
    if (uid == null) throw Exception('سجّل دخول الأول');
    final row = {
      'business_name': businessName,
      'whatsapp': whatsapp,
      'materials': materials,
      'governorate': governorate,
      'areas': areas,
      'radius_km': radiusKm,
      'base_lat': radiusKm == null ? null : baseLat,
      'base_lng': radiusKm == null ? null : baseLng,
      'doc_path': docPath,
    };
    if (isNew) {
      await _db.from('scrap_dealers').insert({'user_id': uid, ...row});
    } else {
      await _db.from('scrap_dealers').update(row).eq('user_id', uid);
    }
  }

  static Future<void> unregister() async {
    final uid = AuthService.currentUser?.id;
    if (uid == null) return;
    await _db.from('scrap_dealers').delete().eq('user_id', uid);
  }

  /// user id → business name, for verified dealers only (public RPC).
  static Future<Map<String, String>> badges(Iterable<String> userIds) async {
    final ids = userIds.toSet().toList();
    if (ids.isEmpty) return {};
    final rows = await _db.rpc('scrap_dealer_badges', params: {'p_user_ids': ids});
    return {
      for (final r in List<Map<String, dynamic>>.from(rows as List)) r['user_id'] as String: r['business_name'] as String,
    };
  }

  /// Active lots matching the caller's materials and area.
  static Future<List<Map<String, dynamic>>> matchingLots() async {
    final rows = await _db.rpc('scrap_dealer_matching_lots');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Every lot the caller bid on: my_amount, top_amount, status, won.
  static Future<List<Map<String, dynamic>>> myBids() async {
    final rows = await _db.rpc('recycling_my_bids');
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// The seller's name + phone — only for the accepted winner.
  static Future<Map<String, dynamic>?> sellerContact(String listingId) async {
    final rows = List<Map<String, dynamic>>.from(await _db.rpc('recycling_seller_contact', params: {'p_listing': listingId}) as List);
    return rows.isEmpty ? null : rows.first;
  }

  /// The winner's name, phone, business name + WhatsApp — only for the seller.
  static Future<Map<String, dynamic>?> winnerContact(String listingId) async {
    final rows = List<Map<String, dynamic>>.from(await _db.rpc('recycling_winner_contact', params: {'p_listing': listingId}) as List);
    return rows.isEmpty ? null : rows.first;
  }

  // ------------------------------------------------------------ admin
  static Future<List<Map<String, dynamic>>> adminList({String? status}) async {
    final rows = await _db.rpc('admin_list_scrap_dealers', params: {'p_status': status});
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> review(String userId, {required bool approve, String? note}) async {
    await _db.rpc('review_scrap_dealer', params: {'p_user': userId, 'p_approve': approve, 'p_note': note});
  }
}
