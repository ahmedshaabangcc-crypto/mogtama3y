import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/demo/demo_mode.dart';
import '../../core/demo/demo_store.dart';
import '../../core/geo/money.dart';
import '../../core/shops/catalog.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';
import 'variants_editor.dart';

/// `/products/new` and `/products/:id`: the product editor as a page
/// (photos, AI copy, price, options → variants, SKU / barcode, collections,
/// tags, video, SEO; status نشط / مسودة / مؤرشف).
class ProductEditorPage extends StatefulWidget {
  const ProductEditorPage({super.key, this.productId, this.initial});

  /// null: a new product.
  final String? productId;

  /// The row from the products list (skips the fetch).
  final Map<String, dynamic>? initial;

  @override
  State<ProductEditorPage> createState() => _ProductEditorPageState();
}

class _ProductEditorPageState extends State<ProductEditorPage> {
  Map<String, dynamic>? _product;
  bool _loading = false;
  bool _missing = false;

  @override
  void initState() {
    super.initState();
    _product = widget.initial;
    // The list row may lack collection ids / predate 0098: fetch the full product.
    if (widget.productId != null &&
        (_product == null || _product!['id'] != widget.productId || _product!['variants'] == null || _product!['collection_ids'] == null)) {
      _product = null;
      _loading = true;
      _load();
    }
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _missing = false;
      });
    }
    try {
      final p = await StoreService.merchantProduct(widget.productId!);
      if (!mounted) return;
      setState(() {
        _product = p;
        _missing = p == null;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _missing = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = MerchantScope.of(context).shop!;
    final isNew = widget.productId == null;
    Widget body;
    if (_loading) {
      body = const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()));
    } else if (_missing || (!isNew && _product?['shop_id'] != shop['id'])) {
      body = LoadErrorView(onRetry: _load);
    } else {
      body = ProductEditorForm(
        key: ValueKey(widget.productId ?? 'new'),
        shopId: shop['id'] as String,
        product: isNew ? null : _product,
        shopCategory: shop['category'] as String?,
        onSaved: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتحفظ المنتج')));
          context.go('/products');
        },
      );
    }
    return AdminPage(
      title: isNew ? 'منتج جديد' : (_product?['name'] as String? ?? 'تعديل المنتج'),
      subtitle: isNew ? null : 'تعديل المنتج',
      backTo: '/products',
      scrollable: true,
      maxWidth: 1100,
      body: body,
    );
  }
}

class ProductEditorForm extends StatefulWidget {
  const ProductEditorForm({super.key, required this.shopId, this.product, this.shopCategory, required this.onSaved});
  final VoidCallback onSaved;
  final String shopId;
  final Map<String, dynamic>? product;
  final String? shopCategory;

  @override
  State<ProductEditorForm> createState() => _ProductEditorFormState();
}

class _ProductEditorFormState extends State<ProductEditorForm> {
  static const _maxImages = 6;

  late final _name = TextEditingController(text: widget.product?['name'] as String? ?? '');
  late final _price = TextEditingController(text: (widget.product?['price'] as num?)?.toString() ?? '');
  late final _oldPrice = TextEditingController(text: (widget.product?['old_price'] as num?)?.toString() ?? '');
  late final _desc = TextEditingController(text: widget.product?['description'] as String? ?? '');
  late final _highlights = TextEditingController(
      text: List<String>.from(widget.product?['highlights'] as List? ?? const []).join('\n'));
  late final List<String> _images = widget.product == null ? [] : StoreService.imagesOf(widget.product!);
  late final _stock = TextEditingController(text: (widget.product?['stock'] as num?)?.toString() ?? '');
  late final _sku = TextEditingController(text: widget.product?['sku'] as String? ?? '');
  late final _barcode = TextEditingController(text: widget.product?['barcode'] as String? ?? '');
  late final _video = TextEditingController(text: widget.product?['video_url'] as String? ?? '');
  late final _slug = TextEditingController(text: widget.product?['slug'] as String? ?? '');
  late final _seoTitle = TextEditingController(text: widget.product?['seo_title'] as String? ?? '');
  late final _seoDesc = TextEditingController(text: widget.product?['seo_description'] as String? ?? '');
  late final _tagInput = TextEditingController();
  late final List<String> _tags = List<String>.from(widget.product?['tags'] as List? ?? const []);
  late final VariantsModel _variants = VariantsModel(
    options: widget.product == null ? const [] : productOptions(widget.product!),
    variants: widget.product == null ? const [] : variantsOf(widget.product!),
  );

