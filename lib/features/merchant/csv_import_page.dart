import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/shops/catalog.dart';
import '../../core/shops/print_card.dart';
import '../../core/shops/store_service.dart';
import '../../core/theme/app_colors.dart';
import 'admin/admin_common.dart';
import 'admin/merchant_session.dart';

/// `/products/import` (0098): products from a CSV (Shopify-like columns —
/// a Shopify export works as is). Pick or paste the file → «معاينة» runs
/// the import as a dry run on the server, batch by batch (a product is
/// never split), and shows what would be created / updated and every
/// row's error → «استورد» does it for real. Re-importing the same file
/// only updates (matched by handle, then SKU).
class CsvImportPage extends StatefulWidget {
  const CsvImportPage({super.key});

  @override
  State<CsvImportPage> createState() => _CsvImportPageState();
}

class _CsvImportPageState extends State<CsvImportPage> {
  final _paste = TextEditingController();
  List<Map<String, String>> _rows = const [];
  List<String> _ignored = const [];
  List<String> _missing = const [];
  String? _fileName;
  bool _running = false;
  double _progress = 0;
  Map<String, dynamic>? _report;
  bool _done = false;
  String? _error;

  String get _shopId => MerchantScope.of(context).shop!['id'] as String;

  @override
  void dispose() {
    _paste.dispose();
    super.dispose();
  }

  void _parse(String text, {String? name}) {
    final r = csvToImportRows(text);
    setState(() {
      _rows = r.rows;
      _ignored = r.ignored;
      _missing = r.missing;
      _fileName = name;
      _report = null;
      _done = false;
      _error = r.rows.isEmpty ? 'الملف فاضي أو مش CSV' : null;
    });
  }

  Future<void> _pick() async {
    final text = await pickTextFile();
    if (!mounted) return;
    if (text == null) {
      setState(() => _error = 'مقدرتش أفتح الملف — جرّب تاني، أو الصق محتواه تحت');
      return;
    }
    if (text.isEmpty) return;
    _parse(text, name: 'الملف');
  }

