import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/shops/print_card.dart';
import '../../../core/shops/store_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/load_error_view.dart';
import '../merchant_landing_screen.dart';
import '../register_shop_form.dart';
import '../integrations/integrations_routes.dart';
import '../checkout/checkout_routes.dart';
import 'account_menu.dart';
import 'admin_common.dart';
import 'merchant_session.dart';

/// One entry of the admin navigation.
class AdminDestination {
  const AdminDestination(this.path, this.label, this.icon, this.selectedIcon, {this.soon = false});
  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool soon;
}

const adminDestinations = [
  AdminDestination('/dashboard', 'الرئيسية', Icons.space_dashboard_outlined, Icons.space_dashboard_rounded),
  AdminDestination('/orders', 'الطلبات', Icons.receipt_long_outlined, Icons.receipt_long_rounded),
  AdminDestination('/products', 'المنتجات', Icons.inventory_2_outlined, Icons.inventory_2_rounded),
  AdminDestination('/collections', 'الأقسام', Icons.category_outlined, Icons.category_rounded),
  AdminDestination('/customers', 'العملاء', Icons.people_outline_rounded, Icons.people_rounded, soon: true),
  AdminDestination('/discounts', 'الخصومات', Icons.local_offer_outlined, Icons.local_offer_rounded),
  AdminDestination('/settings', 'متجري', Icons.storefront_outlined, Icons.storefront_rounded),
];

/// The phone bottom bar keeps today's four tabs.
const _mobilePaths = ['/dashboard', '/products', '/orders', '/settings'];

/// The admin paths of the tajer router (for redirects / deep links).
bool isTajerAdminPath(String path) =>
    RegExp(r'^/(dashboard|orders(/[0-9a-f-]{36})?|products(/new|/import|/[0-9a-f-]{36})?|collections(/new|/[0-9a-f-]{36})?|customers|discounts|settings)$').hasMatch(path) ||
    integrationsPath.hasMatch(path) ||
    checkoutPath.hasMatch(path);

/// The merchant admin around every page (APP_FLAVOR=tajer): bottom bar on
/// phones, a NavigationRail on tablets, a Shopify-like sidebar (shop
/// switcher, navigation, view store, account) from [AdminBreakpoints.sidebar].
class TajerAdminShell extends StatefulWidget {
  const TajerAdminShell({super.key, required this.location, required this.child, this.session});

  /// The current path (e.g. `/orders/…`): picks the selected destination.
  final String location;
  final Widget child;

  /// Tests pass their own; the app uses [MerchantSession.instance].
  final MerchantSession? session;

  @override
  State<TajerAdminShell> createState() => _TajerAdminShellState();
}

class _TajerAdminShellState extends State<TajerAdminShell> {
  late MerchantSession _session = widget.session ?? MerchantSession.instance;
  StreamSubscription<Map<String, dynamic>>? _alerts;

  @override
  void initState() {
    super.initState();
    _bind();
  }

  void _bind() {
    _alerts?.cancel();
    _alerts = _session.alerts.listen(_onNewOrder);
    if (_session.shops.isEmpty) {
      _session.load();
    } else {
      _session.resume();
    }
  }

  @override
  void didUpdateWidget(TajerAdminShell old) {
    super.didUpdateWidget(old);
    final next = widget.session ?? MerchantSession.instance;
    if (!identical(next, _session)) {
      _session.pause();
      _session = next;
      _bind();
    }
  }

  @override
  void dispose() {
    _alerts?.cancel();
    _session.pause();
    super.dispose();
  }

  void _onNewOrder(Map<String, dynamic> o) {
    if (!mounted) return;
    playChime();
    final who = (o['customer_name'] as String?)?.trim();
    final code = o['order_code'] as String?;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 8),
      backgroundColor: AppColors.navy,
      content: Row(children: [
        const Text('🛒', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'طلب جديد${code != null ? ' $code' : ''}${who != null && who.isNotEmpty ? ' من $who' : ''} — ${shopMoney((o['total_amount'] as num?) ?? 0)}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ]),
      action: SnackBarAction(label: 'افتح الطلب', textColor: AppColors.gold, onPressed: () => context.go('/orders/${o['id']}')),
    ));
  }

