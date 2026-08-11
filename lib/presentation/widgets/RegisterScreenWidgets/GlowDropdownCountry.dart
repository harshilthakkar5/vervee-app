
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlowDropdownCountry extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final List<Country> items;
  final Country? value;
  final ValueChanged<Country?> onChanged;

  const GlowDropdownCountry({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  State<GlowDropdownCountry> createState() => _GlowDropdownState();
}

class _GlowDropdownState extends State<GlowDropdownCountry> {
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
      child: DropdownButtonFormField<Country>(
        value: widget.value,
        isExpanded: true,             // ← yeh ZAROORI hai — bina iske Expanded kaam nahi karega
        hint: Text(                                              // 👈 yeh add karo
          widget.hint,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 15,
          ),
        ),
        onTap: () => setState(() => _focused = true),
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
          // //hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
          // hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 15), // 👈 fontSize add kiya
          prefixIcon: Icon(widget.prefixIcon,
              color: _focused
                  ? const Color(0xFFD4AF37)
                  : Colors.white.withOpacity(0.5)),
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
        ),
        items: widget.items.map((country) {
          return DropdownMenuItem<Country>(
            value: country,
            child: Row(
              children: [
                Text(country.flagEmoji),
                const SizedBox(width: 8),
                Expanded(                        // ← Tab kaam karega jab isExpanded: true ho
                  child: Text(
                    country.name,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}























