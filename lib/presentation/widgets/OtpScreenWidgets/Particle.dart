
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── WavePainter ────────────────────────────────────────────────────────────

class Particle {
  double x, y, size, speed, opacity;
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final double animValue;
  final List<Particle> particles;
  ParticlePainter(this.animValue, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y - animValue * p.speed * 0.3) % 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(
          Offset(p.x * size.width, y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => true;
}