import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/theme/app_colors.dart';

/// مُجتمعي's old /#/merchant link: merchants have their own app now
/// (tajer.mogtama3y.com), so this hands off to it straight away.
class OpenTajerApp extends StatefulWidget {
  const OpenTajerApp({super.key});

  @override
  State<OpenTajerApp> createState() => _OpenTajerAppState();
}

class _OpenTajerAppState extends State<OpenTajerApp> {
  void _go() => launchUrl(Uri.parse(tajerUrl), webOnlyWindowName: '_self');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _go());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.storefront_rounded, size: 44, color: AppColors.crystal),
            const SizedBox(height: 12),
            const Text('بنفتحلك تطبيق «متجري» للتجار…', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            ElevatedButton(onPressed: _go, child: const Text('افتح متجري')),
          ]),
        ),
      ),
    );
  }
}
