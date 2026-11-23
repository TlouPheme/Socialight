import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'quest_map_screen.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  String? _expandedId;

  Future<void> _pickFriends(Quest quest) async {
    final options = appState.friends.isNotEmpty
        ? appState.friends.toList()
        : allUsers;
    final chosen = {...?appState.questFriends[quest.id]};
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add friends to quest',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if (appState.friends.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'You have no friends added yet; showing everyone.',
                      style: subtitleStyle,
                    ),
                  ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final name in options)
                        CheckboxListTile(
                          value: chosen.contains(name),
                          title: Text(name),
                          activeColor: AppColors.primary,
                          onChanged: (v) => setSheetState(
                            () => v! ? chosen.add(name) : chosen.remove(name),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: PillButton(
                    label: 'Done',
                    onPressed: () => Navigator.of(context).pop(chosen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result != null) appState.setQuestFriends(quest.id, result);
  }

  void _uploadImage(Quest quest) {
    // TODO: hook up image_picker + storage. For now this just marks the photo as uploaded.
    // No snackbar here: it would float over the map screen's "Quest Completed" button.
    appState.uploadPhoto(quest.id);
  }

  void _openMap(Quest quest) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => QuestMapScreen(quest: quest)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => SkyScaffold(
        // The sky shrinks when a quest is expanded, as in the mockups.
        skyHeight: _expandedId == null ? 150 : 64,
        leading: const MenuButton(),
        clouds: const [
          CloudSpec(x: -0.05, top: 50, width: 80, speed: 15),
          CloudSpec(x: 0.5, top: 40, width: 110, speed: 9),
          CloudSpec(x: 0.38, top: -16, width: 100, speed: 6),
        ],
        body: ListView(
          padding: const EdgeInsets.fromLTRB(36, 44, 36, 32),
          children: [
            const PageHeader(
              title: 'Quest',
              subtitle: 'Complete quests to gain xp points.',
            ),
            const SizedBox(height: 40),
            for (final quest in quests) ...[
              _QuestCard(
                quest: quest,
                expanded: _expandedId == quest.id,
                completed: appState.completedQuests.contains(quest.id),
                hasPhoto: appState.questsWithPhoto.contains(quest.id),
                friendCount: appState.questFriends[quest.id]?.length ?? 0,
                onToggle: () => setState(
                  () => _expandedId = _expandedId == quest.id ? null : quest.id,
                ),
                onAddFriends: () => _pickFriends(quest),
                onUploadImage: () => _uploadImage(quest),
                onOpenMap: () => _openMap(quest),
              ),
              const SizedBox(height: 26),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({
    required this.quest,
    required this.expanded,
    required this.completed,
    required this.hasPhoto,
    required this.friendCount,
    required this.onToggle,
    required this.onAddFriends,
    required this.onUploadImage,
    required this.onOpenMap,
  });

  final Quest quest;
  final bool expanded;
  final bool completed;
  final bool hasPhoto;
  final int friendCount;
  final VoidCallback onToggle;
  final VoidCallback onAddFriends;
  final VoidCallback onUploadImage;
  final VoidCallback onOpenMap;

  String? get _status {
    if (completed) return 'Completed';
    if (hasPhoto) return 'Photo uploaded · finish on the map';
    if (friendCount == 0) return null;
    return '$friendCount friend${friendCount == 1 ? '' : 's'} invited';
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final header = Material(
      color: AppColors.primary,
      elevation: expanded ? 0 : 4,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(30),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onToggle,
        child: Container(
          constraints: const BoxConstraints(minHeight: 68),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            completed ? Icons.check_circle : Icons.timelapse,
                            color: completed
                                ? AppColors.accentOnBlue
                                : Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              status,
                              style: TextStyle(
                                color: completed
                                    ? AppColors.accentOnBlue
                                    : Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${quest.xp} XP',
                style: const TextStyle(
                  color: AppColors.accentOnBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !expanded
          ? header
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _QuestSteps(
                          invited: friendCount > 0,
                          photo: hasPhoto,
                          done: completed,
                        ),
                        const SizedBox(height: 16),
                        PillButton(
                          label: friendCount == 0
                              ? 'Add friend to quest'
                              : 'Friends on quest: $friendCount',
                          onPressed: completed ? null : onAddFriends,
                          color: AppColors.cyan,
                          textColor: AppColors.ink,
                          height: 36,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 12),
                        PillButton(
                          label: hasPhoto ? 'Image uploaded' : 'Upload Image',
                          icon: hasPhoto ? Icons.check : Icons.upload,
                          onPressed: completed ? null : onUploadImage,
                          color: AppColors.accent,
                          textColor: AppColors.ink,
                          height: 36,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          alignStart: true,
                          padding: 16,
                        ),
                        const SizedBox(height: 12),
                        PillButton(
                          label: (hasPhoto && !completed)
                              ? 'Finish on the map'
                              : 'View on map',
                          icon: Icons.map_outlined,
                          onPressed: onOpenMap,
                          height: 36,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          alignStart: true,
                          padding: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// "1 Invite · 2 Photo · 3 Complete" progress row inside an open quest card.
/// Inviting friends is optional; the photo is what unlocks completion.
class _QuestSteps extends StatelessWidget {
  const _QuestSteps({
    required this.invited,
    required this.photo,
    required this.done,
  });

  final bool invited;
  final bool photo;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Invite friends', invited),
      ('Upload photo', photo),
      ('Complete', done),
    ];
    return Row(
      children: [
        for (final (i, (label, complete)) in steps.indexed) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: complete ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: complete
                          ? AppColors.primary
                          : const Color(0xFF9AA5B5),
                      width: 2,
                    ),
                  ),
                  child: complete
                      ? const Icon(Icons.check, size: 15, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: complete ? FontWeight.w700 : FontWeight.w500,
                    color: complete
                        ? AppColors.primary
                        : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
