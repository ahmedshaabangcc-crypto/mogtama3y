import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'job_offer_screen.dart';

/// Employer's applicants dashboard for one posting — matches
/// design/screens/35_job_applicants_dashboard.png.
class JobApplicantsDashboardScreen extends StatelessWidget {
  const JobApplicantsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة إدارة طلبات التوظيف')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('إدارة المتقدمين لوظيفة كاشير ومساعد مدير', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.4)),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: const [
              _StatTile(value: '2', label: 'مستبعدون', color: AppColors.inkMuted),
              _StatTile(value: '3', label: 'مؤهل للمقابلة', color: AppColors.teal),
              _StatTile(value: '4', label: 'طلبات جديدة', color: AppColors.categorySos, dot: true),
              _StatTile(value: '14', label: 'المرشحون', color: AppColors.navy),
            ],
          ),
          const SizedBox(height: 16),
          const _FilterChips(),
          const SizedBox(height: 16),
          _ApplicantCard(
            name: 'كريم عبدالله',
            since: 'منذ ساعتين',
            badge: 'طلب جديد • تطابق 95%',
            badgeColor: AppColors.categorySos,
            age: '27 سنة',
            info: 'بكالوريوس تجارة • سنتين خبرة كاشير سوبرماركت',
            distanceBadge: 'جار (400م)',
            cvFile: 'Karim_Abdallah_CV.pdf',
            cvNote: '1.4 ميجابايت • محدث',
            actions: _ApplicantActions.newApplicant,
          ),
          const SizedBox(height: 14),
          _ApplicantCard(
            name: 'مروة عادل',
            since: null,
            badge: 'تمت المقابلة بنجاح',
            badgeColor: AppColors.teal,
            age: '24 سنة',
            info: 'دبلوم تجاري • خبرة سنة كاشير',
            rating: '4.8',
            quote: '"أظهرت التزاماً عالياً ولياقة فائقة في التعامل مع الزبائن وحساب النقدية"',
            actions: _ApplicantActions.qualified,
          ),
          const SizedBox(height: 14),
          _ApplicantCard(
            name: 'حسام خيري',
            since: null,
            badge: 'موعد المقابلة محدد',
            badgeColor: AppColors.gold,
            age: '31 سنة',
            info: '5 سنوات خبرة إدارة مخازن وجرد وكاشير',
            tags: const ['رخصة قيادة', 'جاهز للاستلام الفوري'],
            interviewTime: 'الأربعاء • 05:00',
            actions: _ApplicantActions.scheduled,
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune_rounded, size: 15, color: AppColors.inkMuted),
              label: const Text('تعديل متطلبات الوظيفة أو إيقاف الإعلان مؤقتاً', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, required this.color, this.dot = false});
  final String value, label;
  final Color color;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: color)),
            if (dot) ...[const SizedBox(width: 3), Container(width: 6, height: 6, decoration: BoxDecoration(color: AppColors.categorySos, shape: BoxShape.circle))],
          ]),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8.5, color: AppColors.inkMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل (14)', 'طلبات جديدة (4)', 'مؤهل للمقابلة (3)', 'تم إرسال'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

enum _ApplicantActions { newApplicant, qualified, scheduled }

class _ApplicantCard extends StatelessWidget {
  const _ApplicantCard({
    required this.name,
    required this.since,
    required this.badge,
    required this.badgeColor,
    required this.age,
    required this.info,
    required this.actions,
    this.distanceBadge,
    this.cvFile,
    this.cvNote,
    this.rating,
    this.quote,
    this.tags,
    this.interviewTime,
  });

  final String name, badge, age, info;
  final String? since, distanceBadge, cvFile, cvNote, rating, quote, interviewTime;
  final Color badgeColor;
  final List<String>? tags;
  final _ApplicantActions actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (since != null) Text(since!, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            if (rating != null) ...[
              const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
              const SizedBox(width: 2),
              Text(rating!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ],
            if (interviewTime != null) ...[
              const Icon(Icons.schedule_rounded, size: 12, color: AppColors.inkMuted),
              const SizedBox(width: 4),
              Text(interviewTime!, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
              child: Text(badge, style: TextStyle(fontSize: 9, color: badgeColor, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 24)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('$age • $info', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (distanceBadge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(distanceBadge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
          ]),
          if (tags != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: tags!
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                        child: Text(t, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
          ],
          if (quote != null) ...[
            const SizedBox(height: 8),
            Text(quote!, style: const TextStyle(fontSize: 10.5, color: AppColors.teal, fontStyle: FontStyle.italic, height: 1.6)),
          ],
          if (cvFile != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.picture_as_pdf_rounded, size: 16, color: AppColors.categorySos),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cvFile!, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                      if (cvNote != null) Text(cvNote!, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.visibility_outlined, size: 15, color: AppColors.inkMuted),
              ]),
            ),
          ],
          const SizedBox(height: 10),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (actions) {
      case _ApplicantActions.newApplicant:
        return Column(
          children: [
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobOfferScreen(applicantName: name.split(' ').first))),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.send_rounded, size: 14),
                    label: const Text('إرسال Job Offer', style: TextStyle(fontSize: 10.5)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.event_available_rounded, size: 14),
                    label: const Text('دعوة لمقابلة', style: TextStyle(fontSize: 10.5)),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkMuted, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.block_rounded, size: 13),
                    label: const Text('استبعاد الطلب', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 13),
                    label: const Text('محادثة عبر التطبيق', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ),
            ]),
          ],
        );
      case _ApplicantActions.qualified:
        return SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobOfferScreen(applicantName: name.split(' ').first))),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            icon: const Icon(Icons.workspace_premium_outlined, size: 15),
            label: const Text('إرسال عرض عمل رسمي (Job Offer)', style: TextStyle(fontSize: 11.5)),
          ),
        );
      case _ApplicantActions.scheduled:
        return Row(children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                icon: const Icon(Icons.call_outlined, size: 14),
                label: const Text('اتصال هاتفي', style: TextStyle(fontSize: 11)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                icon: const Icon(Icons.edit_calendar_outlined, size: 14),
                label: const Text('تعديل الموعد', style: TextStyle(fontSize: 11)),
              ),
            ),
          ),
        ]);
    }
  }
}
