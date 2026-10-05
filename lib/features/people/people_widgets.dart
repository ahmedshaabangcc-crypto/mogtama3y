import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/people/people_service.dart';
import '../../core/theme/app_colors.dart';

/// The backend raises readable Arabic messages (e.g. 'الشات للأصحاب بس').
String peopleError(Object e, [String fallback = 'حصلت مشكلة، جرّب تاني']) =>
    e is PostgrestException ? e.message : fallback;

void showPeopleSnack(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

/// Side padding that caps content width on desktop.
double peopleSidePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width > 760 ? (width - 720) / 2 : 12.0;
}

/// A person's photo, or the first letter of their name.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.name, this.url, this.radius = 22});

  final String name;
  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = url != null && url!.isNotEmpty;
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.teal.withValues(alpha: 0.1),
      backgroundImage: hasPhoto ? NetworkImage(url!) : null,
      child: hasPhoto ? null : Text(initial, style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800, fontSize: radius * 0.8)),
    );
  }
}

/// Name with a verified tick when the person is verified.
class PersonName extends StatelessWidget {
  const PersonName({super.key, required this.name, this.verified = false, this.fontSize = 13.5});

  final String name;
  final bool verified;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize)),
      ),
      if (verified) ...[
        const SizedBox(width: 4),
        const Icon(Icons.verified_rounded, size: 15, color: AppColors.teal),
      ],
    ]);
  }
}

/// "حظر" — asks first, then blocks. Returns true when blocked.
Future<bool> confirmAndBlock(BuildContext context, String userId, String name) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('حظر'),
      content: Text('متأكد إنك عايز تحظر $name؟ مش هيقدر يشوفك أو يكلمك، وهتختفي الصداقة لو موجودة.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لأ')),
        FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('حظر')),
      ],
    ),
  );
  if (ok != true || !context.mounted) return false;
  try {
    await PeopleService.block(userId);
    if (context.mounted) showPeopleSnack(context, 'تم الحظر');
    return true;
  } catch (e) {
    if (context.mounted) showPeopleSnack(context, peopleError(e));
    return false;
  }
}

/// "إبلاغ" — asks for a reason, then sends the report.
Future<void> reportPerson(BuildContext context, String userId, String name) async {
  final reason = await showDialog<String>(context: context, builder: (_) => _ReportDialog(name: name));
  if (reason == null || !context.mounted) return;
  if (reason.isEmpty) {
    showPeopleSnack(context, 'اكتب سبب البلاغ');
    return;
  }
  try {
    await PeopleService.report(userId, reason);
    if (context.mounted) showPeopleSnack(context, 'وصلنا البلاغ، شكراً ليك');
  } catch (e) {
    if (context.mounted) showPeopleSnack(context, peopleError(e));
  }
}

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.name});
  final String name;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إبلاغ عن ${widget.name}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        maxLength: 500,
        decoration: const InputDecoration(hintText: 'إيه المشكلة؟ (إزعاج، احتيال، حساب مزيف…)'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.of(context).pop(_controller.text.trim()), child: const Text('إبلاغ')),
      ],
    );
  }
}
