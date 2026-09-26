import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/notifications/notifications_service.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_logo.dart';
import '../auth/auth_landing_screen.dart';
import '../jobs/jobs_board_screen.dart';
import '../lost_found/lost_found_hub_screen.dart';
import '../marketplace/item_details_screen.dart';
import '../marketplace/marketplace_listing_screen.dart';
import '../neighborhood/neighborhood_list_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../real_estate/real_estate_marketplace_screen.dart';
import '../recycling/recycling_marketplace_screen.dart';
import '../services/technicians_market_screen.dart';
import '../shared/placeholder_screen.dart';
import '../shops/neighborhood_shops_screen.dart';
import '../sos/sos_emergency_screen.dart';
import '../union/find_building_screen.dart';
import '../union/union_dashboard_screen.dart';

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
                    onTrailingTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceListingScreen())),
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/building_header.png',
            fit: BoxFit.fitHeight,
            repeat: ImageRepeat.repeatX,
            alignment: Alignment.topCenter,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navy.withValues(alpha: 0.35),
                  AppColors.navy.withValues(alpha: 0.72),
                  const Color(0xFF1B3A63).withValues(alpha: 0.88),
                ],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
          child: Column(
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AuthService.isSignedIn ? const ProfileScreen() : const AuthLandingScreen(),
                )),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_outline, color: Colors.white, size: 20),
                ),
              ),
              StreamBuilder<AuthState>(
                stream: AuthService.authStateChanges,
                builder: (context, snapshot) {
                  final signedIn = AuthService.isSignedIn;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(signedIn ? 'أهلاً بعودتك' : 'وضع الاستكشاف كزائر',
                            style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 6),
                        Icon(signedIn ? Icons.verified_rounded : Icons.circle, size: signedIn ? 13 : 6, color: AppColors.gold),
                      ],
                    ),
                  );
                },
              ),
              const _NotificationBell(),
            ],
          ),
          const SizedBox(height: 20),
          const MogtamayLogo(size: 72),
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
          const _ExploreLocationBox(),
            ],
          ),
        ),
      ],
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
    final count = await NotificationsService.fetchUnreadCount();
    if (!mounted) return;
    setState(() => _unread = count);
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
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
          ),
          if (_unread > 0)
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
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FindBuildingScreen())),
      child: Container(
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
            if (_locating)
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70))
            else
              Text(_resolvedArea != null ? 'استكشف عقارك: $_resolvedArea' : 'استكشف عقارك: حدد موقعك',
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(width: 8),
            const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 18),
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
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => switch (c.label) {
              'سوق المستعمل' => const MarketplaceListingScreen(),
              'اتحاد الملاك' => const UnionDashboardScreen(),
              'الصيانة والخدمات' => const TechniciansMarketScreen(),
              'المحلات' => const NeighborhoodShopsScreen(),
              'طوارئ SOS' => const SosEmergencyScreen(),
              'المفقودات والأمانات' => const LostFoundHubScreen(),
              'تدوير وتوفير' => const RecyclingMarketplaceScreen(),
              'وظائف' => const JobsBoardScreen(),
              'عقارات' => const RealEstateMarketplaceScreen(),
              _ => PlaceholderScreen(title: c.label),
            },
          )),
          child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
    final items = [
      ('صيانة عامة', Icons.handyman_rounded, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TechniciansMarketScreen()))),
      ('جروب الحي', Icons.location_city_rounded, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NeighborhoodListScreen()))),
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MarketplaceListingScreen()));
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
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => signedIn ? const FindBuildingScreen() : const AuthLandingScreen(),
                )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: Icon(signedIn ? Icons.groups_rounded : Icons.login_rounded, size: 18),
                label: Text(signedIn ? 'ابحث عن عمارتك وانضم لاتحاد الملاك' : 'تسجيل الدخول أو فتح حساب جديد للعمارة'),
              ),
            ),
          ),
        );
      },
    );
  }
}
