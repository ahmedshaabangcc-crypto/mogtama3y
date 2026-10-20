import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'store_cart.dart';

/// The storefront cart survives a refresh (0099): saved per shop in the
/// browser (shared_preferences = localStorage on the web) for 30 days.
/// Only product ids, quantities and options — prices always come back
/// from the server.
class CartStorage {
  CartStorage._();

  static const _maxAge = Duration(days: 30);
  static String _key(String shopId) => 'store_cart:$shopId';

  static Future<void> save(String shopId, StoreCart cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (cart.isEmpty) {
        await prefs.remove(_key(shopId));
        return;
      }
      await prefs.setString(_key(shopId), jsonEncode({'at': DateTime.now().toIso8601String(), 'lines': cart.toOrderLines()}));
    } catch (_) {
      // Storage blocked (private mode…): the cart just doesn't survive a refresh.
    }
  }

  static Future<List<Map<String, dynamic>>> load(String shopId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(shopId));
      if (raw == null) return const [];
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final at = DateTime.tryParse(data['at'] as String? ?? '');
      if (at == null || DateTime.now().difference(at) > _maxAge) {
        await prefs.remove(_key(shopId));
        return const [];
      }
      return [for (final l in data['lines'] as List? ?? const []) Map<String, dynamic>.from(l as Map)];
    } catch (_) {
      return const [];
    }
  }
}
