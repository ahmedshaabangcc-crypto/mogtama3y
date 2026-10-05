import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Contact address printed on the legal pages.
const legalContactEmail = 'mogtama3y.eg@gmail.com';

/// One numbered section of a legal page: a title and its paragraphs.
class LegalSection {
  const LegalSection(this.title, this.paragraphs);
  final String title;
  final List<String> paragraphs;
}

/// Plain, readable layout shared by the terms and the privacy policy.
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.title, required this.updated, required this.intro, required this.sections});
  final String title;
  final String updated;
  final String intro;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(title)),
      body: SelectionArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 32),
          children: [
            Text('آخر تحديث: $updated', style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            const SizedBox(height: 10),
            Text(intro, style: const TextStyle(fontSize: 14, color: AppColors.inkSecondary, height: 1.8)),
            const SizedBox(height: 8),
            for (var i = 0; i < sections.length; i++) ...[
              const SizedBox(height: 18),
              Text('${i + 1}. ${sections[i].title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              for (final p in sections[i].paragraphs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(p, style: const TextStyle(fontSize: 13.5, color: AppColors.inkSecondary, height: 1.85)),
                ),
            ],
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
              child: const Text(
                'لأي سؤال أو طلب بخصوص هذه الصفحة: من "المساعدة والدعم" داخل التطبيق، أو على البريد $legalContactEmail',
                style: TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
