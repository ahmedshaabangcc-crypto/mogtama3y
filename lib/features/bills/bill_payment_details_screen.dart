import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'bill_payment_receipt_screen.dart';

/// Look up and pay a specific bill (meter/subscriber number) — the
/// step after picking a service category from the Fawry-style hub.
class BillPaymentDetailsScreen extends StatefulWidget {
  const BillPaymentDetailsScreen({super.key, required this.serviceName, required this.serviceIcon, required this.serviceColor, required this.numberLabel});
  final String serviceName, numberLabel;
  final IconData serviceIcon;
  final Color serviceColor;

  @override
  State<BillPaymentDetailsScreen> createState() => _BillPaymentDetailsScreenState();
}

class _BillPaymentDetailsScreenState extends State<BillPaymentDetailsScreen> {
  bool _fetched = false;
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('سداد فاتورة ${widget.serviceName}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: widget.serviceColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(widget.serviceIcon, color: widget.serviceColor, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.serviceName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const Text('سداد فوري ومعتمد بالتعاون مع فوري', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Text(widget.numberLabel, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Expanded(child: Text('123456789012', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
              Icon(Icons.qr_code_scanner_rounded, size: 18, color: AppColors.inkMuted),
            ]),
          ),
          const SizedBox(height: 14),
          if (!_fetched)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _fetched = true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.search_rounded, size: 17),
                label: const Text('استعلام عن الفاتورة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          if (_fetched) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.receipt_long_rounded, color: AppColors.gold, size: 18),
                    const SizedBox(width: 8),
                    const Text('بيانات الفاتورة المستحقة', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                  const SizedBox(height: 10),
                  const Text('اسم المشترك: أحمد شكري محمود', style: TextStyle(color: Colors.white, fontSize: 12, height: 1.8)),
                  const Text('فترة الفاتورة: أغسطس 2026', style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.8)),
                  const Divider(height: 20, color: Colors.white24),
                  Row(children: const [
                    Text('المبلغ المطلوب سداده', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Spacer(),
                    Text('286.50 ج.م', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 10),
            _PayMethod(icon: Icons.account_balance_wallet_rounded, title: 'محفظة مُجتمعي الرقمية', subtitle: 'الرصيد المتاح: 2,450.00 ج.م', selected: _method == 0, onTap: () => setState(() => _method = 0)),
            const SizedBox(height: 8),
            _PayMethod(icon: Icons.credit_card_rounded, title: 'بطاقة بنكية (فيزا / ماستركارد)', subtitle: 'دفع مصري مباشر 3D Secure', selected: _method == 1, onTap: () => setState(() => _method = 1)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => BillPaymentReceiptScreen(serviceName: widget.serviceName, amount: '286.50'),
                )),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.lock_outline_rounded, size: 17),
                label: const Text('تأكيد السداد الآن', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PayMethod extends StatelessWidget {
  const _PayMethod({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1)),
        child: Row(children: [
          Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.inkSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                Text(subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
