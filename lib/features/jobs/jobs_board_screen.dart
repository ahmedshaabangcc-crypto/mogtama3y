import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/jobs/jobs_service.dart';
import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'job_details_screen.dart';
import 'post_job_form_screen.dart';

const _employmentLabels = {
  'full_time': 'دوام كامل',
  'part_time': 'دوام جزئي',
  'freelance': 'عمل حر',
  'shift': 'ورديات مرنة',
};

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

String _salaryLabel(Map<String, dynamic> job) {
  final min = (job['salary_min'] as num?)?.toDouble();
  final max = (job['salary_max'] as num?)?.toDouble();
  final fmt = NumberFormat('#,##0');
  if (min == null && max == null) return 'حسب الاتفاق';
  if (min != null && max != null) return '${fmt.format(min)} - ${fmt.format(max)}';
  return fmt.format(min ?? max);
}

/// Simple jobs board listing nearby postings — matches
/// design/screens/33_job_details.png's entry point, now reading real
/// active job_postings rows.
class JobsBoardScreen extends StatefulWidget {
  const JobsBoardScreen({super.key});

  @override
  State<JobsBoardScreen> createState() => _JobsBoardScreenState();
}

class _JobsBoardScreenState extends State<JobsBoardScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final jobs = await JobsService.fetchActiveJobs();
    if (!mounted) return;
    setState(() {
      _jobs = jobs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('وظائف وشواغر قريبة منك')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
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
            Row(children: [
              const Text('أحدث الشواغر في حيك السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              Text('${_jobs.length} وظيفة نشطة', style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
            ]),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: CircularProgressIndicator()))
            else if (_jobs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(children: const [
                  Icon(Icons.work_off_outlined, color: AppColors.inkMuted, size: 32),
                  SizedBox(height: 10),
                  Text('لا توجد وظائف منشورة بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                ]),
              )
            else
              for (final job in _jobs) ...[
                _JobCard(job: job),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final target = AuthService.isSignedIn ? const PostJobFormScreen() : const AuthLandingScreen();
          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
          _load();
        },
        backgroundColor: AppColors.navy,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('أضف إعلان وظيفة جديد'),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});
  final Map<String, dynamic> job;

  @override
  Widget build(BuildContext context) {
    final title = job['title'] as String? ?? '';
    final category = job['category'] as String?;
    final employmentType = job['employment_type'] as String? ?? 'full_time';
    final createdAt = DateTime.tryParse(job['created_at'] as String? ?? '') ?? DateTime.now();
    final poster = job['poster'] as Map<String, dynamic>?;
    final posterName = poster?['full_name'] as String? ?? 'صاحب العمل';
    final isFeatured = AdTokenService.isCurrentlyFeatured(job);

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
                    Row(children: [
                      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5), maxLines: 2, overflow: TextOverflow.ellipsis)),
                      if (isFeatured) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(100)),
                          child: const Text('مميز', style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ]),
                    Text(category != null ? '$posterName • $category' : posterName, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.access_time_rounded, size: 13, color: AppColors.inkMuted),
              const SizedBox(width: 3),
              Expanded(child: Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Text('${_salaryLabel(job)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(_employmentLabels[employmentType] ?? employmentType, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
