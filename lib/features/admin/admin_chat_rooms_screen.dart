import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/rooms/rooms_service.dart';
import '../../core/theme/app_colors.dart';
import '../rooms/room_widgets.dart';
import '../shared/load_error_view.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

String _date(String? iso) {
  final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
  return t == null ? '' : DateFormat('yyyy/MM/dd HH:mm').format(t);
}

/// Super admin: «غرف الدردشة» — add / edit / archive rooms, assign room
/// moderators, see a room's messages with the real account behind each
/// nickname, the banned-words list and the 30-day purge (0078).
class AdminChatRoomsScreen extends StatefulWidget {
  const AdminChatRoomsScreen({super.key});

  @override
  State<AdminChatRoomsScreen> createState() => _AdminChatRoomsScreenState();
}

class _AdminChatRoomsScreenState extends State<AdminChatRoomsScreen> {
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _rooms = [];

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
      final rooms = await RoomsService.adminRooms();
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
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

  Future<void> _edit([Map<String, dynamic>? room]) async {
    final saved = await showDialog<bool>(context: context, builder: (_) => _RoomForm(room: room));
    if (saved == true) _load();
  }

  Future<void> _toggleActive(Map<String, dynamic> r) async {
    try {
      await RoomsService.adminSaveRoom(
        id: r['id'] as String,
        name: r['name'] as String,
        description: r['description'] as String?,
        kind: r['kind'] as String,
        governorate: r['governorate'] as String?,
        area: r['area'] as String?,
        icon: r['icon'] as String?,
        sortOrder: (r['sort_order'] as num?)?.toInt() ?? 100,
        isActive: r['is_active'] != true,
      );
      _load();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _purge() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('امسح الرسايل الأقدم من 30 يوم'),
        content: const Text('هيتمسح كل رسايل الغرف اللي عدّى عليها أكتر من 30 يوم، ومش هترجع.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('امسح')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final n = await RoomsService.purgeOld();
      if (mounted) showRoomSnack(context, 'اتمسح $n رسالة');
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final side = roomSidePadding(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('غرف الدردشة'),
        actions: [
          IconButton(
            tooltip: 'الكلمات الممنوعة',
            onPressed: () => showDialog<void>(context: context, builder: (_) => const _BannedWordsDialog()),
            icon: const Icon(Icons.spellcheck_rounded),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'purge') _purge();
            },
            itemBuilder: (_) => const [PopupMenuItem(value: 'purge', child: Text('امسح الرسايل الأقدم من 30 يوم'))],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('غرفة جديدة'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل الغرف')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(side, 12, side, 96),
                    itemCount: _rooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final r = _rooms[i];
                      final active = r['is_active'] == true;
                      final where = [r['governorate'], r['area']].whereType<String>().join(' · ');
                      return Container(
                        decoration: BoxDecoration(
                          color: active ? AppColors.surface : AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListTile(
                          leading: Text((r['icon'] as String?) ?? '💬', style: const TextStyle(fontSize: 24)),
                          title: Text('${r['name']}${active ? '' : ' (مؤرشفة)'}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            '${r['kind'] == 'area' ? 'منطقة' : 'موضوع'}${where.isEmpty ? '' : ' · $where'} · ترتيب ${r['sort_order']}',
                            style: const TextStyle(fontSize: 11.5),
                          ),
                          onTap: () => _edit(r),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              switch (v) {
                                case 'edit':
                                  _edit(r);
                                case 'mods':
                                  showDialog<void>(context: context, builder: (_) => _ModeratorsDialog(room: r));
                                case 'messages':
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminRoomMessagesScreen(room: r)));
                                case 'active':
                                  _toggleActive(r);
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                              const PopupMenuItem(value: 'mods', child: Text('المشرفين')),
                              const PopupMenuItem(value: 'messages', child: Text('رسايل الغرفة (بالحسابات)')),
                              PopupMenuItem(value: 'active', child: Text(active ? 'أرشفة الغرفة' : 'إعادة تفعيل')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _RoomForm extends StatefulWidget {
  const _RoomForm({this.room});
  final Map<String, dynamic>? room;

  @override
  State<_RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<_RoomForm> {
  late final _name = TextEditingController(text: widget.room?['name'] as String? ?? '');
  late final _desc = TextEditingController(text: widget.room?['description'] as String? ?? '');
  late final _gov = TextEditingController(text: widget.room?['governorate'] as String? ?? '');
  late final _area = TextEditingController(text: widget.room?['area'] as String? ?? '');
  late final _icon = TextEditingController(text: widget.room?['icon'] as String? ?? '');
  late final _sort = TextEditingController(text: '${widget.room?['sort_order'] ?? 100}');
  late String _kind = widget.room?['kind'] as String? ?? 'topic';
  late bool _active = widget.room?['is_active'] as bool? ?? true;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _desc, _gov, _area, _icon, _sort]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().length < 2) {
      showRoomSnack(context, 'اكتب اسم الغرفة');
      return;
    }
    setState(() => _busy = true);
    try {
      String? opt(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
      await RoomsService.adminSaveRoom(
        id: widget.room?['id'] as String?,
        name: _name.text.trim(),
        description: opt(_desc),
        kind: _kind,
        governorate: _kind == 'area' ? opt(_gov) : null,
        area: _kind == 'area' ? opt(_area) : null,
        icon: opt(_icon),
        sortOrder: looseInt(_sort.text.trim()) ?? 100,
        isActive: _active,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showRoomSnack(context, roomError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.room == null ? 'غرفة جديدة' : 'تعديل الغرفة'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _name, maxLength: 40, decoration: const InputDecoration(labelText: 'اسم الغرفة')),
          TextField(controller: _desc, maxLength: 200, decoration: const InputDecoration(labelText: 'وصف قصير')),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'area', label: Text('منطقة')), ButtonSegment(value: 'topic', label: Text('موضوع'))],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          if (_kind == 'area') ...[
            TextField(controller: _gov, decoration: const InputDecoration(labelText: 'المحافظة')),
            TextField(
              controller: _area,
              decoration: const InputDecoration(labelText: 'الحي / المنطقة (فاضي = غرفة المحافظة كلها)'),
            ),
          ],
          Row(children: [
            Expanded(child: TextField(controller: _icon, maxLength: 8, decoration: const InputDecoration(labelText: 'إيموجي'))),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(controller: _sort, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الترتيب')),
            ),
          ]),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _active,
            onChanged: (v) => setState(() => _active = v),
            title: const Text('مفعّلة'),
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
        FilledButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'لحظة…' : 'حفظ')),
      ],
    );
  }
}

class _ModeratorsDialog extends StatefulWidget {
  const _ModeratorsDialog({required this.room});
  final Map<String, dynamic> room;

  @override
  State<_ModeratorsDialog> createState() => _ModeratorsDialogState();
}

class _ModeratorsDialogState extends State<_ModeratorsDialog> {
  final _nick = TextEditingController();
  List<Map<String, dynamic>>? _mods;

  String get _roomId => widget.room['id'] as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nick.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final mods = await RoomsService.adminModerators(_roomId);
      if (mounted) setState(() => _mods = mods);
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _set(String nickname, bool on) async {
    if (nickname.trim().isEmpty) return;
    try {
      await RoomsService.adminSetModerator(_roomId, nickname.trim(), on: on);
      _nick.clear();
      await _load();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mods = _mods;
    return AlertDialog(
      title: Text('مشرفين ${widget.room['name']}'),
      content: SizedBox(
        width: 420,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('المشرف يقدر يخفي رسايل ويكتم الناس في الغرفة دي بس (مش حظر عام).',
              style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          if (mods == null)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())
          else if (mods.isEmpty)
            const Padding(padding: EdgeInsets.all(12), child: Text('مفيش مشرفين', style: TextStyle(color: AppColors.inkMuted)))
          else
            for (final m in mods)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${m['nickname'] ?? '—'}  ←  ${m['full_name'] ?? ''}'),
                subtitle: Text(m['email'] as String? ?? '', style: const TextStyle(fontSize: 11)),
                trailing: IconButton(
                  tooltip: 'شيله',
                  onPressed: m['nickname'] == null ? null : () => _set(m['nickname'] as String, false),
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.red),
                ),
              ),
          Row(children: [
            Expanded(child: TextField(controller: _nick, decoration: const InputDecoration(hintText: 'اسمه في الغرف'))),
            TextButton(onPressed: () => _set(_nick.text, true), child: const Text('إضافة')),
          ]),
        ]),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام'))],
    );
  }
}

class _BannedWordsDialog extends StatefulWidget {
  const _BannedWordsDialog();

  @override
  State<_BannedWordsDialog> createState() => _BannedWordsDialogState();
}

class _BannedWordsDialogState extends State<_BannedWordsDialog> {
  final _word = TextEditingController();
  List<String>? _words;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _word.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final words = await RoomsService.adminBannedWords();
      if (mounted) setState(() => _words = words);
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  Future<void> _set(String word, bool on) async {
    if (word.trim().isEmpty) return;
    try {
      await RoomsService.adminSetBannedWord(word.trim(), on: on);
      _word.clear();
      await _load();
    } catch (e) {
      if (mounted) showRoomSnack(context, roomError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _words;
    return AlertDialog(
      title: const Text('الكلمات الممنوعة في الغرف'),
      content: SizedBox(
        width: 420,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('أي رسالة فيها كلمة من دول بتترفض بلطف. الكلمة بتتقارن كاملة (مش جزء من كلمة).',
              style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          Flexible(
            child: words == null
                ? const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final w in words) InputChip(label: Text(w), onDeleted: () => _set(w, false)),
                    ]),
                  ),
          ),
          Row(children: [
            Expanded(child: TextField(controller: _word, decoration: const InputDecoration(hintText: 'كلمة جديدة'), onSubmitted: (v) => _set(v, true))),
            TextButton(onPressed: () => _set(_word.text, true), child: const Text('إضافة')),
          ]),
        ]),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام'))],
    );
  }
}

