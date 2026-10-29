import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// متجري phase 3 (migration 0099): checkout totals, shipping zones,
/// discounts, abandoned carts, COD confirmation and guest cancel.
///
/// Every number the customer pays comes from the server
/// (quote_store_checkout / place_store_order re-price the cart from the
/// database); the app only shows them.
class CheckoutService {
  CheckoutService._();

  static SupabaseClient get _db => Supabase.instance.client;

  /// Widget tests: answers every RPC of this service without a backend.
  @visibleForTesting
  static Future<Object?> Function(String fn, Map<String, dynamic> params)? debugRpc;

  static Future<Object?> _rpc(String fn, Map<String, dynamic> params) =>
      debugRpc != null ? debugRpc!(fn, params) : _db.rpc(fn, params: params);

  static Map<String, dynamic> _map(Object? r) => Map<String, dynamic>.from(r as Map);
  static List<Map<String, dynamic>> _list(Object? r) => [for (final x in r as List? ?? const []) Map<String, dynamic>.from(x as Map)];

  // ------------------------------------------------------------ storefront

  /// Zones, pickup, open state, minimum order (store_checkout_info). Null
  /// when the backend has no 0099 yet — the checkout then works as before.
  static Future<CheckoutInfo?> info(String shopId) async {
    try {
      final r = await _rpc('store_checkout_info', {'p_shop_id': shopId});
      return r == null ? null : CheckoutInfo(_map(r));
    } catch (_) {
      return null;
    }
  }

  /// How the customer may pay (shop_checkout_methods, 0097). Cash only when
  /// it can't be read.
  static Future<CheckoutMethods> methods(String shopId) async {
    try {
      final r = await _rpc('shop_checkout_methods', {'p_shop': shopId});
      return r == null ? const CheckoutMethods({}) : CheckoutMethods(_map(r));
    } catch (_) {
      return const CheckoutMethods({});
    }
  }

  static Future<CheckoutQuote> quote({
    required String shopId,
    required List<Map<String, dynamic>> lines,
    String? area,
    String fulfillment = 'delivery',
    String? code,
    String? phone,
  }) async =>
      CheckoutQuote(_map(await _rpc('quote_store_checkout', {
        'p_shop_id': shopId,
        'p_items': lines,
        'p_area': area,
        'p_fulfillment': fulfillment,
        'p_discount_code': code,
        'p_customer_phone': phone,
      })));

  /// The order code, or null when the discount code was refused (wrong or
  /// too many tries — nothing was placed; quote again for the reason).
  static Future<String?> place({
    required String shopId,
    required List<Map<String, dynamic>> lines,
    required String name,
    required String phone,
    required String address,
    String? note,
    String? area,
    String fulfillment = 'delivery',
    String? code,
    String? cartToken,
    num? expectedTotal,
  }) async =>
      await _rpc('place_store_order', {
        'p_shop_id': shopId,
        'p_items': lines,
        'p_customer_name': name,
        'p_customer_phone': phone,
        'p_address': address,
        'p_note': note,
        'p_area': area,
        'p_fulfillment': fulfillment,
        'p_discount_code': code,
        'p_cart_token': cartToken,
        'p_expected_total': expectedTotal,
      }) as String?;

  /// Saves the customer's cart for «سلات متروكة» (best effort: never throws).
  static Future<String?> saveCart({
    required String shopId,
    required String phone,
    required String name,
    required List<Map<String, dynamic>> lines,
    String? area,
  }) async {
    try {
      return await _rpc('save_store_cart', {
        'p_shop_id': shopId,
        'p_customer_phone': phone,
        'p_customer_name': name,
        'p_items': lines,
        'p_area': area,
      }) as String?;
    } catch (_) {
      return null;
    }
  }

  /// The lines of a «كمّل طلبك» link (null: gone / already ordered).
  static Future<List<Map<String, dynamic>>?> cartLines(String token) async {
    try {
      final r = await _rpc('get_store_cart', {'p_token': token});
      return r == null ? null : _list(_map(r)['lines']);
    } catch (_) {
      return null;
    }
  }

  /// Cancels from the tracking page; returns the updated order, or throws
  /// [CheckoutProblem] with the reason.
  static Future<Map<String, dynamic>> guestCancel({required String code, required String last4, String? reason}) async {
    final r = _map(await _rpc('guest_cancel_store_order', {'p_code': code, 'p_phone_last4': last4, 'p_reason': reason}));
    if (r['ok'] == false) throw CheckoutProblem(r['error'] as String? ?? 'تعذر إلغاء الطلب');
    return r;
  }

  // ------------------------------------------------------------ merchant

  static Future<Map<String, dynamic>> shipping(String shopId) async => _map(await _rpc('get_shop_shipping', {'p_shop': shopId}));

  static Future<Map<String, dynamic>> saveShipping(String shopId, Map<String, dynamic> settings) async =>
      _map(await _rpc('set_shop_shipping', {'p_shop': shopId, 'p': settings}));

