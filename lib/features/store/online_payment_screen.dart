import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/online_payment.dart';
import '../../core/theme/app_colors.dart';
import 'order_tracking_screen.dart';

/// «ادفع أونلاين» (0100 / 0101): opens Fawaterak's hosted checkout for an
/// order placed in the store — the customer picks a card, a wallet, Fawry…
/// there and comes back to the tracking page (/#/o/<code>).
class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({super.key, required this.code, required this.phone});
  final String code;
  final String phone;

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  bool _busy = true;
  String? _error;
  String? _url;

  @override
  void initState() {
    super.initState();
    OnlinePayment.rememberPhone(widget.code, widget.phone);
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final r = await OnlinePayment.pay(widget.code, widget.phone);
      if (!mounted) return;
      if (r['paid'] == true) return _openTracking();
      final url = r['redirect_to'] as String?;
      if (url == null) {
        setState(() => _error = 'فواتيرك ماردّتش بلينك الدفع — جرّب تاني');
        return;
      }
      setState(() => _url = url);
      await _go();
    } on PaymentProblem catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Same tab on the web: Fawaterak sends the customer back to /#/o/<code>.
  Future<void> _go() async {
    final url = _url;
    if (url == null) return;
    final ok = await launchUrl(Uri.parse(url), webOnlyWindowName: '_self', mode: LaunchMode.platformDefault);
    if (!ok && mounted) setState(() => _error = 'مقدرناش نفتح صفحة الدفع — دوس «افتح صفحة الدفع»');
  }

  void _openTracking() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderTrackingScreen(code: widget.code)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ادفع أونلاين')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(padding: const EdgeInsets.all(24), children: [
            const Icon(Icons.lock_rounded, size: 56, color: AppColors.crystal),
            const SizedBox(height: 12),
            Text('طلب ${widget.code}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text(
              'هتدفع في صفحة فواتيرك الآمنة — كارت، محفظة موبايل، أو كود فوري / أمان. الفلوس بتروح للمحل على طول، وبعد الدفع هترجع لصفحة متابعة طلبك.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkSecondary, height: 1.6),
            ),
            const SizedBox(height: 20),
            if (_busy)
              const Center(child: CircularProgressIndicator())
            else if (_url != null)
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  key: const ValueKey('pay-open'),
                  onPressed: _go,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('افتح صفحة الدفع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              )
            else
              OutlinedButton.icon(onPressed: _start, icon: const Icon(Icons.refresh_rounded), label: const Text('جرّب تاني')),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, key: const ValueKey('pay-error'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: _openTracking, icon: const Icon(Icons.local_shipping_outlined), label: const Text('تابع طلبك')),
          ]),
        ),
      ),
    );
  }
}
