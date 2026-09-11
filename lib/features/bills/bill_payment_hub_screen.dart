import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'bill_payment_details_screen.dart';

class _Service {
  const _Service({required this.name, required this.icon, required this.color, required this.numberLabel});
  final String name, numberLabel;
  final IconData icon;
  final Color color;
}

const _services = [
  _Service(name: 'الكهرباء', icon: Icons.bolt_rounded, color: Color(0xFFE8912B), numberLabel: 'رقم العداد الكهربائي'),
  _Service(name: 'الغاز الطبيعي', icon: Icons.local_fire_department_rounded, color: Color(0xFFD8433A), numberLabel: 'رقم عداد الغاز'),
  _Service(name: 'المياه والصرف', icon: Icons.water_drop_rounded, color: Color(0xFF1E7FA0), numberLabel: 'رقم عداد المياه'),
  _Service(name: 'فواتير المحمول', icon: Icons.smartphone_rounded, color: Color(0xFF189E6C), numberLabel: 'رقم الهاتف المحمول'),
  _Service(name: 'الإنترنت الأرضي', icon: Icons.wifi_rounded, color: Color(0xFF2E7FD6), numberLabel: 'رقم الخط الأرضي / الاشتراك'),
  _Service(name: 'التليفزيون المشفر', icon: Icons.live_tv_rounded, color: Color(0xFF7A4FC9), numberLabel: 'رقم بطاقة المشاهدة'),
  _Service(name: 'رسوم حكومية', icon: Icons.account_balance_rounded, color: Color(0xFF12233F), numberLabel: 'الرقم القومي / رقم الإيصال'),
  _Service(name: 'مصاريف تعليم', icon: Icons.school_rounded, color: Color(0xFFC99A3D), numberLabel: 'الرقم التعريفي للطالب'),
  _Service(name: 'تبرعات وزكاة', icon: Icons.volunteer_activism_rounded, color: Color(0xFF6D5BD0), numberLabel: 'رمز الجمعية الخيرية'),
];

/// Fawry-style bill/service payment hub. Ahmed plans to contract
/// directly with Fawry for the real integration.
class BillPaymentHubScreen extends StatelessWidget {
  const BillPaymentHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('دفع الفواتير والخدمات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.verified_rounded, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سداد فوري وآمن بالتعاون مع فوري', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('ادفع كل فواتيرك الحكومية والخدمية من مكان واحد دون طوابير.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('اختر نوع الفاتورة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
            itemBuilder: (context, i) {
              final s = _services[i];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BillPaymentDetailsScreen(serviceName: s.name, serviceIcon: s.icon, serviceColor: s.color, numberLabel: s.numberLabel),
                )),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(12)),
                        child: Icon(s.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(s.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('فواتيرك المحفوظة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('2 فاتورة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          _SavedBillTile(
            icon: Icons.bolt_rounded,
            color: const Color(0xFFE8912B),
            title: 'فاتورة كهرباء - عداد شقة 4B',
            subtitle: 'رقم العداد: 445982210',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const BillPaymentDetailsScreen(serviceName: 'الكهرباء', serviceIcon: Icons.bolt_rounded, serviceColor: Color(0xFFE8912B), numberLabel: 'رقم العداد الكهربائي'),
            )),
          ),
          const SizedBox(height: 10),
          _SavedBillTile(
            icon: Icons.smartphone_rounded,
            color: const Color(0xFF189E6C),
            title: 'فاتورة موبايل - فودافون',
            subtitle: 'الرقم: 010XXXXXXXX',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const BillPaymentDetailsScreen(serviceName: 'فواتير المحمول', serviceIcon: Icons.smartphone_rounded, serviceColor: Color(0xFF189E6C), numberLabel: 'رقم الهاتف المحمول'),
            )),
          ),
        ],
      ),
    );
  }
}

class _SavedBillTile extends StatelessWidget {
  const _SavedBillTile({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
        ]),
      ),
    );
  }
}
