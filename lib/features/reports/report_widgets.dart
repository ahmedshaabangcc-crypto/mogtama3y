import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/reports/report_service.dart';
import '../../core/theme/app_colors.dart';

class ReportStatusChip extends StatelessWidget {
  const ReportStatusChip(this.status, {super.key});
  final String? status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = reportStatuses[status] ?? ('—', AppColors.inkMuted);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w800)),
    );
  }
}

/// One report in a list: photo, category, place, status, age and votes.
class ReportCard extends StatelessWidget {
  const ReportCard(this.r, {super.key});
  final Map<String, dynamic> r;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = reportCategoryStyle(r['category'] as String?);
    final photos = (r['photos'] as List?)?.cast<String>() ?? const [];
    final where = [r['district'], r['governorate']].whereType<String>().where((s) => s.isNotEmpty).join('، ');
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/r/${r['id']}'),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 104,
            height: 116,
            child: photos.isEmpty
                ? ColoredBox(color: color.withValues(alpha: 0.12), child: Icon(icon, color: color, size: 36))
                : Image.network(photos.first, fit: BoxFit.cover, errorBuilder: (_, _, _) => ColoredBox(color: color.withValues(alpha: 0.12))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 4),
                  Expanded(child: Text(r['category'] as String? ?? '', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12.5))),
                  ReportStatusChip(r['status'] as String?),
                ]),
                const SizedBox(height: 4),
                Text(r['description'] as String? ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, height: 1.5)),
                const SizedBox(height: 4),
                Text(
                  [if (where.isNotEmpty) where, ReportService.ageLabel(r)].where((s) => s.isNotEmpty).join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
                ),
                Text('${r['votes_count'] ?? 0} ساكن معاه', style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
