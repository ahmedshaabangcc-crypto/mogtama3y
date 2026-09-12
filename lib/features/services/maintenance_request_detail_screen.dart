import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';

const _statusLabels = {
  'requested': 'بانتظار عرض سعر',
  'quoted': 'تم تحديد السعر',
  'scheduled': 'الزيارة محددة',
  'in_progress': 'العمل جارٍ',
  'completed': 'العمل مكتمل',
  'disputed': 'قيد النزاع',
  'cancelled': 'ملغي',
};

/// Shared detail view for one maintenance_requests row, used by both
/// the resident (my_maintenance_requests_screen.dart) and the
/// technician (technician_jobs_screen.dart) — see
/// backend/migrations/0022_technicians_maintenance.sql. [isTechnician]
/// switches which actions are offered; the underlying RPCs re-check
/// authorization server-side regardless.
class MaintenanceRequestDetailScreen extends StatefulWidget {
  const MaintenanceRequestDetailScreen({super.key, required this.request, required this.isTechnician});
  final Map<String, dynamic> request;
  final bool isTechnician;

  @override
  State<MaintenanceRequestDetailScreen> createState() => _MaintenanceRequestDetailScreenState();
}

class _MaintenanceRequestDetailScreenState extends State<MaintenanceRequestDetailScreen> {
  late Map<String, dynamic> _request;
  bool _loadingMessages = true;
  List<Map<String, dynamic>> _messages = [];
  final _messageCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _request = widget.request;
    _loadMessages();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final rows = await TechnicianService.fetchMessages(_request['id'] as String);
    if (!mounted) return;
    setState(() {
      _messages = rows;
      _loadingMessages = false;
    });
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    _messageCtrl.clear();
    try {
      await TechnicianService.sendMessage(requestId: _request['id'] as String, body: text);
      _loadMessages();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال الرسالة')));
    }
  }

  Future<void> _quote() async {
    final ctrl = TextEditingController(text: (_request['quoted_amount'] as num?)?.toString() ?? '');
    final amountStr = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديد سعر المعاينة'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ بالجنيه')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(ctrl.text.trim()), child: const Text('تأكيد')),
        ],
      ),
    );
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return;
    await _runAction(() => TechnicianService.updateRequestStatus(requestId: _request['id'] as String, status: 'quoted', quotedAmount: amount));
  }

  Future<void> _schedule() async {
    final date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60)));
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    await _runAction(() => TechnicianService.updateRequestStatus(requestId: _request['id'] as String, status: 'scheduled', visitScheduledAt: when));
  }

  Future<void> _startWork() => _runAction(() => TechnicianService.updateRequestStatus(requestId: _request['id'] as String, status: 'in_progress'));

  Future<void> _finishWork() => _runAction(() => TechnicianService.requestEscrowRelease(_request['id'] as String));

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('سيتم رد المبلغ المحجوز بالكامل لمحفظتك فوراً.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تأكيد الإلغاء')),
        ],
      ),
    );
    if (confirmed == true) {
      await _runAction(() => TechnicianService.cancelRequest(_request['id'] as String));
    }
  }

  Future<void> _confirmRelease() async {
    if (_otpCtrl.text.trim().isEmpty) return;
    await _runAction(() => TechnicianService.confirmCompletionAndRelease(requestId: _request['id'] as String, otp: _otpCtrl.text.trim()));
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _request['status'] as String? ?? 'requested';
    final escrowStatus = _request['escrow_status'] as String?;
    final myUserId = AuthService.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(_request['category'] as String? ?? 'طلب صيانة')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                      child: Text(_statusLabels[status] ?? status, style: const TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                    ),
                    if (_request['quoted_amount'] != null) ...[
                      const SizedBox(width: 8),
                      Text('${(_request['quoted_amount'] as num).toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    ],
                  ]),
                  if (_request['description'] != null && (_request['description'] as String).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_request['description'] as String, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                  ],
                  const SizedBox(height: 12),
                  if (widget.isTechnician) ...[
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      if (status == 'requested') OutlinedButton(onPressed: _busy ? null : _quote, child: const Text('تحديد سعر المعاينة')),
                      if (status == 'requested' || status == 'quoted') OutlinedButton(onPressed: _busy ? null : _schedule, child: const Text('تحديد موعد الزيارة')),
                      if (status == 'scheduled') ElevatedButton(onPressed: _busy ? null : _startWork, style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white), child: const Text('بدء العمل')),
                      if (status == 'in_progress') ElevatedButton(onPressed: _busy ? null : _finishWork, style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white), child: const Text('إعلان انتهاء العمل')),
                      if (status == 'completed' && escrowStatus == 'held') const Text('بانتظار كود التأكيد من الساكن', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                    ]),
                  ] else ...[
                    if (status == 'requested' || status == 'quoted') ...[
                      SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _busy ? null : _cancel, style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent), child: const Text('إلغاء الطلب'))),
                    ],
                    if (status == 'completed' && escrowStatus == 'held') ...[
                      const SizedBox(height: 4),
                      const Text('استلمت كود التأكيد كإشعار — أعطه للفني بعد التأكد من جودة العمل فقط', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: TextField(controller: _otpCtrl, decoration: const InputDecoration(hintText: 'كود التأكيد', isDense: true, border: OutlineInputBorder()))),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _busy ? null : _confirmRelease, style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white), child: const Text('تأكيد')),
                      ]),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: _loadingMessages
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      final isMe = m['sender_id'] == myUserId;
                      final senderName = (m['sender'] as Map<String, dynamic>?)?['full_name'] as String? ?? '';
                      return Align(
                        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.teal.withValues(alpha: 0.1) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isMe ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            if (!isMe) Text(senderName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5)),
                            Text(m['body'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                          ]),
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
                    decoration: const InputDecoration(hintText: 'اكتب رسالتك...', isDense: true, filled: true, fillColor: AppColors.surface, border: OutlineInputBorder()),
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
