import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:url_launcher/url_launcher.dart';

import '../../core/geo/phones.dart';
import '../../core/shops/print_card.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'order_detail.dart';
import 'order_print.dart';

/// `/orders` and `/orders/:id`: the server-side paginated orders list
/// (0096 merchant_orders) with status chips + counts, search (code / name
/// / phone), a date range and CSV export — a table on wide screens, cards
/// on phones. With an order open it is master–detail from
/// [AdminBreakpoints.sidebar]; below that the order shows alone.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, this.selectedId});
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final shop = MerchantScope.of(context).shop!;
    final wide = MediaQuery.sizeOf(context).width >= AdminBreakpoints.sidebar;
    if (selectedId != null && !wide) return OrderDetailScreen(orderId: selectedId!);
    return OrdersView(key: ValueKey('o${shop['id']}'), shop: shop, selectedId: selectedId);
  }
}

class OrdersView extends StatefulWidget {
  const OrdersView({super.key, required this.shop, this.selectedId});
  final Map<String, dynamic> shop;
  final String? selectedId;

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  static const _pageSize = 50;

  bool _loading = true;
  bool _loadError = false;
  bool _loadingMore = false;
  bool _exporting = false;
  List<Map<String, dynamic>> _orders = [];
  Map<String, int> _counts = const {};
  bool _hasMore = false;
  String? _status;
  DateTimeRange? _range;
  final _search = TextEditingController();
  Timer? _debounce;
  final _picked = <String>{};
  int _generation = 0;
  ValueNotifier<int>? _version;

