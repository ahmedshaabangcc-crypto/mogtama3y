import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../about/about_platform_screen.dart';
import '../bills/bill_payment_hub_screen.dart';
import '../admin/superadmin_control_panel_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_conditions_screen.dart';
import '../post/smart_post_picker_screen.dart';
import '../promote/token_wallet_screen.dart';
import '../support/support_contact_screen.dart';
import '../wallet/wallet_screen.dart';

/// The "المزيد" (More) menu — the bottom-nav hamburger tab. A plain
/// list of every account/tool section, not any single feature.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('القائمة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 26)),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سكن موثّق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text('برج الياسمين - شقة 4B', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
            ]),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('الحساب والمال'),
          _MenuTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.teal,
            title: 'المحفظة المالية',
            subtitle: 'الرصيد وسجل المعاملات',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen())),
          ),
          _MenuTile(
            icon: Icons.toll_rounded,
            iconColor: AppColors.gold,
            title: 'رصيد التوكن ومميزات الإعلانات',
            subtitle: 'اشحن رصيدك ومَيّز إعلاناتك',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TokenWalletScreen())),
          ),
          _MenuTile(
            icon: Icons.add_circle_outline_rounded,
            iconColor: AppColors.teal,
            title: 'انشر إعلاناً جديداً',
            subtitle: 'وظيفة، سلعة مستعملة، خدمة صيانة، أو خردة للتدوير',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SmartPostPickerScreen())),
          ),
          _MenuTile(
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.gold,
            title: 'دفع الفواتير والخدمات',
            subtitle: 'كهرباء، غاز، مياه، فواتير موبايل وأكتر',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BillPaymentHubScreen())),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('المساعدة والقانون'),
          _MenuTile(
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'الدعم والمساعدة',
            subtitle: 'تواصل مع فريق علاقات السكان',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen())),
          ),
          _MenuTile(
            icon: Icons.gavel_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'الشروط والأحكام وميثاق الجيران',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TermsConditionsScreen())),
          ),
          _MenuTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.inkSecondary,
            title: 'سياسة الخصوصية وحماية البيانات',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          ),
          _MenuTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'عن منصة مُجتمعي',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPlatformScreen())),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('الإدارة'),
          _MenuTile(
            icon: Icons.admin_panel_settings_outlined,
            iconColor: AppColors.inkSecondary,
            title: 'لوحة تحكم السوبر أدمن',
            subtitle: 'فض النزاعات والرقابة العامة',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SuperadminControlPanelScreen())),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 2),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted, fontWeight: FontWeight.w700)),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.iconColor, required this.title, required this.onTap, this.subtitle});
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        tileColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
      ),
    );
  }
}
