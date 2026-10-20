import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'abandoned_carts_page.dart';
import 'discounts_page.dart';
import 'shipping_settings_screen.dart';

/// Phase 3 pages inside the merchant admin shell (0099). `/orders/abandoned`
/// must come before `/orders/:id`.
List<RouteBase> checkoutRoutes() => [
      GoRoute(path: '/orders/abandoned', pageBuilder: (_, _) => _page('carts', const AbandonedCartsPage())),
      GoRoute(path: '/discounts', pageBuilder: (_, _) => _page('discounts', const DiscountsPage())),
      GoRoute(path: '/discounts/new', pageBuilder: (_, _) => _page('discount-new', const DiscountEditorPage())),
      GoRoute(
        path: '/discounts/:id',
        pageBuilder: (_, s) => _page(
          'discount-${s.pathParameters['id']}',
          DiscountEditorPage(discountId: s.pathParameters['id'], initial: s.extra is Map<String, dynamic> ? s.extra as Map<String, dynamic> : null),
        ),
      ),
      GoRoute(path: '/settings/shipping', pageBuilder: (_, _) => _page('shipping', const ShippingSettingsScreen())),
    ];

/// The paths above (for [isTajerAdminPath]).
final checkoutPath = RegExp(r'^/(orders/abandoned|discounts(/new|/[0-9a-f-]{36})?|settings/shipping)$');

NoTransitionPage<void> _page(String key, Widget child) => NoTransitionPage<void>(key: ValueKey('tajer-chk-$key'), child: child);
