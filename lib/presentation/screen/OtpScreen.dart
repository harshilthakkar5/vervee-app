import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/screen/RegistrationSuccessScreen.dart';
//import 'package:flutter/services.dart';

import '../../domain/model/user/OtpResult.dart';
import '../../utils/NetworkResult.dart';
import '../viewmodal/auth_view_modal/otp/OtpViewModel.dart';
import '../widgets/OtpScreenWidgets/CandleStick.dart';
import '../widgets/OtpScreenWidgets/GoldCoin.dart';
import '../widgets/OtpScreenWidgets/OTPBox.dart';
import '../widgets/OtpScreenWidgets/Particle.dart';
import '../widgets/OtpScreenWidgets/VerifyButton.dart';
import '../widgets/OtpScreenWidgets/WavePainter.dart';
import 'HomeScreen.dart';

// ─── Reuse these from LoginScreen file (already defined there) ────────────────
// Particle, ParticlePainter, WavePainter, _GoldCoin, _CandleStick, _Bar
// Make sure these classes are accessible (same file or imported)

// ─── OTP Screen ───────────────────────────────────────────────────────────────
class OTPScreen extends ConsumerStatefulWidget {

  final String email;
  final String password;   // 👈 NEW

  const OTPScreen({super.key, required this.email, required this.password,});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _entryCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  // final List<TextEditingController> _otpControllers =
  // List.generate(4, (_) => TextEditingController());
  // final List<FocusNode> _focusNodes =
  // List.generate(4, (_) => FocusNode());

  // ✅ CHANGE 1: 6 controllers aur focusNodes
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  int _timerSeconds = 600;
  Timer? _timer;
  bool _canResend = false;

