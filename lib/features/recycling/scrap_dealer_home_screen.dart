import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'auction_detail_screen.dart';
import 'scrap_dealer_register_screen.dart';
import 'scrap_widgets.dart';

String _money(num v) => '${NumberFormat('#,##0').format(v)} ج.م';

/// «لوحة تاجر الخردة» (/#/scrap-dealer): the dealer's status, what they
/// buy and where, the active lots matching them, their bids (top / outbid
/// / accepted) and — for accepted lots — the seller's contact. Shows a
/// short pitch + "سجّل" for users who aren't dealers yet. Migration 0075.
class ScrapDealerHomeScreen extends StatefulWidget {
  const ScrapDealerHomeScreen({super.key});

  @override
  State<ScrapDealerHomeScreen> createState() => _ScrapDealerHomeScreenState();
}

class _ScrapDealerHomeScreenState extends State<ScrapDealerHomeScreen> {
  bool _loading = true;
  bool _error = false;
  Map<String, dynamic>? _dealer;
  List<Map<String, dynamic>> _matching = [];
  List<Map<String, dynamic>> _bids = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final dealer = await ScrapDealerService.myDealer();
      final results = await Future.wait([
        dealer == null ? Future.value(<Map<String, dynamic>>[]) : ScrapDealerService.matchingLots(),
        ScrapDealerService.myBids(),
      ]);
      if (!mounted) return;
      setState(() {
        _dealer = dealer;
        _matching = results[0];
        _bids = results[1];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _openRegister() async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ScrapDealerRegisterScreen(existing: _dealer)));
    if (saved == true) _load();
  }

  Future<void> _openLot(String id) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuctionDetailScreen(listingId: id)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    Widget body;
    if (!AuthService.isSignedIn) {
      body = _Pitch(
        buttonLabel: 'سجّل دخول الأول',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
      );
    } else if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error) {
      body = LoadErrorView(onRetry: _load);
    } else if (_dealer == null) {
      body = _Pitch(buttonLabel: 'سجّل كتاجر خردة', onTap: _openRegister, bids: _bids, onOpenLot: _openLot);
    } else {
      final accepted = _bids.where((b) => b['won'] == true).toList();
      final others = _bids.where((b) => b['won'] != true).toList();
      body = RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 32),
          children: [
            _Header(dealer: _dealer!, onEdit: _openRegister),
            const SizedBox(height: 18),
            _SectionTitle('مزادات مطابقة ليك', _matching.length),
            if (_matching.isEmpty)
              const _Empty('مفيش مزادات نشطة مطابقة دلوقتي — هيوصلك إشعار أول ما ينزل مزاد في منطقتك.')
            else
              for (final lot in _matching) _MatchingLotTile(lot: lot, onTap: () => _openLot(lot['id'] as String)),
            const SizedBox(height: 18),
            _SectionTitle('اتقبلت', accepted.length),
            if (accepted.isEmpty)
              const _Empty('لسه مفيش عروض اتقبلت.')
            else
              for (final b in accepted) _AcceptedTile(bid: b, onOpenLot: () => _openLot(b['listing_id'] as String)),
            const SizedBox(height: 18),
            _SectionTitle('عروضي', others.length),
            if (others.isEmpty)
              const _Empty('مقدّمتش عروض لسه.')
            else
              for (final b in others) _BidTile(bid: b, onTap: () => _openLot(b['listing_id'] as String)),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تاجر الخردة')),
      body: body,
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch({required this.buttonLabel, required this.onTap, this.bids = const [], this.onOpenLot});
  final String buttonLabel;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> bids;
  final void Function(String id)? onOpenLot;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    final accepted = bids.where((b) => b['won'] == true).toList();
    return ListView(
      padding: EdgeInsets.fromLTRB(side, 16, side, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFF0E4A38), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.recycling_rounded, color: AppColors.tealLight, size: 30),
            const SizedBox(height: 10),
            const Text('تاجر خردة؟ سجّل هنا', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 8),
            for (final line in const [
              'إشعار فوري بكل مزاد خردة جديد في منطقتك (حديد، نحاس، ألومنيوم، كرتون…)',
              'علامة «تاجر موثّق ✓» جنب عروضك، والبائع بيشوف عروض الموثّقين الأول',
              'رقم البائع بيوصلك أول ما يقبل عرضك',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_rounded, size: 16, color: AppColors.tealLight),
                  const SizedBox(width: 6),
                  Expanded(child: Text(line, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.6))),
                ]),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.tealLight, foregroundColor: const Color(0xFF0E4A38)),
                child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ]),
        ),
        if (accepted.isNotEmpty && onOpenLot != null) ...[
          const SizedBox(height: 18),
          _SectionTitle('اتقبلت', accepted.length),
          for (final b in accepted) _AcceptedTile(bid: b, onOpenLot: () => onOpenLot!(b['listing_id'] as String)),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dealer, required this.onEdit});
  final Map<String, dynamic> dealer;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final status = dealer['status'] as String? ?? 'pending';
    final note = dealer['review_note'] as String?;
    final materials = ((dealer['materials'] as List?) ?? const []).cast<String>();
    final areas = ((dealer['areas'] as List?) ?? const []).cast<String>();
    final governorate = dealer['governorate'] as String?;
    final radius = (dealer['radius_km'] as num?)?.toDouble();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(dealer['business_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
          ScrapDealerStatusBadge(status: status),
        ]),
        if (status == 'pending') ...[
          const SizedBox(height: 6),
          const Text('طلبك قيد المراجعة — إشعارات المزادات شغالة معاك من دلوقتي.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        ],
        if (status == 'rejected') ...[
          const SizedBox(height: 6),
          Text(note == null || note.isEmpty ? 'طلبك اترفض — عدّل بياناتك وابعته تاني.' : 'سبب الرفض: $note',
              style: const TextStyle(fontSize: 11.5, color: Color(0xFFC62828))),
        ],
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [for (final m in materials) ScrapChip(scrapMaterials[m] ?? m)]),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.place_outlined, size: 15, color: AppColors.inkMuted),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              [
                if (governorate != null) areas.isEmpty ? 'كل $governorate' : '$governorate: ${areas.join('، ')}',
                if (radius != null) 'في نطاق ${radius.toStringAsFixed(0)} كم من موقعك',
              ].join(' • '),
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.5),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 16), label: const Text('تعديل البيانات')),
        ),
      ]),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.count);
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5))),
        Text('$count', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
      ]),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.6)),
    );
  }
}

