import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme.dart';
import 'xp.dart';

/// The layout shared by every screen in the mockups: a sky-blue header with
/// decorations (clouds, birds, a tree) and a white card with large rounded top
/// corners holding the page content.
class SkyScaffold extends StatelessWidget {
  const SkyScaffold({
    super.key,
    required this.body,
    this.skyHeight = 64,
    this.decorations = const [],
    this.clouds = defaultClouds,
    this.leading,
    this.cardColor = Colors.white,
    this.showXp = true,
  });

  final Widget body;

  /// Height of the visible sky below the status bar. Changes animate.
  final double skyHeight;

  /// Widgets (usually [Positioned]) drawn in the sky, behind the card.
  /// Coordinates are relative to the area just below the status bar.
  final List<Widget> decorations;

  /// Clouds that drift slowly across the sky, behind [decorations].
  final List<CloudSpec> clouds;

  /// Top-left button, e.g. [MenuButton].
  final Widget? leading;

  final Color cardColor;

  /// Shows the player's XP in the top-right corner (off for sign-in screens).
  final bool showXp;

  static const _cardRadius = BorderRadius.vertical(top: Radius.elliptical(110, 90));

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.sky,
      body: TweenAnimationBuilder<double>(
        tween: Tween(end: skyHeight),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        builder: (context, sky, _) {
          final cardTop = topInset + sky;
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: topInset,
                height: sky + 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: CloudLayer(clouds: clouds)),
                    ...decorations,
                  ],
                ),
              ),
              Positioned.fill(
                top: cardTop,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: _cardRadius,
                    boxShadow: const [
                      BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, -1)),
                    ],
                  ),
                  child: ClipRRect(borderRadius: _cardRadius, child: body),
                ),
              ),
              if (leading != null) Positioned(top: topInset + 4, left: 8, child: leading!),
              if (showXp) Positioned(top: topInset + 10, right: 14, child: const XpBadge()),
            ],
          );
        },
      ),
    );
  }
}

/// A soft cumulus cloud drawn in code: many blurred puffs with a bright,
/// sunlit top and a cool grey underside (placeholder for photo assets).
class Cloud extends StatelessWidget {
  const Cloud({super.key, this.width = 110, this.seed = 1});

  final double width;

  /// Varies the puff layout so clouds don't all look identical.
  final int seed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(size: Size(width, width * 0.5), painter: _CloudPainter(seed)),
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  _CloudPainter(this.seed);

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rng = math.Random(seed);

    // Puffs are biggest in the middle and sit on a roughly flat base.
    final puffs = <(Offset, double)>[];
    for (var i = 0; i < 26; i++) {
      final t = rng.nextDouble();
      final profile = math.sin(math.pi * t);
      final r = h * (0.12 + 0.24 * profile * (0.55 + 0.45 * rng.nextDouble()));
      final x = w * (0.1 + 0.8 * t);
      final y = h * 0.8 - r * (0.55 + 0.45 * rng.nextDouble()) - h * 0.1 * profile;
      puffs.add((Offset(x, y), r));
    }

    Paint blurred(Color color, double sigma) => Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);

    // Flat, shaded base.
    canvas.drawOval(
      Rect.fromLTWH(w * 0.12, h * 0.6, w * 0.76, h * 0.26),
      blurred(const Color(0x99B9CBDA), h * 0.08),
    );
    // Cool shadow under each puff, then the white body, then sunlit highlights.
    for (final (c, r) in puffs) {
      canvas.drawCircle(c + Offset(r * 0.1, r * 0.3), r, blurred(const Color(0xCCCAD8E5), r * 0.35));
    }
    for (final (c, r) in puffs) {
      canvas.drawCircle(c, r * 0.9, blurred(const Color(0xF2FFFFFF), r * 0.3));
    }
    for (final (c, r) in puffs) {
      canvas.drawCircle(c - Offset(r * 0.25, r * 0.3), r * 0.5, blurred(Colors.white, r * 0.25));
    }
  }

  @override
  bool shouldRepaint(_CloudPainter old) => old.seed != seed;
}

/// A loose flock of gulls, as on the "Add friends" screen.
class Birds extends StatelessWidget {
  const Birds({super.key, this.width = 260});

  final double width;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size(width, 70), painter: _BirdsPainter()),
    );
  }
}