/// A room's latest messages with nickname → real name / email (super admin only).
class AdminRoomMessagesScreen extends StatefulWidget {
  const AdminRoomMessagesScreen({super.key, required this.room});
  final Map<String, dynamic> room;

  @override
  State<AdminRoomMessagesScreen> createState() => _AdminRoomMessagesScreenState();
}

class _AdminRoomMessagesScreenState extends State<AdminRoomMessagesScreen> {
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _rows = [];

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
      final rows = await RoomsService.adminMessages(widget.room['id'] as String);
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

  @override
  Widget build(BuildContext context) {
    final side = roomSidePadding(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('رسايل ${widget.room['name']}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل الرسايل')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(side, 12, side, 24),
                    itemCount: _rows.isEmpty ? 1 : _rows.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      if (_rows.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('مفيش رسايل', style: TextStyle(color: AppColors.inkMuted))),
                        );
                      }
                      return AdminRoomMessageCard(message: _rows[i], onChanged: _load);
                    },
                  ),
                ),
    );
  }
}

/// One message as the admin sees it, with the moderation actions
/// (restore, delete, mute, ban). Shared with the reports queue.
class AdminRoomMessageCard extends StatelessWidget {
  const AdminRoomMessageCard({super.key, required this.message, required this.onChanged});

