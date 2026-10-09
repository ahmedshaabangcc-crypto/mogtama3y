import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../shared/load_error_view.dart';

/// Super admin: reported / auto-hidden «شات المسجد» messages (0081),
/// unverified mosques first — nobody else moderates those until an imam
/// is verified. Restore (dismiss the reports), remove, or mute / ban the
/// author from that mosque's chat.
class AdminMosqueChatScreen extends StatefulWidget {
  const AdminMosqueChatScreen({super.key});

  @override
  State<AdminMosqueChatScreen> createState() => _AdminMosqueChatScreenState();
}

class _AdminMosqueChatScreenState extends State<AdminMosqueChatScreen> {
  List<Map<String, dynamic>> _rows = [];
  bool _loading = true;
  bool _error = false;
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
      final rows = await MasjidService.adminChatReports();
      if (!mounted) return;
      setState(() {
        _rows = rows;
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

  Future<void> _act(Map<String, dynamic> r, Future<void> Function() f, String done) async {
    final id = r['id'] as String;
    setState(() => _busy.add(id));
    try {
      await f();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'حصلت مشكلة، جرّب تاني')));
      }
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بلاغات شات المساجد'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded))]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل البلاغات')
              : _rows.isEmpty
                  ? const Center(child: Text('مفيش بلاغات — الحمد لله'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(padding: const EdgeInsets.all(12), children: [for (final r in _rows) _card(r)]),
                    ),
    );
  }

  Widget _card(Map<String, dynamic> r) {
    final busy = _busy.contains(r['id']);
    final hidden = r['is_hidden'] == true;
    final reasons = ((r['reasons'] as List?) ?? const []).map((e) => '$e').toList();
    final at = DateTime.tryParse(r['created_at'] as String? ?? '')?.toLocal();
    final mosqueId = r['mosque_id'] as String;
    final userId = r['user_id'] as String;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(
              child: InkWell(
                onTap: () => context.push(AppRoutes.mosque(mosqueId)),
                child: Text(r['mosque_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.crystal)),
              ),
            ),
            Text(r['mosque_verified'] == true ? 'موثّق (له إدارة)' : 'من غير إدارة', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 6),
          Text(r['body'] as String? ?? '', style: const TextStyle(fontSize: 13.5, height: 1.5)),
          const SizedBox(height: 6),
          Text(
            [
              '${r['full_name'] ?? ''}${r['phone'] != null ? ' (${r['phone']})' : ''}',
              if (at != null) DateFormat('yyyy/MM/dd HH:mm').format(at),
              '${r['reports_count'] ?? 0} بلاغ',
              if (hidden) 'مخفية',
              if (r['sanction'] != null) 'عقوبة: ${r['sanction']}',
            ].join(' • '),
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
          ),
          if (reasons.isNotEmpty) Text('الأسباب: ${reasons.join('، ')}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          const SizedBox(height: 6),
          busy
              ? const Align(alignment: AlignmentDirectional.centerStart, child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
              : Wrap(spacing: 6, runSpacing: 4, children: [
                  OutlinedButton(
                    onPressed: () => _act(r, () => MasjidService.adminChatRestore(r['id'] as String), hidden ? 'الرسالة رجعت' : 'البلاغات اتشالت'),
                    child: Text(hidden ? 'رجّعها' : 'تجاهل البلاغات'),
                  ),
                  if (!hidden)
                    OutlinedButton(
                      onPressed: () => _act(r, () => MasjidService.chatDelete(r['id'] as String, reason: 'admin'), 'الرسالة اتشالت'),
                      child: const Text('شيلها'),
                    ),
                  OutlinedButton(
                    onPressed: () => _act(r, () => MasjidService.chatSanction(mosqueId, userId, 'mute', minutes: 1440), 'اتكتم يوم'),
                    child: const Text('كتم يوم'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
                    onPressed: () => _act(r, () => MasjidService.chatSanction(mosqueId, userId, 'ban'), 'اتمنع من شات المسجد'),
                    child: const Text('امنعه من الشات'),
                  ),
                ]),
        ]),
      ),
    );
  }
}
