import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/reports/report_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../reports/report_widgets.dart';
import '../shared/load_error_view.dart';

/// Super-admin queue of community reports: filter by status, category and
/// governorate; route each one to the responsible body (who + how), move
/// it through the statuses (reporter and voters get notified), add the
/// "after" photo, or hide abusive content.
class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String? _status = 'new';
  String? _category;
  String? _governorate;
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _reports = [];

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
      final list = await ReportService.adminList(status: _status, category: _category, governorate: _governorate);
      if (mounted) {
        setState(() {
          _reports = list;
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

  Future<void> _edit(Map<String, dynamic> r) async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _UpdateSheet(report: r),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('البلاغات')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            _drop<String>('الحالة', _status, {null: 'الكل', for (final e in reportStatuses.entries) e.key: e.value.$1}, (v) => _status = v),
            _drop<String>('النوع', _category, {null: 'كل الأنواع', for (final c in reportCategories) c.$1: c.$1}, (v) => _category = v),
            _drop<String>('المحافظة', _governorate, {null: 'كل المحافظات', for (final g in reportGovernorates) g: g}, (v) => _governorate = v),
          ]),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error
                  ? LoadErrorView(onRetry: _load)
                  : _reports.isEmpty
                      ? const Center(child: Text('مفيش بلاغات بالفلتر ده', style: TextStyle(color: AppColors.inkMuted)))
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: _reports.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final r = _reports[i];
                              final who = r['reporter_admin'] as Map?;
                              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                ReportCard(r),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        [
                                          'المبلّغ: ${who?['name'] ?? '—'}${who?['phone'] != null ? ' (${who!['phone']})' : ''}',
                                          if (r['hide_identity'] == true) 'مخفي عن العامة',
                                          if (r['is_hidden'] == true) '🚫 متخبّي',
                                          if (r['routed_note'] != null) 'الطريقة: ${r['routed_note']}',
                                        ].join(' · '),
                                        style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
                                      ),
                                    ),
                                    TextButton.icon(onPressed: () => _edit(r), icon: const Icon(Icons.edit_note_rounded), label: const Text('تحديث')),
                                  ]),
                                ),
                              ]);
                            },
                          ),
                        ),
        ),
      ]),
    );
  }

  Widget _drop<T>(String label, T? value, Map<T?, String> items, void Function(T?) set) {
    return SizedBox(
      width: 170,
      child: DropdownButtonFormField<T?>(
        initialValue: value,
        isDense: true,
        decoration: InputDecoration(labelText: label, isDense: true),
        items: [for (final e in items.entries) DropdownMenuItem<T?>(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis))],
        onChanged: (v) {
          setState(() => set(v));
          _load();
        },
      ),
    );
  }
}

class _UpdateSheet extends StatefulWidget {
  const _UpdateSheet({required this.report});
  final Map<String, dynamic> report;

  @override
  State<_UpdateSheet> createState() => _UpdateSheetState();
}

class _UpdateSheetState extends State<_UpdateSheet> {
  late String _status = widget.report['status'] as String? ?? 'new';
  late final _routedTo = TextEditingController(text: widget.report['routed_to'] as String? ?? '');
  late final _routedNote = TextEditingController(text: widget.report['routed_note'] as String? ?? '');
  final _note = TextEditingController();
  late bool _hidden = widget.report['is_hidden'] == true;
  String? _afterPhoto;
  bool _saving = false;
  bool _uploading = false;

  @override
  void dispose() {
    _routedTo.dispose();
    _routedNote.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickAfter() async {
    final f = await UploadService.pickImage(source: ImageSource.gallery);
    if (f == null) return;
    setState(() => _uploading = true);
    try {
      final url = await UploadService.uploadPublicPhoto(purpose: 'reports', file: f);
      if (mounted) setState(() => _afterPhoto = url);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ReportService.adminUpdate(
        widget.report['id'] as String,
        status: _status,
        statusNote: _note.text,
        routedTo: _routedTo.text,
        routedNote: _routedNote.text,
        afterPhoto: _afterPhoto,
        hidden: _hidden,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الحفظ')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Expanded(child: Text('تحديث البلاغ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
            TextButton(onPressed: () => context.push('/r/${widget.report['id']}'), child: const Text('فتح البلاغ')),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final e in reportStatuses.entries)
              ChoiceChip(
                selected: _status == e.key,
                label: Text(e.value.$1),
                selectedColor: e.value.$2,
                labelStyle: TextStyle(color: _status == e.key ? Colors.white : AppColors.ink),
                showCheckmark: false,
                onSelected: (_) => setState(() => _status = e.key),
              ),
          ]),
          const SizedBox(height: 10),
          TextField(controller: _routedTo, decoration: const InputDecoration(labelText: 'الجهة المختصة (بتظهر للناس)', hintText: 'مثلاً: حي شرق الإسكندرية')),
          const SizedBox(height: 8),
          TextField(controller: _routedNote, decoration: const InputDecoration(labelText: 'اتبعت إزاي (للإدارة بس)', hintText: 'مثلاً: واتساب شكاوى حي ثان المنتزه')),
          const SizedBox(height: 8),
          TextField(controller: _note, decoration: const InputDecoration(labelText: 'ملاحظة للناس مع التحديث (اختياري)', hintText: 'مثلاً: الحي وعد بالرفع خلال يومين / السبب لو مرفوض')),
          const SizedBox(height: 8),
          Row(children: [
            OutlinedButton.icon(
              onPressed: _uploading ? null : _pickAfter,
              icon: _uploading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_a_photo_outlined),
              label: Text(_afterPhoto == null ? 'صورة بعد الحل' : 'اتغيرت الصورة ✓'),
            ),
            const Spacer(),
            const Text('إخفاء (مسيء)'),
            Switch(value: _hidden, onChanged: (v) => setState(() => _hidden = v)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ وإبلاغ المتابعين'),
            ),
          ),
        ]),
      ),
    );
  }
}
