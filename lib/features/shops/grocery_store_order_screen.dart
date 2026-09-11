import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _Product {
  const _Product({required this.name, required this.note, required this.price, required this.badge, this.badgeColor = AppColors.teal});
  final String name, note, price;
  final String? badge;
  final Color badgeColor;
}

const _products = [
  _Product(name: 'حليب المراعي كامل الدسم...', note: 'مبستر ومعقم يومياً • تاريخ اليوم', price: '42.00', badge: 'طازج'),
  _Product(name: 'جبنة فيتا دومتي 500 جم', note: 'قليلة الملح • عبوة تراكية', price: '38.00', badge: null),
  _Product(name: 'بيض أحمر طازج كرتونة...', note: 'مضمون وضمان الحجم الكبير', price: '65.00', badge: 'مزرعة اليوم', badgeColor: AppColors.gold),
  _Product(name: 'مياه معدنية نستله', note: 'حزمة عائلية (6 زجاجات)', price: '48.00', badge: null),
];

/// Ordering from a neighborhood grocery store — matches
/// design/screens/00_grocery_store_order.png.
class GroceryStoreOrderScreen extends StatefulWidget {
  const GroceryStoreOrderScreen({super.key});

  @override
  State<GroceryStoreOrderScreen> createState() => _GroceryStoreOrderScreenState();
}

class _GroceryStoreOrderScreenState extends State<GroceryStoreOrderScreen> {
  final Map<int, int> _quantities = {0: 2, 3: 1};

  int get _itemCount => _quantities.values.where((q) => q > 0).length;
  double get _total {
    var sum = 0.0;
    _quantities.forEach((i, q) => sum += q * double.parse(_products[i].price));
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: AppColors.navy,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceAlt,
                child: const Center(child: Icon(Icons.storefront_rounded, size: 40, color: AppColors.inkMuted)),
              ),
            ),
            actions: const [
              Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.favorite_border_rounded)),
              Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.share_outlined)),
            ],
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('سوبر ماركت النور والبركة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            Text('بقالة ومؤن تموينية • مجمع دجلة التجاري', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.local_grocery_store_rounded, color: AppColors.teal),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: const [
                      Icon(Icons.circle, size: 6, color: AppColors.teal),
                      SizedBox(width: 4),
                      Text('مفتوح الآن', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
                      SizedBox(width: 10),
                      Icon(Icons.delivery_dining_rounded, size: 13, color: AppColors.inkMuted),
                      SizedBox(width: 3),
                      Text('توصيل 15 دقيقة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                      SizedBox(width: 10),
                      Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                      SizedBox(width: 2),
                      Text('4.9 (180 تقييم)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.teal),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('توصيل مجاني لسكان برج الياسمين للطلبات الأكثر من 100 ج.م بالتعاون مع اتحاد الملاك',
                              style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.6)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                          child: const Text('عرض الجار', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: const Row(children: [
                    Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('ابحث عن منتج داخل سوبر ماركت النور...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12))),
                  ]),
                ),
                const SizedBox(height: 12),
                const _CategoryChips(),
                const SizedBox(height: 18),
                Row(children: const [
                  Expanded(child: Text('قسم الألبان والأجبان الطازجة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
                  Text('عرض 14 صنف', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 12),
                for (var i = 0; i < _products.length; i++) ...[
                  _ProductRow(
                    product: _products[i],
                    quantity: _quantities[i] ?? 0,
                    onChanged: (q) => setState(() => _quantities[i] = q),
                  ),
                  const SizedBox(height: 12),
                ],
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _itemCount == 0
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    icon: Stack(clipBehavior: Clip.none, children: [
                      const Icon(Icons.shopping_cart_rounded, size: 18),
                      Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                          child: Text('$_itemCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ]),
                    label: Text('إتمام الطلب  •  ${_total.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['منتجات الألبان والأجبان', 'معلبات ومؤن', 'مشروبات وعصائر'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product, required this.quantity, required this.onChanged});
  final _Product product;
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          if (quantity > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              height: 34,
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                  onTap: () => onChanged(quantity - 1),
                  child: Icon(quantity == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded, size: 16, color: AppColors.inkSecondary),
                ),
                SizedBox(width: 20, child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                InkWell(onTap: () => onChanged(quantity + 1), child: const Icon(Icons.add_rounded, size: 16, color: AppColors.teal)),
              ]),
            )
          else
            SizedBox(
              height: 34,
              child: OutlinedButton.icon(
                onPressed: () => onChanged(1),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.teal, side: const BorderSide(color: AppColors.teal), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), padding: const EdgeInsets.symmetric(horizontal: 10)),
                icon: const Icon(Icons.add_rounded, size: 14),
                label: const Text('إضافة', style: TextStyle(fontSize: 11)),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(product.note, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${product.price} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_basket_outlined, color: AppColors.inkMuted, size: 22),
              ),
              if (product.badge != null)
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(color: product.badgeColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(product.badge!, style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
