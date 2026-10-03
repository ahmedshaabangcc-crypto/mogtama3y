import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';

const _pillars = [
  (
    icon: Icons.qr_code_2_rounded,
    title: 'عنوانك الإلكتروني',
    body: 'عنوانك بالتفصيل وبالموقع على الخريطة في كود أو اسم سهل، تبعته لأي حد يوصلك من غير ما توصف الطريق.',
  ),
  (
    icon: Icons.shield_outlined,
    title: 'الأمان والضمان المالي (Escrow)',
    body: 'يُحجز مبلغ الصيانة في محفظتك ولا يُصرف للفني إلا بعد أن تتأكد من العمل وتعطيه كود الاستلام.',
  ),
  (
    icon: Icons.storefront_outlined,
    title: 'تنمية الاقتصاد المحلي',
    body: 'دليل لمحلات الحي، وسوق للمستعمل بين الجيران، ومزادات للخردة والتدوير.',
  ),
  (
    icon: Icons.privacy_tip_outlined,
    title: 'بيئة سكنية آمنة تحمي الخصوصية',
    body: 'رقم هاتفك لا يظهر لأي حد إلا لو اخترت إظهاره في إعلانك أو عنوانك.',
  ),
];

/// About the platform / marketing page — matches
/// design/screens/28_about_platform.png.
class AboutPlatformScreen extends StatelessWidget {
  const AboutPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('عن منصة مُجتمعي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('من نحن وعن منصة مُجتمعي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 4),
          const Text('الرؤية، الرسالة، وركائز السكن الذكي التشاركي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: const Text('الريادة السكنية', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.hub_rounded, color: Colors.white, size: 18),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text('مُجتمعي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                const Text('Mogtama3y Smart Living', style: TextStyle(color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 10),
                const Text(
                  'منصة مجتمعية ذكية تربط الجيران بخدمات حيّهم: سوق المستعمل والمحلات وخدمات صيانة منزلية بضمان مالي وتجارة محلية آمنة بدون أي وساطة معقدة.',
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.8),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    image: const DecorationImage(image: AssetImage('assets/images/building_header.png'), fit: BoxFit.cover, opacity: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: const [
                  Icon(Icons.verified_rounded, size: 13, color: AppColors.tealLight),
                  SizedBox(width: 6),
                  Text('كل خدمات حيّك في مكان واحد', style: TextStyle(color: AppColors.tealLight, fontSize: 10.5, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('ركائز مُجتمعي الأربعة الأساسية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Text('الأسس التقنية والاجتماعية التي تُبنى عليها منصتنا', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          for (var i = 0; i < _pillars.length; i++) ...[
            _PillarRow(index: i + 1, icon: _pillars[i].icon, title: _pillars[i].title, body: _pillars[i].body),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => context.go(AppRoutes.nearby),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.near_me_rounded, size: 18),
              label: const Text('اكتشف حواليك', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('كل خدمات حيّك في تطبيق واحد.', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _PillarRow extends StatelessWidget {
  const _PillarRow({required this.index, required this.icon, required this.title, required this.body});
  final int index;
  final IconData icon;
  final String title, body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.teal, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, shape: BoxShape.circle),
                    child: Text('$index', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.4))),
                ]),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

