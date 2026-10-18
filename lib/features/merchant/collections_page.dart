import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/shops/catalog.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';

/// `/collections` («الأقسام», 0098): the shop's collections in the
/// storefront's order (drag to reorder), each with its products count,
/// hidden / smart badges. `/collections/new`, `/collections/:id`: the
/// editor — name, description, photo, visibility, and either the manual
/// product list (add, remove, drag to order) or the smart rules (tag,
/// price range, in stock only).
class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = MerchantScope.of(context).shop!;
    return _CollectionsView(key: ValueKey('c${shop['id']}'), shopId: shop['id'] as String);
  }
}

class _CollectionsView extends StatefulWidget {
  const _CollectionsView({super.key, required this.shopId});
  final String shopId;

  @override
  State<_CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<_CollectionsView> {
  MerchantCatalog? _catalog;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final c = await StoreService.merchantCatalog(widget.shopId);
      if (mounted) setState(() => _catalog = c);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  Future<void> _reorder(int from, int to) async {
    final list = [..._catalog!.collections];
    list.insert(to, list.removeAt(from));
    setState(() => _catalog = MerchantCatalog(products: _catalog!.products, collections: list, lowStockThreshold: _catalog!.lowStockThreshold));
    try {
      await StoreService.reorderCollections(widget.shopId, [for (final c in list) c['id'] as String]);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(adminErrorText(e, 'تعذر حفظ الترتيب'))));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < AdminBreakpoints.rail;
    final c = _catalog;
    Widget body;
    if (_error) {
      body = LoadErrorView(onRetry: _load);
    } else if (c == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (c.collections.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircleAvatar(radius: 32, backgroundColor: AppColors.tealLight, child: Icon(Icons.category_rounded, size: 32, color: AppColors.crystal)),
            const SizedBox(height: 12),
            const Text('قسّم منتجاتك لأقسام', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 6),
            const Text('الأقسام بتظهر للزبون فوق المنتجات في متجرك (زي: تيشيرتات، بناطيل، عروض).',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
            const SizedBox(height: 14),
            ElevatedButton.icon(onPressed: () => context.go('/collections/new'), icon: const Icon(Icons.add_rounded), label: const Text('أول قسم')),
          ]),
        ),
      );
    } else {
      final products = {for (final p in c.products) p['id']: p};
      body = RefreshIndicator(
        onRefresh: _load,
        child: ReorderableListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          buildDefaultDragHandles: false,
          itemCount: c.collections.length,
          onReorderItem: _reorder,
          header: const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('اسحب ⠿ عشان ترتّب الأقسام زي ما هتظهر في المتجر.', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
          ),
          itemBuilder: (context, i) {
            final col = c.collections[i];
            final ids = (col['product_ids'] as List? ?? const []);
            final cover = col['image_url'] as String? ??
                ids.map((id) => products[id]).whereType<Map<String, dynamic>>().map(StoreService.imagesOf).firstWhere((l) => l.isNotEmpty, orElse: () => const []).firstOrNull;
            return Padding(
              key: ValueKey('col-${col['id']}'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  onTap: () => context.go('/collections/${col['id']}'),
                  leading: Row(mainAxisSize: MainAxisSize.min, children: [
                    ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_indicator_rounded, color: AppColors.inkMuted)),
                    const SizedBox(width: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cover == null
                          ? Container(width: 44, height: 44, color: AppColors.surfaceAlt, child: const Icon(Icons.category_outlined, color: AppColors.inkMuted))
                          : Image.network(cover, width: 44, height: 44, cacheWidth: 120, fit: BoxFit.cover),
                    ),
                  ]),
                  title: Text(col['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${ids.length} منتج${col['rules'] != null ? ' • بيتملا لوحده' : ''}'),
                  trailing: Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    if (col['rules'] != null) const Pill('ذكي', AppColors.tealLight, AppColors.crystal, icon: Icons.auto_awesome_rounded),
                    if (col['is_visible'] == false) const Pill('مخفي', AppColors.surfaceAlt, AppColors.inkSecondary),
                    const Icon(Icons.chevron_left_rounded),
                  ]),
                ),
              ),
            );
          },
        ),
      );
    }
    return AdminPage(
      title: 'الأقسام',
      subtitle: c == null ? null : '${c.collections.length} قسم',
      actions: [
        if (!narrow) ElevatedButton.icon(onPressed: () => context.go('/collections/new'), icon: const Icon(Icons.add_rounded, size: 18), label: const Text('قسم جديد')),
      ],
      floatingActionButton: narrow
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/collections/new'),
              backgroundColor: AppColors.teal,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('قسم جديد', style: TextStyle(color: Colors.white)),
            )
          : null,
      maxWidth: 900,
      body: body,
    );
  }
}

