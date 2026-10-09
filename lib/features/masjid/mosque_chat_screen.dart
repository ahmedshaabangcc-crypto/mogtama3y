import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, RealtimeChannel;

import '../../core/auth/auth_service.dart';
import '../../core/masjid/masjid_community.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/realtime/realtime_inserts.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../profile/phone_verify_screen.dart';
import '../rooms/room_widgets.dart' show pickRoomReportReason, roomTime;
import '../shared/load_error_view.dart';
import 'masjid_widgets.dart';
import 'mosque_chat_nickname.dart';

/// «شات المسجد» (migration 0081): one group chat per mosque, members only.
/// New messages arrive live (Realtime on mosque_chat_messages) with a 30 s
/// poll as a fallback. Opening it marks the chat read (the unread badge).
/// Moderators (verified owner / helpers with «chat», or the super admin)
/// remove messages, mute / ban members and see the members list.
/// 0083: posting needs a verified phone (banner → PhoneVerifyScreen),
/// a per-mosque nickname («اسمك في الشات», app-bar menu), and messages
/// are purged after 30 days. Moderators see who is behind a nickname.
class MosqueChatScreen extends StatefulWidget {
  const MosqueChatScreen({super.key, required this.mosqueId, this.mosqueName});
  final String mosqueId;
  final String? mosqueName;

  @override
  State<MosqueChatScreen> createState() => _MosqueChatScreenState();
}

