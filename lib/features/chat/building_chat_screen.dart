import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show RealtimeChannel;

import '../../core/auth/auth_service.dart';
import '../../core/chat/building_chat_service.dart';
import '../../core/realtime/realtime_inserts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/member_names.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';

String _timeLabel(DateTime dt) {
  final local = dt.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Real building-wide group chat — see
/// backend/migrations/0025_building_chat.sql. Polls every few seconds
/// while open rather than a realtime subscription, consistent with the
/// rest of the app.
class BuildingChatScreen extends StatefulWidget {
  const BuildingChatScreen({super.key, required this.buildingId, required this.buildingName});
  final String buildingId, buildingName;

  @override
  State<BuildingChatScreen> createState() => _BuildingChatScreenState();
}

class _BuildingChatScreenState extends State<BuildingChatScreen> {
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _poll;
  RealtimeChannel? _channel;
  /// Names as this user may see them («عائلة …» for members who chose so).
  Map<String, String> _names = const {};

  @override
  void initState() {
    super.initState();
    _load();
    MemberNames.fetch(widget.buildingId).then((n) {
      if (mounted) setState(() => _names = n);
    });
    // New messages arrive instantly over Realtime; the slow poll is only a
    // fallback in case the realtime connection drops.
    _channel = subscribeToInserts(
      table: 'building_chat_messages',
      column: 'building_id',
      value: widget.buildingId,
      onInsert: (_) => _load(silent: true),
    );
    _poll = Timer.periodic(const Duration(seconds: 30), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _poll?.cancel();
    if (_channel != null) unsubscribe(_channel!);
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final List<Map<String, dynamic>> rows;
    try {
      rows = await BuildingChatService.fetchMessages(widget.buildingId);
    } catch (_) {
      // Keep what is already on screen; the 4s poll retries on its own.
      if (!mounted) return;
      setState(() => _loading = false);
      if (!silent) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تحميل الرسائل، تحقق من الاتصال')));
      return;
    }
    if (!mounted) return;
    // Compare the newest message, not the count — the list is capped at
    // 200, so the count stops changing once a chat is busy.
    final grew = (rows.isEmpty ? null : rows.last['id']) != (_messages.isEmpty ? null : _messages.last['id']);
    setState(() {
      _messages = rows;
      _loading = false;
    });
    if (grew) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      });
    }
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    try {
      await BuildingChatService.sendMessage(buildingId: widget.buildingId, body: text);
      // Cleared only after a successful send, so a failed send keeps the text.
      _messageCtrl.clear();
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال الرسالة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = AuthService.currentUser?.id;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('دردشة ${widget.buildingName}')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceAlt,
            child: const Text('دردشة عامة بين جيران العمارة — يراها كل الأعضاء الموثقين', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(child: Text('لا توجد رسائل بعد، ابدأ الحديث مع جيرانك', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[i];
                          final isMe = m['sender_id'] == myUserId;
                          final senderName = _names[m['sender_id']] ?? (m['sender'] as Map<String, dynamic>?)?['full_name'] as String? ?? '';
                          final createdAt = DateTime.tryParse(m['created_at'] as String? ?? '');
                          return Align(
                            alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: isMe ? AppColors.teal.withValues(alpha: 0.1) : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isMe ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isMe) Text(senderName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5)),
                                  Text(m['body'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                                  if (createdAt != null) ...[
                                    const SizedBox(height: 3),
                                    Text(_timeLabel(createdAt), style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: const InputDecoration(hintText: 'اكتب رسالتك لجيرانك...', isDense: true, filled: true, fillColor: AppColors.surface, border: OutlineInputBorder()),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: AppColors.teal)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the building chat for the signed-in user's own building — the
/// union app's entry point (dashboard tile and /#/building-chat). Only
/// verified members get in; the server enforces the same rule (0025).
class BuildingChatEntryScreen extends StatefulWidget {
  const BuildingChatEntryScreen({super.key});

  @override
  State<BuildingChatEntryScreen> createState() => _BuildingChatEntryScreenState();
}

class _BuildingChatEntryScreenState extends State<BuildingChatEntryScreen> {
  bool _loading = true;
  bool _error = false;
  Map<String, dynamic>? _membership;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final m = await UnionService.fetchMyMembership();
      if (mounted) {
        setState(() {
          _membership = m;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) return const AuthLandingScreen();
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error) return Scaffold(appBar: AppBar(title: const Text('دردشة العمارة')), body: LoadErrorView(onRetry: _load));
    final m = _membership;
    if (m == null || m['status'] != 'verified') {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('دردشة العمارة')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('دردشة العمارة لسكانها الموثّقين بس — انضم لعمارتك واستنى موافقة الرئيس',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }
    final building = m['building'] as Map<String, dynamic>?;
    return BuildingChatScreen(buildingId: m['building_id'] as String, buildingName: building?['name'] as String? ?? 'العمارة');
  }
}
