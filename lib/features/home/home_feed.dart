import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/routing/app_router.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
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
                  : Image.network(images.first, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.nightMid)),
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

/// Stores that opened online most recently.
class NewStoresRail extends StatefulWidget {
  const NewStoresRail({super.key});

  @override
  State<NewStoresRail> createState() => _NewStoresRailState();
}

class _NewStoresRailState extends State<NewStoresRail> {
  List<Map<String, dynamic>> _shops = const [];

  @override
  void initState() {
    super.initState();
    _load();
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

  @override
  Widget build(BuildContext context) {
    if (_shops.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const _RailHeader('متاجر الحي أونلاين', subtitle: 'اطلب من محلات منطقتك والدفع عند الاستلام'),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _shops.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final s = _shops[i];
              final logo = s['logo_url'] as String?;
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.push('/s/${s['slug']}'),
                child: Container(
                  width: 112,
                  padding: const EdgeInsets.all(10),
                  decoration: _glass(),
                  child: Column(children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.nightMid,
                      backgroundImage: logo == null ? null : NetworkImage(logo),
                      child: logo == null ? const Icon(Icons.storefront_rounded, color: AppColors.gold) : null,
                    ),
                    const SizedBox(height: 8),
                    Text(s['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                    Text(s['category'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white54, fontSize: 10.5)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
