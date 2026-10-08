import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show RealtimeChannel;

import '../../core/auth/auth_service.dart';
import '../../core/realtime/realtime_inserts.dart';
import '../../core/rooms/rooms_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../profile/phone_verify_screen.dart';
import '../shared/load_error_view.dart';
import 'room_widgets.dart';

const _quickEmoji = ['😂', '❤️', '👍', '👏', '🙏', '😮', '😢', '🔥', '🌹', '😅'];

/// One public room (route `/rooms/:id`). New messages arrive live
/// (Realtime on chat_room_messages, 0078) with a poll as a fallback —
/// every 10 s for guests, 30 s when signed in. Signed-in users send a
/// heartbeat every 30 s for «الموجودين دلوقتي».
class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  Map<String, dynamic>? _room;
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _loadError = false;
  bool _notFound = false;
  bool _sending = false;
  bool _loadingOlder = false;
  bool _noOlder = false;
  bool _showEmoji = false;
  Map<String, dynamic>? _replyTo;
  int _online = 0;
  Timer? _poll;
  Timer? _beat;
  RealtimeChannel? _live;

  bool get _signedIn => AuthService.isSignedIn;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadRoom();
    if (!mounted || _room == null) return;
    await _loadMessages(initial: true);
    _live = subscribeToInserts(
      table: 'chat_room_messages',
      column: 'room_id',
      value: widget.roomId,
      onInsert: (_) => _loadNew(),
    );
    _poll = Timer.periodic(Duration(seconds: _signedIn ? 30 : 10), (_) => _loadNew());
    if (_signedIn) {
      _heartbeat();
      _beat = Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
    }
  }

  @override
  void dispose() {
    _poll?.cancel();
    _beat?.cancel();
    if (_live != null) unsubscribe(_live!);
    if (_signedIn && _room != null) RoomsService.leave(widget.roomId).catchError((_) {});
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadRoom() async {
    try {
      final room = await RoomsService.room(widget.roomId);
      if (!mounted) return;
      setState(() {
        _room = room;
        _notFound = room == null;
        _online = (room?['online_count'] as num?)?.toInt() ?? _online;
        if (room == null) _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  Future<void> _heartbeat() async {
    try {
      final n = await RoomsService.heartbeat(widget.roomId);
      if (mounted) setState(() => _online = n);
    } catch (_) {}
  }

  Future<void> _loadMessages({bool initial = false}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _loadError = false;
      });
    }
    try {
      final rows = await RoomsService.messages(widget.roomId);
      if (!mounted) return;
      setState(() {
        _messages = rows;
        _loading = false;
        _loadError = false;
        _noOlder = rows.length < 60;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted || !initial) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  /// Messages after the newest one on screen (or a full reload when empty).
  Future<void> _loadNew() async {
    if (!mounted || _loading) return;
    if (_messages.isEmpty) return _loadMessages();
    try {
      final rows = await RoomsService.messages(widget.roomId, after: _messages.last['created_at'] as String?);
      if (!mounted || rows.isEmpty) return;
      final known = _messages.map((m) => m['id']).toSet();
      final fresh = rows.where((m) => !known.contains(m['id'])).toList();
      if (fresh.isEmpty) return;
      final atBottom = !_scroll.hasClients || _scroll.position.pixels >= _scroll.position.maxScrollExtent - 120;
      setState(() => _messages = [..._messages, ...fresh]);
      if (atBottom) _scrollToBottom();
    } catch (_) {}
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || _messages.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      final rows = await RoomsService.messages(widget.roomId, before: _messages.first['created_at'] as String?);
      if (!mounted) return;
      setState(() {
        _messages = [...rows, ..._messages];
        _noOlder = rows.length < 60;
      });
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e, 'تعذر تحميل الرسايل الأقدم'));
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  Future<void> _send([String? text]) async {
    final body = (text ?? _input.text).trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await RoomsService.send(widget.roomId, body, replyTo: _replyTo?['id'] as String?);
      if (text == null) _input.clear();
      if (!mounted) return;
      setState(() => _replyTo = null);
      await _loadNew();
      _scrollToBottom();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e, 'تعذر إرسال الرسالة، جرّب تاني'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  // ---------------------------------------------------------------- actions
  Future<void> _messageActions(Map<String, dynamic> m) async {
    final mine = m['mine'] == true;
    final canWrite = _room?['can_write'] == true;
    final canModerate = _room?['can_moderate'] == true;
    final isAdmin = _room?['is_admin'] == true;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: RoomNickname(nickname: m['nickname'] as String? ?? '', verified: m['verified'] == true, fontSize: 14),
            ),
            if (canWrite)
              SizedBox(
                height: 48,
                child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
                  for (final e in _quickEmoji)
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.of(ctx).pop('emoji:$e'),
                      child: Padding(padding: const EdgeInsets.all(8), child: Text(e, style: const TextStyle(fontSize: 22))),
                    ),
                ]),
              ),
            if (canWrite) ListTile(leading: const Icon(Icons.reply_rounded), title: const Text('رد'), onTap: () => Navigator.of(ctx).pop('reply')),
            ListTile(leading: const Icon(Icons.copy_rounded), title: const Text('نسخ'), onTap: () => Navigator.of(ctx).pop('copy')),
            if (!mine && _signedIn) ...[
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_rounded),
                title: const Text('كلّمه خاص'),
                subtitle: const Text('هيوصله طلب صداقة، والشات الخاص بيفتح لما يقبل'),
                onTap: () => Navigator.of(ctx).pop('friend'),
              ),
              ListTile(leading: const Icon(Icons.visibility_off_rounded), title: const Text('تجاهل'), onTap: () => Navigator.of(ctx).pop('ignore')),
              ListTile(leading: const Icon(Icons.flag_rounded, color: Colors.red), title: const Text('بلّغ'), onTap: () => Navigator.of(ctx).pop('report')),
            ],
            if (canModerate && !mine) ...[
              const Divider(),
              ListTile(leading: const Icon(Icons.hide_source_rounded), title: const Text('إخفاء الرسالة (مشرف)'), onTap: () => Navigator.of(ctx).pop('hide')),
              ListTile(leading: const Icon(Icons.volume_off_rounded), title: const Text('كتم 15 دقيقة'), onTap: () => Navigator.of(ctx).pop('mute:15')),
              ListTile(leading: const Icon(Icons.volume_off_rounded), title: const Text('كتم ساعة'), onTap: () => Navigator.of(ctx).pop('mute:60')),
              ListTile(leading: const Icon(Icons.volume_off_rounded), title: const Text('كتم يوم'), onTap: () => Navigator.of(ctx).pop('mute:1440')),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.block_rounded, color: Colors.red),
                  title: const Text('حظر من كل الغرف (نهائي)'),
                  onTap: () => Navigator.of(ctx).pop('ban'),
                ),
            ],
          ]),
        ),
      ),
    );
    if (action == null || !mounted) return;
    final id = m['id'] as String;
    final author = m['author'] as String;
    final nick = m['nickname'] as String? ?? '';
    try {
      if (action.startsWith('emoji:')) {
        setState(() => _replyTo = m);
        await _send(action.substring(6));
      } else if (action == 'reply') {
        setState(() => _replyTo = m);
      } else if (action == 'copy') {
        await Clipboard.setData(ClipboardData(text: m['body'] as String? ?? ''));
        if (mounted) showRoomSnack(context, 'اتنسخت');
      } else if (action == 'friend') {
        await _friendRequest(author, nick);
      } else if (action == 'ignore') {
        await _ignore(author, nick);
      } else if (action == 'report') {
        final reason = await pickRoomReportReason(context);
        if (reason == null) return;
        final hidden = await RoomsService.report(id, reason);
        if (!mounted) return;
        showRoomSnack(context, hidden ? 'وصلنا البلاغ، والرسالة اتخفت لحد ما الإدارة تراجعها' : 'وصلنا البلاغ، شكراً ليك');
        if (hidden) setState(() => _messages.removeWhere((x) => x['id'] == id));
      } else if (action == 'hide') {
        await RoomsService.hide(id);
        if (!mounted) return;
        setState(() => _messages.removeWhere((x) => x['id'] == id));
        showRoomSnack(context, 'الرسالة اتخفت');
      } else if (action.startsWith('mute:')) {
        await RoomsService.mute(id, int.parse(action.substring(5)));
        if (mounted) showRoomSnack(context, 'تم كتم $nick');
      } else if (action == 'ban') {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('حظر نهائي'),
            content: Text('متأكد إنك عايز تمنع $nick من الكتابة في كل الغرف؟ تقدر ترفع الحظر من لوحة الإدارة.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
              FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('حظر')),
            ],
          ),
        );
        if (ok != true) return;
        await RoomsService.adminBan(id);
        if (mounted) showRoomSnack(context, 'تم حظر $nick من الغرف');
      }
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _friendRequest(String author, String nick) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('كلّم $nick خاص'),
        content: const Text('هيوصله طلب صداقة باسمك الحقيقي على مُجتمعي. لو قبل، تقدروا تتكلموا في «أصحابي والرسائل».'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('ابعت الطلب')),
        ],
      ),
    );
    if (ok != true) return;
    final state = await RoomsService.friendRequest(author);
    if (!mounted) return;
    showRoomSnack(context, state == 'friends' ? 'إنتوا أصحاب دلوقتي — تقدروا تتكلموا خاص' : 'اتبعت طلب الصداقة');
  }

  Future<void> _ignore(String author, String nick) async {
    await RoomsService.ignore(author);
    if (!mounted) return;
    setState(() => _messages.removeWhere((x) => x['author'] == author));
    showRoomSnack(context, 'مش هتشوف رسايل $nick تاني. تقدر تلغي التجاهل من القائمة فوق.');
  }

  Future<void> _showOnline() async {
    List<Map<String, dynamic>> people = [];
    try {
      people = await RoomsService.online(widget.roomId);
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
      return;
    }
    if (!mounted) return;
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text('الموجودين دلوقتي (${people.length})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ),
            if (people.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('مفيش حد بإسم في الغرفة دلوقتي', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
              ),
            Flexible(
              child: ListView(shrinkWrap: true, children: [
                for (final p in people)
                  ListTile(
                    leading: const Icon(Icons.circle, size: 10, color: AppColors.success),
                    title: RoomNickname(nickname: p['nickname'] as String? ?? '', verified: p['verified'] == true, fontSize: 13.5),
                    trailing: p['is_me'] == true ? const Text('إنت', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)) : null,
                    onTap: p['is_me'] == true || !_signedIn ? null : () => Navigator.of(ctx).pop(p),
                  ),
              ]),
            ),
          ]),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    final author = picked['author'] as String;
    final nick = picked['nickname'] as String? ?? '';
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.person_add_alt_1_rounded), title: Text('كلّم $nick خاص'), onTap: () => Navigator.of(ctx).pop('friend')),
          ListTile(leading: const Icon(Icons.visibility_off_rounded), title: Text('تجاهل $nick'), onTap: () => Navigator.of(ctx).pop('ignore')),
        ]),
      ),
    );
    if (action == null || !mounted) return;
    try {
      if (action == 'friend') await _friendRequest(author, nick);
      if (action == 'ignore') await _ignore(author, nick);
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _showIgnored() async {
    List<Map<String, dynamic>> rows;
    try {
      rows = await RoomsService.ignored();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
      return;
    }
    if (!mounted) return;
    final undo = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('اللي بتتجاهلهم', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
          if (rows.isEmpty)
            const Padding(padding: EdgeInsets.all(24), child: Text('مش بتتجاهل حد', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted))),
          for (final r in rows)
            ListTile(
              title: Text(r['nickname'] as String? ?? ''),
              trailing: TextButton(onPressed: () => Navigator.of(ctx).pop(r), child: const Text('إلغاء التجاهل')),
            ),
        ]),
      ),
    );
    if (undo == null) return;
    try {
      await RoomsService.ignore(undo['author'] as String, on: false);
      await _loadMessages();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _menu(String action) async {
    switch (action) {
      case 'ignored':
        await _showIgnored();
      case 'nickname':
        final saved = await pickRoomNickname(context, current: _room?['nickname'] as String?);
        if (saved != null) await _loadRoom();
    }
  }

  // ---------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    final side = roomSidePadding(context);
    final room = _room;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(room == null ? 'غرفة الدردشة' : '${room['icon'] ?? '💬'} ${room['name']}', maxLines: 1, overflow: TextOverflow.ellipsis),
          if (room != null)
            Text('$_online موجود دلوقتي', style: const TextStyle(fontSize: 11.5, color: AppColors.success, fontWeight: FontWeight.w700)),
        ]),
        actions: [
          if (room != null)
            IconButton(tooltip: 'الموجودين دلوقتي', onPressed: _showOnline, icon: const Icon(Icons.people_alt_rounded)),
          if (room != null && _signedIn)
            PopupMenuButton<String>(
              onSelected: _menu,
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'ignored', child: Text('اللي بتتجاهلهم')),
                if (room['nickname'] != null) const PopupMenuItem(value: 'nickname', child: Text('غيّر اسمي في الغرف')),
              ],
            ),
        ],
      ),
      body: _notFound
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('الغرفة دي مش موجودة أو اتقفلت', style: TextStyle(color: AppColors.inkSecondary)),
                const SizedBox(height: 12),
                FilledButton(onPressed: () => context.go(AppRoutes.rooms), child: const Text('كل الغرف')),
              ]),
            )
          : Column(children: [
              Expanded(child: _list(side)),
              _bottom(side),
            ]),
    );
  }

  Widget _list(double side) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError) {
      return LoadErrorView(
        onRetry: () async {
          await _loadRoom();
          if (_room != null) await _loadMessages(initial: true);
        },
        message: 'تعذر تحميل الغرفة',
      );
    }
    if (_messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('الغرفة هادية — ابدأ إنت وقول أهلاً 👋', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(side, 8, side, 12),
      itemCount: _messages.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          if (_noOlder) return const SizedBox(height: 4);
          return Center(
            child: TextButton(
              onPressed: _loadingOlder ? null : _loadOlder,
              child: Text(_loadingOlder ? 'لحظة…' : 'رسايل أقدم'),
            ),
          );
        }
        return _bubble(_messages[i - 1]);
      },
    );
  }

  Widget _bubble(Map<String, dynamic> m) {
    final mine = m['mine'] == true;
    final replyNick = m['reply_nickname'] as String?;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8 > 560 ? 560 : MediaQuery.sizeOf(context).width * 0.8),
        child: GestureDetector(
          onTap: () => _messageActions(m),
          onLongPress: () => _messageActions(m),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.fromLTRB(11, 7, 11, 6),
            decoration: BoxDecoration(
              color: mine ? AppColors.tealLight.withValues(alpha: 0.55) : AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Flexible(child: RoomNickname(nickname: m['nickname'] as String? ?? '', verified: m['verified'] == true)),
                const SizedBox(width: 8),
                Text(roomTime(m['created_at'] as String?), style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
              ]),
              if (m['reply_to'] != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: const BorderDirectional(start: BorderSide(color: AppColors.gold, width: 3)),
                  ),
                  child: Text(
                    replyNick == null ? 'رسالة اتشالت' : '$replyNick: ${m['reply_body'] ?? ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary),
                  ),
                ),
              const SizedBox(height: 3),
              Text(m['body'] as String? ?? '', style: const TextStyle(fontSize: 13.5, height: 1.45, color: AppColors.ink)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _bottom(double side) {
    final room = _room;
    if (room == null || _loading) return const SizedBox.shrink();
    if (room['can_write'] != true) return _prompt(side, room);
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(side, 6, side, 8),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (_replyTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 4, 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.reply_rounded, size: 16, color: AppColors.inkSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('رد على ${_replyTo!['nickname']}: ${_replyTo!['body']}',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _replyTo = null),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ]),
            ),
          if (_showEmoji)
            SizedBox(
              height: 44,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final e in _quickEmoji)
                  InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      final sel = _input.selection;
                      final text = _input.text;
                      final at = sel.isValid ? sel.start : text.length;
                      _input.value = TextEditingValue(
                        text: text.replaceRange(at, sel.isValid ? sel.end : text.length, e),
                        selection: TextSelection.collapsed(offset: at + e.length),
                      );
                    },
                    child: Padding(padding: const EdgeInsets.all(8), child: Text(e, style: const TextStyle(fontSize: 21))),
                  ),
              ]),
            ),
          Row(children: [
            IconButton(
              tooltip: 'إيموجي',
              onPressed: () => setState(() => _showEmoji = !_showEmoji),
              icon: Icon(_showEmoji ? Icons.keyboard_rounded : Icons.emoji_emotions_outlined),
            ),
            Expanded(
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(hintText: 'اكتب في الغرفة كـ ${room['nickname']}…', isDense: true, counterText: ''),
              ),
            ),
            const SizedBox(width: 6),
            _sending
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton.filled(tooltip: 'إرسال', onPressed: _send, icon: const Icon(Icons.send_rounded)),
          ]),
        ]),
      ),
    );
  }

  Widget _prompt(double side, Map<String, dynamic> room) {
    final reason = room['blocked_reason'] as String?;
    String text;
    String? action;
    Future<void> Function()? onTap;
    switch (reason) {
      case 'guest':
        text = 'إنت بتقرا كضيف. سجّل دخولك عشان تكتب.';
        action = 'تسجيل الدخول';
        onTap = () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
          if (mounted && AuthService.isSignedIn) {
            await _loadRoom();
            _beat ??= Timer.periodic(const Duration(seconds: 30), (_) => _heartbeat());
            _heartbeat();
          }
        };
      case 'no_phone':
        text = 'أكّد رقمك عشان تكتب في الغرف';
        action = 'أكّد رقمك';
        onTap = () async {
          final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const PhoneVerifyScreen()));
          if (ok == true) await _loadRoom();
        };
      case 'no_nickname':
        text = 'اختار اسمك في الغرف عشان تكتب (اسمك الحقيقي مش هيظهر)';
        action = 'اختار اسمك';
        onTap = () async {
          final saved = await pickRoomNickname(context);
          if (saved != null) await _loadRoom();
        };
      case 'muted':
        text = 'إنت مكتوم مؤقتاً في الغرفة دي لحد ${roomTime(room['sanction_until'] as String?)}';
      case 'banned':
        text = room['sanction_until'] == null
            ? 'إنت ممنوع من الكتابة في الغرف'
            : 'إنت ممنوع من الكتابة في الغرف لحد ${roomTime(room['sanction_until'] as String?)}';
      default:
        text = 'الغرفة دي مقفولة للكتابة';
    }
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(side + 4, 10, side + 4, 10),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.5))),
          if (action != null) ...[
            const SizedBox(width: 8),
            FilledButton(onPressed: onTap, child: Text(action)),
          ],
        ]),
      ),
    );
  }
}
