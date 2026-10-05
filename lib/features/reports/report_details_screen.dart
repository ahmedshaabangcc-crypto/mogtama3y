import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maps/maps_launcher.dart';
import '../../core/reports/report_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'report_widgets.dart';

/// One report (`/r/<id>`, public): photos, place, status timeline, "وأنا كمان
/// 👍" and share (the share link has a photo preview for social media).
class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key, required this.reportId});
  final String reportId;

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  Map<String, dynamic>? _r;
  bool _loading = true;
  bool _error = false;
  bool _voting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await ReportService.get(widget.reportId);
      if (mounted) {
        setState(() {
          _r = r;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _vote() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      return _load();
    }
    setState(() => _voting = true);
    try {
      await ReportService.toggleVote(widget.reportId);
      await _load();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر التسجيل، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _voting = false);
    }
  }

  Future<void> _share() async {
    final r = _r!;
    final url = ReportService.shareUrl(widget.reportId);
    final text = '📢 ${r['category']}${r['district'] != null ? ' في ${r['district']}' : ''}: ${r['description']}\n'
        'شاركني على مُجتمعي واضغط «وأنا كمان» عشان نوصّل صوتنا 👇\n$url';
    final wa = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(leading: Icon(Icons.check_circle_rounded, color: AppColors.teal), title: Text('اتنسخ لينك البلاغ')),
          ListTile(
            leading: const Icon(Icons.chat_rounded, color: Color(0xFF1FA855)),
            title: const Text('ابعته على واتساب'),
            onTap: () {
              Navigator.pop(ctx);
              launchUrl(wa, mode: LaunchMode.externalApplication);
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
          const ListTile(
            leading: Icon(Icons.video_library_outlined),
            title: Text('تيك توك / إنستجرام: الصق اللينك في الوصف أو الستوري'),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = _r;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('بلاغ'),
        actions: [if (r != null) IconButton(onPressed: _share, icon: const Icon(Icons.share_rounded), tooltip: 'شارك')],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : r == null
                  ? const Center(child: Text('البلاغ ده مش موجود', style: TextStyle(color: AppColors.inkMuted)))
                  : _content(r),
    );
  }

  Widget _content(Map<String, dynamic> r) {
    final (icon, color) = reportCategoryStyle(r['category'] as String?);
    final photos = (r['photos'] as List?)?.cast<String>() ?? const [];
    final events = (r['events'] as List?)?.cast<Map>() ?? const [];
    final voted = r['voted'] == true;
    final where = [r['district'], r['governorate']].whereType<String>().where((s) => s.isNotEmpty).join('، ');
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 720 ? (width - 680) / 2 : 16.0;
    final fmt = DateFormat('d/M/yyyy – h:mm a');
    return ListView(
      padding: EdgeInsets.fromLTRB(side, 12, side, 32),
      children: [
        if (photos.isNotEmpty)
          SizedBox(
            height: 240,
            child: PageView(children: [
              for (final p in photos)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(p, fit: BoxFit.cover)),
                ),
            ]),
          ),
        const SizedBox(height: 12),
        Row(children: [
          Icon(icon, color: color),
          const SizedBox(width: 6),
          Expanded(child: Text(r['category'] as String? ?? '', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 17))),
          ReportStatusChip(r['status'] as String?),
        ]),
        const SizedBox(height: 8),
        Text(r['description'] as String? ?? '', style: const TextStyle(fontSize: 15, height: 1.7)),
        const SizedBox(height: 8),
        Text(
          [if (where.isNotEmpty) where, ReportService.ageLabel(r), if (r['reporter'] != null) 'بلّغ: ${r['reporter']}']
              .where((s) => s.isNotEmpty)
              .join(' · '),
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
        ),
        if (r['routed_to'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('اتبعت لـ: ${r['routed_to']}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1565C0))),
          ),
        if (r['status_note'] != null)
          Padding(padding: const EdgeInsets.only(top: 4), child: Text(r['status_note'] as String, style: const TextStyle(color: AppColors.inkSecondary))),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: voted
                  ? OutlinedButton.icon(
                      onPressed: _voting ? null : _vote,
                      icon: const Icon(Icons.thumb_up_alt_rounded),
                      label: Text('معاك (${r['votes_count']})'),
                    )
                  : ElevatedButton.icon(
                      onPressed: _voting ? null : _vote,
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      label: Text('وأنا كمان (${r['votes_count']})', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(onPressed: _share, icon: const Icon(Icons.share_rounded), label: const Text('شارك')),
          ),
        ]),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => openDirections(lat: (r['lat'] as num).toDouble(), lng: (r['lng'] as num).toDouble()),
          icon: const Icon(Icons.map_outlined),
          label: const Text('المكان على خرائط جوجل'),
        ),
        if (r['after_photo'] != null) ...[
          const SizedBox(height: 8),
          const Text('بعد الحل', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(r['after_photo'] as String, height: 220, fit: BoxFit.cover)),
        ],
        const SizedBox(height: 16),
        const Text('متابعة البلاغ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 6),
        for (final e in events)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.circle, size: 10, color: (reportStatuses[e['status']] ?? ('', AppColors.inkMuted)).$2),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: (reportStatuses[e['status']] ?? (e['status'].toString(), Colors.black)).$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (e['note'] != null) TextSpan(text: ' — ${e['note']}'),
                  TextSpan(
                    text: '\n${DateTime.tryParse(e['at'] as String? ?? '') == null ? '' : fmt.format(DateTime.parse(e['at'] as String).toLocal())}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  ),
                ])),
              ),
            ]),
          ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: const Text(ReportService.disclaimer, style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.inkSecondary)),
        ),
      ],
    );
  }
}
