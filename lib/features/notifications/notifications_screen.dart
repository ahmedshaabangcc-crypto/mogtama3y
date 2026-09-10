import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _Notice {
  const _Notice({required this.icon, required this.iconColor, required this.title, required this.body, required this.time, this.unread = false});
  final IconData icon;
  final Color iconColor;
  final String title, body, time;
  final bool unread;
}

const _notices = [
  _Notice(
    icon: Icons.how_to_vote_rounded,
    iconColor: AppColors.categoryUnion,
    title: 'استفتاء جديد يحتاج تصويتك',
    body: 'تركيب كاميرات مراقبة ذكية في الجراج ومداخل المبنى - صوّت الآن قبل إغلاق التصويت.',
    time: 'منذ 10 دقائق',
    unread: true,
  ),
  _Notice(
    icon: Icons.local_shipping_outlined,
    iconColor: AppColors.categoryShops,
    title: 'طلبك #1084 في الطريق إليك',
    body: 'مندوب سوبر ماركت الأمانة وصل لمدخل البرج، سيصلك الطلب خلال دقائق.',
    time: 'منذ 25 دقيقة',
    unread: true,
  ),
  _Notice(
    icon: Icons.payments_outlined,
    iconColor: AppColors.gold,
    title: 'اشتراك الصيانة مستحق قريباً',
    body: '350 ج.م مستحقة عن شهر مارس، آخر موعد للسداد قبل الغرامة: 10 مارس.',
    time: 'منذ ساعتين',
  ),
  _Notice(
    icon: Icons.chat_bubble_outline_rounded,
    iconColor: AppColors.teal,
    title: 'رسالة جديدة من م/ خالد البحيري',
    body: 'اقترح موعد فحص وزيارة اليوم الساعة 05:30 مساءً.',
    time: 'منذ 3 ساعات',
  ),
  _Notice(
    icon: Icons.recycling_rounded,
    iconColor: AppColors.categoryRecycling,
    title: 'مزادك على وشك الانتهاء',
    body: 'خردة 2 تكييف سبليت قديم + مواسير نحاس - أعلى عرض حالياً 1,850 ج.م.',
    time: 'أمس',
  ),
  _Notice(
    icon: Icons.verified_user_outlined,
    iconColor: AppColors.inkSecondary,
    title: 'تم اعتماد عضويتك في اتحاد الملاك',
    body: 'أصبحت الآن عضواً موثقاً في اتحاد ملاك برج الياسمين.',
    time: 'منذ يومين',
  ),
];

/// Notifications tab — the bottom-nav "الإشعارات" tab.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('تحديد الكل كمقروء', style: TextStyle(color: Colors.white, fontSize: 11.5)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: _notices.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final n = _notices[i];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: n.unread ? AppColors.teal.withValues(alpha: 0.06) : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: n.unread ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: n.iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(n.icon, color: n.iconColor, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5))),
                        if (n.unread) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 6), decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
                      ]),
                      const SizedBox(height: 3),
                      Text(n.body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.6)),
                      const SizedBox(height: 6),
                      Text(n.time, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
