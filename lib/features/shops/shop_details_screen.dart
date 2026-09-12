import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'claim_business_hub_screen.dart';

/// Real shop details page — previously tapping a shop card did nothing
/// at all (only the "claim" button on the card worked). Shows the real
/// imported/claimed fields; no fake reviews or product list are
/// fabricated since `shop_products` isn't wired to anything yet.
class ShopDetailsScreen extends StatelessWidget {
  const ShopDetailsScreen({super.key, required this.shop});
  final Map<String, dynamic> shop;

  @override
  Widget build(BuildContext context) {
    final name = shop['name'] as String? ?? '';
    final category = shop['category'] as String? ?? 'محل تجاري';
    final description = shop['description'] as String?;
    final address = shop['address'] as String?;
    final rating = (shop['rating'] as num?)?.toDouble();
    final ratingCount = shop['rating_count'] as int?;
    final isClaimed = shop['is_claimed'] as bool? ?? false;
    final source = shop['source'] as String?;
    final coverImageUrl = shop['cover_image_url'] as String?;
    final discountPct = (shop['discount_pct_for_verified_residents'] as num?)?.toDouble();
    final deliveryRadius = shop['delivery_radius_m'] as int?;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(name)),
      body: ListView(
        children: [
          coverImageUrl != null
              ? Image.network(
                  coverImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(height: 200, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.storefront_rounded, size: 48, color: AppColors.inkMuted))),
                )
              : Container(height: 200, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.storefront_rounded, size: 48, color: AppColors.inkMuted))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                  if (isClaimed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                        SizedBox(width: 3),
                        Text('محل موثّق', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                ]),
                const SizedBox(height: 4),
                Text(category, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
                if (rating != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('$rating', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    if (ratingCount != null) Text(' ($ratingCount تقييم على جوجل)', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                  ]),
                ],
                if (address != null && address.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 15, color: AppColors.inkSecondary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(address, style: const TextStyle(fontSize: 12.5))),
                  ]),
                ],
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(description, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.7)),
                ],
                if (discountPct != null || deliveryRadius != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (discountPct != null)
                          Text('خصم ${discountPct.toStringAsFixed(0)}% لسكان العمارات المجاورة الموثقين', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        if (deliveryRadius != null) Text('نطاق التوصيل: $deliveryRadiusم', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(children: [
                  Icon(source == 'google_imported' ? Icons.travel_explore_rounded : Icons.handshake_rounded, size: 13, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text(source == 'google_imported' ? 'مستورد من خرائط Google' : 'مسجّل يدوياً', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 20),
                if (!isClaimed)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClaimBusinessHubScreen(shop: shop))),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      icon: const Icon(Icons.storefront_outlined, size: 18),
                      label: const Text('محلي ده! طالب بيه', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
