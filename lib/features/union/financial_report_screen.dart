import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/financial_report_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';

String _fmt(num n) {
  final s = n.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

String _fmtDate(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

const _legendColors = [Color(0xFF12233F), AppColors.gold, AppColors.teal];

/// Quarterly general-assembly financial report — was reachable with NO
/// real data at all: fabricated collection totals, a fabricated expense
/// ledger with fake invoice numbers, fabricated board-member names with
/// fake digital-signature IDs, and a fake municipal registration number,
/// under a fake building name. Rebuilt around the real
/// union_financial_reports/union_expense_items tables — see
/// backend/migrations/0030_union_financial_reports.sql. Reports are
/// entered by the union's board directly for now; there's no in-app
/// authoring flow yet.
class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  bool _loading = true;
  String? _buildingId;
  String? _buildingName;
  Map<String, dynamic>? _report;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final membership = await UnionService.fetchMyMembership();
    final isVerified = membership?['status'] == 'verified';
    final buildingId = isVerified ? membership!['building_id'] as String? : null;
    final building = membership?['building'] as Map<String, dynamic>?;

    Map<String, dynamic>? report;
    if (buildingId != null) {
      report = await FinancialReportService.fetchLatestReport(buildingId);
    }

    if (!mounted) return;
    setState(() {
      _buildingId = buildingId;
      _buildingName = building?['name'] as String?;
      _report = report;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('التقرير المالي الشامل للجمعية العمومية')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('لازم تنضم لعمارتك وتوثّق حسابك الأول عشان تشوف التقرير المالي',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }
    final report = _report;
    if (report == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('التقرير المالي الشامل للجمعية العمومية')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('مجلس إدارة اتحاد ${_buildingName ?? "عمارتك"} لسه ما نشرش تقرير مالي',
                textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }

    final totalCollected = (report['total_collected'] as num?) ?? 0;
    final totalExpected = (report['total_expected'] as num?) ?? 0;
    final emergencyFund = (report['emergency_fund'] as num?) ?? 0;
    final actualExpenses = (report['actual_expenses'] as num?) ?? 0;
    final collectionRatio = totalExpected > 0 ? (totalCollected / totalExpected).clamp(0, 1).toDouble() : 0.0;
    final publishedAt = DateTime.tryParse(report['published_at'] as String? ?? '');
    final approvedName = (report['approved'] as Map<String, dynamic>?)?['full_name'] as String?;
    final auditedBy = report['audited_by'] as String?;
    final pdfUrl = report['pdf_url'] as String?;
    final items = List<Map<String, dynamic>>.from(report['expense_items'] as List? ?? []);
    final topItems = [...items]..sort((a, b) => ((b['amount'] as num?) ?? 0).compareTo((a['amount'] as num?) ?? 0));
    final top3 = topItems.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('التقرير المالي الشامل للجمعية العمومية')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Text('تقرير معتمد من مجلس الإدارة', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              if (publishedAt != null)
                Text('تحديث: ${_fmtDate(publishedAt)}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ]),
            const SizedBox(height: 6),
            Text('الشفافية الكاملة لصندوق شاغلي ${_buildingName ?? "العمارة"}', style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.inkSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الفترة المالية', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      Text(report['period_label'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('إجمالي التحصيلات والاشتراكات', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                    const Spacer(),
                    if (totalExpected > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                        child: Text('سداد ${(collectionRatio * 100).round()}%', style: const TextStyle(fontSize: 9, color: AppColors.teal, fontWeight: FontWeight.w700)),
                      ),
                  ]),
                  const SizedBox(height: 6),
                  Text('${_fmt(totalCollected)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
                  Text('من أصل ${_fmt(totalExpected)} ج.م', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(value: collectionRatio, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.savings_outlined, size: 15, color: AppColors.teal),
                        SizedBox(width: 5),
                        Text('صندوق الطوارئ', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ]),
                      const SizedBox(height: 6),
                      Text('${_fmt(emergencyFund)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.trending_down_rounded, size: 15, color: AppColors.categorySos),
                        SizedBox(width: 5),
                        Text('مصروفات فعلية', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ]),
                      const SizedBox(height: 6),
                      Text('${_fmt(actualExpenses)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ]),
            if (top3.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('أكبر بنود الصرف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CustomPaint(size: const Size(96, 96), painter: _DonutPainter(top3, actualExpenses)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < top3.length; i++) ...[
                            _LegendRow(
                              color: _legendColors[i % _legendColors.length],
                              label: top3[i]['label'] as String? ?? '',
                              value: '${_fmt((top3[i]['amount'] as num?) ?? 0)} ج.م',
                            ),
                            if (i != top3.length - 1) const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(child: Text('دفتر الأستاذ والمصروفات المفصل', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text('${items.length} بنود مسجلة', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('لا توجد بنود مسجلة في هذا التقرير', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5))),
              )
            else
              for (final e in items) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.receipt_long_outlined, size: 17, color: AppColors.inkSecondary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['label'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, height: 1.4)),
                              if ((e['vendor'] as String?)?.isNotEmpty == true)
                                Text(e['vendor'] as String, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                            ],
                          ),
                        ),
                        Text('${_fmt((e['amount'] as num?) ?? 0)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      ]),
                      if ((e['invoice_ref'] as String?)?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.attach_file_rounded, size: 12, color: AppColors.inkMuted),
                          const SizedBox(width: 4),
                          Expanded(child: Text(e['invoice_ref'] as String, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                        ]),
                      ],
                    ],
                  ),
                ),
              ],
            if (approvedName != null || auditedBy != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.workspace_premium_outlined, size: 16, color: AppColors.inkSecondary),
                      const SizedBox(width: 6),
                      const Text('اعتماد مجلس الإدارة والتدقيق المالي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    ]),
                    const SizedBox(height: 12),
                    if (approvedName != null) ...[
                      const Text('اعتمد بواسطة', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      Text(approvedName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                    if (auditedBy != null) ...[
                      const SizedBox(height: 8),
                      const Text('المدقق المالي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                      Text(auditedBy, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: pdfUrl == null
                    ? null
                    : () => launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.download_rounded, size: 17),
                label: Text(pdfUrl == null ? 'لا توجد نسخة PDF لهذا التقرير' : 'تحميل التقرير المالي الرسمي (PDF)', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label, required this.value});
  final Color color;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary), overflow: TextOverflow.ellipsis)),
        Text(value, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.items, this.total);
  final List<Map<String, dynamic>> items;
  final num total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    if (total <= 0) return;
    var start = -90 * (3.1415926535 / 180);
    for (var i = 0; i < items.length; i++) {
      final amount = (items[i]['amount'] as num?) ?? 0;
      final sweep = (amount / total) * 2 * 3.1415926535;
      final paint = Paint()
        ..color = _legendColors[i % _legendColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.items != items || oldDelegate.total != total;
}