  void _template() {
    final ok = downloadText(catalogCsvTemplate(currency: StoreService.merchantCurrency), 'matgary-products-template.csv', mime: 'text/csv;charset=utf-8');
    if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('النموذج بيتنزّل من المتصفح')));
  }

  int get _productCount {
    final handles = <String>{};
    String? last;
    for (final r in _rows) {
      final h = r['handle'] != null ? catalogSlugify(r['handle']!) : (r['title'] != null ? catalogSlugify(r['title']!) : (r['sku'] ?? last));
      if (h != null) handles.add(h);
      last = h;
    }
    return handles.length;
  }

  Future<void> _run({required bool dryRun}) async {
    final batches = importBatches(_rows);
    setState(() {
      _running = true;
      _progress = 0;
      _error = null;
    });
    var created = 0, updated = 0, failed = 0;
    final errors = <Map<String, dynamic>>[];
    final items = <Map<String, dynamic>>[];
    try {
      for (final (i, b) in batches.indexed) {
        final r = await StoreService.importProducts(_shopId, b, dryRun: dryRun);
        created += (r['created'] as num?)?.toInt() ?? 0;
        updated += (r['updated'] as num?)?.toInt() ?? 0;
        failed += (r['failed'] as num?)?.toInt() ?? 0;
        errors.addAll([for (final e in r['errors'] as List? ?? const []) Map<String, dynamic>.from(e as Map)]);
        items.addAll([for (final e in r['items'] as List? ?? const []) Map<String, dynamic>.from(e as Map)]);
        if (mounted) setState(() => _progress = (i + 1) / batches.length);
      }
      if (!mounted) return;
      setState(() {
        _report = {'created': created, 'updated': updated, 'failed': failed, 'errors': errors, 'items': items, 'dry_run': dryRun};
        _done = !dryRun;
      });
    } catch (e) {
      if (mounted) setState(() => _error = adminErrorText(e, 'تعذر الاستيراد، جرّب تاني'));
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Widget _source() => AdminCard(
        title: '1. الملف',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'ملف CSV فيه منتجاتك (كل نوع في سطر، والأعمدة زي Shopify: Handle، Title، Option1 Name/Value، Variant SKU، Variant Price، Variant Inventory Qty، Image Src، Collection، Tags…). '
            'تقدر تصدّر منتجاتك الأول من «المنتجات» وتعدّل عليها، أو تنزّل النموذج. الأسعار بعملة متجرك (${StoreService.merchantCurrency}).',
            style: TextStyle(color: AppColors.inkSecondary, fontSize: 12.5, height: 1.6),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton.icon(key: const ValueKey('pick-csv'), onPressed: _running ? null : _pick, icon: const Icon(Icons.upload_file_rounded), label: const Text('اختار ملف CSV')),
            OutlinedButton.icon(onPressed: _template, icon: const Icon(Icons.download_rounded), label: const Text('نزّل النموذج')),
          ]),
          const SizedBox(height: 10),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('أو الصق محتوى الملف', style: TextStyle(fontSize: 13)),
            children: [
              TextField(
                key: const ValueKey('paste-csv'),
                controller: _paste,
                maxLines: 6,
                minLines: 3,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                decoration: const InputDecoration(hintText: 'Handle,Title,Variant Price…'),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(key: const ValueKey('parse-csv'), onPressed: () => _parse(_paste.text, name: 'النص'), child: const Text('اقرا')),
              ),
            ],
          ),
          if (_rows.isNotEmpty) ...[
            const Divider(),
            Text('${_fileName ?? 'الملف'}: ${_rows.length} سطر — حوالي $_productCount منتج', style: const TextStyle(fontWeight: FontWeight.w800)),
            if (_ignored.isNotEmpty)
              Text('أعمدة مش هتتقري: ${_ignored.join('، ')}', style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
            if (_missing.isNotEmpty)
              Text('ناقص عمود: ${_missing.join('، ')}', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
        ]),
      );

  Widget _actions() => AdminCard(
        title: '2. راجع واستورد',
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton.icon(
              key: const ValueKey('preview-import'),
              onPressed: _running || _rows.isEmpty || _missing.isNotEmpty ? null : () => _run(dryRun: true),
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('معاينة'),
            ),
            ElevatedButton.icon(
              key: const ValueKey('run-import'),
              onPressed: _running || _report == null || _report!['dry_run'] != true ? null : () => _run(dryRun: false),
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('استورد'),
            ),
          ]),
          if (_running) ...[const SizedBox(height: 10), LinearProgressIndicator(value: _progress)],
          if (_report != null) ...[const SizedBox(height: 12), _reportView(_report!)],
        ]),
      );

  Widget _reportView(Map<String, dynamic> r) {
    final dry = r['dry_run'] == true;
    final errors = List<Map<String, dynamic>>.from(r['errors'] as List);
    Widget stat(String label, Object n, Color color) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text('$n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              Text(label, style: const TextStyle(fontSize: 12)),
            ]),
          ),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(dry ? 'المعاينة (لسه متحفظش حاجة):' : 'خلص الاستيراد ✓', key: const ValueKey('import-report'), style: const TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Row(children: [
        stat(dry ? 'هيتضاف' : 'اتضاف', r['created'] as Object, AppColors.success),
        const SizedBox(width: 8),
        stat(dry ? 'هيتعدّل' : 'اتعدّل', r['updated'] as Object, AppColors.crystal),
        const SizedBox(width: 8),
        stat('فيه مشكلة', r['failed'] as Object, Colors.redAccent),
      ]),
      if (errors.isNotEmpty) ...[
        const SizedBox(height: 10),
        const Text('المشاكل (صلّحها في الملف وجرّب تاني — باقي المنتجات بتتستورد عادي):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        for (final e in errors.take(100))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
            title: Text(e['message'] as String? ?? ''),
            subtitle: (e['handle'] as String?)?.isNotEmpty ?? false ? Text('handle: ${e['handle']}') : null,
          ),
        if (errors.length > 100) Text('و${errors.length - 100} مشكلة تانية', style: const TextStyle(color: AppColors.inkMuted)),
      ],
      if (!dry) ...[
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => context.go('/products'), child: const Text('شوف المنتجات')),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'استيراد منتجات',
      subtitle: 'من ملف CSV',
      backTo: '/products',
      scrollable: true,
      maxWidth: 820,
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _source(),
        const SizedBox(height: 12),
        _actions(),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
        if (_done) const SizedBox(height: 12),
      ]),
    );
  }
}
