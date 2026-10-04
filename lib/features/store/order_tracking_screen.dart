import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'store_cart.dart';

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
      final o = await StoreService.trackOrder(widget.code);
      if (mounted) setState(() => _order = o);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                          const ListTile(leading: Icon(Icons.cancel_rounded, color: Colors.redAccent), title: Text('الطلب ده اتلغى'))
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
                            trailing: Text(egp(((it['price'] as num?) ?? 0) * ((it['quantity'] as num?) ?? 1))),
                          ),
                        const Divider(),
                        Row(children: [
                          const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Text(egp((o['total'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.crystal)),
                        ]),
                        if (o['shop_whatsapp'] != null) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => launchUrl(Uri.parse('https://wa.me/2${o['shop_whatsapp']}?text=${Uri.encodeComponent('بخصوص طلب رقم ${o['code']}')}'),
                                mode: LaunchMode.externalApplication),
                            icon: const Icon(Icons.chat_rounded),
                            label: const Text('كلّم المحل على واتساب'),
                          ),
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
