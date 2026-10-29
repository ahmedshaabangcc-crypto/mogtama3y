import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:url_launcher/url_launcher.dart';

import '../../core/geo/money.dart';
import '../../core/geo/phones.dart';
import '../../core/shops/print_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/shops/checkout_service.dart';
import '../../core/shops/store_service.dart';
import '../e_address/e_address_widgets.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'order_print.dart';

/// Asks why an order is cancelled (null: the merchant backed out).
Future<String?> askCancelReason(BuildContext context) => showDialog<String>(context: context, builder: (_) => const _CancelDialog());

class _CancelDialog extends StatefulWidget {
  const _CancelDialog();

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  static const presets = ['الزبون طلب الإلغاء', 'الزبون مبيردش', 'منتج خلص من عندنا', 'العنوان بعيد عن منطقة التوصيل', 'طلب مكرر'];
  final c = TextEditingController();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: SizedBox(
          width: 420,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('اختار سبب الإلغاء (بيتسجل في سجل الطلب):', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final p in presets)
                ChoiceChip(label: Text(p), selected: c.text == p, onSelected: (_) => setState(() => c.text = p)),
            ]),
            const SizedBox(height: 10),
            TextField(controller: c, maxLength: 300, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'أو اكتب السبب')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('رجوع')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.categorySos, foregroundColor: Colors.white),
            onPressed: c.text.trim().isEmpty ? null : () => Navigator.of(ctx).pop(c.text.trim()),
            child: const Text('إلغاء الطلب'),
          ),
        ],
      );
  }
}

/// Moves an order on (cancel asks for a reason). True when it changed.
Future<bool> changeOrderStatus(BuildContext context, String orderId, String status) async {
  final messenger = ScaffoldMessenger.of(context);
  final session = MerchantScope.read(context);
  try {
    if (status == 'cancelled') {
      final reason = await askCancelReason(context);
      if (reason == null) return false;
      await StoreService.cancelOrder(orderId, reason);
    } else {
      await StoreService.updateOrderStatus(orderId: orderId, status: status);
    }
    session.ordersChanged();
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر تحديث الطلب'))));
    return false;
  }
}

/// Opens the browser print dialog for [orders] (invoice or packing slip).
void printOrders(BuildContext context, Map<String, dynamic> shop, List<Map<String, dynamic>> orders, {bool packingSlip = false}) {
  final ok = printHtml(ordersPrintHtml(shop: shop, orders: orders, packingSlip: packingSlip), packingSlip ? 'قائمة تجهيز' : 'فاتورة');
  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الطباعة بتشتغل من المتصفح (tajer.mogtama3y.com)')));
  }
}

/// The status action buttons of an order.
class OrderActions extends StatelessWidget {
  const OrderActions({super.key, required this.orderId, required this.status, this.onChanged});
  final String orderId;
  final String status;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final actions = nextOrderActions(status);
    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 6, children: [
      for (final (next, label) in actions)
        next == 'cancelled'
            ? TextButton(
                onPressed: () async {
                  if (await changeOrderStatus(context, orderId, next)) onChanged?.call();
                },
                child: Text(label, style: const TextStyle(color: AppColors.categorySos)),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (await changeOrderStatus(context, orderId, next)) onChanged?.call();
                },
                child: Text(label),
              ),
    ]);
  }
}

/// `/orders/:id` on a phone / tablet: the order alone with a back arrow.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/orders');
      },
      child: AdminPage(
        title: 'تفاصيل الطلب',
        backTo: '/orders',
        maxWidth: 1100,
        body: OrderDetailView(key: ValueKey(orderId), orderId: orderId),
      ),
    );
  }
}

