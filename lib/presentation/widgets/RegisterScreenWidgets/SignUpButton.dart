
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── Sign Up Button ───────────────────────────────────────────────────────────

class SignUpButton extends StatefulWidget {
  final VoidCallback? onTap;   // ← nullable kiya (loading mein disable hoga)
  final bool isLoading;        // ← NAYA

  const SignUpButton({
    super.key,
    required this.onTap,
    this.isLoading = false,    // ← NAYA, default false
  });

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ── Loading ho ya onTap null ho toh kuch mat karo
      onTapDown: widget.onTap == null ? null : (_) => _ctrl.forward(),
      onTapUp: widget.onTap == null
          ? null
          : (_) async {
        await _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: widget.onTap == null ? null : () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              // ── Loading mein slightly dim dikhega
              colors: widget.isLoading
                  ? [const Color(0xFF7C3AED).withOpacity(0.6),
                const Color(0xFF5B21B6).withOpacity(0.6)]
                  : [const Color(0xFF7C3AED), const Color(0xFF5B21B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.55),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            // ── Loading = spinner, otherwise text
            child: widget.isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class SignUpButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const SignUpButton({super.key, required this.onTap});
//
//   @override
//   State<SignUpButton> createState() => _SignUpButtonState();
// }
//
// class _SignUpButtonState extends State<SignUpButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
//     _scale = Tween<double>(begin: 1.0, end: 0.96)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => _ctrl.forward(),
//       onTapUp: (_) async {
//         await _ctrl.reverse();
//         widget.onTap();
//       },
//       onTapCancel: () => _ctrl.reverse(),
//       child: ScaleTransition(
//         scale: _scale,
//         child: Container(
//           width: double.infinity,
//           height: 52,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF7C3AED).withOpacity(0.55),
//                 blurRadius: 20,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: const Center(
//             child: Text(
//               'Sign Up',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.5),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




















