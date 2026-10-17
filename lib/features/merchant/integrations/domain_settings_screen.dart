import 'package:flutter/material.dart';

import '../../../core/shops/store_service.dart';
import '../../../core/theme/app_colors.dart';
import '../admin/admin_common.dart';
import 'integrations_common.dart';
import 'integrations_hub_screen.dart';
import 'integrations_rules.dart';
import 'integrations_service.dart';

/// «الدومين» (/settings/domain) — like Shopify Settings → Domains: the free
/// address, and «اربط دومين عندك» (TXT ownership check + CNAME). Serving
/// the store on the domain is turned on by the platform in Phase 5.
class DomainSettingsScreen extends StatefulWidget {
  const DomainSettingsScreen({super.key});

  @override
  State<DomainSettingsScreen> createState() => _DomainSettingsScreenState();
}

class _DomainSettingsScreenState extends State<DomainSettingsScreen> with IntegrationsLoader {
  final _host = TextEditingController();
  bool _busy = false;
  String? _error;
  String? _verifyMessage;

  @override
  void dispose() {
    _host.dispose();
    super.dispose();
  }

  String get _normalized => normalizeHostname(_host.text);

  Future<void> _add() async {
    final h = _normalized;
    final p = hostnameProblem(h);
    if (p.isNotEmpty) return setState(() => _error = p);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      applied(await IntegrationsService.addDomain(shopId, h));
      _host.clear();
    } catch (e) {
      if (mounted) setState(() => _error = integrationsError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    setState(() {
      _busy = true;
      _verifyMessage = null;
    });
    final (_, msg) = await IntegrationsService.verifyDomain(shopId);
    await reload();
    if (mounted) {
      setState(() {
        _busy = false;
        _verifyMessage = msg;
      });
    }
  }

  Future<void> _remove() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('تمسح الدومين؟'),
        content: const Text('متجرك هيفضل شغال على عنوانه المجاني. تقدر تربط الدومين تاني بعدين (هتحتاج تتحقق من الأول).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('لا')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('امسح')),
        ],
      ),
    );
    if (yes != true) return;
    try {
      applied(await IntegrationsService.removeDomain(shopId));
      _verifyMessage = null;
    } catch (e) {
      toast(integrationsError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'الدومين',
      subtitle: 'عنوان متجرك على الإنترنت',
      backTo: '/settings/integrations',
      scrollable: true,
      maxWidth: 860,
      body: loadingBody() ?? _body(data!),
    );
  }

  Widget _body(ShopIntegrations d) {
    final dom = d.domain;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AdminCard(
        title: 'عنوانك المجاني',
        trailing: const IntegrationBadge('شغال', IntegrationTone.ok),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          CopyValue(label: 'رابط متجرك دلوقتي', value: StoreService.storeUrl(d.slug)),
          Row(children: [
            Expanded(child: CopyValue(label: 'قريباً: عنوان أقصر', value: '${d.slug}.mogtama3y.com')),
            const SizedBox(width: 8),
            const IntegrationBadge('قريباً', IntegrationTone.waiting),
          ]),
        ]),
      ),
      const SizedBox(height: 12),
      if (dom == null) _addCard() else _domainCard(dom),
    ]);
  }

  Widget _addCard() {
    final h = _normalized;
    final showPuny = _host.text.trim().isNotEmpty && h != _host.text.trim().toLowerCase() && h.contains('xn--');
    return AdminCard(
      title: 'اربط دومين عندك',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('عندك دومين (من GoDaddy أو Namecheap أو غيرهم)؟ اكتبه هنا وهنقولك تضيف إيه في إعدادات الـ DNS.',
            style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
        const SizedBox(height: 10),
        TextField(
          controller: _host,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.url,
          autocorrect: false,
          onChanged: (_) => setState(() => _error = null),
          decoration: const InputDecoration(labelText: 'الدومين', hintText: 'shop.example.com'),
        ),
        if (showPuny) Padding(padding: const EdgeInsets.only(top: 4), child: Text('هيتسجل كده: $h', textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted))),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
        const SizedBox(height: 10),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ElevatedButton(onPressed: _busy ? null : _add, child: const Text('اربط الدومين')),
        ),
        const SizedBox(height: 6),
        const Text('نصيحة: استخدم دومين فرعي زي shop.example.com أو www.example.com — أسهل في الربط من الدومين الرئيسي.',
            style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
      ]),
    );
  }

  Widget _domainCard(Map<String, dynamic> dom) {
    final host = dom['hostname'] as String;
    final apex = dom['is_apex'] == true;
    final label = cnameHostLabel(host);
    final txtHost = label == '@' ? '_mogtama3y-verify' : '_mogtama3y-verify.$label';
    final status = dom['status'] as String?;
    return AdminCard(
      title: host,
      trailing: domainStatusBadge(dom),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (status == 'verified')
          const _Note(icon: Icons.verified_rounded, text: 'اتأكدنا إن الدومين بتاعك ✓ تشغيل المتجر عليه هيتفعّل قريباً من ناحيتنا (مع شهادة SSL) — مش محتاج تعمل حاجة تانية، وهنبعتلك إشعار.')
        else if (status == 'active')
          const _Note(icon: Icons.check_circle_rounded, text: 'متجرك شغال على الدومين ده.')
        else
          const _Note(icon: Icons.info_outline_rounded, text: 'ادخل على إعدادات الـ DNS عند الشركة اللي اشتريت منها الدومين، وضيف السجلات دي، وبعدين دوس «تحقق دلوقتي». التغيير ممكن ياخد من دقايق لساعات.'),
        const SizedBox(height: 10),
        const Text('1) سجل TXT (لإثبات الملكية)', style: TextStyle(fontWeight: FontWeight.w800)),
        CopyValue(label: 'Type: TXT — Host / Name', value: txtHost),
        CopyValue(label: 'Value', value: dom['verify_token'] as String? ?? ''),
        const SizedBox(height: 8),
        if (!apex) ...[
          const Text('2) سجل CNAME (عشان المتجر يفتح على الدومين)', style: TextStyle(fontWeight: FontWeight.w800)),
          CopyValue(label: 'Type: CNAME — Host / Name', value: label),
          const CopyValue(label: 'Value / Points to', value: domainCnameTarget),
        ] else
          const _Note(
            icon: Icons.warning_amber_rounded,
            text: 'ده دومين رئيسي (من غير shop. أو www.)، ومينفعش يتعمله CNAME. هنديك عنوان الـ A / ALIAS لما نفعّل تشغيل الدومينات. الأسهل: اربط www.الدومين بتاعك بدل الرئيسي.',
          ),
        if (dom['last_error'] != null && status != 'verified' && status != 'active')
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(dom['last_error'] as String, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5))),
        if (_verifyMessage != null && _verifyMessage!.isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 6), child: Text(_verifyMessage!, style: const TextStyle(fontSize: 12.5))),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 6, children: [
          if (status != 'active')
            ElevatedButton.icon(
              onPressed: _busy ? null : _verify,
              icon: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('تحقق دلوقتي'),
            ),
          TextButton(onPressed: _busy ? null : _remove, child: const Text('امسح الدومين')),
        ]),
      ]),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: AppColors.crystal),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.6))),
        ]),
      );
}
