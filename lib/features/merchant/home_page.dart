import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import '../shared/push_opt_in.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';

/// `/dashboard`: the onboarding checklist, today's numbers, best sellers
/// and quick actions.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = MerchantScope.of(context).shop!;
    return _HomeView(key: ValueKey('h${shop['id']}'), shop: shop);
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({super.key, required this.shop});
  final Map<String, dynamic> shop;

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>>? _products;

  /// «منتجات قربت تخلص» (0098): {threshold, items}; null until loaded or
  /// on a backend without it.
  Map<String, dynamic>? _lowStock;
  bool _error = false;
  bool _sharedNow = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final id = widget.shop['id'] as String;
      final r = await Future.wait([StoreService.shopStats(id), StoreService.fetchProducts(id, includeHidden: true)]);
      if (!mounted) return;
      setState(() {
        _stats = r[0] as Map<String, dynamic>;
        _products = r[1] as List<Map<String, dynamic>>;
      });
      _loadLowStock();
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  Future<void> _loadLowStock() async {
    try {
      final l = await StoreService.lowStock(widget.shop['id'] as String);
      if (mounted) setState(() => _lowStock = l);
    } catch (_) {
      // Optional card.
    }
  }

  Future<void> _editThreshold() async {
    final v = await askAdminText(context,
        title: 'امتى أعرف إن المنتج قرب يخلص؟',
        initial: '${_lowStock?['threshold'] ?? 3}',
        label: 'لما الكمية توصل لـ',
        helper: '0 = متبعتليش تنبيهات',
        number: true,
        okLabel: 'حفظ');
    final n = int.tryParse(latinDigits(v ?? ''));
    if (n == null) return;
    try {
      await StoreService.setLowStockThreshold(widget.shop['id'] as String, n);
      _loadLowStock();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر الحفظ'))));
    }
  }

  Widget? _lowStockCard() {
    final l = _lowStock;
    if (l == null) return null;
    final items = List<Map<String, dynamic>>.from(l['items'] as List? ?? const []);
    if (items.isEmpty) return null;
    return AdminCard(
      key: const ValueKey('low-stock'),
      title: 'منتجات قربت تخلص (${items.length})',
      trailing: TextButton.icon(
        onPressed: _editThreshold,
        icon: const Icon(Icons.tune_rounded, size: 16),
        label: Text('الحد: ${l['threshold']}'),
      ),
      child: Column(children: [
        for (final i in items.take(6))
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () => context.go('/products/${i['product_id']}'),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: i['image_url'] is String
                  ? Image.network(i['image_url'] as String, width: 36, height: 36, cacheWidth: 100, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox(width: 36, height: 36))
                  : Container(width: 36, height: 36, color: AppColors.surfaceAlt, child: const Icon(Icons.inventory_2_outlined, size: 18)),
            ),
            title: Text(i['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: i['variant_label'] == null ? null : Text(i['variant_label'] as String, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Pill((i['stock'] as num? ?? 0) <= 0 ? 'خلص' : 'باقي ${i['stock']}',
                (i['stock'] as num? ?? 0) <= 0 ? AppColors.categorySos.withValues(alpha: 0.12) : AppColors.gold.withValues(alpha: 0.22),
                (i['stock'] as num? ?? 0) <= 0 ? const Color(0xFFB91C1C) : const Color(0xFF8A5A12)),
          ),
        if (items.length > 6)
          Align(alignment: AlignmentDirectional.centerStart, child: TextButton(onPressed: () => context.go('/products'), child: Text('و${items.length - 6} تانيين'))),
      ]),
    );
  }

  Widget _stat(String label, String value, IconData icon, {VoidCallback? onTap, bool highlight = false}) => Expanded(
        child: Material(
          color: highlight ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(icon, color: highlight ? AppColors.night : AppColors.crystal),
                const SizedBox(height: 8),
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: highlight ? AppColors.night : AppColors.ink)),
                Text(label, style: TextStyle(fontSize: 12, color: highlight ? AppColors.night : AppColors.inkMuted)),
              ]),
            ),
          ),
        ),
      );

  void _shareStore(String slug) {
    StoreService.markShared(widget.shop['id'] as String);
    setState(() => _sharedNow = true);
    final text = 'اتفرّج على منتجات ${widget.shop['name']} واطلب أونلاين والدفع عند الاستلام:\n${StoreService.storeUrl(slug)}';
    launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final session = MerchantScope.of(context);
    Widget body;
    final s = _stats;
    if (_error) {
      body = LoadErrorView(onRetry: _load);
    } else if (s == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = _content(context, session, s);
    }
    return AdminPage(title: 'الرئيسية', subtitle: widget.shop['name'] as String?, maxWidth: 1100, body: body);
  }

  Widget _content(BuildContext context, MerchantSession session, Map<String, dynamic> s) {
    final slug = widget.shop['slug'] as String?;
    final newOrders = (s['new_orders'] as num?)?.toInt() ?? 0;
    final top = List<Map<String, dynamic>>.from(s['top_products'] as List? ?? const []);
    final wide = MediaQuery.sizeOf(context).width >= AdminBreakpoints.sidebar;

    final sales = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('مبيعات النهارده', style: TextStyle(color: Colors.white70)),
        Text(shopMoney((s['sales_today'] as num?) ?? 0), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${s['orders_today']} طلب النهارده • ${shopMoney((s['sales_30d'] as num?) ?? 0)} آخر 30 يوم', style: const TextStyle(color: AppColors.gold, fontSize: 12.5)),
      ]),
    );
    final stats = Column(children: [
      Row(children: [
        _stat('طلبات جديدة', '$newOrders', Icons.notifications_active_rounded, highlight: newOrders > 0, onTap: () => context.go('/orders')),
        const SizedBox(width: 10),
        _stat('زيارات المتجر', '${s['visits']}', Icons.visibility_rounded),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        _stat('طلبات آخر 30 يوم', '${s['orders_30d']}', Icons.receipt_long_rounded, onTap: () => context.go('/orders')),
        const SizedBox(width: 10),
        _stat('المنتجات', '${s['products']}', Icons.inventory_2_rounded, onTap: () => context.go('/products')),
      ]),
    ]);
    final actions = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('بيع أكتر', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: ElevatedButton.icon(onPressed: () => context.go('/products/new'), icon: const Icon(Icons.add_rounded), label: const Text('أضف منتج'))),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: slug == null ? () => context.go('/settings') : () => _shareStore(slug),
            icon: const Icon(Icons.share_rounded),
            label: const Text('شارك متجرك'),
          ),
        ),
      ]),
    ]);
    final best = top.isEmpty
        ? null
        : AdminCard(
            title: 'الأكثر مبيعاً (30 يوم)',
            child: Column(children: [
              for (final (i, t) in top.indexed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: CircleAvatar(backgroundColor: AppColors.surfaceAlt, child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800))),
                  title: Text(t['name'] as String? ?? ''),
                  trailing: Text('${t['sold']} قطعة', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.crystal)),
                ),
            ]),
          );
    final low = _lowStockCard();
    final checklist = OnboardingChecklist(
      shop: widget.shop,
      products: _products ?? const [],
      orders: (s['orders_all'] as num?)?.toInt() ?? session.allOrders,
      sharedNow: _sharedNow,
      onShare: slug == null ? null : () => _shareStore(slug),
    );

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.only(top: 4, bottom: 32), children: [
        const PushOptInCard(),
        checklist,
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [sales, const SizedBox(height: 12), stats])),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                actions,
                if (low != null) ...[const SizedBox(height: 16), low],
                if (best != null) ...[const SizedBox(height: 16), best],
              ]),
            ),
          ])
        else ...[
          sales,
          const SizedBox(height: 12),
          stats,
          const SizedBox(height: 16),
          actions,
          if (low != null) ...[const SizedBox(height: 18), low],
          if (best != null) ...[const SizedBox(height: 18), best],
        ],
      ]),
    );
  }
}

