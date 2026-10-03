import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// Super-admin queue for things only the platform owner decides
/// (migration 0051 / 0049):
///   * president requests — nobody becomes union president on their own;
///   * join requests of buildings that have no board yet;
///   * assigning (selling) premium single-word address names.
class AdminGovernanceScreen extends StatefulWidget {
  const AdminGovernanceScreen({super.key});

  @override
  State<AdminGovernanceScreen> createState() => _AdminGovernanceScreenState();
}

class _AdminGovernanceScreenState extends State<AdminGovernanceScreen> {
  SupabaseClient get _db => Supabase.instance.client;

  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _presidents = [];
  List<Map<String, dynamic>> _joins = [];

  final _addrQuery = TextEditingController();
  final _premium = TextEditingController();
  List<Map<String, dynamic>>? _addrResults;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _addrQuery.dispose();
    _premium.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final results = await Future.wait([
        _db.rpc('admin_list_president_requests'),
        _db.rpc('admin_list_boardless_join_requests'),
      ]);
      if (!mounted) return;
      setState(() {
        _presidents = List<Map<String, dynamic>>.from(results[0] as List);
        _joins = List<Map<String, dynamic>>.from(results[1] as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    }
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  String _err(Object e) => e is PostgrestException ? e.message : 'حصلت مشكلة، جرّب تاني';

  Future<void> _run(Future<void> Function() action, String done) async {
    try {
      await action();
      _toast(done);
      _load();
    } catch (e) {
      _toast(_err(e));
    }
  }

  Future<void> _searchAddresses() async {
    final q = _addrQuery.text.trim();
    if (q.isEmpty) return;
    try {
      final rows = await _db.rpc('admin_find_e_addresses', params: {'p_query': q});
      setState(() {
        _addrResults = List<Map<String, dynamic>>.from(rows as List);
        _selectedAddressId = _addrResults!.length == 1 ? _addrResults!.first['id'] as String : null;
      });
    } catch (e) {
      _toast(_err(e));
    }
  }

  Future<void> _assignPremium() async {
    final name = _premium.text.trim().toLowerCase();
    if (_selectedAddressId == null || name.isEmpty) {
      _toast('اختار العنوان واكتب الاسم المميز');
      return;
    }
    await _run(
      () => _db.rpc('admin_assign_e_address_handle', params: {'p_address_id': _selectedAddressId, 'p_handle': name}),
      'الاسم «$name» اتسجّل للعنوان',
    );
    _premium.clear();
    _searchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئاسات والأسماء المميزة')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      _title('طلبات رئاسة الاتحاد', _presidents.length),
                      if (_presidents.isEmpty) _empty('مفيش طلبات رئاسة دلوقتي'),
                      for (final r in _presidents)
                        _card(
                          title: '${r['full_name']} — ${r['building_name']}',
                          lines: [
                            [r['district'], r['city']].whereType<String>().join('، '),
                            'موبايل: ${r['phone'] ?? '—'} • أعضاء موثّقين: ${r['members']}',
                          ],
                          onApprove: () => _run(() => _db.rpc('review_president_request', params: {'p_request_id': r['id'], 'p_approve': true}), 'بقى رئيس الاتحاد'),
                          onReject: () => _run(() => _db.rpc('review_president_request', params: {'p_request_id': r['id'], 'p_approve': false}), 'اترفض الطلب'),
                        ),
                      const SizedBox(height: 20),
                      _title('طلبات انضمام لعمارات ملهاش رئيس', _joins.length),
                      if (_joins.isEmpty) _empty('مفيش طلبات انضمام مستنية'),
                      for (final j in _joins)
                        _card(
                          title: '${j['full_name']} — ${j['building_name']}',
                          lines: ['شقة ${j['unit_number'] ?? '—'} • ${j['requested_residency'] == 'tenant' ? 'مستأجر' : 'مالك'} • ${j['phone'] ?? '—'}'],
                          onApprove: () => _run(() => _db.rpc('review_union_member', params: {'p_member_id': j['member_id'], 'p_approve': true}), 'اتقبل'),
                          onReject: () => _run(() => _db.rpc('review_union_member', params: {'p_member_id': j['member_id'], 'p_approve': false}), 'اترفض'),
                        ),
                      const SizedBox(height: 20),
                      _title('بيع اسم مميز لعنوان إلكتروني', null),
                      const Text('الأسماء اللي من كلمة واحدة (زي ahmed أو mona) محجوزة للمنصة. دوّر على العنوان بموبايل صاحبه أو الكود أو الاسم الحالي، وسجّله له.',
                          style: TextStyle(color: AppColors.inkMuted, fontSize: 12, height: 1.6)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            controller: _addrQuery,
                            textDirection: TextDirection.ltr,
                            onSubmitted: (_) => _searchAddresses(),
                            decoration: const InputDecoration(hintText: '010… أو MG-… أو ahmed-maadi', isDense: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(onPressed: _searchAddresses, icon: const Icon(Icons.search_rounded)),
                      ]),
                      if (_addrResults != null) ...[
                        const SizedBox(height: 8),
                        if (_addrResults!.isEmpty) _empty('مالقيناش عناوين'),
                        for (final a in _addrResults!)
                          ListTile(
                            onTap: () => setState(() => _selectedAddressId = a['id'] as String),
                            leading: Icon(
                              _selectedAddressId == a['id'] ? Icons.check_circle_rounded : Icons.circle_outlined,
                              color: _selectedAddressId == a['id'] ? AppColors.crystal : AppColors.inkMuted,
                            ),
                            title: Text('${a['owner_name']} — ${a['label']} (${a['city']})'),
                            subtitle: Text('الكود: ${a['code']}${a['handle'] != null ? ' • الاسم: ${a['handle']}' : ''}', textDirection: TextDirection.ltr),
                          ),
                        if (_addrResults!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextField(
                            controller: _premium,
                            textDirection: TextDirection.ltr,
                            decoration: const InputDecoration(labelText: 'الاسم المميز', prefixText: 'mogtama3y.com/#/a/', hintText: 'ahmed'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(onPressed: _assignPremium, icon: const Icon(Icons.workspace_premium_rounded), label: const Text('سجّل الاسم للعنوان')),
                        ],
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _title(String t, int? count) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(count == null ? t : '$t ($count)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      );

  Widget _empty(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(t, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
      );

  Widget _card({required String title, required List<String> lines, required VoidCallback onApprove, required VoidCallback onReject}) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            for (final l in lines) Text(l, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, height: 1.6)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: onApprove, child: const Text('موافقة'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(onPressed: onReject, child: const Text('رفض'))),
            ]),
          ]),
        ),
      );
}
