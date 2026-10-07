import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/recycling/recycling_service.dart';
import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';
import 'scrap_widgets.dart';

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
  bool _loadError = false;
  bool _busy = false;
  String? _error;
  Timer? _timer;

  /// bidder id → business name, for verified scrap dealers (0075).
  Map<String, String> _badges = {};

  /// After acceptance: the seller's contact (for the winner) or the
  /// winner's (for the seller).
  Map<String, dynamic>? _contact;
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
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final lot = await RecyclingService.fetchLot(widget.listingId);
      final bidders = ((lot['recycling_bids'] as List?) ?? const []).map((b) => (b as Map)['bidder_id']).whereType<String>();
      var badges = <String, String>{};
      try {
        badges = await ScrapDealerService.badges(bidders);
      } catch (_) {}
      Map<String, dynamic>? contact;
      final me = AuthService.currentUser?.id;
      if (me != null && lot['status'] != 'active' && lot['winning_bid_id'] != null) {
        try {
          contact = lot['seller_id'] == me
              ? await ScrapDealerService.winnerContact(widget.listingId)
              : await ScrapDealerService.sellerContact(widget.listingId);
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _lot = lot;
        _badges = badges;
        _contact = contact;
        _loading = false;
      });
    } catch (_) {
      // If a lot was already shown (refresh after a bid), build() keeps it.
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
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

  /// What the seller sees: verified dealers' bids first, by amount within
  /// each group. Display only — accepting still takes the top amount.
  List<Map<String, dynamic>> _sellerOrder(List<Map<String, dynamic>> byAmount) {
    final verified = byAmount.where((b) => _badges.containsKey(b['bidder_id'])).toList();
    final others = byAmount.where((b) => !_badges.containsKey(b['bidder_id'])).toList();
    return [...verified, ...others];
  }

  Future<void> _open(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
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
    } catch (e) {
      if (!mounted) return;
      // The server explains why (bid too low, auction ended, your own lot).
      setState(() => _error = e is PostgrestException ? e.message : 'تعذر إرسال العرض، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _acceptTopBid() async {
    setState(() => _busy = true);
    try {
      await RecyclingService.acceptTopBid(widget.listingId);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر إنهاء المزاد، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && _loadError && _lot == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('متابعة المزاد')),
        body: LoadErrorView(onRetry: _load),
      );
    }
    if (_loading || _lot == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final lot = _lot!;
    final title = lot['title'] as String? ?? '';
    final description = lot['description'] as String?;
    final weightKg = (lot['estimated_weight_kg'] as num?)?.toDouble();
    final locationNote = lot['location_note'] as String?;
    final place = scrapPlaceLabel(lot);
    final status = lot['status'] as String? ?? 'active';
    final isSeller = lot['seller_id'] == AuthService.currentUser?.id;
    final bids = _bids;
    final topBid = bids.isEmpty ? null : bids.first;
    final shownBids = isSeller ? _sellerOrder(bids) : bids;
    final me = AuthService.currentUser?.id;
    final winningBidId = lot['winning_bid_id'] as String?;
    final placeText = [place, if (locationNote != null && locationNote.isNotEmpty) locationNote].whereType<String>().join(' — ');
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
                _DetailRow(label: 'نوع الخردة', value: scrapLotMaterialLabel(lot)),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الوصف التفصيلي', value: (description == null || description.isEmpty) ? '—' : description),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الوزن التقديري', value: weightKg != null ? '${weightKg.toStringAsFixed(0)} كجم' : 'غير محدد'),
                const Divider(height: 20, color: AppColors.border),
                _DetailRow(label: 'الموقع الجغرافي', value: placeText.isEmpty ? '—' : placeText),
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
          if (_contact != null) ...[
            _ContactCard(contact: _contact!, forSeller: isSeller, lotTitle: title, onOpen: _open),
            const SizedBox(height: 14),
          ],
          if (bids.isNotEmpty) ...[
            const Text('سجل العروض', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            if (isSeller && _badges.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text('عروض التجار الموثّقين ظاهرة الأول — وقبول العرض بياخد أعلى مبلغ زي ما هو.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            ],
            const SizedBox(height: 8),
            for (final b in shownBids) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: b['id'] == winningBidId ? AppColors.teal.withValues(alpha: 0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: b['id'] == winningBidId ? AppColors.teal : AppColors.border),
                ),
                child: Row(children: [
                  Icon(_badges.containsKey(b['bidder_id']) ? Icons.storefront_rounded : Icons.person_outline_rounded, size: 15, color: AppColors.inkMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        b['bidder_id'] == me ? 'أنت' : (_badges[b['bidder_id']] ?? 'مزايد'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_badges.containsKey(b['bidder_id'])) ...[
                        const SizedBox(height: 3),
                        const _VerifiedDealerBadge(),
                      ],
                    ]),
                  ),
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

class _VerifiedDealerBadge extends StatelessWidget {
  const _VerifiedDealerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
      child: const Text('تاجر موثّق ✓', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
    );
  }
}

/// After acceptance: "كلّم البائع" for the winner, "كلّم المشتري" for the seller.
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact, required this.forSeller, required this.lotTitle, required this.onOpen});
  final Map<String, dynamic> contact;
  final bool forSeller;
  final String lotTitle;
  final Future<void> Function(Uri) onOpen;

  @override
  Widget build(BuildContext context) {
    final name = (contact['business_name'] as String?) ?? (contact['full_name'] as String?) ?? (forSeller ? 'المشتري' : 'البائع');
    final phone = normalizeEgyptMobile(contact['phone'] as String?) ?? normalizeEgyptMobile(contact['whatsapp'] as String?);
    final whatsapp = normalizeEgyptMobile(contact['whatsapp'] as String?) ?? phone;
    final message = forSeller
        ? 'السلام عليكم، بخصوص مزاد «$lotTitle» على مُجتمعي — قبلت عرضك، نتفق على الاستلام؟'
        : 'السلام عليكم، بخصوص مزاد «$lotTitle» على مُجتمعي — عرضي اتقبل، نتفق على الاستلام؟';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(forSeller ? 'كلّم المشتري' : 'مبروك! كلّم البائع', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.teal)),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        if (phone != null) Text(phone, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
        const SizedBox(height: 10),
        if (whatsapp == null)
          const Text('مفيش رقم متسجّل للطرف التاني.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted))
        else
          ScrapContactButtons(phone: phone, whatsapp: whatsapp, message: message, onOpen: onOpen),
      ]),
    );
  }
}
