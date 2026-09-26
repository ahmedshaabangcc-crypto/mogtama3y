import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/contact_phones.dart';
import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_listing_screen.dart';
import 'item_details_screen.dart';

const _conditionLabels = {
  'new': 'جديد',
  'like_new': 'شبه جديد (كالجديد)',
  'light_use': 'استعمال خفيف',
  'used': 'بحالة متوسطة',
  'heavy_use': 'استعمال كثيف',
};

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
  return 'منذ ${(diff.inDays / 30).floor()} شهر';
}

/// Marketplace browsing screen — matches design/screens/03_marketplace_listing.png,
/// now reading real active `marketplace_listings` rows.
class MarketplaceListingScreen extends StatefulWidget {
  const MarketplaceListingScreen({super.key});

  @override
  State<MarketplaceListingScreen> createState() => _MarketplaceListingScreenState();
}

class _MarketplaceListingScreenState extends State<MarketplaceListingScreen> {
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _listings = [];
  String _query = '';

  // Client-side search over the loaded listings (title + description).
  List<Map<String, dynamic>> get _visibleListings {
    if (_query.isEmpty) return _listings;
    final q = _query.toLowerCase();
    return _listings.where((l) {
      final text = '${l['title'] ?? ''} ${l['description'] ?? ''}'.toLowerCase();
      return text.contains(q);
    }).toList();
  }

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
      final rows = await Supabase.instance.client
          .from('marketplace_listings')
          .select('*, seller:profiles(full_name, is_verified)')
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(30);
      final listings = List<Map<String, dynamic>>.from(rows as List);
      // Only sellers whose listing shows the number come back from the RPC.
      await ContactPhones.attach(
        listings.where((l) => l['hide_phone_number'] != true).toList(),
        userIdKey: 'seller_id',
        profileKey: 'seller',
      );

      final membership = await UnionService.fetchMyMembership();
      final myBuildingId = membership?['building_id'] as String?;
      final visible = myBuildingId == null
          ? listings
          : listings.where((l) => !(l['hide_from_own_building'] == true && l['building_id'] == myBuildingId)).toList();

      if (!mounted) return;
      setState(() {
        _listings = AdTokenService.sortFeaturedFirst(visible);
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

  void _addListing() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AuthService.isSignedIn ? const AddListingScreen() : const AuthLandingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('سوق المستعمل'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(Icons.storefront_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'ابحث في عناوين ووصف الإعلانات...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                filled: true,
                fillColor: AppColors.surface,
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('أحدث المعروضات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const Spacer(),
                Text('${_visibleListings.length} إعلان نشط', style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_loadError)
              LoadErrorView(onRetry: _load)
            else if (_visibleListings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: AppColors.inkMuted, size: 36),
                    const SizedBox(height: 10),
                    Text(_query.isEmpty ? 'لا توجد إعلانات بعد' : 'لا توجد نتائج لبحثك', style: const TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                    if (_query.isEmpty) ...[
                      const SizedBox(height: 4),
                      const Text('كن أول من ينشر إعلاناً في السوق!', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                    ],
                  ],
                ),
              )
            else
              for (final l in _visibleListings) ...[
                _ListingCard(listing: l),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addListing,
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('أضف إعلان مستعمل جديد'),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.listing});
  final Map<String, dynamic> listing;

  @override
  Widget build(BuildContext context) {
    final title = listing['title'] as String? ?? '';
    final price = (listing['price'] as num?)?.toDouble() ?? 0;
    final condition = listing['condition'] as String? ?? 'used';
    final images = (listing['images'] as List?)?.cast<String>() ?? const [];
    final createdAt = DateTime.tryParse(listing['created_at'] as String? ?? '') ?? DateTime.now();
    final sellerProfile = listing['seller'] as Map<String, dynamic>?;
    final sellerName = sellerProfile?['full_name'] as String? ?? 'عضو مُجتمعي';
    final sellerVerified = sellerProfile?['is_verified'] as bool? ?? false;
    final isFeatured = AdTokenService.isCurrentlyFeatured(listing);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailsScreen(listing: listing))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                images.isEmpty
                    ? Container(
                        height: 150,
                        color: AppColors.surfaceAlt,
                        child: const Center(child: Icon(Icons.image_outlined, color: AppColors.inkMuted, size: 32)),
                      )
                    : Image.network(
                        images.first,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 150,
                          color: AppColors.surfaceAlt,
                          child: const Center(child: Icon(Icons.image_outlined, color: AppColors.inkMuted, size: 32)),
                        ),
                      ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (sellerVerified) ...[
                          const Icon(Icons.verified_rounded, color: AppColors.teal, size: 13),
                          const SizedBox(width: 3),
                        ],
                        Text(sellerName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                    child: Text(_conditionLabels[condition] ?? condition, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
                if (isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.local_fire_department_rounded, size: 12, color: Colors.white),
                        SizedBox(width: 3),
                        Text('مميز', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(title,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, height: 1.4)),
                      ),
                      const SizedBox(width: 8),
                      Text('${NumberFormat('#,##0').format(price)} ج.م', style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 13, color: AppColors.inkMuted),
                      const SizedBox(width: 3),
                      Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
