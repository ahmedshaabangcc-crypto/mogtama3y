import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'found_building_screen.dart';
import 'join_as_tenant_screen.dart';
import 'union_registration_screen.dart';

/// Find/join your building's owners' union — was reachable straight
/// from the home screen and showed a "browse nearby buildings" list of
/// THREE entirely fabricated buildings (fake addresses, fake quorum
/// percentages like "58% joined" and "16/16 مكتمل", a fake interactive-
/// map thumbnail) whose "join" buttons fed into union_registration_
/// screen.dart pre-filled with that fake name — which even defaulted to
/// 'برج الياسمين الفاخر' when reached any other way. No real "browse
/// buildings near me" feature exists (that would need a public search
/// over buildings + a distinct "request to join" flow, not built).
/// Rebuilt to offer only the two real paths that already exist: found a
/// new building, or join an existing one with a real invite code.
class FindBuildingScreen extends StatelessWidget {
  const FindBuildingScreen({super.key});

  void _showQuorumInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نصاب الـ 51% القانوني'),
        content: const Text(
          'وفقاً لقانون تنظيم اتحادات الشاغلين المصري، يلزم موافقة مالكي 51% على الأقل من وحدات العقار على الأقل لتأسيس اتحاد ملاك رسمي والبدء في انتخاب مجلس إدارته. '
          'اجمع موافقات جيرانك أولاً، ثم أسّس الاتحاد من هذا التطبيق.',
          style: TextStyle(height: 1.7),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('البحث عن عقارك والانضمام')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                  child: const Text('خطوة التأسيس', style: TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                const Text('لعمارات بدون اتحاد ملاك رسمي — ابدأ بجمع جيرانك وتأسيس مجلس إدارتكم الرقمي بكل سهولة وشفافية.',
                    style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.apartment_rounded, color: AppColors.teal, size: 20),
                  SizedBox(width: 8),
                  Text('لم يتأسس اتحاد ملاك لعقارك بعد؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'كن أنت المبادر الأول! أضف عقارك واحصل على رابط دعوة فوري ورقمي قابل للمشاركة لتعليمه بمدخل العمارة لدعوة باقي الجيران.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FoundBuildingScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('إضافة وتسجيل عنوان عمارتك وبدء دعوة الجيران', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.mail_outline_rounded, color: AppColors.navy, size: 20),
                  SizedBox(width: 8),
                  Text('عمارتك أسّست اتحادها بالفعل؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'لو استلمت كود دعوة من رئيس اتحاد ملاك عمارتك، استخدمه هنا لتوثيق شقتك والانضمام.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionRegistrationScreen())),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.navy, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.groups_rounded, size: 18),
                    label: const Text('عندي كود دعوة من رئيس الاتحاد', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JoinAsTenantScreen())),
              icon: const Icon(Icons.key_rounded, size: 16, color: AppColors.teal),
              label: const Text('عندي كود دعوة من مالك شقتي (مستأجر)', style: TextStyle(fontSize: 12, color: AppColors.teal, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () => _showQuorumInfo(context),
              icon: const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.inkMuted),
              label: const Text('كيف نصل لنصاب الـ 51% قانونياً؟', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}