  int get _selected {
    final i = adminDestinations.indexWhere((d) => widget.location == d.path || widget.location.startsWith('${d.path}/'));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn && widget.session == null && !MerchantSession.isTestSession) return const MerchantLandingScreen();
    return MerchantScope(
      session: _session,
      child: ListenableBuilder(listenable: _session, builder: (context, _) => _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    final s = _session;
    if (s.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (s.loadError) {
      return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('لوحة التاجر')), body: LoadErrorView(onRetry: s.load));
    }
    if (s.shops.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('سجّل محلك'), actions: const [TajerAccountMenu()]),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: RegisterShopForm(onCreated: s.load)),
        ),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AdminBreakpoints.sidebar) return _sidebarLayout(context);
    if (width >= AdminBreakpoints.rail) return _railLayout(context);
    return _mobileLayout(context);
  }

  Widget _badge(Widget icon, String path) {
    final n = _session.newOrders;
    if (path != '/orders' || n == 0) return icon;
    return Badge(label: Text('$n'), backgroundColor: AppColors.gold, textColor: AppColors.night, child: icon);
  }

  PreferredSizeWidget _appBar() => AppBar(
        title: const ShopSwitcher(compact: true),
        actions: const [TajerAccountMenu()],
      );

  Widget _mobileLayout(BuildContext context) {
    final current = adminDestinations[_selected].path;
    // «الأقسام» lives under the products tab on phones.
    final idx = _mobilePaths.indexOf(current == '/collections' ? '/products' : current);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _appBar(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx < 0 ? 0 : idx,
        onDestinationSelected: (i) => context.go(_mobilePaths[i]),
        destinations: [
          for (final p in _mobilePaths)
            () {
              final d = adminDestinations.firstWhere((d) => d.path == p);
              return NavigationDestination(icon: _badge(Icon(d.icon), p), selectedIcon: _badge(Icon(d.selectedIcon), p), label: d.label);
            }(),
        ],
      ),
    );
  }

  Widget _railLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _appBar(),
      body: Row(children: [
        NavigationRail(
          selectedIndex: _selected,
          labelType: NavigationRailLabelType.all,
          backgroundColor: AppColors.surface,
          onDestinationSelected: (i) => context.go(adminDestinations[i].path),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: IconButton(tooltip: 'شوف متجرك', onPressed: () => _openStore(_session.shop), icon: const Icon(Icons.open_in_new_rounded)),
          ),
          destinations: [
            for (final d in adminDestinations)
              NavigationRailDestination(icon: _badge(Icon(d.icon), d.path), selectedIcon: _badge(Icon(d.selectedIcon), d.path), label: Text(d.label)),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: widget.child),
      ]),
    );
  }

  Widget _sidebarLayout(BuildContext context) {
    final sel = _selected;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(children: [
        Container(
          width: 252,
          decoration: const BoxDecoration(color: AppColors.surface, border: BorderDirectional(end: BorderSide(color: AppColors.border))),
          child: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Padding(padding: EdgeInsets.fromLTRB(12, 14, 12, 10), child: ShopSwitcher()),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(padding: const EdgeInsets.symmetric(horizontal: 10), children: [
                  for (final (i, d) in adminDestinations.indexed)
                    _SideItem(
                      label: d.label,
                      icon: i == sel ? d.selectedIcon : d.icon,
                      selected: i == sel,
                      soon: d.soon,
                      badge: d.path == '/orders' ? _session.newOrders : 0,
                      onTap: () => context.go(d.path),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _SideItem(label: 'شوف متجرك', icon: Icons.open_in_new_rounded, onTap: () => _openStore(_session.shop)),
              ),
              const Divider(height: 16),
              const TajerAccountMenu(tile: true),
              const SizedBox(height: 6),
            ]),
          ),
        ),
        Expanded(child: widget.child),
      ]),
    );
  }

  void _openStore(Map<String, dynamic>? shop) {
    final slug = shop?['slug'] as String?;
    if (slug == null || slug.isEmpty) {
      context.go('/settings');
      return;
    }
    launchUrl(Uri.parse(StoreService.storeUrl(slug)), mode: LaunchMode.externalApplication);
  }
}

class _SideItem extends StatelessWidget {
  const _SideItem({required this.label, required this.icon, required this.onTap, this.selected = false, this.soon = false, this.badge = 0});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;
  final bool soon;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? AppColors.tealLight.withValues(alpha: 0.7) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(children: [
              Icon(icon, size: 20, color: selected ? AppColors.crystal : AppColors.inkSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600, fontSize: 14, color: soon ? AppColors.inkMuted : AppColors.ink)),
              ),
              if (badge > 0) Pill('$badge', AppColors.gold, AppColors.night),
              if (soon) const Pill('قريباً', AppColors.surfaceAlt, AppColors.inkMuted),
            ]),
          ),
        ),
      ),
    );
  }
}

/// The shop shown (logo + name); with more than one shop, a menu to switch.
class ShopSwitcher extends StatelessWidget {
  const ShopSwitcher({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = MerchantScope.of(context);
    final shop = s.shop;
    if (shop == null) return const Text('لوحة التاجر');
    final logo = shop['logo_url'] as String?;
    final name = shop['name'] as String? ?? 'لوحة التاجر';
    final row = Row(mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max, children: [
      Container(
        width: compact ? 30 : 38,
        height: compact ? 30 : 38,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(10),
          image: logo != null ? DecorationImage(image: NetworkImage(logo), fit: BoxFit.cover) : null,
        ),
        child: logo == null ? const Icon(Icons.storefront_rounded, size: 18, color: AppColors.crystal) : null,
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w800, fontSize: compact ? 16 : 14)),
          if (!compact && shop['category'] != null)
            Text(shop['category'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
        ]),
      ),
      if (s.shops.length > 1) const Icon(Icons.expand_more_rounded, size: 20),
    ]);
    if (s.shops.length < 2) return row;
    return PopupMenuButton<int>(
      tooltip: 'غيّر المحل',
      initialValue: s.selected,
      onSelected: (i) {
        s.select(i);
        context.go('/dashboard');
      },
      itemBuilder: (_) => [for (final (i, sh) in s.shops.indexed) PopupMenuItem(value: i, child: Text(sh['name'] as String? ?? ''))],
      child: row,
    );
  }
}