/// `/collections/new`, `/collections/:id`.
class CollectionEditorPage extends StatefulWidget {
  const CollectionEditorPage({super.key, this.collectionId});
  final String? collectionId;

  @override
  State<CollectionEditorPage> createState() => _CollectionEditorPageState();
}

class _CollectionEditorPageState extends State<CollectionEditorPage> {
  MerchantCatalog? _catalog;
  bool _error = false;
  bool _missing = false;
  bool _saving = false;
  bool _uploading = false;
  String? _problem;

  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _tag = TextEditingController();
  final _minPrice = TextEditingController();
  final _maxPrice = TextEditingController();
  String? _image;
  bool _visible = true;
  bool _smart = false;
  bool _inStock = false;
  List<String> _productIds = [];

  String get _shopId => MerchantScope.of(context).shop!['id'] as String;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_catalog == null && !_error) _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _tag.dispose();
    _minPrice.dispose();
    _maxPrice.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final c = await StoreService.merchantCatalog(_shopId);
      if (!mounted) return;
      final col = widget.collectionId == null ? null : c.collections.where((x) => x['id'] == widget.collectionId).firstOrNull;
      setState(() {
        _catalog = c;
        _missing = widget.collectionId != null && col == null;
        if (col != null) {
          _name.text = col['name'] as String? ?? '';
          _desc.text = col['description'] as String? ?? '';
          _image = col['image_url'] as String?;
          _visible = col['is_visible'] != false;
          final rules = col['rules'] as Map?;
          _smart = rules != null;
          _tag.text = rules?['tag'] as String? ?? '';
          _minPrice.text = rules?['min_price']?.toString() ?? '';
          _maxPrice.text = rules?['max_price']?.toString() ?? '';
          _inStock = rules?['in_stock'] == true;
          _productIds = [for (final id in col['product_ids'] as List? ?? const []) '$id'];
        }
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  Map<String, dynamic>? get _rules {
    if (!_smart) return null;
    return {
      if (_tag.text.trim().isNotEmpty) 'tag': _tag.text.trim(),
      if (looseDouble(_minPrice.text.trim()) != null) 'min_price': looseDouble(_minPrice.text.trim()),
      if (looseDouble(_maxPrice.text.trim()) != null) 'max_price': looseDouble(_maxPrice.text.trim()),
      if (_inStock) 'in_stock': true,
    };
  }

  /// What a smart collection holds right now (the same rules as the server).
  List<Map<String, dynamic>> get _smartPreview {
    final r = _rules ?? const {};
    return [
      for (final p in _catalog?.products ?? const <Map<String, dynamic>>[])
        if (productStatusOf(p) != 'archived' &&
            (r['tag'] == null || (p['tags'] as List? ?? const []).contains(r['tag'])) &&
            (r['min_price'] == null || ((p['price'] as num?) ?? 0) >= (r['min_price'] as num)) &&
            (r['max_price'] == null || ((p['price'] as num?) ?? 0) <= (r['max_price'] as num)) &&
            (r['in_stock'] != true || !allSoldOut(p)))
          p,
    ];
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _problem = 'اكتب اسم القسم');
      return;
    }
    if (_smart && (_rules ?? const {}).isEmpty) {
      setState(() => _problem = 'القسم الذكي محتاج شرط واحد على الأقل');
      return;
    }
    setState(() {
      _saving = true;
      _problem = null;
    });
    try {
      final id = await StoreService.saveCollection(_shopId, {
        'id': widget.collectionId,
        'name': _name.text.trim(),
        'description': _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        'image_url': _image,
        'is_visible': _visible,
        'rules': _rules,
      });
      if (!_smart) await StoreService.setCollectionProducts(id, _productIds);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظ القسم')));
      context.go('/collections');
    } catch (e) {
      if (mounted) setState(() => _problem = adminErrorText(e, 'تعذر حفظ القسم'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('حذف القسم'),
        content: const Text('القسم بس هيتمسح — المنتجات نفسها هتفضل زي ما هي.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await StoreService.deleteCollection(widget.collectionId!);
      if (mounted) context.go('/collections');
    } catch (e) {
      if (mounted) setState(() => _problem = adminErrorText(e, 'تعذر الحذف'));
    }
  }

  Future<void> _pickImage() async {
    final f = await UploadService.pickImage(source: ImageSource.gallery);
    if (f == null) return;
    setState(() => _uploading = true);
    try {
      final url = await UploadService.uploadPublicPhoto(purpose: 'products', file: f);
      if (mounted) setState(() => _image = url);
    } catch (_) {
      if (mounted) setState(() => _problem = 'الصورة مارفعتش، جرّب تاني');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _addProducts() async {
    final all = (_catalog?.products ?? const <Map<String, dynamic>>[]).where((p) => productStatusOf(p) != 'archived' && !_productIds.contains(p['id'])).toList();
    final picked = await showDialog<List<String>>(context: context, builder: (_) => _ProductPicker(products: all));
    if (picked == null || picked.isEmpty) return;
    setState(() => _productIds = [..._productIds, ...picked]);
  }

  Widget _details() => AdminCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(key: const ValueKey('collection-name'), controller: _name, decoration: const InputDecoration(labelText: 'اسم القسم *', hintText: 'مثلاً: تيشيرتات')),
          const SizedBox(height: 10),
          TextField(controller: _desc, maxLines: 3, minLines: 2, maxLength: 1000, decoration: const InputDecoration(labelText: 'وصف (اختياري)', alignLabelWithHint: true)),
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _image == null
                  ? Container(width: 64, height: 64, color: AppColors.surfaceAlt, child: const Icon(Icons.image_outlined, color: AppColors.inkMuted))
                  : Image.network(_image!, width: 64, height: 64, cacheWidth: 200, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: _uploading ? null : _pickImage,
              icon: _uploading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.photo_library_rounded, size: 18),
              label: const Text('صورة القسم'),
            ),
            if (_image != null) IconButton(tooltip: 'شيل الصورة', onPressed: () => setState(() => _image = null), icon: const Icon(Icons.close_rounded)),
          ]),
          const SizedBox(height: 6),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('ظاهر في المتجر'),
            subtitle: const Text('لو قفلته القسم بيستخبى عن الزباين (المنتجات نفسها بتفضل ظاهرة).'),
            value: _visible,
            onChanged: (v) => setState(() => _visible = v),
          ),
        ]),
      );

  Widget _kind() => AdminCard(
        title: 'المنتجات',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: false, label: Text('أختارهم بنفسي'), icon: Icon(Icons.touch_app_outlined, size: 16)),
              ButtonSegment(value: true, label: Text('ذكي (بشروط)'), icon: Icon(Icons.auto_awesome_rounded, size: 16)),
            ],
            selected: {_smart},
            onSelectionChanged: (v) => setState(() => _smart = v.first),
          ),
          const SizedBox(height: 10),
          if (_smart) ..._smartFields() else ..._manualList(),
        ]),
      );

  List<Widget> _smartFields() {
    final preview = _smartPreview;
    return [
      const Text('أي منتج يطابق كل الشروط دي بيدخل القسم لوحده:', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
      const SizedBox(height: 8),
      TextField(controller: _tag, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'عليه الوسم', hintText: 'مثلاً: صيفي')),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: TextField(controller: _minPrice, onChanged: (_) => setState(() {}), keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعره من'))),
        const SizedBox(width: 8),
        Expanded(child: TextField(controller: _maxPrice, onChanged: (_) => setState(() {}), keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'لحد'))),
      ]),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: _inStock,
        onChanged: (v) => setState(() => _inStock = v ?? false),
        title: const Text('المتاح بس (مش خلصان)'),
      ),
      Text('دلوقتي فيه ${preview.length} منتج: ${preview.take(5).map((p) => p['name']).join('، ')}${preview.length > 5 ? '…' : ''}',
          style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
    ];
  }

  List<Widget> _manualList() {
    final products = {for (final p in _catalog?.products ?? const <Map<String, dynamic>>[]) p['id']: p};
    final rows = _productIds.where(products.containsKey).toList();
    return [
      Row(children: [
        Expanded(child: Text('${rows.length} منتج — اسحب ⠿ عشان ترتّبهم', style: const TextStyle(color: AppColors.inkMuted, fontSize: 12))),
        TextButton.icon(key: const ValueKey('add-products'), onPressed: _addProducts, icon: const Icon(Icons.add_rounded), label: const Text('ضيف منتجات')),
      ]),
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: rows.length,
        onReorderItem: (from, to) => setState(() {
          rows.insert(to, rows.removeAt(from));
          _productIds = rows;
        }),
        itemBuilder: (context, i) {
          final p = products[rows[i]]!;
          final img = StoreService.imagesOf(p).firstOrNull;
          return ListTile(
            key: ValueKey('cp-${rows[i]}'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Row(mainAxisSize: MainAxisSize.min, children: [
              ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_indicator_rounded, color: AppColors.inkMuted)),
              const SizedBox(width: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: img == null ? Container(width: 36, height: 36, color: AppColors.surfaceAlt) : Image.network(img, width: 36, height: 36, cacheWidth: 100, fit: BoxFit.cover),
              ),
            ]),
            title: Text(p['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: productStatusOf(p) == 'active' ? null : Text(productStatusLabels[productStatusOf(p)]!),
            trailing: IconButton(tooltip: 'شيله من القسم', onPressed: () => setState(() => _productIds = [..._productIds]..remove(rows[i])), icon: const Icon(Icons.remove_circle_outline_rounded)),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.collectionId == null;
    Widget body;
    if (_error || _missing) {
      body = LoadErrorView(onRetry: _load);
    } else if (_catalog == null) {
      body = const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()));
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _details(),
        const SizedBox(height: 12),
        _kind(),
        if (_problem != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_problem!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            key: const ValueKey('save-collection'),
            onPressed: _saving ? null : _save,
            child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ القسم'),
          ),
        ),
        if (!isNew) TextButton.icon(onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent), label: const Text('حذف القسم', style: TextStyle(color: Colors.redAccent))),
      ]);
    }
    return AdminPage(
      title: isNew ? 'قسم جديد' : (_name.text.isEmpty ? 'القسم' : _name.text),
      subtitle: isNew ? null : 'تعديل القسم',
      backTo: '/collections',
      scrollable: true,
      maxWidth: 760,
      body: body,
    );
  }
}

class _ProductPicker extends StatefulWidget {
  const _ProductPicker({required this.products});
  final List<Map<String, dynamic>> products;

  @override
  State<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends State<_ProductPicker> {
  final _q = TextEditingController();
  final _picked = <String>[];

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.text.trim();
    final list = widget.products.where((p) => q.isEmpty || (p['name'] as String? ?? '').contains(q)).toList();
    return AlertDialog(
      title: const Text('ضيف منتجات للقسم'),
      content: SizedBox(
        width: 420,
        height: 420,
        child: Column(children: [
          TextField(controller: _q, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'دوّر', isDense: true)),
          const SizedBox(height: 8),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('مفيش منتجات تانية', style: TextStyle(color: AppColors.inkMuted)))
                : ListView(children: [
                    for (final p in list)
                      CheckboxListTile(
                        dense: true,
                        value: _picked.contains(p['id']),
                        onChanged: (on) => setState(() => on == true ? _picked.add(p['id'] as String) : _picked.remove(p['id'])),
                        title: Text(p['name'] as String? ?? ''),
                      ),
                  ]),
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('تراجع')),
        ElevatedButton(key: const ValueKey('picker-add'), onPressed: () => Navigator.pop(context, _picked), child: Text('ضيف (${_picked.length})')),
      ],
    );
  }
}
