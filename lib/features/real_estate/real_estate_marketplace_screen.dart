import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/real_estate/real_estate_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'add_real_estate_listing_screen.dart';

const _safetyTips = [
  'لا تحوّل أي مبلغ مالي مهما كان صغيراً إلا بعد معاينة الوحدة شخصياً على الطبيعة.',
  'اطلب دائماً الاطلاع على عقد الملكية أو التوكيل الرسمي قبل أي التزام أو دفعة.',
  'تواصل فقط مع المعلن مباشرة بعد إبداء اهتمامك، وتجاهل أي طلب دفع أو تحويل خارج التطبيق.',
  'أي سعر أقل من المعتاد بشكل ملحوظ هو علامة تحذير — تحقق جيداً قبل التقديم.',
];

/// Verified peer-to-peer real estate marketplace — now reading real
/// `real_estate_listings` rows instead of two hardcoded ads, see
/// backend/migrations/0023_real_estate.sql. Framed around trust and
/// fraud-protection first, not commissions/payment.
class RealEstateMarketplaceScreen extends StatefulWidget {
  const RealEstateMarketplaceScreen({super.key});

  @override
  State<RealEstateMarketplaceScreen> createState() => _RealEstateMarketplaceScreenState();
}

class _RealEstateMarketplaceScreenState extends State<RealEstateMarketplaceScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _listings = [];
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final dealType = switch (_filterIndex) {
      1 => 'sale',
      2 => 'rent',
      _ => null,
    };
    final rows = await RealEstateService.fetchListings(dealType: dealType);
    if (!mounted) return;
    setState(() {
      _listings = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سوق العقارات الموثق')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
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
                          const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.check_circle_rounded, size: 13, color: AppColors.tealLight)),
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (!AuthService.isSignedIn) {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                    return;
                  }
                  final published = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddRealEstateListingScreen()));
                  if (published == true) _load();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('أضف عقاراً للبيع أو الإيجار', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(label: 'الكل', selected: _filterIndex == 0, onTap: () { setState(() => _filterIndex = 0); _load(); }),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'للبيع', selected: _filterIndex == 1, onTap: () { setState(() => _filterIndex = 1); _load(); }),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'للإيجار', selected: _filterIndex == 2, onTap: () { setState(() => _filterIndex = 2); _load(); }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
            else if (_listings.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('لا توجد إعلانات عقارية حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))),
              )
            else
              for (final l in _listings) ...[
                _ListingCard(listing: l),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: selected ? AppColors.navy : AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: selected ? AppColors.navy : AppColors.border)),
        child: Text(label, style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _ListingCard extends StatefulWidget {
  const _ListingCard({required this.listing});
  final Map<String, dynamic> listing;

  @override
  State<_ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<_ListingCard> {
  bool _sending = false;

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        const reasons = ['سعر غير منطقي أو مشبوه', 'طلب دفع مقدم خارج التطبيق', 'صور أو بيانات غير حقيقية', 'إعلان مكرر أو منتهي'];
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
              const Text('بلاغك يساعدنا في حماية باقي الجيران من النصب والإعلانات الوهمية.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6)),
              const SizedBox(height: 14),
              for (final reason in reasons)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
                  title: Text(reason, style: const TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استلام بلاغك، شكراً لمساهمتك في أمان المجتمع')));
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _expressInterest() async {
    setState(() => _sending = true);
    try {
      await RealEstateService.expressInterest(widget.listing['id'] as String);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إبلاغ صاحب الإعلان باهتمامك، هيتواصل معاك قريباً')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال طلبك، حاول مرة أخرى')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    final owner = l['owner'] as Map<String, dynamic>?;
    final isSale = l['deal_type'] == 'sale';
    final price = (l['price'] as num).toStringAsFixed(0);

    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(height: 140, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.villa_outlined, size: 36, color: AppColors.inkMuted))),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.verified_rounded, size: 12, color: AppColors.teal),
                    SizedBox(width: 3),
                    Text('معلن جار موثق', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                  ]),
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
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
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
                    child: Text(isSale ? 'للبيع' : 'للإيجار', style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Text(isSale ? '$price ج.م' : '$price ج.م / شهرياً', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
                const SizedBox(height: 8),
                Text(l['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4)),
                if (l['description'] != null && (l['description'] as String).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(l['description'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 10),
                Row(children: [
                  if (l['area_sqm'] != null) _SpecChip(icon: Icons.straighten_rounded, label: '${(l['area_sqm'] as num).toStringAsFixed(0)} م²'),
                  if (l['area_sqm'] != null) const SizedBox(width: 8),
                  if (l['bedrooms'] != null) _SpecChip(icon: Icons.bed_outlined, label: '${l['bedrooms']} غرف'),
                  if (l['bedrooms'] != null) const SizedBox(width: 8),
                  if (l['bathrooms'] != null) _SpecChip(icon: Icons.bathtub_outlined, label: '${l['bathrooms']} حمام'),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const CircleAvatar(radius: 16, backgroundColor: AppColors.surface, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(children: [
                        Text(owner?['full_name'] as String? ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, size: 12, color: AppColors.teal),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: _sending ? null : _expressInterest,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: _sending
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                    label: const Text('أنا مهتم، تواصل معايا', style: TextStyle(fontSize: 11.5)),
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
