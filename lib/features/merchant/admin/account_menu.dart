import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_flavor.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/tutorials/tutorial_service.dart';
import '../../profile/profile_screen.dart';
import '../../support/support_contact_screen.dart';
import '../../tutorials/tutorial_widgets.dart';

/// Account menu of the stand-alone merchant app (tajer.mogtama3y.com): an
/// icon in the top bar, or — [tile] — the account row at the bottom of the
/// wide-screen sidebar.
class TajerAccountMenu extends StatelessWidget {
  const TajerAccountMenu({super.key, this.tile = false});
  final bool tile;

  void _onSelected(BuildContext context, String v) {
    switch (v) {
      case 'tutorials':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TutorialVideosScreen()));
      case 'profile':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      case 'support':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen()));
      case 'mogtama3y':
        launchUrl(Uri.parse(mogtama3yUrl), webOnlyWindowName: '_self');
      case 'logout':
        AuthService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    TutorialService.activeForApp(); // warm the session cache for «فيديوهات الشرح»
    List<PopupMenuEntry<String>> items(BuildContext _) => [
          if (TutorialService.loaded?.isNotEmpty ?? false) const PopupMenuItem(value: 'tutorials', child: Text('فيديوهات الشرح')),
          const PopupMenuItem(value: 'profile', child: Text('حسابي')),
          const PopupMenuItem(value: 'support', child: Text('الدعم والمساعدة')),
          const PopupMenuItem(value: 'mogtama3y', child: Text('زور مُجتمعي')),
          const PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
        ];
    if (!tile) {
      return PopupMenuButton<String>(
        tooltip: 'حسابي',
        icon: const Icon(Icons.account_circle_outlined),
        onSelected: (v) => _onSelected(context, v),
        itemBuilder: items,
      );
    }
    final user = AuthService.currentUser;
    final name = (user?.userMetadata?['full_name'] as String?)?.trim();
    final label = (name == null || name.isEmpty) ? (user?.email ?? 'حسابي') : name;
    return PopupMenuButton<String>(
      tooltip: 'حسابي',
      onSelected: (v) => _onSelected(context, v),
      itemBuilder: items,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.tealLight,
            child: Text(label.characters.first.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.crystal)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
          const Icon(Icons.unfold_more_rounded, size: 18, color: AppColors.inkMuted),
        ]),
      ),
    );
  }
}
