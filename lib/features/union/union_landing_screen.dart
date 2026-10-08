import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import 'found_building_screen.dart';
import 'join_as_tenant_screen.dart';
import 'union_registration_screen.dart';
import 'union_home_link.dart';

const _features = [
  (Icons.receipt_long_rounded, 'مستحقات الصيانة', 'إصدار المستحقات لكل الشقق مرة واحدة، والسكان يدفعوا من محفظتهم، وكله متسجّل.'),
  (Icons.how_to_vote_rounded, 'قرارات وانتخابات', 'تصويت مجلس الإدارة على القرارات، وانتخابات الرئاسة بصوت لكل شقة ونصاب واضح.'),
  (Icons.bar_chart_rounded, 'تقارير مالية', 'المصروفات والإيرادات ظاهرة لكل السكان الموثقين — شفافية من غير خناقات.'),
  (Icons.groups_rounded, 'سكان موثقين', 'محدش يدخل العمارة إلا بموافقة الرئيس، والمالك يضيف مستأجره بكود خاص.'),
  (Icons.qr_code_2_rounded, 'تصاريح زوار وحارس', 'تصريح QR للزائر بمدة محددة، والحارس يتحقق منه من موبايله.'),
  (Icons.campaign_rounded, 'إعلانات ودردشة وSOS', 'إعلانات رسمية من المجلس، دردشة للعمارة، وزر استغاثة ينبّه الجيران.'),
];

/// The owners'-union campaign page — mogtama3y.com/#/ittihad. Explains the
/// union tools on their own (without the rest of مُجتمعي) and sends the
/// visitor straight into founding or joining a building. Everything lives
/// in the same مُجتمعي account, so these buildings are part of مُجتمعي
/// from day one.
class UnionLandingScreen extends StatefulWidget {
  const UnionLandingScreen({super.key});

  @override
  State<UnionLandingScreen> createState() => _UnionLandingScreenState();
}

class _UnionLandingScreenState extends State<UnionLandingScreen> {
  bool _hasBuilding = false;

  @override
  void initState() {
    super.initState();
    _checkMembership();
  }

  Future<void> _checkMembership() async {
    if (!AuthService.isSignedIn) return;
    try {
      final membership = await UnionService.fetchMyMembership();
      if (!mounted) return;
      setState(() => _hasBuilding = membership?['status'] == 'verified');
    } catch (_) {
      // The page works the same without this shortcut.
    }
  }

  Future<void> _open(Widget screen) async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (mounted) _checkMembership();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const UnionHomeTitle(title: 'اتحاد ملاك أونلاين')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('اتحاد ملاك عمارتك… من الموبايل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
              SizedBox(height: 8),
              Text('المستحقات والقرارات والانتخابات والتقارير المالية وتصاريح الزوار في مكان واحد، ببلاش.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.7)),
            ]),
          ),
          const SizedBox(height: 16),
          if (_hasBuilding) ...[
            _CtaButton(
              icon: Icons.dashboard_rounded,
              label: 'افتح لوحة اتحاد عمارتك',
              filled: true,
              onTap: () => context.go(AppRoutes.union),
            ),
            const SizedBox(height: 16),
          ],
          const Text('إزاي تبدأ؟', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          const _Step(n: 1, text: 'رئيس الاتحاد (أو أي مالك) يسجّل العمارة ويبقى مؤسسها.'),
          const _Step(n: 2, text: 'ياخد كود دعوة ويبعته في جروب العمارة.'),
          const _Step(n: 3, text: 'السكان ينضموا بالكود، والرئيس يوافق على كل شقة.'),
          const SizedBox(height: 14),
          _CtaButton(icon: Icons.add_business_rounded, label: 'أسّس اتحاد عمارتك', filled: !_hasBuilding, onTap: () => _open(const FoundBuildingScreen())),
          const SizedBox(height: 10),
          _CtaButton(icon: Icons.vpn_key_rounded, label: 'عندي كود دعوة من الرئيس', onTap: () => _open(const UnionRegistrationScreen())),
          const SizedBox(height: 10),
          _CtaButton(icon: Icons.person_add_alt_rounded, label: 'أنا مستأجر ومعايا كود من المالك', onTap: () => _open(const JoinAsTenantScreen())),
          const SizedBox(height: 22),
          const Text('هتقدر تعمل إيه', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 10),
          for (final (icon, title, body) in _features) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: AppColors.teal, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(body, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.6)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          const Text(
            'الأدوات دي بتساعدكم تنظموا شغل الاتحاد، ومش بديل عن القواعد القانونية لاتحادكم.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});
  final int n;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(radius: 11, backgroundColor: AppColors.gold, child: Text('$n', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800))),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.6))),
      ]),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.icon, required this.label, required this.onTap, this.filled = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: Icon(icon, size: 18),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.navy, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: Icon(icon, size: 18),
              label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
    );
  }
}
