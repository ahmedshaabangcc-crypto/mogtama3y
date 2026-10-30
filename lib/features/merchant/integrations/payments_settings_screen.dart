import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../shared/phone_field.dart';
import '../admin/admin_common.dart';
import 'integrations_common.dart';
import 'integrations_rules.dart';
import 'integrations_service.dart';
import 'platform_pay_card.dart';

/// «طرق الدفع» (/settings/payments) — like Shopify Settings → Payments:
/// cash on delivery, manual methods, and the merchant's OWN online gateway
/// (the money goes straight to the merchant). Customers already pay online
/// with Fawaterak (0100); the other gateways' checkout comes later.
class PaymentsSettingsScreen extends StatefulWidget {
  const PaymentsSettingsScreen({super.key});

  @override
  State<PaymentsSettingsScreen> createState() => _PaymentsSettingsScreenState();
}

class _PaymentsSettingsScreenState extends State<PaymentsSettingsScreen> with IntegrationsLoader {
  bool _cod = true;
  bool _instapayOn = false, _walletOn = false, _bankOn = false;
  final _instapay = TextEditingController();
  final _wallet = PhoneController();
  final _walletLabel = TextEditingController();
  final _bankName = TextEditingController();
  final _accountName = TextEditingController();
  final _iban = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_instapay, _wallet, _walletLabel, _bankName, _accountName, _iban]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void onLoaded(ShopIntegrations d) {
    _cod = d.codEnabled;
    _instapayOn = d.manualOn('instapay');
    _walletOn = d.manualOn('wallet');
    _bankOn = d.manualOn('bank');
    _instapay.text = d.manualOf('instapay')['handle'] as String? ?? '';
    _wallet.setPhone(d.manualOf('wallet')['number'] as String?);
    _walletLabel.text = d.manualOf('wallet')['label'] as String? ?? '';
    _bankName.text = d.manualOf('bank')['bank_name'] as String? ?? '';
    _accountName.text = d.manualOf('bank')['account_name'] as String? ?? '';
    _iban.text = d.manualOf('bank')['iban'] as String? ?? '';
  }

  String? _problem() {
    if (_instapay.text.trim().isNotEmpty || _instapayOn) {
      if (normalizeInstapay(_instapay.text) == null) return 'عنوان InstaPay مش صحيح — اكتبه زي name@instapay أو لينك ipn.eg';
    }
    if (_walletOn && _wallet.stored == null) return 'رقم المحفظة مش صحيح';
    if (_bankOn) {
      if (_bankName.text.trim().length < 2) return 'اكتب اسم البنك';
      if (_accountName.text.trim().length < 2) return 'اكتب اسم صاحب الحساب';
    }
    if ((_bankOn || _iban.text.trim().isNotEmpty) && !ibanValid(_iban.text)) return 'رقم الـ IBAN مش صحيح — راجعه من البنك';
    final gatewaysOn = data!.gateways.any((g) => g['status'] == 'connected');
    if (!_cod && !_instapayOn && !_walletOn && !_bankOn && !gatewaysOn) return 'لازم تسيب طريقة دفع واحدة على الأقل شغالة';
    return null;
  }

  Future<void> _save() async {
    final p = _problem();
    if (p != null) return setState(() => _error = p);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final d = await IntegrationsService.savePayments(shopId, cod: _cod, manual: {
        'instapay': {'enabled': _instapayOn, 'handle': _instapay.text.trim()},
        'wallet': {'enabled': _walletOn, 'number': _wallet.stored ?? _wallet.text.trim(), 'label': _walletLabel.text.trim()},
        'bank': {'enabled': _bankOn, 'bank_name': _bankName.text.trim(), 'account_name': _accountName.text.trim(), 'iban': _iban.text.trim()},
      });
      if (!mounted) return;
      applied(d);
      toast('اتحفظت طرق الدفع ✓');
    } catch (e) {
      if (mounted) setState(() => _error = integrationsError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'طرق الدفع',
      subtitle: 'اختار الزبون يدفع إزاي — كاش، تحويل، أو أونلاين',
      backTo: '/settings/integrations',
      scrollable: true,
      maxWidth: 980,
      body: loadingBody() ?? _body(data!),
    );
  }

  Widget _body(ShopIntegrations d) {
    final available = gatewaySpecs.where((g) => g.availableIn(d.country)).toList();
    final others = gatewaySpecs.where((g) => !g.availableIn(d.country)).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AdminCard(
        title: 'الدفع عند الاستلام',
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _cod,
          onChanged: (v) => setState(() => _cod = v),
          title: const Text('كاش عند الاستلام'),
          subtitle: const Text('الزبون بيدفع للمندوب أو في المحل'),
        ),
      ),
      const SizedBox(height: 12),
      AdminCard(
        title: 'تحويل يدوي',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('بتظهر للزبون في صفحة الدفع مع «ارفع إيصال التحويل» (مع الدفع أونلاين قريباً)، وإنت بتأكد الطلب لما الفلوس توصلك.',
              style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
          const SizedBox(height: 8),
          if (d.country == 'EG') ...[
            SwitchListTile(contentPadding: EdgeInsets.zero, value: _instapayOn, onChanged: (v) => setState(() => _instapayOn = v), title: const Text('InstaPay')),
            if (_instapayOn)
              TextField(
                controller: _instapay,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'عنوان InstaPay (IPA)', hintText: 'name@instapay أو لينك ipn.eg'),
              ),
            const Divider(height: 24),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _walletOn,
            onChanged: (v) => setState(() => _walletOn = v),
            title: Text(d.country == 'EG' ? 'محفظة موبايل (فودافون كاش وغيرها)' : 'محفظة موبايل'),
          ),
          if (_walletOn) ...[
            PhoneFormField(controller: _wallet, labelText: 'رقم المحفظة'),
            const SizedBox(height: 8),
            TextField(controller: _walletLabel, decoration: InputDecoration(labelText: 'اسم المحفظة (اختياري)', hintText: d.country == 'EG' ? 'فودافون كاش' : 'STC Pay')),
          ],
          const Divider(height: 24),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _bankOn, onChanged: (v) => setState(() => _bankOn = v), title: const Text('تحويل بنكي')),
          if (_bankOn) ...[
            TextField(controller: _bankName, decoration: const InputDecoration(labelText: 'اسم البنك')),
            const SizedBox(height: 8),
            TextField(controller: _accountName, decoration: const InputDecoration(labelText: 'اسم صاحب الحساب')),
            const SizedBox(height: 8),
            TextField(controller: _iban, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'IBAN', hintText: 'EG38 0019 0005 …')),
          ],
        ]),
      ),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
      const SizedBox(height: 12),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: ElevatedButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded, size: 18),
          label: const Text('احفظ طرق الدفع'),
        ),
      ),
      if (d.country == 'EG') ...[
        const SizedBox(height: 22),
        PlatformPayCard(shopId: d.shopId),
      ],
      const SizedBox(height: 22),
      const Text('الدفع أونلاين — أو اربط بوابتك أنت', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 4),
      const Text('افتح حساب تاجر عند البوابة باسمك، وبعدين الصق المفاتيح هنا. المفاتيح السرية بتتحفظ على السيرفر ومحدش يقدر يشوفها تاني (ولا إنت) — بتظهر آخر 4 حروف بس.',
          style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
      const SizedBox(height: 10),
      ResponsivePair(children: [for (final g in available) _GatewayCard(spec: g, data: d, onChanged: applied)]),
      if (others.isNotEmpty)
        Text('مش متاحة في دولة متجرك: ${others.map((g) => g.name).join('، ')}', style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
    ]);
  }
}

