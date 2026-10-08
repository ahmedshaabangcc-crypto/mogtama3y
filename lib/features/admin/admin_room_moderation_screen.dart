import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/rooms/rooms_service.dart';
import '../../core/theme/app_colors.dart';
import '../rooms/room_widgets.dart';
import '../shared/load_error_view.dart';
import 'admin_chat_rooms_screen.dart';

String _date(String? iso) {
  final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
  return t == null ? '' : DateFormat('yyyy/MM/dd HH:mm').format(t);
}

const _actionLabels = {
  'auto_hide': 'اتخفت تلقائياً (3 بلاغات)',
  'hide': 'إخفاء رسالة',
  'restore': 'رجوع رسالة',
  'delete': 'مسح رسالة',
  'mute': 'كتم',
  'ban': 'حظر',
  'lift': 'رفع عقوبة',
  'moderator_add': 'إضافة مشرف',
  'moderator_remove': 'شيل مشرف',
  'room_create': 'غرفة جديدة',
  'room_update': 'تعديل غرفة',
  'word_add': 'كلمة ممنوعة جديدة',
  'word_remove': 'شيل كلمة ممنوعة',
  'purge': 'مسح الرسايل القديمة',
};

/// Super admin: moderation of the chat rooms (0078) — reported / hidden
/// messages with the real account, active mutes & bans, and the audit log.
class AdminRoomModerationScreen extends StatefulWidget {
  const AdminRoomModerationScreen({super.key});

  @override
  State<AdminRoomModerationScreen> createState() => _AdminRoomModerationScreenState();
}

class _AdminRoomModerationScreenState extends State<AdminRoomModerationScreen> {
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _sanctions = [];
  List<Map<String, dynamic>> _log = [];

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
      final results = await Future.wait([RoomsService.adminReports(), RoomsService.adminSanctions(), RoomsService.adminLog()]);
      if (!mounted) return;
      setState(() {
        _reports = results[0];
        _sanctions = results[1];
        _log = results[2];
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

  Future<void> _lift(Map<String, dynamic> s) async {
    try {
      await RoomsService.adminLift(s['id'] as String);
      if (mounted) showRoomSnack(context, 'اترفعت العقوبة');
      _load();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final side = roomSidePadding(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: const Text('إشراف الغرف'),
          bottom: TabBar(tabs: [
            Tab(text: 'البلاغات (${_reports.length})'),
            Tab(text: 'الكتم والحظر (${_sanctions.length})'),
            const Tab(text: 'السجل'),
          ]),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error
                ? LoadErrorView(onRetry: _load, message: 'تعذر التحميل')
                : TabBarView(children: [
                    _list(side, _reports, 'مفيش بلاغات', (m) => AdminRoomMessageCard(message: m, onChanged: _load)),
                    _list(side, _sanctions, 'مفيش حد مكتوم أو محظور', _sanctionCard),
                    _list(side, _log, 'السجل فاضي', _logCard),
                  ]),
      ),
    );
  }

  Widget _list(double side, List<Map<String, dynamic>> rows, String empty, Widget Function(Map<String, dynamic>) item) {
    return RefreshIndicator(
      onRefresh: _load,
      child: rows.isEmpty
          ? ListView(children: [
              Padding(padding: const EdgeInsets.all(40), child: Center(child: Text(empty, style: const TextStyle(color: AppColors.inkMuted)))),
            ])
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(side, 12, side, 24),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => item(rows[i]),
            ),
    );
  }

  Widget _sanctionCard(Map<String, dynamic> s) {
    final ban = s['kind'] == 'ban';
    final until = s['until'] as String?;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(ban ? Icons.block_rounded : Icons.volume_off_rounded, color: ban ? Colors.red : AppColors.gold),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${s['nickname'] ?? '—'}  ←  ${s['full_name'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            Text(s['email'] as String? ?? '', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            Text(
              '${ban ? 'حظر' : 'كتم'} ${s['room_name'] == null ? 'في كل الغرف' : 'في ${s['room_name']}'} · '
              '${until == null ? 'نهائي' : 'لحد ${_date(until)}'}${s['reason'] != null ? ' · ${s['reason']}' : ''}',
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
            ),
          ]),
        ),
        TextButton(onPressed: () => _lift(s), child: const Text('ارفع')),
      ]),
    );
  }

  Widget _logCard(Map<String, dynamic> l) {
    final detail = (l['detail'] as Map?)?.entries.where((e) => e.value != null).map((e) => '${e.key}: ${e.value}').join(' · ') ?? '';
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_actionLabels[l['action']] ?? '${l['action']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        Text(
          [
            _date(l['created_at'] as String?),
            if (l['actor'] != null) 'بواسطة ${l['actor']}',
            if (l['room_name'] != null) 'غرفة ${l['room_name']}',
            if (l['target_nickname'] != null || l['target_name'] != null) 'على ${l['target_nickname'] ?? ''} (${l['target_name'] ?? ''})',
          ].join(' · '),
          style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary),
        ),
        if (detail.isNotEmpty) Text(detail, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
      ]),
    );
  }
}
