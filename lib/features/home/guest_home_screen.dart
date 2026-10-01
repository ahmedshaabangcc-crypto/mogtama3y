import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/notifications/notifications_service.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_logo.dart';
import '../auth/auth_landing_screen.dart';
import '../marketplace/item_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../union/find_building_screen.dart';

class _Category {
  const _Category(this.label, this.sublabel, this.icon, this.color);
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
}

const _categories = [
  _Category('سوق المستعمل', 'سلع من الجيران', Icons.shopping_bag_rounded, AppColors.categoryUsedMarket),
  _Category('المحلات', 'محلات ومتاجر الحي', Icons.storefront_rounded, AppColors.categoryShops),
  _Category('اتحاد الملاك', 'حوكمة واشتراكات', Icons.groups_rounded, AppColors.categoryUnion),
  _Category('عقارات', 'بيع وإيجار بالمنطقة', Icons.home_work_rounded, AppColors.categoryRealEstate),
  _Category('وظائف', 'شواغر قريبة منك', Icons.work_rounded, AppColors.categoryJobs),
  _Category('الصيانة والخدمات', 'فنيين وحجز بضمان', Icons.build_rounded, AppColors.categoryMaintenance),
  _Category('طوارئ SOS', 'تنبيه الجيران والطوارئ', Icons.warning_rounded, AppColors.categorySos),
  _Category('المفقودات والأمانات', 'مفقود أو موجود', Icons.search_rounded, AppColors.categoryLostFound),
  _Category('تدوير وتوفير', 'مزادات الخردة والتدوير', Icons.autorenew_rounded, AppColors.categoryRecycling),
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
                  const _SectionHeader(title: 'أقسام الحي والخدمات'),
                  const SizedBox(height: 12),
                  _CategoryGrid(),
                  const SizedBox(height: 28),
                  const _SectionHeader(title: 'خدمات سريعة'),
                  const SizedBox(height: 12),
                  _QuickServicesRow(),
                  const SizedBox(height: 28),
                  _SectionHeader(
                    title: 'أحدث معروضات السوق',
                    trailing: 'عرض الكل',
                    onTrailingTap: () => context.go(AppRoutes.marketplace),
                  ),
                  const SizedBox(height: 12),
                  const _LatestListings(),
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
      decoration: const BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(
                icon: Icons.person_outline_rounded,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AuthService.isSignedIn ? const ProfileScreen() : const AuthLandingScreen(),
                )),
              ),
              StreamBuilder<AuthState>(
                stream: AuthService.authStateChanges,
                builder: (context, snapshot) {
                  final signedIn = AuthService.isSignedIn;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(signedIn ? Icons.verified_rounded : Icons.circle, size: signedIn ? 14 : 7, color: signedIn ? AppColors.apexBlue : AppColors.apexPink),
                        const SizedBox(width: 6),
                        Text(signedIn ? 'أهلاً بعودتك' : 'بتستكشف كزائر',
                            style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                },
              ),
              const _NotificationBell(),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppColors.apexPurple.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 12))],
            ),
            child: const MogtamayLogo(size: 76),
          ),
          const SizedBox(height: 14),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) => AppColors.brandGradient.createShader(Rect.fromLTWH(0, 0, rect.width, rect.height)),
            child: Text('مُجتمعي', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 32)),
          ),
          const SizedBox(height: 4),
          const Text('إدارة اتحاد الملاك والحي… أسهل وأذكى', style: TextStyle(color: AppColors.inkSecondary, fontSize: 13.5)),
          const SizedBox(height: 18),
          const _ExploreLocationBox(),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
        child: Icon(icon, color: AppColors.ink, size: 20),
      ),
    );
  }
}

