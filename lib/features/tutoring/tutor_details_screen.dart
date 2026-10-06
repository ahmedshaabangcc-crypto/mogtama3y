import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tutoring/tutoring_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'tutoring_market_screen.dart' show TutorPhotoPlaceholder;

/// One tutor listing (`/tutoring/<id>`, public): photos, subjects, stages,
/// price, bio, and ways to reach the tutor — WhatsApp, a call, or an
/// in-app "عايز أحجز" notification — plus a share link.
class TutorDetailsScreen extends StatefulWidget {
  const TutorDetailsScreen({super.key, required this.listingId, this.initial});
  final String listingId;

  /// The row already loaded by the list, shown while the fresh copy loads.
  final Map<String, dynamic>? initial;

  @override
  State<TutorDetailsScreen> createState() => _TutorDetailsScreenState();
}

class _TutorDetailsScreenState extends State<TutorDetailsScreen> {
  Map<String, dynamic>? _t;
  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _sent = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _t = widget.initial;
    _loading = _t == null;
    _load();
  }

  Future<void> _load() async {
    try {
      final t = await TutoringService.get(widget.listingId);
      if (!mounted) return;
      setState(() {
        _t = t;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _t == null;
      });
    }
  }

  bool get _isMine => _t != null && _t!['owner_id'] == AuthService.currentUser?.id;

  Future<void> _book() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!mounted || !AuthService.isSignedIn) return;
      setState(() {});
      if (_isMine) return;
    }
    setState(() => _sending = true);
    try {
      await TutoringService.expressInterest(widget.listingId);
      if (!mounted) return;
      setState(() => _sent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('وصّلنا للمدرس إنك عايز تحجز، وممكن تكلّمه واتساب دلوقتي')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الإرسال، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _whatsapp(String number) {
    final t = _t!;
    final msg = 'السلام عليكم، شفت إعلانك على مُجتمعي (${tutorLabels(t['subjects'], tutorSubjects)}) وعايز أسأل عن الدروس.';
    launchUrl(Uri.parse('https://wa.me/2$number?text=${Uri.encodeComponent(msg)}'), mode: LaunchMode.externalApplication);
  }

  void _call(String number) => launchUrl(Uri.parse('tel:$number'));

  Future<void> _share() async {
    final t = _t!;
    final url = TutoringService.shareUrl(widget.listingId);
    final text = '${t['tutor_name']} — ${tutorLabels(t['subjects'], tutorSubjects)}\n${tutorPrice(t['price'] as num?, t['price_unit'] as String?)}\nشوفه على مُجتمعي:\n$url';
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
    final t = _t;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('مدرس خصوصي'),
        actions: [if (t != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك')],
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
              : t == null
                  ? const Center(child: Text('الإعلان ده مش موجود أو اتشال', style: TextStyle(color: AppColors.inkMuted)))
                  : _content(t),
      bottomNavigationBar: t == null || t['is_active'] != true || _isMine ? null : _contactBar(t),
    );
  }

  Widget _contactBar(Map<String, dynamic> t) {
    final whatsapp = (t['whatsapp'] as String?) ?? (t['phone'] as String?);
    final phone = (t['phone'] as String?) ?? (t['whatsapp'] as String?);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Row(children: [
              if (whatsapp != null) ...[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1FA855)),
                      onPressed: () => _whatsapp(whatsapp),
                      icon: const Icon(Icons.chat_rounded),
                      label: const Text('واتساب'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (phone != null) ...[
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => _call(phone),
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('اتصل'),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _sent ? AppColors.inkMuted : AppColors.teal),
                    onPressed: _sending || _sent ? null : _book,
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(_sent ? Icons.check_rounded : Icons.event_available_rounded),
                    label: Text(_sent ? 'وصل طلبك' : 'عايز أحجز'),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _content(Map<String, dynamic> t) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final images = (t['images'] as List?)?.cast<String>() ?? const [];
    final avatar = t['tutor_avatar'] as String?;
    final place = [t['area'], t['governorate']].whereType<String>().where((s) => s.trim().isNotEmpty).join('، ');
    final created = DateTime.tryParse(t['created_at'] as String? ?? '');
    final years = t['experience_years'] as int?;
    final specs = <(IconData, String, String?)>[
      (Icons.menu_book_rounded, 'المواد', tutorLabels(t['subjects'], tutorSubjects)),
      (Icons.stairs_outlined, 'المراحل', tutorLabels(t['stages'], tutorStages)),
      (Icons.translate_rounded, 'المنهج', tutorLabels(t['curricula'], tutorCurricula)),
      (Icons.home_work_outlined, 'مكان الدرس', tutorLabels(t['modes'], tutorModes)),
      (Icons.workspace_premium_outlined, 'سنين الخبرة', years == null ? null : (years == 0 ? 'لسه بادئ' : '$years سنة')),
      (Icons.place_outlined, 'المكان', place),
    ].where((s) => s.$3 != null && s.$3!.trim().isNotEmpty).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        if (images.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: width > 760 ? 340 : 230,
              child: Stack(children: [
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
        ],
        if (t['is_active'] != true)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('الإعلان ده متوقف دلوقتي', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w800)),
          ),
        Row(children: [
          ClipOval(
            child: SizedBox(
              width: 56,
              height: 56,
              child: avatar == null || avatar.isEmpty
                  ? const TutorPhotoPlaceholder(size: 26)
                  : Image.network(avatar, cacheWidth: 168, fit: BoxFit.cover, errorBuilder: (_, _, _) => const TutorPhotoPlaceholder(size: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t['tutor_name'] as String? ?? '', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(tutorPrice(t['price'] as num?, t['price_unit'] as String?),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.teal)),
            ]),
          ),
        ]),
        if (created != null) ...[
          const SizedBox(height: 6),
          Text('اتنشر ${DateFormat('d/M/yyyy').format(created.toLocal())}', style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
        ],
        const SizedBox(height: 14),
        for (final (icon, label, value) in specs)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, size: 18, color: AppColors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                  Text(value!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                ]),
              ),
            ]),
          ),
        if ((t['bio'] as String?)?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 10),
          const Text('عن المدرس', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 6),
          Text(t['bio'] as String, style: const TextStyle(fontSize: 14, height: 1.7, color: AppColors.inkSecondary)),
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
                'نصيحة: اتفق على السعر والمواعيد قبل أول حصة، ولو الدرس في البيت خلّي حد من الأسرة موجود، ومتدفعش شهر مقدم قبل ما تجرّب.',
                style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