class _GatewayCard extends StatefulWidget {
  const _GatewayCard({required this.spec, required this.data, required this.onChanged});
  final GatewaySpec spec;
  final ShopIntegrations data;
  final ValueChanged<ShopIntegrations> onChanged;

  @override
  State<_GatewayCard> createState() => _GatewayCardState();
}

class _GatewayCardState extends State<_GatewayCard> {
  bool _busy = false;

  Map<String, dynamic>? get _row => widget.data.gateway(widget.spec.id);

  void _toast(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _test() async {
    setState(() => _busy = true);
    final (ok, msg) = await IntegrationsService.testGateway(widget.data.shopId, widget.spec.id);
    try {
      final d = await IntegrationsService.load(widget.data.shopId);
      widget.onChanged(d);
    } catch (_) {}
    if (!mounted) return;
    setState(() => _busy = false);
    _toast(ok ? (msg.isEmpty ? 'الربط شغال ✓' : msg) : (msg.isEmpty ? 'فيه مشكلة في الربط' : msg));
  }

  Future<void> _disconnect() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('تفصل ${widget.spec.name}؟'),
        content: const Text('المفاتيح هتتمسح من عندنا، والزبون مش هيقدر يدفع بيها. تقدر تربطها تاني في أي وقت.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('لا')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('افصل')),
        ],
      ),
    );
    if (yes != true) return;
    setState(() => _busy = true);
    try {
      widget.onChanged(await IntegrationsService.disconnectGateway(widget.data.shopId, widget.spec.id));
    } catch (e) {
      _toast(integrationsError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit() async {
    final saved = await showModalBottomSheet<ShopIntegrations>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _GatewayForm(spec: widget.spec, data: widget.data),
    );
    if (saved == null || !mounted) return;
    widget.onChanged(saved);
    await _test();
  }

  @override
  Widget build(BuildContext context) {
    final row = _row;
    final status = row?['status'] as String?;
    final badge = switch (status) {
      null => const IntegrationBadge('مش مربوط', IntegrationTone.off),
      'connected' => const IntegrationBadge('مربوط', IntegrationTone.ok),
      'error' => const IntegrationBadge('فيه مشكلة', IntegrationTone.problem),
      _ => const IntegrationBadge('مستني الاختبار', IntegrationTone.waiting),
    };
    return AdminCard(
      title: widget.spec.name,
      trailing: badge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.spec.blurb, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.5)),
        if (row != null) ...[
          const SizedBox(height: 6),
          Text(row['mode'] == 'live' ? 'الوضع: حقيقي' : 'الوضع: تجريبي (مفيش فلوس حقيقية)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          if (row['last_error'] != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: Text(row['last_error'] as String, style: const TextStyle(fontSize: 12, color: Colors.redAccent))),
          const SizedBox(height: 6),
          if (widget.spec.webhookWhere.isNotEmpty)
            CopyValue(label: 'رابط الـ Webhook — الصقه في ${widget.spec.webhookWhere}', value: IntegrationsService.webhookUrl(widget.data.shopId, widget.spec.id)),
          if (widget.spec.id == 'moyasar' && row['webhook_token'] != null) CopyValue(label: 'Secret token للـ Webhook', value: row['webhook_token'] as String),
          Text(
            widget.spec.checkoutReady
                ? (status == 'connected'
                    ? 'الزبون بيشوف «ادفع أونلاين» في صفحة متجرك، والطلب بيتعلّم «اتدفع ✓» لوحده لما الفلوس توصل.'
                    : 'اضغط «اختبر الاتصال» — أول ما يبقى «مربوط» الزبون يقدر يدفع أونلاين.')
                : 'الربط محفوظ — الدفع أونلاين بـ ${widget.spec.name} في صفحة المتجر جاي قريباً.',
            style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.5),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 6, children: [
          if (row == null)
            ElevatedButton(onPressed: _busy ? null : _edit, child: const Text('اربط'))
          else ...[
            ElevatedButton(onPressed: _busy ? null : _test, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('اختبر الاتصال')),
            OutlinedButton(onPressed: _busy ? null : _edit, child: const Text('عدّل')),
            TextButton(onPressed: _busy ? null : _disconnect, child: const Text('افصل')),
          ],
          TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(widget.spec.signupUrl), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: Text(row == null ? 'افتح حساب في ${widget.spec.name}' : 'لوحة ${widget.spec.name}'),
          ),
        ]),
      ]),
    );
  }
}