/// One order: lines (snapshots), totals, customer, address, actions,
/// internal note, timeline, print. [embedded]: the right pane of the
/// wide-screen orders page (with a close button).
class OrderDetailView extends StatefulWidget {
  const OrderDetailView({super.key, required this.orderId, this.embedded = false});
  final String orderId;
  final bool embedded;

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  Map<String, dynamic>? _order;
  bool _error = false;
  final _note = TextEditingController();
  bool _savingNote = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final o = await StoreService.merchantOrder(widget.orderId);
      if (!mounted) return;
      setState(() {
        _order = o;
        _note.text = o['internal_note'] as String? ?? '';
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  /// «اتأكد» (0099): the customer confirmed the cash order.
  Future<void> _confirm() async {
    final session = MerchantScope.read(context);
    try {
      await CheckoutService.confirmOrder(widget.orderId);
      session.ordersChanged();
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر التأكيد'))));
    }
  }

  Future<void> _saveNote() async {
    setState(() => _savingNote = true);
    final session = MerchantScope.read(context);
    try {
      await StoreService.setOrderNote(widget.orderId, _note.text);
      session.ordersChanged();
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظت الملاحظة')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر حفظ الملاحظة'))));
    } finally {
      if (mounted) setState(() => _savingNote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return LoadErrorView(onRetry: _load);
    final o = _order;
    if (o == null) return const Center(child: CircularProgressIndicator());
    final shop = MerchantScope.of(context).shop!;
    final cur = (o['currency'] as String?) ?? currencyOf(shop);
    String m(num v) => money(v, cur);
    final status = o['status'] as String? ?? 'placed';
    final created = DateTime.tryParse(o['created_at'] as String? ?? '')?.toLocal();

    final header = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('طلب ${o['order_code'] ?? ''}', textDirection: TextDirection.rtl, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        OrderStatusPill(status),
        CashPill(long: true, order: o),
        if (o['fulfillment'] == 'pickup') const Pill('استلام من المحل', AppColors.surfaceAlt, AppColors.inkSecondary, icon: Icons.storefront_rounded),
        if (o['confirmation_status'] == 'confirmed')
          Pill('اتأكد', AppColors.success.withValues(alpha: 0.15), const Color(0xFF047857), icon: Icons.verified_rounded)
        else if (o['confirmation_status'] == 'pending' && status == 'placed')
          Pill('مستني تأكيد', AppColors.gold.withValues(alpha: 0.22), const Color(0xFF8A5A12), icon: Icons.hourglass_top_rounded),
        if (created != null) Text(DateFormat('d/M/yyyy – h:mm a').format(created), style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
      ],
    );
    final tools = Wrap(spacing: 6, runSpacing: 6, children: [
      OutlinedButton.icon(onPressed: () => printOrders(context, shop, [o]), icon: const Icon(Icons.receipt_rounded, size: 18), label: const Text('فاتورة')),
      OutlinedButton.icon(
        onPressed: () => printOrders(context, shop, [o], packingSlip: true),
        icon: const Icon(Icons.inventory_rounded, size: 18),
        label: const Text('قائمة تجهيز'),
      ),
      if (widget.embedded) IconButton(tooltip: 'قفل', onPressed: () => context.go('/orders'), icon: const Icon(Icons.close_rounded)),
    ]);

    final items = List<Map<String, dynamic>>.from((o['items'] as List? ?? const []).map((i) => Map<String, dynamic>.from(i as Map)));
    final delivery = (o['delivery_fee'] as num?) ?? 0;
    final total = (o['total_amount'] as num?) ?? 0;
    final discount = (o['discount_amount'] as num?) ?? 0;
    final subtotal = (o['subtotal'] as num?) ?? total - delivery + discount;
    final zone = o['shipping_zone'] as String?;
    final itemsCard = AdminCard(
      title: 'المنتجات (${items.fold<num>(0, (a, i) => a + ((i['quantity'] as num?) ?? 0))} قطعة)',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final i in items) _line(i, m),
        const Divider(height: 20),
        _total('المنتجات', m(subtotal)),
        if (discount > 0)
          _total('الخصم${o['discount_code'] != null ? ' (${o['discount_code']})' : o['discount_title'] != null ? ' (${o['discount_title']})' : ''}', '−${m(discount)}'),
        _total(o['fulfillment'] == 'pickup' ? 'استلام من المحل' : 'التوصيل${zone != null ? ' — $zone' : ''}', delivery == 0 ? 'مجاني' : m(delivery)),
        _total('الإجمالي', m(total), bold: true),
        const SizedBox(height: 4),
        const Text('الدفع كاش عند الاستلام', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      ]),
    );

    final phone = o['customer_phone'] as String?;
    final customerCard = AdminCard(
      title: 'الزبون',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(o['customer_name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
        if (phone != null) ...[
          const SizedBox(height: 4),
          Text(displayPhone(phone), textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6, children: [
            OutlinedButton.icon(onPressed: () => launchUrl(telLink(phone)), icon: const Icon(Icons.call_rounded, size: 16), label: const Text('اتصال')),
            OutlinedButton.icon(
              onPressed: () => launchUrl(waLink(phone, text: 'أهلاً ${o['customer_name'] ?? ''}، بخصوص طلبك ${o['order_code'] ?? ''} من ${shop['name']}'),
                  mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.chat_rounded, size: 16),
              label: const Text('واتساب'),
            ),
          ]),
        ],
      ]),
    );
    final note = (o['note'] as String?)?.trim();
    final addressCard = AdminCard(
      title: 'عنوان التوصيل',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SelectableText(o['delivery_address'] as String? ?? '—', style: const TextStyle(height: 1.6, fontSize: 13)),
        if (note != null && note.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.13), borderRadius: BorderRadius.circular(10)),
            child: Text('ملاحظة الزبون: $note', style: const TextStyle(fontSize: 12.5, height: 1.5)),
          ),
        ],
        const SizedBox(height: 10),
        const EAddressLookupBox(title: 'عنوان زبون للتوصيل'),
      ]),
    );
    final noteCard = AdminCard(
      title: 'ملاحظة داخلية',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('ليك إنت بس — الزبون مش بيشوفها.', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        TextField(controller: _note, minLines: 2, maxLines: 5, maxLength: 1000, decoration: const InputDecoration(hintText: 'مثلاً: الزبون عايزه قبل الضهر')),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: ElevatedButton(
            onPressed: _savingNote ? null : _saveNote,
            child: _savingNote ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ الملاحظة'),
          ),
        ),
      ]),
    );
    final pendingConfirm = o['confirmation_status'] == 'pending' && status == 'placed';
    final actions = nextOrderActions(status).isEmpty
        ? null
        : AdminCard(
            title: 'حرّك الطلب',
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (pendingConfirm) ...[
                Row(children: [
                  const Expanded(
                    child: Text('الزبون أكّد الطلب على واتساب أو في التليفون؟', style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary)),
                  ),
                  FilledButton.icon(
                    key: const ValueKey('confirm-order'),
                    onPressed: _confirm,
                    style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                    icon: const Icon(Icons.verified_rounded, size: 18),
                    label: const Text('اتأكد'),
                  ),
                ]),
                const SizedBox(height: 10),
              ],
              OrderActions(orderId: widget.orderId, status: status, onChanged: _load),
            ]),
          );
    final cancelled = status == 'cancelled' && (o['cancel_reason'] as String?) != null
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Text('اتلغى: ${o['cancel_reason']}', style: const TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w700)),
          )
        : null;
    final timeline = AdminCard(title: 'سجل الطلب', child: OrderTimeline(events: List<Map<String, dynamic>>.from((o['events'] as List? ?? const []).map((e) => Map<String, dynamic>.from(e as Map)))));

    return LayoutBuilder(builder: (context, c) {
      final two = c.maxWidth >= 760;
      const gap = SizedBox(height: 12);
      final mainCol = [itemsCard, gap, ?actions, if (actions != null) gap, ?cancelled, if (cancelled != null) gap, timeline];
      final sideCol = [customerCard, gap, addressCard, gap, noteCard];
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: EdgeInsets.only(top: widget.embedded ? 12 : 4, bottom: 32), children: [
          Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 10, children: [header, tools]),
          const SizedBox(height: 14),
          if (two)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: mainCol)),
              const SizedBox(width: 14),
              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: sideCol)),
            ])
          else ...[
            ?actions,
            if (actions != null) gap,
            itemsCard,
            gap,
            ...sideCol,
            gap,
            ?cancelled,
            if (cancelled != null) gap,
            timeline,
          ],
        ]),
      );
    });
  }

  Widget _line(Map<String, dynamic> i, String Function(num) m) {
    final qty = (i['quantity'] as num?) ?? 0;
    final price = (i['unit_price'] as num?) ?? 0;
    final img = i['image_url'] as String?;
    final variant = (i['variant_label'] as String?)?.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 48,
            height: 48,
            child: img == null
                ? const ColoredBox(color: AppColors.surfaceAlt, child: Icon(Icons.image_outlined, color: AppColors.inkMuted))
                : Image.network(img, cacheWidth: 120, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(i['product_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
            if (variant != null && variant.isNotEmpty) Text(variant, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            Text('${m(price)} × $qty', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          ]),
        ),
        Text(m(price * qty), style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _total(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, fontSize: bold ? 15 : 13))),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: bold ? 16 : 13, color: bold ? AppColors.teal : AppColors.ink)),
        ]),
      );
}

