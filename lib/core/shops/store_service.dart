import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'scan_flag.dart';

/// Merchant stores ("مشروعك أونلاين") — see
/// backend/migrations/0047_merchant_stores.sql. Every store has a public
/// page at `mogtama3y.com/#/s/<slug>`; orders are priced and recorded
/// server-side, then handed to the shop on WhatsApp. No payment or
/// delivery goes through مُجتمعي.
class StoreService {
  StoreService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static const publicBaseUrl = 'https://mogtama3y.com/#/s/';
  static String storeUrl(String slug) => '$publicBaseUrl$slug';

  static const categories = [
    'سوبر ماركت / بقالة',
    'ملابس وأحذية',
    'مطعم / كافيه',
    'صيدلية / مستحضرات',
    'موبايلات وإكسسوارات',
    'أدوات منزلية',
    'حلويات ومخبوزات',
    'عطارة / خضار وفاكهة',
    'نشاط تاني',
  ];

  // ---- public store page ----

  static Future<Map<String, dynamic>?> fetchStoreBySlug(String slug) async {
    return _client
        .from('shops')
        .select('id, name, category, description, cover_image_url, logo_url, address, lat, lng, slug, whatsapp, owner_id, is_claimed, delivery_fee, free_delivery_over')
        .eq('slug', slug.toLowerCase())
        .maybeSingle();
  }

