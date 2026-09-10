import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _requiredDocs = [
  'أصل المؤهل الدراسي أو مستخرج رسمي منه',
  'صورة واضحة لبطاقة الرقم القومي (سارية)',
  'صحيفة حالة جنائية حديثة موجهة للجهة (فيش وتشبيه)',
  'شهادة صحية سارية من مكتب الصحة المعتمد',
];

/// Official job offer — matches design/screens/36_job_offer_official.png.
class JobOfferScreen extends StatelessWidget {
  const JobOfferScreen({super.key, this.applicantName = 'كريم'});
  final String applicantName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إشعار قبول وعرض عمل رسمي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: const Text('عرض رسمي معتمد', style: TextStyle(fontSize: 9, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  const Icon(Icons.celebration_rounded, color: AppColors.gold, size: 22),
                ]),
                const SizedBox(height: 10),
                Text('تهانينا يا $applicantName!', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19)),
                const SizedBox(height: 6),
                const Text(
                  'لقد نال ملفك الشخصي إعجاب الإدارة، وتلقيت الآن عرض عمل رسمي للانضمام لفريق العمل.',
                  style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.8),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.storefront_rounded, color: AppColors.navy, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('سوبر ماركت الأمانة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                          Text('فرع دجلة المعادي • عضوية تجارية موثقة', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(children: [Icon(Icons.event_available_outlined, size: 14, color: AppColors.inkMuted), SizedBox(width: 5), Text('تاريخ المباشرة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted))]),
                    SizedBox(height: 6),
                    Text('الأحد 1 مارس', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    Text('الموافق 1 رمضان 1446هـ', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(children: [Icon(Icons.payments_outlined, size: 14, color: AppColors.inkMuted), SizedBox(width: 5), Text('الراتب الشهري', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted))]),
                    SizedBox(height: 6),
                    Text('6,000 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
                    Text('+ حوافز مبيعات ربع سنوية', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            const Icon(Icons.description_outlined, size: 16, color: AppColors.inkSecondary),
            const SizedBox(width: 6),
            const Expanded(child: Text('وثيقة عرض العمل الرسمية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            const Text('رقم العرض: OFF-8429#', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: const [
                _OfferDetailRow(icon: Icons.badge_outlined, label: 'المسمى الوظيفي والدرجة', value: 'كاشير ومسؤول مبيعات الفرع\nقسم المحاسبة وخدمة العملاء الداخلية'),
                Divider(height: 24, color: AppColors.border),
                _OfferDetailRow(icon: Icons.access_time_rounded, label: 'مواعيد وساعات الدوام', value: 'وردية صباحية (09:00 ص - 05:00 م)\n8 ساعات عمل فعلية يخللها ساعة راحة وغداء يومياً'),
                Divider(height: 24, color: AppColors.border),
                _OfferDetailRow(icon: Icons.calendar_month_outlined, label: 'أيام العمل والراحة الأسبوعية', value: '6 أيام عمل أسبوعياً\nيوم الجمعة راحة أسبوعية مدفوعة الأجر'),
                Divider(height: 24, color: AppColors.border),
                _OfferDetailRow(icon: Icons.location_on_outlined, label: 'موقع ومقر العمل', value: 'شارع 206 متفرع من دجلة الرئيسي\nالمعادي، القاهرة، على مسافة 400 متر من سكنك'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: const Center(child: Icon(Icons.map_rounded, size: 28, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 20),
          const Text('المستندات المطلوبة عند استلام العمل', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 6),
          const Text('يرجى إحضار أصول وصور الأوراق التالية معك في اليوم الأول لاستكمال إجراءات التعاقد والتسجيل:', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7)),
          const SizedBox(height: 10),
          for (final doc in _requiredDocs) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.teal),
                const SizedBox(width: 8),
                Expanded(child: Text(doc, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.gavel_rounded, size: 18, color: AppColors.teal),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ميثاق حماية حقوق العمل بمُجتمعي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.teal)),
                      SizedBox(height: 4),
                      Text(
                        'هذا العرض ملزم قانونياً وأخلاقياً للطرفين. يتم أرشفة نسخة رسمية في خزينة المنصة لضمان صرف المستحقات ومساندتها في مواعيدها بيئة عمل عادلة وآمنة.',
                        style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الحاج محمود العمدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  Text('المدير العام ومسؤول التعيينات', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('متواجد بالفرع', style: TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ]),
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
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 17),
                  label: const Text('قبول عرض العمل وتأكيد الموعد الرسمي', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                  label: const Text('محادثة صاحب العمل للاستفسار أو التفاوض', style: TextStyle(fontSize: 11.5)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('الاعتذار عن العرض؟ يُتيح إتاحة الفرصة لمرشح آخر', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferDetailRow extends StatelessWidget {
  const _OfferDetailRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 16, color: AppColors.inkSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.6)),
            ],
          ),
        ),
      ],
    );
  }
}
