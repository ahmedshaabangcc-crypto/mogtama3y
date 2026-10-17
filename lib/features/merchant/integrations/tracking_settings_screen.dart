import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../admin/admin_common.dart';
import 'integrations_common.dart';
import 'integrations_rules.dart';
import 'integrations_service.dart';

/// «البكسل والتاجز» (/settings/tracking) — like Shopify Customer events:
/// the merchant's pixel IDs. They load on THIS store's pages only
/// (web/shop-pixels.js) and fire PageView, ViewContent, AddToCart,
/// InitiateCheckout and Purchase.
class TrackingSettingsScreen extends StatefulWidget {
  const TrackingSettingsScreen({super.key});

  @override
  State<TrackingSettingsScreen> createState() => _TrackingSettingsScreenState();
}

class _TrackingSettingsScreenState extends State<TrackingSettingsScreen> with IntegrationsLoader {
  final _c = {for (final f in [...trackingFields, fbDomainVerificationField]) f.key: TextEditingController()};
  final _errors = <String, String>{};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void onLoaded(ShopIntegrations d) {
    for (final e in _c.entries) {
      e.value.text = d.tracking[e.key] as String? ?? '';
    }
  }

  Future<void> _save() async {
    final out = <String, String>{};
    _errors.clear();
    for (final e in _c.entries) {
      final v = normalizeTracking(e.key, e.value.text);
      final p = trackingProblem(e.key, v);
      if (p.isNotEmpty) _errors[e.key] = p;
      if (v.isNotEmpty) out[e.key] = v;
    }
    if (_errors.isNotEmpty) return setState(() {});
    setState(() => _saving = true);
    try {
      applied(await IntegrationsService.saveTracking(shopId, out));
      toast('اتحفظ ✓ — الأدوات هتشتغل على صفحات متجرك');
    } catch (e) {
      toast(integrationsError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(TrackingField f) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: _c[f.key],
          textDirection: TextDirection.ltr,
          autocorrect: false,
          onChanged: (_) {
            if (_errors.remove(f.key) != null) setState(() {});
          },
          decoration: InputDecoration(labelText: f.label, hintText: f.hint, helperText: f.help, helperMaxLines: 2, errorText: _errors[f.key], errorMaxLines: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'البكسل والتاجز',
      subtitle: 'اعرف إعلاناتك جابت كام زيارة وطلب',
      backTo: '/settings/integrations',
      scrollable: true,
      maxWidth: 860,
      body: loadingBody() ??
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            AdminCard(
              title: 'أدوات القياس',
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('الصق الـ ID (أو الكود كله وإحنا هنطلّع الـ ID منه). الأدوات بتشتغل على صفحات متجرك بس، وبتبعت: زيارة الصفحة، مشاهدة منتج، إضافة للسلة، بدء الطلب، والشراء (بالمبلغ ورقم الطلب).',
                    style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
                const SizedBox(height: 12),
                ResponsivePair(children: [for (final f in trackingFields) _field(f)]),
              ]),
            ),
            const SizedBox(height: 12),
            AdminCard(
              title: 'تأكيد ملكية الدومين (فيسبوك)',
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('لو هتربط دومين عندك: الصق قيمة الـ meta-tag من فيسبوك هنا، وهنحطها في صفحات متجرك لما يشتغل على الدومين (قريباً).',
                    style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
                const SizedBox(height: 10),
                _field(fbDomainVerificationField),
              ]),
            ),
            const SizedBox(height: 12),
            const Text('الزبون بيشوف تحت المتجر «المتجر ده بيستخدم أدوات قياس». بيانات التوصيل (الاسم والرقم والعنوان) مش بتتبعت لأي أداة.',
                style: TextStyle(fontSize: 12, color: AppColors.inkMuted, height: 1.6)),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded, size: 18),
                label: const Text('احفظ'),
              ),
            ),
          ]),
    );
  }
}
