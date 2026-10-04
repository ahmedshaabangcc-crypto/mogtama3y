import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/pwa/install_prompt.dart';
import '../../core/theme/app_colors.dart';

/// "نزّل التطبيق على موبايلك": Android/Chrome gets a one-tap install
/// button; iPhone gets the Share → Add to Home Screen steps. Hidden when
/// already installed or when the browser can't install.
class InstallAppBanner extends StatefulWidget {
  const InstallAppBanner({super.key, this.appName = 'متجري'});
  final String appName;

  @override
  State<InstallAppBanner> createState() => _InstallAppBannerState();
}

class _InstallAppBannerState extends State<InstallAppBanner> {
  bool _dismissed = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // Chrome fires beforeinstallprompt a little after load.
    _poll = Timer.periodic(const Duration(seconds: 1), (t) {
      if (canInstallApp || t.tick > 15) t.cancel();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed || isInstalledApp || !(canInstallApp || isIOSBrowser)) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(children: [
        const Icon(Icons.install_mobile_rounded, color: AppColors.gold),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            isIOSBrowser && !canInstallApp
                ? 'نزّل «${widget.appName}» على موبايلك: دوس زرار المشاركة ⬆️ وبعدين «إضافة إلى الشاشة الرئيسية».'
                : 'نزّل «${widget.appName}» على موبايلك وافتحه بلمسة زي أي تطبيق.',
            style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.5),
          ),
        ),
        if (canInstallApp)
          TextButton(
            style: TextButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
            onPressed: () => setState(() => promptInstallApp()),
            child: const Text('نزّله'),
          ),
        IconButton(
          onPressed: () => setState(() => _dismissed = true),
          icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
        ),
      ]),
    );
  }
}
