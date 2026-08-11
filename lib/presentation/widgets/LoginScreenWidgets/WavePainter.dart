
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

// ─── Wave Painter ─────────────────────────────────────────────────────────────

class WavePainter extends CustomPainter {
  final double animValue;
  WavePainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF6B21A8).withOpacity(0.7),
          const Color(0xFF9333EA).withOpacity(0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path1 = Path();
    path1.moveTo(0, size.height * 0.45);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.45 +
          math.sin((x / size.width * 2 * math.pi) + animValue * 2 * math.pi) *
              size.height * 0.12 +
          math.sin((x / size.width * 4 * math.pi) + animValue * 2 * math.pi) *
              size.height * 0.06;
      path1.lineTo(x, y);
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()..color = const Color(0xFF7C3AED).withOpacity(0.35);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.6 +
          math.sin((x / size.width * 3 * math.pi) + animValue * 2 * math.pi + 1.2) *
              size.height * 0.09;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WavePainter old) => true;
}