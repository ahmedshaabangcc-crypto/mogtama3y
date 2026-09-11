import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../assistant/assistant_chat_screen.dart';
import '../chat/chat_list_screen.dart';
import '../home/guest_home_screen.dart';
import '../more/more_menu_screen.dart';
import '../notifications/notifications_screen.dart';
import '../services/technicians_market_screen.dart';

/// Bottom-nav shell matching the 5-tab bar seen across the app screens:
/// الرئيسية، الخدمات، المحادثات، الإشعارات، المزيد (right-to-left).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static final _pages = [
    const GuestHomeScreen(),
    const TechniciansMarketScreen(),
    const ChatListScreen(),
    const NotificationsScreen(),
    const MoreMenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _pages),
          // Positioned manually (rather than Scaffold.floatingActionButton) so it
          // can clear the home tab's own bottomSheet CTA, which an outer
          // Scaffold's default FAB placement doesn't know about.
          Positioned(
            bottom: _index == 0 ? 104 : 20,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'assistant-fab',
              backgroundColor: AppColors.navy,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssistantChatScreen())),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'الخدمات'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'المحادثات'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'الإشعارات'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}
