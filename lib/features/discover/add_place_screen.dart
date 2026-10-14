import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/auth/auth_service.dart';
import '../../core/location/where.dart';
import '../../core/places/directory_service.dart';
import '../../core/places/osm_places.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/phone_field.dart';

/// «ضيف محل»: a shop that isn't in the directory yet, at the user's current
/// position (no map) — anywhere in the Arab world (directory_add_place,
/// 0094). Guests are asked to sign in first.
Future<void> openAddPlace(BuildContext context, {String? category}) async {
  if (!AuthService.isSignedIn) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!AuthService.isSignedIn || !context.mounted) return;
  }
  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPlaceScreen(category: category)));
}

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key, this.category});
  final String? category;

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _wa = PhoneController();
  final _phone = TextEditingController();
  final _hours = TextEditingController();
  final _address = TextEditingController();
  late String? _category = directoryCategories.contains(widget.category) ? widget.category : null;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _wa.dispose();
    _phone.dispose();
    _hours.dispose();
    _address.dispose();
    super.dispose();
  }

  String? _t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final at = await Where.current();
      final id = await DirectoryService.addPlace(
        name: _name.text.trim(),
        category: _category!,
        lat: at.latitude,
        lng: at.longitude,
        whatsapp: _wa.isEmpty ? null : (_wa.stored ?? _wa.text.trim()),
        phone: _t(_phone),
        openingHours: _t(_hours),
        address: _t(_address),
      );
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('شكراً! المحل بقى في الدليل وأي حد حواليك يقدر يلاقيه')));
      context.pushReplacement('/d/$id');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(e is PostgrestException ? e.message : 'مقدرناش نحدد مكانك أو نحفظ المحل — جرّب تاني')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 680 ? (width - 640) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('ضيف محل')),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 16, side, 32),
          children: [
            const Text('محل أو صيدلية أو مطعم مش موجود في الدليل؟ ضيفه وخلّي جيرانك يلاقوه ويطلبوا منه.',
                style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'اسم المحل *'),
              validator: (v) => (v ?? '').trim().length < 2 ? 'اكتب اسم المحل' : null,
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'النشاط *'),
              items: [for (final c in directoryCategories) DropdownMenuItem(value: c, child: Text(c))],
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'اختار نشاط المحل' : null,
            ),
            const SizedBox(height: 12),
            PhoneFormField(controller: _wa, required: false, labelText: 'واتساب المحل (اختياري)', helperText: 'عشان الناس تطلب منه على واتساب'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(labelText: 'تليفون تاني / أرضي (اختياري)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hours,
              maxLength: 200,
              decoration: const InputDecoration(labelText: 'مواعيد الشغل (اختياري)', hintText: 'مثلاً: كل يوم من 9 الصبح لـ 12 بالليل'),
            ),
            TextFormField(
              controller: _address,
              maxLength: 300,
              decoration: const InputDecoration(labelText: 'العنوان (اختياري)', hintText: 'الشارع، علامة مميزة'),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [
                Icon(Icons.my_location_rounded, color: AppColors.teal, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('مكان المحل هيتسجّل من موقعك الحالي — ضيفه وإنت جوه المحل أو قدامه.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.6)),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_business_rounded),
                label: const Text('ضيف المحل', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
