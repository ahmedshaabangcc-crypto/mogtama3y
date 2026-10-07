import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/union/fund_service.dart';

/// «انسخ» + «شارك على واتساب» for an invite code (building BLD- or
/// tenant TEN-). [message] is the ready Arabic text that goes to WhatsApp.
class InviteCodeShareButtons extends StatelessWidget {
  const InviteCodeShareButtons({super.key, required this.code, required this.message, this.dark = false});
  final String code;
  final String message;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.navy;
    final side = BorderSide(color: dark ? Colors.white38 : AppColors.border);
    return Row(children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: code));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('اتنسخ الكود $code')));
          },
          style: OutlinedButton.styleFrom(foregroundColor: fg, side: side),
          icon: const Icon(Icons.copy_rounded, size: 16),
          label: const Text('انسخ', style: TextStyle(fontSize: 12)),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 2,
        child: ElevatedButton.icon(
          onPressed: () => launchUrl(inviteWhatsAppUri(message), mode: LaunchMode.externalApplication),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
          icon: const Icon(Icons.chat_rounded, size: 16),
          label: const Text('شارك على واتساب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }
}

/// Permanent card on the president/board dashboard with the building's
/// invite code (BLD-…): copy, share on WhatsApp, rotate («غيّر الكود» —
/// the old code stops working at once).
class BuildingInviteCodeCard extends StatefulWidget {
  const BuildingInviteCodeCard({super.key, required this.buildingId, this.buildingName});
  final String buildingId;
  final String? buildingName;

  @override
  State<BuildingInviteCodeCard> createState() => _BuildingInviteCodeCardState();
}

class _BuildingInviteCodeCardState extends State<BuildingInviteCodeCard> {
  String? _code;
  bool _failed = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final code = await FundService.fetchInviteCode(widget.buildingId);
      if (mounted) setState(() => _code = code);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _rotate() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير كود الدعوة؟'),
        content: const Text('الكود القديم هيبطل يشتغل فوراً، وأي حد معاه الكود القديم مش هيقدر ينضم بيه. ابعت الكود الجديد للجيران.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('غيّر الكود')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      final code = await FundService.rotateInviteCode(widget.buildingId);
      if (!mounted) return;
      setState(() => _code = code);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتغيّر الكود — القديم مبقاش شغّال')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذّر تغيير الكود')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const SizedBox.shrink();
    final code = _code;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.vpn_key_rounded, size: 18, color: AppColors.teal),
          const SizedBox(width: 6),
          const Expanded(child: Text('كود دعوة العمارة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
          TextButton.icon(
            onPressed: code == null || _busy ? null : _rotate,
            icon: const Icon(Icons.autorenew_rounded, size: 16),
            label: const Text('غيّر الكود', style: TextStyle(fontSize: 11.5)),
          ),
        ]),
        const SizedBox(height: 4),
        const Text('ابعته في جروب العمارة — كل جار ينضم بيه وانت توافق على طلبه.', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child: code == null
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : SelectableText(code, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2)),
        ),
        if (code != null) ...[
          const SizedBox(height: 10),
          InviteCodeShareButtons(code: code, message: buildingInviteMessage(code, buildingName: widget.buildingName)),
        ],
      ]),
    );
  }
}
