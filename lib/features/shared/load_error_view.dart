import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Shown in place of a screen's content when its data failed to load
/// (network error, permission error, …) — instead of a spinner that
/// never stops. [onRetry] re-runs the screen's loader.
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({super.key, required this.onRetry, this.message = 'تعذر تحميل البيانات، تحقق من الاتصال وحاول مرة أخرى'});

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.inkMuted, size: 34),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5, height: 1.6)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
