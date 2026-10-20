import 'package:flutter/foundation.dart';
import 'package:mogtama3y/core/geo/money.dart';
import 'package:mogtama3y/core/shops/catalog.dart';
import 'package:mogtama3y/core/shops/shop_pixels.dart';

/// One line in the storefront cart: a product (as its chosen variant
/// shows it — price, stock, photo; see productWithVariant) + its options.
class CartLine {
  CartLine({required this.product, required this.options, required this.quantity, this.variantId});
  final Map<String, dynamic> product;
  final String options; // e.g. "المقاس: L • اللون: أسود" ('' when none) — the variant label
  int quantity;

  /// The chosen variant (0098); null for a product without variants.
  final String? variantId;

  /// The variant label shown with the line ('' when none).
  String get variantLabel => options;

  String get key => '${product['id']}|${variantId ?? ''}|$options';
  double get unitPrice => (product['price'] as num?)?.toDouble() ?? 0;
  double get total => unitPrice * quantity;
  int? get stock => (product['stock'] as num?)?.toInt();
}

/// Cart of one store visit (kept in memory while browsing the store).
class StoreCart extends ChangeNotifier {
  final Map<String, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList();
  int get count => _lines.values.fold(0, (s, l) => s + l.quantity);
  double get total => _lines.values.fold(0.0, (s, l) => s + l.total);
  bool get isEmpty => _lines.isEmpty;

  /// Units of this product already in the cart (all option combinations).
  int quantityOf(String productId) =>
      _lines.values.where((l) => l.product['id'] == productId).fold(0, (s, l) => s + l.quantity);

  /// Units of what [line] counts stock against: its variant, or (no
  /// variants) the product.
  int stockUnitsOf(CartLine line) => line.variantId != null
      ? _lines.values.where((l) => l.variantId == line.variantId).fold(0, (s, l) => s + l.quantity)
      : quantityOf(line.product['id'] as String);

  /// Units of a variant already in the cart.
  int quantityOfVariant(String variantId) => _lines.values.where((l) => l.variantId == variantId).fold(0, (s, l) => s + l.quantity);

  /// Whether one more of [line] fits its stock.
  bool canIncrease(CartLine line) => line.stock == null || stockUnitsOf(line) < line.stock!;

  /// [product]: as the variant shows it (productWithVariant) when one is
  /// chosen — its `variant_id` becomes the line's [CartLine.variantId].
  void add(Map<String, dynamic> product, {String options = '', int quantity = 1}) {
    final line = CartLine(product: product, options: options, quantity: quantity, variantId: product['variant_id'] as String?);
    final existing = _lines[line.key];
    if (existing != null) {
      existing.quantity = (existing.quantity + quantity).clamp(1, 99);
    } else {
      _lines[line.key] = line;
    }
    ShopPixels.addToCart(product, quantity); // merchant pixels (0097); no-op when none
    notifyListeners();
  }

  void setQuantity(CartLine line, int quantity) {
    if (quantity <= 0) {
      _lines.remove(line.key);
    } else {
      line.quantity = quantity.clamp(1, 99);
    }
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }

  /// Puts saved lines back (after a refresh, or a «كمّل طلبك» link) — no
  /// pixel events. [lines]: product_id, variant_id?, quantity, options;
  /// products / variants not in [products] (gone / hidden) are skipped.
  /// Replaces the cart.
  void restore(List<Map<String, dynamic>> lines, List<Map<String, dynamic>> products) {
    final byId = {for (final p in products) p['id']: p};
    _lines.clear();
    for (final l in lines) {
      final base = byId[l['product_id']];
      final qty = (l['quantity'] as num?)?.toInt() ?? 0;
      if (base == null || qty < 1) continue;
      final variants = variantsOf(base);
      Map<String, dynamic> p = base;
      var options = (l['options'] as String?) ?? '';
      if (variants.isNotEmpty) {
        final v = variants.where((v) => v['id'] == l['variant_id']).firstOrNull ??
            variants.where((v) => variantLabelOf(base, v) == options).firstOrNull;
        if (v == null) continue;
        p = productWithVariant(base, v);
        options = variantLabelOf(base, v);
      }
      if (isSoldOut(p)) continue;
      final line = CartLine(product: p, options: options, quantity: qty.clamp(1, 99), variantId: p['variant_id'] as String?);
      final stock = line.stock;
      if (stock != null && line.quantity > stock) line.quantity = stock;
      _lines[line.key] = line;
    }
    notifyListeners();
  }

  /// The lines as pixel event items (no options / customer data).
  List<PixelItem> toPixelItems() => [
        for (final l in _lines.values) PixelItem.fromProduct(l.product, l.quantity),
      ];

  /// place_store_order lines: {product_id, variant_id?, quantity, options}.
  List<Map<String, dynamic>> toOrderLines() => [
        for (final l in _lines.values)
          {'product_id': l.product['id'], 'variant_id': ?l.variantId, 'quantity': l.quantity, 'options': l.options},
      ];
}

/// A storefront price in the shop's [currency] (EGP when unknown) — was
/// egp() before 0092.
String shopMoney(num v, [String? currency]) => money(v, currency);

/// "−20%" when the product has a real discount, else null.
String? discountLabel(Map<String, dynamic> p) {
  final price = (p['price'] as num?)?.toDouble();
  final old = (p['old_price'] as num?)?.toDouble();
  if (price == null || old == null || old <= price) return null;
  return '−${((1 - price / old) * 100).round()}%';
}

bool isSoldOut(Map<String, dynamic> p) => p['stock'] is int && (p['stock'] as int) <= 0;
