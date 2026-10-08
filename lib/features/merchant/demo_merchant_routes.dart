import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/demo/demo_mode.dart';
import '../../core/shops/store_service.dart';
import '../store/checkout_screen.dart';
import '../store/store_cart.dart';
import 'starter_products_screen.dart';
import 'store_qr_card_screen.dart';

/// Demo build only (added to the router behind `kDemo && isTajerApp`):
/// direct links to merchant-app screens that are otherwise tabs or pushed
/// pages, so each one can be opened straight away for a recording.
///
///   /#/dashboard, /#/products, /#/add-product, /#/orders, /#/my-store
///   (the panel's tabs — they redirect to `/?tab=…`), /#/qr-card,
///   /#/starter, /#/pricing, /#/checkout (the demo store's cart, filled).
final demoTajerRoutes = <GoRoute>[
  GoRoute(path: 'dashboard', redirect: (_, _) => '/?tab=0'),
  GoRoute(path: 'products', redirect: (_, _) => '/?tab=1'),
  GoRoute(path: 'add-product', redirect: (_, _) => '/?tab=1&add=1'),
  GoRoute(path: 'orders', redirect: (_, _) => '/?tab=2'),
  GoRoute(path: 'my-store', redirect: (_, _) => '/?tab=3'),
  GoRoute(
    path: 'qr-card',
    builder: (_, _) => _MyShop(
      builder: (shop) {
        final slug = shop['slug'] as String? ?? demoShopSlug;
        return StoreQrCardScreen(shopName: shop['name'] as String? ?? '', slug: slug, url: StoreService.storeUrl(slug));
      },
    ),
  ),
  GoRoute(
    path: 'starter',
    builder: (_, _) => _MyShop(builder: (shop) => StarterProductsScreen(shopId: shop['id'] as String, shopCategory: shop['category'] as String?)),
  ),
  GoRoute(path: 'pricing', builder: (_, _) => _MyShop(builder: (shop) => QuickPricingScreen(shopId: shop['id'] as String))),
  GoRoute(path: 'checkout', builder: (_, _) => const _DemoCheckout()),
];

final demoTajerPaths = {for (final r in demoTajerRoutes) '/${r.path}'};

/// Loads the signed-in merchant's first shop, then shows [builder].
class _MyShop extends StatelessWidget {
  const _MyShop({required this.builder});
  final Widget Function(Map<String, dynamic> shop) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: StoreService.fetchMyShops(),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final shops = snap.data!;
        if (shops.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('مفيش محل في الدور ده — اختار دور «التاجر» من مبدّل الأدوار')),
          );
        }
        return builder(shops.first);
      },
    );
  }
}

/// The demo store's checkout with two products already in the cart.
class _DemoCheckout extends StatefulWidget {
  const _DemoCheckout();

  @override
  State<_DemoCheckout> createState() => _DemoCheckoutState();
}

class _DemoCheckoutState extends State<_DemoCheckout> {
  final _cart = StoreCart();
  Map<String, dynamic>? _shop;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final shop = await StoreService.fetchStoreBySlug(demoShopSlug);
    if (shop == null) return;
    final products = await StoreService.fetchProducts(shop['id'] as String);
    for (final (i, p) in products.where((p) => StoreService.optionsOf(p).isEmpty).take(2).indexed) {
      _cart.add(p, quantity: i == 0 ? 2 : 1);
    }
    if (mounted) setState(() => _shop = shop);
  }

  @override
  Widget build(BuildContext context) {
    final shop = _shop;
    if (shop == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return CheckoutScreen(shop: shop, cart: _cart);
  }
}
