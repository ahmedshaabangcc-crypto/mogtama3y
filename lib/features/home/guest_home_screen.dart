import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../jobs/jobs_board_screen.dart';
import '../lost_found/lost_found_hub_screen.dart';
import '../marketplace/marketplace_listing_screen.dart';
import '../recycling/recycling_marketplace_screen.dart';
import '../services/technicians_market_screen.dart';
import '../shared/placeholder_screen.dart';
import '../shops/neighborhood_shops_screen.dart';
import '../sos/sos_emergency_screen.dart';
import '../union/find_building_screen.dart';
import '../union/union_feed_screen.dart';

class _Category {
  const _Category(this.label, this.sublabel, this.icon, this.color);
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
}

const _categories = [
  _Category('سوق المستعمل', 'سلع من الجيران', Icons.shopping_bag_rounded, AppColors.categoryUsedMarket),
  _Category('المحلات', 'دليفري ومتاجر 500م', Icons.storefront_rounded, AppColors.categoryShops),
  _Category('اتحاد الملاك', 'حوكمة واشتراكات', Icons.groups_rounded, AppColors.categoryUnion),
  _Category('عقارات', 'بيع وإيجار بالمنطقة', Icons.home_work_rounded, AppColors.categoryRealEstate),
  _Category('وظائف', 'شواغر قريبة منك', Icons.work_rounded, AppColors.categoryJobs),
  _Category('الصيانة والخدمات', 'فنيين وضمان معتمد', Icons.build_rounded, AppColors.categoryMaintenance),
  _Category('طوارئ SOS', 'الجيران 24/7 و122', Icons.warning_rounded, AppColors.categorySos),
  _Category('المفقودات والأمانات', 'مطابقة سرية تامة', Icons.search_rounded, AppColors.categoryLostFound),
  _Category('تدوير وتوفير', 'لدعم صندوق العمارة', Icons.autorenew_rounded, AppColors.categoryRecycling),
];

/// The pre-login / guest landing screen — matches design/screens/01_home_guest.png.
class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NewsBanner(),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'أقسام الحي والخدمات', trailing: '(شبكة 3×3)'),
                  const SizedBox(height: 12),
                  _CategoryGrid(),
                  const SizedBox(height: 28),
                  _SectionHeader(title: 'خدمات سريعة ومرافق', trailing: 'الكل'),
                  const SizedBox(height: 12),
                  _QuickServicesRow(),
                  const SizedBox(height: 28),
                  _SectionHeader(title: 'معروضات الحي والقريب منك', trailing: 'عرض الكل'),
                  const SizedBox(height: 4),
                  const Text('سلع من جيرانك في نطاق 500 متر',
                      style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                  const SizedBox(height: 12),
                  _ListingCard(
                    tag: 'مستعمل',
                    title: 'شاشة سامسونج 4K بوصة 55',
                    subtitle: 'عمارة 14 - التجمع الخامس (على بعد 120م)',
                    price: '8,500 ج.م',
                  ),
                  const SizedBox(height: 12),
                  _ListingCard(
                    tag: 'إيجار شهري',
                    title: 'متاح حجز جراج خاص للسيارات',
                    subtitle: 'بدروم العمارة 22 - حراسة 24 ساعة',
                    price: '1,200 ج.م/شهر',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _SignupCta(),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.navy, Color(0xFF1B3A63)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_outline, color: Colors.white, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('وضع الاستكشاف كزائر',
                        style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w500)),
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 6, color: AppColors.gold),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
                  ),
                  Positioned(
                    top: -2,
                    left: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: CustomPaint(painter: _LogoPainter()),
          ),
          const SizedBox(height: 12),
          Text('مُجتمعي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 4),
          const Text('إدارة اتحاد الملاك والحي... أسهل وأذكى',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                const Icon(Icons.expand_more_rounded, color: Colors.white70, size: 18),
                const Spacer(),
                const Text('استكشف عقارك: القاهرة الجديدة / التجمع الخامس',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Minimal recreation of the mُجتمعي icon (house + three neighbors).
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * s
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(100 * s, 42 * s)
      ..lineTo(150 * s, 84 * s)
      ..lineTo(150 * s, 152 * s)
      ..lineTo(50 * s, 152 * s)
      ..lineTo(50 * s, 84 * s)
      ..close();
    canvas.drawPath(path, stroke);

    void person(double cx, Color color, double headR, double top, double bottom) {
      final fill = Paint()..color = color;
      canvas.drawCircle(Offset(cx * s, top * s), headR * s, fill);
      final body = Path()
        ..moveTo((cx - headR) * s, bottom * s)
        ..lineTo((cx - headR) * s, (top + headR + 6) * s)
        ..quadraticBezierTo(cx * s, (top + headR - 5) * s, (cx + headR) * s, (top + headR + 6) * s)
        ..lineTo((cx + headR) * s, bottom * s)
        ..close();
      canvas.drawPath(body, fill);
    }

    person(76, const Color(0xFF2E7FD6), 9, 112, 142);
    person(100, const Color(0xFF189E6C), 11, 100, 145);
    person(124, const Color(0xFFE8912B), 9, 112, 142);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NewsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                      child: const Text('جديد', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    const Text('آخر الأخبار والتحديثات',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('تم الانتهاء من صيانة المضخات، وبدء مبادرة التدوير للأسبوع...',
                    style: TextStyle(color: AppColors.inkMuted, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.trailing});
  final String title, trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(trailing, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final c = _categories[i];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => switch (c.label) {
              'سوق المستعمل' => const MarketplaceListingScreen(),
              'اتحاد الملاك' => const UnionFeedScreen(),
              'الصيانة والخدمات' => const TechniciansMarketScreen(),
              'المحلات' => const NeighborhoodShopsScreen(),
              'طوارئ SOS' => const SosEmergencyScreen(),
              'المفقودات والأمانات' => const LostFoundHubScreen(),
              'تدوير وتوفير' => const RecyclingMarketplaceScreen(),
              'وظائف' => const JobsBoardScreen(),
              _ => PlaceholderScreen(title: c.label),
            },
          )),
          child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: c.color, borderRadius: BorderRadius.circular(12)),
                child: Icon(c.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 8),
              Text(c.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(c.sublabel,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
          ),
        );
      },
    );
  }
}

class _QuickServicesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('الأمن والحراسة', Icons.security_rounded),
      ('خدمات النظافة', Icons.cleaning_services_rounded),
      ('صيانة عامة', Icons.handyman_rounded),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (label, icon) = items[i];
          return Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.gold, size: 22),
                const Spacer(),
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.tag, required this.title, required this.subtitle, required this.price});
  final String tag, title, subtitle, price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.image_outlined, color: AppColors.inkMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(6)),
                  child: Text(tag, style: const TextStyle(fontSize: 10, color: AppColors.inkSecondary)),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SignupCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FindBuildingScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('تسجيل الدخول أو فتح حساب جديد للعمارة'),
          ),
        ),
      ),
    );
  }
}
