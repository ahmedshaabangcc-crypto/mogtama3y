import 'package:flutter/material.dart';

import '../../core/jobs/jobs_service.dart';
import '../../core/theme/app_colors.dart';

const _statusLabels = {
  'submitted': 'طلب جديد',
  'shortlisted': 'مرشّح',
  'interview': 'مقابلة',
  'offered': 'عرض عمل',
  'rejected': 'مرفوض',
  'hired': 'مقبول',
};

const _statusColors = {
  'submitted': AppColors.categorySos,
  'shortlisted': AppColors.gold,
  'interview': AppColors.categoryUnion,
  'offered': AppColors.teal,
  'rejected': AppColors.inkMuted,
  'hired': AppColors.teal,
};

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

/// Employer's real applicants dashboard for one posting — was a fully
/// mocked ATS screen (fabricated names, fake CVs, fake ratings, fake
/// interview times) unreachable from anywhere real. Now shows the
/// actual job_applications rows and moves them through the real
/// application_status pipeline — see
/// backend/migrations/0036_job_applications_review.sql.
class JobApplicantsDashboardScreen extends StatefulWidget {
  const JobApplicantsDashboardScreen({super.key, required this.jobId, required this.jobTitle});
  final String jobId, jobTitle;

  @override
  State<JobApplicantsDashboardScreen> createState() => _JobApplicantsDashboardScreenState();
}

class _JobApplicantsDashboardScreenState extends State<JobApplicantsDashboardScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _applicants = [];
  bool _busyId = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await JobsService.fetchApplicants(widget.jobId);
    if (!mounted) return;
    setState(() {
      _applicants = rows;
      _loading = false;
    });
  }

  Future<void> _review(String applicationId, String status) async {
    setState(() => _busyId = true);
    try {
      await JobsService.reviewApplication(applicationId: applicationId, status: status);
      await _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تحديث حالة الطلب')));
    } finally {
      if (mounted) setState(() => _busyId = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إدارة طلبات التوظيف')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  Text(widget.jobTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.4)),
                  const SizedBox(height: 4),
                  Text('${_applicants.length} طلب توظيف', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                  const SizedBox(height: 16),
                  if (_applicants.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('لا توجد طلبات توظيف بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))),
                    )
                  else
                    for (final a in _applicants) ...[
                      _ApplicantCard(applicant: a, busy: _busyId, onReview: (status) => _review(a['id'] as String, status)),
                      const SizedBox(height: 14),
                    ],
                ],
              ),
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  const _ApplicantCard({required this.applicant, required this.busy, required this.onReview});
  final Map<String, dynamic> applicant;
  final bool busy;
  final void Function(String status) onReview;

  @override
  Widget build(BuildContext context) {
    final profile = applicant['applicant'] as Map<String, dynamic>?;
    final name = profile?['full_name'] as String? ?? 'مستخدم مُجتمعي';
    final verified = profile?['is_verified'] as bool? ?? false;
    final status = applicant['status'] as String? ?? 'submitted';
    final introMessage = applicant['intro_message'] as String?;
    final createdAt = DateTime.tryParse(applicant['created_at'] as String? ?? '') ?? DateTime.now();
    final isFinal = status == 'rejected' || status == 'hired';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    if (verified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, color: AppColors.teal, size: 13)],
                  ]),
                  Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: (_statusColors[status] ?? AppColors.inkMuted).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
              child: Text(_statusLabels[status] ?? status, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: _statusColors[status] ?? AppColors.inkMuted)),
            ),
          ]),
          if (introMessage != null && introMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(introMessage, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.7)),
          ],
          if (!isFinal) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (status == 'submitted')
                  _ActionChip(label: 'ترشيح', icon: Icons.thumb_up_alt_outlined, onTap: busy ? null : () => onReview('shortlisted')),
                if (status == 'submitted' || status == 'shortlisted')
                  _ActionChip(label: 'دعوة لمقابلة', icon: Icons.event_available_outlined, onTap: busy ? null : () => onReview('interview')),
                if (status == 'interview')
                  _ActionChip(label: 'عرض عمل', icon: Icons.workspace_premium_outlined, onTap: busy ? null : () => onReview('offered')),
                if (status == 'offered')
                  _ActionChip(label: 'تأكيد القبول', icon: Icons.check_circle_outline_rounded, onTap: busy ? null : () => onReview('hired')),
                _ActionChip(label: 'رفض', icon: Icons.block_rounded, color: AppColors.categorySos, onTap: busy ? null : () => onReview('rejected')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon, required this.onTap, this.color = AppColors.navy});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color.withValues(alpha: 0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}
