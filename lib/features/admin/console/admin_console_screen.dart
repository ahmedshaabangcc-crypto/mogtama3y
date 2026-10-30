import 'package:flutter/material.dart';

import '../../../core/app_flavor.dart';
import '../../../core/theme/app_colors.dart';
import '../admin_chat_rooms_screen.dart';
import '../admin_governance_screen.dart';
import '../admin_mosque_chat_screen.dart';
import '../admin_mosque_claims_screen.dart';
import '../admin_place_reports_screen.dart';
import '../admin_reports_screen.dart';
import '../admin_room_moderation_screen.dart';
import '../admin_scrap_dealers_screen.dart';
import '../admin_tutorial_videos_screen.dart';
import '../admin_user_flags_screen.dart';
import '../superadmin_control_panel_screen.dart';
import 'list_pages.dart';
import 'overview_page.dart';

/// One page of the console.
class ConsolePage {
  const ConsolePage(this.id, this.label, this.icon, this.build, {this.group = 'main'});
  final String id;
  final String label;
  final IconData icon;
  final Widget Function(void Function(String) open) build;
  final String group;
}

/// Every console page, in sidebar order.
List<ConsolePage> consolePages() => [
      ConsolePage('overview', 'نظرة عامة', Icons.space_dashboard_rounded, (open) => AdminOverviewPage(onOpen: open)),
      ConsolePage('users', 'المشتركين', Icons.people_alt_rounded, (_) => const AdminUsersPage()),
      ConsolePage('payments', 'المدفوعات والإيراد', Icons.payments_rounded, (_) => const AdminPaymentsPage()),
      ConsolePage('shops', 'المتاجر', Icons.storefront_rounded, (_) => const AdminShopsPage()),
      ConsolePage('approvals', 'الطلبات والموافقات', Icons.fact_check_rounded, (_) => const SuperadminControlPanelScreen(embedded: true)),
      ConsolePage('governance', 'الرئاسة والانضمام', Icons.how_to_reg_rounded, (_) => const AdminGovernanceScreen(), group: 'community'),
      ConsolePage('reports', 'البلاغات', Icons.campaign_rounded, (_) => const AdminReportsScreen(), group: 'community'),
      ConsolePage('user_flags', 'بلاغات عن أشخاص', Icons.person_off_rounded, (_) => const AdminUserFlagsScreen(), group: 'community'),
      ConsolePage('place_reports', 'بلاغات الأماكن', Icons.wrong_location_rounded, (_) => const AdminPlaceReportsScreen(), group: 'community'),
      ConsolePage('scrap', 'تجار الخردة', Icons.recycling_rounded, (_) => const AdminScrapDealersScreen(), group: 'community'),
      ConsolePage('mosques', 'طلبات إدارة المساجد', Icons.mosque_rounded, (_) => const AdminMosqueClaimsScreen(), group: 'masjid'),
      ConsolePage('mosque_chat', 'بلاغات شات المساجد', Icons.forum_rounded, (_) => const AdminMosqueChatScreen(), group: 'masjid'),
      if (!isUnionApp && !isTajerApp && !isMasjidApp) ...[
        ConsolePage('rooms', 'غرف الدردشة', Icons.chat_rounded, (_) => const AdminChatRoomsScreen(), group: 'chat'),
        ConsolePage('room_mod', 'إشراف الغرف', Icons.shield_rounded, (_) => const AdminRoomModerationScreen(), group: 'chat'),
      ],
      ConsolePage('videos', 'فيديوهات الشرح', Icons.smart_display_rounded, (_) => const AdminTutorialVideosScreen(), group: 'content'),
    ];

const _groups = {
  'main': null,
  'community': 'المجتمع والبلاغات',
  'masjid': 'مسجدي',
  'chat': 'الدردشة',
  'content': 'المحتوى',
};

/// The super-admin console (0106): a sidebar on a computer (a drawer on a
/// phone), a live overview first, then users, payments, stores, the
/// approvals queues and every moderation tool.
class AdminConsoleScreen extends StatefulWidget {
  const AdminConsoleScreen({super.key, this.initialPage = 'overview'});
  final String initialPage;

  @override
  State<AdminConsoleScreen> createState() => _AdminConsoleScreenState();
}

class _AdminConsoleScreenState extends State<AdminConsoleScreen> {
  late final List<ConsolePage> _pages = consolePages();
  late String _current = widget.initialPage;
  final _scaffold = GlobalKey<ScaffoldState>();

  ConsolePage get _page => _pages.firstWhere((p) => p.id == _current, orElse: () => _pages.first);

  void _open(String id) {
    if (_scaffold.currentState?.isDrawerOpen ?? false) Navigator.of(context).pop();
    setState(() => _current = id);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final sidebar = _Sidebar(pages: _pages, current: _current, onOpen: _open);
    final content = KeyedSubtree(key: ValueKey('console-page-${_page.id}'), child: _page.build(_open));
    return Scaffold(
      key: _scaffold,
      backgroundColor: AppColors.bg,
      drawer: wide ? null : Drawer(width: 290, child: sidebar),
      appBar: wide
          ? null
          : AppBar(
              title: Text(_page.label),
              leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => _scaffold.currentState?.openDrawer()),
            ),
      body: wide
          ? Row(children: [
              SizedBox(width: 270, child: sidebar),
              const VerticalDivider(width: 1),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: AlignmentDirectional.centerStart,
                    decoration: const BoxDecoration(color: AppColors.surface, border: Border(bottom: BorderSide(color: AppColors.border))),
                    child: Row(children: [
                      Icon(_page.icon, color: AppColors.crystal),
                      const SizedBox(width: 10),
                      Text(_page.label, key: const ValueKey('console-title'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
                    ]),
                  ),
                  Expanded(child: content),
                ]),
              ),
            ])
          : content,
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.pages, required this.current, required this.onOpen});
  final List<ConsolePage> pages;
  final String current;
  final void Function(String) onOpen;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    String? group;
    for (final p in pages) {
      if (p.group != group) {
        group = p.group;
        final title = _groups[group];
        if (title != null) {
          items.add(Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 16, 6),
            child: Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ));
        }
      }
      final selected = p.id == current;
      items.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Material(
          color: selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            key: ValueKey('console-nav-${p.id}'),
            dense: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Icon(p.icon, size: 20, color: selected ? AppColors.gold : Colors.white70),
            title: Text(p.label, style: TextStyle(color: Colors.white, fontWeight: selected ? FontWeight.w800 : FontWeight.w500, fontSize: 13.5)),
            onTap: () => onOpen(p.id),
          ),
        ),
      ));
    }
    return Material(
      color: AppColors.night,
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 16, 4),
            child: Row(children: [
              Icon(Icons.admin_panel_settings_rounded, color: AppColors.gold),
              SizedBox(width: 10),
              Flexible(
                child: Text('لوحة تحكم مُجتمعي',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 16, 10),
            child: Text('سوبر أدمن', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 12), children: items)),
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            leading: const Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 20),
            title: const Text('رجوع للتطبيق', style: TextStyle(color: Colors.white70, fontSize: 13)),
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ]),
      ),
    );
  }
}
