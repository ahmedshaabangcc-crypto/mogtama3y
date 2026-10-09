import 'package:flutter/material.dart';

import '../../core/masjid/masjid_community.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/theme/app_colors.dart';
import 'masjid_widgets.dart';

/// «اسمك في الشات» (migration 0083): the real profile name shows by
/// default; a member may use a per-mosque nickname instead. Once a day.
/// Returns true when the name changed.
Future<bool> editMosqueChatNickname(BuildContext context, String mosqueId) async {
  final messenger = ScaffoldMessenger.of(context);
  Map<String, dynamic> me;
  try {
    me = await MasjidService.chatProfile(mosqueId);
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(masjidError(e, 'تعذر التحميل'))));
    return false;
  }
  if (!context.mounted) return false;
  final changed = await showDialog<bool>(context: context, builder: (_) => _NicknameDialog(mosqueId: mosqueId, me: me));
  return changed == true;
}

class _NicknameDialog extends StatefulWidget {
  const _NicknameDialog({required this.mosqueId, required this.me});
  final String mosqueId;
  final Map<String, dynamic> me;

  @override
  State<_NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<_NicknameDialog> {
  late final _ctrl = TextEditingController(text: widget.me['nickname'] as String? ?? '');
  bool _busy = false;
  String? _error;

  String get _realName => widget.me['real_name'] as String? ?? 'اسمك';
  String? get _current => widget.me['nickname'] as String?;
  DateTime? get _canChangeAt => DateTime.tryParse(widget.me['can_change_at'] as String? ?? '')?.toLocal();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save(String? value) async {
    final nick = value == null ? '' : tidyChatNickname(value);
    final err = mosqueChatNicknameError(nick);
    if (err != null) return setState(() => _error = err);
    if (nick == (_current ?? '')) return Navigator.of(context).pop(false);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await MasjidService.chatSetNickname(widget.mosqueId, nick.isEmpty ? null : nick);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(nick.isEmpty ? 'رجعنا اسمك الحقيقي في الشات' : 'اسمك في الشات بقى «$nick»')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = masjidError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockedUntil = _canChangeAt;
    final locked = lockedUntil != null && lockedUntil.isAfter(DateTime.now());
    return AlertDialog(
      title: const Text('اسمك في شات المسجد'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'بيظهر اسمك الحقيقي «$_realName» لأهل المسجد. لو حابب، اكتب اسم مستعار يظهر بداله في شات المسجد ده بس.',
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            enabled: !_busy && !locked,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: 'اسم مستعار في الشات',
              hintText: 'مثلاً: أم محمد',
              helperText: 'سيبه فاضي عشان يظهر اسمك الحقيقي',
              errorText: _error,
            ),
            onSubmitted: _busy || locked ? null : _save,
          ),
          const SizedBox(height: 4),
          Text(
            locked
                ? 'غيّرت اسمك قريب — تقدر تغيّره تاني بعد ${_hm(lockedUntil)}'
                : 'تقدر تغيّره مرة واحدة في اليوم. إدارة المسجد بتشوف اسمك الحقيقي.',
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
          ),
        ]),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
        if (_current != null && !locked) TextButton(onPressed: _busy ? null : () => _save(null), child: const Text('رجّع اسمي الحقيقي')),
        if (!locked) FilledButton(onPressed: _busy ? null : () => _save(_ctrl.text), child: Text(_busy ? 'لحظة…' : 'حفظ')),
      ],
    );
  }

  static String _hm(DateTime t) {
    final now = DateTime.now();
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final time = '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'ص' : 'م'}';
    return t.day == now.day ? 'الساعة $time' : 'بكرة الساعة $time';
  }
}
