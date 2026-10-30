import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/storage/upload_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/phone_field.dart';
import '../admin/admin_common.dart';
import 'integrations_common.dart';
import 'integrations_rules.dart';
import 'integrations_service.dart';

/// platform_pay_get() of one shop (0108): the application, the balance the
/// platform owes the merchant, and the payouts already sent.
class PlatformPay {
  PlatformPay(this.raw);
  final Map<String, dynamic> raw;

  Map<String, dynamic>? get application => (raw['application'] as Map?)?.cast<String, dynamic>();
  String? get status => application?['status'] as String?;
  Map<String, dynamic> get balance => (raw['balance'] as Map?)?.cast<String, dynamic>() ?? const {};
  List<Map<String, dynamic>> get payouts => [for (final p in (raw['payouts'] as List? ?? const [])) (p as Map).cast<String, dynamic>()];
}

class PlatformPayService {
  PlatformPayService._();
  static SupabaseClient get _db => Supabase.instance.client;

  /// Widget tests: answers [get] without a backend.
  @visibleForTesting
  static Future<PlatformPay> Function(String shopId)? debugGet;

  static Future<PlatformPay> get(String shopId) async => debugGet != null
      ? debugGet!(shopId)
      : PlatformPay((await _db.rpc('platform_pay_get', params: {'p_shop': shopId}) as Map).cast<String, dynamic>());

  static Future<PlatformPay> apply(String shopId, Map<String, dynamic> p) async =>
      PlatformPay((await _db.rpc('platform_pay_apply', params: {'p_shop': shopId, 'p': p}) as Map).cast<String, dynamic>());
}

String _money(Object? v, String cur) {
  final n = (v is num ? v : num.tryParse('$v') ?? 0).toDouble();
  return '${n == n.roundToDouble() ? n.toStringAsFixed(0) : n.toStringAsFixed(2)} ${cur == 'EGP' ? 'ج.م' : cur}';
}

/// «اربط مع مُجتمعي» — the customer pays through the PLATFORM's Fawaterak,
/// the money lands with مُجتمعي and is transferred to the merchant by hand.
/// Turned on only after the merchant's papers are approved by an admin.
class PlatformPayCard extends StatefulWidget {
  const PlatformPayCard({super.key, required this.shopId});
  final String shopId;

  @override
  State<PlatformPayCard> createState() => _PlatformPayCardState();
}

class _PlatformPayCardState extends State<PlatformPayCard> {
  PlatformPay? _data;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await PlatformPayService.get(widget.shopId);
      if (mounted) {
        setState(() {
          _data = d;
          _failed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _apply() async {
    final d = await showModalBottomSheet<PlatformPay>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PlatformPayForm(shopId: widget.shopId, current: _data?.application),
    );
    if (d == null || !mounted) return;
    setState(() => _data = d);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(d.status == 'approved' ? 'اتحفظت بيانات التحويل ✓' : 'وصلنا طلبك ✓ — هنراجع الأوراق ونبلغك')));
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    final status = d?.status;
    final badge = switch (status) {
      null => const IntegrationBadge('مش مفعّل', IntegrationTone.off),
      'approved' => const IntegrationBadge('شغال', IntegrationTone.ok),
      'pending' => const IntegrationBadge('بنراجع الأوراق', IntegrationTone.waiting),
      _ => IntegrationBadge(status == 'suspended' ? 'متوقف' : 'مرفوض', IntegrationTone.problem),
    };
    const muted = TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6);
    return AdminCard(
      title: 'اربط مع مُجتمعي',
      trailing: d == null ? null : badge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text(
            'من غير ما تفتح حساب عند أي بوابة: الزبون بيدفع فيزا / محفظة / فوري عن طريق مُجتمعي، والفلوس بتتجمّع عندنا وبنحوّلها لك. '
            'رسوم بوابة الدفع بتتخصم من المبلغ، ومفيش عمولة لمُجتمعي دلوقتي. لازم تبعت إثبات الهوية الأول ونوافق عليه.',
            style: muted),
        const SizedBox(height: 8),
        if (_failed)
          TextButton(onPressed: _load, child: const Text('مقدرناش نحمّل — جرّب تاني'))
        else if (d == null)
          const Center(child: Padding(padding: EdgeInsets.all(8), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
        else ...[
          if (status == 'pending') const Text('طلبك عندنا — بنراجع الأوراق وهيوصلك إشعار أول ما نوافق.', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          if (status == 'approved') const Text('الزبون بيشوف «ادفع أونلاين» في صفحة متجرك، والطلب بيتعلّم «اتدفع ✓» لوحده.', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          if ((status == 'rejected' || status == 'suspended') && d.application?['review_note'] != null)
            Text('السبب: ${d.application!['review_note']}', style: const TextStyle(fontSize: 12.5, color: Colors.redAccent)),
          if (status != null && status != 'pending') _Balance(d),
          const SizedBox(height: 8),
          if (status != 'suspended')
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ElevatedButton(
                onPressed: _apply,
                child: Text(switch (status) {
                  null => 'شغّل الدفع عن طريق مُجتمعي',
                  'rejected' => 'ابعت الأوراق تاني',
                  _ => 'عدّل البيانات',
                }),
              ),
            ),
        ],
      ]),
    );
  }
}

