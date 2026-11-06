import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/admin/admin_console_service.dart';
import '../../../core/geo/phones.dart';
import '../../../core/shops/starter_catalog.dart';
import '../../../core/shops/store_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../merchant/admin/admin_common.dart';
import 'console_widgets.dart';

/// «جهّزنالك متجرك» (0112): after a phone call where a shop owner agrees and
/// gives their prices, the team builds the store from the directory place;
/// the owner then claims it with the link (or the number they gave).
class AdminPrepareStorePage extends StatefulWidget {
  const AdminPrepareStorePage({super.key});

  @override
  State<AdminPrepareStorePage> createState() => _AdminPrepareStorePageState();
}

/// A product row: from the activity's ready-made list, or typed.
class _Item {
  _Item({required this.name, this.starter});
  final StarterProduct? starter;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController price = TextEditingController();
  String name;

  Map<String, dynamic>? toJson() {
    final p = num.tryParse(price.text.trim().replaceAll(',', '.'));
    final n = (starter == null ? nameCtrl.text : name).trim();
    if (p == null || p <= 0 || n.length < 2) return null;
    final s = starter;
    return {
      'name': n,
      'price': p,
      if (s != null) ...{
        'category': s.section,
        'description': s.description,
        'highlights': s.highlights,
        'images': [?s.imageUrl],
        'image_url': s.imageUrl,
        'options': [
          if (s.sizes.isNotEmpty) {'name': 'الحجم', 'values': s.sizes},
        ],
      },
    };
  }
}

class _AdminPrepareStorePageState extends State<AdminPrepareStorePage> {
  final _q = TextEditingController();
  final _slug = TextEditingController();
  final _whatsapp = TextEditingController();
  List<Map<String, dynamic>>? _results;
  List<Map<String, dynamic>>? _waiting;
  Map<String, dynamic>? _place;
  String _category = StoreService.categories.first;
  List<_Item> _items = [];
  bool _saving = false;
  Map<String, dynamic>? _done;

  @override
  void initState() {
    super.initState();
    _loadWaiting();
  }

  Future<void> _loadWaiting() async {
    try {
      final w = await AdminConsoleService.preparedStores();
      if (mounted) setState(() => _waiting = w);
    } catch (_) {}
  }

