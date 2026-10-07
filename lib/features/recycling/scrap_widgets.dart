import 'package:flutter/material.dart';

import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/theme/app_colors.dart';

/// WhatsApp + call buttons for a contact revealed after an auction.
class ScrapContactButtons extends StatelessWidget {
  const ScrapContactButtons({super.key, required this.phone, required this.whatsapp, required this.message, required this.onOpen});
  final String? phone;
  final String whatsapp;
  final String message;
  final Future<void> Function(Uri) onOpen;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => onOpen(scrapWhatsappUri(whatsapp, message)),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
          icon: const Icon(Icons.chat_rounded, size: 16),
          label: const Text('واتساب'),
        ),
      ),
      if (phone != null) ...[
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onOpen(Uri.parse('tel:$phone')),
            icon: const Icon(Icons.call_rounded, size: 16),
            label: const Text('اتصال'),
          ),
        ),
      ],
    ]);
  }
}

/// قيد المراجعة / موثّق ✓ / مرفوض.
class ScrapDealerStatusBadge extends StatelessWidget {
  const ScrapDealerStatusBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'verified' => AppColors.teal,
      'rejected' => const Color(0xFFC62828),
      _ => const Color(0xFFF9A825),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
      child: Text(scrapDealerStatusLabels[status] ?? status, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

/// Small grey chip used for materials / areas.
class ScrapChip extends StatelessWidget {
  const ScrapChip(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
    );
  }
}
