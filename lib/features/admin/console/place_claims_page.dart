import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/admin/admin_console_service.dart';
import '../../../core/geo/phones.dart';
import '../../../core/theme/app_colors.dart';
import 'console_widgets.dart';

/// «استلم محلك جاهز» (0111): people who claimed a directory place without
/// proving its number by SMS. Approving links the place to their store (its
/// dalil / Google page then opens the store); a rejection needs a reason.
class AdminPlaceClaimsPage extends StatefulWidget {
  const AdminPlaceClaimsPage({super.key});

  @override
  State<AdminPlaceClaimsPage> createState() => _AdminPlaceClaimsPageState();
}

const _statuses = {'pending': 'مستني المراجعة', 'approved': 'اتربط', 'rejected': 'مرفوض', null: 'الكل'};

class _AdminPlaceClaimsPageState extends State<AdminPlaceClaimsPage> {
  String? _status = 'pending';
  List<Map<String, dynamic>>? _rows;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final r = await AdminConsoleService.placeClaims(status: _status);
      if (mounted) setState(() => _rows = r);
    } catch (e) {
      if (mounted) setState(() => _error = isAdminDenied(e) ? 'غير مصرح لك' : 'مقدرناش نحمّل — $e');
    }
  }

  void _toast(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _review(Map<String, dynamic> r, bool approve) async {
    String? note;
    if (!approve) {
      final ctrl = TextEditingController();
      note = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          title: Text('رفض استلام «${r['place_name']}»'),
          content: TextField(
            key: const ValueKey('place-claim-note'),
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'السبب *', hintText: 'الرقم مش بتاع المحل…', helperText: 'بيوصل لصاحب الطلب في إشعار'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d), child: const Text('رجوع')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.categorySos),
              onPressed: () => Navigator.pop(d, ctrl.text.trim()),
              child: const Text('ارفض'),
            ),
          ],
        ),
      );
      if (note == null) return;
      if (note.length < 3) return _toast('اكتب السبب');
    }
    try {
      await AdminConsoleService.placeClaimReview(r['id'] as String, approve: approve, note: note);
      _toast(approve ? 'اتربط المحل بالمتجر ✓' : 'اترفض الطلب ✓');
      _load();
    } catch (e) {
      _toast('تعذر التنفيذ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text(
        'اللي أكّد رقم المحل بـ SMS بيتربط لوحده. هنا الطلبات اللي محتاجة مراجعة: كلّم رقم المحل اللي في الدليل واتأكد إن صاحب الطلب هو صاحب المحل.',
        style: TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.6),
      ),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 6, children: [
        for (final e in _statuses.entries)
          ChoiceChip(
            label: Text(e.value),
            selected: _status == e.key,
            onSelected: (_) {
              setState(() {
                _status = e.key;
                _rows = null;
              });
              _load();
            },
          ),
        IconButton(tooltip: 'تحديث', onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
      ]),
      const SizedBox(height: 12),
      if (_error != null)
        Text(_error!, style: const TextStyle(color: Colors.redAccent))
      else if (rows == null)
        const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
      else if (rows.isEmpty)
        const Padding(padding: EdgeInsets.all(24), child: Text('مفيش طلبات هنا', textAlign: TextAlign.center))
      else
        for (final r in rows) Padding(padding: const EdgeInsets.only(bottom: 12), child: _card(r)),
    ]);
  }

  Widget _card(Map<String, dynamic> r) {
    final status = r['status'] as String?;
    Widget kv(String k, String? v, {bool ltr = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 130, child: Text(k, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted))),
            Expanded(child: SelectableText(v == null || v.isEmpty ? '—' : v, textDirection: ltr ? TextDirection.ltr : null, style: const TextStyle(fontSize: 13))),
          ]),
        );
    final at = DateTime.tryParse(r['created_at'] as String? ?? '')?.toLocal();
    final placePhone = r['place_phone'] as String?;
    return ConsolePanel(
      title: '${r['place_name']}',
      trailing: ConsolePill(_statuses[status] ?? '$status', color: switch (status) {
        'approved' => AppColors.success,
        'pending' => AppColors.categoryUsedMarket,
        _ => AppColors.categorySos,
      }),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        kv('المحل في الدليل', [r['place_category'], r['place_address']].whereType<String>().join(' — ')),
        kv('رقم المحل', placePhone == null ? null : displayPhone(placePhone), ltr: true),
        kv('صاحب الطلب', '${r['user_name'] ?? '—'} — ${displayPhone(r['user_phone'] as String? ?? '')}${r['user_phone_verified'] == true ? ' ✓' : ''}'),
        kv('متجره', '${r['shop_name']} (${r['shop_slug']}) — واتساب ${displayPhone(r['shop_whatsapp'] as String? ?? '')}'),
        if (r['auto'] == true) kv('الربط', 'تلقائي (أكّد رقم المحل)'),
        if (at != null) kv('اتبعت', DateFormat('d/M/yyyy – h:mm a').format(at)),
        if (r['note'] != null) kv('ملاحظة', r['note'] as String?),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 6, children: [
          if (placePhone != null && placePhone.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () => launchUrl(Uri.parse('tel:$placePhone')),
              icon: const Icon(Icons.call_rounded, size: 18),
              label: const Text('كلّم رقم المحل'),
            ),
          OutlinedButton.icon(
            onPressed: () => launchUrl(Uri.parse('https://dalil.mogtama3y.com/p/${r['place_id']}'), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('صفحة المحل'),
          ),
          if (status == 'pending') ...[
            FilledButton(key: ValueKey('claim-approve-${r['id']}'), onPressed: () => _review(r, true), child: const Text('اربط المحل')),
            TextButton(
              onPressed: () => _review(r, false),
              style: TextButton.styleFrom(foregroundColor: AppColors.categorySos),
              child: const Text('ارفض'),
            ),
          ],
        ]),
      ]),
    );
  }
}
