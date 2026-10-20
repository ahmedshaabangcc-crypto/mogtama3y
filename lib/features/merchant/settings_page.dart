import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/demo/demo_mode.dart';
import '../../core/demo/demo_store.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/phone_field.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'store_currency_card.dart';
import 'store_qr_card_screen.dart';

/// «متجري» (/settings): the store's look, links to «الشحن والتوصيل» and
/// «الربط والتكاملات», link / QR and visits.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MerchantScope.of(context);
    final shop = session.shop!;
    return AdminPage(
      title: 'متجري',
      subtitle: 'شكل المتجر، التوصيل، الرابط والـ QR',
      maxWidth: 820,
      body: _SettingsBody(key: ValueKey('s${shop['id']}'), shop: shop, onChanged: session.load),
    );
  }
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody({super.key, required this.shop, required this.onChanged});
  final Map<String, dynamic> shop;
  final VoidCallback onChanged;

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  late final _slug = TextEditingController(text: widget.shop['slug'] as String? ?? '');
  late final _whatsapp = PhoneController(phone: widget.shop['whatsapp'] as String?);
  bool _saving = false;

  @override
  void dispose() {
    _slug.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  Future<void> _saveLink() async {
    setState(() => _saving = true);
    try {
      await StoreService.updateShopLink(shopId: widget.shop['id'] as String, slug: _slug.text, whatsapp: _whatsapp.stored ?? _whatsapp.text);
      widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      final msg = e is PostgrestException && e.code == '23505'
          ? 'اسم الرابط ده مستخدم، جرّب اسم تاني'
          : 'تأكد إن اسم الرابط بالإنجليزي (3–40 حرف) ورقم الواتساب صحيح';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _shared() => StoreService.markShared(widget.shop['id'] as String);

  @override
  Widget build(BuildContext context) {
    final slug = widget.shop['slug'] as String?;
    final hasLink = slug != null && slug.isNotEmpty && (widget.shop['whatsapp'] as String?)?.isNotEmpty == true;

    if (!hasLink) {
      return ListView(padding: const EdgeInsets.only(top: 4, bottom: 32), children: [
        const Text('اختار رابط محلك ورقم الواتساب عشان تبدأ تستقبل طلبات', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(controller: _slug, textDirection: TextDirection.ltr, decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي', hintText: 'elsalam')),
        const SizedBox(height: 10),
        PhoneFormField(controller: _whatsapp, labelText: 'رقم الواتساب'),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _saving ? null : _saveLink, child: const Text('حفظ')),
      ]);
    }

    final url = StoreService.storeUrl(slug);
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 32),
      children: [
        StoreProfileCard(shop: widget.shop, onSaved: widget.onChanged),
        const SizedBox(height: 14),
        // «الربط والتكاملات» (0097): payments, domain, pixels.
        AdminCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.hub_rounded, color: AppColors.crystal),
            title: const Text('الربط والتكاملات', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: const Text('طرق الدفع، الدومين، البكسل والتاجز'),
            trailing: const Icon(Icons.chevron_left_rounded),
            onTap: () => GoRouter.of(context).go('/settings/integrations'),
          ),
        ),
        const SizedBox(height: 14),
        StoreCurrencyCard(shop: widget.shop, onSaved: widget.onChanged),
        const SizedBox(height: 14),
        // «الشحن والتوصيل» (0099): zones, pickup, hours, minimum order.
        AdminCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            key: const ValueKey('open-shipping'),
            leading: const Icon(Icons.local_shipping_rounded, color: AppColors.crystal),
            title: const Text('الشحن والتوصيل', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${StoreService.deliveryLabel(widget.shop)} • مناطق، استلام من المحل، مواعيد'),
            trailing: const Icon(Icons.chevron_left_rounded),
            onTap: () => GoRouter.of(context).go('/settings/shipping'),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            const Text('علّق الكود ده على واجهة المحل', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            SizedBox(width: 220, height: 220, child: QrImageView(data: url, backgroundColor: Colors.white, eyeStyle: const QrEyeStyle(color: AppColors.navy), dataModuleStyle: const QrDataModuleStyle(color: AppColors.navy))),
            const SizedBox(height: 8),
            SelectableText(url, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, alignment: WrapAlignment.center, children: [
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: url));
                  _shared();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرابط')));
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('انسخ الرابط'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _shared();
                  launchUrl(Uri.parse('https://wa.me/?text=${Uri.encodeComponent('اطلب من ${widget.shop['name']} أونلاين: $url')}'), mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.share_rounded, size: 16),
                label: const Text('شارك على واتساب'),
              ),
            ]),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _shared();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => StoreQrCardScreen(shopName: widget.shop['name'] as String? ?? '', slug: slug, url: url),
                  ));
                },
                icon: const Icon(Icons.print_rounded, size: 18),
                label: const Text('تحميل / طباعة الـ QR'),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.qr_code_scanner_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            const Expanded(child: Text('عدد مرات فتح متجرك', style: TextStyle(color: Colors.white70))),
            Text('${widget.shop['scan_count'] ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
          ]),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.open_in_new_rounded, size: 16),
          label: const Text('شوف متجرك زي الزبون'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// Store profile: name, description, logo, cover
// ---------------------------------------------------------------------

class StoreProfileCard extends StatefulWidget {
  const StoreProfileCard({super.key, required this.shop, required this.onSaved});
  final Map<String, dynamic> shop;
  final VoidCallback onSaved;

  @override
  State<StoreProfileCard> createState() => _StoreProfileCardState();
}

class _StoreProfileCardState extends State<StoreProfileCard> {
  late final _name = TextEditingController(text: widget.shop['name'] as String? ?? '');
  late final _desc = TextEditingController(text: widget.shop['description'] as String? ?? '');
  late String? _logo = widget.shop['logo_url'] as String?;
  late String? _cover = widget.shop['cover_image_url'] as String?;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<String?> _pick() async {
    // Demo build: a bundled sample photo instead of the (empty) file picker.
    if (kDemo) return demoSamplePhoto(name: _name.text, taken: [?_logo, ?_cover]);
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    setState(() => _busy = true);
    try {
      return await UploadService.uploadPublicPhoto(purpose: 'products', file: file);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الصورة')));
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickCover() async {
    final url = await _pick();
    if (url != null) setState(() => _cover = url);
  }

  Future<void> _pickLogo() async {
    final url = await _pick();
    if (url != null) setState(() => _logo = url);
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await StoreService.updateShopProfile(
        shopId: widget.shop['id'] as String,
        name: _name.text.trim(),
        description: _desc.text.trim(),
        logoUrl: _logo,
        coverUrl: _cover,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظ شكل متجرك')));
      widget.onSaved();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر الحفظ'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          onTap: _busy ? null : _pickCover,
          child: SizedBox(
            height: 130,
            child: Stack(fit: StackFit.expand, children: [
              if (_cover == null)
                const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.brandGradient))
              else
                Image.network(_cover!, fit: BoxFit.cover),
              const PositionedDirectional(bottom: 8, end: 8, child: Pill('📷 غيّر الغلاف', Colors.black54, Colors.white)),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              InkWell(
                onTap: _busy ? null : _pickLogo,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                    image: _logo != null ? DecorationImage(image: NetworkImage(_logo!), fit: BoxFit.cover) : null,
                  ),
                  child: _logo == null ? const Icon(Icons.add_photo_alternate_outlined, color: AppColors.inkMuted) : null,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('لوجو وغلاف متجرك بيظهروا للزبون أول ما يفتح المتجر', style: TextStyle(fontSize: 12, color: AppColors.inkMuted))),
            ]),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المتجر')),
            const SizedBox(height: 10),
            TextField(
              controller: _desc,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(labelText: 'وصف المتجر', hintText: 'بتبيع إيه؟ بتوصّل فين؟ مواعيدك؟', alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _save,
              child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('حفظ شكل المتجر'),
            ),
          ]),
        ),
      ]),
    );
  }
}
