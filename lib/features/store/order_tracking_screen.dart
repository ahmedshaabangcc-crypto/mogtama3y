import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/checkout_service.dart';
import '../../core/shops/online_payment.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import '../../core/geo/phones.dart';
import 'package:mogtama3y/core/geo/money.dart';
import 'online_payment_screen.dart';

/// `mogtama3y.com/#/o/<code>` — anyone with the order code follows it.
class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key, required this.code});
  final String code;

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  static const _steps = [
    ('placed', 'استلمنا طلبك', Icons.receipt_long_rounded),
    ('preparing', 'المحل بيجهّزه', Icons.inventory_2_rounded),
    ('delivering', 'في الطريق ليك', Icons.local_shipping_rounded),
    ('delivered', 'اتسلّم', Icons.check_circle_rounded),
  ];

  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      var o = await StoreService.trackOrder(widget.code);
      // Back from Fawaterak's page (0100): ask it about the invoice now
      // rather than wait for the webhook.
      if (o != null && o['payment_method'] == 'online' && o['payment_status'] != 'paid') {
        final phone = await OnlinePayment.phoneFor(widget.code);
        if (phone != null && await OnlinePayment.refresh(widget.code, phone) == 'paid') {
          o = await StoreService.trackOrder(widget.code);
        }
      }
      if (mounted) setState(() => _order = o);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// «إلغاء الطلب» (0099): while the order is «placed», with the last 4
  /// digits of the order's phone.
  Future<void> _cancel() async {
    final done = await showDialog<Map<String, dynamic>>(context: context, builder: (_) => _GuestCancelDialog(code: widget.code));
    if (done == null || !mounted) return;
    setState(() => _order = done);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتلغى طلبك، والمحل وصله إشعار')));
  }

  /// «ادفع دلوقتي»: the mobile this browser placed the order with, or ask.
  Future<void> _payNow() async {
    var phone = await OnlinePayment.phoneFor(widget.code);
    if (phone == null && mounted) {
      final c = TextEditingController();
      phone = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          title: const Text('ادفع أونلاين'),
          content: TextField(
            controller: c,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(labelText: 'رقم الموبايل اللي طلبت بيه'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d), child: const Text('رجوع')),
            FilledButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: const Text('كمّل')),
          ],
        ),
      );
    }
    if (phone == null || phone.isEmpty || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => OnlinePaymentScreen(code: widget.code, phone: phone!)));
    if (mounted) _load();
  }

  Widget _paymentTile(Map<String, dynamic> o) {
    final (icon, color, text) = switch (o['payment_status']) {
      'paid' => (Icons.verified_rounded, AppColors.success, 'اتدفع أونلاين ✓'),
      'failed' => (Icons.error_outline_rounded, Colors.redAccent, 'الدفع مانجحش — تقدر تحاول تاني'),
      _ => (Icons.hourglass_top_rounded, AppColors.gold, 'مستني الدفع أونلاين'),
    };
    return ListTile(
      key: const ValueKey('track-payment'),
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
      trailing: o['can_pay'] == true ? FilledButton(onPressed: _payNow, child: const Text('ادفع دلوقتي')) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = _order;
    return Scaffold(
      appBar: AppBar(title: const Text('متابعة الطلب')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : o == null
                  ? const Center(child: Text('مفيش طلب بالرقم ده', style: TextStyle(color: AppColors.inkMuted)))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(padding: const EdgeInsets.all(16), children: [
                        Text('طلب ${o['code']} من ${o['shop_name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        if (o['status'] == 'cancelled')
                          ListTile(
                            leading: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
                            title: const Text('الطلب ده اتلغى'),
                            subtitle: (o['cancel_reason'] as String?)?.isNotEmpty ?? false ? Text(o['cancel_reason'] as String) : null,
                          )
                        else
                          for (var i = 0; i < _steps.length; i++)
                            _Step(
                              icon: _steps[i].$3,
                              label: _steps[i].$2,
                              done: _steps.indexWhere((s) => s.$1 == o['status']) >= i,
                              last: i == _steps.length - 1,
                            ),
                        const SizedBox(height: 16),
                        for (final it in List<Map<String, dynamic>>.from(o['items'] as List? ?? const []))
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text('${it['name']} × ${it['quantity']}'),
                            subtitle: (it['options'] as String?)?.isNotEmpty ?? false ? Text(it['options'] as String) : null,
                            trailing: Text(moneyOf(o, ((it['price'] as num?) ?? 0) * ((it['quantity'] as num?) ?? 1))),
                          ),
                        if (((o['discount_amount'] as num?) ?? 0) > 0)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text('الخصم${o['discount_code'] != null ? ' (${o['discount_code']})' : ''}'),
                            trailing: Text('−${moneyOf(o, o['discount_amount'] as num)}', style: const TextStyle(color: AppColors.success)),
                          ),
                        if (o['fulfillment'] == 'pickup')
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.storefront_rounded),
                            title: const Text('استلام من المحل'),
                            subtitle: o['pickup_address'] != null ? Text(o['pickup_address'] as String) : null,
                          )
                        else if (((o['delivery_fee'] as num?) ?? 0) > 0)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text('التوصيل${o['shipping_zone'] != null ? ' (${o['shipping_zone']})' : ''}'),
                            trailing: Text(moneyOf(o, o['delivery_fee'] as num)),
                          ),
                        const Divider(),
                        Row(children: [
                          const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Text(moneyOf(o, (o['total'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.crystal)),
                        ]),
                        if (o['payment_method'] == 'online' && o['status'] != 'cancelled') _paymentTile(o),
                        if (o['shop_whatsapp'] != null) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => launchUrl(waLink(o['shop_whatsapp'] as String?, text: 'بخصوص طلب رقم ${o['code']}'),
                                mode: LaunchMode.externalApplication),
                            icon: const Icon(Icons.chat_rounded),
                            label: const Text('كلّم المحل على واتساب'),
                          ),
                        ],
                        if (o['can_cancel'] == true) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            key: const ValueKey('guest-cancel'),
                            onPressed: _cancel,
                            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('إلغاء الطلب'),
                          ),
                          const Text('تقدر تلغي طلبك لحد ما المحل يبدأ يجهّزه.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                        ],
                      ]),
                    ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.label, required this.done, required this.last});
  final IconData icon;
  final String label;
  final bool done;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.success : AppColors.border;
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Column(children: [
          CircleAvatar(radius: 16, backgroundColor: color, child: Icon(icon, size: 18, color: done ? Colors.white : AppColors.inkMuted)),
          if (!last) Expanded(child: Container(width: 3, color: color)),
        ]),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 22),
          child: Text(label, style: TextStyle(fontWeight: done ? FontWeight.w800 : FontWeight.w400, color: done ? AppColors.ink : AppColors.inkMuted)),
        ),
      ]),
    );
  }
}

