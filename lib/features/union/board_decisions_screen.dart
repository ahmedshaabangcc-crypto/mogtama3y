import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/board_decisions_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';

/// Board-of-directors decisions requiring member approval (distinct
/// from the open general-assembly resident votes) — governance layer
/// on top of the union president so no single person decides alone.
/// See backend/migrations/0020_board_decisions.sql.
class BoardDecisionsScreen extends StatefulWidget {
  const BoardDecisionsScreen({super.key});

  @override
  State<BoardDecisionsScreen> createState() => _BoardDecisionsScreenState();
}

class _BoardDecisionsScreenState extends State<BoardDecisionsScreen> {
  bool _loading = true;
  String? _buildingId;
  bool _isBoardMember = false;
  List<Map<String, dynamic>> _boardMembers = [];
  List<Map<String, dynamic>> _decisions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    final role = membership?['role'] as String?;
    final status = membership?['status'] as String?;
    final isBoardMember = status == 'verified' && (role == 'president' || role == 'board_member');

    List<Map<String, dynamic>> members = [];
    List<Map<String, dynamic>> decisions = [];
    if (buildingId != null) {
      final allMembers = await UnionService.fetchVerifiedMembers(buildingId);
      members = allMembers.where((m) => m['role'] == 'president' || m['role'] == 'board_member').toList();
      decisions = await BoardDecisionsService.fetchDecisions(buildingId);
    }

    if (!mounted) return;
    setState(() {
      _buildingId = buildingId;
      _isBoardMember = isBoardMember;
      _boardMembers = members;
      _decisions = decisions;
      _loading = false;
    });
  }

  Future<void> _propose() async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool requiresUnanimous = false;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('اقتراح قرار مجلس جديد'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'عنوان القرار')),
            const SizedBox(height: 10),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'التفاصيل')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: const Text('يتطلب إجماع كل الأعضاء', style: TextStyle(fontSize: 12.5))),
              Switch(
                value: requiresUnanimous,
                onChanged: (v) => setDialogState(() => requiresUnanimous = v),
                activeThumbColor: AppColors.teal,
              ),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('اقتراح')),
          ],
        ),
      ),
    );
    if (result != true || titleCtrl.text.trim().isEmpty) return;
    try {
      await BoardDecisionsService.proposeDecision(
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
        requiresUnanimous: requiresUnanimous,
      );
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر اقتراح القرار، حاول مرة أخرى.')));
    }
  }

  Future<void> _vote(String decisionId, String choice) async {
    try {
      await BoardDecisionsService.castVote(decisionId: decisionId, choice: choice);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تسجيل تصويتك، حاول مرة أخرى.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('قرارات مجلس الإدارة')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('يجب الانضمام لعمارتك أولاً لعرض قرارات المجلس', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }

    final userId = AuthService.currentUser?.id;
    final open = _decisions.where((d) => d['status'] == 'open').toList();
    final closed = _decisions.where((d) => d['status'] != 'open').toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('قرارات مجلس الإدارة'),
        actions: [
          if (_isBoardMember)
            IconButton(onPressed: _propose, icon: const Icon(Icons.add_circle_outline_rounded), tooltip: 'اقتراح قرار جديد'),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
              child: const Row(children: [
                Icon(Icons.gavel_rounded, color: AppColors.teal),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'حوكمة جماعية: القرارات المصيرية والمالية لا يتخذها رئيس الاتحاد بمفرده، بل تحتاج موافقة أغلبية أو إجماع أعضاء المجلس حسب نوع القرار.',
                    style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.7, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('أعضاء المجلس', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (_boardMembers.isEmpty)
              const Text('لا يوجد أعضاء مجلس مسجّلون بعد', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _boardMembers.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final m = _boardMembers[i];
                    final profile = m['profile'] as Map<String, dynamic>?;
                    return Container(
                      width: 130,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
                          const SizedBox(height: 6),
                          Text(profile?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(m['role'] == 'president' ? 'رئيس الاتحاد' : 'عضو مجلس', style: const TextStyle(fontSize: 8.5, color: AppColors.inkMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 22),
            Row(children: [
              const Expanded(child: Text('القرارات الجارية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                child: Text('${open.length} قرار مفتوح', style: const TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 10),
            if (open.isEmpty)
              const Text('لا توجد قرارات مفتوحة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final d in open) ...[
                _DecisionCard(decision: d, myUserId: userId, isBoardMember: _isBoardMember, onVote: _vote),
                const SizedBox(height: 14),
              ],
            const SizedBox(height: 8),
            const Text('قرارات مغلقة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (closed.isEmpty)
              const Text('لا توجد قرارات مغلقة بعد', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final d in closed) ...[
                _DecisionCard(decision: d, myUserId: userId, isBoardMember: _isBoardMember, onVote: _vote),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({required this.decision, required this.myUserId, required this.isBoardMember, required this.onVote});
  final Map<String, dynamic> decision;
  final String? myUserId;
  final bool isBoardMember;
  final void Function(String decisionId, String choice) onVote;

  @override
  Widget build(BuildContext context) {
    final status = decision['status'] as String;
    final isOpen = status == 'open';
    final requiresUnanimous = decision['requires_unanimous'] == true;
    final eligible = decision['eligible_voters'] as int? ?? 0;
    final votes = List<Map<String, dynamic>>.from(decision['votes'] as List? ?? const []);
    final approved = votes.where((v) => v['choice'] == 'approve').length;
    final myVoteMatches = votes.where((v) => v['voter_id'] == myUserId);
    final myVote = myVoteMatches.isEmpty ? null : myVoteMatches.first['choice'] as String?;
    final proposer = decision['proposer'] as Map<String, dynamic>?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOpen ? AppColors.gold : AppColors.border, width: isOpen ? 1.3 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(decision['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: requiresUnanimous ? AppColors.categorySos.withValues(alpha: 0.1) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: Text(requiresUnanimous ? 'يتطلب إجماع' : 'أغلبية بسيطة', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: requiresUnanimous ? AppColors.categorySos : AppColors.inkMuted)),
            ),
          ]),
          if (decision['description'] != null) ...[
            const SizedBox(height: 6),
            Text(decision['description'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7)),
          ],
          const SizedBox(height: 6),
          Text('مقدَّم من: ${proposer?['full_name'] ?? ''}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: votes.map((v) {
              final choice = v['choice'] as String;
              final (icon, color) = choice == 'approve' ? (Icons.check_circle_rounded, AppColors.teal) : (Icons.cancel_rounded, AppColors.categorySos);
              final name = (v['profile'] as Map<String, dynamic>?)?['full_name'] as String? ?? '';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 12, color: color),
                  const SizedBox(width: 4),
                  Text(name.split(' ').take(2).join(' '), style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
                ]),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Icon(
              isOpen ? Icons.hourglass_bottom_rounded : (status == 'approved' ? Icons.check_circle_rounded : Icons.cancel_rounded),
              size: 14,
              color: status == 'rejected' ? AppColors.categorySos : AppColors.teal,
            ),
            const SizedBox(width: 5),
            Text(
              isOpen ? '$approved من $eligible موافقين حتى الآن' : (status == 'approved' ? 'تم اعتماد القرار' : 'تم رفض القرار'),
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: status == 'rejected' ? AppColors.categorySos : AppColors.teal),
            ),
          ]),
          if (isOpen && isBoardMember && myVote == null) ...[
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => onVote(decision['id'] as String, 'reject'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('اعتراض', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => onVote(decision['id'] as String, 'approve'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('موافقة على القرار', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
