import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../jobs/post_job_form_screen.dart';
import '../marketplace/add_listing_screen.dart';
import '../recycling/recycling_marketplace_screen.dart';
import '../services/technicians_market_screen.dart';

/// "What do you want to post today?" hub — routes to the four posting
/// flows already built. Matches design/screens/31_smart_post_picker.png.
class SmartPostPickerScreen extends StatelessWidget {
  const SmartPostPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('بوابة النشر الذكية')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('ماذا تريد أن تنشر في مجتمعك اليوم؟', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, height: 1.4)),
          const SizedBox(height: 6),
          const Text(
            'اختر نوع الإعلان المناسب للوصول إلى جيرانك الموثقين بالمعادي، مع كامل التحكم في خصوصية هويتك ورقم هاتفك.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 18),
          _PickerCard(
            badge: 'الأكثر طلباً • جديد نشط',
            badgeColor: AppColors.teal,
            icon: Icons.work_rounded,
            iconColor: AppColors.categoryJobs,
            title: 'وظيفة شاغرة أو طلب عمل',
            body: 'أعلن عن فرصة عمل بشركتك أو محلك، أو ابحث عن كفاءات محترفة من سكان الحي. يدعم استقبال السير الذاتية (CV)، تحديد الراتب، وجدولة المقابلات السريعة.',
            note: 'حجب رقم الهاتف وتفعيل التقديم المباشر',
            ctaLabel: 'نشر وظيفة',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostJobFormScreen())),
          ),
          const SizedBox(height: 14),
          _PickerCard(
            badge: 'حسب القرب السكني',
            badgeColor: AppColors.categoryUsedMarket,
            icon: Icons.shopping_bag_rounded,
            iconColor: AppColors.categoryUsedMarket,
            title: 'بيع بسوق المستعمل',
            body: 'اعرض أثاث، أجهزة ومنزل ومستلزمات للبيع أو الإهداء مع ميزة استثنائية لحجب الإعلان تماماً عن سكان عمارتك وترتيب الأولوية للمشترين الأقرب جغرافياً.',
            note: 'ميزة إخفاء الإعلان عن عمارتك تلقائياً',
            ctaLabel: 'إضافة إعلان مستعمل',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddListingScreen())),
          ),
          const SizedBox(height: 14),
          _PickerCard(
            badge: 'دفع بالضمان المالي Escrow',
            badgeColor: AppColors.teal,
            icon: Icons.build_rounded,
            iconColor: AppColors.categoryMaintenance,
            title: 'خدمات وصيانة منزلية',
            body: 'سجل خدماتك الحرفية (سباكة، كهرباء، تكييف، نجارة) أو اطلب صيانة فورية عبر نظام المحفظة الضامنة لراحة بال تامة لكلا الطرفين.',
            note: 'تسجيل كفني معتمد يخضع لفحص الجودة',
            ctaLabel: 'سجل كفني معتمد',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TechniciansMarketScreen())),
          ),
          const SizedBox(height: 14),
          _PickerCard(
            badge: 'خاص باتحادات الملاك وتجار البيكيا',
            badgeColor: AppColors.gold,
            icon: Icons.recycling_rounded,
            iconColor: AppColors.categoryRecycling,
            title: 'تدوير الخردة والبيكيا',
            body: 'اطرح مخلفات العمارة المجمعة (كرتون، بلاستيك، ألومنيوم) لصالح خزينة العمارة وتنافس خبرة تجار التدوير الموثقين للحصول على أفضل عرض وأسرع تسليم.',
            note: 'عائد نقدي مباشر لخزينة التمارة',
            ctaLabel: 'بوابة التدوير',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecyclingMarketplaceScreen())),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.shield_outlined, size: 18, color: AppColors.inkSecondary),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ميثاق النشر وحماية الجيران', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    SizedBox(height: 3),
                    Text(
                      'تخضع جميع الإعلانات آلياً لمراجعة فورية وفق قواعد السكن الراقي وتضمن حماية أرقام التواصل بنسبة 100% ومنع أي تطفل غير مرغوب.',
                      style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.note,
    required this.ctaLabel,
    required this.onTap,
  });

  final String badge, title, body, note, ctaLabel;
  final Color badgeColor, iconColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: Text(badge, style: TextStyle(fontSize: 9, color: badgeColor, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 6),
                      Text(body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.7)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.verified_outlined, size: 12, color: AppColors.inkMuted),
              const SizedBox(width: 5),
              Expanded(child: Text(note, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted))),
              Text(ctaLabel, style: const TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w700)),
              const Icon(Icons.arrow_back_rounded, size: 13, color: AppColors.teal),
            ]),
          ],
        ),
      ),
    );
  }
}
