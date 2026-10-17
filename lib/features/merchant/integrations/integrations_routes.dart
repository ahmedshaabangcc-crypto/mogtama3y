import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'domain_settings_screen.dart';
import 'integrations_hub_screen.dart';
import 'payments_settings_screen.dart';
import 'tracking_settings_screen.dart';

/// «الربط والتكاملات» pages inside the merchant admin shell (0097).
List<RouteBase> integrationsRoutes() => [
      GoRoute(path: '/settings/integrations', pageBuilder: (_, _) => _page('integrations', const IntegrationsHubScreen())),
      GoRoute(path: '/settings/payments', pageBuilder: (_, _) => _page('payments', const PaymentsSettingsScreen())),
      GoRoute(path: '/settings/domain', pageBuilder: (_, _) => _page('domain', const DomainSettingsScreen())),
      GoRoute(path: '/settings/tracking', pageBuilder: (_, _) => _page('tracking', const TrackingSettingsScreen())),
    ];

/// The paths above (for [isTajerAdminPath]).
final integrationsPath = RegExp(r'^/settings/(integrations|payments|domain|tracking)$');

NoTransitionPage<void> _page(String key, Widget child) => NoTransitionPage<void>(key: ValueKey('tajer-int-$key'), child: child);
