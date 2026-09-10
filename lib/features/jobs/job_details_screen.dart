import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'job_application_confirm_screen.dart';

class JobPosting {
  const JobPosting({
    required this.title,
    required this.company,
    required this.location,
    required this.postedNote,
    required this.applicantsNote,
    required this.salaryRange,
    required this.schedule,
    required this.dayOff,
    required this.experience,
    required this.workLocation,
    required this.distanceNote,
    required this.description,
    required this.duties,
  });

  final String title, company, location, postedNote, applicantsNote, salaryRange, schedule, dayOff, experience, workLocation, distanceNote, description;
  final List<String> duties;
}

const sampleJob = JobPosting(
  title: 'مطلوب كاشير ومساعد مدير فرع',
  company: 'سوبر ماركت الأمانة - دجلة',
  location: 'المعادي - برج الياسمين',
  postedNote: 'نُشر منذ 4 ساعات',
  applicantsNote: '18 متقدماً حق الآن',
  salaryRange: '5,500 - 6,500',
  schedule: 'دوام كامل (8 ساعات)',
  dayOff: 'يوم إجازة أسبوعي',
  experience: 'سنة أو خريج جديد',
  workLocation: 'دجلة - شارع 206',
  distanceNote: 'على بعد 350 متر منك',
  description:
      'تبحث عن عضو نشيط ومحل ثقة للانضمام إلى فريق عمل فرع دجلة المعادي، لتولي عمليات الصندوق وخدمة سكان الحي والإشراف على الجودة العامة خلال الوردية الصباحية.',
  duties: [
    'التعامل السلس مع ماكينات الدفع الإلكتروني (POS)، أنظمة الكاشير المحاسبية وإصدار الفواتير المعتمدة.',
    'استقبال الجيران والزبائن برحابة وحسن خلق، وترتيب المنتجات على الأرفف وفق أفضل معايير العرض.',
    'جرد البضائع اليومي والتبليغ الاستباقي عن النواقص بالتنسيق المباشر مع إدارة المحل ومسؤولي التوريد.',
  ],
);

/// Job details + inline application — matches
/// design/screens/33_job_details.png.
class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key, this.job = sampleJob});
  final JobPosting job;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تفاصيل الوظيفة والتقديم السريع'), actions: const [
        Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.share_outlined)),
        Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.bookmark_border_rounded)),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(job.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.4))),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.storefront_rounded, color: AppColors.inkSecondary),
                  ),
                ]),
                const SizedBox(height: 6),
                Text('${job.company} • ${job.location}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: const Text('نشاط تجاري موثّق بالعمارة 14', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.circle, size: 6, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(job.applicantsNote, style: const TextStyle(fontSize: 9.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time_rounded, size: 12, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text(job.postedNote, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('قابل للتفاوض حسب الخبرة', style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${job.salaryRange} ج.م', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const Text('شهرياً', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: [
              _InfoTile(icon: Icons.event_available_outlined, label: 'نوع الدوام', value: job.schedule),
              _InfoTile(icon: Icons.calendar_month_outlined, label: 'أيام الراحة', value: job.dayOff),
              _InfoTile(icon: Icons.badge_outlined, label: 'متطلبات الخبرة', value: job.experience),
              _InfoTile(icon: Icons.near_me_outlined, label: 'موقع العمل', value: '${job.workLocation}\n${job.distanceNote}'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('الوصف الوظيفي والمهام المطلوبة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Text(job.description, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.9)),
          const SizedBox(height: 10),
          for (final duty in job.duties) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.teal)),
                const SizedBox(width: 8),
                Expanded(child: Text(duty, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.6))),
              ]),
            ),
          ],
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.shield_outlined, size: 16, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'خصوصية وأمان التقديم عبر مُجتمعي: بياناتك وسيرتك الذاتية تُرسل مباشرة لصاحب العمل وتُمسح من منصة مُجتمعي الآمنة. لن يتم مشاركة رقم هاتفك إلا بعد الموافقة المبدئية لحضور المقابلة الشخصية حفاظاً على خصوصيتك.',
                  style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('نموذج التقديم المباشر', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('خطوة واحدة فقط', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          const Text('السيرة الذاتية (CV)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.categorySos, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ahmed_CV_2025.pdf', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('تم الاسترداد من ملف الشخصي (1.2MB)', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('تغيير الملف', style: TextStyle(fontSize: 11))),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('رقم الهاتف للتواصل الرسمي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Row(children: const [
              Icon(Icons.verified_rounded, size: 15, color: AppColors.teal),
              SizedBox(width: 6),
              Text('رقمك الموثّق', style: TextStyle(fontSize: 10.5, color: AppColors.teal)),
              Spacer(),
              Text('0100 123 4567', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('رسالة تعريفية قصيرة لصاحب العمل (اختياري)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Text('اكتب نبذة موجزة (مثلاً: متفرغ تماماً ومستعد لبدء العمل فوراً وسبق لي التعامل مع ماكينات كاشير)...',
                style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.6)),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobApplicationConfirmScreen(job: job))),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.send_rounded, size: 17),
              label: const Text('إرسال طلب التقديم والسيرة الذاتية الآن', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
