import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: appState, builder: (context, _) => _build(context));
  }

  Widget _build(BuildContext context) {
    final me = Player(appState.displayName, appState.xp);
    final ranking = [...leaderboardPlayers, me]..sort((a, b) => b.xp.compareTo(a.xp));

    return SkyScaffold(
      leading: const MenuButton(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(36, 44, 36, 32),
        children: [
          const Text('Leader Board', style: titleStyle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          for (final (i, player) in ranking.indexed) ...[
            _LeaderRow(rank: i + 1, player: player, isMe: identical(player, me)),
            const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({required this.rank, required this.player, required this.isMe});

  final int rank;
  final Player player;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        border: isMe ? Border.all(color: AppColors.accent, width: 3) : null,
        boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.accentOnBlue, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const CircleAvatar(radius: 24, backgroundColor: AppColors.avatar),
          Expanded(
            child: Text(
              isMe ? '${player.name} (you)' : player.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${player.xp} XP',
            style: const TextStyle(color: AppColors.accentOnBlue, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
