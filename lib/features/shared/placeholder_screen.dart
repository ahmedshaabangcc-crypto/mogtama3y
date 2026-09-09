import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Temporary placeholder for tabs/screens not built yet.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_rounded, size: 48, color: AppColors.inkMuted),
            const SizedBox(height: 12),
            Text('$title — قريباً', style: const TextStyle(color: AppColors.inkMuted, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
