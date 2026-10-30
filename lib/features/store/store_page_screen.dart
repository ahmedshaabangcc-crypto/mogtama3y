import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/catalog.dart';
import '../../core/shops/shop_pixels.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import '../../core/shops/checkout_service.dart';
import 'cart_storage.dart';
import 'checkout_screen.dart';
import 'product_screen.dart';
import 'store_cart.dart';
import 'package:mogtama3y/core/geo/money.dart';

/// A merchant's storefront at `mogtama3y.com/#/s/<slug>` — what the QR on
/// the shop and every shared product link open. Browsing and ordering need
/// no account: the customer checks out with name, mobile and address and
/// pays on delivery (migration 0054).
class StorePageScreen extends StatefulWidget {
  const StorePageScreen({super.key, required this.slug, this.productId, this.cartToken});
  final String slug;

  /// `?cart=<token>`: a «كمّل طلبك» link (0099) — restores that cart.
  final String? cartToken;

  /// Opens this product right away (shared product links `/s/<slug>/p/<id>`).
  final String? productId;

  @override
  State<StorePageScreen> createState() => _StorePageScreenState();
}

class _StorePageScreenState extends State<StorePageScreen> {
  final _cart = StoreCart();
  final _search = TextEditingController();
  bool _loading = true;
  bool _loadError = false;
  Map<String, dynamic>? _shop;
  List<Map<String, dynamic>> _products = [];
  String? _category;

  /// The merchant's visible collections (0098); empty → the old
  /// free-text categories make the chips.
  List<Map<String, dynamic>> _collections = [];
  String? _collectionId;

  /// The merchant's pixel IDs (0097); non-empty → the «أدوات قياس» note.
  Map<String, dynamic> _tracking = const {};

  @override
  void initState() {
    super.initState();
    StoreService.recordScan(widget.slug);
    _cart.addListener(_onCart);
    _load();
  }

  void _onCart() {
    setState(() {});
    final id = _shop?['id'] as String?;
    if (id != null && _cartRestored) CartStorage.save(id, _cart);
  }

  /// The saved cart is back (so restoring doesn't overwrite it with nothing).
  bool _cartRestored = false;

