import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/controls.dart';
import 'leaderboard_screen.dart';
import 'lock_box_screen.dart';
import 'other_screens.dart';
import 'quests_screen.dart';

enum AppTab { quests, lockBox, leaderboard, profile }

/// Main signed-in layout: the four core sections behind a bottom navigation
/// bar. Each tab keeps its state (scroll position, expanded quest) while you
/// switch between them.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = AppTab.quests});

  final AppTab initialTab;

  /// Clears the navigation stack and shows the shell on [tab].
  static void open(BuildContext context, [AppTab tab = AppTab.quests]) =>
      goToSection(context, HomeShell(initialTab: tab));

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialTab.index;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Quests'),
    NavigationDestination(
      icon: Icon(Icons.phonelink_lock_outlined),
      selectedIcon: Icon(Icons.phonelink_lock),
      label: 'Lock Box',
    ),
    NavigationDestination(
      icon: Icon(Icons.leaderboard_outlined),
      selectedIcon: Icon(Icons.leaderboard),
      label: 'Leaders',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined),
      selectedIcon: Icon(Icons.account_circle),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [QuestsScreen(), LockBoxScreen(), LeaderboardScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? AppColors.primary : Colors.black54,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
              color: states.contains(WidgetState.selected) ? AppColors.primary : Colors.black87,
            ),
          ),
        ),
        child: NavigationBar(
          height: 68,
          elevation: 8,
          shadowColor: Colors.black,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: _destinations,
        ),
      ),
    );
  }
}