/// «ابدأ صح»: the first steps of a new shop, each with a link. Hidden once
/// everything is done.
class OnboardingChecklist extends StatelessWidget {
  const OnboardingChecklist({super.key, required this.shop, required this.products, required this.orders, this.sharedNow = false, this.onShare});
  final Map<String, dynamic> shop;
  final List<Map<String, dynamic>> products;
  final int orders;
  final bool sharedNow;
  final VoidCallback? onShare;

  static List<(bool, String, String, String?)> stepsFor(Map<String, dynamic> shop, List<Map<String, dynamic>> products, int orders, {bool sharedNow = false}) {
    final priced = products.where((p) => productStatusOf(p) == 'active' && ((p['price'] as num?) ?? 0) > 0).length;
    final fee = (shop['delivery_fee'] as num?) ?? 0;
    return [
      ((shop['logo_url'] as String?)?.isNotEmpty ?? false, 'حط لوجو لمتجرك', 'الزبون بيثق في المتجر اللي له شكل', '/settings'),
      (priced >= 5, 'ضيف 5 منتجات بأسعارها${priced < 5 ? ' ($priced من 5)' : ''}', 'كل ما المنتجات تكتر، الطلبات بتزيد', '/products'),
      (fee > 0 || shop['free_delivery_over'] != null, 'حدد قيمة التوصيل', 'عشان الزبون يعرف الإجمالي قبل ما يطلب', '/settings'),
      (sharedNow || shop['first_shared_at'] != null || ((shop['scan_count'] as num?) ?? 0) > 0, 'شارك رابط متجرك أو علّق الـ QR', 'على واتساب وفيسبوك وواجهة المحل', null),
      (orders > 0, 'استقبل أول طلب', 'هيوصلك تنبيه أول ما زبون يطلب', '/orders'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = stepsFor(shop, products, orders, sharedNow: sharedNow);
    final done = steps.where((s) => s.$1).length;
    if (done == steps.length) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AdminCard(
        title: 'ابدأ صح — $done من ${steps.length}',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: done / steps.length, minHeight: 6, color: AppColors.success, backgroundColor: AppColors.surfaceAlt),
          ),
          const SizedBox(height: 6),
          for (final (ok, title, hint, link) in steps)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: ok ? AppColors.success : AppColors.inkMuted),
              title: Text(title,
                  style: TextStyle(fontWeight: FontWeight.w700, decoration: ok ? TextDecoration.lineThrough : null, color: ok ? AppColors.inkMuted : AppColors.ink)),
              subtitle: ok ? null : Text(hint, style: const TextStyle(fontSize: 11.5)),
              trailing: ok ? null : const Icon(Icons.chevron_left_rounded),
              onTap: ok ? null : (link != null ? () => context.go(link) : onShare ?? () => context.go('/settings')),
            ),
        ]),
      ),
    );
  }
}
