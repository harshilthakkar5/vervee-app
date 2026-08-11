
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/NetworkResult.dart';
import '../viewmodal/auth_view_modal/forget_password/ForgetPasswordViewModel.dart';
import '../viewmodal/auth_view_modal/reset_Password/ResetPasswordViewModel.dart';
// import '../viewmodels/forget_password_viewmodel.dart';
// import '../viewmodels/reset_password_viewmodel.dart';

// TODO: adjust import path to match your project structure
// import 'package:vervee_academy/core/network_result.dart'; // NetworkResult<T>

// ─────────────────────────────────────────────────────────────
// Vervee Academy — Reset Password Screen (OTP + New Password)
// Calls: POST /v1/auth/reset-password
// "Resend OTP" reuses: POST /v1/auth/forget-password
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
  static const success = Color(0xFF3ED598);
  static const successBg = Color(0xFF163527);
  static const error = Color(0xFFEF6767);
  static const errorBg = Color(0xFF3A1F22);
}

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // banner shown inline in the form (separate from resend snackbar)
  bool? _bannerIsSuccess;
  String _bannerMessage = 'An OTP has been sent to your email.';

  int _resendSeconds = 600;
  bool _canResend = false;

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

    _bannerIsSuccess = true;
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 600;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (_resendSeconds <= 1) {
        setState(() => _canResend = true);
        return false;
      }
      setState(() => _resendSeconds--);
      return true;
    });
  }

  void _handleResendOtp() {
    if (!_canResend) return;
    HapticFeedback.lightImpact();
    // Reuses the same forget-password endpoint to trigger a fresh OTP
    ref.read(forgetPasswordViewModelProvider.notifier).sendResetOtp(
      email: widget.email,
    );
  }

  void _handleResetPassword() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();
    ref.read(resetPasswordViewModelProvider.notifier).resetPassword(
      email: widget.email,
      otp: _otpController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Reset password result: success → pop back to Login, error → banner
    ref.listen<NetworkResult<String>>(resetPasswordViewModelProvider,
            (previous, next) {
          switch (next) {
            case Success(:final data):
              setState(() {
                _bannerIsSuccess = true;
                _bannerMessage = data; // "Password updated successfully!"
              });
              Future.delayed(const Duration(milliseconds: 900), () {
                if (mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              });

            case Error(:final message):
              setState(() {
                _bannerIsSuccess = false;
                _bannerMessage = message;
              });

            default:
              break;
          }
        });

    // ── Resend OTP result: just refresh the inline banner + restart timer
    ref.listen<NetworkResult<String>>(forgetPasswordViewModelProvider,
            (previous, next) {
          switch (next) {
            case Success(:final data):
              setState(() {
                _bannerIsSuccess = true;
                _bannerMessage = data;
              });
              _startResendTimer();

            case Error(:final message):
              setState(() {
                _bannerIsSuccess = false;
                _bannerMessage = message;
              });

            default:
              break;
          }
        });

    final isResetLoading = switch (ref.watch(resetPasswordViewModelProvider)) {
      Loading() => true,
      _ => false,
    };
    final isResendLoading = switch (ref.watch(forgetPasswordViewModelProvider)) {
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
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildLogo(),
                              const SizedBox(height: 24),
                              _buildFormContent(isResetLoading, isResendLoading),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
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
      width: 130,
      height: 140,
      padding: const EdgeInsets.all(3),
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
              color: AppColors.goldLight, size: 50);
        },
      ),
    );
  }

  // ── Form ─────────────────────────────────────────────────
  Widget _buildFormContent(bool isResetLoading, bool isResendLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Forgot Your Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sent to ${widget.email}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
        ),
        const SizedBox(height: 26),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('OTP'),
              _buildOtpField(isResetLoading),
              const SizedBox(height: 18),
              _buildLabel('New Password'),
              _buildPasswordField(
                controller: _newPasswordController,
                hint: 'Enter new password',
                obscure: _obscureNew,
                enabled: !isResetLoading,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (value) {
                  final v = value ?? '';
                  if (v.isEmpty) return 'Please enter a new password';
                  if (v.length < 8) return 'Minimum 8 characters required';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _buildLabel('Confirm Password'),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: 'Confirm new password',
                obscure: _obscureConfirm,
                enabled: !isResetLoading,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        if (_bannerIsSuccess != null) ...[
          const SizedBox(height: 18),
          _buildBanner(),
        ],
        const SizedBox(height: 22),
        _buildResetButton(isResetLoading),
        const SizedBox(height: 14),
        _buildResendRow(isResendLoading),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOtpField(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextFormField(
        controller: _otpController,
        enabled: !isLoading,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 6,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: AppColors.gold,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          final v = value?.trim() ?? '';
          if (v.isEmpty) return 'Please enter the OTP';
          if (v.length < 4) return 'Enter a valid OTP';
          return null;
        },
        decoration: const InputDecoration(
          counterText: '',
          hintText: 'Enter OTP',
          hintStyle: TextStyle(
              color: AppColors.textMuted, fontSize: 14, letterSpacing: 0),
          prefixIcon: Icon(Icons.password_rounded,
              color: AppColors.textMuted, size: 20),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required bool enabled,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 14.5),
        cursorColor: AppColors.gold,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.lock_outline_rounded,
              color: AppColors.textMuted, size: 20),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
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

  Widget _buildBanner() {
    final isSuccess = _bannerIsSuccess!;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(_bannerMessage),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSuccess ? AppColors.successBg : AppColors.errorBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isSuccess ? AppColors.success : AppColors.error)
                .withOpacity(0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: isSuccess ? AppColors.success : AppColors.error,
              size: 19,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _bannerMessage,
                style: TextStyle(
                  color: isSuccess ? AppColors.success : AppColors.error,
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(bool isLoading) {
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
            onTap: isLoading ? null : _handleResetPassword,
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
                'Reset Password',
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

  Widget _buildResendRow(bool isResendLoading) {
    return TextButton(
      onPressed: (_canResend && !isResendLoading) ? _handleResendOtp : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      child: isResendLoading
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.goldLight),
        ),
      )
          : Text(
        _canResend ? 'Resend OTP' : 'Resend OTP in $_resendSeconds seconds',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _canResend ? AppColors.goldLight : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
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










// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// // ─────────────────────────────────────────────────────────────
// // Vervee Academy — Reset Password Screen (OTP + New Password)
// // Dark navy background + purple/gold brand accents.
// // Drop into `screens/`, wire your Riverpod controller inside
// // `_handleResendOtp()` and `_handleResetPassword()`.
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
//   static const success = Color(0xFF3ED598);
//   static const successBg = Color(0xFF163527);
//   static const error = Color(0xFFEF6767);
//   static const errorBg = Color(0xFF3A1F22);
// }
//
// class ResetPasswordScreen extends StatefulWidget {
//   final String email;
//   const ResetPasswordScreen({super.key, this.email = ''});
//
//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends State<ResetPasswordScreen>
//     with SingleTickerProviderStateMixin {
//   final _otpController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;
//   bool _isLoading = false;
//
//   // banner: null = hidden, true = success, false = error
//   bool? _bannerIsSuccess;
//   String _bannerMessage = '';
//
//   Timer? _resendTimer;
//   int _resendSeconds = 600;
//   bool _canResend = false;
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
//
//     _startResendTimer();
//     _showBanner(true, 'OTP sent successfully! Please check your email.');
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     _animController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startResendTimer() {
//     _resendSeconds = 600;
//     _canResend = false;
//     _resendTimer?.cancel();
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendSeconds <= 1) {
//         timer.cancel();
//         setState(() => _canResend = true);
//       } else {
//         setState(() => _resendSeconds--);
//       }
//     });
//   }
//
//   void _showBanner(bool isSuccess, String message) {
//     setState(() {
//       _bannerIsSuccess = isSuccess;
//       _bannerMessage = message;
//     });
//   }
//
//   Future<void> _handleResendOtp() async {
//     if (!_canResend) return;
//     HapticFeedback.lightImpact();
//
//     // TODO: replace with your Riverpod controller call, e.g.
//     // await ref.read(authControllerProvider.notifier).resendOtp(widget.email);
//
//     _showBanner(true, 'A new OTP has been sent to your email.');
//     _startResendTimer();
//     setState(() {});
//   }
//
//   Future<void> _handleResetPassword() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//     HapticFeedback.lightImpact();
//
//     // TODO: replace with your Riverpod controller call, e.g.
//     // await ref.read(authControllerProvider.notifier).resetPassword(
//     //   email: widget.email,
//     //   otp: _otpController.text.trim(),
//     //   newPassword: _newPasswordController.text,
//     // );
//     await Future.delayed(const Duration(milliseconds: 1400));
//
//     if (!mounted) return;
//     setState(() => _isLoading = false);
//     _showBanner(true, 'Password reset successfully! You can log in now.');
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
//                       const SizedBox(height: 20),
//                       FadeTransition(
//                         opacity: _fadeAnim,
//                         child: SlideTransition(
//                           position: _slideAnim,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               _buildLogo(),
//                               const SizedBox(height: 24),
//                               _buildFormContent(),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
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
//       width: 130,
//       height: 140,
//       padding: const EdgeInsets.all(3),
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
//               color: AppColors.goldLight, size: 50);
//         },
//       ),
//     );
//   }
//
//   // ── Form ─────────────────────────────────────────────────
//   Widget _buildFormContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           'Forgot Your Password?',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 21,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.2,
//           ),
//         ),
//         if (widget.email.isNotEmpty) ...[
//           const SizedBox(height: 8),
//           Text(
//             'Sent to ${widget.email}',
//             style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
//           ),
//         ],
//         const SizedBox(height: 26),
//         Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel('OTP'),
//               _buildOtpField(),
//               const SizedBox(height: 18),
//               _buildLabel('New Password'),
//               _buildPasswordField(
//                 controller: _newPasswordController,
//                 hint: 'Enter new password',
//                 obscure: _obscureNew,
//                 onToggle: () => setState(() => _obscureNew = !_obscureNew),
//                 validator: (value) {
//                   final v = value ?? '';
//                   if (v.isEmpty) return 'Please enter a new password';
//                   if (v.length < 8) return 'Minimum 8 characters required';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 18),
//               _buildLabel('Confirm Password'),
//               _buildPasswordField(
//                 controller: _confirmPasswordController,
//                 hint: 'Confirm new password',
//                 obscure: _obscureConfirm,
//                 onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
//                 validator: (value) {
//                   if (value != _newPasswordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         if (_bannerIsSuccess != null) ...[
//           const SizedBox(height: 18),
//           _buildBanner(),
//         ],
//         const SizedBox(height: 22),
//         _buildResetButton(),
//         const SizedBox(height: 14),
//         _buildResendRow(),
//       ],
//     );
//   }
//
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4, bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white70,
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOtpField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.fieldFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.fieldBorder),
//       ),
//       child: TextFormField(
//         controller: _otpController,
//         keyboardType: TextInputType.number,
//         maxLength: 6,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           letterSpacing: 6,
//           fontWeight: FontWeight.w600,
//         ),
//         cursorColor: AppColors.gold,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         validator: (value) {
//           final v = value?.trim() ?? '';
//           if (v.isEmpty) return 'Please enter the OTP';
//           if (v.length < 4) return 'Enter a valid OTP';
//           return null;
//         },
//         decoration: InputDecoration(
//           counterText: '',
//           hintText: 'Enter OTP',
//           hintStyle: TextStyle(
//               color: AppColors.textMuted, fontSize: 14, letterSpacing: 0),
//           prefixIcon: const Icon(Icons.password_rounded,
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
//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String hint,
//     required bool obscure,
//     required VoidCallback onToggle,
//     required String? Function(String?) validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.fieldFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.fieldBorder),
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         style: const TextStyle(color: Colors.white, fontSize: 14.5),
//         cursorColor: AppColors.gold,
//         validator: validator,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
//           prefixIcon: const Icon(Icons.lock_outline_rounded,
//               color: AppColors.textMuted, size: 20),
//           suffixIcon: IconButton(
//             onPressed: onToggle,
//             icon: Icon(
//               obscure
//                   ? Icons.visibility_off_outlined
//                   : Icons.visibility_outlined,
//               color: AppColors.textMuted,
//               size: 20,
//             ),
//           ),
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
//   Widget _buildBanner() {
//     final isSuccess = _bannerIsSuccess!;
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 250),
//       child: Container(
//         key: ValueKey(_bannerMessage),
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSuccess ? AppColors.successBg : AppColors.errorBg,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: (isSuccess ? AppColors.success : AppColors.error)
//                 .withOpacity(0.4),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(
//               isSuccess
//                   ? Icons.check_circle_rounded
//                   : Icons.error_outline_rounded,
//               color: isSuccess ? AppColors.success : AppColors.error,
//               size: 19,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 _bannerMessage,
//                 style: TextStyle(
//                   color: isSuccess ? AppColors.success : AppColors.error,
//                   fontSize: 13,
//                   height: 1.4,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResetButton() {
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
//             onTap: _isLoading ? null : _handleResetPassword,
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
//                 'Reset Password',
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
//   Widget _buildResendRow() {
//     return TextButton(
//       onPressed: _canResend ? _handleResendOtp : null,
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       ),
//       child: Text(
//         _canResend
//             ? 'Resend OTP'
//             : 'Resend OTP in $_resendSeconds seconds',
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: _canResend ? AppColors.goldLight : AppColors.textMuted,
//         ),
//       ),
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
//           text: const TextSpan(
//             style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
//             children: [
//               TextSpan(text: 'Remembered it? '),
//               TextSpan(
//                 text: 'Back to Login',
//                 style: TextStyle(
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
//       home: const ResetPasswordScreen(email: 'tunade6hogake@gmail.com'),
//     );
//   }
// }