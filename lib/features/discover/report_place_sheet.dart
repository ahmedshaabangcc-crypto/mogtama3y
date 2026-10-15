import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/auth/auth_service.dart';
import '../../core/places/directory_service.dart';
import '../../core/places/osm_places.dart' show directoryCategories;
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

/// Sends a report: reason key, optional note, optional suggested
/// correction (name / phone / category — «الاسم أو الرقم غلط» only).
typedef PlaceReportSubmit = Future<void> Function(String reason, String? note, Map<String, String>? suggestion);

/// «بلّغ عن محل غلط» (0095) on a directory place. Guests sign in first and
/// come back to the sheet.
Future<void> openReportPlace(BuildContext context, Map<String, dynamic> place) async {
  if (!AuthService.isSignedIn) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!AuthService.isSignedIn || !context.mounted) return;
  }
  final id = '${place['id']}';
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    builder: (_) => ReportPlaceSheet(
      placeName: place['name'] as String? ?? '',
      category: place['category'] as String?,
      onSubmit: (reason, note, suggestion) => DirectoryService.reportPlace(id, reason, note: note, suggestion: suggestion),
    ),
  );
  if (sent == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('شكراً! بلاغك وصلنا وهنراجعه قريب')));
  }
}

class ReportPlaceSheet extends StatefulWidget {
  const ReportPlaceSheet({super.key, required this.placeName, required this.onSubmit, this.category});
  final String placeName;
  final String? category;
  final PlaceReportSubmit onSubmit;

  static const maxNote = 500;

  @override
  State<ReportPlaceSheet> createState() => _ReportPlaceSheetState();
}

class _ReportPlaceSheetState extends State<ReportPlaceSheet> {
  String? _reason;
  final _note = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  String? _category;
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    final note = _t(_note);
    if (reason == 'other' && note == null) {
      setState(() => _error = 'اكتب لنا إيه الغلط');
      return;
    }
    Map<String, String>? suggestion;
    if (reason == 'wrong_info') {
      suggestion = {
        if (_t(_name) != null) 'name': _t(_name)!,
        if (_t(_phone) != null) 'phone': _t(_phone)!,
        if (_category != null && _category != widget.category) 'category': _category!,
      };
      if (suggestion.isEmpty) suggestion = null;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await widget.onSubmit(reason, note, suggestion);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _sending = false;
          _error = e is PostgrestException ? e.message : 'مقدرناش نبعت البلاغ — جرّب تاني';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wrongInfo = _reason == 'wrong_info';
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const Text('بلّغ عن غلط في المحل', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          if (widget.placeName.isNotEmpty)
            Text(widget.placeName, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          for (final e in DirectoryService.reportReasons.entries)
            ListTile(
              key: ValueKey('report-reason-${e.key}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_reason == e.key ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: _reason == e.key ? AppColors.teal : AppColors.inkMuted),
              title: Text(e.value),
              onTap: _sending ? null : () => setState(() {
                    _reason = e.key;
                    _error = null;
                  }),
            ),
          if (wrongInfo) ...[
            const SizedBox(height: 6),
            const Text('تعرف الصح؟ اكتبه (اختياري)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              key: const ValueKey('report-suggest-name'),
              controller: _name,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'الاسم الصح'),
            ),
            TextField(
              key: const ValueKey('report-suggest-phone'),
              controller: _phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(labelText: 'الرقم الصح'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: const ValueKey('report-suggest-category'),
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'النشاط الصح'),
              items: [for (final c in directoryCategories) DropdownMenuItem(value: c, child: Text(c))],
              onChanged: (v) => setState(() => _category = v),
            ),
          ],
          if (_reason != null) ...[
            const SizedBox(height: 10),
            TextField(
              key: const ValueKey('report-note'),
              controller: _note,
              minLines: 2,
              maxLines: 4,
              maxLength: ReportPlaceSheet.maxNote,
              decoration: InputDecoration(labelText: _reason == 'other' ? 'إيه الغلط؟' : 'ملاحظة (اختياري)'),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(_error!, style: const TextStyle(color: Color(0xFFC62828), fontSize: 12.5)),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              key: const ValueKey('report-submit'),
              onPressed: _reason == null || _sending ? null : _submit,
              child: _sending
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('ابعت البلاغ', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }
}
