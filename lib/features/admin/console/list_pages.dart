import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/admin/admin_console_service.dart';
import '../../../core/geo/arab_countries.dart';
import '../../../core/geo/money.dart';
import '../../../core/geo/phones.dart';
import '../../../core/theme/app_colors.dart';
import 'console_widgets.dart';

/// The console's table pages (0106): users, ad-token payments, stores.
/// Each loads 50 rows a page, searches on the server and refreshes itself
/// every 30 s while open.

typedef _Loader = Future<Map<String, dynamic>> Function(String? query, String? filter, int offset);

class _TablePage extends StatefulWidget {
  const _TablePage({
    required this.searchHint,
    required this.load,
    required this.columns,
    required this.cells,
    this.filters = const {},
    this.summary,
    this.onTapRow,
  });
  final String? searchHint;
  final _Loader load;
  final List<String> columns;
  final List<Widget> Function(Map<String, dynamic> row) cells;
  final Map<String?, String> filters;
  final Widget Function(Map<String, dynamic> data)? summary;
  final void Function(BuildContext context, Map<String, dynamic> row)? onTapRow;

  @override
  State<_TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<_TablePage> {
  static const _page = 50;
  final _search = TextEditingController();
  Timer? _debounce;
  Timer? _refresh;
  Map<String, dynamic>? _data;
  List<Map<String, dynamic>> _rows = [];
  String? _filter;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _refresh = Timer.periodic(const Duration(seconds: 30), (_) => _load(quiet: true));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _refresh?.cancel();
    _search.dispose();
    super.dispose();
  }

  String? get _query => _search.text.trim().isEmpty ? null : _search.text.trim();

  Future<void> _load({bool quiet = false, bool more = false}) async {
    if (!quiet) setState(() => _loading = true);
    try {
      final d = await widget.load(_query, _filter, more ? _rows.length : 0);
      if (!mounted) return;
      final rows = [for (final r in d['rows'] as List? ?? const []) Map<String, dynamic>.from(r as Map)];
      setState(() {
        _data = d;
        // A quiet refresh keeps what was already paged in.
        _rows = more ? [..._rows, ...rows] : (quiet && _rows.length > rows.length ? [...rows, ..._rows.skip(rows.length)] : rows);
        _error = null;
      });
    } catch (e) {
      if (mounted && !quiet) setState(() => _error = isAdminDenied(e) ? 'الصفحة دي للسوبر أدمن بس' : 'تعذر التحميل — اتأكد من النت');
    } finally {
      if (mounted && !quiet) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = (_data?['total'] as num?) ?? 0;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
      Wrap(spacing: 12, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
        if (widget.searchHint != null)
          SizedBox(
            width: 340,
            child: TextField(
              controller: _search,
              onChanged: (_) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 400), _load);
              },
              decoration: InputDecoration(hintText: widget.searchHint, prefixIcon: const Icon(Icons.search_rounded), isDense: true),
            ),
          ),
        for (final f in widget.filters.entries)
          ChoiceChip(
            label: Text(f.value),
            selected: _filter == f.key,
            onSelected: (_) {
              setState(() => _filter = f.key);
              _load();
            },
          ),
        Text('${fmtCount(total)} نتيجة', style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12.5)),
      ]),
      if (_data != null && widget.summary != null) ...[const SizedBox(height: 14), widget.summary!(_data!)],
      const SizedBox(height: 14),
      if (_error != null)
        Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(_error!, style: const TextStyle(color: AppColors.inkSecondary))))
      else if (_loading && _rows.isEmpty)
        const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
      else if (_rows.isEmpty)
        const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('مفيش نتايج', style: TextStyle(color: AppColors.inkMuted))))
      else
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          clipBehavior: Clip.antiAlias,
          child: ConsoleTable(
            columns: widget.columns,
            rows: [for (final r in _rows) widget.cells(r)],
            onTapRow: widget.onTapRow == null ? null : (i) => widget.onTapRow!(context, _rows[i]),
          ),
        ),
      if (_rows.length < total)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Center(
            child: OutlinedButton(onPressed: _loading ? null : () => _load(more: true), child: Text('اعرض ${fmtCount(_page)} كمان')),
          ),
        ),
    ]);
  }
}

String _date(String? iso) {
  final t = DateTime.tryParse(iso ?? '')?.toLocal();
  return t == null ? '—' : DateFormat('d/M/yyyy').format(t);
}

String _country(String? iso) {
  final c = arabCountry(iso);
  return c == null ? (iso ?? '—') : '${c.flag} ${c.nameAr}';
}

Widget _phone(String? p) => Directionality(textDirection: TextDirection.ltr, child: Text(p == null ? '—' : displayPhone(p)));

