
import 'package:flutter/cupertino.dart';

// ─── _CandleStick ────────────────────────────────────────────────────────────

class CandleStick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _Bar(height: 24, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 3),
        _Bar(height: 36, color: const Color(0xFFFFD700)),
        const SizedBox(width: 3),
        _Bar(height: 18, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 3),
        _Bar(height: 28, color: const Color(0xFFFFD700)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;
  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.75),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}