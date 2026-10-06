import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/pets/pet_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_pet_listing_screen.dart';

/// One pet listing (`/pets/<id>`, public): photos, details, last-seen box
/// for lost / found, contact (WhatsApp, call, in-app "أنا مهتم") and a
/// share link.
class PetDetailsScreen extends StatefulWidget {
  const PetDetailsScreen({super.key, required this.listingId, this.initial});
  final String listingId;

  /// The row already loaded by the list, shown while the fresh copy loads.
  final Map<String, dynamic>? initial;

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  Map<String, dynamic>? _c;
  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _sent = false;
  bool _gettingPhone = false;
  String? _phone;
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
      final c = await PetService.get(widget.listingId);
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

  /// Signs in if needed; false if the user backed out (or it's their own).
  Future<bool> _ensureSignedIn() async {
    if (AuthService.isSignedIn) return true;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!mounted || !AuthService.isSignedIn) return false;
    setState(() {});
    return !_isMine;
  }

  Future<String?> _getPhone() async {
    if (_phone != null) return _phone;
    if (!await _ensureSignedIn()) return null;
    setState(() => _gettingPhone = true);
    try {
      final p = await PetService.phone(widget.listingId);
      if (mounted) setState(() => _phone = p);
      if (p == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الإعلان ده مبقاش متاح')));
      }
      return p;
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر جلب الرقم، جرّب تاني')));
      return null;
    } finally {
      if (mounted) setState(() => _gettingPhone = false);
    }
  }

  Future<void> _call() async {
    final p = await _getPhone();
    if (p == null) return;
    await launchUrl(Uri.parse('tel:$p'));
  }

  Future<void> _whatsapp() async {
    final p = await _getPhone();
    if (p == null) return;
    final c = _c!;
    final text = 'السلام عليكم، شفت إعلانك «${c['title']}» على مُجتمعي:\n${PetService.shareUrl(widget.listingId)}';
    await launchUrl(Uri.parse('https://wa.me/2$p?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
  }

  Future<void> _interested() async {
    if (!await _ensureSignedIn()) return;
    setState(() => _sending = true);
    try {
      await PetService.expressInterest(widget.listingId);
      if (!mounted) return;
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('وصّلنا لصاحب الإعلان رسالتك، هيتواصل معاك')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الإرسال، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => AddPetListingScreen(initial: _c)));
    if (saved == true) _load();
  }

  Future<void> _share() async {
    final c = _c!;
    final url = PetService.shareUrl(widget.listingId);
    final text = '${c['title']} — ${petPrice(c)}\nشوفه على مُجتمعي:\n$url';
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
        title: const Text('إعلان حيوان أليف'),
        actions: [
          if (c != null && _isMine) IconButton(onPressed: _edit, icon: const Icon(Icons.edit_outlined), tooltip: 'عدّل الإعلان'),
          if (c != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك'),
        ],
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
      bottomNavigationBar: c == null || c['is_active'] != true || _isMine ? null : _contactBar(c),
    );
  }

  Widget _contactBar(Map<String, dynamic> c) {
    final kind = c['kind'] as String?;
    final interestLabel = switch (kind) {
      'lost' => 'عندي معلومة',
      'found' => 'ده بتاعي',
      _ => 'أنا مهتم',
    };
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Row(children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _sent ? AppColors.inkMuted : AppColors.teal),
                    onPressed: _sending || _sent ? null : _interested,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(_sent ? Icons.check_rounded : Icons.notifications_active_outlined, size: 18),
                    label: Text(_sent ? 'وصّلنا رسالتك' : interestLabel),
                  ),
                ),
              ),
              if (c['has_whatsapp'] == true) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _gettingPhone ? null : _whatsapp,
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Icon(Icons.chat_rounded, size: 20, color: Color(0xFF1FA855)),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 48,
                child: OutlinedButton(
                  onPressed: _gettingPhone ? null : _call,
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                  child: _gettingPhone
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.call_outlined, size: 20, color: AppColors.navy),
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
    final kind = c['kind'] as String?;
    final supplies = kind == 'supplies';
    final place = [c['area'], c['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final created = DateTime.tryParse(c['created_at'] as String? ?? '');
    final lastSeen = DateTime.tryParse(c['last_seen_date'] as String? ?? '');
    final price = petPrice(c);
    final specs = <(IconData, String, String?)>[
      (Icons.sell_outlined, 'نوع الإعلان', petKinds[kind]),
      (petAnimalIcon(c['animal'] as String?), supplies ? 'لأنهي حيوان' : 'الحيوان', petAnimals[c['animal']]),
      if (!supplies) ...[
        (Icons.category_outlined, 'السلالة', c['breed'] as String?),
        (Icons.cake_outlined, 'السن', c['age_text'] as String?),
        (Icons.wc_rounded, 'النوع', petGenders[c['gender']]),
        (Icons.vaccines_outlined, 'متطعّم', c['vaccinated'] == true ? 'أيوه' : 'لأ'),
      ] else
        (Icons.new_releases_outlined, 'الحالة', petConditions[c['condition']]),
    ].where((s) => s.$3 != null && s.$3!.trim().isNotEmpty).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: width > 760 ? 380 : 250,
            child: images.isEmpty
                ? ColoredBox(
                    color: AppColors.surfaceAlt,
                    child: Center(child: Icon(petAnimalIcon(c['animal'] as String?), size: 64, color: AppColors.inkMuted)),
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
        if (c['is_active'] != true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              c['outcome'] != null ? 'الإعلان ده اتقفل: ${petOutcomes[c['outcome']] ?? ''}' : 'الإعلان ده متوقف',
              style: const TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w800),
            ),
          ),
        Text(c['title'] as String? ?? '', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
        if (price.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, children: [
            Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.teal)),
            if (c['negotiable'] == true && !petKindIsFree(kind))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(8)),
                child: const Text('قابل للتفاوض', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.teal)),
              ),
          ]),
        ],
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
        if (petKindIsLostFound(kind)) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (kind == 'lost' ? const Color(0xFFC62828) : const Color(0xFF2E7D32)).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(kind == 'lost' ? Icons.search_rounded : Icons.volunteer_activism_outlined,
                  size: 20, color: kind == 'lost' ? const Color(0xFFC62828) : const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(kind == 'lost' ? 'آخر مرة اتشاف' : 'اتلقى',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (lastSeen != null) DateFormat('d/M/yyyy').format(lastSeen),
                      if ((c['last_seen_area'] as String?)?.trim().isNotEmpty == true) c['last_seen_area'] as String,
                    ].join(' · '),
                    style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kind == 'lost' ? 'لو شفته، دوس "عندي معلومة" أو كلّم صاحبه على طول.' : 'لو ده بتاعك، دوس "ده بتاعي" وجهّز صورة ليه تثبت إنه بتاعك.',
                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                  ),
                ]),
              ),
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
        if (kind == 'sale' || kind == 'mating' || supplies) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.shield_outlined, size: 18, color: AppColors.inkSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  supplies
                      ? 'نصيحة: ماتحوّلش فلوس قبل ما تشوف الحاجة وتتأكد من حالتها بنفسك.'
                      : 'نصيحة: ماتحوّلش فلوس قبل ما تشوف الحيوان بنفسك، واتأكد من صحته وشهادة التطعيمات، وقابل البايع في مكان عام.',
                  style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary),
                ),
              ),
            ]),
          ),
        ],
      ],
    );
  }
}
