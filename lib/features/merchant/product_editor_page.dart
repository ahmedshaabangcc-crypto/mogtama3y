import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/demo/demo_mode.dart';
import '../../core/demo/demo_store.dart';
import '../../core/geo/money.dart';
import '../../core/shops/store_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/numbers.dart';
import '../shared/load_error_view.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';

/// `/products/new` and `/products/:id`: the product editor as a page
/// (photos, AI copy, price, options; status نشط / مسودة / مؤرشف).
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
    if (widget.productId != null && (_product == null || _product!['id'] != widget.productId)) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _missing = false;
    });
    try {
      final p = await StoreService.fetchProduct(widget.productId!);
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
  late final _category = TextEditingController(text: widget.product?['category'] as String? ?? '');
  late final _stock = TextEditingController(text: (widget.product?['stock'] as int?)?.toString() ?? '');
  late final _sizes = TextEditingController(text: _optionValues('المقاس'));
  late final _colors = TextEditingController(text: _optionValues('اللون'));

  String _optionValues(String name) {
    if (widget.product == null) return '';
    return StoreService.optionsOf(widget.product!).where((o) => o.name == name).map((o) => o.values.join('، ')).firstOrNull ?? '';
  }

  List<String> _split(String s) => s.split(RegExp(r'[,،\n]')).map((v) => v.trim()).where((v) => v.isNotEmpty).take(20).toList();
  late String _status = widget.product == null ? 'active' : productStatusOf(widget.product!);
  bool _uploading = false;
  bool _thinking = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _oldPrice.dispose();
    _desc.dispose();
    _highlights.dispose();
    _category.dispose();
    _stock.dispose();
    _sizes.dispose();
    _colors.dispose();
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

  Future<void> _save() async {
    final price = looseDouble(_price.text.trim());
    final oldPrice = _oldPrice.text.trim().isEmpty ? null : looseDouble(_oldPrice.text.trim());
    if (_name.text.trim().isEmpty || price == null || price < 0) {
      setState(() => _error = 'اكتب اسم المنتج وسعر صحيح');
      return;
    }
    if (oldPrice != null && oldPrice <= price) {
      setState(() => _error = 'السعر قبل الخصم لازم يكون أكبر من السعر الحالي');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await StoreService.saveProduct(
        productId: widget.product?['id'] as String?,
        shopId: widget.shopId,
        name: _name.text.trim(),
        price: price,
        oldPrice: oldPrice,
        description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        images: _images,
        highlights: _highlights.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).take(6).toList(),
        category: _category.text.trim().isEmpty ? null : _category.text.trim(),
        stock: looseInt(_stock.text.trim()),
        options: [
          if (_split(_sizes.text).isNotEmpty) {'name': 'المقاس', 'values': _split(_sizes.text)},
          if (_split(_colors.text).isNotEmpty) {'name': 'اللون', 'values': _split(_colors.text)},
        ],
        status: _status,
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

  Widget _organizeBox() => AdminCard(
        title: 'التنظيم والمخزون',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(controller: _category, decoration: const InputDecoration(labelText: 'القسم', hintText: 'مثلاً: تيشيرتات')),
          const SizedBox(height: 10),
          TextField(
            controller: _stock,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'الكمية المتاحة', hintText: 'فاضية = مفتوحة'),
          ),
        ]),
      );

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
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'اسم المنتج *')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextField(
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
        TextField(controller: _sizes, decoration: const InputDecoration(labelText: 'المقاسات (اختياري)', hintText: 'S، M، L، XL')),
        const SizedBox(height: 10),
        TextField(controller: _colors, decoration: const InputDecoration(labelText: 'الألوان (اختياري)', hintText: 'أسود، أبيض، كحلي')),
        const SizedBox(height: 10),
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
      if (c.maxWidth >= 860) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: main),
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
        main,
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
