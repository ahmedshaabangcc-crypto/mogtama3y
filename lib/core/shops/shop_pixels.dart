import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../demo/demo_mode.dart';
import 'shop_pixels_bridge.dart';

/// The merchant's pixels on THEIR store pages only (0097, shops.tracking):
/// the Flutter storefront sends standard events to web/shop-pixels.js,
/// which loads Meta / TikTok / Snapchat / GA4 / GTM / Google Ads lazily.
/// Nothing loads on the rest of مُجتمعي; off the web it is a no-op.
class ShopPixels {
  ShopPixels._();

  static String? _shop;
  static bool _on = false;

  static const _pixelKeys = ['meta_pixel', 'tiktok_pixel', 'snap_pixel', 'ga4', 'gtm', 'google_ads'];

  /// The store page opened: reads the shop's pixel IDs (a separate read, so
  /// a database without 0097 just means no pixels) and starts them.
  /// Returns the tracking map (empty when none) — the page shows the
  /// «أدوات قياس» note when it isn't.
  static Future<Map<String, dynamic>> open(String shopId) async {
    if (kDemo) return const {};
    Map<String, dynamic> t = const {};
    try {
      final row = await Supabase.instance.client.from('shops').select('tracking').eq('id', shopId).maybeSingle();
      t = (row?['tracking'] as Map?)?.cast<String, dynamic>() ?? const {};
    } catch (_) {
      return const {};
    }
    if (!_pixelKeys.any((k) => t[k] is String)) {
      close();
      return const {};
    }
    _shop = shopId;
    _on = true;
    pixelsCommand('init', jsonEncode({'shop': shopId, 'tracking': t}));
    return t;
  }

  static bool get active => _on;

  static void _event(String name, Map<String, dynamic> data, {String? key}) {
    if (!_on) return;
    pixelsCommand('event', jsonEncode({'name': name, 'data': data, 'key': ?key}));
  }

  /// [key]: one PageView per page (the store page and store-lite.js share
  /// `s/<slug>`, so the instant page and Flutter don't count twice).
  static void pageView(String key) => _event('PageView', const {}, key: key);

  static void viewContent(Map<String, dynamic> product) =>
      _event('ViewContent', pixelPayload([PixelItem.fromProduct(product, 1)], currency: product['currency'] as String?));

  static void addToCart(Map<String, dynamic> product, int quantity) =>
      _event('AddToCart', pixelPayload([PixelItem.fromProduct(product, quantity)], currency: product['currency'] as String?));

  static void initiateCheckout(List<PixelItem> items, {required double value, String? currency}) =>
      _event('InitiateCheckout', pixelPayload(items, currency: currency, value: value));

  /// [orderCode] is the event id the vendors dedupe on.
  static void purchase(String orderCode, List<PixelItem> items, {required double value, String? currency}) =>
      _event('Purchase', pixelPayload(items, currency: currency, value: value, orderId: orderCode));

  /// Left the store for the rest of the app.
  static void close() {
    if (_on) pixelsCommand('close', '{}');
    _on = false;
    _shop = null;
  }

  static String? get shopId => _shop;
}

/// One product line of a pixel event.
class PixelItem {
  const PixelItem({required this.id, required this.name, required this.price, required this.quantity});
  final String id;
  final String name;
  final double price;
  final int quantity;

  factory PixelItem.fromProduct(Map<String, dynamic> p, int quantity) => PixelItem(
        id: '${p['id']}',
        name: (p['name'] as String?) ?? '',
        price: (p['price'] as num?)?.toDouble() ?? 0,
        quantity: quantity < 1 ? 1 : quantity,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price, 'quantity': quantity};
}

/// The event payload shop-pixels.js maps to every vendor:
/// {currency, value, contents:[{id,name,price,quantity}], order_id?}.
/// No customer data (name / phone / address) ever goes in here.
Map<String, dynamic> pixelPayload(List<PixelItem> items, {String? currency, double? value, String? orderId}) {
  final cur = currency != null && RegExp(r'^[A-Z]{3}$').hasMatch(currency) ? currency : 'EGP';
  final total = value ?? items.fold<double>(0, (s, i) => s + i.price * i.quantity);
  return {
    'currency': cur,
    'value': (total * 1000).round() / 1000,
    'contents': [for (final i in items) i.toJson()],
    'order_id': ?orderId,
  };
}
