import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'item_details_screen.dart';

class _Listing {
  const _Listing({
    required this.seller,
    required this.condition,
    required this.title,
    required this.price,
    required this.distance,
    required this.time,
    required this.location,
  });
  final String seller, condition, title, price, distance, time, location;
}

const _listings = [
  _Listing(
    seller: 'بائع موثّق • د. أحمد',
    condition: 'حالة ممتازة كالجديد',
    title: 'صالون زاوية L-Shape مودرن تركي مع طاولة قهوة',
    price: '8,500 ج.م',
    distance: '400 متر',
    time: 'منذ ساعتين',
    location: 'الشيخ زايد (كمبوند الياسمين)',
  ),
  _Listing(
    seller: 'بائع موثّق • م. كريم',
    condition: 'استعمال خفيف • مع الضمان',
    title: 'ماكينة قهوة ديلونجي ديديكا مع مطحنة احترافية',
    price: '4,200 ج.م',
    distance: '1.2 كم',
    time: 'أمس',
    location: 'التجمع الخامس (الرحاب)',
  ),
  _Listing(
    seller: 'بائع موثّق • سارة م.',
    condition: 'بحالة الوكالة',
    title: 'دراجة رياضية ترينكس مقاس 26 مع خوذة وإضاءة ليلية',
    price: '3,100 ج.م',
    distance: '850 متر',
    time: 'منذ 4 ساعات',
    location: 'المعادي (دجلة)',
  ),
];

/// Marketplace browsing screen — matches design/screens/03_marketplace_listing.png.
class MarketplaceListingScreen extends StatelessWidget {
  const MarketplaceListingScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          _SearchBar(),
          const SizedBox(height: 12),
          _FilterChips(),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('أحدث المعروضات في حيك السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Spacer(),
              Text('448 إعلان قريب', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          for (final l in _listings) ...[
            _ListingCard(listing: l),
            const SizedBox(height: 14),
          ],
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('أضف إعلان مستعمل جديد'),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
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
  final _Listing listing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ItemDetailsScreen())),
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
              Container(
                height: 150,
                color: AppColors.surfaceAlt,
                child: const Center(child: Icon(Icons.image_outlined, color: AppColors.inkMuted, size: 32)),
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
                      const Icon(Icons.verified_rounded, color: AppColors.teal, size: 13),
                      const SizedBox(width: 3),
                      Text(listing.seller, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, size: 15),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                  child: Text(listing.condition, style: const TextStyle(color: Colors.white, fontSize: 10)),
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
                      child: Text(listing.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, height: 1.4)),
                    ),
                    const SizedBox(width: 8),
                    Text(listing.price, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.inkMuted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text('يبعد ${listing.distance} • ${listing.location}',
                          style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Icon(Icons.access_time_rounded, size: 13, color: AppColors.inkMuted),
                    const SizedBox(width: 3),
                    Text(listing.time, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
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