/// The order's history (shop_order_events, 0096), newest first.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.events});
  final List<Map<String, dynamic>> events;

  static String describe(Map<String, dynamic> e) {
    final who = switch (e['actor_role']) {
      'merchant' => (e['actor_name'] as String?)?.isNotEmpty == true ? 'المحل (${e['actor_name']})' : 'المحل',
      'customer' => 'الزبون',
      _ => 'النظام',
    };
    final to = orderStatusLabels[e['to_status']] ?? e['to_status'];
    return switch (e['kind']) {
      'created' => 'الزبون عمل الطلب',
      'status' => 'الحالة بقت «$to» — $who',
      'cancel' => 'اتلغى الطلب — $who${(e['body'] as String?)?.isNotEmpty == true ? '\nالسبب: ${e['body']}' : ''}',
      'note' => 'ملاحظة داخلية — $who\n${e['body'] ?? ''}',
      'confirm' => 'الطلب اتأكد مع الزبون — $who',
      'discount' => 'خصم: ${e['body'] ?? ''}',
      _ => '${e['kind']}',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const Text('مفيش أحداث لسه', style: TextStyle(color: AppColors.inkMuted));
    final list = events.reversed.toList();
    return Column(children: [
      for (final (i, e) in list.indexed)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              width: 28,
              child: Column(children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: switch (e['kind']) { 'cancel' => AppColors.categorySos, 'note' || 'discount' => AppColors.gold, 'created' || 'confirm' => AppColors.success, _ => AppColors.crystal },
                  child: Icon(
                    switch (e['kind']) {
                      'cancel' => Icons.close_rounded,
                      'note' => Icons.sticky_note_2_rounded,
                      'created' => Icons.shopping_bag_rounded,
                      'confirm' => Icons.verified_rounded,
                      'discount' => Icons.local_offer_rounded,
                      _ => Icons.sync_alt_rounded,
                    },
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                if (i < list.length - 1) const Expanded(child: VerticalDivider(width: 2, thickness: 2, color: AppColors.surfaceAlt)),
              ]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(describe(e), style: const TextStyle(fontSize: 13, height: 1.5)),
                  if (DateTime.tryParse(e['created_at'] as String? ?? '') case final at?)
                    Text(DateFormat('d/M – h:mm a').format(at.toLocal()), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                ]),
              ),
            ),
          ]),
        ),
    ]);
  }
}
