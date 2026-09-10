import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'union_dashboard_screen.dart';

const _steps = [
  (
    title: 'تحديد قيمة الاشتراك الشهري لصندوق الصيانة',
    subtitle: 'القيمة المقترحة التقديرية بناءً على مساحات الوحدات: 250 ج.م شهرياً لكل شقة.',
  ),
  (
    title: 'دعوة باقي سكان الشقق الـ 4 المتبقية',
    subtitle: 'مشاركة كود الانضمام السريع لتسجيل باقي الملاك وتحديث دليل الملاك.',
  ),
  (
    title: 'فتح الحساب البنكي / المحفظة المشتركة للعقار',
    subtitle: 'ربط الحساب البنكي الرسمي لتحصيل التحويلات وفواتير الصيانة عبر التطبيق.',
  ),
];

/// Election result confirmed & union founded — matches
/// design/screens/45_union_founding_success.png.
class UnionFoundingSuccessScreen extends StatelessWidget {
  const UnionFoundingSuccessScreen({super.key, this.buildingName = 'عمارة 14'});
  final String buildingName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('اعتماد نتيجة الانتخابات وترقية الحساب')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.military_tech_rounded, color: AppColors.teal, size: 40),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: const Text('تم اعتماد نتيجة التصويت بنجاح بنسبة نصاب 75%', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('تهانينا لجيران $buildingName! تم تأسيس اتحاد الملاك واختيار الرئيس',
              textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, height: 1.5)),
          const SizedBox(height: 8),
          const Text(
            'اكتمل النصاب القانوني للجلسة التأسيسية وتم توثيق المحضر إلكترونياً بسلامة وشفافية كاملة.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.share_outlined, size: 18, color: AppColors.inkMuted),
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 20, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('م. طارق عبد الحميد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text('شقة 3B', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                      child: const Text('رئيس اتحاد الملاك المنتخب', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(children: const [
                  Text('نتيجة فرز الأصوات النهائي', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                  Spacer(),
                  Text('77.8%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.778, minHeight: 8, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
                const SizedBox(height: 10),
                Row(children: const [
                  Icon(Icons.thumb_up_alt_outlined, size: 13, color: AppColors.teal),
                  SizedBox(width: 4),
                  Text('7 أصوات مؤيدة من إجمالي 9 مصوتين', style: TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
                  Spacer(),
                  Text('امتناع: 0', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  SizedBox(width: 8),
                  Text('معارض: 2', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 10),
                Row(children: const [
                  Icon(Icons.check_circle_outline_rounded, size: 13, color: AppColors.teal),
                  SizedBox(width: 4),
                  Expanded(child: Text('تم التوثيق بتاريخ اليوم عبر منظومة مجتمعي الرقمية المعتمدة', style: TextStyle(fontSize: 10, color: AppColors.inkMuted))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.lock_open_rounded, color: AppColors.gold, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('ترقية فورية للصلاحيات الإدارية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                    child: const Text('مفتاح [07]', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text(
                  'تمت ترقية حسابك تلقائياً إلى «رئيس اتحاد الملاك» — فُتحت لك الآن صلاحيات كاملة في لوحة التحكم لإدارة تحصيل اشتراكات الصيانة، صندوق العمارة، ومتابعة الطلبات بكل سهولة.',
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('خارطة الخطوات التأسيسية الأولى', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('3 مهام مطلوبة', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          for (var i = 0; i < _steps.length; i++) ...[
            _StepCard(index: i + 1, title: _steps[i].title, subtitle: _steps[i].subtitle),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 15, color: AppColors.teal),
              SizedBox(width: 6),
              Expanded(child: Text('بالضغط أدناه تنتقل مباشرة إلى لوحة تحكم اتحاد الملاك بصفتك رئيساً منتخباً.', style: TextStyle(fontSize: 10.5, color: AppColors.teal))),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionDashboardScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
              label: const Text('الدخول إلى لوحة تحكم اتحاد الملاك الآن', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 15, color: AppColors.inkMuted),
              label: const Text('تحميل محضر اجتماع التأسيس الرقمي (PDF)', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.index, required this.title, required this.subtitle});
  final int index;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
            child: Text('$index', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.4)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
