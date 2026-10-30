import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../../core/theme/app_colors.dart';

/// Building blocks of the super-admin console (0106).

final _num = NumberFormat.decimalPattern('ar');

/// «1٬234» — Arabic grouping for counts.
String fmtCount(num? v) => _num.format(v ?? 0);

/// A KPI card: icon, big value, label, an optional hint line.
class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.icon, required this.value, required this.label, this.hint, this.color = AppColors.crystal, this.onTap});
  final IconData icon;
  final String value;
  final String label;
  final String? hint;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (onTap != null) const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted, size: 18),
            ]),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
            const SizedBox(height: 2),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, color: AppColors.inkSecondary, fontWeight: FontWeight.w600)),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(hint!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w700)),
            ],
          ]),
        ),
      ),
    );
  }
}

/// Cards in a responsive grid: 4 across on a desktop, 2 on a phone.
class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 640 ? 3 : 2;
      const gap = 12.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(spacing: gap, runSpacing: gap, children: [for (final k in children) SizedBox(width: w, child: k)]);
    });
  }
}

/// A titled white panel.
class ConsolePanel extends StatelessWidget {
  const ConsolePanel({super.key, required this.title, required this.child, this.trailing, this.padding = const EdgeInsets.all(16)});
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      padding: padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
          ?trailing,
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

/// A section title between card grids.
class ConsoleSection extends StatelessWidget {
  const ConsoleSection(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
      );
}

/// A simple bar chart of one value per day (no chart package): the last
/// bar is today; touch / hover shows the day and value.
class DailyBars extends StatelessWidget {
  const DailyBars({super.key, required this.days, required this.values, this.color = AppColors.crystal, this.format = fmtCount, this.height = 140});
  final List<DateTime> days;
  final List<num> values;
  final Color color;
  final String Function(num) format;
  final double height;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<num>(0, (m, v) => v > m ? v : m);
    final total = values.fold<num>(0, (s, v) => s + v);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('الإجمالي: ${format(total)}', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
      const SizedBox(height: 8),
      SizedBox(
        height: height,
        child: Directionality(
          // Oldest on the left, today on the right, like any timeline chart.
          textDirection: TextDirection.ltr,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (var i = 0; i < values.length; i++)
              Expanded(
                child: Tooltip(
                  message: '${DateFormat('d/M').format(days[i])}: ${format(values[i])}',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Container(
                      height: max == 0 ? 2 : 2 + (height - 2) * values[i] / max,
                      decoration: BoxDecoration(
                        color: i == values.length - 1 ? color : color.withValues(alpha: 0.45),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
      const SizedBox(height: 4),
      if (days.isNotEmpty)
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(children: [
            Text(DateFormat('d/M').format(days.first), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            const Spacer(),
            const Text('النهارده', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ]),
        ),
    ]);
  }
}

/// A small status / tag pill.
class ConsolePill extends StatelessWidget {
  const ConsolePill(this.text, {super.key, this.color = AppColors.inkSecondary});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w700)),
      );
}

/// A data table that scrolls sideways on narrow screens.
class ConsoleTable extends StatelessWidget {
  const ConsoleTable({super.key, required this.columns, required this.rows, this.onTapRow});
  final List<String> columns;
  final List<List<Widget>> rows;
  final void Function(int index)? onTapRow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: c.maxWidth),
          child: DataTable(
            showCheckboxColumn: false,
            headingRowHeight: 40,
            dataRowMinHeight: 46,
            dataRowMaxHeight: 60,
            columnSpacing: 22,
            headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: AppColors.inkSecondary),
            columns: [for (final col in columns) DataColumn(label: Text(col))],
            rows: [
              for (var i = 0; i < rows.length; i++)
                DataRow(
                  onSelectChanged: onTapRow == null ? null : (_) => onTapRow!(i),
                  cells: [for (final cell in rows[i]) DataCell(cell)],
                ),
            ],
          ),
        ),
      );
    });
  }
}

/// «منذ 5 دقايق» style relative time.
String agoText(String? iso) {
  final t = DateTime.tryParse(iso ?? '')?.toLocal();
  if (t == null) return '—';
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'دلوقتي';
  if (d.inMinutes < 60) return 'من ${d.inMinutes} دقيقة';
  if (d.inHours < 24) return 'من ${d.inHours} ساعة';
  if (d.inDays < 30) return 'من ${d.inDays} يوم';
  return DateFormat('d/M/yyyy').format(t);
}
