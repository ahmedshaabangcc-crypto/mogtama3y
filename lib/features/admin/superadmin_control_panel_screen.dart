import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Platform super-admin control panel — dispute arbitration, business
/// claims, and security controls. Matches
/// design/screens/23_superadmin_control_panel.png.
class SuperadminControlPanelScreen extends StatelessWidget {
  const SuperadminControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تحكم السوبر أدمن')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 6, color: AppColors.teal),
                SizedBox(width: 4),
                Text('سيرفر متصل ومراقَب لحظياً', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          const Text('لوحة تحكم السوبر أدمن وفض النزاعات والرقابة العامة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.4)),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(child: Text('مؤشرات الرقابة الحية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            const Text('تحديث فوري', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: const [
              _StatCard(icon: Icons.lock_outline_rounded, value: '142,500 ج.م', label: 'أموال الضمان (Escrow)', note: 'في 46 عملية نشطة ومؤمنة'),
              _StatCard(icon: Icons.verified_rounded, value: '184 عمارة', label: 'العقارات الموثقة', note: '+12 عمارة هذا الشهر', noteColor: AppColors.teal),
              _StatCard(icon: Icons.storefront_outlined, value: '5 طلبات', label: 'اعتماد المحلات والأنشطة', note: 'جديدة تنتظر الفحص'),
              _StatCard(icon: Icons.gavel_rounded, value: '2 نزاعات', label: 'نزاعات بانتظار الحكم', note: 'قيد المراجعة الفورية', noteColor: AppColors.categorySos),
            ],
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('فض النزاعات والتحكيم المالي (Escrow)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('عاجل', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          const _DisputeCard(),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('اعتماد وتملك المحلات والأنشطة (Claim Business)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('5 طلبات', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          const _ClaimBusinessCard(),
          const SizedBox(height: 22),
          const Text('أدوات الرقابة والتحكم الأمني المتقدم', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.categorySos.withValues(alpha: 0.3))),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.categorySos),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تجميد حركة المحافظ والتحويلات المالية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.categorySos)),
                    Text('يُستخدم فقط في حالات الطوارئ والاشتباه الأمني القصوى', style: TextStyle(fontSize: 9.5, color: AppColors.categorySos)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.inkSecondary),
                    const SizedBox(height: 8),
                    const Text('رصد الأمان المجتمعي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                    const Text('3 بلاغات محتوى محلي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: const Icon(Icons.arrow_back_rounded, size: 13),
                      label: const Text('مراجعة البلاغات', style: TextStyle(fontSize: 10.5)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.badge_outlined, color: AppColors.inkSecondary),
                    const SizedBox(height: 8),
                    const Text('صلاحيات الاتحادات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                    const Text('الفحص والتدقيق الدوري', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      icon: const Icon(Icons.arrow_back_rounded, size: 13),
                      label: const Text('إدارة 184 رئيساً', style: TextStyle(fontSize: 10.5)),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label, required this.note, this.noteColor = AppColors.inkMuted});
  final IconData icon;
  final String value, label, note;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          const SizedBox(height: 2),
          Text(note, style: TextStyle(fontSize: 8.5, color: noteColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard();

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
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('350 ج.م محجوزة بالضمان', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const Text('#842', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 8),
          const Text('نزاع على خدمة صيانة تكييف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('الطرف الأول (مقدم الخدمة)', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  Text('صابر للتبريد والتكييف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                  Text('فني معتمد بالمنطقة', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('الطرف الثاني (الساكن المشتكي)', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  Text('م. أحمد عزت', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                  Text('برج الياسمين - شقة 402', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Icon(Icons.warning_amber_rounded, size: 13, color: AppColors.categorySos), SizedBox(width: 5), Text('سبب النزاع:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.categorySos))]),
                SizedBox(height: 4),
                Text(
                  'عدم اكتمال شحن الفريون وظهور تسريب مياه كثيف داخل الغرفة بعد ساعتين من مغادرة الفني ورفضه إعادة المعاينة.',
                  style: TextStyle(fontSize: 10, color: AppColors.inkSecondary, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.image_outlined, size: 13, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            const Text('صور الضرر (2)', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            const SizedBox(width: 12),
            const Icon(Icons.chat_bubble_outline_rounded, size: 13, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            const Text('محادثة الشات المسجلة', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 12),
          const Text('اتخاذ القرار الإداري التحكيمي:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: const Icon(Icons.replay_rounded, size: 15),
              label: const Text('تحرير 350 ج.م للساكن (استرداد كامل)', style: TextStyle(fontSize: 11.5)),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('تكليف فني مُحايد', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('تحرير المبلغ للفني', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _ClaimBusinessCard extends StatelessWidget {
  const _ClaimBusinessCard();

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
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('طلب تملك وتوصيل', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            const Text('#204', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 8),
          const Text('صيدلية الأمل الحديثة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          Row(children: const [
            Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkMuted),
            SizedBox(width: 4),
            Text('دجلة المعادي - شارع 206', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          const Text('الوثائق والتحقق المرفق:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: const [
            Icon(Icons.check_circle_rounded, size: 13, color: AppColors.teal),
            SizedBox(width: 4),
            Expanded(child: Text('تزكية رئيس اتحاد ملاك عمارة 14', style: TextStyle(fontSize: 10.5))),
          ]),
          const SizedBox(height: 4),
          Row(children: const [
            Icon(Icons.description_outlined, size: 13, color: AppColors.inkSecondary),
            SizedBox(width: 4),
            Expanded(child: Text('السجل التجاري والبطاقة الضريبية', style: TextStyle(fontSize: 10.5))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('رفض مع ذكر السبب', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('اعتماد وتفعيل التوصيل 500م', style: TextStyle(fontSize: 10.5)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
