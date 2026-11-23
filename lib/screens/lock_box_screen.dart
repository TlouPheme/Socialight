import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import '../widgets/xp.dart';
import 'lock_screen.dart';

class LockBoxScreen extends StatelessWidget {
  const LockBoxScreen({super.key});

  Future<void> _lock(BuildContext context) async {
    final session = await Navigator.of(context).push<LockSession>(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const LockScreen(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
    if (session == null || !context.mounted) return;
    final minutes = session.duration.inMinutes;
    if (session.xp > 0) {
      await showCelebration(
        context,
        title: 'Phone-free time!',
        xp: session.xp,
        message: 'You stayed off your phone for $minutes minute${minutes == 1 ? '' : 's'}.',
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlocked'),
        content: const Text('Stay locked for at least a minute to start earning XP.'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SkyScaffold(
      leading: const MenuButton(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36, 44, 36, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: PageHeader(title: 'Lock Box', subtitle: 'Spend time without phone to gain xp points'),
            ),
            const Spacer(),
            PillButton(
              label: 'Lock phone',
              icon: Icons.lock_outline,
              onPressed: () => _lock(context),
              alignStart: true,
              height: 68,
              radius: 22,
              fontWeight: FontWeight.w500,
              padding: 38,
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: appState,
              builder: (context, _) => Text(
                'Earn ${LockSession.xpPerMinute} XP for every minute locked · You have ${appState.xp} XP',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
