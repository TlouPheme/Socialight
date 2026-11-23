import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'home_shell.dart';
import 'login_screen.dart';
import 'other_screens.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, IconData, VoidCallback)>[
      ('Quests', Icons.explore_outlined, () => HomeShell.open(context, AppTab.quests)),
      ('Lock box', Icons.phonelink_lock_outlined, () => HomeShell.open(context, AppTab.lockBox)),
      ('Leader board', Icons.leaderboard_outlined, () => HomeShell.open(context, AppTab.leaderboard)),
      ('Vouchers', Icons.local_activity_outlined, () => _openOverShell(context, const VouchersScreen())),
      ('Profile', Icons.account_circle_outlined, () => HomeShell.open(context, AppTab.profile)),
      ('Settings', Icons.settings_outlined, () => _openOverShell(context, const SettingsScreen())),
      (
        'Logout',
        Icons.logout,
        () {
          appState.signOut();
          goToSection(context, const LoginScreen());
        }
      ),
    ];

    return SkyScaffold(
      leading: IconButton(
        tooltip: 'Close menu',
        icon: const Icon(Icons.close, size: 34, color: AppColors.ink),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
        children: [
          const Text('Menu', style: titleStyle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          for (final (label, icon, onTap) in items) ...[
            PillButton(
              label: label,
              icon: icon,
              onPressed: onTap,
              alignStart: true,
              height: 68,
              radius: 22,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              padding: 38,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

/// Replaces the menu with [screen], so Back returns to the tabs underneath.
void _openOverShell(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
}
