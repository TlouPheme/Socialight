import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'add_friends_screen.dart';

/// Screens reachable from the menu that don't have mockups yet.

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => SkyScaffold(
        leading: const MenuButton(),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(36, 44, 36, 32),
          children: [
            const Text('Profile', style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.avatar,
                child: Icon(Icons.person, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              appState.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            if (appState.email.isNotEmpty)
              Text(appState.email, textAlign: TextAlign.center, style: subtitleStyle),
            const SizedBox(height: 8),
            Text(
              '${appState.xp} XP',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: AppColors.accentText, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 28),
            const Text('Interests', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (appState.interests.isEmpty) const Text('None yet', style: subtitleStyle),
                for (final i in appState.interests) Chip(label: Text(i)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Friends (${appState.friends.length})', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final f in appState.friends) Chip(label: Text(f))],
            ),
            const SizedBox(height: 20),
            PillButton(
              label: 'Add friends',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddFriendsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VouchersScreen extends StatelessWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const _ComingSoon(title: 'Vouchers', subtitle: 'Spend your XP on rewards from local partners.');
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ComingSoon(title: 'Settings', subtitle: 'Notifications, privacy and more.');
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SkyScaffold(
      leading: const BackButton(color: AppColors.ink),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36, 44, 36, 32),
        child: Column(
          children: [
            PageHeader(title: title, subtitle: subtitle),
            const Spacer(),
            const Icon(Icons.construction_outlined, size: 56, color: AppColors.primaryDisabled),
            const SizedBox(height: 12),
            const Text('Coming soon', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