  /// Counts a visit from the QR / link (works for guests too).
  static Future<void> recordScan(String slug) async {
    if (scanAlreadyRecorded) return; // store-lite.js already counted it
    try {
      await _client.rpc('record_shop_scan', params: {'p_slug': slug});
    } catch (_) {
      // A missed count must never block showing the store.
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProducts(String shopId, {bool includeHidden = false}) async {
    var query = _client.from('shop_products').select().eq('shop_id', shopId);
    if (!includeHidden) query = query.eq('is_available', true);
    final rows = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// [items]: productId → quantity. Returns the new order id.
  static Future<String> placeOrder({
    required String shopId,
    required Map<String, int> items,
    required String customerPhone,
    String? note,
  }) async {
    final result = await _client.rpc('place_shop_order', params: {
      'p_shop_id': shopId,
      'p_items': [for (final e in items.entries) {'product_id': e.key, 'quantity': e.value}],
      'p_customer_phone': customerPhone,
      'p_note': note,
    });
    return result as String;
  }

  /// Opens WhatsApp to the shop with a ready-made order message.
  static Future<void> openWhatsAppOrder({required String shopWhatsapp, required String message}) {
    final international = '2${shopWhatsapp.replaceAll(RegExp(r'\s'), '')}';
    return launchUrl(
      Uri.parse('https://wa.me/$international?text=${Uri.encodeComponent(message)}'),
      mode: LaunchMode.externalApplication,
    );
  }

  // ---- merchant panel ----

  static Future<List<Map<String, dynamic>>> fetchMyShops() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final rows = await _client
        .from('shops')
        .select('id, name, category, description, address, slug, whatsapp, scan_count, cover_image_url, logo_url, delivery_fee, free_delivery_over')
        .eq('owner_id', userId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<String> createMyShop({
    required String name,
    required String category,
    required String slug,
    required String whatsapp,
    String? address,
  }) async {
    final result = await _client.rpc('create_my_shop', params: {
      'p_name': name,
      'p_category': category,
      'p_slug': slug,
      'p_whatsapp': whatsapp,
      'p_address': address,
    });
    return result as String;
  }

  /// For a claimed Google shop that has no link/WhatsApp yet.
  static Future<void> updateShopLink({required String shopId, required String slug, required String whatsapp}) async {
    await _client.from('shops').update({'slug': slug.toLowerCase().trim(), 'whatsapp': whatsapp.trim()}).eq('id', shopId);
  }

  static Future<void> saveProduct({
    String? productId,
    required String shopId,
    required String name,
    required double price,
    String? description,
    List<String> images = const [],
    double? oldPrice,
    List<String> highlights = const [],
    String? category,
    int? stock,
    List<Map<String, dynamic>> options = const [],
    required bool isAvailable,
  }) async {
    final data = {
      'category': category,
      'stock': stock,
      'options': options,
      'shop_id': shopId,
      'name': name,
      'price': price,
      'description': description,
      'images': images,
      // The cover mirrors into image_url for older builds / store-lite.
      'image_url': images.isEmpty ? null : images.first,
      'old_price': oldPrice,
      'highlights': highlights,
      'is_available': isAvailable,
    };
    if (productId == null) {
      await _client.from('shop_products').insert(data);
    } else {
      await _client.from('shop_products').update(data).eq('id', productId);
    }
  }

  // ---- storefront checkout (migration 0054) ----

  /// Guest checkout (cash on delivery). [lines]: product_id, quantity and
  /// the chosen options text. Returns the public tracking code.
  static Future<String> placeStoreOrder({
    required String shopId,
    required List<Map<String, dynamic>> lines,
    required String name,
    required String phone,
    required String address,
    String? note,
  }) async {
    final code = await _client.rpc('place_store_order', params: {
      'p_shop_id': shopId,
      'p_items': lines,
      'p_customer_name': name,
      'p_customer_phone': phone,
      'p_address': address,
      'p_note': note,
    });
    return code as String;
  }

  static Future<Map<String, dynamic>?> trackOrder(String code) async {
    final res = await _client.rpc('get_store_order', params: {'p_code': code});
    return res == null ? null : Map<String, dynamic>.from(res as Map);
  }

  static Future<Map<String, dynamic>> shopStats(String shopId) async {
    final res = await _client.rpc('my_shop_stats', params: {'p_shop_id': shopId});
    return Map<String, dynamic>.from(res as Map);
  }

  static Future<void> updateShopProfile({
    required String shopId,
    required String name,
    String? description,
    String? logoUrl,
    String? coverUrl,
  }) async {
    await _client.rpc('update_my_shop_profile', params: {
      'p_shop_id': shopId,
      'p_name': name,
      'p_description': description,
      'p_logo_url': logoUrl,
      'p_cover_url': coverUrl,
    });
  }

  static Future<void> setShopDelivery({required String shopId, required double fee, double? freeOver}) async {
    await _client.rpc('set_my_shop_delivery', params: {'p_shop_id': shopId, 'p_fee': fee, 'p_free_over': freeOver});
  }

  /// Delivery for an order of [subtotal] at [shop] (same rule as the server).
  static double deliveryFor(Map<String, dynamic> shop, double subtotal) {
    final fee = (shop['delivery_fee'] as num?)?.toDouble() ?? 0;
    final freeOver = (shop['free_delivery_over'] as num?)?.toDouble();
    if (freeOver != null && subtotal >= freeOver) return 0;
    return fee;
  }

  /// "التوصيل 25 ج.م • مجاني فوق 500 ج.م" / "التوصيل مجاني".
  static String deliveryLabel(Map<String, dynamic> shop) {
    final fee = (shop['delivery_fee'] as num?)?.toDouble() ?? 0;
    final freeOver = (shop['free_delivery_over'] as num?)?.toDouble();
    String m(double v) => '${v == v.roundToDouble() ? v.toInt() : v} ج.م';
    if (fee == 0) return 'التوصيل مجاني';
    return 'التوصيل ${m(fee)}${freeOver != null ? ' • مجاني فوق ${m(freeOver)}' : ''}';
  }

  static String productUrl(String slug, String productId) => 'https://mogtama3y.com/#/s/$slug/p/$productId';
  static String trackUrl(String code) => 'https://mogtama3y.com/#/o/$code';

  /// Option groups of a product: [{name: 'المقاس', values: ['S','M']}].
  static List<({String name, List<String> values})> optionsOf(Map<String, dynamic> p) {
    final raw = p['options'];
    if (raw is! List) return const [];
    return [
      for (final o in raw)
        if (o is Map && o['name'] is String && o['values'] is List)
          (name: o['name'] as String, values: List<String>.from((o['values'] as List).whereType<String>())),
    ].where((o) => o.values.isNotEmpty).toList();
  }

  /// AI copywriter (Edge Function product-ai): name, description and
  /// highlights suggested from the product photos and the merchant's notes.
  static Future<({String name, String description, List<String> highlights})> suggestProductCopy({
    List<String> imageUrls = const [],
    String? name,
    String? category,
    String? notes,
  }) async {
    final res = await _client.functions.invoke('product-ai', body: {
      'image_urls': imageUrls.take(3).toList(),
      'name': name,
      'category': category,
      'notes': notes,
    });
    final data = Map<String, dynamic>.from(res.data as Map);
    if (data['error'] != null) throw Exception(data['error']);
    return (
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      highlights: List<String>.from(data['highlights'] as List? ?? const []),
    );
  }

  /// All photos of a product (the images array, or the legacy single image).
  static List<String> imagesOf(Map<String, dynamic> p) {
    final list = List<String>.from(p['images'] as List? ?? const []);
    if (list.isEmpty && p['image_url'] is String) list.add(p['image_url'] as String);
    return list;
  }

  static Future<void> deleteProduct(String productId) async {
    await _client.from('shop_products').delete().eq('id', productId);
  }

  static Future<List<Map<String, dynamic>>> fetchShopOrders(String shopId) async {
    final rows = await _client
        .from('shop_orders')
        .select('*, items:shop_order_items(quantity, unit_price, chosen_options, product:shop_products(name))')
        .eq('shop_id', shopId)
        .neq('status', 'cart')
        .order('created_at', ascending: false)
        .limit(100);
    return List<Map<String, dynamic>>.from(rows as List);
  }

  static Future<void> updateOrderStatus({required String orderId, required String status}) async {
    await _client.rpc('update_shop_order_status', params: {'p_order_id': orderId, 'p_status': status});
  }
}
