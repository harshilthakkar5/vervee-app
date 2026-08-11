import 'package:flutter/cupertino.dart';

// ─── Gold Coin ────────────────────────────────────────────────────────────────

class GoldCoin extends StatefulWidget {
  final double size;
  const GoldCoin({required this.size});

  @override
  State<GoldCoin> createState() => GoldCoinState();
}

class GoldCoinState extends State<GoldCoin> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _float = Tween<double>(begin: 0, end: 8)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -_float.value),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFA07820)],
              center: Alignment(-0.3, -0.3),
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2),
            ],
          ),
          child: Center(
            child: Text(
              '\$',
              style: TextStyle(
                  color: const Color(0xFF7A5500),
                  fontSize: widget.size * 0.48,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
