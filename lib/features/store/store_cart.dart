import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// One line in the storefront cart: a product + its chosen options.
class CartLine {
  CartLine({required this.product, required this.options, required this.quantity});
  final Map<String, dynamic> product;
  final String options; // e.g. "المقاس: L • اللون: أسود" ('' when none)
  int quantity;

  String get key => '${product['id']}|$options';
  double get unitPrice => (product['price'] as num?)?.toDouble() ?? 0;
  double get total => unitPrice * quantity;
  int? get stock => product['stock'] as int?;
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

  void add(Map<String, dynamic> product, {String options = '', int quantity = 1}) {
    final line = CartLine(product: product, options: options, quantity: quantity);
    final existing = _lines[line.key];
    if (existing != null) {
      existing.quantity = (existing.quantity + quantity).clamp(1, 99);
    } else {
      _lines[line.key] = line;
    }
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

  List<Map<String, dynamic>> toOrderLines() => [
        for (final l in _lines.values) {'product_id': l.product['id'], 'quantity': l.quantity, 'options': l.options},
      ];
}

String egp(num v) => '${NumberFormat('#,##0.##').format(v)} ج.م';

/// "−20%" when the product has a real discount, else null.
String? discountLabel(Map<String, dynamic> p) {
  final price = (p['price'] as num?)?.toDouble();
  final old = (p['old_price'] as num?)?.toDouble();
  if (price == null || old == null || old <= price) return null;
  return '−${((1 - price / old) * 100).round()}%';
}

bool isSoldOut(Map<String, dynamic> p) => p['stock'] is int && (p['stock'] as int) <= 0;
