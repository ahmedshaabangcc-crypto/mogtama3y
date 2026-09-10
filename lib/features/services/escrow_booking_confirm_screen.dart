import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Escrow payment confirmation for a booked service visit — matches
/// design/screens/15_escrow_booking_confirm.png.
class EscrowBookingConfirmScreen extends StatefulWidget {
  const EscrowBookingConfirmScreen({
    super.key,
    this.providerName = 'م/ خالد البحيري',
    this.providerRole = 'فحص شبكات وتأسيس معتمد من اتحاد الملاك',
    this.providerBadge = 'سباكة متخصصة',
    this.rating = '4.9',
    this.reviewsNote = '184 خدمة ناجحة في المعادي',
    this.visitTime = 'اليوم، 05:30 مساءً (خلال ساعتين)',
    this.address = 'برج الياسمين 4B - شقة 4B - الدور 4',
    this.inspectionFee = 80,
  });

  final String providerName, providerRole, providerBadge, rating, reviewsNote, visitTime, address;
  final double inspectionFee;

  @override
  State<EscrowBookingConfirmScreen> createState() => _EscrowBookingConfirmScreenState();
}

class _EscrowBookingConfirmScreenState extends State<EscrowBookingConfirmScreen> {
  int _paymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    final total = widget.inspectionFee;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأكيد الحجز وإتمام الدفع بالضمان')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('دفع مشفّر ومضمون 100%', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shield_rounded, color: AppColors.teal, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('أموالك في أمان تام 100% بنظام الضمان (Escrow)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.5))),
                ]),
                const SizedBox(height: 10),
                const Text(
                  'يتم تجميد مبلغ الحجز في محفظة الضمان المؤقتة للحي، ولن يتم تحويل أي مليم للفني إلا بعد حضوره وإتمام المعاينة وإدخالك لكود التسليم الرقمي برضاك التام.',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.8),
                ),
                const SizedBox(height: 12),
                Row(children: const [
                  Expanded(child: _EscrowStep(icon: Icons.lock_outline_rounded, label: '1. حجز بمحفظة الضمان')),
                  Expanded(child: _EscrowStep(icon: Icons.home_work_outlined, label: '2. زيارة ومعاينة الفني')),
                  Expanded(child: _EscrowStep(icon: Icons.password_rounded, label: '3. الإفراج بكود OTP')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('تفاصيل حجز الخدمة والفني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('معتمد ومفحوص أمنياً', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                          child: Text(widget.providerBadge, style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 4),
                        Text(widget.providerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                          const SizedBox(width: 2),
                          Text('${widget.rating} • ${widget.reviewsNote}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                        ]),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_rounded, color: AppColors.teal, size: 20),
                ]),
                const Divider(height: 24, color: AppColors.border),
                Row(children: [
                  const Icon(Icons.event_available_outlined, size: 16, color: AppColors.inkSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.visitTime, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.inkSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.address, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('جدول الرسوم المجمّدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                _FeeRow(label: 'رسم المعاينة والتشخيص الأولي', value: '${widget.inspectionFee.toStringAsFixed(2)} ج.م'),
                const SizedBox(height: 10),
                const _FeeRow(label: 'حماية الضمان والتأمين التبادلي', value: '0.00 ج.م', strikethrough: '15.00', note: 'مجاناً لسكان الوحدة المعتمدة'),
                const Divider(height: 24, color: AppColors.border),
                _FeeRow(label: 'إجمالي الحجز المطلوب', value: '${total.toStringAsFixed(2)} ج.م', emphasize: true),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('يُحجز في حساب الضمان حتى موافقتك', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('طريقة الدفع لحجز الضمان', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const Text('اختر وسيلتك المفضلة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          _PaymentOption(
            icon: Icons.account_balance_wallet_rounded,
            title: 'محفظة مُجتمعي الرقمية',
            subtitle: 'الرصيد الحالي: 850.00 ج.م (كافٍ للسداد الفوري)',
            badge: 'نقرة واحدة',
            selected: _paymentMethod == 0,
            onTap: () => setState(() => _paymentMethod = 0),
          ),
          const SizedBox(height: 8),
          _PaymentOption(
            icon: Icons.bolt_rounded,
            title: 'إنستاباي InstaPay الفوري',
            subtitle: 'تحويل لحظي بالاسم التعريفي IPA',
            selected: _paymentMethod == 1,
            onTap: () => setState(() => _paymentMethod = 1),
          ),
          const SizedBox(height: 8),
          _PaymentOption(
            icon: Icons.credit_card_rounded,
            title: 'بطاقة بنكية (فيزا / ماستركارد / ميزة)',
            subtitle: 'دفع مصري مباشر 3D Secure',
            selected: _paymentMethod == 2,
            onTap: () => setState(() => _paymentMethod = 2),
          ),
          const SizedBox(height: 8),
          _PaymentOption(
            icon: Icons.phone_android_rounded,
            title: 'محافظ المحمول الإلكترونية',
            subtitle: 'فودافون كاش، أورانج، وي، اتصالات',
            selected: _paymentMethod == 3,
            onTap: () => setState(() => _paymentMethod = 3),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  icon: const Icon(Icons.lock_outline_rounded, size: 17),
                  label: const Text('تأكيد الحجز وحجز مبلغ الضمان في المحفظة المعلقة', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 6),
              const Text('سياسة استرداد فورية بنسبة 100% تلقائياً في حال عدم حضور الفني أو إلغاء الموعد.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowStep extends StatelessWidget {
  const _EscrowStep({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.label, required this.value, this.strikethrough, this.note, this.emphasize = false});
  final String label, value;
  final String? strikethrough, note;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: emphasize ? 13 : 11.5, fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500, color: emphasize ? AppColors.ink : AppColors.inkSecondary)),
              if (note != null) Text(note!, style: const TextStyle(fontSize: 9.5, color: AppColors.teal)),
            ],
          ),
        ),
        if (strikethrough != null) ...[
          Text(strikethrough!, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted, decoration: TextDecoration.lineThrough)),
          const SizedBox(width: 6),
        ],
        Text(value, style: TextStyle(fontSize: emphasize ? 17 : 12.5, fontWeight: FontWeight.w800, color: emphasize ? AppColors.teal : AppColors.ink)),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap, this.badge});
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? AppColors.teal : AppColors.inkMuted, width: 2),
                color: Colors.transparent,
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.teal),
                      ),
                    )
                  : null,
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.inkSecondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                        child: Text(badge!, style: const TextStyle(fontSize: 8.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
