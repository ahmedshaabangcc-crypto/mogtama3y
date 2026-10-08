import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/rooms/rooms_service.dart';
import '../../core/theme/app_colors.dart';

/// The backend raises readable Egyptian-Arabic messages
/// ('استنى ثانيتين قبل الرسالة الجاية', …).
String roomError(Object e, [String fallback = 'حصلت مشكلة، جرّب تاني']) => e is PostgrestException ? e.message : fallback;

void showRoomSnack(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

/// Side padding that caps content width on desktop.
double roomSidePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width > 760 ? (width - 720) / 2 : 12.0;
}

String roomTime(String? iso) {
  final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
  if (t == null) return '';
  String two(int n) => n.toString().padLeft(2, '0');
  final now = DateTime.now();
  final hm = '${two(t.hour)}:${two(t.minute)}';
  if (t.year == now.year && t.month == now.month && t.day == now.day) return hm;
  return '${t.day}/${t.month} $hm';
}

/// Nickname + the «موثّق ✓» badge (every writer has a verified phone).
class RoomNickname extends StatelessWidget {
  const RoomNickname({super.key, required this.nickname, this.verified = true, this.color, this.fontSize = 12.5});

  final String nickname;
  final bool verified;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: Text(nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSize, color: color ?? AppColors.crystal)),
      ),
      if (verified) ...[
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Text('موثّق', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.success)),
            SizedBox(width: 2),
            Icon(Icons.check_rounded, size: 11, color: AppColors.success),
          ]),
        ),
      ],
    ]);
  }
}

/// «اختار اسمك في الغرف» — returns the saved nickname, or null.
Future<String?> pickRoomNickname(BuildContext context, {String? current}) =>
    showDialog<String>(context: context, builder: (_) => _NicknameDialog(current: current));

class _NicknameDialog extends StatefulWidget {
  const _NicknameDialog({this.current});
  final String? current;

  @override
  State<_NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<_NicknameDialog> {
  late final _controller = TextEditingController(text: widget.current ?? '');
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nick = _controller.text.trim();
    if (!RegExp(r'^[A-Za-z0-9_\u0621-\u063A\u0641-\u064A\u0660-\u0669]{3,20}$').hasMatch(nick)) {
      setState(() => _error = 'من 3 لـ 20 حرف: حروف عربي أو إنجليزي أو أرقام أو _ (من غير مسافات)');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await RoomsService.setNickname(nick);
      if (mounted) Navigator.of(context).pop(saved);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = roomError(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.current == null ? 'اختار اسمك في الغرف' : 'غيّر اسمك في الغرف'),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ده الاسم اللي الناس هتشوفه في الغرف، واسمك الحقيقي مش هيظهر لحد.',
            style: TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, height: 1.5)),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          autofocus: true,
          maxLength: 20,
          enabled: !_busy,
          onSubmitted: (_) => _save(),
          decoration: InputDecoration(hintText: 'مثلاً: ابن_المعادي', errorText: _error, errorMaxLines: 3),
        ),
        const Text('تقدر تغيّره مرة واحدة كل 7 أيام، فاختار كويس.', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
      ]),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        FilledButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'لحظة…' : 'حفظ')),
      ],
    );
  }
}

/// «بلّغ» — picks a reason. Returns null when cancelled.
Future<String?> pickRoomReportReason(BuildContext context) => showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('بلّغ عن الرسالة دي — إيه المشكلة؟', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          for (final r in const ['شتيمة أو إساءة', 'سبام أو إعلانات', 'تحرش أو مضايقة', 'نصب أو احتيال', 'حاجة تانية'])
            ListTile(title: Text(r), onTap: () => Navigator.of(ctx).pop(r)),
        ]),
      ),
    );
