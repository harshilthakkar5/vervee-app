
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/NetworkResult.dart';
import '../viewmodal/auth_view_modal/forget_password/ForgetPasswordViewModel.dart';
//import '../viewmodels/forget_password_viewmodel.dart';
import 'ResetPasswordScreen.dart';
//import 'reset_password_screen.dart';

// TODO: adjust import path to match your project structure
// import 'package:vervee_academy/core/network_result.dart'; // NetworkResult<T>

// ─────────────────────────────────────────────────────────────
// Vervee Academy — Forgot Password Screen (Mobile)
// Calls: POST /v1/auth/forget-password
// On success → navigates to ResetPasswordScreen(email: ...)
// ─────────────────────────────────────────────────────────────

class AppColors {
  static const bgDark = Color(0xFF12141C);
  static const bgDark2 = Color(0xFF1A1D2A);
  static const purple = Color(0xFF7B3FE4);
  static const purpleDeep = Color(0xFF4E2AA8);
  static const gold = Color(0xFFE8B24D);
  static const goldLight = Color(0xFFF3D08A);
  static const textMuted = Color(0xFF8B90A3);
  static const fieldFill = Color(0xFF20232F);
  static const fieldBorder = Color(0xFF2E3244);
}

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();

    // ref.read — one-off action, button tap
    ref.read(forgetPasswordViewModelProvider.notifier).sendResetOtp(
      email: _emailController.text,
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    // ── ref.listen — side effects on state change
    // Success → navigate to ResetPasswordScreen with the email
    // Error   → SnackBar
    ref.listen<NetworkResult<String>>(forgetPasswordViewModelProvider,
            (previous, next) {
          switch (next) {
            case Success(:final data):
              _showSnack(data); // e.g. "Reset password OTP has been sent..."
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResetPasswordScreen(
                    email: _emailController.text.trim(),
                  ),
                ),
              );

            case Error(:final message):
              _showSnack(message, isError: true);

            default:
              break;
          }
        });

    // ── isLoading — button disable/spinner ke liye
    final isLoading = switch (ref.watch(forgetPasswordViewModelProvider)) {
      Loading() => true,
      _ => false,
    };

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          _buildBackgroundGlow(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildBackButton(context),
                      const Spacer(flex: 2),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildLogo(),
                              const SizedBox(height: 28),
                              _buildFormContent(isLoading),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      _buildFooter(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ──────────────────────────────────────────
  Widget _buildBackgroundGlow() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.bgDark2, AppColors.bgDark],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
            Positioned(
              top: -140,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.purple.withOpacity(0.35),
                      AppColors.purple.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -160,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withOpacity(0.12),
                      AppColors.gold.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white70, size: 18),
      ),
    );
  }

  // ── Logo (image asset) ───────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 150,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Image.asset(
        'assets/vervee_app_icon_bgr.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.shield_rounded,
              color: AppColors.goldLight, size: 56);
        },
      ),
    );
  }

  // ── Form content ─────────────────────────────────────────
  Widget _buildFormContent(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Forgot Your Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Enter the email linked to your account and\nwe\'ll send you an OTP.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildEmailField(isLoading),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _buildSubmitButton(isLoading),
      ],
    );
  }

  Widget _buildEmailField(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextFormField(
        controller: _emailController,
        enabled: !isLoading,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: Colors.white, fontSize: 14.5),
        cursorColor: AppColors.gold,
        onFieldSubmitted: (_) => _handleSubmit(),
        validator: (value) {
          final v = value?.trim() ?? '';
          if (v.isEmpty) return 'Please enter your email';
          final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
          if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Enter your email',
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.mail_outline_rounded,
              color: AppColors.textMuted, size: 20),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [AppColors.purple, AppColors.purpleDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: isLoading ? null : _handleSubmit,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
            children: [
              TextSpan(text: 'Remembered it? '),
              TextSpan(
                text: 'Back to Login',
                style: TextStyle(
                  color: AppColors.goldLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'ResetPasswordScreen.dart';
//
// // ─────────────────────────────────────────────────────────────
// // Vervee Academy — Forgot Password Screen (Mobile)
// // Dark navy background + purple/gold brand accents.
// // Drop this file into your `screens/` folder and wire up
// // your Riverpod controller inside `_handleSubmit()`.
// // ─────────────────────────────────────────────────────────────
//
// class AppColors {
//   static const bgDark = Color(0xFF12141C);
//   static const bgDark2 = Color(0xFF1A1D2A);
//   static const purple = Color(0xFF7B3FE4);
//   static const purpleDeep = Color(0xFF4E2AA8);
//   static const gold = Color(0xFFE8B24D);
//   static const goldLight = Color(0xFFF3D08A);
//   static const textMuted = Color(0xFF8B90A3);
//   static const fieldFill = Color(0xFF20232F);
//   static const fieldBorder = Color(0xFF2E3244);
// }
//
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
//     with SingleTickerProviderStateMixin {
//   final _emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _isLoading = false;
//   bool _emailSent = false;
//
//   late final AnimationController _animController;
//   late final Animation<double> _fadeAnim;
//   late final Animation<Offset> _slideAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.06),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
//     _animController.forward();
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _animController.dispose();
//     super.dispose();
//   }
//
//   void resetpasword() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
//   );
// }
//
//   Future<void> _handleSubmit() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//     HapticFeedback.lightImpact();
//
//     // TODO: replace with your Riverpod controller call, e.g.
//     // await ref.read(authControllerProvider.notifier).sendResetLink(_emailController.text.trim());
//     await Future.delayed(const Duration(milliseconds: 1400));
//
//     if (!mounted) return;
//     setState(() {
//       _isLoading = false;
//       _emailSent = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgDark,
//       body: Stack(
//         children: [
//           _buildBackgroundGlow(),
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: MediaQuery.of(context).size.height -
//                       MediaQuery.of(context).padding.top -
//                       MediaQuery.of(context).padding.bottom,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 8),
//                       _buildBackButton(context),
//                       const Spacer(flex: 2),
//                       FadeTransition(
//                         opacity: _fadeAnim,
//                         child: SlideTransition(
//                           position: _slideAnim,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               _buildLogo(),
//                               const SizedBox(height: 28),
//                               _emailSent ? _buildSuccessContent() : _buildFormContent(),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const Spacer(flex: 3),
//                       _buildFooter(context),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Background ──────────────────────────────────────────
//   Widget _buildBackgroundGlow() {
//     return Positioned.fill(
//       child: IgnorePointer(
//         child: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [AppColors.bgDark2, AppColors.bgDark],
//                   stops: [0.0, 0.5],
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -140,
//               left: -80,
//               child: Container(
//                 width: 320,
//                 height: 320,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       AppColors.purple.withOpacity(0.35),
//                       AppColors.purple.withOpacity(0.0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -160,
//               right: -100,
//               child: Container(
//                 width: 300,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       AppColors.gold.withOpacity(0.12),
//                       AppColors.gold.withOpacity(0.0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBackButton(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: () => Navigator.of(context).maybePop(),
//       child: Container(
//         width: 42,
//         height: 42,
//         decoration: BoxDecoration(
//           color: AppColors.fieldFill,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.fieldBorder),
//         ),
//         child: const Icon(Icons.arrow_back_ios_new_rounded,
//             color: Colors.white70, size: 18),
//       ),
//     );
//   }
//
//   // ── Logo (image asset) ───────────────────────────────────
//   Widget _buildLogo() {
//     return Container(
//       width: 140,
//       height: 150,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.purple.withOpacity(0.25),
//             blurRadius: 20,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Image.asset(
//         'assets/vervee_app_icon_bgr.png',
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) {
//           // Fallback if the asset isn't found yet, so the screen never breaks.
//           return const Icon(Icons.shield_rounded,
//               color: AppColors.goldLight, size: 56);
//         },
//       ),
//     );
//   }
//
//   // ── Form content ─────────────────────────────────────────
//   Widget _buildFormContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           'Forgot Your Password?',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'Enter the email linked to your account and\nwe\'ll send you a reset link.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: AppColors.textMuted,
//             fontSize: 13.5,
//             height: 1.5,
//           ),
//         ),
//         const SizedBox(height: 32),
//         Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 4, bottom: 8),
//                 child: Text(
//                   'Email',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               _buildEmailField(),
//             ],
//           ),
//         ),
//         const SizedBox(height: 22),
//         _buildSubmitButton(),
//       ],
//     );
//   }
//
//   Widget _buildEmailField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.fieldFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.fieldBorder),
//       ),
//       child: TextFormField(
//         controller: _emailController,
//         keyboardType: TextInputType.emailAddress,
//         textInputAction: TextInputAction.done,
//         style: const TextStyle(color: Colors.white, fontSize: 14.5),
//         cursorColor: AppColors.gold,
//         onFieldSubmitted: (_) => _handleSubmit(),
//         validator: (value) {
//           final v = value?.trim() ?? '';
//           if (v.isEmpty) return 'Please enter your email';
//           final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
//           if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
//           return null;
//         },
//         decoration: InputDecoration(
//           hintText: 'Enter your email',
//           hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
//           prefixIcon: const Icon(Icons.mail_outline_rounded,
//               color: AppColors.textMuted, size: 20),
//           border: InputBorder.none,
//           errorBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedErrorBorder: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: const LinearGradient(
//             colors: [AppColors.purple, AppColors.purpleDeep],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.purple.withOpacity(0.35),
//               blurRadius: 18,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(14),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(14),
//             onTap: resetpasword, //_isLoading ? null : _handleSubmit,
//             child: Center(
//               child: _isLoading
//                   ? const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.4,
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                 ),
//               )
//                   : const Text(
//                 'Submit',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── Success state ────────────────────────────────────────
//   Widget _buildSuccessContent() {
//     return Column(
//       children: [
//         Container(
//           width: 72,
//           height: 72,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: const LinearGradient(
//               colors: [AppColors.gold, AppColors.goldLight],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.gold.withOpacity(0.35),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: const Icon(Icons.mark_email_read_rounded,
//               color: AppColors.bgDark, size: 34),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           'Check Your Inbox',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: AppColors.textMuted, fontSize: 13.5, height: 1.5),
//         ),
//         const SizedBox(height: 28),
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: OutlinedButton(
//             onPressed: () => setState(() => _emailSent = false),
//             style: OutlinedButton.styleFrom(
//               side: const BorderSide(color: AppColors.fieldBorder),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             child: const Text(
//               'Resend Email',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFooter(BuildContext context) {
//     return Center(
//       child: TextButton(
//         onPressed: () => Navigator.of(context).maybePop(),
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//         ),
//         child: RichText(
//           text: TextSpan(
//             style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
//             children: [
//               const TextSpan(text: 'Remembered it? '),
//               TextSpan(
//                 text: 'Back to Login',
//                 style: const TextStyle(
//                   color: AppColors.goldLight,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Standalone preview entry point (optional) ───────────────
// void main() {
//   runApp(const _PreviewApp());
// }
//
// class _PreviewApp extends StatelessWidget {
//   const _PreviewApp();
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const ForgotPasswordScreen(),
//     );
//   }
// }

//-------------------- using everywhere ---------------------------------------->

// void resetpasword() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
//   );
// }