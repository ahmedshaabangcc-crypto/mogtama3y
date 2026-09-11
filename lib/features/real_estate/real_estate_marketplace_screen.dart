import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _Listing {
  const _Listing({
    required this.adCode,
    required this.dealType,
    required this.price,
    required this.title,
    required this.area,
    required this.beds,
    required this.baths,
    required this.ownerName,
    required this.ownerNote,
  });
  final String adCode, dealType, price, title, area, beds, baths, ownerName, ownerNote;
}

const _listings = [
  _Listing(
    adCode: 'MJ-882#',
    dealType: 'للبيع المباشر',
    price: '4,200,000 ج.م كاش',
    title: 'شقة فاخرة للبيع تشطيب سوبر لوكس',
    area: '210 م²',
    beds: '3 غرف نوم',
    baths: '3 حمامات',
    ownerName: 'أ. كريم حامد',
    ownerNote: 'مالك الوحدة 4B جار موثق بالهوية وعقد',
  ),
  _Listing(
    adCode: 'MJ-901#',
    dealType: 'للإيجار الجديد',
    price: '18,000 ج.م / شهرياً',
    title: 'شقة مفروشة بالكامل للإيجار قانون جديد',
    area: '160 م²',
    beds: '2 غرفة نوم',
    baths: '2 حمام',
    ownerName: 'د. مي الشاذلي',
    ownerNote: 'مالكة الوحدة 2A جارة موثقة بالهوية وعقد',
  ),
];

const _safetyTips = [
  'لا تحوّل أي مبلغ مالي مهما كان صغيراً إلا بعد معاينة الوحدة شخصياً على الطبيعة.',
  'اطلب دائماً الاطلاع على عقد الملكية أو التوكيل الرسمي قبل أي التزام أو دفعة.',
  'تواصل فقط عبر محادثة مُجتمعي الآمنة، وتجاهل أي طلب دفع أو تحويل خارج التطبيق.',
  'أي سعر أقل من المعتاد بشكل ملحوظ هو علامة تحذير — تحقق جيداً قبل التقديم.',
];

/// Verified peer-to-peer real estate marketplace — matches the
/// "سوق العقارات الموثق" design screen the user provided. Framed around
/// trust and fraud-protection first, not around commissions/payment.
class RealEstateMarketplaceScreen extends StatefulWidget {
  const RealEstateMarketplaceScreen({super.key});

  @override
  State<RealEstateMarketplaceScreen> createState() => _RealEstateMarketplaceScreenState();
}

class _RealEstateMarketplaceScreenState extends State<RealEstateMarketplaceScreen> {
  bool _hideFromMyBuilding = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سوق العقارات الموثق')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.shield_rounded, size: 12, color: AppColors.teal),
                SizedBox(width: 4),
                Text('أمانك أهم من أي صفقة', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 6),
          const Text('البيع والإيجار المباشر بين جيران موثقين — لا وسطاء ولا إعلانات مجهولة المصدر',
              style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.6)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.verified_user_rounded, color: AppColors.tealLight, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('كل معلن هنا جار حقيقي وموثق بوحدته السكنية — ليس وسيطاً أو حساباً مجهولاً',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.5)),
                  ),
                ]),
                const SizedBox(height: 12),
                for (final tip in _safetyTips) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle_rounded, size: 13, color: AppColors.tealLight),
                        ),
                        const SizedBox(width: 6),
                        Expanded(child: Text(tip, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.6))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.verified_rounded, color: AppColors.teal, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حساب موثق: سكن موثق، برج الياسمين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('الوحدة: شقة 4B - مسجلة بسجل العقار الذكي', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                child: const Text('أصيل 100%', style: TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: const [
            Expanded(child: _StatTile(value: '100%', label: 'فحص الملكية', valueColor: AppColors.teal)),
            SizedBox(width: 8),
            Expanded(child: _StatTile(value: '100%', label: 'توثيق الهوية', valueColor: AppColors.teal)),
            SizedBox(width: 8),
            Expanded(child: _StatTile(value: '0 ج.م', label: 'بدون عمولات خفية')),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('أضف عقاراً للبيع أو الإيجار', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.gold, width: 1.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                    child: const Text('حصري', style: TextStyle(fontSize: 8.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.gold),
                ]),
                const SizedBox(height: 6),
                const Text('ميزة الخصوصية التامة للجيران', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                const Text(
                  'تحكم كامل في ظهور إعلانك لتجنب الحرج الاجتماعي مع الجيران داخل نفس البرج.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.7),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Expanded(child: Text('إخفاء العقار عن سكان عمارتي الحالية (برج الياسمين)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                    Switch(value: _hideFromMyBuilding, onChanged: (v) => setState(() => _hideFromMyBuilding = v), activeThumbColor: AppColors.teal),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _FilterChips(),
          const SizedBox(height: 16),
          for (final l in _listings) ...[
            _ListingCard(listing: l),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, this.valueColor = AppColors.ink});
  final String value, label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: valueColor)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل (12)', 'شقق للبيع (7)', 'شقق للإيجار قانون جديد (3)', 'مكاتب'];
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

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.listing});
  final _Listing listing;

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        const reasons = [
          'سعر غير منطقي أو مشبوه',
          'طلب دفع مقدم خارج التطبيق',
          'صور أو بيانات غير حقيقية',
          'إعلان مكرر أو منتهي',
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [
                Icon(Icons.flag_outlined, color: AppColors.categorySos, size: 20),
                SizedBox(width: 8),
                Text('الإبلاغ عن هذا الإعلان', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ]),
              const SizedBox(height: 6),
              const Text('بلاغك يساعدنا في حماية باقي الجيران من النصب والإعلانات الوهمية.',
                  style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6)),
              const SizedBox(height: 14),
              for (final reason in reasons)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
                  title: Text(reason, style: const TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم استلام بلاغك، شكراً لمساهمتك في أمان المجتمع')),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(height: 170, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.villa_outlined, size: 36, color: AppColors.inkMuted))),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.verified_rounded, size: 12, color: AppColors.teal),
                    SizedBox(width: 3),
                    Text('ملكية مفحوصة رسمياً', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                  child: Text('كود الإعلان: ${listing.adCode}', style: const TextStyle(fontSize: 9, color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                  child: const Text('1/8 صور', style: TextStyle(fontSize: 9, color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => _showReportSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(100)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.flag_outlined, size: 11, color: Colors.white),
                      SizedBox(width: 4),
                      Text('إبلاغ', style: TextStyle(fontSize: 9, color: Colors.white)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                    child: Text(listing.dealType, style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Text(listing.price, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
                const SizedBox(height: 8),
                Text(listing.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4)),
                const SizedBox(height: 10),
                Row(children: [
                  _SpecChip(icon: Icons.straighten_rounded, label: listing.area),
                  const SizedBox(width: 8),
                  _SpecChip(icon: Icons.bed_outlined, label: listing.beds),
                  const SizedBox(width: 8),
                  _SpecChip(icon: Icons.bathtub_outlined, label: listing.baths),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const CircleAvatar(radius: 16, backgroundColor: AppColors.surface, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(listing.ownerName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, size: 12, color: AppColors.teal),
                          ]),
                          Text(listing.ownerNote, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                      child: const Text('جار موثق', style: TextStyle(fontSize: 8.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text('طلب معاينة', style: TextStyle(fontSize: 11.5)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                        label: const Text('محادثة فورية', style: TextStyle(fontSize: 11.5)),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.inkSecondary),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