  static Future<List<Map<String, dynamic>>> discounts(String shopId) async => _list(await _rpc('merchant_discounts', {'p_shop': shopId}));

  static Future<Map<String, dynamic>> saveDiscount(String shopId, Map<String, dynamic> discount) async =>
      _map(await _rpc('save_shop_discount', {'p_shop': shopId, 'p': discount}));

  /// True when deleted; false when it was used (then it is switched off).
  static Future<bool> deleteDiscount(String discountId) async =>
      _map(await _rpc('delete_shop_discount', {'p_discount': discountId}))['deleted'] == true;

  static Future<List<Map<String, dynamic>>> discountOrders(String discountId) async =>
      _list(await _rpc('merchant_discount_orders', {'p_discount': discountId}));

  static Future<Map<String, dynamic>> abandonedCarts(String shopId) async => _map(await _rpc('merchant_abandoned_carts', {'p_shop': shopId}));

  static Future<void> markReminded(String cartId) => _rpc('merchant_mark_cart_reminded', {'p_cart': cartId});

  static Future<void> confirmOrder(String orderId) => _rpc('merchant_confirm_order', {'p_order': orderId});

  /// «عملة المتجر» (any of [storeCurrencies]); nothing is converted.
  static Future<void> setCurrency(String shopId, String currency) => _rpc('set_shop_currency', {'p_shop': shopId, 'p_currency': currency});

  /// `/#/s/<slug>?cart=<token>` — the «كمّل طلبك» link.
  static String cartUrl(String slug, String token) => 'https://mogtama3y.com/#/s/$slug?cart=$token';
}

/// A refusal to show as is.
class CheckoutProblem implements Exception {
  const CheckoutProblem(this.message);
  final String message;
  @override
  String toString() => message;
}

/// store_checkout_info().
class CheckoutInfo {
  const CheckoutInfo(this.raw);
  final Map<String, dynamic> raw;

  String get country => raw['country'] as String? ?? 'EG';
  List<Map<String, dynamic>> get zones => [for (final z in raw['zones'] as List? ?? const []) Map<String, dynamic>.from(z as Map)];

  /// Delivery outside every zone: false = «مش بنوصّل هناك».
  bool get deliversElsewhere => raw['default_mode'] != 'none';

  /// The customer must pick an area (zones exist or only zones are served).
  bool get needsArea => zones.isNotEmpty || !deliversElsewhere;
  Map<String, dynamic>? get pickup => raw['pickup'] == null ? null : Map<String, dynamic>.from(raw['pickup'] as Map);
  bool get hasCodes => raw['has_codes'] == true;
  bool get requireConfirmation => raw['require_confirmation'] == true;
  Map<String, dynamic> get open => Map<String, dynamic>.from(raw['open'] as Map? ?? const {'can_order': true, 'code': 'ok'});
  List<Map<String, dynamic>> get autoDiscounts => [for (final d in raw['auto_discounts'] as List? ?? const []) Map<String, dynamic>.from(d as Map)];
}

/// shop_checkout_methods().
class CheckoutMethods {
  const CheckoutMethods(this.raw);
  final Map<String, dynamic> raw;

  bool get cod => raw['cod'] != false;

  /// Online payment the store takes now (0100: the shop's Fawaterak).
  bool get online => (raw['online'] as List? ?? const []).any((g) => g is Map && g['provider'] == 'fawaterak');
}

/// quote_store_checkout().
class CheckoutQuote {
  const CheckoutQuote(this.raw);
  final Map<String, dynamic> raw;

  double _n(String k) => (raw[k] as num?)?.toDouble() ?? 0;

  double get subtotal => _n('subtotal');
  double get shipping => _n('shipping_fee');
  double get shippingBase => _n('shipping_base');
  double get discount => _n('discount_amount');
  double get total => _n('total');
  double? get freeOver => (raw['free_over'] as num?)?.toDouble();
  bool get freeShipping => raw['free_shipping'] == true;
  String? get zone => raw['shipping_zone'] as String?;
  String? get eta => raw['shipping_eta'] as String?;
  String? get discountTitle => raw['discount_title'] as String?;
  String? get discountCode => raw['discount_code'] as String?;
  String? get autoTitle => raw['auto_title'] as String?;

  /// applied | invalid | not_applicable | not_better | blocked (null: no code).
  String? get codeStatus => raw['code_status'] as String?;
  String? get codeMessage => raw['code_message'] as String?;
  String? get hint => raw['hint'] as String?;
  bool get canOrder => raw['can_order'] != false;
  List<Map<String, dynamic>> get errors => [for (final e in raw['errors'] as List? ?? const []) Map<String, dynamic>.from(e as Map)];
  Map<String, dynamic> get open => Map<String, dynamic>.from(raw['open'] as Map? ?? const {});
  List<Map<String, dynamic>> get lines => [for (final l in raw['lines'] as List? ?? const []) Map<String, dynamic>.from(l as Map)];
}
