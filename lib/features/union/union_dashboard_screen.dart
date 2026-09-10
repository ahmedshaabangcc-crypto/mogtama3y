import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../visitor/visitor_qr_pass_screen.dart';
import 'financial_report_screen.dart';
import 'maintenance_payment_screen.dart';

/// The owners'-union governance dashboard — matches
/// design/screens/00_union_dashboard_board.png.
class UnionDashboardScreen extends StatelessWidget {
  const UnionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('مجلس إدارة اتحاد الشاغلين')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.circle, size: 6, color: AppColors.teal),
                  SizedBox(width: 4),
                  Text('الجمعية العمومية نشطة', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: const Text('برج الياسمين الفاخر ✓', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.apartment_rounded, color: AppColors.inkMuted, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مجلس إدارة اتحاد الشاغلين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('كود: YSM-42', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                      SizedBox(height: 2),
                      Text('42 وحدة سكنية • المعادي - دجلة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.savings_outlined, color: AppColors.gold, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('صندوق الصيانة والاحتياطي المالي', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                ]),
                const SizedBox(height: 10),
                const Text('١٤٨,٢٥٠ ج.م', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const Text('نسبة تحصيل اشتراكات هذا الشهر', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.92, minHeight: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
                const SizedBox(height: 6),
                Row(children: [
                  const Text('92% مكتمل', style: TextStyle(color: AppColors.tealLight, fontSize: 11, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  const Icon(Icons.trending_up_rounded, size: 13, color: AppColors.tealLight),
                  const SizedBox(width: 3),
                  const Text('+15% عن دورة التحصيل السابقة', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialReportScreen())),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.arrow_back_rounded, size: 15),
                    label: const Text('التقرير المالي المفصل', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('إجراءات سريعة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          const _QuickActionsRow(),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Text('استفتاء الجمعية العمومية الرئيسي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Text('نشط الآن', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(children: [
            Icon(Icons.access_time_rounded, size: 12, color: AppColors.inkMuted),
            SizedBox(width: 4),
            Text('متبقي 3 أيام و 8 ساعات', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          const _ProposalCard(),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(child: Text('جدول الصيانات الدورية القادمة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              TextButton(onPressed: () {}, child: const Text('عرض الجدول السنوي', style: TextStyle(fontSize: 11.5))),
            ],
          ),
          const SizedBox(height: 8),
          const _MaintenanceItem(
            title: 'فحص واختبار أمان المصاعد',
            subtitle: 'شركة أوتيس للمصاعد • فحص كهروميكانيكي',
            when: 'غداً',
            day: 'الثلاثاء',
            urgent: true,
          ),
          const SizedBox(height: 10),
          const _MaintenanceItem(
            title: 'صيانة مضخات المياه والفلاتر المركزية',
            subtitle: 'شركة النيل الهندسية • استبدال مرشحات الشرب',
            when: 'بعد 3 أيام',
            day: 'الخميس',
            urgent: false,
          ),
          const SizedBox(height: 22),
          const _BoardMessage(),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  static const _actions = [
    (icon: Icons.poll_outlined, label: 'إضافة استطلاع'),
    (icon: Icons.picture_as_pdf_outlined, label: 'التقرير المالي PDF'),
    (icon: Icons.payments_outlined, label: 'سداد الصيانة'),
    (icon: Icons.qr_code_2_rounded, label: 'إصدار تصريح QR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: switch (i) {
                1 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialReportScreen())),
                2 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MaintenancePaymentScreen())),
                3 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VisitorQrPassScreen())),
                _ => null,
              },
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Icon(_actions[i].icon, size: 20, color: AppColors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(_actions[i].label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.videocam_rounded, color: AppColors.teal, size: 18),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('تركيب كاميرات مراقبة ذكية في الجراج ومداخل المبنى', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4)),
            ),
          ]),
          const SizedBox(height: 8),
          const Text(
            'تركيب شبكة متكاملة تضم 16 كاميرا مراقبة بدقة 4K مع خاصية الرؤية الليلية وتغطية مداخل المشاة ومداخل الجراج وغرفة الحراسة مع ربطها بتطبيق مجتمعي.',
            style: TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [
              Icon(Icons.account_balance_wallet_outlined, size: 13, color: AppColors.inkMuted),
              SizedBox(width: 6),
              Text('الميزانية المقترحة: 35,000 ج.م من بند الاحتياطي', style: TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Text('موافق  (85% • 30 شقة)', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              Spacer(),
              Text('غير موافق (15% • 5 شقة)', style: TextStyle(fontSize: 10.5, color: AppColors.categorySos, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: 85, child: Container(color: AppColors.teal)),
                  Expanded(flex: 15, child: Container(color: AppColors.categorySos)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.check_circle_rounded, size: 13, color: AppColors.teal),
            SizedBox(width: 4),
            Expanded(child: Text('النصاب القانوني: تم اكتمال النصاب (35 من 42 شقة مصوتة)', style: TextStyle(fontSize: 10, color: AppColors.inkMuted))),
          ]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.thumb_up_alt_outlined, size: 15),
                    label: const Text('موافق على القرار', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('غير موافق', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.forum_outlined, size: 15, color: AppColors.inkMuted),
              label: const Text('نقاش (18)', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  const _MaintenanceItem({required this.title, required this.subtitle, required this.when, required this.day, required this.urgent});
  final String title, subtitle, when, day;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.build_outlined, color: AppColors.inkSecondary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: urgent ? AppColors.gold.withValues(alpha: 0.15) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(when, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: urgent ? AppColors.gold : AppColors.inkMuted)),
              ),
              const SizedBox(height: 3),
              Text(day, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoardMessage extends StatelessWidget {
  const _BoardMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('أ. طارق المنشاوي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  Text('رئيس مجلس اتحاد ملاك برج الياسمين', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
            const Text('منذ 4 ساعات', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          const Text(
            'السادة الجيران الكرام، نرجو المشاركة في التصويت الجاري لتثبيت المراقبة الذكية لتعزيز أمان المبنى والجراج، وسيتم إعلان النتائج فور انتهاء المهلة المحددة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, size: 15, color: AppColors.teal),
              label: const Text('تأكيد المتابعة مع الجيران', style: TextStyle(fontSize: 11.5, color: AppColors.teal)),
            ),
          ),
        ],
      ),
    );
  }
}