  final Map<String, dynamic> message;
  final VoidCallback onChanged;

  Future<void> _act(BuildContext context, String action) async {
    final id = message['id'] as String;
    try {
      switch (action) {
        case 'hide':
          await RoomsService.hide(id);
        case 'restore':
          await RoomsService.adminRestore(id);
        case 'delete':
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('مسح الرسالة'),
              content: const Text('الرسالة هتتمسح نهائي (بتفضل في سجل الإدارة).'),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
                FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('امسح')),
              ],
            ),
          );
          if (ok != true) return;
          await RoomsService.adminDelete(id);
        default:
          if (action.startsWith('mute:')) await RoomsService.mute(id, int.parse(action.substring(5)));
          if (action == 'ban:perm') await RoomsService.adminBan(id);
          if (action.startsWith('ban:') && action != 'ban:perm') await RoomsService.adminBan(id, hours: int.parse(action.substring(4)));
      }
      if (context.mounted) showRoomSnack(context, 'تم');
      onChanged();
    } catch (e) {
      if (context.mounted) showRoomSnack(context, roomError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = message;
    final hidden = m['is_hidden'] == true;
    final reports = (m['reports_count'] as num?)?.toInt() ?? 0;
    final reasons = (m['reasons'] as List?)?.cast<String>() ?? const [];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hidden ? Colors.red.withValues(alpha: 0.04) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: hidden ? Colors.red.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: RoomNickname(nickname: m['nickname'] as String? ?? '', verified: false, fontSize: 13)),
          if (m['room_name'] != null)
            Text(m['room_name'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          PopupMenuButton<String>(
            onSelected: (v) => _act(context, v),
            itemBuilder: (_) => [
              if (hidden) const PopupMenuItem(value: 'restore', child: Text('رجّع الرسالة')) else const PopupMenuItem(value: 'hide', child: Text('اخفي الرسالة')),
              const PopupMenuItem(value: 'delete', child: Text('امسح الرسالة')),
              const PopupMenuItem(value: 'mute:60', child: Text('كتم ساعة (كل الغرف)')),
              const PopupMenuItem(value: 'mute:1440', child: Text('كتم يوم (كل الغرف)')),
              const PopupMenuItem(value: 'mute:10080', child: Text('كتم أسبوع (كل الغرف)')),
              const PopupMenuItem(value: 'ban:168', child: Text('حظر أسبوع من كل الغرف')),
              const PopupMenuItem(value: 'ban:perm', child: Text('حظر نهائي من كل الغرف')),
            ],
          ),
        ]),
        Text('${m['full_name'] ?? '—'}  ·  ${m['email'] ?? ''}${m['phone'] != null ? '  ·  ${m['phone']}' : ''}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
        const SizedBox(height: 6),
        SelectableText(m['body'] as String? ?? '', style: const TextStyle(fontSize: 13, height: 1.5)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 4, children: [
          Text(_date(m['created_at'] as String?), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          if (hidden)
            Text('مخفية${m['hidden_reason'] == 'auto_reports' ? ' تلقائياً (بلاغات)' : ''}',
                style: const TextStyle(fontSize: 10.5, color: Colors.red, fontWeight: FontWeight.w700)),
          if (reports > 0) Text('$reports بلاغ', style: const TextStyle(fontSize: 10.5, color: Colors.red)),
          if (m['active_sanction'] != null)
            Text('عليه: ${(m['active_sanction'] as String).replaceFirst('mute', 'كتم').replaceFirst('ban', 'حظر')}',
                style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
        ]),
        if (reasons.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('الأسباب: ${reasons.join('، ')}', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          ),
      ]),
    );
  }
}
