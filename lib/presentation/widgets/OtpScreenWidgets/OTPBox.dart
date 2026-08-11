
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── OTP Single Input Box ─────────────────────────────────────────────────────

class OTPBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const OTPBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  State<OTPBox> createState() => _OTPBoxState();
}

class _OTPBoxState extends State<OTPBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    widget.focusNode.addListener(() {
      widget.focusNode.hasFocus ? _ctrl.forward() : _ctrl.reverse();
      setState(() {});
    });
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;
    final filled = widget.controller.text.isNotEmpty;

    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) => Container(
        width:  48, //64,
        height: 58, //68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: focused
              ? [
            BoxShadow(
              color: const Color(0xFF9333EA)
                  .withOpacity(0.55 * _glow.value),
              blurRadius: 20 * _glow.value,
              spreadRadius: 2 * _glow.value,
            ),
          ]
              : filled
              ? [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            color: filled ? const Color(0xFFFFFFFF) : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          cursorColor: const Color(0xFFD4AF37),
          onChanged: (val) {
            widget.onChanged(val);
          },
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: filled
                ? const Color(0xFF7C3AED).withOpacity(0.22)
                : Colors.white.withOpacity(0.09),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: filled
                    ? const Color(0xFFD4AF37).withOpacity(0.65)
                    : Colors.white.withOpacity(0.18),
                width: filled ? 1.8 : 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF9333EA),
                width: 2.0,
              ),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          ),
        ),
      ),
    );
  }
}