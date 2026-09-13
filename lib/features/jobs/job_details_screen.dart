import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/jobs/jobs_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'job_applicants_dashboard_screen.dart';
import 'job_application_confirm_screen.dart';

const _employmentLabels = {
  'full_time': 'دوام كامل (Full-time)',
  'part_time': 'دوام جزئي (Part-time)',
  'freelance': 'عمل حر / بالقطعة',
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
  if (min != null && max != null) return '${fmt.format(min)} - ${fmt.format(max)} ج.م';
  return '${fmt.format(min ?? max)} ج.م';
}

/// Job details + inline application — matches
/// design/screens/33_job_details.png, now backed by a real job_postings row.
class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key, required this.job});
  final Map<String, dynamic> job;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _messageCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (!AuthService.isSignedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await JobsService.apply(jobId: widget.job['id'] as String, introMessage: _messageCtrl.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => JobApplicationConfirmScreen(job: widget.job)));
    } catch (_) {
      setState(() => _error = 'تعذر إرسال الطلب، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final title = job['title'] as String? ?? '';
    final category = job['category'] as String?;
    final requirements = job['requirements'] as String?;
    final employmentType = job['employment_type'] as String? ?? 'full_time';
    final salaryNegotiable = job['salary_negotiable'] as bool? ?? false;
    final createdAt = DateTime.tryParse(job['created_at'] as String? ?? '') ?? DateTime.now();
    final poster = job['poster'] as Map<String, dynamic>?;
    final posterName = poster?['full_name'] as String? ?? 'صاحب العمل';
    final posterVerified = poster?['is_verified'] as bool? ?? false;
    final isOwnJob = job['poster_id'] != null && job['poster_id'] == AuthService.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تفاصيل الوظيفة والتقديم السريع')),
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
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.4))),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.work_rounded, color: AppColors.inkSecondary),
                  ),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(child: Text('$posterName${category != null ? ' • $category' : ''}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted))),
                  if (posterVerified) const Icon(Icons.verified_rounded, size: 14, color: AppColors.teal),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.access_time_rounded, size: 12, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salaryNegotiable ? 'قابل للتفاوض حسب الخبرة' : 'راتب ثابت', style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_salaryLabel(job), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const Text('شهرياً', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.event_available_outlined, size: 16, color: AppColors.teal),
              const SizedBox(width: 8),
              Text(_employmentLabels[employmentType] ?? employmentType, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('الوصف الوظيفي والمتطلبات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Text(
            (requirements == null || requirements.trim().isEmpty) ? 'لم يضف صاحب العمل تفاصيل إضافية.' : requirements,
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.9),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.shield_outlined, size: 16, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'صاحب العمل هيشوف اسمك ورسالتك التعريفية بس، وهتوصلك إشعار حقيقي فور ما يراجع طلبك أو يغيّر حالته.',
                  style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7),
                ),
              ),
            ]),
          ),
          if (!isOwnJob) ...[
            const SizedBox(height: 20),
            const Text('نموذج التقديم المباشر', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            const Text('رسالة تعريفية قصيرة لصاحب العمل (اختياري)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: TextField(
                controller: _messageCtrl,
                maxLines: 3,
                minLines: 2,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'اكتب نبذة موجزة (مثلاً: متفرغ تماماً ومستعد لبدء العمل فوراً)...',
                  hintStyle: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
                ]),
              ),
            ],
          ],
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: isOwnJob
                ? ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => JobApplicantsDashboardScreen(jobId: job['id'] as String, jobTitle: title),
                    )),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    icon: const Icon(Icons.people_outline_rounded, size: 18),
                    label: const Text('عرض طلبات التوظيف', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  )
                : ElevatedButton.icon(
                    onPressed: _submitting ? null : _apply,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    icon: _submitting
                        ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 17),
                    label: const Text('إرسال طلب التقديم الآن', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
          ),
        ),
      ),
    );
  }
}
