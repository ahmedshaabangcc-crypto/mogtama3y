import 'package:flutter/material.dart';
import '../../core/places/directory_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/routing/app_router.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/location/where.dart';
import '../../core/places/place_images.dart';
import '../store/store_cart.dart';

/// Live content for the home page: offers and new products from the
/// neighbourhood's online stores, newly opened stores, and promo banners.
/// Each rail hides itself while it has nothing to show.

SupabaseClient get _db => Supabase.instance.client;

BoxDecoration _glass({double radius = 18}) => BoxDecoration(
      color: AppColors.glass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.glassBorder),
    );

class _RailHeader extends StatelessWidget {
  const _RailHeader(this.title, {this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.white60)),
      ]),
    );
  }
}

/// Two promo banners: open a store (merchants) and the digital address.
class HomePromoBanners extends StatelessWidget {
  const HomePromoBanners({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = [
      _Banner(
        title: 'عندك محل؟ افتح متجرك أونلاين ببلاش',
        body: 'منتجات جاهزة بالصور، والطلبات توصلك على طول — من غير عمولة.',
        cta: 'افتح متجرك',
        icon: Icons.storefront_rounded,
        colors: const [Color(0xFF8A5A17), Color(0xFF3A2508)],
        onTap: () => launchUrl(Uri.parse(tajerUrl), webOnlyWindowName: '_blank'),
      ),
      _Banner(
        title: 'عنوانك الإلكتروني في كود واحد',
        body: 'ابعت عنوانك للدليفري والأصحاب باسم سهل أو QR بدل الوصف الطويل.',
        cta: 'اعمل عنوانك',
        icon: Icons.qr_code_2_rounded,
        colors: const [Color(0xFF2A4F96), Color(0xFF101D42)],
        onTap: () => context.go(AppRoutes.myAddress),
      ),
    ];
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= 700) {
        return Row(children: [
          Expanded(child: banners[0]),
          const SizedBox(width: 12),
          Expanded(child: banners[1]),
        ]);
      }
      return SizedBox(
        height: 150,
        child: PageView(
          controller: PageController(viewportFraction: 0.92),
          padEnds: false,
          children: [
            for (final b in banners) Padding(padding: const EdgeInsetsDirectional.only(end: 10), child: b),
          ],
        ),
      );
    });
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.title, required this.body, required this.cta, required this.icon, required this.colors, required this.onTap});
  final String title, body, cta;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: colors),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, height: 1.35)),
              const SizedBox(height: 4),
              // Gives way first when the text runs long (big system font).
              Expanded(
                child: Text(body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(100)),
                child: Text(cta, style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w800, fontSize: 12.5)),
              ),
            ]),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 64, color: Colors.white.withValues(alpha: 0.85)),
        ]),
      ),
    );
  }
}

/// Products from the online stores: newest first, or only discounted ones.
class StoreProductsRail extends StatefulWidget {
  const StoreProductsRail({super.key, required this.title, this.subtitle, this.offersOnly = false});
  final String title;
  final String? subtitle;
  final bool offersOnly;

  @override
  State<StoreProductsRail> createState() => _StoreProductsRailState();
}

