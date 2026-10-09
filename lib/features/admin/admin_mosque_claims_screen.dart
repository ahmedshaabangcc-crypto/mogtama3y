import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:url_launcher/url_launcher.dart';

import '../../core/maps/maps_launcher.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// Super-admin review of «مسجدي» claims (migration 0080): who claims which
/// mosque, as what, their phone and the optional proof (opened through a
/// short-lived signed URL). Approving verifies the mosque and makes the
/// claimant its owner; either way the claimant is notified.
class AdminMosqueClaimsScreen extends StatefulWidget {
  const AdminMosqueClaimsScreen({super.key});

  @override
  State<AdminMosqueClaimsScreen> createState() => _AdminMosqueClaimsScreenState();
}

class _AdminMosqueClaimsScreenState extends State<AdminMosqueClaimsScreen> {
  static const _filters = <String?, String>{'pending': 'قيد المراجعة', 'approved': 'مقبولة', 'rejected': 'مرفوضة', null: 'الكل'};

  String? _status = 'pending';
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _claims = [];
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final rows = await MasjidService.adminClaims(status: _status);
      if (!mounted) return;
      setState(() {
        _claims = rows;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _openDoc(String path) async {
    try {
      final url = await UploadService.createPrivateSignedUrl(path, expiresInSeconds: 600);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح المستند')));
    }
  }

  Future<void> _review(Map<String, dynamic> c, bool approve) async {
    final noteCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approve ? 'توثيق ${c['full_name']} لـ «${c['mosque_name']}»' : 'رفض الطلب'),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: InputDecoration(labelText: approve ? 'ملاحظة (اختياري)' : 'سبب الرفض (بيوصل لصاحب الطلب)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(approve ? 'وثّق' : 'ارفض')),
        ],
      ),
    );
    final note = noteCtrl.text.trim();
    noteCtrl.dispose();
    if (confirmed != true) return;
    final id = c['id'] as String;
    setState(() => _busy.add(id));
    try {
      await MasjidService.adminReview(id, approve: approve, note: note.isEmpty ? null : note);
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر الحفظ')));
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('طلبات إدارة المساجد')),
      body: Column(children: [
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(side, 10, side, 6),
            children: [
              for (final e in _filters.entries) ...[
                ChoiceChip(
                  label: Text(e.value),
                  selected: _status == e.key,
                  onSelected: (_) {
                    setState(() => _status = e.key);
                    _load();
                  },
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error
                  ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل الطلبات')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: _claims.isEmpty
                          ? ListView(children: const [
                              Padding(padding: EdgeInsets.all(40), child: Center(child: Text('مفيش طلبات هنا', style: TextStyle(color: AppColors.inkMuted)))),
                            ])
                          : ListView.separated(
                              padding: EdgeInsets.fromLTRB(side, 8, side, 24),
                              itemCount: _claims.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (context, i) => _card(_claims[i]),
                            ),
                    ),
        ),
      ]),
    );
  }

  Widget _card(Map<String, dynamic> c) {
    final status = c['status'] as String? ?? 'pending';
    final created = DateTime.tryParse(c['created_at'] as String? ?? '')?.toLocal();
    final busy = _busy.contains(c['id']);
    final doc = c['doc_path'] as String?;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(c['mosque_name'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
          Text(switch (status) { 'approved' => 'مقبول ✓', 'rejected' => 'مرفوض', _ => 'قيد المراجعة' },
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: status == 'approved' ? AppColors.success : AppColors.inkSecondary)),
        ]),
        if (c['mosque_address'] != null) Text(c['mosque_address'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
        const SizedBox(height: 6),
        Text('${c['full_name']} — ${MasjidService.roleTitles[c['role_title']] ?? c['role_title']}', style: const TextStyle(fontWeight: FontWeight.w700)),
        Text('موبايل الطلب ${c['phone']}${c['account_phone'] != null ? '  ·  موبايل الحساب ${c['account_phone']}' : ''}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
        if (c['note'] != null) Text('ملاحظته: ${c['note']}', style: const TextStyle(fontSize: 11.5)),
        Text(
          [
            if (created != null) 'اتبعت ${DateFormat('yyyy/MM/dd HH:mm').format(created)}',
            c['mosque_verified'] == true ? 'المسجد موثّق بالفعل (${c['current_admins']} مسؤول)' : 'المسجد مش موثّق',
          ].join(' • '),
          style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
        ),
        if (c['review_note'] != null) Text('ملاحظة المراجعة: ${c['review_note']}', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          OutlinedButton.icon(
            onPressed: () => launchUrl(Uri.parse('https://wa.me/2${c['phone']}'), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.chat_rounded, size: 16),
            label: const Text('واتساب', style: TextStyle(fontSize: 11.5)),
          ),
          if (doc != null)
            OutlinedButton.icon(
              onPressed: () => _openDoc(doc),
              icon: const Icon(Icons.description_outlined, size: 16),
              label: const Text('الإثبات', style: TextStyle(fontSize: 11.5)),
            ),
          OutlinedButton.icon(
            onPressed: () => openDirections(lat: (c['lat'] as num).toDouble(), lng: (c['lng'] as num).toDouble()),
            icon: const Icon(Icons.map_outlined, size: 16),
            label: const Text('على الخريطة', style: TextStyle(fontSize: 11.5)),
          ),
          if (isInAppPath(AppRoutes.mosque(c['mosque_id'] as String)))
            TextButton(onPressed: () => context.push(AppRoutes.mosque(c['mosque_id'] as String)), child: const Text('صفحة المسجد', style: TextStyle(fontSize: 11.5))),
          if (status == 'pending') ...[
            ElevatedButton.icon(
              onPressed: busy ? null : () => _review(c, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
              icon: const Icon(Icons.verified_rounded, size: 16),
              label: const Text('وثّق', style: TextStyle(fontSize: 11.5)),
            ),
            OutlinedButton.icon(
              onPressed: busy ? null : () => _review(c, false),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFC62828)),
              icon: const Icon(Icons.block_rounded, size: 16),
              label: const Text('ارفض', style: TextStyle(fontSize: 11.5)),
            ),
          ],
        ]),
      ]),
    );
  }
}
