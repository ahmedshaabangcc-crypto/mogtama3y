import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/cars/car_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';

/// One car listing (`/cars/<id>`, public): photos, specs, "أنا مهتم" and
/// a share link.
class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key, required this.listingId, this.initial});
  final String listingId;

  /// The row already loaded by the list, shown while the fresh copy loads.
  final Map<String, dynamic>? initial;

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  Map<String, dynamic>? _c;
  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _sent = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _c = widget.initial;
    _loading = _c == null;
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await CarService.get(widget.listingId);
      if (!mounted) return;
      setState(() {
        _c = c;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _c == null;
      });
    }
  }

  bool get _isMine => _c != null && _c!['owner_id'] == AuthService.currentUser?.id;

  Future<void> _interested() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!mounted || !AuthService.isSignedIn) return;
      setState(() {});
      if (_isMine) return;
    }
    setState(() => _sending = true);
    try {
      await CarService.expressInterest(widget.listingId);
      if (!mounted) return;
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('وصّلنا لصاحب الإعلان إنك مهتم، هيتواصل معاك')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الإرسال، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _share() async {
    final c = _c!;
    final url = CarService.shareUrl(widget.listingId);
    final text = '${c['title']} — ${carPrice(c['price'] as num?)}${carPriceSuffix(c['offer_type'] as String?)}\nشوفه على مُجتمعي:\n$url';
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(leading: Icon(Icons.check_circle_rounded, color: AppColors.teal), title: Text('اتنسخ لينك الإعلان')),
          ListTile(
            leading: const Icon(Icons.chat_rounded, color: Color(0xFF1FA855)),
            title: const Text('ابعته على واتساب'),
            onTap: () {
              Navigator.pop(ctx);
              launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2)),
            title: const Text('شاركه على فيسبوك'),
            onTap: () {
              Navigator.pop(ctx);
              launchUrl(Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}'), mode: LaunchMode.externalApplication);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('إعلان سيارة'),
        actions: [if (c != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك')],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: () {
                  setState(() {
                    _loading = true;
                    _error = false;
                  });
                  _load();
                })
              : c == null
                  ? const Center(child: Text('الإعلان ده مش موجود أو اتشال', style: TextStyle(color: AppColors.inkMuted)))
                  : _content(c),
      bottomNavigationBar: c == null || c['status'] != 'active' || _isMine
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: _sent ? AppColors.inkMuted : AppColors.teal),
                        onPressed: _sending || _sent ? null : _interested,
                        icon: _sending
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Icon(_sent ? Icons.check_rounded : Icons.thumb_up_alt_rounded),
                        label: Text(_sent ? 'وصّلنا اهتمامك' : 'أنا مهتم'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _content(Map<String, dynamic> c) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final images = (c['images'] as List?)?.cast<String>() ?? const [];
    final parts = c['offer_type'] == 'parts';
    final place = [c['area'], c['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final created = DateTime.tryParse(c['created_at'] as String? ?? '');
    final specs = <(IconData, String, String?)>[
      (Icons.sell_outlined, 'نوع الإعلان', carOfferTypes[c['offer_type']]),
      (Icons.two_wheeler_rounded, 'نوع المركبة', carVehicleTypes[c['vehicle_type']]),
      (Icons.directions_car_outlined, 'الماركة', c['brand'] as String?),
      (Icons.badge_outlined, 'الموديل', c['model'] as String?),
      if (!parts) ...[
        (Icons.calendar_today_outlined, 'سنة الصنع', c['year']?.toString()),
        (Icons.speed_rounded, 'العداد', c['km'] == null ? null : '${NumberFormat('#,##0').format(c['km'])} كم'),
        (Icons.settings_outlined, 'ناقل الحركة', carTransmissions[c['transmission']]),
        (Icons.local_gas_station_outlined, 'الوقود', carFuels[c['fuel']]),
        (Icons.airport_shuttle_outlined, 'شكل العربية', carBodyTypes[c['body_type']]),
        (Icons.palette_outlined, 'اللون', c['color'] as String?),
      ],
      (Icons.new_releases_outlined, 'الحالة', carConditions[c['condition']]),
      if (c['offer_type'] == 'rent_daily' || c['offer_type'] == 'rent_monthly')
        (Icons.person_outline_rounded, 'بسواق', c['with_driver'] == null ? null : (c['with_driver'] == true ? 'أيوه' : 'لأ')),
      (Icons.payments_outlined, 'طريقة الدفع', carPayments[c['payment']]),
    ].where((s) => s.$3 != null && s.$3!.trim().isNotEmpty).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: width > 760 ? 380 : 250,
            child: images.isEmpty
                ? const ColoredBox(
                    color: AppColors.surfaceAlt,
                    child: Center(child: Icon(Icons.directions_car_filled_rounded, size: 64, color: AppColors.inkMuted)),
                  )
                : Stack(children: [
                    PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (_, i) => Image.network(
                        images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt, child: Center(child: Icon(Icons.broken_image_outlined))),
                      ),
                    ),
                    if (images.length > 1)
                      PositionedDirectional(
                        bottom: 10,
                        start: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                          child: Text('${_page + 1} / ${images.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                  ]),
          ),
        ),
        const SizedBox(height: 14),
        if (c['status'] != 'active')
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(c['status'] == 'sold' ? 'الإعلان ده اتباع' : 'الإعلان ده اتشال',
                style: const TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w800)),
          ),
        Text(c['title'] as String? ?? '', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
        const SizedBox(height: 6),
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, children: [
          Text('${carPrice(c['price'] as num?)}${carPriceSuffix(c['offer_type'] as String?)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.teal)),
          if (c['negotiable'] == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(8)),
              child: const Text('قابل للتفاوض', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.teal)),
            ),
        ]),
        if (place.isNotEmpty || created != null) ...[
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.place_outlined, size: 15, color: AppColors.inkMuted),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                [if (place.isNotEmpty) place, if (created != null) DateFormat('d/M/yyyy').format(created.toLocal())].join(' · '),
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
              ),
            ),
          ]),
        ],
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, box) {
          final cols = box.maxWidth >= 560 ? 3 : 2;
          final w = (box.maxWidth - (cols - 1) * 8) / cols;
          return Wrap(spacing: 8, runSpacing: 8, children: [
            for (final (icon, label, value) in specs)
              Container(
                width: w,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Icon(icon, size: 18, color: AppColors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                      Text(value!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    ]),
                  ),
                ]),
              ),
          ]);
        }),
        if ((c['description'] as String?)?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 18),
          const Text('التفاصيل', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 6),
          Text(c['description'] as String, style: const TextStyle(fontSize: 14, height: 1.7, color: AppColors.inkSecondary)),
        ],
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.shield_outlined, size: 18, color: AppColors.inkSecondary),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'نصيحة: عاين العربية وافحص الورق والرخصة قبل ما تدفع أي فلوس، ومتحوّلش عربون لحد ما تشوفها بنفسك.',
                style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
