import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/election_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';

/// Real president/board succession election — see
/// backend/migrations/0021_elections.sql. Distinct from founding a
/// building (found_building() makes the founder president instantly,
/// no vote) — this is for an existing building replacing its
/// leadership. Finalizing actually hands over the presidency if quorum
/// is met, so this is a real governance action, not a cosmetic result.
class ElectionVotingScreen extends StatefulWidget {
  const ElectionVotingScreen({super.key});

  @override
  State<ElectionVotingScreen> createState() => _ElectionVotingScreenState();
}

class _ElectionVotingScreenState extends State<ElectionVotingScreen> {
  bool _loading = true;
  String? _buildingId;
  bool _isBoardMember = false;
  String? _myUserId;
  Map<String, dynamic>? _election;
  List<Map<String, dynamic>> _candidates = [];
  String? _myVoteCandidateId;

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

    Map<String, dynamic>? election;
    List<Map<String, dynamic>> candidates = [];
    String? myVote;
    if (buildingId != null) {
      election = await ElectionService.fetchLatestElection(buildingId);
      if (election != null) {
        candidates = await ElectionService.fetchCandidates(election['id'] as String);
        myVote = await ElectionService.fetchMyVoteCandidateId(election['id'] as String);
      }
    }

    if (!mounted) return;
    setState(() {
      _buildingId = buildingId;
      _isBoardMember = isBoardMember;
      _myUserId = AuthService.currentUser?.id;
      _election = election;
      _candidates = candidates;
      _myVoteCandidateId = myVote;
      _loading = false;
    });
  }

  Future<void> _createElection() async {
    final titleCtrl = TextEditingController(text: 'انتخاب رئيس اتحاد الملاك');
    final daysCtrl = TextEditingController(text: '3');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بدء انتخابات جديدة'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'عنوان الانتخابات')),
          const SizedBox(height: 10),
          TextField(controller: daysCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'مدة التصويت (بالأيام)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('بدء الانتخابات')),
        ],
      ),
    );
    if (result != true || titleCtrl.text.trim().isEmpty) return;
    final days = int.tryParse(daysCtrl.text.trim()) ?? 3;
    try {
      await ElectionService.createElection(title: titleCtrl.text.trim(), closesAt: DateTime.now().add(Duration(days: days)));
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر بدء الانتخابات، حاول مرة أخرى.')));
    }
  }

  Future<void> _nominate() async {
    final pledgeCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ترشيح نفسك لرئاسة الاتحاد'),
        content: TextField(controller: pledgeCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'برنامجك الانتخابي (اختياري)')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('ترشيح نفسي')),
        ],
      ),
    );
    if (result != true) return;
    try {
      await ElectionService.nominateSelf(electionId: _election!['id'] as String, pledge: pledgeCtrl.text.trim());
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  Future<void> _vote(String candidateId) async {
    try {
      await ElectionService.castVote(electionId: _election!['id'] as String, candidateId: candidateId);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تسجيل صوتك، حاول مرة أخرى.')));
    }
  }

  Future<void> _finalize() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إغلاق التصويت وإعلان النتيجة'),
        content: const Text('هذا الإجراء نهائي: سيتم إعلان الفائز وتسليمه صلاحية رئاسة الاتحاد فوراً إذا تحقق النصاب القانوني. متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تأكيد الإغلاق')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ElectionService.finalizeElection(_election!['id'] as String);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إغلاق الانتخابات، حاول مرة أخرى.')));
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
        appBar: AppBar(title: const Text('انتخابات اتحاد الملاك')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('يجب الانضمام لعمارتك أولاً لعرض الانتخابات', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }
    if (_election == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('انتخابات اتحاد الملاك')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.how_to_vote_outlined, color: AppColors.inkMuted, size: 36),
              const SizedBox(height: 12),
              const Text('لا توجد انتخابات جارية حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
              if (_isBoardMember) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _createElection,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text('بدء انتخابات جديدة'),
                ),
              ],
            ]),
          ),
        ),
      );
    }

    final election = _election!;
    final closesAt = DateTime.tryParse(election['closes_at'] as String? ?? '');
    final isFinalized = election['is_finalized'] == true;
    final isOpen = !isFinalized && closesAt != null && closesAt.isAfter(DateTime.now());
    final eligible = election['eligible_voters'] as int? ?? 0;
    final totalVotes = _candidates.fold<int>(0, (sum, c) => sum + (c['vote_count'] as int? ?? 0));
    final iHaveNominated = _candidates.any((c) => c['user_id'] == _myUserId);
    final quorumPct = (election['legal_quorum_pct'] as num?)?.toDouble() ?? 65.0;
    final turnoutPct = eligible > 0 ? totalVotes / eligible : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('انتخابات اتحاد الملاك')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: (isOpen ? AppColors.gold : AppColors.surfaceAlt).withValues(alpha: isOpen ? 0.15 : 1), borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(isOpen ? Icons.hourglass_bottom_rounded : Icons.check_circle_rounded, size: 12, color: isOpen ? AppColors.gold : AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text(isFinalized ? 'أُغلقت الانتخابات' : (isOpen ? 'التصويت مفتوح' : 'انتهى وقت التصويت'), style: TextStyle(fontSize: 10.5, color: isOpen ? AppColors.gold : AppColors.inkMuted, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(election['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.how_to_vote_outlined, size: 14, color: AppColors.inkSecondary),
                    const SizedBox(width: 6),
                    Text('$totalVotes من $eligible صوّتوا', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('نصاب الاقتراع القانوني (${quorumPct.toStringAsFixed(0)}%)', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(value: turnoutPct.clamp(0, 1), minHeight: 7, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                  ),
                  if (isFinalized) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(turnoutPct * 100 >= quorumPct ? Icons.check_circle_outline_rounded : Icons.cancel_outlined, size: 13, color: turnoutPct * 100 >= quorumPct ? AppColors.teal : AppColors.categorySos),
                      const SizedBox(width: 3),
                      Text(turnoutPct * 100 >= quorumPct ? 'تحقق النصاب واعتُمدت النتيجة' : 'لم يتحقق النصاب القانوني', style: TextStyle(fontSize: 10, color: turnoutPct * 100 >= quorumPct ? AppColors.teal : AppColors.categorySos, fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('المرشحون', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (_candidates.isEmpty)
              const Text('لا يوجد مرشحون بعد', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final c in _candidates) ...[
                _CandidateCard(
                  candidate: c,
                  eligibleVoters: eligible,
                  voted: c['id'] == _myVoteCandidateId,
                  canVote: isOpen,
                  onVote: () => _vote(c['id'] as String),
                ),
                const SizedBox(height: 12),
              ],
            if (isOpen && !iHaveNominated) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _nominate,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 17),
                  label: const Text('ترشيح نفسك لرئاسة الاتحاد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
            if (isOpen && _isBoardMember) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _finalize,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border)),
                  icon: const Icon(Icons.flag_outlined, size: 16),
                  label: const Text('إغلاق التصويت وإعلان النتيجة'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
              child: const Column(
                children: [
                  Text('قوة عمارتنا في تكاتفنا', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('التصويت والتأسيس يتم وفقاً للمادة 74 من قانون البناء الموحد لتنظيم اتحادات الشاغلين.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({required this.candidate, required this.eligibleVoters, required this.voted, required this.canVote, required this.onVote});
  final Map<String, dynamic> candidate;
  final int eligibleVoters;
  final bool voted, canVote;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    final voteCount = candidate['vote_count'] as int? ?? 0;
    final pct = eligibleVoters > 0 ? voteCount / eligibleVoters : 0.0;
    final profile = candidate['profile'] as Map<String, dynamic>?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: voted ? AppColors.teal : AppColors.border, width: voted ? 1.5 : 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(profile?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: voted ? AppColors.teal.withValues(alpha: 0.1) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(voted ? 'صوتك الحالي' : 'مرشح', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: voted ? AppColors.teal : AppColors.inkMuted)),
              ),
            ],
          ),
          if (candidate['pledge'] != null && (candidate['pledge'] as String).isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(candidate['pledge'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7)),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Text('$voteCount صوت', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const Spacer(),
            Text('${(pct * 100).toStringAsFixed(1)}% من أصوات السكان', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: pct.clamp(0, 1), minHeight: 7, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
          ),
          if (canVote) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: voted
                  ? OutlinedButton.icon(
                      onPressed: onVote,
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.teal, side: const BorderSide(color: AppColors.teal), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(Icons.check_rounded, size: 15),
                      label: const Text('تم التصويت', style: TextStyle(fontSize: 12)),
                    )
                  : OutlinedButton.icon(
                      onPressed: onVote,
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(Icons.how_to_vote_outlined, size: 15),
                      label: const Text('التصويت له', style: TextStyle(fontSize: 12)),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
