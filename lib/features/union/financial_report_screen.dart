import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _ledgerEntries = [
  (
    title: 'صيانة لوحة تحكم المصعد الرئيسي وتغيير حساسات الأمان',
    vendor: 'شركة أوتيس للمصاعد والهندسة',
    amount: '4,800',
    attachment: 'مرفق فاتورة معتمدة رقم #INV-883',
    status: 'معاينة',
    icon: Icons.elevator_outlined,
  ),
  (
    title: 'فاتورة كهرباء السلم والمصاعد العمومية',
    vendor: 'عداد تجاري مشترك كود 40912',
    amount: '3,250',
    attachment: 'مرفق إيصال شركة الكهرباء (سداد فوري)',
    status: 'معاينة',
    icon: Icons.bolt_rounded,
  ),
  (
    title: 'تطهير وغسيل خزان المياه العلوي مع التعقيم',
    vendor: 'شركة النيل للخدمات الصحية والبيئية',
    amount: '1,800',
    attachment: 'شهادة فحص نقاء العينة بعد التعقيم',
    status: 'معاينة',
    icon: Icons.water_drop_outlined,
  ),
  (
    title: 'رواتب الحراسة والأمن والنظافة الدورية',
    vendor: 'عن 3 أشهر (طاقم الحراسة وعاملي الصيانة)',
    amount: '12,000',
    attachment: 'كشف التوقيع والاستلام البنكي المجمع',
    status: 'مكتمل السداد',
    icon: Icons.security_rounded,
  ),
];

/// Quarterly general-assembly financial report — matches
/// design/screens/12_financial_report.png.
class FinancialReportScreen extends StatelessWidget {
  const FinancialReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('التقرير المالي الشامل للجمعية العمومية')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('وثيقة تدقيق رسمية موثقة', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const Text('تحديث: 30 سبتمبر 2025', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 6),
          const Text('الشفافية الكاملة لصندوق شاغلي اتحاد برج الياسمين', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.inkSecondary),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الفترة المالية المعتمدة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    Text('الربع الثالث (يوليو - سبتمبر 2025)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ],
                ),
              ),
              const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('إجمالي التحصيلات والاشتراكات', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                    child: const Text('سداد 96%', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 6),
                const Text('78,400 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
                const Text('من أصل 81,600 ج.م', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.96, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: const [
                      Icon(Icons.savings_outlined, size: 15, color: AppColors.teal),
                      SizedBox(width: 5),
                      Text('صندوق الطوارئ', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                    ]),
                    const SizedBox(height: 6),
                    const Text('26,250 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const Text('نمو +15% فائض مرحل', style: TextStyle(fontSize: 9, color: AppColors.teal)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(children: [
                      Icon(Icons.trending_down_rounded, size: 15, color: AppColors.categorySos),
                      SizedBox(width: 5),
                      Text('مصروفات فعلية', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                    ]),
                    SizedBox(height: 6),
                    Text('52,150 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text('ضمن ميزانية التقدير', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('توزيع التدفقات والمصروفات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('ميزانية متزنة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(size: const Size(110, 110), painter: _DonutPainter()),
                      const Text('33.5%\nفائض', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, height: 1.3)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _LegendRow(color: Color(0xFF12233F), label: 'أجور الحراسة والنظافة', value: '12,000 ج.م'),
                      SizedBox(height: 8),
                      _LegendRow(color: AppColors.gold, label: 'صيانة وتجهيز مصاعد وخزان', value: '6,600 ج.م'),
                      SizedBox(height: 8),
                      _LegendRow(color: AppColors.teal, label: 'كهرباء وخدمات عمومية', value: '3,250 ج.م'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('دفتر الأستاذ والمصروفات المفصل', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('4 بنود مسجلة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          for (final e in _ledgerEntries) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                      child: Icon(e.icon, size: 17, color: AppColors.inkSecondary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, height: 1.4)),
                          Text(e.vendor, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    Text('${e.amount} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.attach_file_rounded, size: 12, color: AppColors.inkMuted),
                    const SizedBox(width: 4),
                    Expanded(child: Text(e.attachment, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: (e.status == 'مكتمل السداد' ? AppColors.teal : AppColors.navy).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(e.status, style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: e.status == 'مكتمل السداد' ? AppColors.teal : AppColors.navy)),
                    ),
                  ]),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.workspace_premium_outlined, size: 16, color: AppColors.inkSecondary),
                  const SizedBox(width: 6),
                  const Text('اعتماد مجلس الإدارة والتدقيق المالي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                    child: const Text('مصدق رسمياً', style: TextStyle(fontSize: 8.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('رئيس مجلس الإدارة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        Text('م. حازم عبد الرحمن', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('توقيع رقمي معتمد #HZ-09', style: TextStyle(fontSize: 9, color: AppColors.teal)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('أمين الصندوق والمالية', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        Text('أ. طارق الشربيني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('توقيع رقمي معتمد #TS-44', style: TextStyle(fontSize: 9, color: AppColors.teal)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: const [
                    Icon(Icons.verified_rounded, size: 16, color: AppColors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الختم الرقمي الرسمي لاتحاد ملاك برج الياسمين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5)),
                          Text('رقم التوثيق البلدي: REG-CAIRO-2024-91823', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'تم إعداد هذا التقرير وتدقيقه آلياً وفقاً لأحكام اللائحة التنفيذية لاتحادات الشاغلين، ويحق لأي ساكن مسجل تقديم استفساراته الخطية عبر التطبيق خلال 15 يوماً من تاريخ النشر.',
            style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted, height: 1.7),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.download_rounded, size: 17),
              label: const Text('تحميل التقرير المالي الرسمي المعتمد (PDF)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.mail_outline_rounded, size: 14, color: AppColors.inkMuted),
              label: const Text('تقديم استفسار أو ملاحظة مالية لأمين الصندوق', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label, required this.value});
  final Color color;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary), overflow: TextOverflow.ellipsis)),
        Text(value, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final segments = [
      (value: 0.545, color: const Color(0xFF12233F)),
      (value: 0.30, color: AppColors.gold),
      (value: 0.155, color: AppColors.teal),
    ];
    var start = -90 * (3.1415926535 / 180);
    for (final seg in segments) {
      final sweep = seg.value * 2 * 3.1415926535;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
