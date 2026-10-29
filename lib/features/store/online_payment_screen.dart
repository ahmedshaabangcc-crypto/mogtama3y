import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/online_payment.dart';
import '../../core/theme/app_colors.dart';
import 'order_tracking_screen.dart';
import 'package:mogtama3y/core/geo/money.dart';

/// «ادفع أونلاين» (0100): Fawaterak's methods for an order placed in the
/// store — cards / wallets go to Fawaterak's page and come back to the
/// tracking page; Fawry / Aman give a code to pay with.
class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({super.key, required this.code, required this.phone});
  final String code;
  final String phone;

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  Map<String, dynamic>? _order;
  List<Map<String, dynamic>> _methods = const [];
  bool _loading = true;
  String? _error;
  int? _busyId;
  Map<String, String>? _codes;
  String? _expire;

  @override
  void initState() {
    super.initState();
    OnlinePayment.rememberPhone(widget.code, widget.phone);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await OnlinePayment.methods(widget.code, widget.phone);
      if (!mounted) return;
      if (r['paid'] == true) return _openTracking();
      setState(() {
        _order = Map<String, dynamic>.from(r['order'] as Map? ?? const {});
        _methods = [for (final m in r['methods'] as List? ?? const []) Map<String, dynamic>.from(m as Map)];
      });
    } on PaymentProblem catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pay(Map<String, dynamic> m) async {
    final id = (m['id'] as num).toInt();
    setState(() {
      _busyId = id;
      _error = null;
    });
    try {
      final r = await OnlinePayment.pay(widget.code, widget.phone, id);
      final url = r['redirect_to'] as String?;
      if (url != null) {
        // Same tab on the web: Fawaterak sends the customer back to /#/o/<code>.
        await launchUrl(Uri.parse(url), webOnlyWindowName: '_self', mode: LaunchMode.platformDefault);
        return;
      }
      final codes = Map<String, String>.from((r['codes'] as Map?)?.map((k, v) => MapEntry('$k', '$v')) ?? const {});
      if (!mounted) return;
      if (codes.isEmpty) {
        setState(() => _error = 'فواتيرك ماردّتش بلينك ولا كود — جرّب طريقة تانية');
      } else {
        setState(() {
          _codes = codes;
          _expire = r['expire_date'] as String?;
        });
      }
    } on PaymentProblem catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  void _openTracking() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderTrackingScreen(code: widget.code)));
  }

  @override
  Widget build(BuildContext context) {
    final o = _order;
    return Scaffold(
      appBar: AppBar(title: const Text('ادفع أونلاين')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(padding: const EdgeInsets.all(20), children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      Text('طلب ${widget.code}${o?['shop_name'] != null ? ' — ${o!['shop_name']}' : ''}',
                          textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                      if (o?['total'] != null)
                        Text(money(o!['total'] as num, o['currency'] as String?),
                            key: const ValueKey('pay-total'), style: const TextStyle(color: AppColors.gold, fontSize: 28, fontWeight: FontWeight.w800)),
                      const Text('الفلوس بتروح للمحل على طول عن طريق فواتيرك', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  if (_codes != null) ..._codeView() else ..._methodsView(),
                  if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _openTracking,
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('تابع طلبك'),
                  ),
                ]),
        ),
      ),
    );
  }

  List<Widget> _methodsView() => [
        if (_methods.isNotEmpty) const Text('اختار هتدفع إزاي', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        if (_methods.isEmpty && _error != null)
          TextButton.icon(onPressed: _load, icon: const Icon(Icons.refresh_rounded), label: const Text('جرّب تاني')),
        const SizedBox(height: 8),
        for (final m in _methods)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              key: ValueKey('pay-method-${m['id']}'),
              enabled: _busyId == null,
              onTap: () => _pay(m),
              leading: m['logo'] != null
                  ? Image.network(m['logo'] as String, width: 44, height: 32, fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(Icons.payment_rounded))
                  : const Icon(Icons.payment_rounded),
              title: Text('${m['name_ar'] ?? m['name_en'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: m['redirect'] == true ? null : const Text('هتاخد كود تدفع بيه', style: TextStyle(fontSize: 12)),
              trailing: _busyId == m['id']
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.chevron_left_rounded),
            ),
          ),
      ];

  List<Widget> _codeView() => [
        const Text('ادفع بالكود ده', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 6),
        const Text('روح أي منفذ أو استخدم التطبيق، وقول إنك عايز تدفع بالكود. أول ما تدفع الطلب بيتعلّم «اتدفع» لوحده.',
            style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
        const SizedBox(height: 10),
        for (final e in _codes!.entries)
          Card(
            child: ListTile(
              title: Text(paymentCodeLabels[e.key] ?? e.key),
              subtitle: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(e.value, key: const ValueKey('pay-code'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: e.value));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتنسخ الكود')));
                },
              ),
            ),
          ),
        if (_expire != null) Text('صالح لحد $_expire', style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        TextButton(onPressed: () => setState(() => _codes = null), child: const Text('اختار طريقة تانية')),
      ];
}