class _MosqueChatScreenState extends State<MosqueChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  Map<String, dynamic>? _m;
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _loadingOlder = false;
  bool _noOlder = false;
  bool _joining = false;
  Map<String, dynamic>? _replyTo;
  Timer? _poll;
  RealtimeChannel? _live;
  Map<String, dynamic>? _me;
  Map<String, Map<String, dynamic>> _identities = {};

  String get _id => widget.mosqueId;
  bool get _canRead => _m?['is_member'] == true || _m?['can_moderate_chat'] == true;
  bool get _canModerate => _m?['can_moderate_chat'] == true;
  bool get _isMember => _m?['is_member'] == true;
  bool get _needsPhone => _me?['needs_phone'] == true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _poll?.cancel();
    if (_live != null) unsubscribe(_live!);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _loadMosque();
    if (!mounted || !_canRead) return;
    _loadMe();
    _loadIdentities();
    await _loadMessages(initial: true);
    _live ??= subscribeToInserts(table: 'mosque_chat_messages', column: 'mosque_id', value: _id, onInsert: (_) => _loadNew());
    _poll ??= Timer.periodic(const Duration(seconds: 30), (_) => _loadNew());
  }

  Future<void> _loadMosque() async {
    try {
      final m = await MasjidService.get(_id);
      if (!mounted) return;
      setState(() {
        _m = m;
        if (m == null || !_canRead) _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadMe() async {
    if (!_isMember) return;
    try {
      final me = await MasjidService.chatProfile(_id);
      if (mounted) setState(() => _me = me);
    } catch (_) {}
  }

  Future<void> _loadIdentities() async {
    if (!_canModerate) return;
    try {
      final rows = await MasjidService.chatIdentities(_id);
      if (mounted) setState(() => _identities = {for (final r in rows) r['user_id'] as String: r});
    } catch (_) {}
  }

  Future<void> _verifyPhone() async {
    final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const PhoneVerifyScreen()));
    if (!mounted) return;
    await _loadMe();
    if (ok == true) _toast('تمام، رقمك اتوثّق — تقدر تكتب في الشات دلوقتي');
  }

  Future<void> _editNickname() async {
    final changed = await editMosqueChatNickname(context, _id);
    if (!changed || !mounted) return;
    await _loadMe();
    await _loadMessages();
  }

  Future<void> _markRead() async {
    try {
      await MasjidService.chatMarkRead(_id);
    } catch (_) {}
  }

  Future<void> _loadMessages({bool initial = false}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _error = false;
      });
    }
    try {
      final rows = await MasjidService.chatMessages(_id);
      if (!mounted) return;
      setState(() {
        _messages = rows;
        _loading = false;
        _noOlder = rows.length < 60;
      });
      _scrollToBottom();
      _markRead();
    } catch (_) {
      if (!mounted || !initial) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadNew() async {
    if (!mounted || _loading) return;
    if (_messages.isEmpty) return _loadMessages();
    try {
      final rows = await MasjidService.chatMessages(_id, after: _messages.last['created_at'] as String?);
      if (!mounted || rows.isEmpty) return;
      final known = _messages.map((m) => m['id']).toSet();
      final fresh = rows.where((m) => !known.contains(m['id'])).toList();
      if (fresh.isEmpty) return;
      final atBottom = !_scroll.hasClients || _scroll.position.pixels >= _scroll.position.maxScrollExtent - 120;
      setState(() => _messages = [..._messages, ...fresh]);
      if (atBottom) _scrollToBottom();
      _markRead();
    } catch (_) {}
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || _messages.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      final rows = await MasjidService.chatMessages(_id, before: _messages.first['created_at'] as String?);
      if (!mounted) return;
      setState(() {
        _messages = [...rows, ..._messages];
        _noOlder = rows.length < 60;
      });
    } catch (e) {
      _toast(masjidError(e, 'تعذر تحميل الرسايل الأقدم'));
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

  void _toast(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _join() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    setState(() => _joining = true);
    try {
      await MasjidService.join(_id);
      await _init();
      _toast('أهلاً بيك في «${_m?['name'] ?? 'المسجد'}» 🤍');
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    final err = mosqueChatBodyError(body);
    if (err != null) return _toast(err);
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await MasjidService.chatSend(_id, body, replyTo: _replyTo?['id'] as String?);
      _input.clear();
      if (!mounted) return;
      setState(() => _replyTo = null);
      await _loadNew();
      _scrollToBottom();
    } catch (e) {
      if (e is PostgrestException && isPhoneUnverifiedError(hint: e.hint, message: e.message)) {
        if (mounted) setState(() => _me = {...?_me, 'needs_phone': true});
        return;
      }
      _toast(masjidError(e, 'تعذر إرسال الرسالة، جرّب تاني'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  // ----------------------------------------------------------- actions
  Future<void> _messageActions(Map<String, dynamic> m) async {
    final mine = m['mine'] == true;
    final isMember = _isMember;
    final identity = _canModerate ? _identities[m['author_id']] : null;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(m['author_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            ),
            if (identity != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text('اسم مستعار — الاسم الحقيقي: ${identity['full_name'] ?? '—'} (للإدارة بس)',
                    style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
              ),
            if (isMember) ListTile(leading: const Icon(Icons.reply_rounded), title: const Text('رد'), onTap: () => Navigator.of(ctx).pop('reply')),
            ListTile(leading: const Icon(Icons.copy_rounded), title: const Text('نسخ'), onTap: () => Navigator.of(ctx).pop('copy')),
            if (mine) ListTile(leading: const Icon(Icons.delete_outline_rounded), title: const Text('امسح رسالتي'), onTap: () => Navigator.of(ctx).pop('delete')),
            if (!mine)
              ListTile(leading: const Icon(Icons.flag_rounded, color: Colors.red), title: const Text('بلّغ'), onTap: () => Navigator.of(ctx).pop('report')),
            if (_canModerate && !mine) ...[
              const Divider(),
              ListTile(leading: const Icon(Icons.hide_source_rounded), title: const Text('شيل الرسالة (إدارة)'), onTap: () => Navigator.of(ctx).pop('remove')),
              ListTile(leading: const Icon(Icons.volume_off_rounded), title: const Text('كتم ساعة'), onTap: () => Navigator.of(ctx).pop('mute:60')),
              ListTile(leading: const Icon(Icons.volume_off_rounded), title: const Text('كتم يوم'), onTap: () => Navigator.of(ctx).pop('mute:1440')),
              ListTile(
                leading: const Icon(Icons.block_rounded, color: Colors.red),
                title: const Text('امنعه من الكتابة في شات المسجد'),
                onTap: () => Navigator.of(ctx).pop('ban'),
              ),
            ],
          ]),
        ),
      ),
    );
    if (action == null || !mounted) return;
    final id = m['id'] as String;
    final author = m['author_id'] as String?;
    final name = identity == null ? m['author_name'] as String? ?? '' : '${m['author_name']} (${identity['full_name'] ?? '—'})';
    try {
      if (action == 'reply') {
        setState(() => _replyTo = m);
      } else if (action == 'copy') {
        await Clipboard.setData(ClipboardData(text: m['body'] as String? ?? ''));
        _toast('اتنسخت');
      } else if (action == 'delete' || action == 'remove') {
        await MasjidService.chatDelete(id);
        if (!mounted) return;
        setState(() => _messages.removeWhere((x) => x['id'] == id));
        _toast(action == 'delete' ? 'اتمسحت' : 'الرسالة اتشالت');
      } else if (action == 'report') {
        final reason = await pickRoomReportReason(context);
        if (reason == null) return;
        final hidden = await MasjidService.chatReport(id, reason);
        if (!mounted) return;
        _toast(hidden ? 'وصلنا البلاغ، والرسالة اتخفت لحد ما الإدارة تراجعها' : 'وصلنا البلاغ، شكراً ليك');
        if (hidden) setState(() => _messages.removeWhere((x) => x['id'] == id));
      } else if (author != null && action.startsWith('mute:')) {
        await MasjidService.chatSanction(_id, author, 'mute', minutes: int.parse(action.substring(5)));
        _toast('تم كتم $name');
      } else if (author != null && action == 'ban') {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('منع من الكتابة'),
            content: Text('متأكد إنك عايز تمنع $name من الكتابة في شات المسجد؟ تقدر ترفع المنع من «الأعضاء».'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
              FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('امنعه')),
            ],
          ),
        );
        if (ok != true) return;
        await MasjidService.chatSanction(_id, author, 'ban');
        _toast('$name مش هيقدر يكتب في الشات');
      }
    } catch (e) {
      _toast(masjidError(e));
    }
  }

  Future<void> _showMembers() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
          child: _MembersSheet(mosqueId: _id),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    final m = _m;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('شات ${m?['name'] ?? widget.mosqueName ?? 'المسجد'}', maxLines: 1, overflow: TextOverflow.ellipsis),
          if (m != null) Text(membersLabel(m['members'] as num?), style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
        ]),
        actions: [
          if (_canModerate) IconButton(tooltip: 'الأعضاء', onPressed: _showMembers, icon: const Icon(Icons.groups_rounded)),
          if (_isMember)
            PopupMenuButton<String>(
              tooltip: 'إعدادات الشات',
              onSelected: (v) {
                if (v == 'nickname') _editNickname();
                if (v == 'phone') _verifyPhone();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'nickname',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('اسمك في الشات'),
                    subtitle: Text(_me?['nickname'] != null ? 'اسم مستعار: ${_me!['nickname']}' : 'اسمك الحقيقي'),
                  ),
                ),
                if (_needsPhone)
                  const PopupMenuItem(
                    value: 'phone',
                    child: ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.verified_user_outlined), title: Text('وثّق رقم موبايلك')),
                  ),
              ],
            ),
        ],
      ),
      body: _error
          ? LoadErrorView(onRetry: _init, message: 'تعذر تحميل الشات')
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : m == null
                  ? const Center(child: Text('المسجد ده مش موجود'))
                  : !_canRead
                      ? _joinPrompt(m)
                      : Column(children: [Expanded(child: _list(side)), _composer(side)]),
    );
  }

  Widget _joinPrompt(Map<String, dynamic> m) {
    final count = (m['chat_messages'] as num?)?.toInt() ?? 0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.forum_rounded, size: 48, color: AppColors.crystal),
          const SizedBox(height: 12),
          Text(count > 0 ? 'فيه $count رسالة في شات المسجد' : 'شات المسجد لسه هادي', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 6),
          const Text('الشات لأعضاء المسجد بس. انضم عشان تشارك جيرانك.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary)),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _joining ? null : _join,
            icon: const Icon(Icons.group_add_rounded),
            label: Text(_joining ? 'لحظة…' : 'انضم عشان تشارك'),
          ),
        ]),
      ),
    );
  }

  Widget _list(double side) {
    if (_messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('الشات هادي — ابدأ إنت وقول السلام عليكم 🤍\n\n$mosqueChatRetentionNote',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(side, 8, side, 12),
      itemCount: _messages.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          if (_noOlder) return const _RetentionNote();
          return Center(child: TextButton(onPressed: _loadingOlder ? null : _loadOlder, child: Text(_loadingOlder ? 'لحظة…' : 'رسايل أقدم')));
        }
        return _bubble(_messages[i - 1]);
      },
    );
  }

  Widget _bubble(Map<String, dynamic> m) {
    final mine = m['mine'] == true;
    final maxW = MediaQuery.sizeOf(context).width * 0.8;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW > 560 ? 560 : maxW),
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
                Flexible(
                  child: Text(m['author_name'] as String? ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.crystal)),
                ),
                if (m['author_is_admin'] == true) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                  const Text(' إدارة المسجد', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ],
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
                    m['reply_name'] == null ? 'رسالة اتشالت' : '${m['reply_name']}: ${m['reply_body'] ?? ''}',
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

  Widget _composer(double side) {
    if (_m?['is_member'] != true) {
      // A moderator who isn't a member reads but writes only after joining.
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(side, 6, side, 8),
          child: OutlinedButton.icon(onPressed: _joining ? null : _join, icon: const Icon(Icons.group_add_rounded), label: const Text('انضم للمسجد عشان تكتب')),
        ),
      );
    }
    if (_needsPhone) {
      return SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(side, 10, side, 10),
          decoration: const BoxDecoration(color: AppColors.surfaceAlt, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            const Icon(Icons.verified_user_outlined, color: AppColors.crystal),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('لازم توثّق رقم موبايلك عشان تكتب في الشات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _verifyPhone, child: const Text('وثّق رقمك')),
          ]),
        ),
      );
    }
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
                  child: Text('رد على ${_replyTo!['author_name']}: ${_replyTo!['body']}',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                ),
                IconButton(visualDensity: VisualDensity.compact, onPressed: () => setState(() => _replyTo = null), icon: const Icon(Icons.close_rounded, size: 18)),
              ]),
            ),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 5,
                maxLength: mosqueChatMaxLength,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(hintText: 'اكتب لأهل المسجد…', isDense: true, counterText: ''),
              ),
            ),
            const SizedBox(width: 6),
            _sending
                ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                : IconButton.filled(tooltip: 'إرسال', onPressed: _send, icon: const Icon(Icons.send_rounded)),
          ]),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('خلّي الكلام طيب — ممنوع أرقام الموبايلات واللينكات للحسابات الجديدة. $mosqueChatRetentionNote.',
                style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ),
        ]),
      ),
    );
  }
}

