import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/catalog.dart';
import '../../core/shops/shop_pixels.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import 'checkout_screen.dart';
import 'store_cart.dart';
import 'package:mogtama3y/core/geo/money.dart';

/// Product page: swipeable photos, price/discount, options (size,
/// colour…), quantity, highlights, description, video, share, add to
/// cart / buy.
///
/// A product with variants (0098) gets one picker per option: values
/// with no available variant in stock are crossed out, and the chosen
/// variant switches the price, compare-at, stock and photo. A product
/// with options but no variants (older rows) keeps the free-text options.
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
  final _pages = PageController();
  int _page = 0;
  int _qty = 1;
  final Map<String, String> _chosen = {};

  Map<String, dynamic> get base => widget.product;
  List<ProductOption> get _options => productOptions(base);
  bool get _hasVariants => variantsOf(base).isNotEmpty;

  /// The chosen variant (all options picked), else null.
  Map<String, dynamic>? get _variant => _hasVariants ? findVariant(base, _chosen) : null;

  /// What the page shows: the chosen variant's view of the product.
  Map<String, dynamic> get p => productWithVariant(base, _variant);

  @override
  void initState() {
    super.initState();
    // One value only → pre-picked; a single variant → everything picked.
    final variants = variantsOf(base);
    for (final (i, o) in _options.indexed) {
      if (o.values.length == 1) _chosen[o.name] = o.values.first;
      if (variants.length == 1 && i < valuesOf(variants.first).length) _chosen[o.name] = valuesOf(variants.first)[i];
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  String? get _missingOption => _options.where((o) => !_chosen.containsKey(o.name)).map((o) => o.name).firstOrNull;
  String get _optionsText => [for (final o in _options) if (_chosen[o.name] != null) '${o.name}: ${_chosen[o.name]}'].join(' • ');

  void _choose(String option, String value) {
    setState(() {
      if (_chosen[option] == value) {
        _chosen.remove(option);
      } else {
        _chosen[option] = value;
      }
      _qty = 1;
    });
    final v = _variant;
    final img = v?['image_url'] as String?;
    if (img != null) {
      // The variant's photo comes first in its image list: show it.
      if (_pages.hasClients) _pages.jumpToPage(0);
      setState(() => _page = 0);
    }
    if (v != null) ShopPixels.viewContent(productWithVariant(base, v));
  }

  bool _addToCart() {
    final missing = _missingOption;
    if (missing != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اختار $missing الأول')));
      return false;
    }
    final v = _variant;
    if (_hasVariants && v == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('النوع ده مش متاح، اختار نوع تاني')));
      return false;
    }
    final shown = p;
    final stock = (shown['stock'] as num?)?.toInt();
    final inCart = v != null ? widget.cart.quantityOfVariant(v['id'] as String) : widget.cart.quantityOf(base['id'] as String);
    if (stock != null && inCart + _qty > stock) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stock <= 0 ? 'النوع ده خلص' : 'المتاح من ده $stock بس')));
      return false;
    }
    widget.cart.add(shown, options: v != null ? variantLabelOf(base, v) : _optionsText, quantity: _qty);
    return true;
  }

  void _share() {
    final slug = widget.shop['slug'] as String?;
    if (slug == null) return;
    final text = '${base['name']} — ${shopMoney((p['price'] as num?) ?? 0, currencyOf(base))}\nمن ${widget.shop['name']}، اطلبه من هنا:\n${StoreService.productUrl(slug, base['id'] as String)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  Widget _priceRow() {
    final shown = p;
    final discount = discountLabel(shown);
    final old = shown['old_price'] as num?;
    final range = priceRange(base);
    final from = _hasVariants && _variant == null && range.min != range.max;
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 10, runSpacing: 4, children: [
      Text(
        from ? 'من ${shopMoney(range.min, currencyOf(base))}' : shopMoney((shown['price'] as num?) ?? 0, currencyOf(base)),
        key: const ValueKey('product-price'),
        style: const TextStyle(color: AppColors.crystal, fontSize: 22, fontWeight: FontWeight.w800),
      ),
      if (!from && old != null && discount != null) ...[
        Text(shopMoney(old, currencyOf(base)), style: const TextStyle(color: AppColors.inkMuted, fontSize: 14, decoration: TextDecoration.lineThrough)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(10)),
          child: Text('خصم $discount', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.night)),
        ),
      ],
    ]);
  }

  Widget _pickers() {
    final variants = _hasVariants;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final (i, o) in _options.indexed) ...[
        const SizedBox(height: 16),
        Text(_chosen[o.name] == null ? o.name : '${o.name}: ${_chosen[o.name]}', style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final v in o.values)
            () {
              final available = !variants || valueAvailable(base, i, v, _chosen);
              return ChoiceChip(
                key: ValueKey('opt-${o.name}-$v'),
                label: Text(v,
                    style: TextStyle(
                      decoration: available ? null : TextDecoration.lineThrough,
                      color: _chosen[o.name] == v ? Colors.white : (available ? AppColors.ink : AppColors.inkMuted),
                      fontWeight: _chosen[o.name] == v ? FontWeight.w700 : null,
                    )),
                checkmarkColor: Colors.white,
                selected: _chosen[o.name] == v,
                tooltip: available ? null : 'خلص',
                onSelected: (_) => _choose(o.name, v),
              );
            }(),
        ]),
      ],
    ]);
  }

  Widget? _video() {
    final id = youtubeId(base['video_url'] as String?);
    if (id == null) return null;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => launchUrl(Uri.parse('https://www.youtube.com/watch?v=$id'), mode: LaunchMode.externalApplication),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(fit: StackFit.expand, children: [
              Image.network('https://img.youtube.com/vi/$id/hqdefault.jpg', fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
              const Center(child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 64)),
              const PositionedDirectional(
                start: 12,
                bottom: 10,
                child: Text('شوف فيديو المنتج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, shadows: [Shadow(blurRadius: 6)])),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shown = p;
    final images = StoreService.imagesOf(shown);
    final highlights = List<String>.from(base['highlights'] as List? ?? const []);
    final v = _variant;
    // Sold out: the chosen variant, or (nothing chosen yet) every variant.
    final soldOut = _hasVariants ? (v != null ? isSoldOut(shown) : allSoldOut(base)) : isSoldOut(base);
    final stock = (shown['stock'] as num?)?.toInt();
    final width = MediaQuery.sizeOf(context).width;
    final video = _video();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.shop['name'] as String? ?? ''),
        actions: [IconButton(tooltip: 'شارك المنتج', onPressed: _share, icon: const Icon(Icons.share_rounded))],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              if (images.isNotEmpty)
                SizedBox(
                  // Desktop: a shorter gallery keeps the pickers in view.
                  height: width >= 900 ? 380 : width.clamp(0, 520).toDouble(),
                  child: Stack(children: [
                    PageView.builder(
                      key: ValueKey('photos-${v?['id'] ?? 'p'}'),
                      controller: _pages,
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
                  Text(base['name'] as String? ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, height: 1.35)),
                  const SizedBox(height: 8),
                  _priceRow(),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.inkMuted),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(soldOut ? (v != null ? 'النوع ده خلص' : 'نفدت الكمية') : '${StoreService.deliveryLabel(widget.shop)} • الدفع عند الاستلام',
                          style: TextStyle(color: soldOut ? Colors.redAccent : AppColors.inkMuted, fontSize: 12.5)),
                    ),
                    if (!soldOut && stock != null && stock <= 5 && (!_hasVariants || v != null)) ...[
                      const SizedBox(width: 10),
                      Text('باقي $stock بس!', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 12.5)),
                    ],
                  ]),
                  _pickers(),
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
                  if ((base['description'] as String?)?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 14),
                    const Text('تفاصيل المنتج', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 6),
                    Text(base['description'] as String, style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.inkSecondary)),
                  ],
                  ?video,
                ]),
              ),
            ],
          ),
        ),
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
