import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../shell/app_shell.dart';
import 'union_dashboard_screen.dart';

const _perks = [
  (
    icon: Icons.verified_user_rounded,
    title: 'شارة الجار الموثق (Verified Neighbor)',
    subtitle: 'تظهر شارة خضراء بجوار اسمك في سوق المستعمل والتطبيق',
  ),
  (
    icon: Icons.how_to_vote_rounded,
    title: 'التصويت والجمعية العمومية',
    subtitle: 'حق المشاركة في استفتاءات وموازنات اتحاد الملاك',
  ),
  (
    icon: Icons.qr_code_2_rounded,
    title: 'إصدار تصاريح الزوار (QR Pass)',
    subtitle: 'توليد أكواد دخول مشفرة ومؤقتة لضيوفك وأمن العقار',
  ),
  (
    icon: Icons.shopping_bag_outlined,
    title: 'سوق المستعمل الشامل',
    subtitle: 'بيع وشراء الأغراض المنزلية المستعملة بحماية وخصوصية',
  ),
  (
    icon: Icons.handyman_outlined,
    title: 'سوق الخدمات والفنيين المعتمدين',
    subtitle: 'طلب فني الصيانة والكهرباء والتكييف المعتمدين وحجز المواعيد',
  ),
  (
    icon: Icons.villa_outlined,
    title: 'سوق العقارات السكني الموثق',
    subtitle: 'تصفح وعرض شقق للإيجار والبيع والوحدات المعتمدة داخل وخارج البرج',
  ),
  (
    icon: Icons.storefront_outlined,
    title: 'دليل المحلات والتسوق السريع',
    subtitle: 'الطلب والتوصيل السريع خلال دقائق من السوبرماركت والصيدلية',
  ),
];

/// Success screen after union-membership approval — matches
/// design/screens/09_verified_neighbor_welcome.png.
class VerifiedNeighborWelcomeScreen extends StatelessWidget {
  const VerifiedNeighborWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأكيد الاعتماد والترحيب')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(24)),
                  child: const Icon(Icons.shield_rounded, color: AppColors.teal, size: 40),
                ),
                const Positioned(top: -4, left: -4, child: Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 22)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('أهلاً بك جاراً موثقاً في عائلة مُجتمعي!',
              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, height: 1.5)),
          const SizedBox(height: 8),
          const Text(
            'تم اعتماد كود الدعوة وموافقة مجلس رئيس اتحاد ملاك برج الياسمين رسمياً وتفعيل عضويتك السكنية.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 20),
          const _ResidentCard(),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.gold),
              const SizedBox(width: 6),
              const Text('المزايا المفعّلة لحسابك السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
              const Spacer(),
              Text('٧ خدمات ومزايا مفعّلة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in _perks) ...[
            _PerkTile(icon: p.icon, title: p.title, subtitle: p.subtitle),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AppShell()),
                  (route) => false,
                );
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionDashboardScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('الانتقال إلى لوحة تحكم العمارة وبدء الاستخدام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.ink,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('تحميل بطاقة الساكن الرقمية (PDF)', style: TextStyle(fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResidentCard extends StatelessWidget {
  const _ResidentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.navy, Color(0xFF0E6B55)], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                child: const Text('عضوية معتمدة بكود الدعوة', style: TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              const Text('بطاقة الساكن الرقمية', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(width: 6),
              const Text('مُجتمعي', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(6)),
                  ),
                  const SizedBox(height: 4),
                  const Text('NFC ACTIVE', style: TextStyle(color: Colors.white54, fontSize: 8)),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الاسم الكامل', style: TextStyle(color: Colors.white54, fontSize: 9.5)),
                    const Text('أحمد شكري', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.location_on, size: 11, color: Colors.white70),
                      const SizedBox(width: 3),
                      const Expanded(child: Text('برج الياسمين الفاخر - المعادي', style: TextStyle(color: Colors.white70, fontSize: 10.5), overflow: TextOverflow.ellipsis)),
                    ]),
                    Row(children: [
                      const Icon(Icons.door_front_door_outlined, size: 11, color: Colors.white70),
                      const SizedBox(width: 3),
                      const Text('شقة 4B • الدور الرابع', style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('معتمد من رئيس الاتحاد: م. أحمد شريف', style: TextStyle(color: Colors.white70, fontSize: 10)),
                SizedBox(height: 2),
                Text('كود الدعوة المعتمد: YSM-9482', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.qr_code_2_rounded, size: 40),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('معرف الاعتماد السكني', style: TextStyle(color: Colors.white54, fontSize: 9.5)),
                    Text('YSM-42-04B', style: TextStyle(color: AppColors.tealLight, fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('تاريخ التوثيق: أكتوبر ٢٠٢٤', style: TextStyle(color: Colors.white54, fontSize: 9.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerkTile extends StatelessWidget {
  const _PerkTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.teal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
