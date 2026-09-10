import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'job_details_screen.dart';

const _postings = [
  sampleJob,
  JobPosting(
    title: 'مندوب توصيل داخلي بالحي (موتوسيكل)',
    company: 'صيدلية العزي - فرع دجلة',
    location: 'المعادي - دجلة',
    postedNote: 'نُشر أمس',
    applicantsNote: '9 متقدمين',
    salaryRange: '3,800 - 4,500',
    schedule: 'دوام مرن (6 ساعات)',
    dayOff: 'يومان إجازة أسبوعياً',
    experience: 'يفضل رخصة قيادة سارية',
    workLocation: 'دجلة - شارع الصيدلية',
    distanceNote: 'على بعد 280 متر منك',
    description: 'مطلوب مندوب توصيل نشيط لتوصيل الطلبات الطبية والمنزلية لسكان الحي في نطاق آمن ومحدود بمواعيد ثابتة.',
    duties: [
      'استلام الطلبات من الصيدلية وتسليمها للعناوين المسجلة داخل نطاق الحي.',
      'التأكد من مطابقة الفاتورة والمبلغ المحصل قبل التسليم.',
      'الالتزام بمواعيد التوصيل المتفق عليها مع العملاء.',
    ],
  ),
  JobPosting(
    title: 'مدرس دروس خصوصية ابتدائي وإعدادي',
    company: 'إعلان فردي - ولي أمر بالبرج',
    location: 'برج الياسمين - المعادي',
    postedNote: 'نُشر منذ يومين',
    applicantsNote: '5 متقدمين',
    salaryRange: '2,000 - 3,000',
    schedule: 'جزئي (3 أيام أسبوعياً)',
    dayOff: 'حسب الاتفاق',
    experience: 'خبرة سابقة مفضّلة',
    workLocation: 'داخل برج الياسمين',
    distanceNote: 'لسكان البرج فقط',
    description: 'مطلوب مدرس/ة متمكن لمتابعة طالبين بالمرحلة الابتدائية في مواد اللغة العربية والرياضيات داخل شقة الأسرة.',
    duties: [
      'متابعة الواجبات المدرسية اليومية وتقوية أساسيات المواد.',
      'التواصل الدوري مع ولي الأمر لمتابعة التقدم الدراسي.',
      'الالتزام بمواعيد الحصص المتفق عليها أسبوعياً.',
    ],
  ),
];

/// Simple jobs board listing nearby postings, leading into
/// design/screens/33_job_details.png.
class JobsBoardScreen extends StatelessWidget {
  const JobsBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('وظائف وشواغر قريبة منك')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.tune_rounded, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: const Row(children: [
                  Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
                  SizedBox(width: 8),
                  Text('ابحث عن وظيفة، مهارة، أو نشاط تجاري...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          const Row(children: [
            Text('أحدث الشواغر في حيك السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            Spacer(),
            Text('32 وظيفة قريبة', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
          ]),
          const SizedBox(height: 12),
          for (final job in _postings) ...[
            _JobCard(job: job),
            const SizedBox(height: 14),
          ],
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('أضف إعلان وظيفة جديد'),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});
  final JobPosting job;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: AppColors.categoryJobs.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.work_rounded, color: AppColors.categoryJobs, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(job.company, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
              const SizedBox(width: 3),
              Expanded(child: Text(job.location, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
              Text(job.postedNote, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Text('${job.salaryRange} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(job.schedule, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
