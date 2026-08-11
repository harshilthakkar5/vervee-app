
// ─── FILE: lib/presentation/widgets/HomeScreenWidgets/shimmer_box.dart ────────
// ✅ CHANGE 1 (NEW FILE) — Reusable shimmer animation widget
//    Kaam: AnimationController se 0→1→0 loop chalata hai,
//    LinearGradient leftmost → rightmost shift karta hai
//    taaki "light sweep" effect aaye bina kisi package ke.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ── ShimmerBox ────────────────────────────────────────────────────────────────
// Ek single shimmer rectangle.
// width/height pass karo, borderRadius optional hai.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 6,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {

  // ✅ CHANGE 1a — AnimationController: 1200ms loop (shimmer ki speed)
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(); // ✅ infinite loop

    _anim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Container(
          width:  widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // ✅ CHANGE 1b — Shimmer gradient: dark base + light sweep
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end:   Alignment(_anim.value,     0),
              colors: const [
                Color(0xFF1A0535), // base dark purple
                Color(0xFF2D1050), // mid highlight
                Color(0xFF3D1A6E), // peak shimmer (lightest)
                Color(0xFF2D1050), // mid highlight
                Color(0xFF1A0535), // base dark purple
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }
}