  void _toast(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _search() async {
    final q = _q.text.trim();
    if (q.length < 2) return;
    try {
      final r = await AdminConsoleService.searchPlaces(q);
      if (mounted) setState(() => _results = r);
    } catch (e) {
      _toast(isAdminDenied(e) ? 'غير مصرح لك' : 'تعذر البحث: $e');
    }
  }

  void _pick(Map<String, dynamic> p) {
    setState(() {
      _place = p;
      _done = null;
      _whatsapp.text = '${p['whatsapp'] ?? p['phone'] ?? ''}';
      _slug.clear();
      _setCategory(_categoryOf('${p['category'] ?? ''}'));
    });
  }

  /// Same mapping as the database (private.shop_category_of_dir).
  String _categoryOf(String dir) => switch (dir) {
        'صيدليات' => 'صيدلية / مستحضرات',
        'سوبر ماركت وبقالة' => 'سوبر ماركت / بقالة',
        'مطاعم' || 'كافيهات' => 'مطعم / كافيه',
        'ملابس وأزياء' => 'ملابس وأحذية',
        'إلكترونيات وموبايلات' => 'موبايلات وإكسسوارات',
        'أدوات منزلية وأثاث' => 'أدوات منزلية',
        _ => StoreService.categories.first,
      };

  void _setCategory(String c) {
    _category = c;
    _items = [for (final s in starterCatalog[c] ?? const <StarterProduct>[]) _Item(name: s.name, starter: s)];
  }

  Future<void> _submit() async {
    final products = [for (final i in _items) ?i.toJson()];
    if (products.isEmpty) return _toast('اكتب سعر منتج واحد على الأقل');
    setState(() => _saving = true);
    try {
      final r = await AdminConsoleService.preparePlaceStore(
        placeId: '${_place!['id']}',
        slug: _slug.text.trim(),
        whatsapp: _whatsapp.text.trim(),
        category: _category,
        products: products,
      );
      if (!mounted) return;
      setState(() => _done = r);
      _loadWaiting();
    } catch (e) {
      _toast(adminErrorText(e, 'تعذر تجهيز المتجر'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// The message for the owner, with their claim link.
  String _message(String name, String url) =>
      'أهلاً 👋 متجر «$name» على مُجتمعي جاهز بالمنتجات والأسعار اللي اتفقنا عليها.\n'
      'استلمه من هنا، وأكّد رقمك برسالة SMS، والطلبات هتوصلك على طول:\n$url';

  Future<void> _sendWhatsApp(String phone, String name, String url) async {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '').replaceFirst(RegExp(r'^0'), '20');
    await launchUrl(Uri.parse('https://wa.me/$digits?text=${Uri.encodeComponent(_message(name, url))}'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final place = _place;
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text(
        'كلّم صاحب المحل الأول: لو موافق، خد منه أسعار أهم منتجاته واعمله المتجر هنا. بعد كده ابعتله لينك الاستلام، وأول ما يأكّد رقمه المتجر يبقى بتاعه.',
        style: TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.6),
      ),
      if ((_waiting ?? const []).isNotEmpty) ...[
        const SizedBox(height: 16),
        ConsolePanel(
          title: 'متاجر مستنية أصحابها (${_waiting!.length})',
          child: Column(children: [
            for (final w in _waiting!)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('${w['name']}'),
                subtitle: Text('${w['products']} منتج — ${displayPhone('${w['whatsapp'] ?? ''}')}'),
                trailing: IconButton(
                  tooltip: 'ابعتله اللينك على واتساب',
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () => _sendWhatsApp('${w['whatsapp']}', '${w['name']}', '${w['claim_url']}'),
                ),
              ),
          ]),
        ),
      ],
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
          child: TextField(
            key: const ValueKey('prep-search'),
            controller: _q,
            onSubmitted: (_) => _search(),
            decoration: const InputDecoration(labelText: 'دوّر على المحل في الدليل (الاسم)', prefixIcon: Icon(Icons.search_rounded)),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(onPressed: _search, child: const Text('بحث')),
      ]),
      if (_results != null && place == null) ...[
        const SizedBox(height: 8),
        if (_results!.isEmpty) const Text('مفيش نتايج'),
        for (final p in _results!)
          ListTile(
            key: ValueKey('prep-place-${p['id']}'),
            title: Text('${p['name']}'),
            subtitle: Text([p['category'], p['address'], p['phone']].where((x) => x != null && '$x'.isNotEmpty).join(' — ')),
            trailing: p['claimed_shop_id'] != null ? const ConsolePill('ليه متجر', color: AppColors.inkMuted) : const Icon(Icons.chevron_left_rounded),
            onTap: p['claimed_shop_id'] != null ? null : () => _pick(p),
          ),
      ],
      if (place != null) ...[
        const SizedBox(height: 16),
        ConsolePanel(
          title: '${place['name']}',
          trailing: TextButton(onPressed: () => setState(() => _place = null), child: const Text('محل تاني')),
          child: _done != null ? _result(place) : _form(place),
        ),
      ],
    ]);
  }

  Widget _result(Map<String, dynamic> place) {
    final url = '${_done!['claim_url']}';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('المتجر جاهز ✓ — ${_done!['products']} منتج، ورابطه ${StoreService.storeUrl('${_done!['slug']}')}',
          style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      SelectableText(url, textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.teal)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [
        FilledButton.icon(
          key: const ValueKey('prep-send'),
          onPressed: () => _sendWhatsApp(_whatsapp.text, '${place['name']}', url),
          icon: const Icon(Icons.send_rounded, size: 18),
          label: const Text('ابعتله اللينك على واتساب'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _message('${place['name']}', url)));
            _toast('اتنسخت الرسالة ✓');
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text('انسخ الرسالة'),
        ),
      ]),
    ]);
  }

  Widget _form(Map<String, dynamic> place) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text([place['category'], place['address']].where((x) => x != null).join(' — '), style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('prep-slug'),
          controller: _slug,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-]'))],
          decoration: const InputDecoration(labelText: 'اسم الرابط بالإنجليزي *', hintText: 'elnour-pharmacy'),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('prep-whatsapp'),
          controller: _whatsapp,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(labelText: 'واتساب صاحب المحل (اللي كلّمته) *'),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _category,
          decoration: const InputDecoration(labelText: 'النشاط'),
          items: [
            for (final c in StoreService.categories.where((c) => c != StoreService.otherActivity)) DropdownMenuItem(value: c, child: Text(c)),
          ],
          onChanged: (v) => setState(() => _setCategory(v ?? _category)),
        ),
        const SizedBox(height: 12),
        const Text('الأسعار اللي قالها صاحب المحل (سيب الخانة فاضية للمنتج اللي مش عنده):', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        for (final (i, it) in _items.indexed)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              Expanded(
                child: it.starter != null
                    ? Text(it.name)
                    : TextField(controller: it.nameCtrl, decoration: const InputDecoration(labelText: 'اسم المنتج', isDense: true)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: TextField(
                  key: ValueKey('prep-price-$i'),
                  controller: it.price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'السعر', isDense: true),
                ),
              ),
            ]),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => _items.add(_Item(name: ''))),
            icon: const Icon(Icons.add_rounded),
            label: const Text('منتج تاني'),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const ValueKey('prep-submit'),
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'بنجهّز…' : 'جهّز المتجر'),
        ),
      ]);
}
