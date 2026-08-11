
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── Verify Button ────────────────────────────────────────────────────────────

class VerifyButton extends StatefulWidget {
  // ── CHANGE 1: VoidCallback? — null allow karo (loading pe button disable)
  // Pehle: required VoidCallback onTap  → null nahi ho sakta tha
  // Ab:    VoidCallback? onTap          → null = disabled
  final VoidCallback? onTap;

  // ── CHANGE 2: isLoading parameter add kiya
  // True  → CircularProgressIndicator dikhao, tap disable
  // False → Normal "Verify OTP" text dikhao
  final bool isLoading;

  const VerifyButton({
    super.key,
    required this.onTap,
    this.isLoading = false, // ← default false — pehle wala behavior same rahega
  });

  @override
  State<VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<VerifyButton>
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
    // ── CHANGE 3: isLoading ya onTap null ho toh disabled
    // disabled = true  → tap karne pe kuch nahi hoga
    // disabled = false → normal animation + callback
    final disabled = widget.isLoading || widget.onTap == null;

    return GestureDetector(
      // ── CHANGE 4: disabled ho toh null pass karo — tap block ho jaata hai
      onTapDown:  disabled ? null : (_) => _ctrl.forward(),
      onTapUp:    disabled ? null : (_) async {
        await _ctrl.reverse();
        widget.onTap?.call(); // ← ?. safe call — null check
      },
      onTapCancel: disabled ? null : () => _ctrl.reverse(),

      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          // ── CHANGE 5: AnimatedContainer — opacity smoothly change hogi
          // disabled ho toh button thoda dim dikhega
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              // ── CHANGE 6: disabled ho toh colors dim karo
              colors: disabled
                  ? [const Color(0xFF9333EA).withOpacity(0.5),
                const Color(0xFF7C3AED).withOpacity(0.5)]
                  : [const Color(0xFF9333EA),
                const Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: disabled
            // ── CHANGE 7: disabled ho toh glow hatao
                ? []
                : [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.70),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.40),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            // ── CHANGE 8: isLoading ho toh loader, warna text
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
              'Verify OTP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//----------------------------------- before api call ----------------------------------------------->


// class VerifyButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const VerifyButton({required this.onTap});
//
//   @override
//   State<VerifyButton> createState() => _VerifyButtonState();
// }
//
// class _VerifyButtonState extends State<VerifyButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 120));
//     _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
//         CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
//               colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF9333EA).withOpacity(0.70),
//                 blurRadius: 28,
//                 offset: const Offset(0, 8),
//               ),
//               BoxShadow(
//                 color: const Color(0xFF7C3AED).withOpacity(0.40),
//                 blurRadius: 12,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: const Center(
//             child: Text(
//               'Verify OTP',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.8,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }