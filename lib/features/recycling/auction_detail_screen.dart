import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Read-only auction-tracking view for the seller — a resident's-eye
/// view of the lot detail shown to dealers in
/// design/screens/20_recycling_auction_bidding.png.
class AuctionDetailScreen extends StatefulWidget {
  const AuctionDetailScreen({
    super.key,
    required this.title,
    required this.lotNumber,
    required this.description,
    required this.weightNote,
    required this.location,
    required this.currentBid,
    required this.bidderName,
    required this.offerCount,
    required Duration remaining,
  }) : _initialRemaining = remaining;

  final String title, lotNumber, description, weightNote, location, bidderName;
  final int currentBid, offerCount;
  final Duration _initialRemaining;

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  late Duration _remaining = widget._initialRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) return;
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text('رقم اللوط: ${widget.lotNumber}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.timer_outlined, size: 12, color: AppColors.categorySos),
                const SizedBox(width: 4),
                Text('ينتهي خلال $_formatted', style: const TextStyle(fontSize: 10, color: AppColors.categorySos, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            height: 180,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Icon(Icons.recycling_rounded, size: 40, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 14),
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.4)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'الوصف التفصيلي', value: widget.description),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الوزن التقديري', value: widget.weightNote),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الموقع الجغرافي', value: widget.location),
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
                Text('${widget.currentBid} ج.م', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.storefront_rounded, size: 14, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text('آخر مزايد: ${widget.bidderName}', style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                    child: Text('${widget.offerCount} عروض تجار', style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 15, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(child: Text('العروض تصل من تجار البيكيا المعتمدين تلقائياً. يمكنك قبول العرض الحالي في أي وقت أو الانتظار حتى نهاية المزاد لأفضل سعر.', style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.7))),
            ]),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text('قبول العرض الحالي وإنهاء المزاد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
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