  final List<Particle> _particles = List.generate(55, (i) {
    final rng = math.Random(i * 17 + 3);
    return Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: rng.nextDouble() * 1.8 + 0.4,
      speed: rng.nextDouble() * 0.4 + 0.1,
      opacity: rng.nextDouble() * 0.6 + 0.15,
    );
  });

  @override
  void initState() {
    super.initState();
    _particleCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
    _waveCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
    _glowCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideIn =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
            CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    Future.delayed(
        const Duration(milliseconds: 100), () => _entryCtrl.forward());
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 600;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  String get _timerText {
    final m = _timerSeconds ~/ 60;
    final s = _timerSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _glowCtrl.dispose();
    _entryCtrl.dispose();
    _timer?.cancel();
    for (final c in _otpControllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ── CHANGE 3: Verify handler — ViewModel ko call karta hai
  void _onVerify() {
    FocusScope.of(context).unfocus();

    // 4 boxes ka text join karke ek OTP string banao
    final otp = _otpControllers.map((c) => c.text).join();

    // widget.email — parent (RegisterScreen) se aaya tha
    ref.read(otpViewModelProvider.notifier).verifyOtp(
      email: widget.email,
      otp:   otp,
    );
  }

  @override
  Widget build(BuildContext context) {

    // ── CHANGE 4: ref.listen — OTP verify result suno
    ref.listen<NetworkResult<OtpResult>>(otpViewModelProvider, (_, next) {
      switch (next) {
        case Success():
        // ✅ OTP verify success — Home pe jaao, poora back stack clear karo
        // Login → Register → OTP → Home — teen screens ka stack clear
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => RegistrationSuccessScreen(email: widget.email, password: widget.password)),
                (route) => false,
          );

        case Error(:final message):
        // ✅ Galat OTP ya expired OTP — error dikhao
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ));

        default:
          break;
      }
    });

    // ── CHANGE 5: isLoading — verify button disable karne ke liye
    final isLoading = switch (ref.watch(otpViewModelProvider)) {
      Loading() => true,
      _         => false,
    };

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomBarHeight = screenHeight * 0.18;
    final hPad = screenWidth * 0.07;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── 1. Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF3B0764),
                  Color(0xFF1E0245),
                  Color(0xFF0F0120),
                ],
              ),
            ),
          ),

          // ── 2. Particles
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              painter: ParticlePainter(_particleCtrl.value, _particles),
              child: const SizedBox.expand(),
            ),
          ),

          // ── 3. Bottom wave + coins + candles
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomBarHeight,
            child: IgnorePointer(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _waveCtrl,
                      builder: (_, __) =>
                          CustomPaint(painter: WavePainter(_waveCtrl.value)),
                    ),
                  ),
                  Positioned(
                    bottom: bottomBarHeight * 0.15,
                    left: screenWidth * 0.04,
                    child: GoldCoin(size: screenHeight * 0.05),
                  ),
                  Positioned(
                    bottom: bottomBarHeight * 0.1,
                    right: screenWidth * 0.04,
                    child: GoldCoin(size: screenHeight * 0.06),
                  ),
                  Positioned(
                    bottom: bottomBarHeight * 0.2,
                    left: screenWidth * 0.2,
                    child: CandleStick(),
                  ),
                  Positioned(
                    bottom: bottomBarHeight * 0.15,
                    right: screenWidth * 0.2,
                    child: CandleStick(),
                  ),
                ],
              ),
            ),
          ),

          // ── 4. Main scrollable content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideIn,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
                          child: Column(
                            children: [
                              // ── Email icon with glow
                              AnimatedBuilder(
                                animation: _glowCtrl,
                                builder: (_, __) {
                                  final g = _glowCtrl.value;
                                  return SizedBox(
                                    width: 110,
                                    height: 110,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Glow behind icon
                                        Container(
                                          width: 65 + g * 5,
                                          height: 65 + g * 5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFD4AF37)
                                                    .withOpacity(
                                                    0.35 + 0.25 * g),
                                                blurRadius: 30 + (20 * g),
                                                spreadRadius: 8 + (8 * g),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFF7C3AED)
                                                    .withOpacity(
                                                    0.25 + 0.2 * g),
                                                blurRadius: 45 + (20 * g),
                                                spreadRadius: 4 + (4 * g),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Icon circle
                                        Container(
                                          width: 78,
                                          height: 78,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF9333EA),
                                                Color(0xFF7C3AED),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFD4AF37)
                                                  .withOpacity(0.5 + 0.3 * g),
                                              width: 2.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF9333EA)
                                                    .withOpacity(0.5),
                                                blurRadius: 16,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.mark_email_read_outlined,
                                            color: Color(0xFFFFE566),
                                            size: 34,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // ── Title
                              Text(
                                'Verify your email',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.033,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.008),

                              // ── Subtitle with email highlight
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: screenHeight * 0.019,
                                    height: 1.65,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: "We've sent a 6-digit code to\n"),
                                    TextSpan(
                                      text: widget.email, // ← ab email dikhega
                                     // text: widget.email,
                                      style: const TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.042),

                              // ✅ CHANGE 2: 6 boxes — sahi index, sahi navigation
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //
                              //     // Box 1
                              //     OTPBox(
                              //       controller: _otpControllers[0],
                              //       focusNode:  _focusNodes[0],
                              //       onChanged:  (val) {
                              //         if (val.isNotEmpty) _focusNodes[1].requestFocus();
                              //       },
                              //       onBackspace: () {},  // pehla box — back pe kuch nahi
                              //     ),
                              //     const SizedBox(width: 10),
                              //
                              //     // Box 2
                              //     OTPBox(
                              //       controller: _otpControllers[1],
                              //       focusNode:  _focusNodes[1],
                              //       onChanged:  (val) {
                              //         if (val.isNotEmpty) _focusNodes[2].requestFocus();
                              //         if (val.isEmpty)    _focusNodes[0].requestFocus();
                              //       },
                              //       onBackspace: () {
                              //         _otpControllers[0].clear();
                              //         _focusNodes[0].requestFocus();
                              //       },
                              //     ),
                              //     const SizedBox(width: 10),
                              //
                              //     // Box 3
                              //     OTPBox(
                              //       controller: _otpControllers[2],
                              //       focusNode:  _focusNodes[2],
                              //       onChanged:  (val) {
                              //         if (val.isNotEmpty) _focusNodes[3].requestFocus();
                              //         if (val.isEmpty)    _focusNodes[1].requestFocus();
                              //       },
                              //       onBackspace: () {
                              //         _otpControllers[1].clear();
                              //         _focusNodes[1].requestFocus();
                              //       },
                              //     ),
                              //     const SizedBox(width: 10),
                              //
                              //     // Box 4
                              //     OTPBox(
                              //       controller: _otpControllers[3],
                              //       focusNode:  _focusNodes[3],
                              //       onChanged:  (val) {
                              //         if (val.isNotEmpty) _focusNodes[4].requestFocus();
                              //         if (val.isEmpty)    _focusNodes[2].requestFocus();
                              //       },
                              //       onBackspace: () {
                              //         _otpControllers[2].clear();
                              //         _focusNodes[2].requestFocus();
                              //       },
                              //     ),
                              //     const SizedBox(width: 10),
                              //
                              //     // Box 5
                              //     OTPBox(
                              //       controller: _otpControllers[4],
                              //       focusNode:  _focusNodes[4],
                              //       onChanged:  (val) {
                              //         if (val.isNotEmpty) _focusNodes[5].requestFocus();
                              //         if (val.isEmpty)    _focusNodes[3].requestFocus();
                              //       },
                              //       onBackspace: () {
                              //         _otpControllers[3].clear();
                              //         _focusNodes[3].requestFocus();
                              //       },
                              //     ),
                              //     const SizedBox(width: 10),
                              //
                              //     // Box 6 — last box, aage koi focus nahi
                              //     OTPBox(
                              //       controller: _otpControllers[5],
                              //       focusNode:  _focusNodes[5],
                              //       onChanged:  (val) {
                              //         if (val.isEmpty) _focusNodes[4].requestFocus();
                              //         // ✅ 6th box fill hote hi keyboard band karo
                              //         if (val.isNotEmpty) FocusScope.of(context).unfocus();
                              //       },
                              //       onBackspace: () {
                              //         _otpControllers[4].clear();
                              //         _focusNodes[4].requestFocus();
                              //       },
                              //     ),
                              //   ],
                              // ),

                              // ✅ 6 boxes — FittedBox se wrap kiya taaki overflow na ho
                              SizedBox(
                                width: double.infinity,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      // Box 1
                                      OTPBox(
                                        controller: _otpControllers[0],
                                        focusNode:  _focusNodes[0],
                                        onChanged:  (val) {
                                          if (val.isNotEmpty) _focusNodes[1].requestFocus();
                                        },
                                        onBackspace: () {},
                                      ),
                                      const SizedBox(width: 10),

                                      // Box 2
                                      OTPBox(
                                        controller: _otpControllers[1],
                                        focusNode:  _focusNodes[1],
                                        onChanged:  (val) {
                                          if (val.isNotEmpty) _focusNodes[2].requestFocus();
                                          if (val.isEmpty)    _focusNodes[0].requestFocus();
                                        },
                                        onBackspace: () {
                                          _otpControllers[0].clear();
                                          _focusNodes[0].requestFocus();
                                        },
                                      ),
                                      const SizedBox(width: 10),

                                      // Box 3
                                      OTPBox(
                                        controller: _otpControllers[2],
                                        focusNode:  _focusNodes[2],
                                        onChanged:  (val) {
                                          if (val.isNotEmpty) _focusNodes[3].requestFocus();
                                          if (val.isEmpty)    _focusNodes[1].requestFocus();
                                        },
                                        onBackspace: () {
                                          _otpControllers[1].clear();
                                          _focusNodes[1].requestFocus();
                                        },
                                      ),
                                      const SizedBox(width: 10),

                                      // Box 4
                                      OTPBox(
                                        controller: _otpControllers[3],
                                        focusNode:  _focusNodes[3],
                                        onChanged:  (val) {
                                          if (val.isNotEmpty) _focusNodes[4].requestFocus();
                                          if (val.isEmpty)    _focusNodes[2].requestFocus();
                                        },
                                        onBackspace: () {
                                          _otpControllers[2].clear();
                                          _focusNodes[2].requestFocus();
                                        },
                                      ),
                                      const SizedBox(width: 10),

                                      // Box 5
                                      OTPBox(
                                        controller: _otpControllers[4],
                                        focusNode:  _focusNodes[4],
                                        onChanged:  (val) {
                                          if (val.isNotEmpty) _focusNodes[5].requestFocus();
                                          if (val.isEmpty)    _focusNodes[3].requestFocus();
                                        },
                                        onBackspace: () {
                                          _otpControllers[3].clear();
                                          _focusNodes[3].requestFocus();
                                        },
                                      ),
                                      const SizedBox(width: 10),

                                      // Box 6
                                      OTPBox(
                                        controller: _otpControllers[5],
                                        focusNode:  _focusNodes[5],
                                        onChanged:  (val) {
                                          if (val.isEmpty) _focusNodes[4].requestFocus();
                                          if (val.isNotEmpty) FocusScope.of(context).unfocus();
                                        },
                                        onBackspace: () {
                                          _otpControllers[4].clear();
                                          _focusNodes[4].requestFocus();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // ── Timer row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.07),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.12),
                                      width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.timer_outlined,
                                        color: Colors.white.withOpacity(0.75),
                                        size: 17),
                                    const SizedBox(width: 7),
                                    Text(
                                      'Code expires in  ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.75),
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      _timerText,
                                      style: const TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.032),

                              // ── CHANGE 7: onTap aur isLoading wire kiya
                              // ── Verify Button
                              VerifyButton(
                                // onTap: () {
                                //   final otp = _otpControllers
                                //       .map((c) => c.text)
                                //       .join();
                                //   // TODO: OTP verify logic yahan
                                // },
                                onTap:     isLoading ? null : _onVerify, // ← loading pe disable
                                isLoading: isLoading,
                              ),

                              SizedBox(height: screenHeight * 0.020),

                              // ── Resend row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't receive the code?  ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _canResend
                                        ? () {
                                      for (final c in _otpControllers)
                                        c.clear();
                                      _focusNodes[0].requestFocus();
                                      _startTimer();
                                    }
                                        : null,
                                    child: Text(
                                      'Resend',
                                      style: TextStyle(
                                        color: _canResend
                                            ? const Color(0xFFFFD700)
                                            : const Color(0xFFD4AF37)
                                            .withOpacity(0.38),
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Back button
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back_ios_rounded,
                                        color: Colors.white.withOpacity(0.65),
                                        size: 13),
                                    Text(
                                      'Back to Register',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.65),
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: bottomBarHeight + 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── OTP Single Input Box ─────────────────────────────────────────────────────
// class _OTPBox extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onBackspace;
//
//   const _OTPBox({
//     required this.controller,
//     required this.focusNode,
//     required this.onChanged,
//     required this.onBackspace,
//   });
//
//   @override
//   State<_OTPBox> createState() => _OTPBoxState();
// }
//
// class _OTPBoxState extends State<_OTPBox> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _glow;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));
//     _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     widget.focusNode.addListener(() {
//       widget.focusNode.hasFocus ? _ctrl.forward() : _ctrl.reverse();
//       setState(() {});
//     });
//     widget.controller.addListener(() => setState(() {}));
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
//     final focused = widget.focusNode.hasFocus;
//     final filled = widget.controller.text.isNotEmpty;
//
//     return AnimatedBuilder(
//       animation: _glow,
//       builder: (_, __) => Container(
//         width: 64,
//         height: 68,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: focused
//               ? [
//             BoxShadow(
//               color: const Color(0xFF9333EA)
//                   .withOpacity(0.55 * _glow.value),
//               blurRadius: 20 * _glow.value,
//               spreadRadius: 2 * _glow.value,
//             ),
//           ]
//               : filled
//               ? [
//             BoxShadow(
//               color: const Color(0xFFD4AF37).withOpacity(0.25),
//               blurRadius: 10,
//               spreadRadius: 1,
//             ),
//           ]
//               : [],
//         ),
//         child: TextField(
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           textAlign: TextAlign.center,
//           maxLength: 1,
//           keyboardType: TextInputType.number,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           style: TextStyle(
//             color: filled ? const Color(0xFFFFFFFF) : Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.w800,
//             letterSpacing: 0,
//           ),
//           cursorColor: const Color(0xFFD4AF37),
//           onChanged: (val) {
//             widget.onChanged(val);
//           },
//           decoration: InputDecoration(
//             counterText: '',
//             filled: true,
//             fillColor: filled
//                 ? const Color(0xFF7C3AED).withOpacity(0.22)
//                 : Colors.white.withOpacity(0.09),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(
//                 color: filled
//                     ? const Color(0xFFD4AF37).withOpacity(0.65)
//                     : Colors.white.withOpacity(0.18),
//                 width: filled ? 1.8 : 1.2,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(
//                 color: Color(0xFF9333EA),
//                 width: 2.0,
//               ),
//             ),
//             contentPadding:
//             const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ─── Verify Button ────────────────────────────────────────────────────────────
// class _VerifyButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const _VerifyButton({required this.onTap});
//
//   @override
//   State<_VerifyButton> createState() => _VerifyButtonState();
// }
//
// class _VerifyButtonState extends State<_VerifyButton>
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

// ─── Particle (same as LoginScreen) ──────────────────────────────────────────
// NOTE: Agar LoginScreen aur OTPScreen alag files mein hain to
// in classes ko ek common file mein rakh do aur dono import karein.
// Nahi to yahan copy kar lo:

// // ─── WavePainter ────────────────────────────────────────────────────────────
// class Particle {
//   double x, y, size, speed, opacity;
//   Particle({
//     required this.x,
//     required this.y,
//     required this.size,
//     required this.speed,
//     required this.opacity,
//   });
// }
//
// class ParticlePainter extends CustomPainter {
//   final double animValue;
//   final List<Particle> particles;
//   ParticlePainter(this.animValue, this.particles);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final p in particles) {
//       final y = (p.y - animValue * p.speed * 0.3) % 1.0;
//       final paint = Paint()
//         ..color = Colors.white.withOpacity(p.opacity * 0.6)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
//       canvas.drawCircle(
//           Offset(p.x * size.width, y * size.height), p.size, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(ParticlePainter old) => true;
// }

// // ─── WavePainter ────────────────────────────────────────────────────────────
// class WavePainter extends CustomPainter {
//   final double animValue;
//   WavePainter(this.animValue);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint1 = Paint()
//       ..shader = LinearGradient(
//         colors: [
//           const Color(0xFF6B21A8).withOpacity(0.7),
//           const Color(0xFF9333EA).withOpacity(0.4),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     final path1 = Path();
//     path1.moveTo(0, size.height * 0.45);
//     for (double x = 0; x <= size.width; x++) {
//       final y = size.height * 0.45 +
//           math.sin(
//               (x / size.width * 2 * math.pi) + animValue * 2 * math.pi) *
//               size.height *
//               0.12 +
//           math.sin(
//               (x / size.width * 4 * math.pi) + animValue * 2 * math.pi) *
//               size.height *
//               0.06;
//       path1.lineTo(x, y);
//     }
//     path1.lineTo(size.width, size.height);
//     path1.lineTo(0, size.height);
//     path1.close();
//     canvas.drawPath(path1, paint1);
//
//     final paint2 = Paint()
//       ..color = const Color(0xFF7C3AED).withOpacity(0.35);
//     final path2 = Path();
//     path2.moveTo(0, size.height * 0.6);
//     for (double x = 0; x <= size.width; x++) {
//       final y = size.height * 0.6 +
//           math.sin((x / size.width * 3 * math.pi) +
//               animValue * 2 * math.pi +
//               1.2) *
//               size.height *
//               0.09;
//       path2.lineTo(x, y);
//     }
//     path2.lineTo(size.width, size.height);
//     path2.lineTo(0, size.height);
//     path2.close();
//     canvas.drawPath(path2, paint2);
//   }
//
//   @override
//   bool shouldRepaint(WavePainter old) => true;
// }

// ─── _GoldCoin ────────────────────────────────────────────────────────────
// class _GoldCoin extends StatefulWidget {
//   final double size;
//   const _GoldCoin({required this.size});
//
//   @override
//   State<_GoldCoin> createState() => _GoldCoinState();
// }
//
// class _GoldCoinState extends State<_GoldCoin>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _float;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(seconds: 3))
//       ..repeat(reverse: true);
//     _float = Tween<double>(begin: 0, end: 8)
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
//     return AnimatedBuilder(
//       animation: _float,
//       builder: (_, __) => Transform.translate(
//         offset: Offset(0, -_float.value),
//         child: Container(
//           width: widget.size,
//           height: widget.size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: const RadialGradient(
//               colors: [
//                 Color(0xFFFFD700),
//                 Color(0xFFD4AF37),
//                 Color(0xFFA07820)
//               ],
//               center: Alignment(-0.3, -0.3),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: const Color(0xFFD4AF37).withOpacity(0.5),
//                   blurRadius: 12,
//                   spreadRadius: 2),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               '\$',
//               style: TextStyle(
//                   color: const Color(0xFF7A5500),
//                   fontSize: widget.size * 0.48,
//                   fontWeight: FontWeight.w900),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ─── _CandleStick ────────────────────────────────────────────────────────────
// class _CandleStick extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         _Bar(height: 24, color: const Color(0xFFD4AF37)),
//         const SizedBox(width: 3),
//         _Bar(height: 36, color: const Color(0xFFFFD700)),
//         const SizedBox(width: 3),
//         _Bar(height: 18, color: const Color(0xFFD4AF37)),
//         const SizedBox(width: 3),
//         _Bar(height: 28, color: const Color(0xFFFFD700)),
//       ],
//     );
//   }
// }
//
// class _Bar extends StatelessWidget {
//   final double height;
//   final Color color;
//   const _Bar({required this.height, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 5,
//       height: height,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.75),
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }
// }