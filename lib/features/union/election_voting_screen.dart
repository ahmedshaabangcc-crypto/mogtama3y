import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _Candidate {
  const _Candidate({required this.name, required this.info, required this.pitch, required this.votePct, required this.voteCount, required this.tag});
  final String name, info, pitch, tag;
  final double votePct;
  final int voteCount;
}

const _candidates = [
  _Candidate(
    name: 'م. طارق عبد الحميد',
    info: 'شقة 3B • ساكن مقيم منذ 6 سنوات',
    pitch: 'خطة شاملة لصيانة وتحديث مصعد العمارة وتنظيم جدول حراسة البوابة الإلكترونية.',
    votePct: 0.625,
    voteCount: 5,
    tag: 'مرشح مستوفي للشروط',
  ),
  _Candidate(
    name: 'أ. حسام عادل',
    info: 'شقة 5A • مالك وحدة',
    pitch: 'ترشيد مصاريف النظافة وإدخال منظومة الطاقة الشمسية لإنارة السلم والسطح.',
    votePct: 0.375,
    voteCount: 3,
    tag: 'سجل إداري نظيف',
  ),
];

/// Founding election for the union president — matches
/// design/screens/44_union_election_voting.png.
class ElectionVotingScreen extends StatefulWidget {
  const ElectionVotingScreen({super.key, this.buildingName = 'عمارة 14 - شارع دجلة'});
  final String buildingName;

  @override
  State<ElectionVotingScreen> createState() => _ElectionVotingScreenState();
}

class _ElectionVotingScreenState extends State<ElectionVotingScreen> {
  int _votedFor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('انتخاب وتأسيس اتحاد الملاك')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.hourglass_bottom_rounded, size: 12, color: AppColors.gold),
                SizedBox(width: 4),
                Text('باقٍ 48 ساعة', style: TextStyle(fontSize: 10.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
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
                  Expanded(child: Text(widget.buildingName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                ]),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(right: 26),
                  child: Text('عمارة قيد التأسيس الرقمي الرسمي', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ),
                const SizedBox(height: 12),
                Row(children: const [
                  Icon(Icons.how_to_vote_outlined, size: 14, color: AppColors.inkSecondary),
                  SizedBox(width: 6),
                  Text('8 من 12 صوّتوا', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                  Spacer(),
                  Text('نصاب الاقتراع القانوني (65%)', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(value: 0.65, minHeight: 7, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                ),
                const SizedBox(height: 8),
                Row(children: const [
                  Text('الحد الأدنى لاعتماد النتيجة: 7 أصوات', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  Spacer(),
                  Icon(Icons.check_circle_outline_rounded, size: 13, color: AppColors.teal),
                  SizedBox(width: 3),
                  Text('مكتمل النصاب', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('انتخاب رئيس اتحاد الملاك التأسيسي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('مباشر', style: TextStyle(fontSize: 9.5, color: AppColors.categorySos, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          for (var i = 0; i < _candidates.length; i++) ...[
            _CandidateCard(
              candidate: _candidates[i],
              voted: _votedFor == i,
              onVote: () => setState(() => _votedFor = i),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 17),
              label: const Text('ترشيح نفسك لرئاسة الاتحاد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('نقاشات وسوالف الجيران', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('نشط', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ]),
          const Text('11 عضواً متصلاً الآن', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          const _ChatBubble(name: 'د. مي الشاذلي (شقة 2A)', time: 'منذ 25 دقيقة', text: 'مساء الخير جميعاً.. بخصوص مصعد العمارة شندلر أرسلت عرض الصيانة بتكلفة أقل 15% إذا تم التعاقد السنوي فور اكتمال التأسيس.'),
          const SizedBox(height: 8),
          const _ChatBubble(name: 'م. طارق عبد الحميد (مرشح)', time: 'منذ 15 دقيقة', text: 'تمام يا دكتورة، اطلعت على العرض وسنطرحه للتصويت الفعلي في الاجتماع الأول فور ظهور نتيجة الرئاسة يوم الجمعة بإذن الله.'),
          const SizedBox(height: 8),
          const _ChatBubble(name: 'أنت (شقة 402)', time: 'الآن', text: 'أهم نقطة أيضاً تحديد مواعيد ثابتة لتنظيف المداخل وجمع القمامة الصباحية.', isMe: true),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.border)),
            child: Row(children: const [
              Expanded(child: Text('اكتب رسالتك لجيرانك في العمارة...', style: TextStyle(fontSize: 12, color: AppColors.inkMuted))),
              Icon(Icons.send_rounded, size: 18, color: AppColors.teal),
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: const [
                Text('قوة عمارتنا في تكاتفنا', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                SizedBox(height: 4),
                Text('التصويت والتأسيس يتم وفقاً للمادة 74 من قانون البناء الموحد لتنظيم اتحادات الشاغلين.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({required this.candidate, required this.voted, required this.onVote});
  final _Candidate candidate;
  final bool voted;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(candidate.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(candidate.info, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: voted ? AppColors.teal.withValues(alpha: 0.1) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(voted ? 'صوتك الحالي' : 'مرشح', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: voted ? AppColors.teal : AppColors.inkMuted)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(candidate.pitch, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7)),
          const SizedBox(height: 10),
          Row(children: [
            Text('${(candidate.votePct * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const Spacer(),
            const Text('من أصوات السكان', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: candidate.votePct, minHeight: 7, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
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
                          icon: const Icon(Icons.swap_horiz_rounded, size: 15),
                          label: const Text('تغيير صوتي له', style: TextStyle(fontSize: 12)),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.verified_outlined, size: 13, color: AppColors.inkMuted),
              const SizedBox(width: 4),
              Text(candidate.tag, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.name, required this.time, required this.text, this.isMe = false});
  final String name, time, text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.teal.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isMe ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (!isMe) const CircleAvatar(radius: 12, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 13, color: AppColors.inkMuted)),
            if (!isMe) const SizedBox(width: 6),
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5))),
            Text(time, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 11, height: 1.7, color: AppColors.inkSecondary)),
        ],
      ),
    );
  }
}