/// المشتركين: newest first, search by name / phone.
class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TablePage(
      searchHint: 'دوّر بالاسم أو الموبايل',
      load: (q, _, offset) => AdminConsoleService.users(query: q, offset: offset),
      columns: const ['الاسم', 'الموبايل', 'الدولة', 'اتسجّل', 'آخر دخول', 'متاجر', 'توكن', 'النوع'],
      cells: (r) => [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text(r['full_name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
          if (r['phone_verified'] == true) const Padding(padding: EdgeInsetsDirectional.only(start: 4), child: Icon(Icons.verified_rounded, size: 15, color: AppColors.success)),
        ]),
        _phone(r['phone'] as String?),
        Text(_country(r['country'] as String?)),
        Text(_date(r['created_at'] as String?)),
        Text(agoText(r['last_sign_in_at'] as String?)),
        Text(fmtCount(r['shops'] as num?)),
        Text(fmtCount(r['ad_token_balance'] as num?)),
        r['role'] == 'super_admin' ? const ConsolePill('أدمن', color: AppColors.categorySos) : const ConsolePill('مستخدم'),
      ],
      onTapRow: (context, r) {
        final phone = r['phone'] as String?;
        if (phone == null) return;
        Clipboard.setData(ClipboardData(text: phone));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اتنسخ رقم ${r['full_name'] ?? ''}')));
      },
    );
  }
}

/// المدفوعات: ad-token top-ups, online and manual.
class AdminPaymentsPage extends StatelessWidget {
  const AdminPaymentsPage({super.key});

  static const _status = {
    'approved': ('اتدفع', AppColors.success),
    'awaiting_payment': ('مستني الدفع', AppColors.gold),
    'pending': ('مستني مراجعة', AppColors.crystalLight),
    'rejected': ('مرفوض', AppColors.categorySos),
  };

  @override
  Widget build(BuildContext context) {
    return _TablePage(
      searchHint: null,
      filters: const {null: 'الكل', 'approved': 'اتدفع', 'awaiting_payment': 'مستني الدفع أونلاين', 'pending': 'تحويل يدوي مستني مراجعة', 'rejected': 'مرفوض'},
      load: (_, f, offset) => AdminConsoleService.tokenPayments(status: f, offset: offset),
      summary: (d) => Wrap(spacing: 12, runSpacing: 12, children: [
        SizedBox(
          width: 260,
          child: KpiCard(icon: Icons.payments_rounded, value: money((d['approved_sum'] as num?) ?? 0, 'EGP'), label: 'إجمالي اللي اتدفع (كل الوقت)', color: AppColors.success),
        ),
      ]),
      columns: const ['التاريخ', 'المستخدم', 'الموبايل', 'التوكن', 'المبلغ', 'الطريقة', 'الحالة'],
      cells: (r) {
        final st = _status[r['status']] ?? (r['status'] as String? ?? '—', AppColors.inkSecondary);
        return [
          Text(_date(r['created_at'] as String?)),
          Text(r['full_name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
          _phone(r['phone'] as String?),
          Text(fmtCount(r['tokens_requested'] as num?)),
          Text(money((r['amount_egp'] as num?) ?? 0, 'EGP'), style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(r['method'] == 'online' ? 'أونلاين (فواتيرك)' : 'تحويل يدوي'),
          ConsolePill(st.$1, color: st.$2),
        ];
      },
    );
  }
}

/// المتاجر: every store with its owner, products, orders and sales.
class AdminShopsPage extends StatelessWidget {
  const AdminShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TablePage(
      searchHint: 'دوّر باسم المتجر أو الرابط',
      load: (q, _, offset) => AdminConsoleService.shops(query: q, offset: offset),
      columns: const ['المتجر', 'صاحبه', 'الدولة', 'منتجات', 'طلبات', 'مبيعات', 'دفع أونلاين', 'آخر طلب', 'اتعمل'],
      cells: (r) => [
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(r['name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
          if (r['category'] != null) Text(r['category'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(r['owner_name'] as String? ?? (r['source'] == 'google' ? 'من الدليل (مش متملّك)' : '—')),
          if (r['owner_phone'] != null) _phone(r['owner_phone'] as String?),
        ]),
        Text(_country(r['country'] as String?)),
        Text(fmtCount(r['products'] as num?)),
        Text(fmtCount(r['orders'] as num?)),
        Text(money((r['sales'] as num?) ?? 0, r['currency'] as String?)),
        r['gateway'] == null ? const Text('—') : ConsolePill(r['gateway'] == 'fawaterak' ? 'فواتيرك' : r['gateway'] as String, color: AppColors.success),
        Text(agoText(r['last_order_at'] as String?)),
        Text(_date(r['created_at'] as String?)),
      ],
      onTapRow: (context, r) {
        final slug = r['slug'] as String?;
        if (slug == null) return;
        launchUrl(Uri.parse('https://mogtama3y.com/#/s/$slug'), mode: LaunchMode.externalApplication);
      },
    );
  }
}
