import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/install_app_banner.dart';
import '../shared/made_by_apex.dart';

/// The merchant app's front page (tajer.mogtama3y.com) — "مشروعك أونلاين":
/// what the merchant gets, three steps, and one button to start.
class MerchantLandingScreen extends StatelessWidget {
  const MerchantLandingScreen({super.key});

  static const _benefits = [
    (Icons.link_rounded, 'لينك وQR باسم محلك', 'تعلّقه على المحل وتبعته لزباينك، يفتح متجرك في ثانية.'),
    (Icons.photo_library_rounded, 'منتجاتك بالصور والأسعار', 'صوّر المنتج من الموبايل وحط سعره، وخبّيه لما يخلص.'),
    (Icons.chat_rounded, 'الطلبات على واتساب', 'الطلب يوصلك إشعار، والزبون يبعتلك تفاصيله على واتساب.'),
    (Icons.location_on_rounded, 'عنوان الزبون للتوصيل', 'اكتب اسم عنوان الزبون الإلكتروني فيفتحلك العنوان بالخريطة.'),
    (Icons.money_off_rounded, 'ببلاش بالكامل', 'من غير عمولة ولا اشتراك، والفلوس بينك وبين زبونك مباشرة.'),
  ];

  void _start(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 600 ? (width - 560) / 2 : 18.0;
    return Scaffold(
      backgroundColor: AppColors.night,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.nightGradient),
        child: SafeArea(
          child: ListView(
            // On a wide screen keep it a centred phone-width column.
            padding: EdgeInsets.fromLTRB(side, 14, side, 32),
            children: [
              const InstallAppBanner(),
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/home/shops.jpg', width: 44, height: 44, fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                const Text('متجري', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(width: 6),
                const Text('من مُجتمعي', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
              ]),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Image.asset('assets/images/home/shops.jpg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text('محلك أونلاين ببلاش 🛍️',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.3)),
              const SizedBox(height: 8),
              const Text('متجر باسم محلك، ومنتجاتك بالصور والأسعار، والطلبات توصلك على واتساب — في دقيقتين ومن غير عمولة.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.7)),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
                  onPressed: () => _start(context),
                  icon: const Icon(Icons.storefront_rounded),
                  label: const Text('سجّل محلك دلوقتي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _start(context),
                child: const Text('عندي حساب — تسجيل الدخول', style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 22),
              for (final (icon, title, body) in _benefits)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(icon, color: AppColors.gold, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14.5)),
                        const SizedBox(height: 2),
                        Text(body, style: const TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.6)),
                      ]),
                    ),
                  ]),
                ),
              const SizedBox(height: 16),
              const Text('إزاي تبدأ؟', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              for (final (n, t) in const [
                ('1', 'اعمل حساب بإيميلك أو بحساب جوجل.'),
                ('2', 'سجّل اسم محلك ونشاطك ورقم الواتساب، وخد اللينك والـ QR.'),
                ('3', 'ضيف منتجاتك وعلّق الـ QR على المحل — وابدأ استقبل طلبات.'),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    CircleAvatar(radius: 14, backgroundColor: AppColors.gold, child: Text(n, style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w800))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.5))),
                  ]),
                ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: AppColors.glassBorder)),
                  onPressed: () => _start(context),
                  child: const Text('ابدأ دلوقتي ببلاش'),
                ),
              ),
              const SizedBox(height: 20),
              const MadeByApex(),
            ],
          ),
        ),
      ),
    );
  }
}