  String get _shopId => widget.shop['id'] as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final v = MerchantScope.read(context).ordersVersion;
    if (!identical(v, _version)) {
      _version?.removeListener(_reloadQuietly);
      _version = v..addListener(_reloadQuietly);
    }
  }

  @override
  void dispose() {
    _version?.removeListener(_reloadQuietly);
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _reloadQuietly() => _load(quiet: true);

  DateTime? get _to => _range == null ? null : DateTime(_range!.end.year, _range!.end.month, _range!.end.day + 1);

  Future<MerchantOrdersPage> _fetch({Map<String, dynamic>? after, int limit = _pageSize}) => StoreService.merchantOrders(
        shopId: _shopId,
        status: _status,
        search: latinDigits(_search.text),
        from: _range?.start,
        to: _to,
        limit: limit,
        after: after,
      );

  Future<void> _load({bool quiet = false}) async {
    final gen = ++_generation;
    if (!quiet) {
      setState(() {
        _loading = true;
        _loadError = false;
      });
    }
    try {
      // A quiet reload keeps what was already scrolled into view.
      final page = await _fetch(limit: quiet ? _orders.length.clamp(_pageSize, 200) : _pageSize);
      if (!mounted || gen != _generation) return;
      setState(() {
        _orders = page.orders;
        _counts = page.counts;
        _hasMore = page.hasMore;
        _loading = false;
        _picked.retainWhere((id) => page.orders.any((o) => o['id'] == id));
      });
    } catch (_) {
      if (!mounted || gen != _generation) return;
      setState(() {
        _loading = false;
        _loadError = !quiet || _orders.isEmpty;
      });
    }
  }

  Future<void> _more() async {
    if (_loadingMore || !_hasMore || _orders.isEmpty) return;
    final gen = _generation;
    setState(() => _loadingMore = true);
    try {
      final page = await _fetch(after: _orders.last);
      if (!mounted || gen != _generation) return;
      setState(() {
        _orders = [..._orders, ...page.orders];
        _hasMore = page.hasMore;
      });
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تحميل باقي الطلبات')));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(now.year, now.month, now.day),
      initialDateRange: _range,
      helpText: 'اختار المدة',
      saveText: 'تم',
    );
    if (r == null) return;
    setState(() => _range = r);
    _load();
  }

  /// Every order of the current filter (pages of 200), as CSV.
  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    try {
      final all = <Map<String, dynamic>>[];
      Map<String, dynamic>? after;
      while (all.length < 5000) {
        final page = await _fetch(after: after, limit: 200);
        all.addAll(page.orders);
        if (!page.hasMore || page.orders.isEmpty) break;
        after = page.orders.last;
      }
      if (!mounted) return;
      final name = 'orders-${widget.shop['slug'] ?? 'shop'}-${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv';
      final ok = downloadText(ordersCsv(all, currency: StoreService.merchantCurrency), name, mime: 'text/csv;charset=utf-8');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'اتحمّل ملف ${all.length} طلب' : 'التصدير بيشتغل من المتصفح')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر التصدير'))));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _open(Map<String, dynamic> o) => context.go('/orders/${o['id']}');

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AdminBreakpoints.sidebar;
    final master = widget.selectedId != null && wide;
    final rangeLabel = _range == null ? 'كل الأيام' : '${DateFormat('d/M').format(_range!.start)} – ${DateFormat('d/M').format(_range!.end)}';
    final list = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SizedBox(
        height: 46,
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
          for (final (key, label) in orderStatusFilters)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text('$label (${_counts[key ?? 'all'] ?? 0})'),
                labelStyle: chipLabelStyle(_status == key),
                checkmarkColor: Colors.white,
                selected: _status == key,
                onSelected: (_) {
                  setState(() => _status = key);
                  _load();
                },
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: InputChip(
              avatar: const Icon(Icons.date_range_rounded, size: 18),
              label: Text(rangeLabel),
              selected: _range != null,
              onPressed: _pickRange,
              onDeleted: _range == null
                  ? null
                  : () {
                      setState(() => _range = null);
                      _load();
                    },
            ),
          ),
        ])),
      ),
      if (_picked.isNotEmpty && !master) _bulkBar(),
      Expanded(child: _listBody(compact: master)),
    ]);
    return AdminPage(
      title: 'الطلبات',
      subtitle: _loading ? null : '${_counts['all'] ?? 0} طلب',
      search: AdminSearchField(controller: _search, hint: 'دوّر بالكود أو الاسم أو الموبايل', onChanged: _onSearch),
      actions: [
        IconButton(tooltip: 'تحديث', onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        OutlinedButton.icon(
          onPressed: _exporting || (_counts['all'] ?? 0) == 0 ? null : _exportCsv,
          icon: _exporting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.download_rounded, size: 18),
          label: const Text('تصدير CSV'),
        ),
      ],
      body: master
          ? Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(width: 380, child: list),
              const VerticalDivider(width: 24),
              Expanded(child: OrderDetailView(key: ValueKey(widget.selectedId), orderId: widget.selectedId!, embedded: true)),
            ])
          : list,
    );
  }

  Widget _bulkBar() {
    final picked = _orders.where((o) => _picked.contains(o['id'])).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text('${picked.length} طلب متحدد', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const Spacer(),
        TextButton.icon(
          onPressed: () => printOrders(context, widget.shop, picked),
          icon: const Icon(Icons.receipt_rounded, size: 18, color: AppColors.gold),
          label: const Text('اطبع الفواتير', style: TextStyle(color: Colors.white)),
        ),
        TextButton.icon(
          onPressed: () => printOrders(context, widget.shop, picked, packingSlip: true),
          icon: const Icon(Icons.inventory_rounded, size: 18, color: AppColors.gold),
          label: const Text('قوائم التجهيز', style: TextStyle(color: Colors.white)),
        ),
        IconButton(tooltip: 'إلغاء التحديد', onPressed: () => setState(_picked.clear), icon: const Icon(Icons.close_rounded, color: Colors.white70)),
      ]),
    );
  }

  Widget _listBody({required bool compact}) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load);
    if (_orders.isEmpty) {
      final filtered = _status != null || _range != null || _search.text.trim().isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(filtered ? 'مفيش طلبات بالبحث ده' : 'لسه مفيش طلبات. شارك رابط متجرك ومنتجاتك على واتساب وفيسبوك.',
              textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, height: 1.6)),
        ),
      );
    }
    return LayoutBuilder(builder: (context, c) {
      final table = !compact && c.maxWidth >= 720;
      final more = _hasMore
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: _loadingMore
                    ? const CircularProgressIndicator()
                    : OutlinedButton.icon(onPressed: _more, icon: const Icon(Icons.expand_more_rounded), label: const Text('حمّل طلبات أقدم')),
              ),
            )
          : const SizedBox(height: 24);
      return RefreshIndicator(
        onRefresh: _load,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels > n.metrics.maxScrollExtent - 300) _more();
            return false;
          },
          child: table
              ? ListView(children: [OrdersTable(orders: _orders, picked: _picked, onOpen: _open, onPick: (id, v) => setState(() => v ? _picked.add(id) : _picked.remove(id)), onPickAll: (v) => setState(() => v ? _picked.addAll(_orders.map((o) => o['id'] as String)) : _picked.clear())), more])
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _orders.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => i == _orders.length
                      ? more
                      : compact
                          ? _CompactOrderTile(order: _orders[i], selected: _orders[i]['id'] == widget.selectedId, onTap: () => _open(_orders[i]))
                          : OrderCard(order: _orders[i], onOpen: () => _open(_orders[i]), onChanged: () => _load(quiet: true)),
                ),
        ),
      );
    });
  }
}

String _orderDate(Map<String, dynamic> o, {String pattern = 'd/M – h:mm a'}) {
  final d = DateTime.tryParse(o['created_at'] as String? ?? '')?.toLocal();
  return d == null ? '' : DateFormat(pattern).format(d);
}

