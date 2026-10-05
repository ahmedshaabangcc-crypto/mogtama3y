import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/people/people_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'people_widgets.dart';

/// A private, friends-only conversation (route `/chat/:userId`). Polls for
/// new messages every 5 seconds while open; fetching also marks theirs read.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  String _title = 'محادثة';
  bool _loading = true;
  bool _loadError = false;
  bool _sending = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    if (!AuthService.isSignedIn) return;
    _loadTitle();
    _load(initial: true);
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _load());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadTitle() async {
    try {
      final friends = await PeopleService.myFriends();
      final me = friends.where((f) => f['user_id'] == widget.userId).firstOrNull;
      final name = me?['full_name'] as String?;
      if (!mounted || name == null || name.isEmpty) return;
      setState(() => _title = name);
    } catch (_) {}
  }

  Future<void> _load({bool initial = false}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _loadError = false;
      });
    }
    try {
      final messages = await PeopleService.messages(widget.userId);
      if (!mounted) return;
      final grew = messages.length != _messages.length ||
          (messages.isNotEmpty && _messages.isNotEmpty && messages.last['id'] != _messages.last['id']);
      setState(() {
        _messages = messages;
        _loading = false;
        _loadError = false;
      });
      if (grew || initial) _scrollToBottom();
    } catch (_) {
      // A failed background poll keeps what's on screen.
      if (!mounted || !initial) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await PeopleService.send(widget.userId, body);
      _input.clear();
      await _load();
    } catch (e) {
      if (mounted) showPeopleSnack(context, peopleError(e, 'تعذر إرسال الرسالة، جرّب تاني'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _menu(String action) async {
    switch (action) {
      case 'block':
        if (await confirmAndBlock(context, widget.userId, _title) && mounted) _leave();
      case 'report':
        await reportPerson(context, widget.userId, _title);
      case 'unfriend':
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('إلغاء الصداقة'),
            content: Text('متأكد إنك عايز تلغي الصداقة مع $_title؟ مش هتقدروا تكلموا بعض تاني غير لو اتصاحبتوا من جديد.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
              FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('إلغاء الصداقة')),
            ],
          ),
        );
        if (ok != true || !mounted) return;
        try {
          await PeopleService.remove(widget.userId);
          if (mounted) _leave();
        } catch (e) {
          if (mounted) showPeopleSnack(context, peopleError(e));
        }
    }
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.friends);
    }
  }

  @override
  Widget build(BuildContext context) {
    final side = peopleSidePadding(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (AuthService.isSignedIn)
            PopupMenuButton<String>(
              onSelected: _menu,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'block', child: Text('حظر')),
                PopupMenuItem(value: 'report', child: Text('إبلاغ')),
                PopupMenuItem(value: 'unfriend', child: Text('إلغاء الصداقة')),
              ],
            ),
        ],
      ),
      body: !AuthService.isSignedIn
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('سجّل دخولك عشان تشوف المحادثة', style: TextStyle(color: AppColors.inkSecondary)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
                    child: const Text('تسجيل الدخول'),
                  ),
                ]),
              ),
            )
          : Column(children: [
              Expanded(child: _list(side)),
              _composer(side),
            ]),
    );
  }

  Widget _list(double side) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: () => _load(initial: true), message: 'تعذر تحميل المحادثة');
    if (_messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('مفيش رسايل لسه — ابدأ إنت وقول أهلاً', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(side, 12, side, 12),
      itemCount: _messages.length,
      itemBuilder: (context, i) => _bubble(_messages[i]),
    );
  }

  Widget _bubble(Map<String, dynamic> m) {
    final mine = m['mine'] == true;
    final time = _time(m['created_at'] as String?);
    final read = mine && m['read_at'] != null;
    return Align(
      // Directional, so the sides mirror correctly in RTL.
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75 > 520 ? 520 : MediaQuery.sizeOf(context).width * 0.75),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          decoration: BoxDecoration(
            color: mine ? AppColors.teal : AppColors.surface,
            border: mine ? null : Border.all(color: AppColors.border),
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(14),
              topEnd: const Radius.circular(14),
              bottomStart: Radius.circular(mine ? 14 : 4),
              bottomEnd: Radius.circular(mine ? 4 : 14),
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SelectableText(m['body'] as String? ?? '', style: TextStyle(color: mine ? Colors.white : AppColors.ink, fontSize: 13.5, height: 1.45)),
            const SizedBox(height: 2),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(time, style: TextStyle(fontSize: 10, color: mine ? Colors.white70 : AppColors.inkMuted)),
              if (mine) ...[
                const SizedBox(width: 4),
                Icon(read ? Icons.done_all_rounded : Icons.done_rounded, size: 13, color: Colors.white70),
              ],
            ]),
          ]),
        ),
      ),
    );
  }

  static String _time(String? iso) {
    final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
    if (t == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    final now = DateTime.now();
    final hm = '${two(t.hour)}:${two(t.minute)}';
    if (t.year == now.year && t.month == now.month && t.day == now.day) return hm;
    return '${t.day}/${t.month} $hm';
  }

  Widget _composer(double side) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(side, 8, side, 8),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _input,
              minLines: 1,
              maxLines: 4,
              maxLength: 2000,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(hintText: 'اكتب رسالة…', isDense: true, counterText: ''),
            ),
          ),
          const SizedBox(width: 6),
          _sending
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : IconButton.filled(
                  tooltip: 'إرسال',
                  onPressed: _send,
                  icon: const Icon(Icons.send_rounded),
                ),
        ]),
      ),
    );
  }
}
