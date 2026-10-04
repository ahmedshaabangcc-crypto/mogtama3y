import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import 'checkout_screen.dart';
import 'store_cart.dart';

/// Product page: swipeable photos, price/discount, options (size,
/// colour…), quantity, highlights, description, share, add to cart / buy.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.shop, required this.product, required this.cart, required this.canOrder});
  final Map<String, dynamic> shop;
  final Map<String, dynamic> product;
  final StoreCart cart;
  final bool canOrder;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _page = 0;
  int _qty = 1;
  final Map<String, String> _chosen = {};

  Map<String, dynamic> get p => widget.product;
  List<({String name, List<String> values})> get _options => StoreService.optionsOf(p);

  String? get _missingOption => _options.where((o) => !_chosen.containsKey(o.name)).map((o) => o.name).firstOrNull;
  String get _optionsText => [for (final o in _options) if (_chosen[o.name] != null) '${o.name}: ${_chosen[o.name]}'].join(' • ');

  bool _addToCart() {
    final missing = _missingOption;
    if (missing != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اختار $missing الأول')));
      return false;
    }
    final stock = p['stock'] as int?;
    if (stock != null && widget.cart.quantityOf(p['id'] as String) + _qty > stock) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('المتاح من المنتج ده $stock بس')));
      return false;
    }
    widget.cart.add(p, options: _optionsText, quantity: _qty);
    return true;
  }

  void _share() {
    final slug = widget.shop['slug'] as String?;
    if (slug == null) return;
    final text = '${p['name']} — ${egp((p['price'] as num?) ?? 0)}\nمن ${widget.shop['name']}، اطلبه من هنا:\n${StoreService.productUrl(slug, p['id'] as String)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final images = StoreService.imagesOf(p);
    final highlights = List<String>.from(p['highlights'] as List? ?? const []);
    final discount = discountLabel(p);
    final old = p['old_price'] as num?;
    final soldOut = isSoldOut(p);
    final stock = p['stock'] as int?;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.shop['name'] as String? ?? ''),
        actions: [IconButton(tooltip: 'شارك المنتج', onPressed: _share, icon: const Icon(Icons.share_rounded))],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          if (images.isNotEmpty)
            SizedBox(
              height: width.clamp(0, 520).toDouble(),
              child: Stack(children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => InteractiveViewer(
                    child: Image.network(images[i], fit: BoxFit.cover, width: double.infinity,
                        errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (var i = 0; i < images.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _page ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(color: i == _page ? Colors.white : Colors.white54, borderRadius: BorderRadius.circular(8)),
                        ),
                    ]),
                  ),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p['name'] as String? ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, height: 1.35)),
              const SizedBox(height: 8),
              Row(children: [
                Text(egp((p['price'] as num?) ?? 0), style: const TextStyle(color: AppColors.crystal, fontSize: 22, fontWeight: FontWeight.w800)),
                if (old != null && discount != null) ...[
                  const SizedBox(width: 10),
                  Text(egp(old), style: const TextStyle(color: AppColors.inkMuted, fontSize: 14, decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(10)),
                    child: Text('خصم $discount', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.night)),
                  ),
                ],
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.inkMuted),
                const SizedBox(width: 6),
                Text(soldOut ? 'نفدت الكمية' : '${StoreService.deliveryLabel(widget.shop)} • الدفع عند الاستلام', style: TextStyle(color: soldOut ? Colors.redAccent : AppColors.inkMuted, fontSize: 12.5)),
                if (!soldOut && stock != null && stock <= 5) ...[
                  const SizedBox(width: 10),
                  Text('باقي $stock بس!', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 12.5)),
                ],
              ]),
              for (final o in _options) ...[
                const SizedBox(height: 16),
                Text(o.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final v in o.values)
                    ChoiceChip(label: Text(v), selected: _chosen[o.name] == v, onSelected: (_) => setState(() => _chosen[o.name] = v)),
                ]),
              ],
              if (widget.canOrder && !soldOut) ...[
                const SizedBox(height: 16),
                Row(children: [
                  const Text('الكمية', style: TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton.outlined(onPressed: _qty > 1 ? () => setState(() => _qty--) : null, icon: const Icon(Icons.remove_rounded)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('$_qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                  IconButton.outlined(onPressed: _qty < (stock ?? 99) ? () => setState(() => _qty++) : null, icon: const Icon(Icons.add_rounded)),
                ]),
              ],
              if (highlights.isNotEmpty) ...[
                const SizedBox(height: 18),
                for (final h in highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                      const SizedBox(width: 8),
                      Expanded(child: Text(h, style: const TextStyle(fontSize: 14))),
                    ]),
                  ),
              ],
              if ((p['description'] as String?)?.isNotEmpty ?? false) ...[
                const SizedBox(height: 14),
                const Text('تفاصيل المنتج', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 6),
                Text(p['description'] as String, style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.inkSecondary)),
              ],
            ]),
          ),
        ],
      ),
      bottomNavigationBar: !widget.canOrder || soldOut
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_addToCart()) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                        label: const Text('أضف للسلة'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_addToCart()) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => CheckoutScreen(shop: widget.shop, cart: widget.cart)),
                          );
                        },
                        child: const Text('اطلب دلوقتي'),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