class _Balance extends StatelessWidget {
  const _Balance(this.d);
  final PlatformPay d;

  @override
  Widget build(BuildContext context) {
    final b = d.balance;
    final cur = b['currency'] as String? ?? 'EGP';
    Widget row(String k, Object? v, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: [
            Expanded(child: Text(k, style: const TextStyle(fontSize: 12.5))),
            Text(_money(v, cur), style: TextStyle(fontSize: 12.5, fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
          ]),
        );
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('حسابك عندنا (${b['orders'] ?? 0} طلب مدفوع)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        row('إجمالي المدفوع أونلاين', b['gross']),
        row('رسوم بوابة الدفع', b['fees']),
        if ((num.tryParse('${b['commission']}') ?? 0) > 0) row('عمولة مُجتمعي (${b['commission_pct']}%)', b['commission']),
        row('اتحوّل لك', b['paid_out']),
        const Divider(height: 12),
        row('مستحق لك', b['due'], bold: true),
        if (d.payouts.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('التحويلات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          for (final p in d.payouts.take(10))
            Text(
              '${DateFormat('d/M/yyyy').format(DateTime.parse(p['created_at'] as String).toLocal())} — ${_money(p['amount'], cur)}'
              '${p['reference'] != null ? ' — مرجع ${p['reference']}' : ''}',
              style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
            ),
        ],
      ]),
    );
  }
}

class _PlatformPayForm extends StatefulWidget {
  const _PlatformPayForm({required this.shopId, this.current});
  final String shopId;
  final Map<String, dynamic>? current;

  @override
  State<_PlatformPayForm> createState() => _PlatformPayFormState();
}

