import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Support & help-desk contact screen — matches
/// design/screens/29_support_contact_ticket.png.
class SupportContactScreen extends StatelessWidget {
  const SupportContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تواصل معنا والدعم الفني السكني')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('فريق علاقات السكان جاهز لخدمتك ومعالجة بلاغاتك على مدار 24 ساعة', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Stack(children: [
                const CircleAvatar(radius: 20, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.support_agent_rounded, color: AppColors.inkMuted)),
                Positioned(bottom: 0, left: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.teal, shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)))),
              ]),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ممثلو الدعم بانتظارك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('متوسط وقت الاستجابة الحقيقي: دقيقة و4 ثوانٍ', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('قنوات التواصل السريع', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('خدمة فورية', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          _ChannelCard(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: AppColors.navy,
            title: 'محادثة فورية مباشرة',
            subtitle: 'فريق علاقات السكان والدعم الفني السكني',
            badge: 'متواجدون 24/7',
            ctaLabel: 'بدء المحادثة الفورية',
            ctaColor: AppColors.navy,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _ChannelCard(
            icon: Icons.chat_rounded,
            iconColor: AppColors.teal,
            title: 'خدمة واتساب مُجتمعي الرسمية المعتمدة',
            subtitle: '+20 100 000 0000',
            badge: 'موثّق',
            ctaLabel: 'محادثة واتساب الرسمي',
            ctaColor: AppColors.teal,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _ChannelCard(
            icon: Icons.phone_in_talk_rounded,
            iconColor: AppColors.categorySos,
            title: 'الخط الساخن المباشر',
            subtitle: 'للشكاوى والنزاعات المستعجلة',
            badge: 'طوارئ',
            ctaLabel: 'خط ساخن مباشر (19999)',
            ctaColor: AppColors.surfaceAlt,
            ctaTextColor: AppColors.ink,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.inkSecondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.mail_outline_rounded, color: AppColors.inkSecondary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('البريد الإلكتروني المخصص', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('لشؤون اتحادات الملاك والتوثيق', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    Text('hoa@mojtamaie.com', style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: const Text('رسمي', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.verified_rounded, color: AppColors.teal, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('التزام جودة مُجتمعي (SLA)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.teal)),
                    SizedBox(height: 3),
                    Text('نضمن لك الرد وحل الشكاوى الفنية في أقل من 24 ساعة مع متابعة دورية حق إغلاق التذكرة.',
                        style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('فتح تذكرة دعم جديدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('طلب رسمي مسجل', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          const _FieldLabel('اسم الساكن'),
          const SizedBox(height: 6),
          const _InputBox(hint: 'الاسم الثلاثي أو صفة المالك'),
          const SizedBox(height: 12),
          const _FieldLabel('رقم الوحدة السكنية'),
          const SizedBox(height: 6),
          const _InputBox(hint: 'مثال: شقة 4B - برج الياسمين'),
          const SizedBox(height: 12),
          const _FieldLabel('تصنيف المشكلة أو البلاغ'),
          const SizedBox(height: 6),
          _DropdownBox(text: 'مشكلة تقنية في التطبيق'),
          const SizedBox(height: 12),
          const _FieldLabel('عنوان الرسالة'),
          const SizedBox(height: 6),
          const _InputBox(hint: 'ملخص المشكلة في عبارة واضحة'),
          const SizedBox(height: 12),
          const _FieldLabel('نص الرسالة أو تفاصيل البلاغ'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Text('اكتب تفاصيل الاستفسار أو البلاغ بدقة لتسريع التحقق والتنفيذ...', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 12),
          const _FieldLabel('المرفقات الإثباتية (صورة أو مستند)'),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)), child: const Icon(Icons.attach_file_rounded, color: AppColors.inkSecondary)),
              const SizedBox(height: 8),
              const Text('إرفاق صورة أو مستند (JPG, PNG, PDF)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const Text('الحد الأقصى للملف: 10 ميجابايت', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.send_rounded, size: 17),
              label: const Text('إرسال الاستفسار / البلاغ المباشر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('أسئلة شائعة قد تفيدك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('مركز المساعدة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          const _FaqTile(question: 'كيف يتم توثيق صفة مالك الشقة؟'),
          const SizedBox(height: 8),
          const _FaqTile(question: 'ما هي آلية تسوية اشتراكات الصيانة المعلقة؟'),
        ],
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.ctaLabel,
    required this.ctaColor,
    required this.onTap,
    this.ctaTextColor = Colors.white,
  });
  final IconData icon;
  final Color iconColor, ctaColor, ctaTextColor;
  final String title, subtitle, badge, ctaLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: Text(badge, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(backgroundColor: ctaColor, foregroundColor: ctaTextColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: Text(ctaLabel, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Text(hint, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  const _DropdownBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5))),
        const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
      ]),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question});
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Expanded(child: Text(question, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
      ]),
    );
  }
}