/// The wide-screen orders table (Shopify-like): select, code, date,
/// customer, total, status, payment. A row opens the order.
class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key, required this.orders, required this.picked, required this.onOpen, required this.onPick, required this.onPickAll});
  final List<Map<String, dynamic>> orders;
  final Set<String> picked;
  final ValueChanged<Map<String, dynamic>> onOpen;
  final void Function(String id, bool picked) onPick;
  final ValueChanged<bool> onPickAll;

  static const _flex = [14, 16, 26, 14, 14, 10];

  @override
  Widget build(BuildContext context) {
    Widget cell(int i, Widget child) => Expanded(flex: _flex[i], child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: child));
    const head = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.inkSecondary);
    final all = orders.isNotEmpty && orders.every((o) => picked.contains(o['id']));
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(
          color: AppColors.surfaceAlt,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Checkbox(value: all ? true : (picked.isEmpty ? false : null), tristate: true, onChanged: (_) => onPickAll(!all)),
            cell(0, const Text('الكود', style: head)),
            cell(1, const Text('التاريخ', style: head)),
            cell(2, const Text('الزبون', style: head)),
            cell(3, const Text('الإجمالي', style: head)),
            cell(4, const Text('الحالة', style: head)),
            cell(5, const Text('الدفع', style: head)),
          ]),
        ),
        for (final o in orders)
          Material(
            color: o['status'] == 'placed' ? AppColors.gold.withValues(alpha: 0.07) : Colors.transparent,
            child: InkWell(
              key: ValueKey('row-${o['id']}'),
              onTap: () => onOpen(o),
              child: Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Checkbox(value: picked.contains(o['id']), onChanged: (v) => onPick(o['id'] as String, v ?? false)),
                  cell(0, Text(o['order_code'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
                  cell(1, Text(_orderDate(o), style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary))),
                  cell(
                    2,
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(o['customer_name'] as String? ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      if (o['customer_phone'] != null)
                        Text(displayPhone(o['customer_phone'] as String), textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                    ]),
                  ),
                  cell(3, Text(shopMoney((o['total_amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
                  cell(4, Align(alignment: AlignmentDirectional.centerStart, child: OrderStatusPill(o['status'] as String? ?? 'placed'))),
                  cell(5, const Align(alignment: AlignmentDirectional.centerStart, child: CashPill())),
                ]),
              ),
            ),
          ),
      ]),
    );
  }
}

/// A list row next to the open order (master–detail).
class _CompactOrderTile extends StatelessWidget {
  const _CompactOrderTile({required this.order, required this.selected, required this.onTap});
  final Map<String, dynamic> order;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final o = order;
    return Material(
      color: selected ? AppColors.tealLight.withValues(alpha: 0.6) : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${o['order_code'] ?? ''} • ${o['customer_name'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                Text(_orderDate(o), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(shopMoney((o['total_amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
              const SizedBox(height: 2),
              OrderStatusPill(o['status'] as String? ?? 'placed'),
            ]),
          ]),
        ),
      ),
    );
  }
}

/// The phone card of an order (as before), opening the detail on tap.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onOpen, this.onChanged});
  final Map<String, dynamic> order;
  final VoidCallback onOpen;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final o = order;
    final status = o['status'] as String? ?? 'placed';
    final items = List<Map<String, dynamic>>.from((o['items'] as List? ?? const []).map((i) => Map<String, dynamic>.from(i as Map)));
    final phone = o['customer_phone'] as String?;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: status == 'placed' ? AppColors.gold : AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              OrderStatusPill(status),
              const SizedBox(width: 6),
              const CashPill(),
              const Spacer(),
              Text(shopMoney((o['total_amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.teal)),
            ]),
            const SizedBox(height: 4),
            Text('${o['order_code'] != null ? 'طلب ${o['order_code']} • ' : ''}${_orderDate(o)}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            if (o['customer_name'] != null) ...[
              const SizedBox(height: 6),
              Text('👤 ${o['customer_name']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ],
            if (o['delivery_address'] != null)
              Text('📍 ${o['delivery_address']}', maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.5)),
            const SizedBox(height: 8),
            for (final it in items)
              Text(
                '• ${it['product_name'] ?? ''}${(it['variant_label'] as String?)?.isNotEmpty ?? false ? ' (${it['variant_label']})' : ''} × ${it['quantity']}',
                style: const TextStyle(fontSize: 12.5),
              ),
            if (((o['delivery_fee'] as num?) ?? 0) > 0)
              Text('🚚 التوصيل: ${shopMoney(o['delivery_fee'] as num)} (داخل الإجمالي)', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
            if (o['note'] != null) ...[
              const SizedBox(height: 6),
              Text('ملاحظات: ${o['note']}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
            ],
            if (phone != null) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 6, children: [
                OutlinedButton.icon(onPressed: () => launchUrl(telLink(phone)), icon: const Icon(Icons.call_rounded, size: 16), label: Text(displayPhone(phone), textDirection: TextDirection.ltr)),
                OutlinedButton.icon(
                  onPressed: () => launchUrl(waLink(phone), mode: LaunchMode.externalApplication),
                  icon: const Icon(Icons.chat_rounded, size: 16),
                  label: const Text('واتساب'),
                ),
              ]),
            ],
            if (nextOrderActions(status).isNotEmpty) ...[
              const SizedBox(height: 8),
              OrderActions(orderId: o['id'] as String, status: status, onChanged: onChanged),
            ],
          ]),
        ),
      ),
    );
  }
}
