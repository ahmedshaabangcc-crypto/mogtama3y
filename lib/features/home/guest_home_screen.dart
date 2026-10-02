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
  const _Category(this.label, this.sublabel, this.image);
  final String label;
  final String sublabel;
  final String image;
}

const _img = 'assets/images/home';
const _categories = [
  _Category('سوق المستعمل', 'سلع من الجيران', '$_img/used_market.jpg'),
  _Category('المحلات', 'محلات ومتاجر الحي', '$_img/shops.jpg'),
  _Category('اتحاد الملاك', 'حوكمة واشتراكات', '$_img/union.jpg'),
  _Category('عقارات', 'بيع وإيجار بالمنطقة', '$_img/real_estate.jpg'),
  _Category('وظائف', 'شواغر قريبة منك', '$_img/jobs.jpg'),
  _Category('الصيانة والخدمات', 'فنيين وحجز بضمان', '$_img/maintenance.jpg'),
  _Category('طوارئ SOS', 'تنبيه الجيران والطوارئ', '$_img/sos.jpg'),
  _Category('المفقودات والأمانات', 'مفقود أو موجود', '$_img/lost_found.jpg'),
  _Category('تدوير وتوفير', 'مزادات الخردة والتدوير', '$_img/recycling.jpg'),
];

/// Frosted-glass panel used across the night-styled home.
BoxDecoration _glass({double radius = 22}) => BoxDecoration(
      color: AppColors.glass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.glassBorder),
    );

/// The pre-login / guest landing screen — matches design/screens/01_home_guest.png.
class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.night,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
        // Hero artwork, fading into the night canvas at the bottom.
        Positioned.fill(
          bottom: 70,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0.0, 0.62, 1.0],
            ).createShader(rect),
            child: Image.asset('$_img/hero.jpg', fit: BoxFit.cover, alignment: const Alignment(-0.35, 0)),
          ),
        ),
        // Darken the text side so the headline stays readable.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [AppColors.night.withValues(alpha: 0.75), AppColors.night.withValues(alpha: 0.05)],
              ),
            ),
          ),
        ),
        Padding(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    decoration: _glass(radius: 100).copyWith(color: AppColors.night.withValues(alpha: 0.45)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(signedIn ? Icons.verified_rounded : Icons.circle, size: signedIn ? 14 : 7, color: AppColors.gold),
                        const SizedBox(width: 6),
                        Text(signedIn ? 'أهلاً بعودتك' : 'بتستكشف كزائر',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                },
              ),
              const _NotificationBell(),
            ],
          ),
          const SizedBox(height: 70),
          Row(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8))],
              ),
              child: const MogtamayLogo(size: 46),
            ),
            const SizedBox(width: 12),
            Text('مُجتمعي',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 34, shadows: const [Shadow(color: Colors.black54, blurRadius: 16)])),
          ]),
          const SizedBox(height: 8),
          const Text('كل حيّك في تطبيق واحد',
              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700, shadows: [Shadow(color: Colors.black54, blurRadius: 12)])),
          const SizedBox(height: 4),
          const Text('اتحاد الملاك، المحلات، الصيانة والجيران… أسهل وأذكى',
              style: TextStyle(color: Colors.white70, fontSize: 12.5, shadows: [Shadow(color: Colors.black54, blurRadius: 10)])),
          const SizedBox(height: 22),
          const _ExploreLocationBox(),
        ],
      ),
        ),
      ],
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
        decoration: BoxDecoration(color: AppColors.night.withValues(alpha: 0.45), shape: BoxShape.circle, border: Border.all(color: AppColors.glassBorder)),
        child: Icon(icon, color: Colors.white, size: 20),
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
            decoration: BoxDecoration(color: AppColors.night.withValues(alpha: 0.45), shape: BoxShape.circle, border: Border.all(color: AppColors.glassBorder)),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
          ),
          if (_unread > 0)
            Positioned(
              top: -2,
              left: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
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
        decoration: _glass(radius: 18).copyWith(color: AppColors.night.withValues(alpha: 0.55)),
        child: Row(
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 19),
            const SizedBox(width: 8),
            if (_locating)
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
            else
              Text(_resolvedArea != null ? 'استكشف عقارك: $_resolvedArea' : 'استكشف عقارك: حدد موقعك',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.expand_more_rounded, color: Colors.white60, size: 18),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        if (trailing != null)
          InkWell(
            onTap: onTrailingTap,
            child: Text(trailing!, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700)),
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
        childAspectRatio: 0.74,
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
            clipBehavior: Clip.antiAlias,
            decoration: _glass().copyWith(
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                Expanded(child: Image.asset(c.image, fit: BoxFit.cover, width: double.infinity)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 7, 6, 9),
                  child: Column(children: [
                    Text(c.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 1),
                    Text(c.sublabel,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9.5, color: Colors.white60)),
                  ]),
                ),
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
      ('عنوانك الإلكتروني', Icons.qr_code_2_rounded, () => context.go(AppRoutes.myAddress)),
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
              decoration: _glass(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AppColors.gold, size: 24),
                  const Spacer(),
                  Text(label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.25, fontWeight: FontWeight.w800)),
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
          decoration: _glass(radius: 18),
          child: Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.gold),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    AuthService.isSignedIn ? 'لا توجد معروضات بعد — كن أول من ينشر إعلاناً في سوق المستعمل' : 'سجّل الدخول لتصفح معروضات جيرانك في سوق المستعمل',
                    style: const TextStyle(fontSize: 12, color: Colors.white70)),
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
        decoration: _glass(radius: 18),
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
                  Text(listing['title'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(sellerName, style: const TextStyle(fontSize: 11, color: Colors.white60)),
                ],
              ),
            ),
            Text('${NumberFormat('#,##0').format(price)} ج.م', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
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
        return ColoredBox(
          color: AppColors.night,
          child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Material(
              color: Colors.transparent,
              child: Ink(
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: AppColors.crystalLight.withValues(alpha: 0.35), blurRadius: 22, offset: const Offset(0, 10))],
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
          ),
        );
      },
    );
  }
}
