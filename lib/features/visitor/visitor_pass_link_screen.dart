import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_colors.dart';

/// What a visitor sees when they open the pass link a resident sent them
/// on WhatsApp (ittihad.mogtama3y.com/#/pass/PASS-…): the pass QR, big,
/// to show the building guard. No sign-in and no data lookup — the code
/// in the link is the whole pass; the guard's console checks it.
class VisitorPassLinkScreen extends StatelessWidget {
  const VisitorPassLinkScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(title: const Text('تصريح دخول زائر')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('اعرض الكود ده على حارس العمارة', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('الحارس هيمسحه بالكاميرا أو يكتب الكود اللي تحته', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12.5)),
              const SizedBox(height: 20),
              Container(
                width: 280,
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                child: QrImageView(
                  data: code,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(color: AppColors.navy),
                  dataModuleStyle: const QrDataModuleStyle(color: AppColors.navy),
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.ltr,
                child: SelectableText(code, style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              ),
              const SizedBox(height: 18),
              const Text('التصريح صالح للمدة اللي حددها الساكن ولمرة دخول واحدة.', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 11.5)),
            ],
          ),
        ),
      ),
    );
  }
}