class _GatewayForm extends StatefulWidget {
  const _GatewayForm({required this.spec, required this.data});
  final GatewaySpec spec;
  final ShopIntegrations data;

  @override
  State<_GatewayForm> createState() => _GatewayFormState();
}

class _GatewayFormState extends State<_GatewayForm> {
  late final Map<String, dynamic>? _row = widget.data.gateway(widget.spec.id);
  late String _mode = _row?['mode'] as String? ?? 'test';
  late final Map<String, TextEditingController> _c = {
    for (final f in widget.spec.fields)
      f.key: TextEditingController(text: f.secret ? '' : ((_row?['public'] as Map?)?[f.key] as String? ?? '')),
  };
  bool _saving = false;
  String? _error;

  Map<String, dynamic> get _hints => (_row?['secret_hint'] as Map?)?.cast<String, dynamic>() ?? const {};

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final values = {for (final e in _c.entries) e.key: e.value.text.trim()};
    final hasSecret = _row?['has_secret'] == true;
    final p = gatewayProblem(widget.spec, values, _mode, hasSecret: hasSecret);
    if (p.isNotEmpty) return setState(() => _error = p);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final d = await IntegrationsService.saveGateway(
        widget.data.shopId,
        widget.spec.id,
        public: {for (final f in widget.spec.fields.where((f) => !f.secret)) f.key: values[f.key]!},
        secret: {for (final f in widget.spec.fields.where((f) => f.secret)) if (values[f.key]!.isNotEmpty) f.key: values[f.key]!},
        mode: _mode,
      );
      if (mounted) Navigator.of(context).pop(d);
    } catch (e) {
      if (mounted) setState(() => _error = integrationsError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), children: [
            Text('اربط ${widget.spec.name}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 4),
            const Text('انسخ البيانات من لوحة البوابة. ابدأ بالوضع التجريبي واعمل عملية تجربة، وبعدين حوّل لحقيقي بمفاتيح الـ live.',
                style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [ButtonSegment(value: 'test', label: Text('تجريبي')), ButtonSegment(value: 'live', label: Text('حقيقي'))],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: 12),
            for (final f in widget.spec.fields) ...[
              TextField(
                controller: _c[f.key],
                obscureText: f.secret,
                autocorrect: false,
                enableSuggestions: false,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: f.label + (f.secret ? ' 🔒' : ''),
                  hintText: f.secret && _hints[f.key] != null ? 'محفوظ (${_hints[f.key]}) — سيبه فاضي لو مش هتغيّره' : f.hint,
                  helperText: f.secret ? 'بيتحفظ على السيرفر بس ومش بيظهر تاني' : null,
                ),
              ),
              const SizedBox(height: 10),
            ],
            if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
            ElevatedButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'بنحفظ…' : 'احفظ واختبر الاتصال')),
          ]),
        ),
      ),
    );
  }
}
