import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _BoardMember {
  const _BoardMember({required this.name, required this.role, required this.since});
  final String name, role, since;
}

const _members = [
  _BoardMember(name: 'م. حازم عبد الرحمن', role: 'رئيس مجلس الإدارة', since: 'عضو منذ 2023'),
  _BoardMember(name: 'أ. طارق الشربيني', role: 'أمين الصندوق والمالية', since: 'عضو منذ 2023'),
  _BoardMember(name: 'د. مي الشاذلي', role: 'عضو مجلس (شقة 2A)', since: 'عضو منذ 2024'),
  _BoardMember(name: 'م. أحمد عزت', role: 'عضو مجلس (شقة 402)', since: 'عضو منذ 2024'),
];

enum _VoteStatus { approved, rejected, pending }

class _Decision {
  const _Decision({required this.title, required this.description, required this.proposedBy, required this.status, required this.votes, required this.requiresUnanimous});
  final String title, description, proposedBy;
  final bool status; // true = open/active
  final Map<String, _VoteStatus> votes;
  final bool requiresUnanimous;
}

final _decisions = [
  _Decision(
    title: 'التعاقد مع شركة أمن جديدة لحراسة البوابات',
    description: 'استبدال شركة الحراسة الحالية بعد شكاوى متكررة، بعرض سعري 18,000 ج.م شهرياً شامل 3 ورديات.',
    proposedBy: 'م. حازم عبد الرحمن (الرئيس)',
    status: true,
    votes: {'م. حازم عبد الرحمن': _VoteStatus.approved, 'أ. طارق الشربيني': _VoteStatus.approved, 'د. مي الشاذلي': _VoteStatus.pending, 'م. أحمد عزت': _VoteStatus.pending},
    requiresUnanimous: false,
  ),
  _Decision(
    title: 'سحب 35,000 ج.م من صندوق الاحتياطي لكاميرات المراقبة',
    description: 'يتطلب صرف أي مبلغ يتجاوز 20,000 ج.م من صندوق الاحتياطي موافقة أغلبية أعضاء المجلس وفق اللائحة الداخلية.',
    proposedBy: 'أ. طارق الشربيني (أمين الصندوق)',
    status: true,
    votes: {'م. حازم عبد الرحمن': _VoteStatus.approved, 'أ. طارق الشربيني': _VoteStatus.approved, 'د. مي الشاذلي': _VoteStatus.approved, 'م. أحمد عزت': _VoteStatus.rejected},
    requiresUnanimous: false,
  ),
  _Decision(
    title: 'تعيين عم رجب حارساً رسمياً لعمارة 16',
    description: 'تثبيت التعيين ومنحه صلاحيات مسح تصاريح الزوار واستلام الأمانات عبر تطبيق مُجتمعي.',
    proposedBy: 'م. حازم عبد الرحمن (الرئيس)',
    status: false,
    votes: {'م. حازم عبد الرحمن': _VoteStatus.approved, 'أ. طارق الشربيني': _VoteStatus.approved, 'د. مي الشاذلي': _VoteStatus.approved, 'م. أحمد عزت': _VoteStatus.approved},
    requiresUnanimous: true,
  ),
];

/// Board-of-directors decisions requiring member approval (distinct
/// from the open general-assembly resident votes) — governance layer
/// on top of the union president so no single person decides alone.
class BoardDecisionsScreen extends StatelessWidget {
  const BoardDecisionsScreen({super.key, this.currentMember = 'د. مي الشاذلي'});
  final String currentMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('قرارات مجلس الإدارة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.gavel_rounded, color: AppColors.teal),
              const SizedBox(width: 10),
              const Expanded(
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
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _members.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final m = _members[i];
                return Container(
                  width: 130,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
                      const SizedBox(height: 6),
                      Text(m.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(m.role, style: const TextStyle(fontSize: 8.5, color: AppColors.inkMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
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
              child: Text('${_decisions.where((d) => d.status).length} قرار مفتوح', style: const TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          for (final d in _decisions.where((d) => d.status)) ...[
            _DecisionCard(decision: d, currentMember: currentMember),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 8),
          const Text('قرارات مغلقة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          for (final d in _decisions.where((d) => !d.status)) ...[
            _DecisionCard(decision: d, currentMember: currentMember),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({required this.decision, required this.currentMember});
  final _Decision decision;
  final String currentMember;

  @override
  Widget build(BuildContext context) {
    final approved = decision.votes.values.where((v) => v == _VoteStatus.approved).length;
    final total = decision.votes.length;
    final myVote = decision.votes[currentMember] ?? _VoteStatus.pending;
    final passed = decision.requiresUnanimous ? approved == total : approved > total / 2;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: decision.status ? AppColors.gold : AppColors.border, width: decision.status ? 1.3 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(decision.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: decision.requiresUnanimous ? AppColors.categorySos.withValues(alpha: 0.1) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: Text(decision.requiresUnanimous ? 'يتطلب إجماع' : 'أغلبية بسيطة', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: decision.requiresUnanimous ? AppColors.categorySos : AppColors.inkMuted)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(decision.description, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7)),
          const SizedBox(height: 6),
          Text('مقدَّم من: ${decision.proposedBy}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: decision.votes.entries.map((e) {
              final (icon, color) = switch (e.value) {
                _VoteStatus.approved => (Icons.check_circle_rounded, AppColors.teal),
                _VoteStatus.rejected => (Icons.cancel_rounded, AppColors.categorySos),
                _VoteStatus.pending => (Icons.hourglass_top_rounded, AppColors.inkMuted),
              };
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 12, color: color),
                  const SizedBox(width: 4),
                  Text(e.key.split(' ').take(2).join(' '), style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
                ]),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Icon(decision.status ? (passed ? Icons.trending_up_rounded : Icons.hourglass_bottom_rounded) : (passed ? Icons.check_circle_rounded : Icons.cancel_rounded),
                size: 14, color: passed ? AppColors.teal : AppColors.inkMuted),
            const SizedBox(width: 5),
            Text(
              decision.status ? '$approved من $total موافقين حتى الآن' : (passed ? 'تم اعتماد القرار' : 'لم يحقق النصاب المطلوب'),
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: passed ? AppColors.teal : AppColors.inkMuted),
            ),
          ]),
          if (decision.status && myVote == _VoteStatus.pending) ...[
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () {},
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
                    onPressed: () {},
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
