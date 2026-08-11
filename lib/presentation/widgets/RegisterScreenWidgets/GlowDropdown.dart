
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── Glow Dropdown ────────────────────────────────────────────────────────────

class GlowDropdown extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const GlowDropdown({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  State<GlowDropdown> createState() => _GlowDropdownState();
}

class _GlowDropdownState extends State<GlowDropdown> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _focused
            ? [
          BoxShadow(
            color: const Color(0xFF9333EA).withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ]
            : [],
      ),
      child: DropdownButtonFormField<String>(
        value: widget.value,
        onTap: () => setState(() => _focused = true),
        hint: Text(                                              // 👈 yeh add karo
          widget.hint,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 15,
          ),
        ),
        onChanged: (val) {
          setState(() => _focused = false);
          widget.onChanged(val);
        },
        dropdownColor: const Color(0xFF2D0A5E),
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.5), size: 22),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          // hintText: widget.hint,
          // hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 15),
          prefixIcon: Icon(widget.prefixIcon,
              color: _focused ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.5),
              size: 20),
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
        items: widget.items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
      ),
    );
  }
}