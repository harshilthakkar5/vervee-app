






















import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class GlowDropdownCountry extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final List<Country> items;
  final Country? value;
  final ValueChanged<Country?> onChanged;
  final String? errorText;   // ← NAYA field

  const GlowDropdownCountry({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.value,
    this.errorText,
  });

  @override
  State<GlowDropdownCountry> createState() => _GlowDropdownCountryState();
}

class _GlowDropdownCountryState extends State<GlowDropdownCountry> {
  bool _focused = false;

  // ── NAYA: search wala country picker kholta hai
  // Note: showCountryPicker() `void` return karta hai (Future nahi),
  // isliye iske upar .then()/.whenComplete() use NAHI kar sakte.
  void _openCountryPicker() {
    setState(() => _focused = true);

    showCountryPicker(
      context: context,
      showPhoneCode: false,          // sirf country name/flag chahiye, phone code nahi
      // package khud search field render karta hai top pe (built-in)
      countryListTheme: CountryListThemeData(
        backgroundColor: const Color(0xFF2D0A5E),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        searchTextStyle: const TextStyle(color: Colors.white),
        textStyle: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      onSelect: (country) {
        widget.onChanged(country);
        if (mounted) setState(() => _focused = false);
      },
    );

    // Bottom sheet apni pop route khud handle karta hai (Navigator.pop se band hota hai),
    // isliye humein async completion track karne ki zaroorat nahi —
    // glow sirf tap ke turant baad thoda dikhna UX ke liye kaafi hai.
    setState(() => _focused = false);
  }

  @override
  Widget build(BuildContext context) {

    final hasError = widget.errorText != null;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
     AnimatedContainer(
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
      // ── DropdownButtonFormField ki jagah ab InkWell + fake-field
      // kyunki hume tap pe searchable bottom sheet kholna hai, dropdown nahi
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _openCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14),
              // border: Border.all(
              //   color: _focused
              //       ? const Color(0xFF9333EA)
              //       : Colors.white.withOpacity(0.15),
              //   width: _focused ? 1.8 : 1.2,
              // ),
              border: Border.all(
                color: hasError
                    ? Colors.redAccent
                    : _focused
                        ? const Color(0xFF9333EA)
                        : Colors.white.withOpacity(0.15),
                width: _focused || hasError ? 1.8 : 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.prefixIcon,
                  color: _focused
                      ? const Color(0xFFD4AF37)
                      : Colors.white.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: widget.value == null
                      ? Text(
                    widget.hint,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 15,
                    ),
                  )
                      : Row(
                    children: [
                      Text(widget.value!.flagEmoji,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.value!.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white.withOpacity(0.5), size: 22),

                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      widget.errorText!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
        ]
    );
  }
}







// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class GlowDropdownCountry extends StatefulWidget {
//   final String hint;
//   final IconData prefixIcon;
//   final List<Country> items;
//   final Country? value;
//   final ValueChanged<Country?> onChanged;
//
//   const GlowDropdownCountry({
//     super.key,
//     required this.hint,
//     required this.prefixIcon,
//     required this.items,
//     required this.onChanged,
//     this.value,
//   });
//
//   @override
//   State<GlowDropdownCountry> createState() => _GlowDropdownState();
// }
//
// class _GlowDropdownState extends State<GlowDropdownCountry> {
//   bool _focused = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: _focused
//             ? [
//           BoxShadow(
//             color: const Color(0xFF9333EA).withOpacity(0.4),
//             blurRadius: 16,
//             spreadRadius: 2,
//           ),
//         ]
//             : [],
//       ),
//       child: DropdownButtonFormField<Country>(
//         value: widget.value,
//         isExpanded: true,             // ← yeh ZAROORI hai — bina iske Expanded kaam nahi karega
//         hint: Text(                                              // 👈 yeh add karo
//           widget.hint,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.45),
//             fontSize: 15,
//           ),
//         ),
//         onTap: () => setState(() => _focused = true),
//         onChanged: (val) {
//           setState(() => _focused = false);
//           widget.onChanged(val);
//         },
//         dropdownColor: const Color(0xFF2D0A5E),
//         icon: Icon(Icons.keyboard_arrow_down_rounded,
//             color: Colors.white.withOpacity(0.5), size: 22),
//         style: const TextStyle(color: Colors.white, fontSize: 15),
//         decoration: InputDecoration(
//           // hintText: widget.hint,
//           // //hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
//           // hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 15), // 👈 fontSize add kiya
//           prefixIcon: Icon(widget.prefixIcon,
//               color: _focused
//                   ? const Color(0xFFD4AF37)
//                   : Colors.white.withOpacity(0.5)),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.09),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: Color(0xFF9333EA), width: 1.8),
//           ),
//         ),
//         items: widget.items.map((country) {
//           return DropdownMenuItem<Country>(
//             value: country,
//             child: Row(
//               children: [
//                 Text(country.flagEmoji),
//                 const SizedBox(width: 8),
//                 Expanded(                        // ← Tab kaam karega jab isExpanded: true ho
//                   child: Text(
//                     country.name,
//                     style: const TextStyle(color: Colors.white),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }























