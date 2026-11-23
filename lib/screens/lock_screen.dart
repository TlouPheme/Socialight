import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/mock_data.dart';

/// Result of a Lock Box session, returned when the user swipes up.
class LockSession {
  const LockSession(this.duration);

  static const xpPerMinute = 10;

  final Duration duration;
  int get xp => duration.inMinutes * xpPerMinute;
}

/// Full-screen in-app "lock screen" shown while the phone is locked.
///
/// Note: Flutter can't lock the device itself; this screen hides system UI,
/// blocks the back button, and only exits on a swipe up.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  static const _messages = [
    "You're doing great, don't give up now!",
    'Look up, the world is out there.',
    'Every minute counts. Keep going!',
    'Your friends will still be there later.',
  ];
  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  final _start = DateTime.now();
  late final Timer _timer;
  DateTime _now = DateTime.now();

  Duration get _elapsed => _now.difference(_start);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _unlock() {
    final session = LockSession(DateTime.now().difference(_start));
    if (session.xp > 0) appState.addXp(session.xp);
    Navigator.of(context).pop(session);
  }

  @override
  Widget build(BuildContext context) {
    final hour = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final time = '$hour:${_now.minute.toString().padLeft(2, '0')}';
    final date = '${_weekdays[_now.weekday - 1]}, ${_months[_now.month - 1]} ${_now.day}';
    final message = _messages[(_elapsed.inSeconds ~/ 30) % _messages.length];
    final size = MediaQuery.sizeOf(context);
    final circle = math.min(size.width * 0.78, 310.0);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (d) {
            if ((d.primaryVelocity ?? 0) < -250) _unlock();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _MountainsPainter()),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(date, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.white, fontSize: 84, fontWeight: FontWeight.w700, height: 1.1),
                    ),
                    _ElapsedRing(elapsed: _elapsed),
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: Container(
                              width: circle,
                              height: circle,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.18),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                              ),
                              child: Icon(Icons.lock_outline, size: circle * 0.4, color: const Color(0xFF3E5A72)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xCC1C1C1E),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          message,
                          key: ValueKey(message),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Row(
                        children: [
                          _RoundIcon(Icons.flashlight_on_outlined),
                          Expanded(
                            child: Text(
                              'Swipe up to open',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          _RoundIcon(Icons.photo_camera_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: 140,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small gauge showing minutes locked (ring fills over each minute).
class _ElapsedRing extends StatelessWidget {
  const _ElapsedRing({required this.elapsed});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _RingPainter((elapsed.inSeconds % 60) / 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${elapsed.inMinutes}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, height: 1),
              ),
              const Text('min', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(4);
    final base = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi * 0.75, math.pi * 1.5, false, base);
    canvas.drawArc(rect, math.pi * 0.75, math.pi * 1.5 * progress, false, base..color = Colors.white);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(color: Color(0x55000000), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

/// Layered mountain silhouettes over a blue gradient (placeholder wallpaper).
class _MountainsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1D4E89), Color(0xFF8DB6D9), Color(0xFFF2EBDD)],
          stops: [0, 0.3, 0.42],
        ).createShader(Offset.zero & size),
    );

    const layers = [
      (0.45, Color(0xFF7FB0D6)),
      (0.53, Color(0xFF4F86B5)),
      (0.62, Color(0xFF2F5F8C)),
      (0.72, Color(0xFF1B3B5E)),
      (0.82, Color(0xFF0E1E33)),
    ];
    for (final (i, (top, color)) in layers.indexed) {
      final path = Path()..moveTo(0, h);
      const steps = 6;
      for (var s = 0; s <= steps; s++) {
        final x = w * s / steps;
        final peak = (s + i).isEven ? -0.05 : 0.03;
        path.lineTo(x, h * (top + peak));
      }
      path
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }
    canvas.drawRect(Rect.fromLTWH(0, h * 0.85, w, h * 0.15), Paint()..color = const Color(0xFF070F1A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