class _GuestCancelDialog extends StatefulWidget {
  const _GuestCancelDialog({required this.code});
  final String code;

  @override
  State<_GuestCancelDialog> createState() => _GuestCancelDialogState();
}

class _GuestCancelDialogState extends State<_GuestCancelDialog> {
  final _last4 = TextEditingController();
  final _reason = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _last4.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final o = await CheckoutService.guestCancel(code: widget.code, last4: _last4.text.trim(), reason: _reason.text.trim());
      if (mounted) Navigator.of(context).pop(o);
    } on CheckoutProblem catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) setState(() => _error = e is PostgrestException ? e.message : 'تعذر إلغاء الطلب، حاول تاني');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إلغاء الطلب'),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('للتأكد إنك صاحب الطلب، اكتب آخر 4 أرقام من الموبايل اللي طلبت بيه.', style: TextStyle(fontSize: 13, color: AppColors.inkSecondary)),
        const SizedBox(height: 10),
        TextField(
          controller: _last4,
          keyboardType: TextInputType.number,
          maxLength: 4,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(labelText: 'آخر 4 أرقام', counterText: ''),
        ),
        const SizedBox(height: 8),
        TextField(controller: _reason, decoration: const InputDecoration(labelText: 'السبب (اختياري)', hintText: 'غيّرت رأيي، طلبت غلط…')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
      ]),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('رجوع')),
        FilledButton(
          onPressed: _busy ? null : _go,
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('إلغاء الطلب'),
        ),
      ],
    );
  }
}
