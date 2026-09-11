import 'package:flutter/material.dart';

import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import 'claim_business_hub_screen.dart';

/// Neighborhood shops guide — matches
/// design/screens/17_neighborhood_shops_guide.png, now backed by real
/// shops imported from Google Places (see PlacesService) alongside any
/// claimed listings, instead of three hardcoded sample shops.
class NeighborhoodShopsScreen extends StatefulWidget {
  const NeighborhoodShopsScreen({super.key});

  @override
  State<NeighborhoodShopsScreen> createState() => _NeighborhoodShopsScreenState();
}

class _NeighborhoodShopsScreenState extends State<NeighborhoodShopsScreen> {
  bool _loading = true;
  bool _searching = false;
  String? _error;
  List<Map<String, dynamic>> _shops = [];
  final _searchCtrl = TextEditingController(text: 'سوبر ماركت وصيدليات في المعادي');

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final shops = await PlacesService.fetchImportedShops();
    if (!mounted) return;
    setState(() {
      _shops = shops;
      _loading = false;
    });
  }

  Future<void> _search() async {
    if (_searchCtrl.text.trim().isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final shops = await PlacesService.importFromGoogle(_searchCtrl.text.trim());
      if (!mounted) return;
      setState(() => _shops = shops);
    } catch (_) {
      setState(() => _error = 'تعذر البحث الآن، تحقق من الاتصال وحاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحلات القريبة ودليل الحي')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Text('محلات حقيقية عبر خرائط Google، بالإضافة لأي محل طالب به أصحابه.',
                style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      const Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onSubmitted: (_) => _search(),
                          style: const TextStyle(fontSize: 12.5),
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _searching ? null : _search,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: _searching
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.travel_explore_rounded, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('ابحث بنوع المحل والحي (مثلاً: صيدليات في المعادي) لاستيراد نتائج حقيقية من خرائط Google.',
                style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
                ]),
              ),
            ],
            const SizedBox(height: 18),
            Row(children: [
              const Expanded(child: Text('المحلات القريبة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              Text('${_shops.length} محل', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            ]),
            const SizedBox(height: 10),
            if (_loading)
              const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: CircularProgressIndicator()))
            else if (_shops.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(children: [
                  Icon(Icons.storefront_outlined, color: AppColors.inkMuted, size: 32),
                  SizedBox(height: 10),
                  Text('ابحث فوق لاستيراد محلات حقيقية من حيك', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
                ]),
              )
            else
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
                    'ابحث عن محلك في القائمة فوق واضغط "محلي ده! طالب بيه" على كارته لتبدأ توثيق الملكية.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
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

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});
  final Map<String, dynamic> shop;

  @override
  Widget build(BuildContext context) {
    final name = shop['name'] as String? ?? '';
    final category = shop['category'] as String? ?? 'محل تجاري';
    final address = shop['address'] as String?;
    final rating = (shop['rating'] as num?)?.toDouble();
    final ratingCount = shop['rating_count'] as int?;
    final isClaimed = shop['is_claimed'] as bool? ?? false;
    final source = shop['source'] as String?;
    final coverImageUrl = shop['cover_image_url'] as String?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: coverImageUrl != null
                    ? Image.network(
                        coverImageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 52,
                          height: 52,
                          color: AppColors.categoryShops.withValues(alpha: 0.1),
                          child: const Icon(Icons.storefront_rounded, color: AppColors.categoryShops, size: 24),
                        ),
                      )
                    : Container(
                        width: 52,
                        height: 52,
                        color: AppColors.categoryShops.withValues(alpha: 0.1),
                        child: const Icon(Icons.storefront_rounded, color: AppColors.categoryShops, size: 24),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                      if (isClaimed) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                      ],
                    ]),
                    Text(category, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                    if (rating != null)
                      Row(children: [
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                        const SizedBox(width: 2),
                        Text('$rating', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                        if (ratingCount != null) Text(' ($ratingCount)', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      ]),
                  ],
                ),
              ),
            ],
          ),
          if (address != null && address.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
              const SizedBox(width: 4),
              Expanded(child: Text(address, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
            ]),
          ],
          const SizedBox(height: 8),
          Row(children: [
            Icon(source == 'google_imported' ? Icons.travel_explore_rounded : Icons.handshake_rounded, size: 12, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            Expanded(child: Text(source == 'google_imported' ? 'عبر خرائط Google' : 'محل مسجّل يدوياً', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted))),
            if (!isClaimed)
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClaimBusinessHubScreen(shop: shop))),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('محلي ده! طالب بيه', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.teal)),
              ),
          ]),
        ],
      ),
    );
  }
}
