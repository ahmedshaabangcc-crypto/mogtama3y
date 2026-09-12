import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
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
  List<Map<String, dynamic>> _listings = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await Supabase.instance.client
        .from('marketplace_listings')
        .select('*, seller:profiles(full_name, is_verified)')
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(30);
    final listings = List<Map<String, dynamic>>.from(rows as List);

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
            const _SearchBar(),
            const SizedBox(height: 12),
            const _FilterChips(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('أحدث المعروضات في حيك السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const Spacer(),
                Text('${_listings.length} إعلان نشط', style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_listings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: AppColors.inkMuted, size: 36),
                    const SizedBox(height: 10),
                    const Text('لا توجد إعلانات بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('كن أول من ينشر إعلاناً في السوق!', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                  ],
                ),
              )
            else
              for (final l in _listings) ...[
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.tune_rounded, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                SizedBox(width: 8),
                Text('ابحث عن أثاث، إلكترونيات، سيارات، أدوات...',
                    style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الأقرب لموقعي أولاً', 'الكل', 'هواتف وإلكترونيات', 'أجهزة كهربائية', 'أثاث ومنزل'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.teal : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.teal : AppColors.border),
            ),
            child: Text(chips[i],
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? Colors.white : AppColors.inkSecondary,
                  fontWeight: FontWeight.w500,
                )),
          );
        },
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
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                            label: const Text('محادثة فورية', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.share_outlined, size: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
