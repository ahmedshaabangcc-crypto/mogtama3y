import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/admin/admin_console_service.dart';
import '../../../core/geo/arab_countries.dart';
import '../../../core/geo/money.dart';
import '../../../core/theme/app_colors.dart';
import 'console_widgets.dart';

/// The console's first page: KPI cards for users, stores, the community,
/// revenue and the admin's queues, plus 30-day charts — refreshed every
/// [refreshEvery] while it is open.
class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key, required this.onOpen, this.refreshEvery = const Duration(seconds: 15)});

  /// Opens another console page by its id (users, payments, shops, approvals…).
  final void Function(String page) onOpen;
  final Duration refreshEvery;

  @override
  State<AdminOverviewPage> createState() => _AdminOverviewPageState();
}

class _AdminOverviewPageState extends State<AdminOverviewPage> {
  Map<String, dynamic>? _o;
  List<Map<String, dynamic>> _series = const [];
  String? _error;
  DateTime? _at;
  Timer? _timer;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(widget.refreshEvery, (_) => _load(quiet: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool quiet = false}) async {
    if (_busy) return;
    _busy = true;
    try {
      final o = await AdminConsoleService.overview();
      final s = await AdminConsoleService.series(days: 30);
      if (!mounted) return;
      setState(() {
        _o = o;
        _series = s;
        _error = null;
        _at = DateTime.now();
      });
    } catch (e) {
      if (mounted && (!quiet || _o == null)) {
        setState(() => _error = isAdminDenied(e) ? 'الصفحة دي للسوبر أدمن بس' : 'تعذر تحميل الأرقام — اتأكد من النت');
      }
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = _o;
    if (o == null) {
      return Center(
        child: _error == null
            ? const CircularProgressIndicator()
            : Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_error!, style: const TextStyle(color: AppColors.inkSecondary)),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _load, child: const Text('جرّب تاني')),
              ]),
      );
    }
    final u = Map<String, dynamic>.from(o['users'] as Map? ?? const {});
    final s = Map<String, dynamic>.from(o['shops'] as Map? ?? const {});
    final c = Map<String, dynamic>.from(o['community'] as Map? ?? const {});
    final t = Map<String, dynamic>.from(o['tokens'] as Map? ?? const {});
    final q = Map<String, dynamic>.from(o['queues'] as Map? ?? const {});
    num n(Map m, String k) => (m[k] as num?) ?? 0;
    final pending = ['token_topups', 'wallet_topups', 'withdrawals', 'fund_withdrawals', 'shop_claims', 'disputes'].fold<num>(0, (a, k) => a + n(q, k));
    final sales = [for (final x in s['sales_month'] as List? ?? const []) Map<String, dynamic>.from(x as Map)];
    final days = [for (final r in _series) DateTime.parse(r['day'] as String)];

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
        Row(children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(
            child: Text('مباشر — آخر تحديث ${_at == null ? '' : DateFormat('h:mm:ss a', 'ar').format(_at!)}',
                key: const ValueKey('console-live'), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          ),
          IconButton(tooltip: 'تحديث', onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ]),
        const ConsoleSection('المشتركين'),
        KpiGrid(children: [
          KpiCard(icon: Icons.people_alt_rounded, value: fmtCount(n(u, 'total')), label: 'إجمالي المشتركين', hint: '+${fmtCount(n(u, 'today'))} النهارده', onTap: () => widget.onOpen('users')),
          KpiCard(icon: Icons.bolt_rounded, value: fmtCount(n(u, 'active_24h')), label: 'دخلوا آخر 24 ساعة', color: AppColors.success),
          KpiCard(icon: Icons.trending_up_rounded, value: fmtCount(n(u, 'week')), label: 'جداد آخر 7 أيام', hint: '${fmtCount(n(u, 'month'))} في 30 يوم', color: AppColors.categoryRealEstate),
          KpiCard(icon: Icons.verified_user_rounded, value: fmtCount(n(u, 'verified_phone')), label: 'موبايلهم متأكد', color: AppColors.categoryShops),
        ]),
        const ConsoleSection('المتاجر والطلبات'),
        KpiGrid(children: [
          KpiCard(icon: Icons.storefront_rounded, value: fmtCount(n(s, 'total')), label: 'المتاجر', hint: '${fmtCount(n(s, 'with_products'))} فيها منتجات', color: AppColors.categoryShops, onTap: () => widget.onOpen('shops')),
          KpiCard(icon: Icons.receipt_long_rounded, value: fmtCount(n(s, 'orders_today')), label: 'طلبات النهارده', hint: '${fmtCount(n(s, 'orders_month'))} في 30 يوم', color: AppColors.categoryUsedMarket),
          KpiCard(
            icon: Icons.payments_rounded,
            value: sales.isEmpty ? money(0, 'EGP') : money((sales.first['total'] as num?) ?? 0, sales.first['currency'] as String?),
            label: 'مبيعات المتاجر — 30 يوم',
            hint: sales.length > 1 ? '+ ${sales.length - 1} عملة تانية' : null,
            color: AppColors.success,
          ),
          KpiCard(icon: Icons.credit_card_rounded, value: fmtCount(n(s, 'online_payments')), label: 'متاجر بدفع أونلاين', color: AppColors.crystalLight),
        ]),
        const ConsoleSection('الإيراد — توكن الإعلانات'),
        KpiGrid(children: [
          KpiCard(icon: Icons.today_rounded, value: money(n(t, 'revenue_today'), 'EGP'), label: 'إيراد النهارده', color: AppColors.success, onTap: () => widget.onOpen('payments')),
          KpiCard(icon: Icons.calendar_month_rounded, value: money(n(t, 'revenue_month'), 'EGP'), label: 'إيراد الشهر', hint: 'منه ${money(n(t, 'online_month'), 'EGP')} أونلاين', color: AppColors.success, onTap: () => widget.onOpen('payments')),
          KpiCard(icon: Icons.hourglass_top_rounded, value: fmtCount(n(t, 'awaiting_online')), label: 'دفع أونلاين مستني التأكيد', color: AppColors.gold, onTap: () => widget.onOpen('payments')),
          KpiCard(icon: Icons.toll_rounded, value: fmtCount(n(t, 'balance_total')), label: 'توكن في أرصدة الناس', hint: t['online_enabled'] == true ? 'الشحن الأونلاين شغال' : 'الشحن الأونلاين مقفول', color: AppColors.crystal),
        ]),
        const ConsoleSection('المجتمع'),
        KpiGrid(children: [
          KpiCard(icon: Icons.apartment_rounded, value: fmtCount(n(c, 'buildings')), label: 'عمارات', color: AppColors.crystal),
          KpiCard(icon: Icons.groups_rounded, value: fmtCount(n(c, 'members')), label: 'سكان موثّقين', hint: '${fmtCount(n(c, 'presidents'))} رئيس اتحاد', color: AppColors.crystalLight),
          KpiCard(icon: Icons.campaign_rounded, value: fmtCount(n(c, 'reports_month')), label: 'بلاغات آخر 30 يوم', color: AppColors.categorySos, onTap: () => widget.onOpen('reports')),
          KpiCard(icon: Icons.lock_outline_rounded, value: money(n(c, 'held_escrow'), 'EGP'), label: 'فلوس ضمان محجوزة', color: AppColors.gold),
        ]),
        const ConsoleSection('مستني قرارك'),
        KpiGrid(children: [
          KpiCard(icon: Icons.fact_check_rounded, value: fmtCount(pending), label: 'طلبات وموافقات', hint: 'شحن وسحب وتملّك ونزاعات', color: pending > 0 ? AppColors.categorySos : AppColors.inkMuted, onTap: () => widget.onOpen('approvals')),
          KpiCard(icon: Icons.campaign_outlined, value: fmtCount(n(q, 'reports_new')), label: 'بلاغات جديدة', color: n(q, 'reports_new') > 0 ? AppColors.categorySos : AppColors.inkMuted, onTap: () => widget.onOpen('reports')),
          KpiCard(icon: Icons.wrong_location_rounded, value: fmtCount(n(q, 'place_reports')), label: 'بلاغات أماكن الدليل', color: n(q, 'place_reports') > 0 ? AppColors.gold : AppColors.inkMuted, onTap: () => widget.onOpen('place_reports')),
          KpiCard(icon: Icons.support_agent_rounded, value: fmtCount(n(q, 'tickets')), label: 'تذاكر دعم مفتوحة', color: n(q, 'tickets') > 0 ? AppColors.gold : AppColors.inkMuted, onTap: () => widget.onOpen('approvals')),
        ]),
        if (_series.isNotEmpty) ...[
          const ConsoleSection('آخر 30 يوم'),
          LayoutBuilder(builder: (context, box) {
            final charts = [
              ConsolePanel(title: 'مشتركين جداد', child: DailyBars(days: days, values: [for (final r in _series) (r['signups'] as num?) ?? 0])),
              ConsolePanel(title: 'طلبات المتاجر', child: DailyBars(days: days, values: [for (final r in _series) (r['orders'] as num?) ?? 0], color: AppColors.categoryUsedMarket)),
              ConsolePanel(
                title: 'إيراد التوكن',
                child: DailyBars(days: days, values: [for (final r in _series) (r['tokens'] as num?) ?? 0], color: AppColors.success, format: (v) => money(v, 'EGP')),
              ),
            ];
            if (box.maxWidth < 900) {
              return Column(children: [for (final ch in charts) Padding(padding: const EdgeInsets.only(bottom: 12), child: ch)]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var i = 0; i < charts.length; i++) ...[if (i > 0) const SizedBox(width: 12), Expanded(child: charts[i])],
            ]);
          }),
        ],
        const ConsoleSection('المشتركين حسب الدولة'),
        ConsolePanel(
          title: 'أكتر الدول',
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            for (final x in u['by_country'] as List? ?? const [])
              Chip(
                avatar: Text(arabCountry((x as Map)['country'] as String?)?.flag ?? '🏳️'),
                label: Text('${arabCountry(x['country'] as String?)?.nameAr ?? x['country']} — ${fmtCount(x['n'] as num?)}'),
              ),
          ]),
        ),
      ]),
    );
  }
}
