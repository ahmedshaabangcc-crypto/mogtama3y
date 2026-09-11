import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Application submitted confirmation — matches
/// design/screens/34_job_application_confirm.png, simplified to what
/// the schema actually tracks (a submitted status) rather than a fake
/// multi-stage hiring pipeline with no backing data.
class JobApplicationConfirmScreen extends StatelessWidget {
  const JobApplicationConfirmScreen({super.key, required this.job});
  final Map<String, dynamic> job;

  @override
  Widget build(BuildContext context) {
    final title = job['title'] as String? ?? '';
    final poster = job['poster'] as Map<String, dynamic>?;
    final posterName = poster?['full_name'] as String? ?? 'صاحب العمل';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأكيد التقديم')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 40),
              ),
              const SizedBox(height: 14),
              const Text('تم إرسال طلب التقديم بنجاح!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.5)),
              const SizedBox(height: 8),
              Text('تم تسليم طلبك لـ "$title" إلى $posterName، وسيتم إشعارك عند مراجعته.',
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                child: const Row(children: [
                  Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.inkSecondary),
                  SizedBox(width: 8),
                  Expanded(child: Text('حالة الطلب: قيد المراجعة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
                ]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
                  label: const Text('العودة للرئيسية', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
