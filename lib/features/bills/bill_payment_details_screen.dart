import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Look up and pay a specific bill (meter/subscriber number) — was
/// reachable straight from the bills hub and let anyone type ANY number
/// (the field wasn't even real — it was a static, hardcoded "123456789012"
/// Text, not a TextField), then showed a fully fabricated bill (a fake
/// subscriber name, a fake amount, a fake wallet balance) and, on
/// "confirm," a fake success receipt with a fake Fawry transaction
/// number — a completely simulated financial transaction with no real
/// lookup, no real wallet deduction, and no real Fawry call anywhere.
/// There is no real bill-payment backend yet (Ahmed plans to contract
/// directly with Fawry for that) — this now honestly says so instead of
/// pretending the payment happened.
class BillPaymentDetailsScreen extends StatefulWidget {
  const BillPaymentDetailsScreen({super.key, required this.serviceName, required this.serviceIcon, required this.serviceColor, required this.numberLabel});
  final String serviceName, numberLabel;
  final IconData serviceIcon;
  final Color serviceColor;

  @override
  State<BillPaymentDetailsScreen> createState() => _BillPaymentDetailsScreenState();
}

class _BillPaymentDetailsScreenState extends State<BillPaymentDetailsScreen> {
  final _numberCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    super.dispose();
  }

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
                    const Text('الخدمة دي هتتفعل بعد ربط التطبيق رسمياً بفوري', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Text(widget.numberLabel, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: TextField(
              controller: _numberCtrl,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 13)),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 18, color: AppColors.inkSecondary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'سداد الفواتير لسه مش متاح في التطبيق — لسه بنجهّز التكامل الرسمي مع فوري. هنبلّغك أول ما الخدمة تتفعّل.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock_clock_rounded, size: 17),
              label: const Text('السداد قريباً', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
