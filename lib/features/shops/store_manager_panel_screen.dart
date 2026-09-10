import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Local shop owner's order & storefront management panel — matches
/// design/screens/22_store_manager_panel.png.
class StoreManagerPanelScreen extends StatefulWidget {
  const StoreManagerPanelScreen({super.key});

  @override
  State<StoreManagerPanelScreen> createState() => _StoreManagerPanelScreenState();
}

class _StoreManagerPanelScreenState extends State<StoreManagerPanelScreen> {
  bool _instantAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('بوابة إدارة المتجر المحلي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 6, color: AppColors.teal),
                SizedBox(width: 4),
                Text('المتجر مفتوح ويستقبل طلبات الجيران', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Row(children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.storefront_rounded, color: AppColors.inkMuted, size: 26),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Flexible(child: Text('سوبر ماركت الأمانة - فرع دجلة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 14, color: AppColors.teal),
                        ]),
                        const Text('خدمة التوصيل السريع لسكان عمارات دجلة والمعادي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        Row(children: const [
                          Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                          SizedBox(width: 2),
                          Text('4.8 (142 تقييم)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ]),
                      ],
                    ),
                  ),
                ]),
                const Divider(height: 20, color: AppColors.border),
                Row(children: [
                  const Icon(Icons.notifications_active_outlined, size: 18, color: AppColors.inkSecondary),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('استقبال التنبيهات الفورية للطلبات العاجلة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
                  Switch(value: _instantAlerts, onChanged: (v) => setState(() => _instantAlerts = v), activeThumbColor: AppColors.teal),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('مؤشرات أداء اليوم', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            const Text('محدث منذ 3 دقائق', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatTile(icon: Icons.delivery_dining_rounded, value: '18', unit: 'دقيقة', label: 'وقت التوصيل')),
            const SizedBox(width: 8),
            Expanded(child: _StatTile(icon: Icons.payments_outlined, value: '3,420', unit: 'ج.م', label: 'المبيعات')),
            const SizedBox(width: 8),
            Expanded(child: _StatTile(icon: Icons.shopping_cart_outlined, value: '28', unit: '+14%', label: 'طلبات اليوم', unitColor: AppColors.teal)),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            const Text('طابور الطلبات المباشرة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.categorySos, shape: BoxShape.circle),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const Text('تحديث تلقائي حي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          _NewOrderCard(),
          const SizedBox(height: 12),
          _DeliveringOrderCard(),
          const SizedBox(height: 22),
          const Text('خيارات إدارة وتوسيع المتجر', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.inventory_2_outlined, color: AppColors.inkSecondary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إدارة المنتجات وقائمة الأسعار', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('240 صنف مسجل في الرفوف الرقمية للمتجر', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
            ]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.near_me_outlined, color: AppColors.inkSecondary),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('نطاق التوصيل السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        Text('محدد بقطر 800 متر لضمان سرعة الوصول للبرج', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                    child: const Text('800 متر', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.65, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.gold),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المستحقات المالية والعمولة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        Text('إعفاء كامل لأول 3 شهور لدعم المتاجر المحلية وسكان الحي', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                    child: const Text('0% عمولة', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const Divider(height: 20, color: AppColors.border),
                Row(children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تاريخ السحب القادم', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        Text('الخميس، 15 مايو', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('الرصيد المتاح للتحويل', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      Text('14,890 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.local_grocery_store_rounded, color: AppColors.teal),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حملة الجيران الشهرية', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                    Text('عروض خضار وفاكهة طازجة لبرج الياسمين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('إشعار سكان الحي بالعروض الخاصة وتوصيل مجاني خلال 15 دقيقة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.unit, required this.label, this.unitColor = AppColors.inkMuted});
  final IconData icon;
  final String value, unit, label;
  final Color unitColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.inkSecondary),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(width: 3),
            Text(unit, style: TextStyle(fontSize: 9, color: unitColor, fontWeight: FontWeight.w600)),
          ]),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _NewOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.gold, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('طلب جديد #1084', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('جديد للتو', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('323 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                Text('كاش عند الاستلام', style: TextStyle(fontSize: 8.5, color: AppColors.inkMuted)),
              ],
            ),
          ]),
          const SizedBox(height: 6),
          Row(children: const [
            Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkMuted),
            SizedBox(width: 4),
            Text('شقة 402 • برج الياسمين (350 متر)', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: const Text('حليب المراعي كامل الدسم (2) • بيض مزارع طازج (طبق) • جبنة فيتا دومتي',
                style: TextStyle(fontSize: 10, color: AppColors.inkSecondary, height: 1.6)),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
                  label: const Text('قبول الطلب وتجهيزه', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('رفض الطلب', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _DeliveringOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('طلب #1081', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.delivery_dining_rounded, size: 11, color: AppColors.teal),
                SizedBox(width: 3),
                Text('قيد التوصيل', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ]),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('185 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                Text('مدفوع إلكترونياً', style: TextStyle(fontSize: 8.5, color: AppColors.inkMuted)),
              ],
            ),
          ]),
          const SizedBox(height: 6),
          Row(children: const [
            Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkMuted),
            SizedBox(width: 4),
            Text('عمارة 14 دجلة - الدور الثالث', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.badge_outlined, size: 13, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            const Text('مندوب المتجر: أحمد حسام', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.timer_outlined, size: 12, color: AppColors.inkMuted),
            const SizedBox(width: 3),
            const Text('متبقي 6 دقائق', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
        ],
      ),
    );
  }
}
