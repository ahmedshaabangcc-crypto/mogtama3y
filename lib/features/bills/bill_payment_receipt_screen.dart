import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Payment success receipt, styled like a Fawry transaction receipt.
class BillPaymentReceiptScreen extends StatelessWidget {
  const BillPaymentReceiptScreen({super.key, required this.serviceName, required this.amount});
  final String serviceName, amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إيصال السداد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        children: [
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          const Text('تم السداد بنجاح', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 6),
          Text('فاتورة $serviceName • $amount ج.م', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
            child: Column(
              children: [
                const Icon(Icons.qr_code_2_rounded, size: 90, color: AppColors.ink),
                const SizedBox(height: 12),
                const _ReceiptRow(label: 'رقم العملية', value: 'FWY-2609841'),
                const Divider(height: 20, color: AppColors.border),
                _ReceiptRow(label: 'الخدمة', value: serviceName),
                const Divider(height: 20, color: AppColors.border),
                const _ReceiptRow(label: 'التاريخ والوقت', value: '11 سبتمبر 2026 - 09:42 ص'),
                const Divider(height: 20, color: AppColors.border),
                const _ReceiptRow(label: 'وسيلة الدفع', value: 'محفظة مُجتمعي الرقمية'),
                const Divider(height: 20, color: AppColors.border),
                _ReceiptRow(label: 'المبلغ الإجمالي', value: '$amount ج.م', emphasize: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.verified_rounded, size: 16, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(child: Text('عملية موثقة ومعتمدة عبر شبكة فوري الرسمية لتحصيل المدفوعات الحكومية والخدمية.', style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.6))),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.share_outlined, size: 16),
              label: const Text('مشاركة الإيصال', style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 13, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value, this.emphasize = false});
  final String label, value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: emphasize ? 16 : 12.5, fontWeight: FontWeight.w800, color: emphasize ? AppColors.teal : AppColors.ink)),
    ]);
  }
}
