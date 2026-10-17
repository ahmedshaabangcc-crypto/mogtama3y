import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../admin/admin_common.dart';
import 'integrations_common.dart';
import 'integrations_service.dart';

/// «الربط والتكاملات» (/settings/integrations): payments, domain, pixels —
/// each with its status. Migration 0097.
class IntegrationsHubScreen extends StatefulWidget {
  const IntegrationsHubScreen({super.key});

  @override
  State<IntegrationsHubScreen> createState() => _IntegrationsHubScreenState();
}

class _IntegrationsHubScreenState extends State<IntegrationsHubScreen> with IntegrationsLoader {
  @override
  Widget build(BuildContext context) {
    final d = data;
    return AdminPage(
      title: 'الربط والتكاملات',
      subtitle: 'طرق الدفع، الدومين، وأدوات قياس الإعلانات',
      backTo: '/settings',
      scrollable: true,
      maxWidth: 980,
      body: loadingBody() ??
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ResponsivePair(children: [
              _HubTile(
                icon: Icons.payments_rounded,
                title: 'طرق الدفع',
                text: 'الدفع عند الاستلام، InstaPay والمحافظ والتحويل البنكي، واربط بوابة دفع باسمك (Paymob، Kashier، Tap، Moyasar) — الفلوس بتنزل في حسابك أنت على طول.',
                badge: _paymentsBadge(d!),
                onTap: () => context.go('/settings/payments'),
              ),
              _HubTile(
                icon: Icons.language_rounded,
                title: 'الدومين',
                text: 'عنوان متجرك المجاني، واربط دومين عندك زي shop.example.com.',
                badge: _domainBadge(d),
                onTap: () => context.go('/settings/domain'),
              ),
              _HubTile(
                icon: Icons.insights_rounded,
                title: 'البكسل والتاجز',
                text: 'Meta وTikTok وSnapchat وGoogle Analytics وTag Manager وGoogle Ads — عشان تعرف إعلاناتك جابت كام زيارة وطلب.',
                badge: _trackingBadge(d),
                onTap: () => context.go('/settings/tracking'),
              ),
            ]),
            const SizedBox(height: 8),
            const Text(
              'مُجتمعي مش بتستلم ولا بتمسك فلوس الطلبات: كل تاجر بيربط حسابه هو، والزبون بيدفع للتاجر مباشرة.',
              style: TextStyle(fontSize: 12, color: AppColors.inkMuted, height: 1.6),
            ),
          ]),
    );
  }
}

Widget _paymentsBadge(ShopIntegrations d) {
  if (d.anyGatewayError) return const IntegrationBadge('بوابة فيها مشكلة', IntegrationTone.problem);
  final n = d.paymentMethodsOn;
  return IntegrationBadge(n == 1 ? 'طريقة دفع واحدة شغالة' : '$n طرق دفع شغالة', IntegrationTone.ok);
}

Widget domainStatusBadge(Map<String, dynamic>? dom) => switch (dom?['status']) {
      null => const IntegrationBadge('مش مربوط', IntegrationTone.off),
      'pending' => const IntegrationBadge('مستني التحقق', IntegrationTone.waiting),
      'verified' => const IntegrationBadge('اتأكدنا — هيتفعّل قريباً', IntegrationTone.ok),
      'active' => const IntegrationBadge('شغال', IntegrationTone.ok),
      _ => const IntegrationBadge('فيه مشكلة', IntegrationTone.problem),
    };

Widget _domainBadge(ShopIntegrations d) => domainStatusBadge(d.domain);

Widget _trackingBadge(ShopIntegrations d) {
  final n = d.pixelsOn;
  return n == 0 ? const IntegrationBadge('مش متفعّل', IntegrationTone.off) : IntegrationBadge(n == 1 ? 'أداة واحدة شغالة' : '$n أدوات شغالة', IntegrationTone.ok);
}

class _HubTile extends StatelessWidget {
  const _HubTile({required this.icon, required this.title, required this.text, required this.badge, required this.onTap});
  final IconData icon;
  final String title;
  final String text;
  final Widget badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(radius: 22, backgroundColor: AppColors.tealLight, child: Icon(icon, color: AppColors.crystal)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  badge,
                ]),
                const SizedBox(height: 6),
                Text(text, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13, height: 1.6)),
              ]),
            ),
            const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
          ]),
        ),
      ),
    );
  }
}
