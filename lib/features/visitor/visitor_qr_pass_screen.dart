import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Visitor QR access pass — matches design/screens/10_visitor_qr_pass.png.
class VisitorQrPassScreen extends StatefulWidget {
  const VisitorQrPassScreen({super.key});

  @override
  State<VisitorQrPassScreen> createState() => _VisitorQrPassScreenState();
}

class _VisitorQrPassScreenState extends State<VisitorQrPassScreen> {
  int _visitType = 2;
  int _duration = 1;
  Duration _remaining = const Duration(hours: 3, minutes: 45, seconds: 8);
  Timer? _timer;

  static const _visitTypes = ['ضيف عائلي', 'مندوب شحن', 'دليفري طلبات', 'في صيانة'];
  static const _durations = ['ساعتان', '4 ساعات', 'اليوم بالكامل'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) return;
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تصريح دخول زائر موقوت (QR Pass)')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('سجل تصاريح الزوار (14 سابقاً)', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline_rounded, size: 15),
              label: const Text('إصدار جديد', style: TextStyle(fontSize: 11.5)),
            ),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Row(children: [
                  const Icon(Icons.circle, size: 7, color: AppColors.teal),
                  const SizedBox(width: 6),
                  const Text('تصريح نشط ومعتمد للدخول الفوري', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.teal)),
                  const Spacer(),
                  const Text('PASS-8924#', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.apartment_rounded, color: AppColors.inkSecondary),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('برج الياسمين - شقة 4B', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('الدور الرابع، المعادي - العقار الرئيسي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 170, color: Colors.white),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.timer_outlined, size: 13, color: AppColors.teal),
                    const SizedBox(width: 6),
                    Text('صالح لمدة: $_formatted', style: const TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ]),
                ),
                const SizedBox(height: 4),
                const Text('مربوط ببوابة برج الياسمين - المعادي لمرة دخول واحدة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const CircleAvatar(radius: 16, backgroundColor: AppColors.surface, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('اسم الزائر والجهة', style: TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                          Text('م/ حسام علام (مهندس ديكور)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                          Text('الغرض: معاينة وتشطيبات شقة 4B', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('مشاركة كود التصريح عبر واتساب', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _remaining = Duration.zero),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.cancel_outlined, size: 15),
                    label: const Text('إلغاء التصريح الحالي', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('إصدار تصريح زائر جديد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          const Text('اسم الزائر أو شركة الشحن / التوصيل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: const Row(children: [
              Icon(Icons.person_outline_rounded, size: 16, color: AppColors.inkMuted),
              SizedBox(width: 8),
              Text('م/ حسام علام (مهندس ديكور)', style: TextStyle(fontSize: 12.5)),
            ]),
          ),
          const SizedBox(height: 14),
          const Text('نوع الزيارة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _visitTypes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.6),
            itemBuilder: (context, i) {
              final selected = _visitType == i;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _visitType = i),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.navy : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? AppColors.navy : AppColors.border),
                  ),
                  child: Text(_visitTypes[i], style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const Text('مدة الصلاحية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < _durations.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _duration = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _duration == i ? AppColors.navy : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _duration == i ? AppColors.navy : AppColors.border),
                      ),
                      child: Text(_durations[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _duration == i ? Colors.white : AppColors.inkSecondary)),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _remaining = const Duration(hours: 4)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.qr_code_rounded, size: 18),
              label: const Text('إصدار تصريح QR جديد فوري', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.shield_outlined, size: 16, color: AppColors.inkSecondary),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('بروتوكول الأمان الموحّد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('يقوم حارس العقار بمسح هذا الرمز للتحقق من هوية الزائر، وتسجيل وقت الدخول والخروج تلقائياً لحفظ أمن المبنى وخصوصية الجيران.',
                        style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.7)),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