class _BirdsPainter extends CustomPainter {
  static const _birds = [(0.06, 0.45), (0.25, 0.70), (0.13, 0.95), (0.70, 0.50), (0.90, 0.80)];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8A9096)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final (fx, fy) in _birds) {
      final c = Offset(fx * size.width, fy * size.height);
      final path = Path()
        ..moveTo(c.dx - 10, c.dy - 4)
        ..quadraticBezierTo(c.dx - 5, c.dy - 6, c.dx, c.dy)
        ..quadraticBezierTo(c.dx + 5, c.dy - 6, c.dx + 10, c.dy - 4);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A leafy tree canopy peeking over the login card: a dark silhouette covered
/// in hundreds of small leaf clusters, lit from the top left.
class TreeTop extends StatelessWidget {
  const TreeTop({super.key, this.width = 140});

  final double width;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(size: Size(width, width * 0.5), painter: _TreePainter()),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  // Canopy lobes: (x, y, radius) as fractions of width, height, height.
  static const _lobes = [
    (0.18, 0.80, 0.30),
    (0.32, 0.55, 0.36),
    (0.50, 0.40, 0.42),
    (0.68, 0.52, 0.38),
    (0.84, 0.78, 0.30),
    (0.50, 0.80, 0.40),
  ];

  static const _shadow = Color(0xFF243A12);
  static const _mid = Color(0xFF557A26);
  static const _light = Color(0xFFA9C459);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final lobes = [for (final (x, y, r) in _lobes) (Offset(x * w, y * h), r * h)];

    bool inside(Offset p) => lobes.any((l) => (p - l.$1).distance < l.$2 * 0.97);

    // Silhouette with a soft drop shadow.
    for (final (c, r) in lobes) {
      canvas.drawCircle(
        c + const Offset(0, 3),
        r,
        Paint()
          ..color = const Color(0x33000000)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
    for (final (c, r) in lobes) {
      canvas.drawCircle(c, r, Paint()..color = _shadow);
    }

    // Leaf clusters, lighter toward the top left where the sun hits.
    final rng = math.Random(7);
    final leaf = Paint();
    final count = (w * 7).round();
    for (var i = 0; i < count; i++) {
      final p = Offset(rng.nextDouble() * w, rng.nextDouble() * h);
      if (!inside(p)) continue;
      final light = (1.05 - p.dy / h * 0.75 - p.dx / w * 0.35 + (rng.nextDouble() - 0.5) * 0.5)
          .clamp(0.0, 1.0);
      leaf.color = light < 0.5
          ? Color.lerp(_shadow, _mid, light * 2)!
          : Color.lerp(_mid, _light, (light - 0.5) * 2)!;
      final r = h * (0.025 + rng.nextDouble() * 0.04);
      canvas.drawOval(Rect.fromCenter(center: p, width: r * 2.2, height: r * 1.6), leaf);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Where a drifting cloud starts and how fast it moves.
class CloudSpec {
  const CloudSpec({required this.x, required this.top, this.width = 110, this.speed = 12});

  /// Starting left edge as a fraction of the screen width (may be negative or > 1).
  final double x;

  /// Distance from the top of the sky, below the status bar.
  final double top;

  final double width;

  /// Drift speed in logical pixels per second (left to right).
  final double speed;
}

/// The default sky for in-app screens: a couple of clouds near the top.
const defaultClouds = [
  CloudSpec(x: 0.2, top: -12, width: 120, speed: 10),
  CloudSpec(x: 0.82, top: 30, width: 100, speed: 16),
];

/// Paints [clouds] drifting left to right, wrapping around the screen edges
/// and bobbing gently up and down. Respects the system "remove animations"
/// accessibility setting.
class CloudLayer extends StatefulWidget {
  const CloudLayer({super.key, required this.clouds});

  final List<CloudSpec> clouds;

  /// Set to false in widget tests so `pumpAndSettle` can settle.
  static bool animate = true;

  @override
  State<CloudLayer> createState() => _CloudLayerState();
}

class _CloudLayerState extends State<CloudLayer> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _elapsed = ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) => _elapsed.value = elapsed);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate = CloudLayer.animate && !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate && !_ticker.isActive) {
      _ticker.start();
    } else if (!shouldAnimate && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _elapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          return ValueListenableBuilder(
            valueListenable: _elapsed,
            builder: (context, elapsed, _) {
              final t = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (final (i, c) in widget.clouds.indexed)
                    Positioned(
                      left: _left(c, screenWidth, t),
                      top: c.top + 3 * math.sin(t * 0.6 + i * 1.7),
                      child: Cloud(width: c.width, seed: i * 31 + c.width.round()),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// Moves right at [CloudSpec.speed]; once fully off the right edge the cloud
  /// re-enters from the left.
  static double _left(CloudSpec c, double screenWidth, double t) {
    final span = screenWidth + c.width;
    final start = c.x * screenWidth + c.width;
    return (start + t * c.speed) % span - c.width;
  }
}
