import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/maps/maps_launcher.dart';
import '../../core/places/directory_service.dart';
import '../../core/places/osm_places.dart' show directoryCategories;
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// «بلاغات الأماكن» (migration 0095): directory places people reported,
/// one card per place — reasons, notes, suggested corrections, who
/// reported — with the fixes: edit the data (or apply the suggestion),
/// hide, delete (user / OSM places only), dismiss, show again.
class AdminPlaceReportsScreen extends StatefulWidget {
  const AdminPlaceReportsScreen({super.key});

  @override
  State<AdminPlaceReportsScreen> createState() => _AdminPlaceReportsScreenState();
}

class _AdminPlaceReportsScreenState extends State<AdminPlaceReportsScreen> {
  static const _filters = {'open': 'بلاغات مفتوحة', 'hidden': 'أماكن مخفية'};
  static const _sources = {'overture': 'Overture', 'osm': 'OpenStreetMap', 'user': 'ضافه مستخدم', 'merchant': 'متجر'};

  String _filter = 'open';
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _rows = [];
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
      final rows = await DirectoryService.adminPlaceReports(filter: _filter);
      if (!mounted) return;
      setState(() {
        _rows = rows;
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

  Future<void> _run(String id, Future<void> Function() action, String done) async {
    setState(() => _busy.add(id));
    try {
      await action();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر الحفظ')));
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<bool> _confirm(String title, String body, String yes) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(yes)),
          ],
        ),
      ) ==
      true;

  Map<String, dynamic>? _suggestion(Map<String, dynamic> r) {
    for (final x in (r['reports'] as List? ?? const [])) {
      final s = (x as Map)['suggestion'];
      if (s is Map && s.isNotEmpty) return Map<String, dynamic>.from(s);
    }
    return null;
  }

