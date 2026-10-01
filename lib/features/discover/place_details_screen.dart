import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maps/maps_launcher.dart';
import '../../core/places/places_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import '../shops/claim_business_hub_screen.dart';

/// One business from "اكتشف حواليك": photos, rating, hours, call,
/// directions, its own online store (website) or مُجتمعي store, and
/// "هل هذا نشاطك؟" for the owner.
class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.placeId, required this.name});
  final String placeId;
  final String name;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool _loading = true;
  bool _loadError = false;
  Map<String, dynamic>? _place;
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final place = await PlacesService.placeDetails(widget.placeId);
      if (!mounted) return;
      setState(() {
        _place = place;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  Future<void> _claim() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    setState(() => _claiming = true);
    try {
      final shop = await PlacesService.ensureShopForPlace(widget.placeId);
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClaimBusinessHubScreen(shop: shop)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = _place;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(widget.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError || place == null
              ? LoadErrorView(onRetry: _load)
              : ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    if ((place['photos'] as List).isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: PageView(
                          children: [
                            for (final url in (place['photos'] as List).cast<String>())
                              Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: AppColors.surfaceAlt)),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Text(place['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
                        if ((place['type'] as String?)?.isNotEmpty == true)
                          Text(place['type'] as String, style: const TextStyle(color: AppColors.inkMuted)),
                        const SizedBox(height: 6),
                        Wrap(spacing: 12, children: [
                          if (place['rating'] != null)
                            Text('★ ${(place['rating'] as num).toStringAsFixed(1)} (${place['rating_count']} تقييم)', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                          if (place['open_now'] != null)
                            Text(place['open_now'] == true ? 'مفتوح الآن' : 'مغلق الآن',
                                style: TextStyle(color: place['open_now'] == true ? AppColors.teal : AppColors.categorySos, fontWeight: FontWeight.w700)),
                        ]),
                        if ((place['address'] as String?)?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Text(place['address'] as String, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.5)),
                        ],
                        const SizedBox(height: 16),
                        if (place['store_slug'] != null) ...[
                          ElevatedButton.icon(
                            onPressed: () => context.go(AppRoutes.store(place['store_slug'] as String)),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(48)),
                            icon: const Icon(Icons.storefront_rounded),
                            label: const Text('اطلب من متجره على مُجتمعي'),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (place['website'] != null) ...[
                          OutlinedButton.icon(
                            onPressed: () => launchUrl(Uri.parse(place['website'] as String), mode: LaunchMode.externalApplication),
                            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
                            icon: const Icon(Icons.shopping_bag_outlined),
                            label: const Text('تسوّق من متجره / موقعه'),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Row(children: [
                          if (place['phone'] != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => launchUrl(Uri.parse('tel:${(place['phone'] as String).replaceAll(' ', '')}')),
                                icon: const Icon(Icons.call_rounded, size: 18),
                                label: const Text('اتصال'),
                              ),
                            ),
                          if (place['phone'] != null) const SizedBox(width: 10),
                          if (place['lat'] != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => openDirections(lat: (place['lat'] as num).toDouble(), lng: (place['lng'] as num).toDouble()),
                                icon: const Icon(Icons.directions_rounded, size: 18),
                                label: const Text('الاتجاهات'),
                              ),
                            ),
                        ]),
                        if ((place['hours'] as List).isNotEmpty) ...[
                          const SizedBox(height: 18),
                          const Text('مواعيد العمل', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          for (final line in (place['hours'] as List).cast<String>())
                            Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(line, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary))),
                        ],
                        if (place['is_claimed'] != true) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              const Text('هل هذا نشاطك؟', style: TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              const Text('اطلب ملكية الصفحة، وبعد التوثيق تقدر تضيف منتجاتك وتستقبل طلبات من جيرانك ببلاش.',
                                  style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6)),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: _claiming ? null : _claim,
                                child: _claiming ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('اطلب ملكية النشاط'),
                              ),
                            ]),
                          ),
                        ],
                        const SizedBox(height: 14),
                        const Text('البيانات والصور من خرائط Google.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ]),
                    ),
                  ],
                ),
    );
  }
}