class _NotificationBell extends StatefulWidget {
  const _NotificationBell();

  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<_NotificationBell> {
  int _unread = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) return;
    try {
      final count = await NotificationsService.fetchUnreadCount();
      if (!mounted) return;
      setState(() => _unread = count);
    } catch (_) {
      // Just a badge — on failure keep the previous count rather than surface an error.
    }
  }

  Future<void> _open() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.notifications_none_rounded, color: AppColors.ink, size: 20),
          ),
          if (_unread > 0)
            Positioned(
              top: -2,
              left: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.apexPink, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExploreLocationBox extends StatefulWidget {
  const _ExploreLocationBox();

  @override
  State<_ExploreLocationBox> createState() => _ExploreLocationBoxState();
}

class _ExploreLocationBoxState extends State<_ExploreLocationBox> {
  String? _resolvedArea;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  Future<void> _detectLocation() async {
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      final area = await PlacesService.resolveAreaLabel(lat: position.latitude, lng: position.longitude);
      if (!mounted || area == null) return;
      setState(() => _resolvedArea = area);
    } catch (_) {
      // Geolocation denied/unavailable — keep the generic label, don't
      // block the box from still being usable.
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FindBuildingScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Icon(Icons.expand_more_rounded, color: AppColors.inkMuted, size: 18),
            const Spacer(),
            if (_locating)
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Text(_resolvedArea != null ? 'استكشف عقارك: $_resolvedArea' : 'استكشف عقارك: حدد موقعك',
                  style: const TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Icon(Icons.location_on_rounded, color: AppColors.apexBlue, size: 19),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing, this.onTrailingTap});
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
        if (trailing != null)
          InkWell(
            onTap: onTrailingTap,
            child: Text(trailing!, style: const TextStyle(color: AppColors.teal, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
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
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.go(switch (c.label) {
            'سوق المستعمل' => AppRoutes.marketplace,
            'اتحاد الملاك' => AppRoutes.union,
            'الصيانة والخدمات' => AppRoutes.technicians,
            'المحلات' => AppRoutes.shops,
            'طوارئ SOS' => AppRoutes.sos,
            'المفقودات والأمانات' => AppRoutes.lostFound,
            'تدوير وتوفير' => AppRoutes.recycling,
            'وظائف' => AppRoutes.jobs,
            'عقارات' => AppRoutes.realEstate,
            _ => '/',
          }),
          child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: c.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                child: Icon(c.icon, color: c.color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(c.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
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
    final items = [
      ('اكتشف حواليك', Icons.near_me_rounded, () => context.go(AppRoutes.nearby)),
      ('صيانة عامة', Icons.handyman_rounded, () => context.go(AppRoutes.technicians)),
      ('جروب الحي', Icons.location_city_rounded, () => context.go(AppRoutes.neighborhoods)),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final (label, icon, onTap) = items[i];
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              width: 128,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: AppColors.apexPurple.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const Spacer(),
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The two newest real active marketplace listings (not sample data).
class _LatestListings extends StatefulWidget {
  const _LatestListings();

  @override
  State<_LatestListings> createState() => _LatestListingsState();
}

class _LatestListingsState extends State<_LatestListings> {
  List<Map<String, dynamic>>? _listings;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await Supabase.instance.client
          .from('marketplace_listings')
          .select('*, seller:profiles(full_name, is_verified)')
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(2);
      if (!mounted) return;
      setState(() => _listings = List<Map<String, dynamic>>.from(rows as List));
    } catch (_) {
      if (!mounted) return;
      setState(() => _listings = []);
    }
  }

  void _openMarketplace() {
    context.go(AppRoutes.marketplace);
  }

  @override
  Widget build(BuildContext context) {
    final listings = _listings;
    if (listings == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    if (listings.isEmpty) {
      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _openMarketplace,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.inkMuted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    AuthService.isSignedIn ? 'لا توجد معروضات بعد — كن أول من ينشر إعلاناً في سوق المستعمل' : 'سجّل الدخول لتصفح معروضات جيرانك في سوق المستعمل',
                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final l in listings) ...[
          _ListingCard(listing: l),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.listing});
  final Map<String, dynamic> listing;

  @override
  Widget build(BuildContext context) {
    final images = (listing['images'] as List?)?.cast<String>() ?? const [];
    final price = (listing['price'] as num?)?.toDouble() ?? 0;
    final sellerName = (listing['seller'] as Map<String, dynamic>?)?['full_name'] as String? ?? 'عضو مُجتمعي';
    final placeholder = Container(
      width: 64,
      height: 64,
      color: AppColors.surfaceAlt,
      child: const Icon(Icons.image_outlined, color: AppColors.inkMuted),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailsScreen(listing: listing))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: images.isEmpty
                  ? placeholder
                  : Image.network(images.first, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing['title'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(sellerName, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Text('${NumberFormat('#,##0').format(price)} ج.م', style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _SignupCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        final signedIn = AuthService.isSignedIn;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Material(
              color: Colors.transparent,
              child: Ink(
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: AppColors.apexPurple.withValues(alpha: 0.35), blurRadius: 22, offset: const Offset(0, 10))],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => signedIn ? const FindBuildingScreen() : const AuthLandingScreen(),
                  )),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(signedIn ? Icons.groups_rounded : Icons.login_rounded, size: 19, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        signedIn ? 'ابحث عن عمارتك وانضم للاتحاد' : 'سجّل دخول أو اعمل حساب',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
