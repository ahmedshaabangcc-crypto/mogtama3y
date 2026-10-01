import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/e_address/e_address_service.dart';
import '../../core/theme/app_colors.dart';

/// The night-glass "address card": label, MG code, QR and the address line.
/// Used on the owner's card screen (with QR) and in their list (compact).
class EAddressCard extends StatelessWidget {
  const EAddressCard({super.key, required this.address, this.showQr = true, this.onTap});
  final Map<String, dynamic> address;
  final bool showQr;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final code = address['code'] as String;
    final active = address['is_active'] as bool? ?? true;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [BoxShadow(color: AppColors.night.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(address['label'] as String? ?? 'عنواني',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  ),
                  if (!active)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(100)),
                      child: const Text('متوقف', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                ]),
                const SizedBox(height: 12),
                if (showQr) ...[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                      child: QrImageView(
                        data: EAddressService.linkFor(code),
                        size: 190,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppColors.night),
                        dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppColors.night),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    EAddressService.display(code),
                    textAlign: showQr ? TextAlign.center : TextAlign.right,
                    style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  EAddressService.oneLine(address),
                  textAlign: showQr ? TextAlign.center : TextAlign.start,
                  maxLines: showQr ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Night banner explaining the idea — top of the owner's list.
class EAddressIntro extends StatelessWidget {
  const EAddressIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: AppColors.nightGradient, borderRadius: BorderRadius.circular(24)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.qr_code_2_rounded, color: AppColors.gold, size: 26),
            SizedBox(width: 8),
            Text('عنوانك الإلكتروني', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
          ]),
          SizedBox(height: 8),
          Text(
            'سجّل عنوانك مرة واحدة بالتفصيل وبالموقع على الخريطة، وخد كود وQR تبعتهم لأي حد: '
            'الدليفري، الضيوف، الفني أو الدكتور. يفتح اللينك ويوصلك على طول من غير ما توصف الطريق.',
            style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.7),
          ),
        ],
      ),
    );
  }
}
