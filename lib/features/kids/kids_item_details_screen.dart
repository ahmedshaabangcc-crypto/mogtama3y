import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/kids/kids_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'kids_market_screen.dart' show KidsPhotoPlaceholder;

/// One kids-gear listing (`/kids/<id>`, public): photos, details, a safety
/// note on car seats / cribs, and contact — WhatsApp, call, or "أنا مهتم"
/// in the app. Guests sign in to see the phone number.
class KidsItemDetailsScreen extends StatefulWidget {
  const KidsItemDetailsScreen({super.key, required this.listingId, this.initial});
  final String listingId;

  /// The row already loaded by the list, shown while the fresh copy loads.
  final Map<String, dynamic>? initial;

  @override
  State<KidsItemDetailsScreen> createState() => _KidsItemDetailsScreenState();
}

class _KidsItemDetailsScreenState extends State<KidsItemDetailsScreen> {
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
      final c = await KidsService.get(widget.listingId);
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

  /// Signs the guest in (then reloads, so the phone shows up).
  Future<bool> _ensureSignedIn() async {
    if (AuthService.isSignedIn) return true;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!mounted || !AuthService.isSignedIn) return false;
    await _load();
    return mounted && !_isMine;
  }

  Future<void> _interested() async {
    if (!await _ensureSignedIn()) return;
    setState(() => _sending = true);
    try {
      await KidsService.expressInterest(widget.listingId);
      if (!mounted) return;
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('وصّلنا لصاحب الإعلان إنك مهتم، هيتواصل معاك')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الإرسال، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _call() async {
    if (!await _ensureSignedIn()) return;
    final phone = _c?['phone'] as String?;
    if (phone == null) return;
    await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _whatsapp() async {
    if (!await _ensureSignedIn()) return;
    final phone = _c?['phone'] as String?;
    if (phone == null) return;
    await launchUrl(KidsService.whatsappUri(phone, _c!['title'] as String? ?? ''), mode: LaunchMode.externalApplication);
  }

  Future<void> _share() async {
    final c = _c!;
    final url = KidsService.shareUrl(widget.listingId);
    final text = '${c['title']} — ${kidsPrice(c)}\nشوفه على مُجتمعي:\n$url';
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
    final open = c != null && c['is_active'] == true && c['is_sold'] != true && !_isMine;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('مستلزمات أطفال'),
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
      bottomNavigationBar: !open ? null : _contactBar(c),
    );
  }

  Widget _contactBar(Map<String, dynamic> c) {
    final whatsapp = c['phone_on_whatsapp'] != false;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Row(children: [
              if (whatsapp) ...[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1FA855)),
                      onPressed: _whatsapp,
                      icon: const Icon(Icons.chat_rounded),
                      label: const Text('واتساب'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _call,
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('اتصل'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _sent ? AppColors.inkMuted : AppColors.teal),
                    onPressed: _sending || _sent ? null : _interested,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(_sent ? Icons.check_rounded : Icons.thumb_up_alt_rounded),
                    label: Text(_sent ? 'وصّلنا' : 'أنا مهتم'),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _content(Map<String, dynamic> c) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final images = (c['images'] as List?)?.cast<String>() ?? const [];
    final place = [c['area'], c['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final created = DateTime.tryParse(c['created_at'] as String? ?? '');
    final free = c['is_free'] == true;
    final specs = <(IconData, String, String?)>[
      (kidsCategoryIcons[c['category']] ?? Icons.category_rounded, 'القسم', kidsCategories[c['category']]),
      (Icons.new_releases_outlined, 'الحالة', kidsConditions[c['condition']]),
      (Icons.cake_outlined, 'السن', kidsAgeRanges[c['age_range']]),
      (Icons.wc_rounded, 'لـ', kidsGenders[c['gender']]),
      if (c['category'] == 'clothes') (Icons.straighten_rounded, 'المقاس', c['clothes_size'] as String?),
      (Icons.sell_outlined, 'الماركة', c['brand'] as String?),
      (Icons.swap_horiz_rounded, 'بدل', c['swap_allowed'] == true ? 'ممكن أبدّل' : null),
    ].where((s) => s.$3 != null && s.$3!.trim().isNotEmpty).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: width > 760 ? 380 : 250,
            child: images.isEmpty
                ? KidsPhotoPlaceholder(category: c['category'] as String?, size: 64)
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
        if (c['is_sold'] == true || c['is_active'] != true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(c['is_sold'] == true ? (free ? 'الحاجة دي اتسلّمت' : 'الحاجة دي اتباعت') : 'الإعلان ده متوقف',
                style: const TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w800)),
          ),
        Text(c['title'] as String? ?? '', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
        const SizedBox(height: 6),
        Text(free ? 'ببلاش لأي حد محتاج' : kidsPrice(c),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: free ? const Color(0xFF2E7D32) : AppColors.teal)),
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
        if (kidsSafetyCategories.contains(c['category'])) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFB74D)),
            ),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.health_and_safety_rounded, size: 20, color: Color(0xFFE65100)),
              SizedBox(width: 8),
              Expanded(child: Text(kidsSafetyNote, style: TextStyle(fontSize: 12.5, height: 1.6, color: Color(0xFF6D3A00)))),
            ]),
          ),
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
        if (!AuthService.isSignedIn && c['is_active'] == true && c['is_sold'] != true) ...[
          const SizedBox(height: 14),
          const Text('سجّل دخول عشان تشوف رقم صاحب الإعلان وتكلّمه.', style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
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
                'نصيحة: قابل صاحب الإعلان في مكان عام وعاين الحاجة بنفسك، ومتحوّلش فلوس قبل ما تستلم.',
                style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
