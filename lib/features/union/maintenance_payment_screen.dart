import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _lineItems = [
  (icon: Icons.bolt_rounded, title: 'كهرباء السلم والمصعد والإنارة المشتركة', note: 'فاتورة العداد الموحد وعقد الصيانة الدورية', amount: '150.00'),
  (icon: Icons.shield_outlined, title: 'أمن وحراسة ونظافة المداخل', note: 'أجر الحراسة ومستلزمات التعقيم اليومي', amount: '100.00'),
  (icon: Icons.savings_outlined, title: 'صندوق الطوارئ والاحتياطي المالي للعمارة', note: 'مخصص لأعطال المضخات وصيانة السطح', amount: '100.00'),
];

/// Monthly maintenance-dues payment — matches
/// design/screens/11_maintenance_payment.png.
class MaintenancePaymentScreen extends StatefulWidget {
  const MaintenancePaymentScreen({super.key});

  @override
  State<MaintenancePaymentScreen> createState() => _MaintenancePaymentScreenState();
}

class _MaintenancePaymentScreenState extends State<MaintenancePaymentScreen> {
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سداد رسوم صيانة العمارة والمخالصة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Expanded(child: Text('برج الياسمين - المعادي (شقة 4B)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                    child: const Text('مستحق الآن - تفادي الغرامات', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text('اشتراك صيانة شهر مارس 2025', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                    child: const Text('فاتورة دورية معتمدة', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  const Text('تاريخ الاستحقاق: 10 مارس', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ]),
                const Divider(height: 26, color: AppColors.border),
                Row(children: const [
                  Text('المبلغ الإجمالي المستحق', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                  Spacer(),
                  Text('350.00 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.teal)),
                ]),
                const SizedBox(height: 14),
                Row(children: const [
                  Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                  SizedBox(width: 5),
                  Text('نسبة تحصيل البرج لشهر مارس: 77%', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.77, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
                const SizedBox(height: 4),
                const Text('تم سداد 17 من أصل 22 وحدة حق الآن', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('تفاصيل بنود الصيانة والمصروفات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            TextButton(onPressed: () {}, child: const Text('تقرير التدقيق المالي', style: TextStyle(fontSize: 11))),
          ]),
          const SizedBox(height: 8),
          for (final item in _lineItems) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, size: 17, color: AppColors.inkSecondary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                      Text(item.note, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                Text('${item.amount} ج.م', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ]),
            ),
          ],
          const SizedBox(height: 16),
          const Text('اختر وسيلة الدفع المناسبة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          _PaymentTile(
            icon: Icons.account_balance_wallet_rounded,
            title: 'محفظة مُجتمعي الرقمية',
            subtitle: 'الرصيد المتاح: 850.00 ج.م',
            badge: 'سداد فوري بنقرة واحدة',
            selected: _method == 0,
            onTap: () => setState(() => _method = 0),
          ),
          const SizedBox(height: 8),
          _PaymentTile(
            icon: Icons.credit_card_rounded,
            title: 'بطاقة بنكية / فيزا وميزة وماستركارد',
            subtitle: 'دفع آمن ومشفر عبر بوابة البنك المركزي',
            selected: _method == 1,
            onTap: () => setState(() => _method = 1),
          ),
          const SizedBox(height: 8),
          _PaymentTile(
            icon: Icons.phone_android_rounded,
            title: 'فوري / المحافظ الإلكترونية',
            subtitle: 'فودافون كاش ومبيلاتيا / إنستاباي',
            selected: _method == 2,
            onTap: () => setState(() => _method = 2),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_user_rounded, size: 18, color: AppColors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ضمان براءة الذمة الرسمية الفورية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.teal)),
                      const SizedBox(height: 4),
                      const Text(
                        'إصدار براءة ذمة مالية إلكترونية مختومة ومعتمدة فور السداد للجمعية العمومية مع رمز QR موثق ومسجل في سجلات العقار الموحدة.',
                        style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.lock_outline_rounded, size: 17),
                  label: const Text('سداد 350.00 ج.م وتأكيد المخالصة الفورية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('اعتماد قانوني فوري وموثق للوحدة 4B', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap, this.badge});
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
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
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: Text(badge!, style: const TextStyle(fontSize: 8, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
        ]),
      ),
    );
  }
}
