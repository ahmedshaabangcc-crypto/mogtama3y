import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:url_launcher/url_launcher.dart';

import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../recycling/scrap_widgets.dart';
import '../shared/load_error_view.dart';

/// Super-admin review of scrap dealers ("تجار الخردة", migration 0075):
/// pending first, with WhatsApp, materials, areas and the optional
/// document (opened through a short-lived signed URL). Approve / reject
/// with a note — the dealer is notified either way.
class AdminScrapDealersScreen extends StatefulWidget {
  const AdminScrapDealersScreen({super.key});

  @override
  State<AdminScrapDealersScreen> createState() => _AdminScrapDealersScreenState();
}

class _AdminScrapDealersScreenState extends State<AdminScrapDealersScreen> {
  static const _filters = <String?, String>{'pending': 'قيد المراجعة', 'verified': 'موثّقين', 'rejected': 'مرفوضين', null: 'الكل'};

  String? _status = 'pending';
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _dealers = [];
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final rows = await ScrapDealerService.adminList(status: _status);
      if (!mounted) return;
      setState(() {
        _dealers = rows;
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

  Future<void> _openDoc(String path) async {
    try {
      final url = await UploadService.createPrivateSignedUrl(path, expiresInSeconds: 600);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح المستند')));
    }
  }

  Future<void> _review(Map<String, dynamic> d, bool approve) async {
    final noteCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approve ? 'توثيق «${d['business_name']}»' : 'رفض «${d['business_name']}»'),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: InputDecoration(labelText: approve ? 'ملاحظة (اختياري)' : 'سبب الرفض (بيوصل للتاجر)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(approve ? 'توثيق' : 'رفض')),
        ],
      ),
    );
    final note = noteCtrl.text.trim();
    noteCtrl.dispose();
    if (confirmed != true) return;
    final id = d['user_id'] as String;
    setState(() => _busy.add(id));
    try {
      await ScrapDealerService.review(id, approve: approve, note: note.isEmpty ? null : note);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر الحفظ')));
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تجار الخردة')),
      body: Column(children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(side, 10, side, 6),
            children: [
              for (final e in _filters.entries) ...[
                ChoiceChip(
                  label: Text(e.value),
                  selected: _status == e.key,
                  onSelected: (_) {
                    setState(() => _status = e.key);
                    _load();
                  },
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error
                  ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل التجار')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _dealers.isEmpty
                          ? ListView(children: const [
                              Padding(
                                padding: EdgeInsets.all(40),
                                child: Center(child: Text('مفيش تجار هنا', style: TextStyle(color: AppColors.inkMuted))),
                              ),
                            ])
                          : ListView.separated(
                              padding: EdgeInsets.fromLTRB(side, 8, side, 24),
                              itemCount: _dealers.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (context, i) => _card(_dealers[i]),
                            ),
                    ),
        ),
      ]),
    );
  }

  Widget _card(Map<String, dynamic> d) {
    final status = d['status'] as String? ?? 'pending';
    final materials = ((d['materials'] as List?) ?? const []).cast<String>();
    final areas = ((d['areas'] as List?) ?? const []).cast<String>();
    final radius = (d['radius_km'] as num?)?.toDouble();
    final doc = d['doc_path'] as String?;
    final note = d['review_note'] as String?;
    final created = DateTime.tryParse(d['created_at'] as String? ?? '')?.toLocal();
    final busy = _busy.contains(d['user_id']);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(d['business_name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
          ScrapDealerStatusBadge(status: status),
        ]),
        const SizedBox(height: 4),
        Text('${d['full_name'] ?? '—'}  ·  واتساب ${d['whatsapp'] ?? '—'}${d['phone'] != null ? '  ·  موبايل الحساب ${d['phone']}' : ''}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
        if (created != null)
          Text('اتسجّل ${DateFormat('yyyy/MM/dd HH:mm').format(created)}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [for (final m in materials) ScrapChip(scrapMaterials[m] ?? m)]),
        const SizedBox(height: 6),
        Text(
          [
            if (d['governorate'] != null) areas.isEmpty ? 'كل ${d['governorate']}' : '${d['governorate']}: ${areas.join('، ')}',
            if (radius != null) 'نطاق ${radius.toStringAsFixed(0)} كم',
          ].join(' • '),
          style: const TextStyle(fontSize: 11.5),
        ),
        if (note != null && note.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('ملاحظة المراجعة: $note', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        ],
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          if (doc != null)
            OutlinedButton.icon(
              onPressed: () => _openDoc(doc),
              icon: const Icon(Icons.description_outlined, size: 16),
              label: const Text('المستند', style: TextStyle(fontSize: 11.5)),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('مفيش مستند', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ),
          if (status != 'verified')
            ElevatedButton.icon(
              onPressed: busy ? null : () => _review(d, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
              icon: const Icon(Icons.verified_rounded, size: 16),
              label: const Text('توثيق', style: TextStyle(fontSize: 11.5)),
            ),
          if (status != 'rejected')
            OutlinedButton.icon(
              onPressed: busy ? null : () => _review(d, false),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFC62828)),
              icon: const Icon(Icons.block_rounded, size: 16),
              label: const Text('رفض', style: TextStyle(fontSize: 11.5)),
            ),
        ]),
      ]),
    );
  }
}
