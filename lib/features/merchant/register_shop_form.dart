import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/location/where.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/phone_field.dart';
import 'admin/admin_common.dart';

/// «سجّل محلك»: a merchant without a shop registers one (0047 create_my_shop).
class RegisterShopForm extends StatefulWidget {
  const RegisterShopForm({super.key, required this.onCreated});
  final VoidCallback onCreated;

  @override
  State<RegisterShopForm> createState() => _RegisterShopFormState();
}

class _RegisterShopFormState extends State<RegisterShopForm> {
  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _whatsapp = PhoneController();
  final _address = TextEditingController();
  final _otherActivity = TextEditingController();
  String _category = StoreService.categories.first;
  // Activities earlier merchants typed under "نشاط تاني".
  List<String> _learned = const [];
  bool _saving = false;
  String? _error;
  /// «محلي هنا»: pin the shop at the current position (directory listing).
  bool _pinHere = false;

  bool get _isOther => _category == StoreService.otherActivity;

  @override
  void initState() {
    super.initState();
    StoreService.learnedActivities().then((l) {
      if (mounted) setState(() => _learned = l);
    });
  }

  @override
  void dispose() {
    _otherActivity.dispose();
    _name.dispose();
    _slug.dispose();
    _whatsapp.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final typed = _otherActivity.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (_isOther && typed.length < 2) {
      setState(() => _error = 'اكتب نشاط محلك');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final shopId = await StoreService.createMyShop(
        name: _name.text.trim(),
        category: _isOther ? typed : _category,
        slug: _slug.text.trim(),
        whatsapp: _whatsapp.stored ?? _whatsapp.text.trim(),
        address: _address.text.trim(),
      );
      if (_pinHere) {
        // Best effort: the shop exists either way; the location can wait.
        try {
          final at = await Where.current();
          await StoreService.setMyShopLocation(shopId: shopId, lat: at.latitude, lng: at.longitude);
        } catch (_) {}
      }
      widget.onCreated();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = adminErrorText(e, 'تعذر تسجيل المحل، حاول مرة أخرى'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('متجر أونلاين مجاني لمحلك، من غير عمولة ولا اشتراك.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        const Text('هتاخد رابط وQR باسم محلك، وزباينك يطلبوا منك والطلب يوصلك على لوحة محلك، والزبون يقدر يبعتهولك واتساب كمان.', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6)),
        const SizedBox(height: 16),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المحل *')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'النشاط *'),
          items: [
            for (final c in StoreService.categories)
              if (c != StoreService.otherActivity) DropdownMenuItem(value: c, child: Text(c)),
            for (final c in _learned) DropdownMenuItem(value: c, child: Text(c)),
            const DropdownMenuItem(value: StoreService.otherActivity, child: Text('${StoreService.otherActivity} (اكتبه بنفسك)')),
          ],
          onChanged: (v) => setState(() => _category = v ?? _category),
        ),
        if (_isOther) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _otherActivity,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'اكتب نشاط محلك *', hintText: 'مثلاً: مكتبة، ورد، أدوات صحية'),
          ),
          // Matching activities other merchants already typed — one tap picks it.
          if (_otherActivity.text.trim().isNotEmpty)
            Wrap(spacing: 6, children: [
              for (final a in _learned.where((a) => a.contains(_otherActivity.text.trim())).take(6))
                ActionChip(label: Text(a), onPressed: () => setState(() => _category = a)),
            ]),
        ],
        const SizedBox(height: 10),
        TextField(
          controller: _slug,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]'))],
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي *', hintText: 'elsalam'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('رابطك: ${StoreService.storeUrl(_slug.text.trim().toLowerCase().isEmpty ? '...' : _slug.text.trim().toLowerCase())}',
              textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 11, color: AppColors.teal)),
        ),
        const SizedBox(height: 10),
        PhoneFormField(controller: _whatsapp, labelText: 'رقم الواتساب لاستقبال الطلبات *'),
        const SizedBox(height: 10),
        TextField(controller: _address, decoration: const InputDecoration(labelText: 'العنوان (المحافظة، الحي، الشارع)')),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _pinHere,
          onChanged: (v) => setState(() => _pinHere = v),
          title: const Text('أنا في المحل دلوقتي — سجّل مكانه', style: TextStyle(fontSize: 13.5)),
          subtitle: const Text('محلك يظهر للناس اللي حواليك في «اكتشف حواليك»', style: TextStyle(fontSize: 11.5)),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
            child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('سجّل محلك ببلاش'),
          ),
        ),
      ],
    );
  }
}
