import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../profile/profile_screen.dart';
import '../shared/made_by_apex.dart';

/// The "المزيد" (More) menu — the bottom-nav hamburger tab. A plain
/// list of every account/tool section, not any single feature.
class MoreMenuScreen extends StatefulWidget {
  const MoreMenuScreen({super.key});

  @override
  State<MoreMenuScreen> createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen> {
  Map<String, dynamic>? _profile;
  bool _isScrapDealer = false;
  bool _loadingProfile = false;
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _authSub = AuthService.authStateChanges.listen((_) => _loadProfile());
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (!AuthService.isSignedIn) {
      setState(() {
        _profile = null;
        _isScrapDealer = false;
      });
      return;
    }
    // Only switches the scrap-dealer tile's wording — failures are ignored.
    ScrapDealerService.myDealer().then((d) {
      if (mounted) setState(() => _isScrapDealer = d != null);
    }, onError: (_) {});
    setState(() => _loadingProfile = true);
    try {
      final profile = await AuthService.fetchCurrentProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loadingProfile = false;
      });
    } catch (_) {
      // Only the header's name line — on failure stop "loading" and keep the
      // previous value (or the generic fallback name) instead of an error view.
      if (!mounted) return;
      setState(() => _loadingProfile = false);
    }
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = AuthService.isSignedIn;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('القائمة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          if (signedIn)
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _loadingProfile ? 'جارِ التحميل...' : (_profile?['full_name'] as String? ?? 'عضو مُجتمعي'),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      Text(
                        AuthService.currentUser?.email ?? '',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: _signOut, child: const Text('تسجيل الخروج', style: TextStyle(fontSize: 11.5, color: AppColors.gold))),
              ]),
            ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 26)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('غير مسجل الدخول', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                      Text('سجّل دخولك للوصول لكل مزايا حسابك', style: TextStyle(fontSize: 10.5, color: Colors.white70)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
                  child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 12, color: AppColors.gold, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
          const SizedBox(height: 18),
          const _SectionLabel('الحساب والمال'),
          if (signedIn)
            _MenuTile(
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.teal,
              title: 'ملفي الشخصي',
              subtitle: 'اسمك وصورتك وبياناتك',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
          _MenuTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.teal,
            title: 'المحفظة المالية',
            subtitle: 'الرصيد وسجل المعاملات',
            onTap: () => context.go(AppRoutes.wallet),
          ),
          _MenuTile(
            icon: Icons.toll_rounded,
            iconColor: AppColors.gold,
            title: 'رصيد التوكن ومميزات الإعلانات',
            subtitle: 'اشحن رصيدك ومَيّز إعلاناتك',
            onTap: () => context.go(AppRoutes.tokens),
          ),
          _MenuTile(
            icon: Icons.add_circle_outline_rounded,
            iconColor: AppColors.teal,
            title: 'انشر إعلاناً جديداً',
            subtitle: 'وظيفة، سلعة مستعملة، خدمة صيانة، أو خردة للتدوير',
            onTap: () => context.go(AppRoutes.post),
          ),
          _MenuTile(
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.gold,
            title: 'دفع الفواتير والخدمات',
            subtitle: 'كهرباء، غاز، مياه، فواتير موبايل وأكتر',
            badge: 'قريباً',
            onTap: () => context.go(AppRoutes.bills),
          ),
          _MenuTile(
            icon: Icons.qr_code_2_rounded,
            iconColor: AppColors.gold,
            title: 'عنوانك الإلكتروني',
            subtitle: 'كود وQR لعنوانك تبعته لأي حد يوصلك على طول',
            onTap: () => context.go(AppRoutes.myAddress),
          ),
          _MenuTile(
            icon: Icons.forum_rounded,
            iconColor: AppColors.teal,
            title: 'أصحابي والرسائل',
            subtitle: 'طلبات الصداقة والشات مع جيرانك',
            onTap: () => context.go(AppRoutes.friends),
          ),
          _MenuTile(
            icon: Icons.storefront_rounded,
            iconColor: AppColors.teal,
            title: 'لوحة التاجر',
            subtitle: 'خلّي محلك أونلاين ببلاش: منتجات وطلبات وQR',
            onTap: () => context.go(AppRoutes.merchant),
          ),
          _MenuTile(
            icon: Icons.recycling_rounded,
            iconColor: AppColors.teal,
            title: _isScrapDealer ? 'لوحة تاجر الخردة' : 'تاجر خردة؟ سجّل هنا',
            subtitle: _isScrapDealer ? 'المزادات المطابقة ليك وعروضك' : 'يوصلك إشعار بكل مزاد خردة جديد في منطقتك',
            onTap: () => context.go(AppRoutes.scrapDealer),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('حيّك'),
          _MenuTile(
            icon: Icons.campaign_rounded,
            iconColor: AppColors.categorySos,
            title: 'بلاغات حيّك',
            subtitle: 'شوف المشاكل اللي جيرانك بلّغوا عنها أو بلّغ إنت',
            onTap: () => context.go(AppRoutes.reports),
          ),
          _MenuTile(
            icon: Icons.groups_rounded,
            iconColor: AppColors.teal,
            title: 'جروب الحي',
            subtitle: 'اتكلم مع جيرانك واعرف أخبار منطقتك',
            onTap: () => context.go(AppRoutes.neighborhoods),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('المساعدة والقانون'),
          _MenuTile(
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'الدعم والمساعدة',
            subtitle: 'تواصل مع فريق علاقات السكان',
            onTap: () => context.go(AppRoutes.support),
          ),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'الأسئلة الشائعة',
            onTap: () => context.go(AppRoutes.faq),
          ),
          _MenuTile(
            icon: Icons.gavel_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'الشروط والأحكام وميثاق الجيران',
            onTap: () => context.go(AppRoutes.terms),
          ),
          _MenuTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.inkSecondary,
            title: 'سياسة الخصوصية وحماية البيانات',
            onTap: () => context.go(AppRoutes.privacy),
          ),
          _MenuTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.inkSecondary,
            title: 'عن منصة مُجتمعي',
            onTap: () => context.go(AppRoutes.about),
          ),
          const SizedBox(height: 8),
          const MadeByApex(dark: false),
          if (_profile?['role'] == 'super_admin') ...[
          const SizedBox(height: 18),
          const _SectionLabel('الإدارة'),
          _MenuTile(
            icon: Icons.admin_panel_settings_outlined,
            iconColor: AppColors.inkSecondary,
            title: 'لوحة تحكم السوبر أدمن',
            subtitle: 'فض النزاعات والرقابة العامة',
            onTap: () => context.go(AppRoutes.admin),
          ),
          ],
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
  const _MenuTile({required this.icon, required this.iconColor, required this.title, required this.onTap, this.subtitle, this.badge});
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? badge;
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
        title: Row(children: [
          Flexible(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
              child: Text(badge!, style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
        subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
      ),
    );
  }
}