  Future<void> _edit(Map<String, dynamic> r) async {
    final s = _suggestion(r) ?? const {};
    final name = TextEditingController(text: (s['name'] ?? r['name'] ?? '') as String);
    final phone = TextEditingController(text: (s['phone'] ?? r['phone'] ?? '') as String);
    String? category = (s['category'] ?? r['category']) as String?;
    if (!directoryCategories.contains(category)) category = null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('تعديل بيانات المكان'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (s.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('متعبّي باقتراح المبلّغ — راجعه قبل الحفظ', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                ),
              TextField(controller: name, maxLength: 120, decoration: const InputDecoration(labelText: 'الاسم')),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'التليفون (فاضي = يتشال)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: category,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'النشاط'),
                items: [for (final c in directoryCategories) DropdownMenuItem(value: c, child: Text(c))],
                onChanged: (v) => setLocal(() => category = v),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('احفظ')),
          ],
        ),
      ),
    );
    final n = name.text.trim(), p = phone.text.trim();
    name.dispose();
    phone.dispose();
    if (ok != true) return;
    final id = r['place_id'] as String;
    await _run(
      id,
      () => DirectoryService.adminUpdatePlace(
        id,
        name: n == r['name'] ? null : n,
        phone: p == (r['phone'] ?? '') ? null : p,
        category: category == r['category'] ? null : category,
      ),
      'اتعدّل وبلاغاته اتقفلت',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('بلاغات الأماكن')),
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
                  selected: _filter == e.key,
                  onSelected: (_) {
                    setState(() => _filter = e.key);
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
                  ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل البلاغات')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _rows.isEmpty
                          ? ListView(children: const [
                              Padding(padding: EdgeInsets.all(40), child: Center(child: Text('مفيش حاجة هنا', style: TextStyle(color: AppColors.inkMuted)))),
                            ])
                          : ListView.separated(
                              padding: EdgeInsets.fromLTRB(side, 8, side, 24),
                              itemCount: _rows.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (context, i) => _card(_rows[i]),
                            ),
                    ),
        ),
      ]),
    );
  }

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
      );

  Widget _card(Map<String, dynamic> r) {
    final id = r['place_id'] as String;
    final source = r['source'] as String? ?? 'overture';
    final hidden = r['hidden'] == true;
    final busy = _busy.contains(id);
    final reasons = Map<String, dynamic>.from(r['reasons'] as Map? ?? const {});
    final reports = [for (final x in (r['reports'] as List? ?? const [])) Map<String, dynamic>.from(x as Map)];
    final hasOpen = reports.any((x) => x['status'] == 'open');
    final deletable = (source == 'user' || source == 'osm') && r['claimed_shop_id'] == null;
    final lat = (r['lat'] as num?)?.toDouble(), lng = (r['lng'] as num?)?.toDouble();
    final link = '/d/$id';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(r['name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
          Text('${r['reporters'] ?? 0} مبلّغ', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.inkSecondary)),
        ]),
        Text(
          [r['category'], r['country'], if (r['phone'] != null) r['phone'], if (r['address'] != null) r['address']].join(' · '),
          style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
        ),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: [
          _badge(_sources[source] ?? source, AppColors.teal),
          if (hidden) _badge(r['hidden_by'] == 'auto' ? 'مخفي تلقائياً' : 'مخفي', const Color(0xFFC62828)),
          for (final e in reasons.entries) _badge('${DirectoryService.reportReasons[e.key] ?? e.key} × ${e.value}', AppColors.inkSecondary),
        ]),
        const SizedBox(height: 6),
        for (final x in reports.take(6)) _reportLine(x),
        if (reports.length > 6) Text('و${reports.length - 6} بلاغ تاني', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          if (lat != null && lng != null)
            OutlinedButton.icon(
              onPressed: () => openDirections(lat: lat, lng: lng),
              icon: const Icon(Icons.map_outlined, size: 16),
              label: const Text('على الخريطة', style: TextStyle(fontSize: 11.5)),
            ),
          if (!hidden && isInAppPath(link))
            TextButton(onPressed: () => context.push(link), child: const Text('صفحة المكان', style: TextStyle(fontSize: 11.5))),
          ElevatedButton.icon(
            onPressed: busy ? null : () => _edit(r),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('تعديل البيانات', style: TextStyle(fontSize: 11.5)),
          ),
          if (!hidden)
            OutlinedButton.icon(
              onPressed: busy ? null : () => _run(id, () => DirectoryService.adminSetHidden(id, true), 'المكان اتخفى'),
              icon: const Icon(Icons.visibility_off_rounded, size: 16),
              label: const Text('إخفاء المكان', style: TextStyle(fontSize: 11.5)),
            )
          else
            OutlinedButton.icon(
              onPressed: busy ? null : () => _run(id, () => DirectoryService.adminSetHidden(id, false), 'المكان رجع للدليل'),
              icon: const Icon(Icons.visibility_rounded, size: 16),
              label: const Text('إظهار تاني', style: TextStyle(fontSize: 11.5)),
            ),
          if (deletable)
            OutlinedButton.icon(
              onPressed: busy
                  ? null
                  : () async {
                      if (await _confirm('مسح «${r['name']}»؟', 'المكان هيتمسح من الدليل خالص مع بلاغاته.', 'امسح')) {
                        await _run(id, () => DirectoryService.adminDeletePlace(id), 'المكان اتمسح');
                      }
                    },
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFC62828)),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('مسح المكان', style: TextStyle(fontSize: 11.5)),
            ),
          if (hasOpen)
            TextButton(
              onPressed: busy ? null : () => _run(id, () => DirectoryService.adminResolveReports(id), 'البلاغات اتجاهلت'),
              child: const Text('تجاهل البلاغ', style: TextStyle(fontSize: 11.5)),
            ),
        ]),
      ]),
    );
  }

  Widget _reportLine(Map<String, dynamic> x) {
    final created = DateTime.tryParse(x['created_at'] as String? ?? '')?.toLocal();
    final s = x['suggestion'] is Map ? Map<String, dynamic>.from(x['suggestion'] as Map) : null;
    final parts = <String>[
      DirectoryService.reportReasons[x['reason']] ?? '${x['reason']}',
      if (x['note'] != null) '«${x['note']}»',
      if (s != null && s.isNotEmpty) 'المقترح: ${[s['name'], s['phone'], s['category']].whereType<String>().join(' / ')}',
    ];
    final meta = <String>[
      '${x['reporter'] ?? 'مستخدم'}${x['eligible'] == true ? '' : ' (حساب جديد)'}',
      if (created != null) DateFormat('yyyy/MM/dd HH:mm').format(created),
      if (x['status'] != 'open') x['status'] == 'resolved' ? 'اتحل' : 'اتجاهل',
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: parts.join(' — '), style: const TextStyle(fontSize: 12)),
          TextSpan(text: '\n${meta.join(' • ')}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        ]),
      ),
    );
  }
}