  /// A «كمّل طلبك» link's cart, or the one saved in this browser.
  Future<void> _restoreCart(String shopId, List<Map<String, dynamic>> products) async {
    final token = widget.cartToken;
    final fromLink = token == null ? null : await CheckoutService.cartLines(token);
    final lines = fromLink ?? await CartStorage.load(shopId);
    if (mounted && lines.isNotEmpty && _cart.isEmpty) _cart.restore(lines, products);
    _cartRestored = true;
    if (mounted && fromLink != null && fromLink.isNotEmpty && !_cart.isEmpty) {
      CartStorage.save(shopId, _cart);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openCart();
      });
    }
  }

  @override
  void dispose() {
    ShopPixels.close();
    _cart.removeListener(_onCart);
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final shop = await StoreService.fetchStoreBySlug(widget.slug);
      var products = <Map<String, dynamic>>[];
      var collections = <Map<String, dynamic>>[];
      if (shop != null) {
        try {
          final catalog = await StoreService.storeCatalog(shop['id'] as String);
          products = catalog.products;
          collections = catalog.collections;
        } catch (_) {
          // A backend without 0098: the plain product list.
          products = await StoreService.fetchProducts(shop['id'] as String);
        }
      }
      if (!mounted) return;
      setState(() {
        _shop = shop;
        _products = products;
        _collections = collections;
        _loading = false;
      });
      if (shop != null) {
        _startPixels(shop['id'] as String);
        _restoreCart(shop['id'] as String, products);
      }
      final pid = widget.productId;
      if (pid != null) {
        final p = products.where((x) => x['id'] == pid).firstOrNull;
        if (p != null) WidgetsBinding.instance.addPostFrameCallback((_) => _openProduct(p));
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadError = true;
          _loading = false;
        });
      }
    }
  }

  // A store the admin suspended (0107) shows its products but takes no orders.
  bool get _suspended => _shop?['suspended_at'] != null;
  bool get _acceptsOrders => _shop?['owner_id'] != null && !_suspended;

  List<String> get _categories {
    final set = <String>{};
    for (final p in _products) {
      final c = (p['category'] as String?)?.trim();
      if (c != null && c.isNotEmpty) set.add(c);
    }
    return set.toList();
  }

  List<Map<String, dynamic>> get _visible {
    final q = _search.text.trim().toLowerCase();
    final inCollection = _collectionId == null
        ? null
        : [for (final id in (_collections.firstWhere((c) => c['id'] == _collectionId, orElse: () => const {})['product_ids'] as List? ?? const [])) '$id'];
    final list = _products.where((p) {
      if (inCollection != null && !inCollection.contains(p['id'])) return false;
      if (_category != null && p['category'] != _category) return false;
      if (q.isEmpty) return true;
      return '${p['name']} ${p['description'] ?? ''} ${(p['tags'] as List? ?? const []).join(' ')}'.toLowerCase().contains(q);
    }).toList();
    // A collection keeps its own order.
    if (inCollection != null) list.sort((a, b) => inCollection.indexOf(a['id'] as String).compareTo(inCollection.indexOf(b['id'] as String)));
    return list;
  }

  Future<void> _startPixels(String shopId) async {
    final t = await ShopPixels.open(shopId);
    if (!mounted) return;
    ShopPixels.pageView('s/${widget.slug}');
    if (t.isNotEmpty) setState(() => _tracking = t);
  }

  void _openProduct(Map<String, dynamic> p) {
    ShopPixels.pageView('s/${widget.slug}/p/${p['id']}');
    ShopPixels.viewContent(p);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProductScreen(shop: _shop!, product: p, cart: _cart, canOrder: _acceptsOrders),
    ));
  }

  void _openCart() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CheckoutScreen(shop: _shop!, cart: _cart, cartToken: widget.cartToken)));
  }

  void _shareStore() {
    final url = 'https://mogtama3y.com/#/s/${widget.slug}';
    final text = 'اتفرّج على منتجات ${_shop?['name']} واطلب أونلاين: $url';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_loadError) return Scaffold(appBar: AppBar(), body: LoadErrorView(onRetry: _load));
    final shop = _shop;
    if (shop == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('المتجر ده مش موجود. اتأكد من اللينك.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
          ),
        ),
      );
    }

    final visible = _visible;
    final cats = _collections.isEmpty ? _categories : const <String>[];
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: AppColors.night,
            foregroundColor: Colors.white,
            title: Text(shop['name'] as String? ?? '', style: const TextStyle(color: Colors.white)),
            actions: [
              IconButton(tooltip: 'شارك المتجر', onPressed: _shareStore, icon: const Icon(Icons.share_rounded)),
              IconButton(
                tooltip: 'انسخ اللينك',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: 'https://mogtama3y.com/#/s/${widget.slug}'));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتنسخ لينك المتجر')));
                },
                icon: const Icon(Icons.link_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(background: _StoreHeader(shop: shop)),
          ),
          if (_suspended)
            SliverToBoxAdapter(
              child: Container(
                key: const ValueKey('store-suspended'),
                margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                child: const Row(children: [
                  Icon(Icons.block_rounded, color: AppColors.categorySos),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('المتجر ده موقوف مؤقتاً من إدارة مُجتمعي ومش بيستقبل طلبات دلوقتي.',
                        style: TextStyle(color: AppColors.categorySos, fontWeight: FontWeight.w700, height: 1.5)),
                  ),
                ]),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'دوّر في منتجات ${shop['name']}',
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                ),
              ),
            ),
          ),
          if (_collections.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  key: const ValueKey('collection-chips'),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(label: const Text('الكل'), selected: _collectionId == null, onSelected: (_) => setState(() => _collectionId = null)),
                    ),
                    for (final c in _collections)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(c['name'] as String? ?? ''),
                          selected: _collectionId == c['id'],
                          onSelected: (_) => setState(() => _collectionId = c['id'] as String),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (cats.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(label: const Text('الكل'), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
                    ),
                    for (final c in cats)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
                      ),
                  ],
                ),
              ),
            ),
          if (visible.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_products.isEmpty ? 'المحل لسه بيضيف منتجاته' : 'مفيش منتجات بالبحث ده',
                      style: const TextStyle(color: AppColors.inkMuted)),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ProductCard(
                    product: visible[i],
                    inCart: _cart.quantityOf(visible[i]['id'] as String),
                    canOrder: _acceptsOrders,
                    onOpen: () => _openProduct(visible[i]),
                    onQuickAdd: () {
                      final p = visible[i];
                      final variants = variantsOf(p);
                      if (variants.length > 1 || (variants.isEmpty && StoreService.optionsOf(p).isNotEmpty)) return _openProduct(p);
                      final shown = variants.isEmpty ? p : productWithVariant(p, variants.first);
                      final stock = (shown['stock'] as num?)?.toInt();
                      if (stock != null && (variants.isEmpty ? _cart.quantityOf(p['id'] as String) : _cart.quantityOfVariant(variants.first['id'] as String)) >= stock) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('المتاح من المنتج ده $stock بس')));
                        return;
                      }
                      _cart.add(shown, options: variants.isEmpty ? '' : variantLabelOf(p, variants.first));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اتضاف «${p['name']}» للسلة'), duration: const Duration(seconds: 1)));
                    },
                  ),
                  childCount: visible.length,
                ),
              ),
            ),
          if (_tracking.isNotEmpty) const SliverToBoxAdapter(child: _TrackingNote()),
        ],
      ),
      bottomNavigationBar: _cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _openCart,
                    child: Row(children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.gold,
                        child: Text('${_cart.count}', style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('السلة — كمّل الطلب', style: TextStyle(fontWeight: FontWeight.w800))),
                      Text(shopMoney(_cart.total, currencyOf(_shop)), style: const TextStyle(fontWeight: FontWeight.w800)),
                    ]),
                  ),
                ),
              ),
            ),
    );
  }
}

