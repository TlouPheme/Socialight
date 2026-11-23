import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'home_shell.dart';
import 'sign_up_screen.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key, this.onboarding = false});

  /// When true, "Add" / "Do it later" continue to the quests screen instead of
  /// simply going back.
  final bool onboarding;

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final _search = TextEditingController();
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<String> get _results {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return allUsers
        .where((u) => u.toLowerCase().contains(q) && u != appState.displayName)
        .toList();
  }

  void _finish() {
    if (widget.onboarding) {
      HomeShell.open(context);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _add() {
    appState.addFriends(_selected);
    showSnack(context, 'Added ${_selected.length} friend${_selected.length == 1 ? '' : 's'}.');
    _finish();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final results = _results;
    return SkyScaffold(
      showXp: !widget.onboarding,
      skyHeight: onboardingSkyHeight(context),
      leading: const MenuButton(),
      clouds: const [CloudSpec(x: 0.33, top: 50, width: 100, speed: 8)],
      decorations: [
        Positioned(top: 30, left: width * 0.17, child: Birds(width: width * 0.66)),
      ],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(36, 40, 36, 16),
        child: Column(
          children: [
            const PageHeader(title: 'Add friends', subtitle: 'Invite or add friends'),
            const SizedBox(height: 40),
            Container(
              height: 44,
              decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(22)),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: AppColors.ink, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: AppColors.ink),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        _search.text.isEmpty
                            ? (_selected.isEmpty ? '' : '${_selected.length} selected')
                            : 'No one found for "${_search.text}"',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final name in results)
                          CheckboxListTile(
                            value: _selected.contains(name) || appState.friends.contains(name),
                            onChanged: appState.friends.contains(name)
                                ? null
                                : (v) => setState(() => v! ? _selected.add(name) : _selected.remove(name)),
                            secondary: CircleAvatar(
                              backgroundColor: AppColors.avatar,
                              child: Text(name[0], style: const TextStyle(color: AppColors.ink)),
                            ),
                            title: Text(name),
                            subtitle: appState.friends.contains(name) ? const Text('Already friends') : null,
                            activeColor: AppColors.primary,
                            contentPadding: EdgeInsets.zero,
                          ),
                      ],
                    ),
            ),
            PillButton(label: 'Add', onPressed: _selected.isEmpty ? null : _add),
            TextButton(
              onPressed: _finish,
              child: const Text(
                'Do it later',
                style: TextStyle(color: AppColors.accentText, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
