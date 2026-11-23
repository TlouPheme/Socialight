import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import 'add_friends_screen.dart';
import 'sign_up_screen.dart';

/// "Tell us about yourself" — pick the activities you enjoy.
class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  late final Set<String> _selected = {...appState.interests};

  // Bubble centre (x, y) and radius in the mockup's 393 x 340 design space.
  static const _layout = <String, (double, double, double)>{
    'Hiking': (122, 75, 52),
    'Reading': (301, 68, 66),
    'Shopping': (196, 270, 60),
    'Boardgames': (100, 188, 78),
    'Bowling': (227, 165, 52),
    'Eating out': (324, 247, 52),
  };
  static const _designSize = Size(393, 340);

  void _toggle(String interest) => setState(() {
        if (!_selected.remove(interest)) _selected.add(interest);
      });

  void _next() {
    appState.setInterests(_selected);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddFriendsScreen(onboarding: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SkyScaffold(
      showXp: false,
      skyHeight: onboardingSkyHeight(context),
      clouds: const [
        CloudSpec(x: 0.25, top: 50, width: 120, speed: 8),
        CloudSpec(x: 0.85, top: 20, width: 80, speed: 14),
      ],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
        child: Column(
          children: [
            const Text(
              'Tell us about\nyourself.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34, height: 1.15, color: AppColors.ink),
            ),
            const SizedBox(height: 10),
            const Text('Select the activities you enjoy.', style: subtitleStyle),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final scale = math.min(
                    constraints.maxWidth / _designSize.width,
                    constraints.maxHeight / _designSize.height,
                  );
                  return Center(
                    child: SizedBox(
                      width: _designSize.width * scale,
                      height: _designSize.height * scale,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          for (final MapEntry(key: name, value: (x, y, r)) in _layout.entries)
                            Positioned(
                              left: (x - r) * scale,
                              top: (y - r) * scale,
                              child: _Bubble(
                                label: name,
                                diameter: r * 2 * scale,
                                fontSize: 18 * scale,
                                selected: _selected.contains(name),
                                onTap: () => _toggle(name),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PillButton(label: 'Next', onPressed: _selected.isEmpty ? null : _next),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.label,
    required this.diameter,
    required this.fontSize,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double diameter;
  final double fontSize;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: diameter,
          height: diameter,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.accent : Colors.transparent,
              width: diameter * 0.045,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x55000000), blurRadius: 5, offset: Offset(0, 3)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
    );
  }
}
