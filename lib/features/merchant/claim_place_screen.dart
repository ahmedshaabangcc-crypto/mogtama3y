import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/geo/phones.dart';
import '../../core/routing/app_router.dart';
import '../../core/shops/place_claim_service.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../profile/phone_verify_screen.dart';
import '../shared/phone_field.dart';
import 'admin/admin_common.dart';
import 'starter_products_screen.dart';

/// «استلم محلك جاهز» (0111): `/claim/<place id>` — the owner of a place in
/// the directory gets a store already filled from it. With the place's
/// number verified by SMS the place is linked at once; otherwise an admin
/// reviews the claim and the store works meanwhile.
class ClaimPlaceScreen extends StatefulWidget {
  const ClaimPlaceScreen({super.key, required this.placeId});
  final String placeId;

  @override
  State<ClaimPlaceScreen> createState() => _ClaimPlaceScreenState();
}

class _ClaimPlaceScreenState extends State<ClaimPlaceScreen> {
  Map<String, dynamic>? _place;
  bool _loading = true;
  String? _loadError;

  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _whatsapp = PhoneController();
  String _category = StoreService.categories.first;
  bool _verified = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _slug.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final p = await PlaceClaimService.info(widget.placeId);
      if (!mounted) return;
      setState(() {
        _place = p;
        _loading = false;
        if (p != null) {
          _name.text = p['name'] as String? ?? '';
          _category = p['shop_category'] as String? ?? _category;
          _whatsapp.setPhone(p['phone'] as String?);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'مقدرناش نحمّل المحل، جرّب تاني';
        });
      }
    }
  }

  Future<void> _signIn() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (mounted) setState(() {});
  }

  Future<void> _verify() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PhoneVerifyScreen(initialPhone: _place?['phone'] as String?)),
    );
    if (ok == true && mounted) setState(() => _verified = true);
  }

  Future<void> _submit() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final r = await PlaceClaimService.claim(
        placeId: widget.placeId,
        slug: _slug.text.trim(),
        whatsapp: _whatsapp.stored ?? _whatsapp.text.trim(),
        name: _name.text.trim(),
        category: _category,
      );
      if (!mounted) return;
      final approved = r['status'] == 'approved';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(approved
            ? 'متجرك جاهز ✓ ومحلك في الدليل بقى بيفتح متجرك'
            : 'متجرك جاهز ✓ وطلب ربط المحل بيتراجع، هنبلغك أول ما يتوافق عليه'),
      ));
      // Ready-made products for the activity: the merchant only sets prices.
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StarterProductsScreen(shopId: r['shop_id'] as String, shopCategory: _category),
      ));
      if (mounted) context.go(isTajerApp ? '/' : AppRoutes.merchant);
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر استلام المحل، حاول مرة أخرى'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استلم محلك جاهز')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(child: Text(_loadError!))
              : _place == null
                  ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('المحل ده مش موجود في الدليل', textAlign: TextAlign.center)))
                  : Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: _body(_place!))),
    );
  }

  Widget _body(Map<String, dynamic> p) {
    final phone = p['phone'] as String?;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        child: ListTile(
          leading: const Icon(Icons.storefront_rounded, color: AppColors.gold, size: 32),
          title: Text(p['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text([p['category'], p['address'], if (phone != null && phone.isNotEmpty) displayPhone(phone)]
              .whereType<String>()
              .where((s) => s.isNotEmpty)
              .join('\n')),
          isThreeLine: true,
        ),
      ),
      const SizedBox(height: 12),
      if (p['claimed'] == true) ...[
        const Text('المحل ده ليه متجر بالفعل.', style: TextStyle(fontWeight: FontWeight.w700)),
        if (p['store_slug'] != null)
          TextButton(onPressed: () => context.go('/s/${p['store_slug']}'), child: const Text('افتح المتجر')),
      ] else if (!AuthService.isSignedIn) ...[
        const Text('ده محلك؟ استلمه متجر أونلاين جاهز باسمه وعنوانه ومكانه، ومنتجات جاهزة لنشاطه تحط أسعارها بس. ببلاش ومن غير عمولة.',
            style: TextStyle(height: 1.7)),
        const SizedBox(height: 16),
        FilledButton(key: const ValueKey('claim-sign-in'), onPressed: _signIn, child: const Text('سجّل دخول واستلم محلك')),
      ] else
        ..._form(phone),
    ]);
  }

  List<Widget> _form(String? phone) => [
        const Text('بياناته جاهزة من الدليل — راجعها واختار اسم الرابط.', style: TextStyle(fontSize: 13, color: AppColors.inkSecondary)),
        const SizedBox(height: 12),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المحل *')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'النشاط *'),
          items: [
            for (final c in {...StoreService.categories.where((c) => c != StoreService.otherActivity), _category})
              DropdownMenuItem(value: c, child: Text(c)),
          ],
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('claim-slug'),
          controller: _slug,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]'))],
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي *', hintText: 'elamal-pharmacy'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('رابطك: ${StoreService.storeUrl(_slug.text.trim().isEmpty ? '...' : _slug.text.trim().toLowerCase())}',
              textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 11, color: AppColors.teal)),
        ),
        const SizedBox(height: 10),
        PhoneFormField(controller: _whatsapp, labelText: 'رقم الواتساب لاستقبال الطلبات *'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              _verified
                  ? 'اتأكدنا من رقم المحل ✓ — المحل هيتربط بمتجرك على طول.'
                  : (phone == null || phone.isEmpty)
                      ? 'المحل مالوش رقم في الدليل، فطلبك هيتراجع من فريقنا خلال يوم، ومتجرك شغال من دلوقتي.'
                      : 'لو رقم المحل (${displayPhone(phone)}) معاك، أكّده برسالة SMS والمحل يتربط بمتجرك على طول. غير كده طلبك هيتراجع خلال يوم، ومتجرك شغال من دلوقتي.',
              style: const TextStyle(fontSize: 12.5, height: 1.6),
            ),
            if (!_verified && phone != null && phone.isNotEmpty)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(onPressed: _verify, icon: const Icon(Icons.sms_rounded, size: 18), label: const Text('أكّد رقم المحل')),
              ),
          ]),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          key: const ValueKey('claim-submit'),
          onPressed: _saving ? null : _submit,
          child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('استلم محلك'),
        ),
      ];
}