/// «المتجر ده بيستخدم أدوات قياس» under a store with merchant pixels (0097).
class _TrackingNote extends StatelessWidget {
  const _TrackingNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      child: Center(
        child: TextButton.icon(
          icon: const Icon(Icons.insights_rounded, size: 16, color: AppColors.inkMuted),
          label: const Text('المتجر ده بيستخدم أدوات قياس', style: TextStyle(fontSize: 12, color: AppColors.inkMuted, decoration: TextDecoration.underline)),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (_) => const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('أدوات القياس في المتجر ده', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  'صاحب المتجر بيستخدم أدوات قياس الإعلانات والزيارات (زي Meta وTikTok وSnapchat وGoogle) عشان يعرف إعلاناته جابت كام زيارة وطلب: '
                  'بتعرف إنك فتحت صفحة أو منتج، أو ضفت للسلة، أو طلبت (بالمبلغ ورقم الطلب).\n\n'
                  'الأدوات دي بتشتغل على صفحات المتجر ده بس، ومش بيوصلها اسمك ولا رقمك ولا عنوانك. '
                  'سياسة خصوصية المتجر نفسه: اسأل صاحب المتجر (صفحة خاصة بيها قريباً).',
                  style: TextStyle(height: 1.7, color: AppColors.inkSecondary),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.shop});
  final Map<String, dynamic> shop;

  @override
  Widget build(BuildContext context) {
    final cover = shop['cover_image_url'] as String?;
    final logo = shop['logo_url'] as String?;
    return Stack(fit: StackFit.expand, children: [
      if (cover != null)
        Image.network(cover, fit: BoxFit.cover, errorBuilder: (_, _, _) => const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.brandGradient)))
      else
        const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.brandGradient)),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black26, Colors.black87]),
        ),
      ),
      PositionedDirectional(
        start: 16,
        end: 16,
        bottom: 16,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 2),
              image: logo != null ? DecorationImage(image: ResizeImage(NetworkImage(logo), width: 240), fit: BoxFit.cover) : null,
            ),
            child: logo == null ? const Icon(Icons.storefront_rounded, color: AppColors.crystal, size: 32) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(shop['name'] as String? ?? '', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              if (shop['category'] != null)
                Text(shop['category'] as String, style: const TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w700)),
              Text('🚚 ${StoreService.deliveryLabel(shop)} • الدفع عند الاستلام', style: const TextStyle(color: Colors.white, fontSize: 11.5)),
              if ((shop['description'] as String?)?.isNotEmpty ?? false)
                Text(shop['description'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.inCart, required this.canOrder, required this.onOpen, required this.onQuickAdd});
  final Map<String, dynamic> product;
  final int inCart;
  final bool canOrder;
  final VoidCallback onOpen;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final images = StoreService.imagesOf(product);
    final discount = discountLabel(product);
    final soldOut = variantsOf(product).isNotEmpty ? allSoldOut(product) : isSoldOut(product);
    final old = product['old_price'] as num?;
    final range = priceRange(product);
    final from = range.min != range.max;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: Stack(fit: StackFit.expand, children: [
              if (images.isEmpty)
                const ColoredBox(color: AppColors.surfaceAlt, child: Icon(Icons.inventory_2_outlined, color: AppColors.inkMuted, size: 36))
              else
                Image.network(images.first, cacheWidth: 480, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
              if (discount != null)
                PositionedDirectional(top: 8, start: 8, child: _Badge(text: discount, color: AppColors.gold, ink: AppColors.night)),
              if (soldOut)
                const PositionedDirectional(top: 8, end: 8, child: _Badge(text: 'نفدت', color: Colors.black87, ink: Colors.white)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Text(product['name'] as String? ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.35)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 4, 8),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(from ? 'من ${shopMoney(range.min, currencyOf(product))}' : shopMoney((product['price'] as num?) ?? 0, currencyOf(product)),
                      style: const TextStyle(color: AppColors.crystal, fontWeight: FontWeight.w800, fontSize: 14)),
                  if (old != null && discount != null)
                    Text(shopMoney(old, currencyOf(product)), style: const TextStyle(color: AppColors.inkMuted, fontSize: 11, decoration: TextDecoration.lineThrough)),
                ]),
              ),
              if (canOrder && !soldOut)
                IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  onPressed: onQuickAdd,
                  icon: inCart > 0
                      ? Text('$inCart', style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white))
                      : const Icon(Icons.add_shopping_cart_rounded, size: 18),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color, required this.ink});
  final String text;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w800)),
      );
}