/// Moderators: the mosque's members, who's muted / banned, and lifting it.
class _MembersSheet extends StatefulWidget {
  const _MembersSheet({required this.mosqueId});
  final String mosqueId;

  @override
  State<_MembersSheet> createState() => _MembersSheetState();
}

class _MembersSheetState extends State<_MembersSheet> {
  List<Map<String, dynamic>>? _rows;
  Map<String, String> _nicknames = {};
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await MasjidService.members(widget.mosqueId);
      var ids = <Map<String, dynamic>>[];
      try {
        ids = await MasjidService.chatIdentities(widget.mosqueId);
      } catch (_) {}
      if (mounted) {
        setState(() {
          _rows = rows;
          _nicknames = {for (final r in ids) r['user_id'] as String: r['nickname'] as String? ?? ''};
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  Future<void> _lift(Map<String, dynamic> r) async {
    try {
      await MasjidService.chatLift(widget.mosqueId, r['user_id'] as String);
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(masjidError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text(rows == null ? 'الأعضاء' : 'الأعضاء (${rows.length})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      ),
      if (_error) const Padding(padding: EdgeInsets.all(24), child: Text('تعذر التحميل', textAlign: TextAlign.center)),
      if (rows == null && !_error) const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
      if (rows != null)
        Flexible(
          child: ListView(shrinkWrap: true, children: [
            for (final r in rows)
              ListTile(
                dense: true,
                title: Text('${r['full_name'] ?? 'عضو'}${r['is_admin'] == true ? ' — إدارة' : ''}'),
                subtitle: Text([
                  if ((_nicknames[r['user_id']] ?? '').isNotEmpty) 'في الشات: ${_nicknames[r['user_id']]}',
                  '${r['messages'] ?? 0} رسالة',
                  if (r['sanction'] == 'ban') r['sanction_until'] == null ? 'ممنوع من الكتابة' : 'ممنوع لحد ${roomTime(r['sanction_until'] as String?)}',
                  if (r['sanction'] == 'mute') 'مكتوم لحد ${roomTime(r['sanction_until'] as String?)}',
                ].join(' • ')),
                trailing: r['sanction'] == null ? null : TextButton(onPressed: () => _lift(r), child: const Text('ارفع المنع')),
              ),
          ]),
        ),
    ]);
  }
}

/// «الرسايل بتتمسح تلقائياً بعد 30 يوم» at the top of the chat.
class _RetentionNote extends StatelessWidget {
  const _RetentionNote();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.auto_delete_outlined, size: 14, color: AppColors.inkMuted),
          SizedBox(width: 4),
          Text(mosqueChatRetentionNote, style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        ]),
      );
}
