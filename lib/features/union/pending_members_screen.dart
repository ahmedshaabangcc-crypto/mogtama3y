import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';

/// Lets a union president/board member review pending join requests —
/// backed by review_union_member() in
/// backend/migrations/0004_union_member_review.sql. No design reference
/// screen for this (it didn't exist in the original Stitch set); this is
/// the missing counterpart to UnionRegistrationScreen's real join flow.
class PendingMembersScreen extends StatefulWidget {
  const PendingMembersScreen({super.key});

  @override
  State<PendingMembersScreen> createState() => _PendingMembersScreenState();
}

class _PendingMembersScreenState extends State<PendingMembersScreen> {
  bool _loading = true;
  bool _authorized = false;
  String? _buildingName;
  List<Map<String, dynamic>> _pending = [];
  final Set<String> _busyIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final membership = await UnionService.fetchMyMembership();
    final role = membership?['role'] as String?;
    final buildingId = membership?['building_id'] as String?;
    final isAuthorized = buildingId != null && (role == 'president' || role == 'board_member');
    var pending = <Map<String, dynamic>>[];
    if (isAuthorized) {
      pending = await UnionService.fetchPendingMembers(buildingId);
    }
    if (!mounted) return;
    setState(() {
      _authorized = isAuthorized;
      _buildingName = (membership?['building'] as Map<String, dynamic>?)?['name'] as String?;
      _pending = pending;
      _loading = false;
    });
  }

  Future<void> _review(String memberId, bool approve) async {
    setState(() => _busyIds.add(memberId));
    try {
      await UnionService.reviewMember(memberId: memberId, approve: approve);
      if (!mounted) return;
      setState(() => _pending.removeWhere((m) => m['id'] == memberId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(approve ? 'تم قبول العضو في الاتحاد' : 'تم رفض طلب الانضمام')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تنفيذ الإجراء، حاول مرة أخرى')));
    } finally {
      if (mounted) setState(() => _busyIds.remove(memberId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('طلبات الانضمام المعلّقة')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_authorized
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: AppColors.inkMuted, size: 36),
                        const SizedBox(height: 12),
                        const Text('هذه الصفحة متاحة فقط لرئيس اتحاد الملاك أو أعضاء المجلس',
                            textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      if (_buildingName != null) ...[
                        Text('طلبات الانضمام إلى $_buildingName', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        const Text('راجع بيانات كل طلب قبل الموافقة أو الرفض', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                        const SizedBox(height: 16),
                      ],
                      if (_pending.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: const [
                              Icon(Icons.task_alt_rounded, color: AppColors.teal, size: 36),
                              SizedBox(height: 10),
                              Text('لا توجد طلبات انضمام معلّقة حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                            ],
                          ),
                        )
                      else
                        for (final m in _pending) ...[
                          _PendingCard(
                            member: m,
                            busy: _busyIds.contains(m['id']),
                            onApprove: () => _review(m['id'] as String, true),
                            onReject: () => _review(m['id'] as String, false),
                          ),
                          const SizedBox(height: 12),
                        ],
                    ],
                  ),
                ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.member, required this.busy, required this.onApprove, required this.onReject});
  final Map<String, dynamic> member;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final profile = member['profile'] as Map<String, dynamic>?;
    final unit = member['unit'] as Map<String, dynamic>?;
    final name = profile?['full_name'] as String? ?? 'مستخدم مُجتمعي';
    final phone = profile?['phone'] as String?;
    final unitNumber = unit?['unit_number'] as String?;
    final floorLabel = unit?['floor_label'] as String?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 20, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  if (phone != null) Text(phone, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('بانتظار المراجعة', style: TextStyle(fontSize: 9.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          if (unitNumber != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.door_front_door_outlined, size: 14, color: AppColors.inkMuted),
              const SizedBox(width: 6),
              Text('$unitNumber${floorLabel != null ? ' • $floorLabel' : ''}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
            ]),
          ],
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: busy ? null : onApprove,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('قبول', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: busy ? null : onReject,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('رفض', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
