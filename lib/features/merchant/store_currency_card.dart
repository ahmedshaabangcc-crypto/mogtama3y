import 'package:flutter/material.dart';

import '../../core/geo/money.dart';
import '../../core/shops/checkout_service.dart';
import '../../core/theme/app_colors.dart';
import 'admin/admin_common.dart';

/// «عملة المتجر» (0099 set_shop_currency): any Arab currency or USD / EUR
/// / GBP. Prices are not converted — the merchant is told so first.
class StoreCurrencyCard extends StatefulWidget {
  const StoreCurrencyCard({super.key, required this.shop, required this.onSaved});
  final Map<String, dynamic> shop;
  final VoidCallback onSaved;

  @override
  State<StoreCurrencyCard> createState() => _StoreCurrencyCardState();
}

class _StoreCurrencyCardState extends State<StoreCurrencyCard> {
  late String _cur = currencyOf(widget.shop);
  bool _busy = false;

  Future<void> _change(String? c) async {
    if (c == null || c == _cur) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تغيّر العملة لـ ${currencyNames[c] ?? c}؟'),
        content: const Text('الأسعار مش بتتحوّل لوحدها: الأرقام اللي كاتبها (المنتجات، التوصيل، الخصومات) هتفضل زي ما هي بالعملة الجديدة — راجعها بعد التغيير. الطلبات القديمة بتفضل بعملتها.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('لا')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('غيّر العملة')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await CheckoutService.setCurrency(widget.shop['id'] as String, c);
      if (!mounted) return;
      setState(() => _cur = c);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('عملة المتجر بقت ${currencyNames[c] ?? c} (${currencyLabel(c)})')));
      widget.onSaved();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر تغيير العملة'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = [...storeCurrencies, if (!storeCurrencies.contains(_cur)) _cur];
    return AdminCard(
      title: 'عملة المتجر',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('الأسعار والتوصيل والخصومات بتظهر للزبون بالعملة دي.', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: const ValueKey('store-currency'),
          initialValue: _cur,
          isExpanded: true,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.payments_outlined)),
          items: [for (final c in list) DropdownMenuItem(value: c, child: Text('${currencyNames[c] ?? c} — ${currencyLabel(c)} ($c)'))],
          onChanged: _busy ? null : _change,
        ),
      ]),
    );
  }
}
