import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/controls.dart';
import '../widgets/sky.dart';
import '../widgets/xp.dart';

class QuestMapScreen extends StatelessWidget {
  const QuestMapScreen({super.key, required this.quest});

  final Quest quest;

  Future<void> _openInMaps(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': quest.mapsQuery});
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) showSnack(context, "Couldn't open Maps.");
  }

  Future<void> _complete(BuildContext context) async {
    appState.completeQuest(quest);
    await showCelebration(context, title: 'Quest complete!', xp: quest.xp, message: quest.title);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final completed = appState.completedQuests.contains(quest.id);
        final hasPhoto = appState.questsWithPhoto.contains(quest.id);
        return SkyScaffold(
          leading: const MenuButton(),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(22, 44, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeader(title: 'Map', subtitle: "Let's get you on your way!"),
                const SizedBox(height: 32),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _MapPreview(label: quest.place),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PillButton(
                    label: 'Open in Maps',
                    icon: Icons.map_outlined,
                    onPressed: () => _openInMaps(context),
                    color: AppColors.accent,
                    textColor: AppColors.ink,
                    fontWeight: FontWeight.w500,
                    height: 52,
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PillButton(
                    label: 'Quest Completed',
                    icon: Icons.check,
                    onPressed: (!completed && hasPhoto) ? () => _complete(context) : null,
                    fontWeight: FontWeight.w500,
                    height: 46,
                  ),
                ),
                if (!completed && !hasPhoto)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Upload an image on the quest to complete it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Stylised map placeholder. Swap for google_maps_flutter once an API key is set up.
class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _MapPainter()),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E9E6A),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: const Icon(Icons.flag, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E7A55),
                  shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF1F3F4));

    // Bay.
    final water = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.7, 0)
      ..quadraticBezierTo(w * 0.45, h * 0.1, 0, h * 0.13)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFFAADAFF));

    // Parks / mountain.
    final park = Paint()..color = const Color(0xFFCDEBD3);
    canvas.drawOval(Rect.fromLTWH(-w * 0.15, h * 0.25, w * 0.6, h * 0.55), park);
    canvas.drawOval(Rect.fromLTWH(w * 0.6, h * 0.62, w * 0.18, h * 0.08), park);

    // Streets.
    final street = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (var i = 1; i < 9; i++) {
      canvas.drawLine(Offset(w * 0.45, h * i / 9), Offset(w, h * i / 9 + 12), street);
      canvas.drawLine(Offset(w * (0.45 + i * 0.07), h * 0.15), Offset(w * (0.42 + i * 0.07), h), street);
    }

    // Highways.
    final highway = Paint()
      ..color = const Color(0xFF9DB2D6)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.9, 0)
        ..quadraticBezierTo(w * 0.7, h * 0.3, w * 0.75, h * 0.6)
        ..quadraticBezierTo(w * 0.8, h * 0.85, w * 0.7, h),
      highway,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.35, h * 0.2)
        ..quadraticBezierTo(w * 0.6, h * 0.25, w, h * 0.22),
      highway,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.3)
        ..quadraticBezierTo(w * 0.45, h * 0.7, w * 0.55, h),
      highway,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