class _PlatformPayFormState extends State<_PlatformPayForm> {
  late final Map<String, dynamic> _cur = widget.current ?? const {};
  late final Map<String, dynamic> _payout = (_cur['payout'] as Map?)?.cast<String, dynamic>() ?? const {};
  late String _entity = _cur['entity'] as String? ?? 'individual';
  late final _name = TextEditingController(text: _cur['legal_name'] as String? ?? '');
  late final _id = TextEditingController(text: _cur['id_number'] as String? ?? '');
  late final _tax = TextEditingController(text: _cur['tax_number'] as String? ?? '');
  late final List<String> _docs = [for (final x in (_cur['documents'] as List? ?? const [])) x as String];
  late String _method = _payout['method'] as String? ?? 'instapay';
  late final _handle = TextEditingController(text: _payout['handle'] as String? ?? '');
  late final _wallet = PhoneController(phone: _payout['number'] as String?, country: 'EG');
  late final _bankName = TextEditingController(text: _payout['bank_name'] as String? ?? '');
  late final _accountName = TextEditingController(text: _payout['account_name'] as String? ?? '');
  late final _iban = TextEditingController(text: _payout['iban'] as String? ?? '');
  bool _uploading = false, _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _id, _tax, _handle, _wallet, _bankName, _accountName, _iban]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addDocs() async {
    final files = await UploadService.pickImages(limit: 8 - _docs.length);
    if (files.isEmpty) return;
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      for (final f in files) {
        final path = await UploadService.uploadPrivateDocument(purpose: 'platform_pay', file: f);
        if (mounted) setState(() => _docs.add(path));
      }
    } catch (e) {
      if (mounted) setState(() => _error = e is Exception ? '$e'.replaceFirst('Exception: ', '') : 'مقدرناش نرفع الصورة — جرّب تاني');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String? _problem() {
    if (_name.text.trim().length < 3) return 'اكتب الاسم زي ما هو في البطاقة / السجل التجاري';
    final id = _id.text.replaceAll(RegExp(r'\s'), '');
    if (_entity == 'individual' && !RegExp(r'^[0-9]{14}$').hasMatch(id)) return 'الرقم القومي 14 رقم';
    if (_entity == 'company' && id.length < 3) return 'اكتب رقم السجل التجاري';
    if (_entity == 'company' && _tax.text.trim().isEmpty) return 'اكتب رقم البطاقة الضريبية';
    if (_docs.length < 2) return 'ارفع صور الأوراق المطلوبة (صورتين على الأقل)';
    if (_method == 'instapay' && normalizeInstapay(_handle.text) == null) return 'عنوان InstaPay مش صحيح — زي name@instapay';
    if (_method == 'wallet' && _wallet.stored == null) return 'رقم المحفظة مش صحيح';
    if (_method == 'bank' && (_bankName.text.trim().length < 2 || !ibanValid(_iban.text))) return 'اكتب اسم البنك و IBAN صحيح';
    return null;
  }

  Future<void> _submit() async {
    final p = _problem();
    if (p != null) return setState(() => _error = p);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final d = await PlatformPayService.apply(widget.shopId, {
        'entity': _entity,
        'legal_name': _name.text.trim(),
        'id_number': _id.text.trim(),
        'tax_number': _entity == 'company' ? _tax.text.trim() : null,
        'documents': _docs,
        'payout': switch (_method) {
          'instapay' => {'method': 'instapay', 'handle': normalizeInstapay(_handle.text)},
          'wallet' => {'method': 'wallet', 'number': _wallet.stored},
          _ => {'method': 'bank', 'bank_name': _bankName.text.trim(), 'account_name': _accountName.text.trim(), 'iban': _iban.text.trim()},
        },
      });
      if (mounted) Navigator.of(context).pop(d);
    } catch (e) {
      if (mounted) setState(() => _error = integrationsError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = _entity == 'company';
    const gap = SizedBox(height: 10);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), children: [
            const Text('شغّل الدفع عن طريق مُجتمعي', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 4),
            const Text('البيانات والصور بتوصل لإدارة مُجتمعي بس، علشان نتأكد من صاحب المتجر قبل ما نستلم فلوس باسمه.',
                style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [ButtonSegment(value: 'individual', label: Text('فرد')), ButtonSegment(value: 'company', label: Text('شركة'))],
              selected: {_entity},
              onSelectionChanged: (s) => setState(() => _entity = s.first),
            ),
            gap,
            TextField(controller: _name, decoration: InputDecoration(labelText: company ? 'اسم الشركة زي السجل التجاري' : 'الاسم زي البطاقة')),
            gap,
            TextField(
              controller: _id,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: company ? 'رقم السجل التجاري' : 'الرقم القومي (14 رقم)'),
            ),
            if (company) ...[
              gap,
              TextField(controller: _tax, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'رقم البطاقة الضريبية')),
            ],
            const SizedBox(height: 14),
            Text(company ? 'صور السجل التجاري والبطاقة الضريبية' : 'صورة البطاقة — الوش والضهر',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (var i = 0; i < _docs.length; i++)
                InputChip(label: Text('صورة ${i + 1}'), avatar: const Icon(Icons.description_outlined, size: 16), onDeleted: () => setState(() => _docs.removeAt(i))),
              if (_docs.length < 8)
                ActionChip(
                  avatar: _uploading ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_a_photo_outlined, size: 16),
                  label: Text(_uploading ? 'بنرفع…' : 'ارفع صور'),
                  onPressed: _uploading ? null : _addDocs,
                ),
            ]),
            const SizedBox(height: 14),
            const Text('هنحوّل لك فلوسك على', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'instapay', label: Text('InstaPay')),
                ButtonSegment(value: 'wallet', label: Text('محفظة')),
                ButtonSegment(value: 'bank', label: Text('بنك')),
              ],
              selected: {_method},
              onSelectionChanged: (s) => setState(() => _method = s.first),
            ),
            gap,
            if (_method == 'instapay')
              TextField(controller: _handle, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'عنوان InstaPay', hintText: 'name@instapay'))
            else if (_method == 'wallet')
              PhoneFormField(controller: _wallet, labelText: 'رقم المحفظة')
            else ...[
              TextField(controller: _bankName, decoration: const InputDecoration(labelText: 'اسم البنك')),
              gap,
              TextField(controller: _accountName, decoration: const InputDecoration(labelText: 'اسم صاحب الحساب')),
              gap,
              TextField(controller: _iban, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'IBAN')),
            ],
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
            const SizedBox(height: 14),
            ElevatedButton(onPressed: _saving || _uploading ? null : _submit, child: Text(_saving ? 'بنبعت…' : 'ابعت للمراجعة')),
          ]),
        ),
      ),
    );
  }
}
