import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'job_details_screen.dart';

/// Application submitted + hiring-stages tracker — matches
/// design/screens/34_job_application_confirm.png.
class JobApplicationConfirmScreen extends StatefulWidget {
  const JobApplicationConfirmScreen({super.key, required this.job});
  final JobPosting job;

  @override
  State<JobApplicationConfirmScreen> createState() => _JobApplicationConfirmScreenState();
}

class _JobApplicationConfirmScreenState extends State<JobApplicationConfirmScreen> {
  int _slot = 0;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأكيد التقديم ومتابعة الطلب')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 40),
                ),
                const SizedBox(height: 14),
                const Text('تم إرسال طلب التقديم وسيرتك الذاتية بنجاح!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.5)),
                const SizedBox(height: 8),
                Text('تم تسليم ملفك بنجاح إلى إدارة ${job.company}، وتم إشعار صاحب العمل لحظياً.',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.copy_rounded, size: 12, color: AppColors.inkMuted),
                    SizedBox(width: 6),
                    Text('رقم مرجعي للطلب: #JOB-94820', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('مراحل التوظيف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('المرحلة 2 من 4', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 12),
          const _StageTimeline(),
          const SizedBox(height: 20),
          const Text('المواعيد المقترحة للمقابلة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const Text('حدد صاحب العمل أوقاتاً أولية لتيسير التنسيق', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          _SlotTile(day: 'غدًا الثلاثاء', time: '05:00 - 04:00 مساءً', badge: 'منح ومفضل', selected: _slot == 0, onTap: () => setState(() => _slot = 0)),
          const SizedBox(height: 8),
          _SlotTile(day: 'الأربعاء', time: '07:00 - 06:00 مساءً', badge: 'متاح', selected: _slot == 1, onTap: () => setState(() => _slot = 1)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.videocam_outlined, size: 16, color: AppColors.inkSecondary),
              const SizedBox(width: 8),
              const Expanded(child: Text('طبيعة ومكان المقابلة المتاحة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: const Text('مباشرة بمقر النشاط', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront_rounded, color: AppColors.inkSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.company, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text(job.workLocation, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Text('نشط بالحي', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.gold),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'نصائح مُجتمعي للتوظيف الناجح: يرجى تجهيز أصل بطاقة الرقم القومي والمستندات الداعمة قبل موعد المقابلة، والحضور في الموعد بدقة يعزز موثوقيتك ضمن منظومة الحي.',
                  style: TextStyle(fontSize: 10, color: AppColors.gold, height: 1.7),
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.arrow_back_rounded, size: 17),
                  label: const Text('متابعة الطلبات وتصفح وظائف أخرى', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageTimeline extends StatelessWidget {
  const _StageTimeline();

  static const _stages = [
    (title: 'استلام الطلب وتدقيق السيرة الذاتية', note: 'اليوم، الساعة 11:30 صباحاً عبر البوابة المركزية', status: 'مكتمل'),
    (title: 'مراجعة صاحب العمل للملفات والمؤهلات', note: 'متوسط زمن الاستجابة: خلال 24 - 48 ساعة', status: 'قيد الإجراء'),
    (title: 'تحديد موعد المقابلة الشخصية (Interview Slot)', note: 'يتم التأكيد فور مراجعة المستندات الأولية', status: 'قادم'),
    (title: 'إصدار قرار التوظيف أو عرض العمل الرسمي', note: 'توقيع العقد المُجتمعي المعتمد عبر التطبيق', status: 'قادم'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _stages.length; i++)
          _StageRow(
            title: _stages[i].title,
            note: _stages[i].note,
            status: _stages[i].status,
            isLast: i == _stages.length - 1,
          ),
      ],
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.title, required this.note, required this.status, required this.isLast});
  final String title, note, status;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = status == 'مكتمل';
    final active = status == 'قيد الإجراء';
    final color = done ? AppColors.teal : (active ? AppColors.navy : AppColors.inkMuted);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: done || active ? color : AppColors.surfaceAlt, shape: BoxShape.circle),
              child: Icon(done ? Icons.check_rounded : Icons.circle, size: done ? 13 : 8, color: done || active ? Colors.white : AppColors.inkMuted),
            ),
            if (!isLast) Expanded(child: Container(width: 2, color: AppColors.border)),
          ]),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                      child: Text(status, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(note, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.day, required this.time, required this.badge, required this.selected, required this.onTap});
  final String day, time, badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                Text(time, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
            child: Text(badge, style: const TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}
