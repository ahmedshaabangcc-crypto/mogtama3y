import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _EmergencyType {
  const _EmergencyType({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
}

const _emergencyTypes = [
  _EmergencyType(icon: Icons.medical_services_rounded, title: 'حالة صحية وإسعافية حرجة', subtitle: 'أزمة قلبية، إغماء، إصابة خطيرة'),
  _EmergencyType(icon: Icons.local_fire_department_rounded, title: 'حريق داخل العقار', subtitle: 'دخان كثيف أو ألسنة لهب'),
  _EmergencyType(icon: Icons.bolt_rounded, title: 'تسريب غاز أو ماس كهربائي', subtitle: 'رائحة غاز نفاذة، شرر أو ماس'),
  _EmergencyType(icon: Icons.shield_moon_rounded, title: 'اشتباه أمني أو اقتحام', subtitle: 'متسلل، سرقة، اعتداء مشبوه'),
];

const _hotlines = [
  (number: '123', label: 'الإسعاف الطبي', icon: Icons.local_hospital_rounded),
  (number: '122', label: 'النجدة (الشرطة)', icon: Icons.local_police_rounded),
  (number: '129', label: 'طوارئ الغاز', icon: Icons.propane_tank_outlined),
  (number: '180', label: 'المطافئ والدفاع المدني', icon: Icons.fire_truck_rounded),
];

/// SOS neighbor emergency alert — matches design/screens/37_sos_emergency.png.
class SosEmergencyScreen extends StatefulWidget {
  const SosEmergencyScreen({super.key});

  @override
  State<SosEmergencyScreen> createState() => _SosEmergencyScreenState();
}

class _SosEmergencyScreenState extends State<SosEmergencyScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _holdController;
  int? _selectedType;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _sent = true);
      }
    });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('نداء الطوارئ وإنذار الجيران السريع')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('نداء عاجل استغاثة للجيران', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 6),
          const Text(
            'إطلاق إنذار فوري ومباشر لكافة جيران المبنى وغرفة الحراسة ورئيس الاتحاد للتدخل والمساندة الفورية.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTapDown: _sent ? null : (_) => _holdController.forward(from: _holdController.value),
              onTapUp: _sent ? null : (_) => _holdController.reverse(),
              onTapCancel: _sent ? null : () => _holdController.reverse(),
              child: AnimatedBuilder(
                animation: _holdController,
                builder: (context, child) {
                  return Container(
                    width: 190,
                    height: 190,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.categorySos.withValues(alpha: 0.08 + 0.05 * _holdController.value),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: _sent ? 1 : _holdController.value,
                            strokeWidth: 5,
                            backgroundColor: AppColors.categorySos.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation(AppColors.categorySos),
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.categorySos),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_sent ? Icons.check_rounded : Icons.warning_amber_rounded, color: Colors.white, size: 34),
                              const SizedBox(height: 4),
                              Text(_sent ? 'تم الإرسال' : 'SOS', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                              if (!_sent) const Text('اضغط باستمرار', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_sent) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [
                Icon(Icons.check_circle_rounded, size: 16, color: AppColors.teal),
                SizedBox(width: 6),
                Expanded(child: Text('تم إرسال نداء الاستغاثة لجيران البرج وغرفة الحراسة الآن.', style: TextStyle(fontSize: 11.5, color: AppColors.teal, fontWeight: FontWeight.w600))),
              ]),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => setState(() {
                  _sent = false;
                  _holdController.value = 0;
                }),
                child: const Text('إلغاء التنبيه', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
              ),
            ),
          ] else
            Column(
              children: const [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.check_circle_outline_rounded, size: 13, color: AppColors.teal),
                  SizedBox(width: 5),
                  Text('اضغط مع الاستمرار لمدة ثانيتين لإطلاق الاستغاثة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
                SizedBox(height: 3),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.inkMuted),
                  SizedBox(width: 5),
                  Text('نظام حماية مدمج لمنع الإنذارات العرضية وغير المقصودة', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ]),
              ],
            ),
          const SizedBox(height: 24),
          Row(children: [
            const Expanded(child: Text('حدد نوع الطارئ (لتوجيه الفريق الأنسب)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('اختياري', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ),
          ]),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _emergencyTypes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.5),
            itemBuilder: (context, i) {
              final t = _emergencyTypes[i];
              final selected = _selectedType == i;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _selectedType = i),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? AppColors.categorySos : AppColors.border, width: selected ? 1.5 : 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(t.icon, color: AppColors.categorySos, size: 20),
                      const Spacer(),
                      Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, height: 1.3)),
                      const SizedBox(height: 2),
                      Text(t.subtitle, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted, height: 1.3)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.campaign_rounded, color: AppColors.categorySos, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تنبيه النطاق السكني الفوري', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      const SizedBox(height: 4),
                      const Text(
                        'سينتم إطلاق تنبيه صوتي مرتفع وإشعار فوري لكافة جيران برج الياسمين وحراس البوابات مع تحديد شقة 4B وموقع البرج لحظياً لسرعة النجدة والدعم.',
                        style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 110,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.map_rounded, size: 28, color: AppColors.inkMuted)),
                Positioned(
                  bottom: 8,
                  right: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(children: const [
                      Icon(Icons.location_on_rounded, size: 13, color: AppColors.categorySos),
                      SizedBox(width: 4),
                      Expanded(child: Text('محدد الموقع: بلوك 12، بوابة 2 الفرعية', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                      Text('نقطة وصول مسجلة', style: TextStyle(fontSize: 8.5, color: AppColors.teal)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('أرقام الطوارئ الوطنية المباشرة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _hotlines.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.2),
            itemBuilder: (context, i) {
              final h = _hotlines[i];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.number, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          Text(h.label, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    Icon(h.icon, color: AppColors.inkSecondary, size: 20),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.gavel_rounded, size: 14, color: AppColors.categorySos),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'تنبيه قانوني: تطبيق عقوبات رادعة وتعليق فوري للحساب في حال استخدام البلاغات الوهمية وفقاً للميثاق السكني المعتمد.',
                  style: TextStyle(fontSize: 9.5, color: AppColors.categorySos, height: 1.6),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
