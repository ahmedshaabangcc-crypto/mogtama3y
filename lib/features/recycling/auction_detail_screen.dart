import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/recycling/recycling_service.dart';
import '../../core/theme/app_colors.dart';

const _categoryLabels = {
  'metal': 'معادن',
  'plastic': 'بلاستيك',
  'electronics': 'إلكترونيات',
  'furniture': 'أثاث',
  'paper_cardboard': 'ورق وكرتون',
  'other': 'أخرى',
};

/// Auction detail + real-time bidding — matches
/// design/screens/20_recycling_auction_bidding.png, now backed by a
/// real recycling_listings row and its recycling_bids.
class AuctionDetailScreen extends StatefulWidget {
  const AuctionDetailScreen({super.key, required this.listingId});
  final String listingId;

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  Map<String, dynamic>? _lot;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  Timer? _timer;
  final _bidCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bidCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final lot = await RecyclingService.fetchLot(widget.listingId);
    if (!mounted) return;
    setState(() {
      _lot = lot;
      _loading = false;
    });
  }

  Duration get _remaining {
    final endsAt = DateTime.tryParse(_lot?['auction_ends_at'] as String? ?? '');
    if (endsAt == null) return Duration.zero;
    final diff = endsAt.difference(DateTime.now().toUtc());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _formatted {
    final d = _remaining;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  List<Map<String, dynamic>> get _bids {
    final bids = (_lot?['recycling_bids'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final sorted = [...bids]..sort((a, b) => (b['amount'] as num).compareTo(a['amount'] as num));
    return sorted;
  }

  Future<void> _placeBid() async {
    final amount = double.tryParse(_bidCtrl.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'أدخل قيمة عرض صحيحة.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await RecyclingService.placeBid(listingId: widget.listingId, amount: amount);
      _bidCtrl.clear();
      await _load();
    } catch (_) {
      setState(() => _error = 'تعذر إرسال العرض، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _acceptTopBid() async {
    setState(() => _busy = true);
    try {
      await RecyclingService.acceptTopBid(widget.listingId);
      await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _lot == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final lot = _lot!;
    final title = lot['title'] as String? ?? '';
    final description = lot['description'] as String?;
    final weightKg = (lot['estimated_weight_kg'] as num?)?.toDouble();
    final locationNote = lot['location_note'] as String?;
    final category = lot['category'] as String? ?? 'other';
    final status = lot['status'] as String? ?? 'active';
    final isSeller = lot['seller_id'] == AuthService.currentUser?.id;
    final bids = _bids;
    final topBid = bids.isEmpty ? null : bids.first;
    final lotCode = '#${(lot['id'] as String).substring(0, 6).toUpperCase()}';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('متابعة المزاد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: Text('رقم اللوط: $lotCode', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            if (status == 'active')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.timer_outlined, size: 12, color: AppColors.categorySos),
                  const SizedBox(width: 4),
                  Text('ينتهي خلال $_formatted', style: const TextStyle(fontSize: 10, color: AppColors.categorySos, fontWeight: FontWeight.w700)),
                ]),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Text('المزاد منتهٍ', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ),
          ]),
          const SizedBox(height: 10),
          Container(
            height: 180,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Icon(Icons.recycling_rounded, size: 40, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.4)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'التصنيف', value: _categoryLabels[category] ?? category),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الوصف التفصيلي', value: (description == null || description.isEmpty) ? '—' : description),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الوزن التقديري', value: weightKg != null ? '${weightKg.toStringAsFixed(0)} كجم' : 'غير محدد'),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الموقع الجغرافي', value: locationNote ?? '—'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أعلى عرض حالي', style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 6),
                Text(topBid != null ? '${NumberFormat('#,##0').format(topBid['amount'])} ج.م' : 'لا توجد عروض بعد', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.storefront_rounded, size: 14, color: Colors.white70),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                    child: Text('${bids.length} عروض', style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (status == 'active' && !isSeller) ...[
            const Text('قدّم عرضك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: TextField(
                    controller: _bidCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'قيمة العرض بالجنيه', border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 13)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _busy ? null : _placeBid,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('إرسال العرض'),
                ),
              ),
            ]),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 11.5)),
            ],
            const SizedBox(height: 12),
          ],
          if (bids.isNotEmpty) ...[
            const Text('سجل العروض', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 8),
            for (final b in bids) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  const Icon(Icons.person_outline_rounded, size: 15, color: AppColors.inkMuted),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b['bidder_id'] == AuthService.currentUser?.id ? 'أنت' : 'مزايد', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                  Text('${NumberFormat('#,##0').format(b['amount'])} ج.م', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.teal)),
                ]),
              ),
            ],
            const SizedBox(height: 8),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 15, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(child: Text('يمكنك قبول العرض الحالي في أي وقت أو الانتظار حتى نهاية المزاد لأفضل سعر.', style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.7))),
            ]),
          ),
          if (isSeller && status == 'active') ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: (_busy || bids.isEmpty) ? null : _acceptTopBid,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text('قبول العرض الحالي وإنهاء المزاد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.5))),
      ],
    );
  }
}
