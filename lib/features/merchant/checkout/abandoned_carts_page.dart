import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/geo/money.dart';
import '../../../core/geo/phones.dart';
import '../../../core/shops/checkout_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/load_error_view.dart';
import '../admin/admin_common.dart';
import '../admin/merchant_session.dart';

/// «سلات متروكة» (/orders/abandoned, 0099): customers who typed their
/// phone at checkout and left without ordering (idle for more than an
/// hour). «كمّل طلبك» opens WhatsApp with a message and the link that
/// refills their cart. Only the shop's owner sees them; they are deleted
/// after 30 days.
class AbandonedCartsPage extends StatefulWidget {
  const AbandonedCartsPage({super.key});

  @override
  State<AbandonedCartsPage> createState() => _AbandonedCartsPageState();
}

/// The «كمّل طلبك» WhatsApp message.
String recoverMessage({required String shopName, required String? name, required String link}) => [
      'أهلاً${name == null || name.isEmpty ? '' : ' $name'} 👋',
      'شفنا إنك كنت بتطلب من $shopName ومكملتش الطلب.',
      'سلتك لسه محفوظة — كمّل طلبك من هنا:',
      link,
    ].join('\n');

String _ago(String? iso) {
  final t = DateTime.tryParse(iso ?? '');
  if (t == null) return '';
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 60) return 'من ${d.inMinutes} دقيقة';
  if (d.inHours < 24) return 'من ${d.inHours} ساعة';
  return 'من ${d.inDays} يوم';
}

class _AbandonedCartsPageState extends State<AbandonedCartsPage> {
  String? _shopId;
  Map<String, dynamic>? _data;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = MerchantScope.of(context).shopId;
    if (id != null && id != _shopId) {
      _shopId = id;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final d = await CheckoutService.abandonedCarts(_shopId!);
      if (mounted) setState(() => _data = d);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _remind(Map<String, dynamic> c) async {
    final shop = MerchantScope.of(context).shop!;
    final link = CheckoutService.cartUrl(shop['slug'] as String? ?? '', c['token'] as String);
    final text = recoverMessage(shopName: shop['name'] as String? ?? '', name: c['name'] as String?, link: link);
    await launchUrl(waLink(c['phone'] as String?, text: text), mode: LaunchMode.externalApplication);
    try {
      await CheckoutService.markReminded(c['id'] as String);
      if (mounted) setState(() => c['reminded_at'] = DateTime.now().toUtc().toIso8601String());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currency = currencyOf(MerchantScope.of(context).shop);
    final d = _data;
    final carts = [for (final c in d?['carts'] as List? ?? const []) Map<String, dynamic>.from(c as Map)];
    return AdminPage(
      title: 'سلات متروكة',
      subtitle: 'زباين كتبوا رقمهم ومكملوش الطلب — فكّرهم على واتساب',
      backTo: '/orders',
      scrollable: true,
      maxWidth: 980,
      actions: [IconButton(tooltip: 'تحديث', onPressed: _load, icon: const Icon(Icons.refresh_rounded))],
      body: _failed
          ? LoadErrorView(onRetry: _load)
          : d == null
              ? const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
              : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  if (((d['recovered_count'] as num?) ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AdminCard(
                        child: Row(children: [
                          const Icon(Icons.celebration_rounded, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('رجّعت ${d['recovered_count']} سلة بعد التذكير — ${money((d['recovered_value'] as num?) ?? 0, currency)} مبيعات',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ]),
                      ),
                    ),
                  if (carts.isEmpty)
                    const AdminCard(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('مفيش سلات متروكة دلوقتي 👌\nأول ما زبون يكتب رقمه في السلة ويمشي من غير ما يطلب (لأكتر من ساعة) هيظهر هنا.',
                            textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary, height: 1.7)),
                      ),
                    ),
                  for (final c in carts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AdminCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(c['name'] as String? ?? 'زبون', style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(
                                  [
                                    displayPhone(c['phone'] as String?),
                                    if ((c['area'] as String?)?.isNotEmpty ?? false) c['area'],
                                    _ago(c['updated_at'] as String?),
                                  ].join(' • '),
                                  style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                                ),
                              ]),
                            ),
                            Text(money((c['subtotal'] as num?) ?? 0, currency), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.crystal)),
                          ]),
                          const SizedBox(height: 6),
                          Text(
                            [for (final l in c['lines'] as List? ?? const []) '${l['name']}${(l['options'] as String?)?.isNotEmpty ?? false ? ' (${l['options']})' : ''} × ${l['quantity']}'].join('، '),
                            style: const TextStyle(color: AppColors.inkSecondary),
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            if (c['reminded_at'] != null) const Pill('اتبعتله تذكير', AppColors.surfaceAlt, AppColors.inkSecondary, icon: Icons.check_rounded),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () => _remind(c),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                              icon: const Icon(Icons.chat_rounded, size: 18),
                              label: const Text('كمّل طلبك'),
                            ),
                          ]),
                        ]),
                      ),
                    ),
                  const SizedBox(height: 6),
                  const Text('السلات بتتمسح لوحدها بعد 30 يوم. محدش غيرك بيشوفها.', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                ]),
    );
  }
}
