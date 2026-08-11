
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── Glow Text Field ──────────────────────────────────────────────────────────

class GlowTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const GlowTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<GlowTextField> createState() => _GlowTextFieldState();
}

class _GlowTextFieldState extends State<GlowTextField>
    with SingleTickerProviderStateMixin {
  bool _obscure = true;
  bool _focused = false;
  late AnimationController _ctrl;
  late Animation<double> _glowAnim;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _glowAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
      _focusNode.hasFocus ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _focused
                ? [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.5 * _glowAnim.value),
                blurRadius: 18 * _glowAnim.value,
                spreadRadius: 2 * _glowAnim.value,
              ),
            ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            cursorColor: const Color(0xFFD4AF37),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 15),
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _focused ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.5),
                size: 20,
              ),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.09),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF9333EA), width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        );
      },
    );
  }
}