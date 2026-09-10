import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'escrow_booking_confirm_screen.dart';

class _Technician {
  const _Technician({
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewsNote,
    required this.location,
    required this.availability,
    required this.price,
    required this.priceNote,
    required this.escrowBadge,
    required this.trustNote,
  });
  final String name, role, rating, reviewsNote, location, availability, price, priceNote, escrowBadge, trustNote;
}

const _technicians = [
  _Technician(
    name: 'الأسطى صابر محمود',
    role: 'فني سباكة أول وشبكات مياه',
    rating: '4.9',
    reviewsNote: '84 تقييم من جيران المعادي ودجلة',
    location: 'في المعادي - دجلة',
    availability: 'متاح للزيارة الآن • منح خلال 20 د',
    price: '75.00 ج.م',
    priceNote: 'سعر المعاينة والفحص (مشمولة بالضمان)',
    escrowBadge: '(Escrow) مشمول بضمان مُجتمعي المالي',
    trustNote: 'هوية وفيش وتشبيه مدقق',
  ),
  _Technician(
    name: 'م/ إبراهيم توفيق',
    role: 'هندسة كهرباء وتيار خفيف وكاميرات',
    rating: '4.8',
    reviewsNote: '62 تقييم',
    location: 'متواجد في برج البرجس المجاورة',
    availability: 'متاح اليوم',
    price: '100.00 ج.م',
    priceNote: 'سعر اليوم (مشمولة بالضمان)',
    escrowBadge: 'مستند مجتمعي 30 يوماً',
    trustNote: 'معتمد من 5 اتحادات ملاك',
  ),
  _Technician(
    name: 'مركز الأهرام (م. مصطفى فؤاد)',
    role: 'صيانة تبريد وتكييف وشحن فريون',
    rating: '4.9',
    reviewsNote: '110 تقييمات',
    location: 'على بعد 500م - دجلة المعادي',
    availability: 'متاح اليوم',
    price: '80.00 ج.م',
    priceNote: 'منح اليوم (مشمولة بالضمان)',
    escrowBadge: 'Escrow ضمان',
    trustNote: 'صيانة فورية ومعدات أصلية',
  ),
];

/// Verified technicians & services market — matches
/// design/screens/13_technicians_market.png.
class TechniciansMarketScreen extends StatelessWidget {
  const TechniciansMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سوق الفنيين والخدمات المعتمدة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('Escrow ضمان مالي', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 4),
          const Text('صيانة منزلية موثقة بضمان مالي (Escrow) وتقييمات حقيقية من الجيران.',
              style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
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
                    Text('ابحث عن فني، تخصص، سباك، أو كهربائي...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.shield_rounded, color: AppColors.teal, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('كيف يحميك ضمان مُجتمعي المالي (Escrow)؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      const Text(
                        'أتعاب الفني تظل معلقة بأمان في حساب الضمان، ولا تُصرف له إلا بعد فحصك التام للعمل وإعطائه «كود التسليم الرقمي (OTP)».',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _FilterChips(),
          const SizedBox(height: 16),
          for (final t in _technicians) ...[
            _TechnicianCard(technician: t),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: const [
                Text('ميثاق الجودة والأمان السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                SizedBox(height: 6),
                Text(
                  'جميع الفنيين مسجلون ببطاقات الرقم القومي وخاضعين للفحص الجنائي وتقييمات موثقة من جيرانك فقط. لا قلق بعد اليوم داخل مجتمعك السكني.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'تكييف وإنارة', 'سباكة وتأسيس', 'كهرباء وإنارة', 'الأقرب لموقعك', 'متاح فوراً للطوارئ', 'الأعلى تقييماً من الجيران'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11.5, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard({required this.technician});
  final _Technician technician;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(technician.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, size: 14, color: AppColors.teal),
                    ]),
                    Text(technician.role, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                    Row(children: [
                      const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                      const SizedBox(width: 2),
                      Expanded(child: Text('${technician.rating} (${technician.reviewsNote})', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
            const SizedBox(width: 3),
            Expanded(child: Text(technician.location, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: Text(technician.availability, style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(technician.price, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      Text(technician.priceNote, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(technician.escrowBadge, textAlign: TextAlign.left, style: const TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.badge_outlined, size: 12, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            Text(technician.trustNote, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EscrowBookingConfirmScreen(
                        providerName: technician.name,
                        providerRole: technician.role,
                        providerBadge: technician.role.length > 20 ? technician.role.substring(0, 20) : technician.role,
                        rating: technician.rating,
                        reviewsNote: technician.reviewsNote,
                        inspectionFee: double.tryParse(technician.price.replaceAll(RegExp('[^0-9.]'), '')) ?? 80,
                      ),
                    )),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.calendar_month_outlined, size: 15),
                    label: const Text('طلب زيارة صيانة', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                    label: const Text('محادثة فورية', style: TextStyle(fontSize: 11.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