String _remaining(String? iso) {
  final end = DateTime.tryParse(iso ?? '');
  if (end == null) return '';
  final d = end.difference(DateTime.now().toUtc());
  if (d.isNegative) return 'انتهى';
  if (d.inHours >= 24) return 'فاضل ${d.inDays} يوم';
  if (d.inHours >= 1) return 'فاضل ${d.inHours} ساعة';
  return 'فاضل ${d.inMinutes} دقيقة';
}

class _MatchingLotTile extends StatelessWidget {
  const _MatchingLotTile({required this.lot, required this.onTap});
  final Map<String, dynamic> lot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = lot['top_amount'] as num?;
    final mine = lot['my_amount'] as num?;
    final weight = (lot['estimated_weight_kg'] as num?)?.toDouble();
    final distance = (lot['distance_km'] as num?)?.toDouble();
    final place = scrapPlaceLabel(lot);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.recycling_rounded, color: AppColors.teal, size: 20)),
        title: Text(lot['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Text(
          [
            scrapLotMaterialLabel(lot),
            ?place,
            if (weight != null) '~${weight.toStringAsFixed(0)} كجم',
            if (distance != null) '${distance.toStringAsFixed(distance < 10 ? 1 : 0)} كم',
            _remaining(lot['auction_ends_at'] as String?),
          ].join(' • '),
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(top == null ? 'مفيش عروض' : _money(top), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.teal)),
          if (mine != null) Text(mine >= (top ?? 0) ? 'إنت الأعلى' : 'عرضك ${_money(mine)}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
        ]),
      ),
    );
  }
}

class _BidTile extends StatelessWidget {
  const _BidTile({required this.bid, required this.onTap});
  final Map<String, dynamic> bid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mine = (bid['my_amount'] as num?) ?? 0;
    final top = (bid['top_amount'] as num?) ?? 0;
    final active = bid['status'] == 'active';
    final (label, color) = !active
        ? ('المزاد خلص', AppColors.inkMuted)
        : mine >= top
            ? ('الأعلى', AppColors.teal)
            : ('اتعدّى', const Color(0xFFC62828));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(bid['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Text('عرضك ${_money(mine)} • أعلى عرض ${_money(top)}', style: const TextStyle(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
          child: Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
        ),
      ),
    );
  }
}

/// An accepted bid: "كلّم البائع" fetches the seller's phone (only the
/// winner gets it, server-checked).
class _AcceptedTile extends StatefulWidget {
  const _AcceptedTile({required this.bid, required this.onOpenLot});
  final Map<String, dynamic> bid;
  final VoidCallback onOpenLot;

  @override
  State<_AcceptedTile> createState() => _AcceptedTileState();
}

class _AcceptedTileState extends State<_AcceptedTile> {
  Map<String, dynamic>? _contact;
  bool _loading = false;
  bool _missing = false;

  Future<void> _reveal() async {
    setState(() => _loading = true);
    try {
      final c = await ScrapDealerService.sellerContact(widget.bid['listing_id'] as String);
      if (!mounted) return;
      setState(() {
        _contact = c;
        _missing = c == null || normalizeEgyptMobile(c['phone'] as String?) == null;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر جلب رقم البائع، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.bid;
    final title = b['title'] as String? ?? '';
    final phone = normalizeEgyptMobile(_contact?['phone'] as String?);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: widget.onOpenLot,
            child: Row(children: [
              const Icon(Icons.emoji_events_rounded, color: AppColors.teal, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
              Text(_money((b['my_amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.teal)),
            ]),
          ),
          const SizedBox(height: 8),
          if (phone != null) ...[
            Text('${_contact?['full_name'] ?? 'البائع'} — $phone', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ScrapContactButtons(
              phone: phone,
              whatsapp: phone,
              message: 'السلام عليكم، بخصوص مزاد «$title» على مُجتمعي — عرضي اتقبل، نتفق على الاستلام؟',
              onOpen: (uri) async {
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (_) {}
              },
            ),
          ] else if (_missing)
            const Text('البائع مسجّلش رقم — هيتواصل معاك من خلال الإشعارات.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted))
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _reveal,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                icon: _loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.call_rounded, size: 16),
                label: const Text('كلّم البائع'),
              ),
            ),
        ]),
      ),
    );
  }
}
