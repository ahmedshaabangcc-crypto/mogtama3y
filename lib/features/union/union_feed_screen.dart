import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'union_dashboard_screen.dart';

/// اتحاد الملاك community feed — matches design/screens/00_union_feed_community.png.
class UnionFeedScreen extends StatelessWidget {
  const UnionFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('مجتمع برج الياسمين'),
        actions: [
          IconButton(
            tooltip: 'لوحة إدارة الاتحاد',
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionDashboardScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          _CommunityCard(),
          const SizedBox(height: 16),
          _FilterTabs(),
          const SizedBox(height: 16),
          _PostCard(
            child: _OfficialAnnouncementPost(),
          ),
          const SizedBox(height: 14),
          _PostCard(child: _MaintenanceQuestionPost()),
          const SizedBox(height: 14),
          _PostCard(child: _LostFoundPost()),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 18, color: AppColors.inkMuted)),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                  child: const Row(
                    children: [
                      Text('شارك جيرانك خبر، أو استفسار...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.image_outlined, color: AppColors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.categoryUnion, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('مجتمع برج الياسمين السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.circle, size: 6, color: AppColors.teal),
                  SizedBox(width: 4),
                  Text('المجلس نشط', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w600)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatChip(icon: Icons.groups_rounded, text: '38 جار موثّق بالعقد')),
              const SizedBox(width: 8),
              Expanded(child: _StatChip(icon: Icons.verified_rounded, text: 'مجتمع موثق 100%')),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.inkMuted),
              SizedBox(width: 6),
              Text('دخول مغلق وآمن لسكان البرج فقط', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.inkSecondary),
          const SizedBox(width: 6),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tabs = ['الكل', 'إعلانات الجيران', 'استفسارات وخدمات'];
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: i == 0 ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: i == 0 ? AppColors.navy : AppColors.border),
            ),
            child: Text(tabs[i], style: TextStyle(fontSize: 12, color: i == 0 ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w600)),
          ),
        ],
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: child,
    );
  }
}

class _EngagementRow extends StatelessWidget {
  const _EngagementRow({required this.likes, required this.comments, this.likeLabel = 'تفاعل'});
  final int likes, comments;
  final String likeLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.inkMuted),
          const SizedBox(width: 4),
          Text('$likes $likeLabel', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          const SizedBox(width: 16),
          const Icon(Icons.mode_comment_outlined, size: 16, color: AppColors.inkMuted),
          const SizedBox(width: 4),
          Text('$comments تعليقات', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          const Spacer(),
          const Icon(Icons.share_outlined, size: 16, color: AppColors.inkMuted),
        ],
      ),
    );
  }
}

class _OfficialAnnouncementPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.push_pin_rounded, size: 14, color: AppColors.teal),
            const SizedBox(width: 6),
            const Text('إعلان رسمي مثبّت • اتحاد الملاك', style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600)),
            const Spacer(),
            const Text('اليوم، 09:30 ص', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Stack(children: [
              const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
              const Positioned(bottom: 0, left: 0, child: Icon(Icons.verified_rounded, size: 14, color: AppColors.teal)),
            ]),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مجلس إدارة برج الياسمين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('أ. أحمد منصور (أمين الصندوق) • شقة 102', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'تحية طيبة لجيراننا الأعزاء، نود الإحاطة بإجراء الصيانة الدورية الشاملة للمصاعد يوم الخميس القادم من 10 ص حتى 1 ظهراً. كما نذكركم ببدء تحصيل ودفعة الصيانة الشهرية عبر التطبيق لتغطية مصاريف الإضاءة والنظافة.',
          style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.inkSecondary),
        ),
        const SizedBox(height: 10),
        Container(
          height: 120,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Icon(Icons.build_circle_outlined, size: 32, color: AppColors.inkMuted)),
        ),
        const _EngagementRow(likes: 29, comments: 6),
      ],
    );
  }
}

class _MaintenanceQuestionPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('د. منى عبد الرحمن', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('الدور الرابع • شقة 402 • منذ ساعتين', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'مساء الخير يا جيران، محتاجة أمين وحرفي محترف لمعالجة تسريب بسيط في حساس الحمام الرئيسي، هل في تجربة ممتازة مع حد قريب من البرج؟',
          style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.inkSecondary),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.verified_rounded, size: 14, color: AppColors.teal),
                SizedBox(width: 4),
                Text('توصية موثّقة من الجيران', style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: AppColors.surface, child: Icon(Icons.plumbing_rounded, size: 16, color: AppColors.teal)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('الأسطى ناصر (سباك)\n4.9★ • رشحه م. طارق كمال', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.4)),
                  ),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)),
                      icon: const Icon(Icons.call_rounded, size: 14),
                      label: const Text('اتصال سريع', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _EngagementRow(likes: 14, comments: 8, likeLabel: 'إعجاب'),
      ],
    );
  }
}

class _LostFoundPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('م. طارق كمال', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('جار معتمد • شقة 203 • أمس', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('أمانة مفقودة', style: TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'عثر على مفاتيح سيارة مع شريحة أمان بمدخل موقف العمارة اليوم بعد الظهر. موجودة لدى حارس العقار (عم سعيد) في غرفة الاستقبال للتسليم بعد التحقق من المطابقة.',
          style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.inkSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('✓ تم التواصل مع الحارس', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
        ),
        const _EngagementRow(likes: 19, comments: 3),
      ],
    );
  }
}
