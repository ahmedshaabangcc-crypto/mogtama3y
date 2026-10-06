import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/halls/hall_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'halls_market_screen.dart' show HallPhotoPlaceholder;

/// One event hall (`/halls/<id>`, public): photo gallery, what it suits,
/// capacity, price, what's included, and contact — call, WhatsApp, or an
/// in-app "أنا مهتم" to the owner.
class HallDetailsScreen extends StatefulWidget {
  const HallDetailsScreen({super.key, required this.hallId, this.initial});
  final String hallId;

  /// The row already loaded by the list, shown while the fresh copy loads.
  final Map<String, dynamic>? initial;

  @override
  State<HallDetailsScreen> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  final _pager = PageController();
  Map<String, dynamic>? _h;
  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _sent = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _h = widget.initial;
    _loading = _h == null;
    _load();
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final h = await HallService.get(widget.hallId);
      if (!mounted) return;
      setState(() {
        _h = h;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _h == null;
      });
    }
  }

  bool get _isMine => _h != null && _h!['owner_id'] == AuthService.currentUser?.id;

  Future<void> _interested() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!mounted || !AuthService.isSignedIn) return;
      setState(() {});
      if (_isMine) return;
    }
    setState(() => _sending = true);
    try {
      await HallService.expressInterest(widget.hallId);
      if (!mounted) return;
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('وصّلنا لصاحب القاعة إنك مهتم، هيتواصل معاك')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الإرسال، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _call(String phone) => launchUrl(Uri.parse('tel:$phone'));

  void _whatsapp(String number) {
    final text = 'السلام عليكم، شفت «${_h!['name']}» على مُجتمعي وعايز أستفسر عن الحجز والأسعار.\n${HallService.shareUrl(widget.hallId)}';
    launchUrl(Uri.parse('https://wa.me/2$number?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  Future<void> _share() async {
    final h = _h!;
    final url = HallService.shareUrl(widget.hallId);
    final text = '${h['name']} — ${hallPrice(h)}\nشوفها على مُجتمعي:\n$url';
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(leading: Icon(Icons.check_circle_rounded, color: AppColors.teal), title: Text('اتنسخ لينك القاعة')),
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
    final h = _h;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('قاعة مناسبات'),
        actions: [if (h != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك')],
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
              : h == null
                  ? const Center(child: Text('القاعة دي مش موجودة أو اتشالت', style: TextStyle(color: AppColors.inkMuted)))
                  : _content(h),
      bottomNavigationBar: h == null || h['is_active'] != true || _isMine ? null : _contactBar(h),
    );
  }

  Widget _contactBar(Map<String, dynamic> h) {
    final phone = h['phone'] as String?;
    final whatsapp = h['whatsapp'] as String?;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SizedBox(
              height: 50,
              child: Row(children: [
                if (whatsapp != null && whatsapp.isNotEmpty) ...[
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1FA855)),
                      onPressed: () => _whatsapp(whatsapp),
                      icon: const Icon(Icons.chat_rounded),
                      label: const Text('واتساب'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (phone != null && phone.isNotEmpty) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _call(phone),
                      icon: const Icon(Icons.call_rounded),
                      label: const Text('اتصل'),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _sent ? AppColors.inkMuted : AppColors.teal),
                    onPressed: _sending || _sent ? null : _interested,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(_sent ? Icons.check_rounded : Icons.thumb_up_alt_rounded),
                    label: Text(_sent ? 'وصّلناه' : 'أنا مهتم'),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gallery(List<String> images, double height) {
    if (images.isEmpty) return SizedBox(height: height, child: const HallPhotoPlaceholder(size: 64));
    return SizedBox(
        height: height,
        child: Stack(children: [
          PageView.builder(
            controller: _pager,
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
      );
  }

  Widget _thumbs(List<String> images) => SizedBox(
        height: 58,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => _pager.animateToPage(i, duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
            child: Container(
              width: 74,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: i == _page ? AppColors.teal : AppColors.border, width: i == _page ? 2 : 1),
              ),
              child: Image.network(images[i], cacheWidth: 200, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.surfaceAlt)),
            ),
          ),
        ),
      );

  Widget _tag(String label, {IconData? icon}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 15, color: AppColors.teal), const SizedBox(width: 5)],
          Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink)),
        ]),
      );

  Widget _heading(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
      );

  Widget _content(Map<String, dynamic> h) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final images = (h['images'] as List?)?.cast<String>() ?? const [];
    final occasions = (h['occasions'] as List?)?.cast<String>() ?? const [];
    final included = (h['included'] as List?)?.cast<String>() ?? const [];
    final place = [h['area'], h['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final address = (h['address'] as String?)?.trim() ?? '';

    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(16), child: _gallery(images, width > 760 ? 380 : 250)),
        if (images.length > 1) ...[const SizedBox(height: 8), _thumbs(images)],
        const SizedBox(height: 14),
        if (h['is_active'] != true)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('القاعة دي مخفية دلوقتي — مش ظاهرة للناس', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w800)),
          ),
        Text(h['name'] as String? ?? '', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
        const SizedBox(height: 4),
        Text(hallTypes[h['hall_type']] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(hallPrice(h), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.teal)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.groups_outlined, size: 16, color: AppColors.inkSecondary),
          const SizedBox(width: 4),
          Text('السعة: ${hallCapacity(h)}', style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary)),
        ]),
        if (place.isNotEmpty || address.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.place_outlined, size: 16, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            Expanded(
              child: Text([if (address.isNotEmpty) address, if (place.isNotEmpty) place].join(' — '),
                  style: const TextStyle(color: AppColors.inkMuted, fontSize: 13, height: 1.5)),
            ),
          ]),
        ],
        if (occasions.isNotEmpty) ...[
          _heading('تنفع لـ'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final o in occasions)
              if (hallOccasions[o] != null) _tag(hallOccasions[o]!, icon: Icons.celebration_outlined),
          ]),
        ],
        if (included.isNotEmpty) ...[
          _heading('متضمن'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in included)
              if (hallIncluded[t] != null) _tag(hallIncluded[t]!, icon: hallIncludedIcons[t]),
          ]),
        ],
        if ((h['description'] as String?)?.trim().isNotEmpty == true) ...[
          _heading('التفاصيل'),
          Text(h['description'] as String, style: const TextStyle(fontSize: 14, height: 1.7, color: AppColors.inkSecondary)),
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
                'نصيحة: زور القاعة بنفسك واتفق على كل التفاصيل والمواعيد في عقد مكتوب قبل ما تدفع أي عربون.',
                style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
