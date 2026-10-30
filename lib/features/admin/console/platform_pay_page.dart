import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/admin/admin_console_service.dart';
import '../../../core/geo/money.dart';
import '../../../core/geo/phones.dart';
import '../../../core/storage/upload_service.dart';
import '../../../core/theme/app_colors.dart';
import 'console_widgets.dart';

/// «الدفع عن طريق مُجتمعي» (0108): stores whose customers pay through the
/// platform's Fawaterak. The admin reviews the identity papers, turns the
/// payment on / off, and records the manual transfers to each merchant.
class AdminPlatformPayPage extends StatefulWidget {
  const AdminPlatformPayPage({super.key});

  @override
  State<AdminPlatformPayPage> createState() => _AdminPlatformPayPageState();
}

const _statuses = {null: 'الكل', 'pending': 'مستني المراجعة', 'approved': 'شغال', 'rejected': 'مرفوض', 'suspended': 'متوقف'};

class _AdminPlatformPayPageState extends State<AdminPlatformPayPage> {
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
      final r = await AdminConsoleService.platformPayList(status: _status);
      if (mounted) setState(() => _rows = r);
    } catch (e) {
      if (mounted) setState(() => _error = isAdminDenied(e) ? 'غير مصرح لك' : 'مقدرناش نحمّل — $e');
    }
  }

  void _toast(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _review(Map<String, dynamic> r, String action) async {
    String? note;
    if (action != 'approve') {
      final ctrl = TextEditingController();
      note = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          title: Text(action == 'reject' ? 'رفض «${r['shop_name']}»' : 'إيقاف الدفع لـ «${r['shop_name']}»'),
          content: TextField(
            key: const ValueKey('platform-pay-note'),
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'السبب *', hintText: 'الصورة مش واضحة، الاسم مش مطابق…', helperText: 'بيوصل للتاجر في إشعار'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d), child: const Text('رجوع')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.categorySos),
              onPressed: () => Navigator.pop(d, ctrl.text.trim()),
              child: Text(action == 'reject' ? 'ارفض' : 'أوقف'),
            ),
          ],
        ),
      );
      if (note == null) return;
      if (note.isEmpty) return _toast('اكتب السبب');
    }
    try {
      await AdminConsoleService.platformPayReview(r['shop_id'] as String, action, note: note);
      _toast(switch (action) { 'approve' => 'اتفعّل الدفع للمتجر ✓', 'reject' => 'اترفض الطلب ✓', _ => 'اتوقف الدفع ✓' });
      _load();
    } catch (e) {
      _toast('تعذر التنفيذ: $e');
    }
  }

  Future<void> _payout(Map<String, dynamic> r) async {
    final due = num.tryParse('${(r['balance'] as Map?)?['due']}') ?? 0;
    final amount = TextEditingController(text: due > 0 ? due.toString() : '');
    final ref = TextEditingController();
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('سجّل تحويل لـ «${r['shop_name']}»'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('المستحق: ${money(due, (r['balance'] as Map?)?['currency'] as String?)} — حوّل الأول من حسابك، وبعدين سجّله هنا.',
              style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary)),
          const SizedBox(height: 10),
          TextField(key: const ValueKey('payout-amount'), controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'المبلغ *')),
          TextField(controller: ref, decoration: const InputDecoration(labelText: 'رقم العملية / المرجع')),
          TextField(controller: note, decoration: const InputDecoration(labelText: 'ملاحظة')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('رجوع')),
          FilledButton(onPressed: () => Navigator.pop(d, true), child: const Text('سجّل التحويل')),
        ],
      ),
    );
    if (ok != true) return;
    final n = num.tryParse(amount.text.trim());
    if (n == null || n <= 0) return _toast('اكتب مبلغ صحيح');
    try {
      await AdminConsoleService.recordPayout(r['shop_id'] as String, n,
          method: (r['payout'] as Map?)?['method'] as String?, reference: ref.text.trim().isEmpty ? null : ref.text.trim(), note: note.text.trim().isEmpty ? null : note.text.trim());
      _toast('اتسجّل التحويل وبلّغنا التاجر ✓');
      _load();
    } catch (e) {
      _toast('تعذر التسجيل: $e');
    }
  }

  Future<void> _openDoc(String path) async {
    try {
      final url = await UploadService.createPrivateSignedUrl(path, expiresInSeconds: 600);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      _toast('مقدرناش نفتح الملف: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('العميل بيدفع عن طريق حساب فواتيرك بتاع مُجتمعي، والفلوس بتتحوّل للتاجر يدوي. رسوم البوابة على التاجر ومفيش عمولة دلوقتي.',
          style: TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.6)),
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
    final b = (r['balance'] as Map?)?.cast<String, dynamic>() ?? const {};
    final cur = b['currency'] as String?;
    final payout = (r['payout'] as Map?)?.cast<String, dynamic>() ?? const {};
    final docs = [for (final d in (r['documents'] as List? ?? const [])) d as String];
    final company = r['entity'] == 'company';
    Widget kv(String k, String? v, {bool ltr = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 130, child: Text(k, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted))),
            Expanded(child: SelectableText(v == null || v.isEmpty ? '—' : v, textDirection: ltr ? TextDirection.ltr : null, style: const TextStyle(fontSize: 13))),
          ]),
        );
    final payoutText = switch (payout['method']) {
      'instapay' => 'InstaPay: ${payout['handle']}',
      'wallet' => 'محفظة: ${displayPhone(payout['number'] as String? ?? '')}',
      'bank' => 'بنك ${payout['bank_name']} — ${payout['account_name'] ?? ''} — ${payout['iban']}',
      _ => null,
    };
    final submitted = DateTime.tryParse(r['submitted_at'] as String? ?? '')?.toLocal();
    return ConsolePanel(
      title: '${r['shop_name']}',
      trailing: ConsolePill(_statuses[status] ?? '$status', color: switch (status) {
        'approved' => AppColors.success,
        'pending' => AppColors.categoryUsedMarket,
        _ => AppColors.categorySos,
      }),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        kv('صاحب المتجر', '${r['owner_name'] ?? '—'} — ${displayPhone(r['owner_phone'] as String? ?? '')}'),
        kv('النوع', company ? 'شركة' : 'فرد'),
        kv(company ? 'اسم الشركة' : 'الاسم في البطاقة', r['legal_name'] as String?),
        kv(company ? 'السجل التجاري' : 'الرقم القومي', r['id_number'] as String?, ltr: true),
        if (company) kv('البطاقة الضريبية', r['tax_number'] as String?, ltr: true),
        kv('التحويل على', payoutText),
        if (submitted != null) kv('اتبعت', DateFormat('d/M/yyyy – h:mm a').format(submitted)),
        if (r['review_note'] != null) kv('ملاحظة المراجعة', r['review_note'] as String?),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (var i = 0; i < docs.length; i++)
            ActionChip(avatar: const Icon(Icons.image_outlined, size: 16), label: Text('ورقة ${i + 1}'), onPressed: () => _openDoc(docs[i])),
        ]),
        if (status != 'pending') ...[
          const Divider(height: 22),
          Wrap(spacing: 18, runSpacing: 6, children: [
            Text('${b['orders'] ?? 0} طلب مدفوع'),
            Text('إجمالي ${money(num.tryParse('${b['gross']}') ?? 0, cur)}'),
            Text('رسوم ${money(num.tryParse('${b['fees']}') ?? 0, cur)}'),
            Text('اتحوّل ${money(num.tryParse('${b['paid_out']}') ?? 0, cur)}'),
            Text('المستحق ${money(num.tryParse('${b['due']}') ?? 0, cur)}', style: const TextStyle(fontWeight: FontWeight.w800)),
          ]),
        ],
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 6, children: [
          if (status == 'pending' || status == 'rejected' || status == 'suspended')
            FilledButton(key: ValueKey('pp-approve-${r['shop_id']}'), onPressed: () => _review(r, 'approve'), child: Text(status == 'suspended' ? 'رجّع التشغيل' : 'وافق وشغّل الدفع')),
          if (status == 'pending') OutlinedButton(onPressed: () => _review(r, 'reject'), child: const Text('ارفض')),
          if (status == 'approved') ...[
            FilledButton.tonal(key: ValueKey('pp-payout-${r['shop_id']}'), onPressed: () => _payout(r), child: const Text('سجّل تحويل')),
            TextButton(
              onPressed: () => _review(r, 'suspend'),
              style: TextButton.styleFrom(foregroundColor: AppColors.categorySos),
              child: const Text('أوقف الدفع'),
            ),
          ],
        ]),
      ]),
    );
  }
}
