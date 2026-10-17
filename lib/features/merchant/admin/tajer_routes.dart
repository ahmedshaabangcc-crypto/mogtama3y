import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/demo/demo_mode.dart';
import '../home_page.dart';
import '../orders_page.dart';
import '../product_editor_page.dart';
import '../products_page.dart';
import '../settings_page.dart';
import 'admin_common.dart';
import 'admin_shell.dart';

/// The merchant admin's bookmarkable pages (APP_FLAVOR=tajer), inside
/// [TajerAdminShell]:
///
///   /dashboard, /orders, /orders/:id, /products, /products/new,
///   /products/:id, /customers, /discounts, /settings
///
/// `/orders` and `/orders/:id` share one page key, so opening an order
/// keeps the list (master–detail) instead of building a new page.
RouteBase tajerAdminRoutes() => ShellRoute(
      builder: (_, state, child) => TajerAdminShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(path: '/dashboard', pageBuilder: (_, _) => _page('home', const HomePage())),
        GoRoute(path: '/orders', pageBuilder: (_, _) => _page('orders', const OrdersPage())),
        GoRoute(path: '/orders/:id', pageBuilder: (_, s) => _page('orders', OrdersPage(selectedId: s.pathParameters['id']))),
        GoRoute(path: '/products', pageBuilder: (_, _) => _page('products', const ProductsPage())),
        GoRoute(path: '/products/new', pageBuilder: (_, _) => _page('product-new', const ProductEditorPage())),
        GoRoute(
          path: '/products/:id',
          pageBuilder: (_, s) => _page(
            'product-${s.pathParameters['id']}',
            ProductEditorPage(productId: s.pathParameters['id'], initial: s.extra is Map<String, dynamic> ? s.extra as Map<String, dynamic> : null),
          ),
        ),
        GoRoute(
          path: '/customers',
          pageBuilder: (_, _) => _page(
            'customers',
            const ComingSoonPage(title: 'العملاء', icon: Icons.people_rounded, text: 'هنا هتلاقي زباينك: مين طلب كام مرة، وصرف قد إيه، وتتواصل معاهم بسهولة.'),
          ),
        ),
        GoRoute(
          path: '/discounts',
          pageBuilder: (_, _) => _page(
            'discounts',
            const ComingSoonPage(title: 'الخصومات', icon: Icons.local_offer_rounded, text: 'كوبونات خصم وعروض لفترة محدودة تشجّع زباينك يطلبوا تاني.'),
          ),
        ),
        GoRoute(path: '/settings', pageBuilder: (_, _) => _page('settings', const SettingsPage())),
      ],
    );

NoTransitionPage<void> _page(String key, Widget child) => NoTransitionPage<void>(key: ValueKey('tajer-$key'), child: child);

/// Signed in → the admin; signed out → the campaign page at `/`.
String? tajerRedirect(GoRouterState state) {
  final path = state.uri.path;
  final signedIn = AuthService.isSignedIn;
  if (path == '/' || path.isEmpty || path == '/merchant') {
    if (!signedIn) return null;
    // Demo build shortcuts of old recordings: `/?tab=…&add=1`.
    if (kDemo) {
      final q = state.uri.queryParameters;
      if (q['add'] == '1') return '/products/new';
      final tab = int.tryParse(q['tab'] ?? '');
      if (tab != null) return const ['/dashboard', '/products', '/orders', '/settings'][tab.clamp(0, 3)];
    }
    return '/dashboard';
  }
  if (isTajerAdminPath(path) && !signedIn) return '/';
  return null;
}

/// Re-runs the redirects when the merchant signs in or out.
class TajerAuthRefresh extends ChangeNotifier {
  TajerAuthRefresh() {
    try {
      _sub = AuthService.authStateChanges.listen((_) {
        final now = AuthService.isSignedIn;
        if (now != _signedIn) {
          _signedIn = now;
          notifyListeners();
        }
      });
      _signedIn = AuthService.isSignedIn;
    } catch (_) {
      // Supabase not initialised (tests).
    }
  }

  StreamSubscription<Object?>? _sub;
  bool _signedIn = false;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