class _StoreProductsRailState extends State<StoreProductsRail> {
  List<Map<String, dynamic>> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      var q = _db
          .from('shop_products')
          .select('id, name, price, old_price, images, image_url, stock, shop:shops!inner(slug, name)')
          .eq('is_available', true)
          .gt('price', 0)
          .not('shop.slug', 'is', null);
      if (widget.offersOnly) q = q.not('old_price', 'is', null);
      final rows = await q.order('created_at', ascending: false).limit(widget.offersOnly ? 40 : 20);
      var items = List<Map<String, dynamic>>.from(rows as List);
      if (widget.offersOnly) items = items.where((p) => discountLabel(p) != null).take(20).toList();
      if (mounted) setState(() => _items = items);
    } catch (_) {
      // A home rail — hide it on failure rather than show an error.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _RailHeader(widget.title, subtitle: widget.subtitle),
        SizedBox(
          height: 236,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _ProductCard(_items[i]),
          ),
        ),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(this.p);
  final Map<String, dynamic> p;

  @override
  Widget build(BuildContext context) {
    final shop = p['shop'] as Map<String, dynamic>? ?? const {};
    final slug = shop['slug'] as String? ?? '';
    final images = StoreService.imagesOf(p);
    final off = discountLabel(p);
    final old = (p['old_price'] as num?)?.toDouble();
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/s/$slug/p/${p['id']}'),
      child: Container(
        width: 156,
        clipBehavior: Clip.antiAlias,
        decoration: _glass(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(
              width: 156,
              height: 140,
              child: images.isEmpty
                  ? const ColoredBox(color: AppColors.nightMid, child: Icon(Icons.image_outlined, color: Colors.white38))
                  : Image.network(images.first, cacheWidth: 480, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.nightMid)),
            ),
            if (off != null)
              PositionedDirectional(
                top: 8,
                start: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE5484D), borderRadius: BorderRadius.circular(100)),
                  child: Text(off, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Row(children: [
                Text(egp(p['price'] as num), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 13)),
                if (off != null && old != null) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(egp(old), maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white38, fontSize: 11, decoration: TextDecoration.lineThrough)),
                  ),
                ],
              ]),
              const SizedBox(height: 2),
              Text(shop['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// "محلات حواليك": stores registered on مُجتمعي first, then the nearest
/// shops from the Egypt directory (order on WhatsApp). The location is used
/// silently only when already allowed; otherwise a tile asks for it.
class NewStoresRail extends StatefulWidget {
  const NewStoresRail({super.key});

  @override
  State<NewStoresRail> createState() => _NewStoresRailState();
}

class _NewStoresRailState extends State<NewStoresRail> {
  // Directory groups that are shops people order from (not offices, mosques…).
  static const _shopCategories = {
    'سوبر ماركت وبقالة', 'صيدليات', 'مطاعم', 'كافيهات', 'حلويات ومخبوزات', 'ملابس وأزياء',
    'إلكترونيات وموبايلات', 'أدوات منزلية وأثاث', 'تجميل وعناية', 'هدايا ومكتبات', 'محلات متنوعة',
  };

  List<Map<String, dynamic>> _shops = const [];
  List<Map<String, dynamic>> _nearby = const [];
  bool _needsLocation = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _load();
    _loadNearby(ask: false);
  }

  Future<void> _load() async {
    try {
      final rows = await _db
          .from('shops')
          .select('id, name, category, slug, logo_url, cover_image_url')
          .not('slug', 'is', null)
          .order('created_at', ascending: false)
          .limit(16);
      if (mounted) setState(() => _shops = List<Map<String, dynamic>>.from(rows as List));
    } catch (_) {}
  }

  Future<void> _loadNearby({required bool ask}) async {
    try {
      // On a tap, ask the browser for the position directly (that is what
      // shows the prompt; iPhone Safari can't report the permission state).
      // Without a tap, only go ahead when it's known to be allowed.
      if (!ask) {
        final perm = await Geolocator.checkPermission();
        if (perm != LocationPermission.always && perm != LocationPermission.whileInUse) {
          if (mounted) setState(() => _needsLocation = true);
          return;
        }
      }
      if (mounted) setState(() => _locating = true);
      final p = await Where.current();
      var rows = await DirectoryService.nearby(lat: p.latitude, lng: p.longitude, km: 1.5, limit: 120);
      if (rows.where((r) => _shopCategories.contains(r['category'])).length < 8) {
        rows = await DirectoryService.nearby(lat: p.latitude, lng: p.longitude, km: 5, limit: 150);
      }
      final shops = rows.where((r) => _shopCategories.contains(r['category']) && r['claimed_shop_id'] == null).toList()
        // Shops you can order from on WhatsApp first, then by distance.
        ..sort((a, b) {
          final wa = (b['whatsapp'] != null ? 1 : 0) - (a['whatsapp'] != null ? 1 : 0);
          return wa != 0 ? wa : ((a['distance_km'] as num) - (b['distance_km'] as num)).sign.toInt();
        });
      if (mounted) {
        setState(() {
          _nearby = shops.take(20).toList();
          _needsLocation = false;
        });
      }
    } catch (_) {
      // Location off, refused or unknown: offer the "شوف محلات حواليك" tile.
      if (mounted) setState(() => _needsLocation = true);
      if (ask && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('مقدرناش نحدد موقعك — اسمح للموقع من إعدادات المتصفح وجرّب تاني')));
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shops.isEmpty && _nearby.isEmpty && !_needsLocation && !_locating) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Expanded(child: _RailHeader('محلات حواليك', subtitle: 'اطلب من محلات منطقتك على مُجتمعي أو واتساب')),
          TextButton(onPressed: () => context.push(AppRoutes.nearby), child: const Text('الكل', style: TextStyle(color: AppColors.gold))),
        ]),
        SizedBox(
          height: 136,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final s in _shops) ...[_registeredTile(s), const SizedBox(width: 12)],
              if (_locating) const SizedBox(width: 112, child: Center(child: CircularProgressIndicator(color: AppColors.gold))),
              if (_needsLocation) _askLocationTile(),
              for (final p in _nearby) ...[_directoryTile(p), const SizedBox(width: 12)],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _tile({required VoidCallback onTap, required Widget avatar, required String name, required String sub, Widget? badge}) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 116,
        padding: const EdgeInsets.all(10),
        decoration: _glass(),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [avatar, if (badge != null) Positioned(bottom: -4, left: -6, child: badge)]),
          const SizedBox(height: 8),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10.5)),
        ]),
      ),
    );
  }

  Widget _registeredTile(Map<String, dynamic> s) {
    final logo = s['logo_url'] as String?;
    return _tile(
      onTap: () => context.push('/s/${s['slug']}'),
      avatar: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.nightMid,
        backgroundImage: logo == null ? null : ResizeImage(NetworkImage(logo), width: 160),
        child: logo == null ? const Icon(Icons.storefront_rounded, color: AppColors.gold) : null,
      ),
      name: s['name'] as String? ?? '',
      sub: s['category'] as String? ?? '',
      badge: _badge('متجر', AppColors.gold, AppColors.night),
    );
  }

  Widget _directoryTile(Map<String, dynamic> p) {
    final km = (p['distance_km'] as num?)?.toDouble();
    final dist = km == null ? '' : (km < 1 ? '${(km * 1000).round()} م' : '${km.toStringAsFixed(1)} كم');
    return _tile(
      onTap: () => context.push('/d/${p['id']}'),
      avatar: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.nightMid,
        backgroundImage: placeImage(p['category'] as String?),
        child: placeImage(p['category'] as String?) == null ? const Icon(Icons.store_mall_directory_rounded, color: Colors.white70) : null,
      ),
      name: p['name'] as String? ?? '',
      sub: [p['category'], dist].where((x) => x != null && '$x'.isNotEmpty).join(' · '),
      badge: p['whatsapp'] != null ? _badge('اطلب', const Color(0xFF1FA855), Colors.white) : null,
    );
  }

  Widget _askLocationTile() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: _tile(
        onTap: () => _loadNearby(ask: true),
        avatar: const CircleAvatar(radius: 30, backgroundColor: AppColors.gold, child: Icon(Icons.my_location_rounded, color: AppColors.night)),
        name: 'شوف محلات حواليك',
        sub: 'فعّل الموقع',
      ),
    );
  }

  Widget _badge(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
        child: Text(text, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w800)),
      );
}

/// "بلّغ عن مشكلة في حيّك" — the community-reports entry on the home page.
class ReportCallout extends StatelessWidget {
  const ReportCallout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF8E1F2B), Color(0xFF3A0B12)]),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('شايف مشكلة في حيّك؟', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('زبالة، حفر، إشغالات، مخالفة خطرة… صوّرها وبلّغ، وإحنا نوصّلها للجهة المختصة ونتابع.',
                style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.5)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.newReport),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, visualDensity: VisualDensity.compact),
                icon: const Icon(Icons.campaign_rounded, size: 18),
                label: const Text('بلّغ دلوقتي', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              OutlinedButton(
                onPressed: () => context.push(AppRoutes.reports),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38), visualDensity: VisualDensity.compact),
                child: const Text('بلاغات حيّك'),
              ),
            ]),
          ]),
        ),
        const SizedBox(width: 8),
        Icon(Icons.campaign_rounded, size: 60, color: Colors.white.withValues(alpha: 0.85)),
      ]),
    );
  }
}
