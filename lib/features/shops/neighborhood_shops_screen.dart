import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'claim_business_hub_screen.dart';
import 'grocery_store_order_screen.dart';

class _Shop {
  const _Shop({
    required this.name,
    required this.category,
    required this.rating,
    required this.distance,
    required this.note,
    required this.discount,
    required this.icon,
    required this.iconColor,
    required this.ctaLabel,
    required this.ctaIcon,
  });
  final String name, category, rating, distance, note, discount, ctaLabel;
  final IconData icon, ctaIcon;
  final Color iconColor;
}

const _shops = [
  _Shop(
    name: 'سوبر ماركت النور والبركة',
    category: 'بقالة ومواد غذائية ولوازم المنزل',
    rating: '4.9',
    distance: '150م (دقيقتين مشياً)',
    note: 'توصيل مجاني للعمارة (15 دقيقة)',
    discount: 'خصم 10% لسكان البرج',
    icon: Icons.local_grocery_store_rounded,
    iconColor: AppColors.categoryUsedMarket,
    ctaLabel: 'تصفح المتجر والطلب',
    ctaIcon: Icons.storefront_outlined,
  ),
  _Shop(
    name: 'صيدلية العزي - فرع دجلة',
    category: 'أدوية، مستلزمات طبية، ورعاية صحية',
    rating: '4.8',
    distance: '280م (4 دقائق مشياً)',
    note: 'مفتوح 24 ساعة',
    discount: 'خصم 5% فوري على العلاج',
    icon: Icons.local_pharmacy_rounded,
    iconColor: AppColors.categorySos,
    ctaLabel: 'طلب روشتة أو علاج',
    ctaIcon: Icons.medication_outlined,
  ),
  _Shop(
    name: 'مخبز الأمانة الإفرنجي والبلدي',
    category: 'فطائر، مخبوزات طازجة على مدار الساعة',
    rating: '4.6',
    distance: '350م (5 دقائق مشياً)',
    note: 'خبز طازج خارج الفرن الآن',
    discount: '',
    icon: Icons.bakery_dining_rounded,
    iconColor: AppColors.gold,
    ctaLabel: 'تصفح قائمة المخبوزات',
    ctaIcon: Icons.local_shipping_outlined,
  ),
];

/// Neighborhood shops guide — matches
/// design/screens/17_neighborhood_shops_guide.png.
class NeighborhoodShopsScreen extends StatelessWidget {
  const NeighborhoodShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحلات القريبة ودليل الحي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('نطاق 500 متر الحيوي', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 4),
          const Text('كل ما تحتاجه عائلتك على بعد خطوات، مع مزايا حصرية لسكان برج الياسمين.',
              style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: const Icon(Icons.tune_rounded, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: const Row(children: [
                    Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                    SizedBox(width: 8),
                    Text('ابحث عن منتج، صيدلية، بقالة، أو مخبز...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _MapCard(),
          const SizedBox(height: 14),
          const _FilterChips(),
          const SizedBox(height: 16),
          const _PromoBanner(),
          const SizedBox(height: 18),
          const Text('المتاجر الشريكة المعتمدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const Text('مرتبة حسب المسافة الأقرب', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          for (final s in _shops) ...[
            _ShopCard(shop: s),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.storefront_rounded, color: AppColors.inkSecondary, size: 26),
                const SizedBox(height: 8),
                const Text('هل تملك محلاً في هذا الحي؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 6),
                const Text(
                  'طالب بملكية نشاطك التجاري واحصد سكان عماراتك فوراً. أضف اسمك على شارة الشريك المعتمد وتلقَّ الطلبات المباشرة دون وسيط.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ClaimBusinessHubScreen())),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), backgroundColor: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('المطالبة بنشاطك التجاري', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
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

class _MapCard extends StatelessWidget {
  const _MapCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.apartment_rounded, color: AppColors.navy, size: 30),
          ),
          Positioned(top: 18, left: 30, child: _MapPin(icon: Icons.shopping_cart_rounded, color: AppColors.teal, label: 'النور (150م)')),
          Positioned(bottom: 30, left: 20, child: _MapPin(icon: Icons.local_pharmacy_rounded, color: AppColors.categorySos, label: 'العزي (280م)')),
          Positioned(bottom: 20, right: 24, child: _MapPin(icon: Icons.bakery_dining_rounded, color: AppColors.gold, label: 'الأمانة (350م)')),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.map_outlined, size: 13, color: AppColors.teal),
                SizedBox(width: 4),
                Text('عرض الخريطة التفاعلية الكاملة', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color, required this.label});
  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          child: Icon(icon, size: 13, color: Colors.white),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Text(label, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل (18)', 'سوبر ماركت وبقالة', 'صيدليات وأدوية'];
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
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11.5, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.loyalty_rounded, size: 16, color: AppColors.teal),
            const SizedBox(width: 6),
            const Text('ميزة حصرية للجيران', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          const Text('خصم موحد 10% لسكان برج الياسمين', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 4),
          const Text(
            'أبرز كود التحقق السكني الرقمي عند الشراء أو استخدم الخصم التلقائي عند الطلب عبر التطبيق.',
            style: TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.7),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                  child: const Text('كود الجار: YASMIN-4B', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.copy_rounded, size: 14),
                  label: const Text('نسخ الرمز', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});
  final _Shop shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: shop.iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(shop.icon, color: shop.iconColor, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                    ]),
                    Text(shop.category, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                    Row(children: [
                      const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                      const SizedBox(width: 2),
                      Text(shop.rating, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      const Icon(Icons.directions_walk_rounded, size: 12, color: AppColors.inkMuted),
                      const SizedBox(width: 2),
                      Expanded(child: Text(shop.distance, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: Text(shop.note, style: const TextStyle(fontSize: 10, color: AppColors.inkSecondary)),
          ),
          if (shop.discount.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.local_offer_outlined, size: 12, color: AppColors.teal),
              const SizedBox(width: 4),
              Text(shop.discount, style: const TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
            ]),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: shop.ctaLabel == 'تصفح المتجر والطلب'
                        ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GroceryStoreOrderScreen()))
                        : () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: Icon(shop.ctaIcon, size: 15),
                    label: Text(shop.ctaLabel, style: const TextStyle(fontSize: 11.5)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                child: const Icon(Icons.chat_bubble_outline_rounded, size: 17, color: AppColors.inkSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
