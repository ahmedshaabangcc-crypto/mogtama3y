import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/recycling/recycling_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'add_recycling_lot_screen.dart';
import 'auction_detail_screen.dart';

const _categoryLabels = {
  'metal': 'معادن',
  'plastic': 'بلاستيك',
  'electronics': 'إلكترونيات',
  'furniture': 'أثاث',
  'paper_cardboard': 'ورق وكرتون',
  'other': 'أخرى',
};

Duration _remainingFor(Map<String, dynamic> lot) {
  final endsAt = DateTime.tryParse(lot['auction_ends_at'] as String? ?? '');
  if (endsAt == null) return Duration.zero;
  final diff = endsAt.difference(DateTime.now().toUtc());
  return diff.isNegative ? Duration.zero : diff;
}

(double, int) _topBidAndCount(Map<String, dynamic> lot) {
  final bids = (lot['recycling_bids'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
  if (bids.isEmpty) return (0, 0);
  final top = bids.map((b) => (b['amount'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
  return (top, bids.length);
}

/// Recycling & scrap ("بيكيا") marketplace with live auctions — matches
/// design/screens/19_recycling_marketplace.png, now reading real
/// recycling_listings/recycling_bids rows.
class RecyclingMarketplaceScreen extends StatefulWidget {
  const RecyclingMarketplaceScreen({super.key});

  @override
  State<RecyclingMarketplaceScreen> createState() => _RecyclingMarketplaceScreenState();
}

class _RecyclingMarketplaceScreenState extends State<RecyclingMarketplaceScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _lots = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final lots = await RecyclingService.fetchActiveLots();
    if (!mounted) return;
    setState(() {
      _lots = lots;
      _loading = false;
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سوق البيكيا وتدوير المخلفات')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF0E4A38), borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.recycling_rounded, color: AppColors.tealLight, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أثر مجتمعي مستدام', style: TextStyle(color: AppColors.tealLight, fontSize: 10.5, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('حوّل مخلفاتك إلى عائد نقدي أو دعم لصندوق صيانة عمارتك', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _FilterChips(),
            const SizedBox(height: 18),
            Row(children: [
              const Expanded(child: Text('مزادات الخردة النشطة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              Text('${_lots.length} مزاد نشط', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ]),
            const SizedBox(height: 10),
            if (_loading)
              const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: CircularProgressIndicator()))
            else if (_lots.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(children: const [
                  Icon(Icons.recycling_outlined, color: AppColors.inkMuted, size: 32),
                  SizedBox(height: 10),
                  Text('لا توجد مزادات نشطة حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                ]),
              )
            else
              for (final lot in _lots) ...[
                _LotCard(lot: lot, remaining: _remainingFor(lot), remainingLabel: _format(_remainingFor(lot))),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (!AuthService.isSignedIn) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                  return;
                }
                final added = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddRecyclingLotScreen()));
                if (added == true) _load();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('إضافة خردة أو بيكيا جديدة للمزاد (بيع أو تبرع)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'أجهزة ومكيفات', 'معادن وحديد', 'ورق وكرتون', 'أثاث خشب'];
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

class _LotCard extends StatelessWidget {
  const _LotCard({required this.lot, required this.remaining, required this.remainingLabel});
  final Map<String, dynamic> lot;
  final Duration remaining;
  final String remainingLabel;

  @override
  Widget build(BuildContext context) {
    final title = lot['title'] as String? ?? '';
    final locationNote = lot['location_note'] as String?;
    final weightKg = (lot['estimated_weight_kg'] as num?)?.toDouble();
    final category = lot['category'] as String? ?? 'other';
    final seller = lot['seller'] as Map<String, dynamic>?;
    final sellerVerified = seller?['is_verified'] as bool? ?? false;
    final (topBid, bidCount) = _topBidAndCount(lot);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionDetailScreen(listingId: lot['id'] as String)));
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(height: 140, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.recycling_rounded, size: 34, color: AppColors.inkMuted))),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: sellerVerified ? AppColors.teal : Colors.black87, borderRadius: BorderRadius.circular(8)),
                    child: Text(_categoryLabels[category] ?? category, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(remainingLabel, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(
                    'الموقع: ${locationNote ?? '—'}${weightKg != null ? ' • ~${weightKg.toStringAsFixed(0)} كجم' : ''}',
                    style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('أعلى عرض حالي', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                            Text(topBid > 0 ? '${NumberFormat('#,##0').format(topBid)} ج.م' : 'لا توجد عروض بعد', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.teal)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                        child: Text('$bidCount عروض', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
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
