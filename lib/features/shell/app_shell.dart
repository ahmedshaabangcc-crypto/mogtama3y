import 'package:flutter/material.dart';

import '../home/guest_home_screen.dart';
import '../services/technicians_market_screen.dart';
import '../shared/placeholder_screen.dart';
import '../wallet/wallet_screen.dart';

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
    const PlaceholderScreen(title: 'المحادثات'),
    const PlaceholderScreen(title: 'الإشعارات'),
    const WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
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
