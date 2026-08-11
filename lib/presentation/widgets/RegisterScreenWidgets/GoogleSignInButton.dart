
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ─── Google Sign In Button ────────────────────────────────────────────────────
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/AuthService.dart';
import '../../../utils/GoogleWebViewLogin.dart';
import '../../screen/HomeScreen.dart';
//import 'google_webview_login.dart'; // ← upar banaya hua file import karo
//import 'home_screen.dart';          // ← tumhara HomeScreen

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _isLoading = false; // ← naya

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── NAYA: Google login handle karne wala method
  // Future<void> _handleGoogleLogin() async {
  //   // WebView screen kholo aur result ka intezaar karo
  //   final result = await Navigator.of(context).push<Map<String, String>?>(
  //     MaterialPageRoute(builder: (_) => const GoogleWebViewLogin()),
  //   );
  //
  //   // Agar user ne cancel kiya ya token nahi mila
  //   if (result == null || result['token'] == null) return;
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     // ── Token aur user data save karo
  //     await prefs.setString('auth_token', result['token']!);
  //     await prefs.setString('user_name',  result['name']!);
  //     await prefs.setString('user_id',    result['userId']!);
  //
  //     if (!mounted) return;
  //
  //     // ── HomeScreen pe jao, back stack clear karo
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => const HomeScreen()),
  //           (route) => false,
  //     );
  //
  //   } catch (e) {
  //     debugPrint('Google Login Error: $e');
  //
  //     if (!mounted) return;
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text('Login failed. Please try again.'),
  //         backgroundColor: Colors.red.shade700,
  //         behavior: SnackBarBehavior.floating,
  //         margin: const EdgeInsets.all(16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _handleGoogleLogin() async {
    final result = await Navigator.of(context).push<Map<String, String>?>(
      MaterialPageRoute(builder: (_) => const GoogleWebViewLogin()),
    );

    if (result == null || result['token'] == null) return;

    setState(() => _isLoading = true);

    try {
      // ── SharedPreferences HATAO, AuthService use karo
      // PEHLE THA (ye hatao):
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('auth_token', result['token']!);

      // ── AB YE KARO — AuthService se token save karo
      await AuthService.instance.saveToken(result['token']!);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );

    } catch (e) {
      debugPrint('Google Login Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login failed. Please try again.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.reverse();
        if (!_isLoading) _handleGoogleLogin(); // ← yahan connect kiya
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: _isLoading
          // ── Loading state
              ? const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          )
          // ── Normal state (tumhara existing UI)
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/google.png', width: 22, height: 22),
              const SizedBox(width: 12),
              Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'dart:math' as math;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// // ─── Google Button ────────────────────────────────────────────────────────────
//
// class GoogleSignInButton extends StatefulWidget {
//   const GoogleSignInButton({super.key});
//
//   @override
//   State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
// }
//
// class _GoogleSignInButtonState extends State<GoogleSignInButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );
//
//     _scale = Tween<double>(
//       begin: 1.0,
//       end: 0.96,
//     ).animate(
//       CurvedAnimation(
//         parent: _ctrl,
//         curve: Curves.easeInOut,
//       ),
//     );
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
//       onTapUp: (_) => _ctrl.reverse(),
//       onTapCancel: () => _ctrl.reverse(),
//       child: ScaleTransition(
//         scale: _scale,
//         child: Container(
//           width: double.infinity,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: Colors.white.withOpacity(0.08),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.18),
//               width: 1.2,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               // ✅ Google Icon Added
//               Image.asset(
//                 "assets/google.png",
//                 width: 22,
//                 height: 22,
//               ),
//
//               const SizedBox(width: 12),
//
//               Text(
//                 'Sign in with Google',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.9),
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