  /// The shop's manual collections (0098) and the ones this product is in.
  List<Map<String, dynamic>> _collections = const [];
  late final Set<String> _inCollections = {for (final id in (widget.product?['collection_ids'] as List? ?? const [])) '$id'};
  late String _status = widget.product == null ? 'active' : productStatusOf(widget.product!);
  bool _uploading = false;
  bool _thinking = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    void defaults() {
      _variants
        ..defaultPrice = _price.text.trim()
        ..defaultCompareAt = _oldPrice.text.trim()
        ..defaultStock = _stock.text.trim();
    }
    defaults();
    _price.addListener(defaults);
    _oldPrice.addListener(defaults);
    _stock.addListener(defaults);
    _hadOptions = _variants.hasOptions;
    _variants.addListener(_onVariants);
    _loadCollections();
  }

  bool _hadOptions = false;
  void _onVariants() {
    // Options appear / disappear → the product's own price fields hide / show.
    if (_variants.hasOptions != _hadOptions) setState(() => _hadOptions = _variants.hasOptions);
  }

  Future<void> _loadCollections() async {
    try {
      final list = await StoreService.fetchCollections(widget.shopId);
      if (mounted) setState(() => _collections = list.where((c) => c['rules'] == null).toList());
    } catch (_) {
      // Collections are optional here.
    }
  }

  Future<void> _newCollection() async {
    final name = await askAdminText(context, title: 'قسم جديد', hint: 'مثلاً: تيشيرتات', okLabel: 'ضيف');
    if (name == null || name.isEmpty) return;
    try {
      final id = await StoreService.saveCollection(widget.shopId, {'name': name});
      await _loadCollections();
      if (mounted) setState(() => _inCollections.add(id));
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر إضافة القسم'));
    }
  }

  @override
  void dispose() {
    _variants.removeListener(_onVariants);
    _variants.dispose();
    _name.dispose();
    _price.dispose();
    _oldPrice.dispose();
    _desc.dispose();
    _highlights.dispose();
    _stock.dispose();
    _sku.dispose();
    _barcode.dispose();
    _video.dispose();
    _slug.dispose();
    _seoTitle.dispose();
    _seoDesc.dispose();
    _tagInput.dispose();
    super.dispose();
  }

  Future<void> _addImage(ImageSource source) async {
    final room = _maxImages - _images.length;
    if (room <= 0) return;
    // Camera: one shot. Gallery: pick several at once.
    final files = source == ImageSource.camera
        ? [?await UploadService.pickImage(source: source)]
        : await UploadService.pickImages(limit: room);
    if (files.isEmpty) return;
    setState(() {
      _uploading = true;
      _error = null;
    });
    final results = await Future.wait(files.take(room).map((f) async {
      try {
        return await UploadService.uploadPublicPhoto(purpose: 'products', file: f);
      } catch (_) {
        return null;
      }
    }));
    if (!mounted) return;
    final ok = results.whereType<String>().toList();
    setState(() {
      _images.addAll(ok);
      _uploading = false;
      if (ok.length < results.length) _error = 'فيه ${results.length - ok.length} صورة مارفعتش، جرّب تاني';
    });
  }

  Future<void> _suggest() async {
    setState(() {
      _thinking = true;
      _error = null;
    });
    try {
      final s = await StoreService.suggestProductCopy(
        imageUrls: _images,
        name: _name.text.trim(),
        category: widget.shopCategory,
        notes: _desc.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        if (s.name.isNotEmpty && _name.text.trim().isEmpty) _name.text = s.name;
        if (s.description.isNotEmpty) _desc.text = s.description;
        if (s.highlights.isNotEmpty) _highlights.text = s.highlights.join('\n');
      });
    } on FunctionException catch (e) {
      final details = e.details;
      if (mounted) setState(() => _error = details is Map && details['error'] is String ? details['error'] as String : 'الذكاء الاصطناعي مش متاح دلوقتي');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _thinking = false);
    }
  }

  /// The first problem with the form (Arabic), or null.
  String? _problem() {
    if (_name.text.trim().isEmpty) return 'اكتب اسم المنتج';
    final v = _video.text.trim();
    if (v.isNotEmpty && youtubeId(v) == null) return 'لينك الفيديو لازم يكون من يوتيوب';
    if (_variants.options.isNotEmpty) return _variants.validate(currency: StoreService.merchantCurrency);
    final price = looseDouble(_price.text.trim());
    final oldPrice = _oldPrice.text.trim().isEmpty ? null : looseDouble(_oldPrice.text.trim());
    if (price == null || price < 0) return 'اكتب اسم المنتج وسعر صحيح';
    if (!priceFitsCurrency(price, StoreService.merchantCurrency)) return 'السعر فيه أرقام بعد العلامة أكتر من اللازم';
    if (oldPrice != null && oldPrice <= price) return 'السعر قبل الخصم لازم يكون أكبر من السعر الحالي';
    if (_stock.text.trim().isNotEmpty && looseInt(_stock.text.trim()) == null) return 'الكمية لازم تكون رقم';
    return null;
  }

  Future<void> _save() async {
    final problem = _problem();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    String? blank(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
    _variants.keepImages(_images);
    final hasOptions = _variants.hasOptions;
    final chosen = [for (final c in _collections) if (_inCollections.contains(c['id'])) c];
    try {
      await StoreService.saveCatalogProduct(
        shopId: widget.shopId,
        product: {
          'id': widget.product?['id'],
          'name': _name.text.trim(),
          'description': blank(_desc),
          'images': _images,
          'highlights': _highlights.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).take(6).toList(),
          // Old builds / store-lite / dalil still read the free-text category.
          'category': chosen.isNotEmpty ? chosen.first['name'] : (_collections.isEmpty ? (widget.product?['category']) : null),
          'options': [for (final o in _variants.cleanOptions) {'name': o.name, 'values': o.values}],
          'status': _status,
          'price': hasOptions ? null : looseDouble(_price.text.trim()),
          'old_price': hasOptions || _oldPrice.text.trim().isEmpty ? null : looseDouble(_oldPrice.text.trim()),
          'stock': hasOptions || _stock.text.trim().isEmpty ? null : looseInt(_stock.text.trim()),
          'sku': hasOptions ? null : blank(_sku),
          'barcode': hasOptions ? null : blank(_barcode),
          'tags': _tags,
          'slug': blank(_slug),
          'seo_title': blank(_seoTitle),
          'seo_description': blank(_seoDesc),
          'video_url': blank(_video),
        },
        variants: hasOptions ? _variants.toJson() : const [],
        collectionIds: _collections.isEmpty && _inCollections.isEmpty ? null : _inCollections.toList(),
      );
      if (mounted) widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = adminErrorText(e, 'تعذر حفظ المنتج'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _photoStrip() {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i = 0; i < _images.length; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(_images[i], cacheWidth: 300, width: 92, height: 92, fit: BoxFit.cover),
                ),
                if (i == 0)
                  PositionedDirectional(
                    bottom: 4,
                    start: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                      child: const Text('الغلاف', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.night)),
                    ),
                  ),
                PositionedDirectional(
                  top: 2,
                  end: 2,
                  child: InkWell(
                    onTap: () => setState(() => _images.removeAt(i)),
                    child: const CircleAvatar(radius: 11, backgroundColor: Colors.black54, child: Icon(Icons.close_rounded, size: 14, color: Colors.white)),
                  ),
                ),
                if (i > 0)
                  PositionedDirectional(
                    bottom: 2,
                    end: 2,
                    child: InkWell(
                      onTap: () => setState(() => _images.insert(0, _images.removeAt(i))),
                      child: const CircleAvatar(radius: 11, backgroundColor: Colors.black54, child: Icon(Icons.star_rounded, size: 14, color: AppColors.gold)),
                    ),
                  ),
              ]),
            ),
          if (_images.length < _maxImages)
            Container(
              width: 92,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: _uploading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'صوّر بالكاميرا',
                        onPressed: () => _addImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_rounded, color: AppColors.crystal),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'من المعرض (كذا صورة مرة واحدة)',
                        onPressed: () => _addImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_rounded, color: AppColors.crystal),
                      ),
                    ]),
            ),
          // Demo build only: the recording browser has no photos to pick.
          if (kDemo && _images.length < _maxImages)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Material(
                color: AppColors.gold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _uploading ? null : () => setState(() => _images.add(demoSamplePhoto(name: _name.text, taken: _images))),
                  child: const SizedBox(
                    width: 92,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.add_photo_alternate_rounded, color: AppColors.crystal),
                      SizedBox(height: 4),
                      Text('صورة تجريبية', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _aiBox() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.gold),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('خلّي الذكاء الاصطناعي يكتب الاسم والوصف والمميزات من صور المنتج',
                style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.5)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, padding: const EdgeInsets.symmetric(horizontal: 14)),
            onPressed: _thinking || _uploading ? null : _suggest,
            child: _thinking
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.night))
                : const Text('✨ اكتبلي'),
          ),
        ]),
      );

  Widget _statusBox() => AdminCard(
        title: 'حالة المنتج',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'active', label: Text('نشط'), icon: Icon(Icons.visibility_rounded, size: 16)),
              ButtonSegment(value: 'draft', label: Text('مسودة'), icon: Icon(Icons.edit_note_rounded, size: 16)),
              ButtonSegment(value: 'archived', label: Text('مؤرشف'), icon: Icon(Icons.archive_outlined, size: 16)),
            ],
            selected: {_status},
            onSelectionChanged: (v) => setState(() => _status = v.first),
          ),
          const SizedBox(height: 8),
          Text(
            switch (_status) {
              'active' => 'ظاهر للزباين في المتجر وتقدر تتطلب.',
              'draft' => 'مخفي عن الزباين لحد ما تخلّصه.',
              _ => 'مخفي ومش بيظهر في قايمة منتجاتك العادية — الطلبات القديمة بتفضل زي ما هي.',
            },
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.5),
          ),
        ]),
      );

  void _addTags(String text) {
    setState(() {
      for (final raw in text.split(RegExp(r'[,،\n]'))) {
        final t = raw.trim();
        if (t.isEmpty || _tags.contains(t) || _tags.length >= 20) continue;
        _tags.add(t.length > 40 ? t.substring(0, 40) : t);
      }
      _tagInput.clear();
    });
  }

  Widget _organizeBox() => AdminCard(
        title: 'التنظيم',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('الأقسام', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final c in _collections)
              FilterChip(
                label: Text(c['name'] as String? ?? ''),
                labelStyle: chipLabelStyle(_inCollections.contains(c['id'])),
                checkmarkColor: Colors.white,
                selected: _inCollections.contains(c['id']),
                onSelected: (on) => setState(() => on ? _inCollections.add(c['id'] as String) : _inCollections.remove(c['id'])),
              ),
            ActionChip(avatar: const Icon(Icons.add_rounded, size: 16), label: const Text('قسم جديد'), onPressed: _newCollection),
          ]),
          const SizedBox(height: 12),
          const Text('الوسوم (Tags)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final t in _tags) InputChip(label: Text(t), onDeleted: () => setState(() => _tags.remove(t))),
          ]),
          TextField(
            key: const ValueKey('tag-input'),
            controller: _tagInput,
            decoration: const InputDecoration(hintText: 'ضيف وسم ودوس Enter (قطن، صيفي…)', isDense: true),
            onSubmitted: _addTags,
          ),
        ]),
      );

  /// Stock and codes of a product without options.
  Widget _inventoryBox() => AdminCard(
        title: 'المخزون والكود',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(
            key: const ValueKey('product-stock'),
            controller: _stock,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'الكمية المتاحة', hintText: 'فاضية = مفتوحة'),
          ),
          const SizedBox(height: 10),
          TextField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU (كود المنتج)', hintText: 'اختياري')),
          const SizedBox(height: 10),
          TextField(controller: _barcode, decoration: const InputDecoration(labelText: 'الباركود', hintText: 'EAN / UPC — اختياري')),
        ]),
      );

  Widget _variantsBox() => AdminCard(
        title: 'الأنواع (مقاسات، ألوان…)',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (!_variants.hasOptions)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('لو المنتج ليه مقاسات أو ألوان، ضيفها هنا — وكل نوع يبقى ليه سعره وكميته وصورته.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5, height: 1.5)),
            ),
          VariantsEditor(model: _variants, images: _images, currencyLabel: currencyLabel(StoreService.merchantCurrency)),
        ]),
      );

  Widget _seoBox() {
    final slug = _slug.text.trim().isEmpty ? catalogSlugify(_name.text) : catalogSlugify(_slug.text);
    return AdminCard(
      title: 'الفيديو ومحركات البحث',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextField(
          controller: _video,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(labelText: 'فيديو يوتيوب (اختياري)', hintText: 'https://youtu.be/…', prefixIcon: Icon(Icons.smart_display_outlined)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _slug,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: 'رابط المنتج (handle)', hintText: slug, helperText: 'بيتعمل لوحده من الاسم لو سبته فاضي'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _seoTitle,
          maxLength: 70,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'عنوان جوجل (SEO)', hintText: 'فاضي = اسم المنتج'),
        ),
        TextField(
          controller: _seoDesc,
          maxLength: 320,
          maxLines: 3,
          minLines: 2,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'وصف جوجل (SEO)', hintText: 'فاضي = أول الوصف', alignLabelWithHint: true),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_seoTitle.text.trim().isEmpty ? (_name.text.trim().isEmpty ? 'اسم المنتج' : _name.text.trim()) : _seoTitle.text.trim(),
                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF1A0DAB), fontSize: 15)),
            Text('dalil.mogtama3y.com › … › $slug', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.success, fontSize: 11.5)),
            Text(_seoDesc.text.trim().isEmpty ? (_desc.text.trim().isEmpty ? '—' : _desc.text.trim()) : _seoDesc.text.trim(),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }

  Widget _saveButton() => SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: _saving || _uploading || _thinking ? null : _save,
          child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ المنتج'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final main = AdminCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('صور المنتج (لحد $_maxImages) — أول صورة هي الغلاف، ودوس ⭐ عشان تخلي صورة الغلاف',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5)),
        const SizedBox(height: 10),
        _photoStrip(),
        const SizedBox(height: 12),
        _aiBox(),
        const SizedBox(height: 12),
        TextField(key: const ValueKey('product-name'), controller: _name, decoration: const InputDecoration(labelText: 'اسم المنتج *')),
        const SizedBox(height: 10),
        if (_variants.hasOptions)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('السعر والكمية بيتحددوا لكل نوع تحت في «الأنواع».', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
          )
        else
        Row(children: [
          Expanded(
            child: TextField(
              key: const ValueKey('product-price'),
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'السعر (${currencyLabel(StoreService.merchantCurrency)}) *'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _oldPrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'السعر قبل الخصم', hintText: 'اختياري'),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        TextField(
          controller: _desc,
          maxLines: 5,
          minLines: 3,
          maxLength: 2000,
          decoration: const InputDecoration(labelText: 'وصف المنتج', hintText: 'اكتب ملاحظاتك هنا، أو دوس «اكتبلي»', alignLabelWithHint: true),
        ),
        TextField(
          controller: _highlights,
          maxLines: 4,
          minLines: 2,
          decoration: const InputDecoration(labelText: 'مميزات المنتج', hintText: 'كل ميزة في سطر، مثلاً: قطن 100%', alignLabelWithHint: true),
        ),
      ]),
    );
    final error = _error == null ? const SizedBox.shrink() : Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
    );
    return LayoutBuilder(builder: (context, c) {
      final left = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        main,
        const SizedBox(height: 12),
        _variantsBox(),
        if (!_variants.hasOptions) ...[const SizedBox(height: 12), _inventoryBox()],
        const SizedBox(height: 12),
        _seoBox(),
      ]);
      if (c.maxWidth >= 860) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              _statusBox(),
              const SizedBox(height: 12),
              _organizeBox(),
              error,
              const SizedBox(height: 12),
              _saveButton(),
            ]),
          ),
        ]);
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        left,
        const SizedBox(height: 12),
        _statusBox(),
        const SizedBox(height: 12),
        _organizeBox(),
        error,
        const SizedBox(height: 12),
        _saveButton(),
      ]);
    });
  }
}
