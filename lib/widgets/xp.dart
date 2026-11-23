import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import 'controls.dart';

/// Small pill in the sky header showing the player's XP. Counts up when XP
/// changes so every gain is noticeable.
class XpBadge extends StatelessWidget {
  const XpBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Semantics(
        label: '${appState.xp} XP',
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 5, 12, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
              const SizedBox(width: 4),
              TweenAnimationBuilder<double>(
                tween: Tween(end: appState.xp.toDouble()),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  '${value.round()} XP',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen celebration with confetti and an XP count-up.
Future<void> showCelebration(
  BuildContext context, {
  required String title,
  required int xp,
  String? message,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: title,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, _, child) => ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: animation, child: child),
    ),
    pageBuilder: (context, _, _) => _Celebration(title: title, xp: xp, message: message),
  );
}

class _Celebration extends StatefulWidget {
  const _Celebration({required this.title, required this.xp, this.message});

  final String title;
  final int xp;
  final String? message;

  @override
  State<_Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<_Celebration> with SingleTickerProviderStateMixin {
  late final _confetti = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))
    ..forward();

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _confetti,
            builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_confetti.value)),
          ),
        ),
        Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            elevation: 12,
            child: Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.accent, size: 64),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: widget.xp.toDouble()),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '+${value.round()} XP',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.accentText),
                    ),
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: 6),
                    Text(widget.message!, textAlign: TextAlign.center, style: subtitleStyle),
                  ],
                  const SizedBox(height: 20),
                  PillButton(label: 'Awesome!', onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);

  final double t;

  static const _colors = [
    AppColors.primary,
    AppColors.accent,
    AppColors.sky,
    Color(0xFFFF6B6B),
    Color(0xFF34C759),
    Colors.white,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint();
    for (var i = 0; i < 90; i++) {
      final x0 = rng.nextDouble() * size.width;
      final delay = rng.nextDouble() * 0.35;
      final speed = 0.7 + rng.nextDouble() * 0.6;
      final spin = (rng.nextDouble() - 0.5) * 12;
      final color = _colors[rng.nextInt(_colors.length)];
      final p = ((t - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (p == 0) continue;
      final y = -20 + p * speed * (size.height + 40);
      final x = x0 + math.sin(p * 8 + i) * 18;
      paint.color = color.withValues(alpha: (1 - math.max(0.0, p - 0.8) * 5).clamp(0.0, 1.0));
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p * spin)
        ..drawRect(const Rect.fromLTWH(-4, -2.5, 8, 5), paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
