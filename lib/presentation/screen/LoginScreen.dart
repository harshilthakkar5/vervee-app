import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/screen/HomeScreen.dart';
import '../../domain/model/user/AuthUser.dart';
import '../../utils/AuthService.dart';
import '../../utils/NetworkResult.dart';
import '../viewmodal/auth_view_modal/login/LoginViewModel.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../widgets/LoginScreenWidgets/CandleStick.dart';
import '../widgets/LoginScreenWidgets/GlowTextField.dart';
import '../widgets/LoginScreenWidgets/GoldCoin.dart';
import '../widgets/LoginScreenWidgets/GoogleSignInButton.dart';
import '../widgets/LoginScreenWidgets/Particle.dart';
import '../widgets/LoginScreenWidgets/RippleLoginButton.dart';
import '../widgets/LoginScreenWidgets/WavePainter.dart';
import 'ForgotPasswordScreen.dart';
import 'RegisterScreen.dart';
    //hide Particle, ParticlePainter, WavePainter;


class LoginScreen extends ConsumerStatefulWidget {

  final String? prefillEmail;
  final String? prefillPassword;

  const LoginScreen({super.key,  this.prefillEmail,  this.prefillPassword});

 // const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {

  // ── CHANGE 3: Controllers add kiye — email aur password ke liye
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late AnimationController _particleCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _shieldGlowCtrl;
  late AnimationController _entryCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  bool _rememberMe = false;

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
    AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _waveCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
    _shieldGlowCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _entryCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 100), () => _entryCtrl.forward());

    // ── CHANGE: Pehle check karo ki Registration se prefill email/password aaya hai ya nahi
    if ((widget.prefillEmail?.isNotEmpty ?? false) ||
        (widget.prefillPassword?.isNotEmpty ?? false)) {
      _emailCtrl.text    = widget.prefillEmail ?? '';
      _passwordCtrl.text = widget.prefillPassword ?? '';
      // Registration se aaya hai matlab user abhi-abhi register hua —
      // Remember Me bhi ON kar do taaki agli baar bhi yaad rahe (optional)
      _rememberMe = true;
    } else {
      // Prefill nahi mila to Remember Me wala saved data try karo
      _loadSavedCredentials();
    }
    //_loadSavedCredentials();
  }

  @override
  void dispose() {

    // ── CHANGE 4: Naye controllers dispose karo
    _emailCtrl.dispose();
    _passwordCtrl.dispose();

    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _shieldGlowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── CHANGE: Naya method — SecureStorage se email/password restore karta hai
  Future<void> _loadSavedCredentials() async {
    final saved = await AuthService.instance.getSavedCredentials();

    // Sirf tab fill karo jab Remember Me ON tha aur fields empty hain
    if (saved.remember && mounted) {
      setState(() {
        _rememberMe            = true;
        _emailCtrl.text        = saved.email;
        _passwordCtrl.text     = saved.password;
      });
    }
  }

  // ── CHANGE 5: Login handler — ViewModel ko call karta hai
  void _onLogin() {
    // Keyboard band karo
    FocusScope.of(context).unfocus();

    // ref.read — ek baar ka action, button tap
    ref.read(loginViewModelProvider.notifier).login(
      email:    _emailCtrl.text,
      password: _passwordCtrl.text,
      rememberMe: _rememberMe, // ← CHANGE: yeh add kiya
    );
  }

  void forgtscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    // ── CHANGE 6: ref.listen — state changes suno
    // Success → HomeScreen navigate karo
    // Error   → SnackBar dikhao
    ref.listen<NetworkResult<AuthUser>>(loginViewModelProvider, (_, next) {
      switch (next) {
        case Success():

        // ✅ NAYA — providers invalidate karo taaki HomeScreen naye user/token
        // ke saath fresh profile/feed/subscription load kare
          ref.invalidate(profileInfoViewModelProvider);
          ref.invalidate(userFeedViewModelProvider);
          ref.invalidate(subscriptionViewModelProvider);
          ref.invalidate(avatarViewModelProvider);

        // ✅ Login success — Home pe jaao, back stack clear karo
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false, // ← back press se login pe nahi jaayega
          );

        case Error(:final message):
        // ✅ Validation ya API error — SnackBar dikhao
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

    // ── CHANGE 7: isLoading — button disable karne ke liye
    final isLoading = switch (ref.watch(loginViewModelProvider)) {
      Loading() => true,
      _         => false,
    };

    // ── Device size for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    final logoSize = screenHeight * 0.16;          // ~130px on 800px screen
    final bottomBarHeight = screenHeight * 0.18;   // wave + coins area
    final hPad = screenWidth * 0.07;               // horizontal padding

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── 1. Background gradient (full screen)
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

          // ── 2. Particles (full screen, behind everything)
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              painter: ParticlePainter(_particleCtrl.value, _particles),
              child: const SizedBox.expand(),
            ),
          ),

          // ── 3. Wave + Coins + Candles FIXED at bottom
          //       These never scroll — they stay in place always
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomBarHeight,
            child: IgnorePointer(   // ← wrap karo
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Wave
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _waveCtrl,
                      builder: (_, __) =>
                          CustomPaint(painter: WavePainter(_waveCtrl.value)),
                    ),
                  ),
                  // Left coin
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.15,
                  //   left: screenWidth * 0.04,
                  //   child: GoldCoin(size: screenHeight * 0.05),
                  // ),
                  // // Right coin
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.1,
                  //   right: screenWidth * 0.04,
                  //   child: GoldCoin(size: screenHeight * 0.06),
                  // ),
                  // // Left candle
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.2,
                  //   left: screenWidth * 0.2,
                  //   child: CandleStick(),
                  // ),
                  // // Right candle
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.15,
                  //   right: screenWidth * 0.2,
                  //   child: CandleStick(),
                  // ),
                ],
              ),
            ),
          ),

          // ── 4. Main content — Column with Expanded
          //       Content fills available space, bottom bar is reserved
          SafeArea(
            child: Column(
              children: [
                // ── Scrollable form content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideIn,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
                          child: Column(
                            children: [
                              // ── Logo
                              AnimatedBuilder(
                                animation: _shieldGlowCtrl,
                                builder: (_, __) {
                                  final glow = _shieldGlowCtrl.value;
                                  return SizedBox(
                                    width: logoSize,
                                    height: logoSize,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Glow circle behind logo
                                        Container(
                                          width: logoSize * 0.55 + (glow * 4),
                                          height: logoSize * 0.55 + (glow * 4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF030900) // 0xFFD4AF37
                                                    .withOpacity(0.35 + 0.25 * glow),
                                                blurRadius: 30 + (20 * glow),
                                                spreadRadius: 8 + (8 * glow),
                                              ),
                                              BoxShadow(
                                                color: const Color(0xFF7C3AED)
                                                    .withOpacity(0.25 + 0.2 * glow),
                                                blurRadius: 45 + (20 * glow),
                                                spreadRadius: 4 + (4 * glow),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Logo image
                                        Image.asset(
                                          'assets/vervee_app_icon_bgr.png',
                                          width: logoSize,
                                          height: logoSize,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // ── Welcome text
                              Text(
                                'Ready to Learn?',//'Welcome Back!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.033,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.006),
                              Text(
                                'Sign in to continue or create your account.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: screenHeight * 0.018,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),

                              Text(
                                'SKILL · HUSTLE · PROSPER',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                                  //fontSize: size.height * 0.014,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.035),

                              // ── Email
                               GlowTextField(
                                controller: _emailCtrl,   // ← naya
                                hint: 'Email',
                                prefixIcon: Icons.mail_outline_rounded,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Password
                               GlowTextField(
                                controller: _passwordCtrl, // ← naya
                                hint: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                              ),
                              SizedBox(height: screenHeight * 0.014),

                              // ── Remember me + Forgot
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: _rememberMe
                                                ? const Color(0xFF7C3AED)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: _rememberMe
                                                  ? const Color(0xFF7C3AED)
                                                  : Colors.white.withOpacity(0.4),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: _rememberMe
                                              ? const Icon(Icons.check,
                                              size: 13, color: Colors.white)
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Remember me',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.75),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: forgtscreen,
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Color(0xFFD4AF37),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.024),

                              // ── CHANGE 10: onTap aur isLoading wire kiya
                              // ── Login Button
                              RippleLoginButton(

                                  onTap:     isLoading ? null : _onLogin, // ← loading pe disable
                                  isLoading: isLoading,
                              //
                              //     onTap: () {
                              //   Navigator.push(context, MaterialPageRoute(
                              //       builder: (_) => const HomeScreen()
                              //   ));
                              // }

                              ),

                              SizedBox(height: screenHeight * 0.018),

                              // ── Or divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                        color: Colors.white.withOpacity(0.18),
                                        thickness: 1),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Or',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.45),
                                          fontSize: 14),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                        color: Colors.white.withOpacity(0.18),
                                        thickness: 1),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Google Button
                              const GoogleSignInButton(),

                              SizedBox(height: screenHeight * 0.018),

                              // ── Sign Up
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 13.5),
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                      // Login screen mein Sign Up button pe:
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (_) => const RegisterScreen()
                                      ));

                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xFFD4AF37),
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Bottom padding so content doesn't go under wave
                              SizedBox(height: bottomBarHeight + 8),
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





// ─── Particle ────────────────────────────────────────────────────────────────
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
//       canvas.drawCircle(Offset(p.x * size.width, y * size.height), p.size, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(ParticlePainter old) => true;
// }

// ─── Wave Painter ─────────────────────────────────────────────────────────────
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
//           math.sin((x / size.width * 2 * math.pi) + animValue * 2 * math.pi) *
//               size.height * 0.12 +
//           math.sin((x / size.width * 4 * math.pi) + animValue * 2 * math.pi) *
//               size.height * 0.06;
//       path1.lineTo(x, y);
//     }
//     path1.lineTo(size.width, size.height);
//     path1.lineTo(0, size.height);
//     path1.close();
//     canvas.drawPath(path1, paint1);
//
//     final paint2 = Paint()..color = const Color(0xFF7C3AED).withOpacity(0.35);
//     final path2 = Path();
//     path2.moveTo(0, size.height * 0.6);
//     for (double x = 0; x <= size.width; x++) {
//       final y = size.height * 0.6 +
//           math.sin((x / size.width * 3 * math.pi) + animValue * 2 * math.pi + 1.2) *
//               size.height * 0.09;
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

// ─── Glow Text Field ──────────────────────────────────────────────────────────
// class GlowTextField extends StatefulWidget {
//   final String hint;
//   final IconData prefixIcon;
//   final bool isPassword;
//
//   const GlowTextField({
//     super.key,
//     required this.hint,
//     required this.prefixIcon,
//     this.isPassword = false,
//   });
//
//   @override
//   State<GlowTextField> createState() => _GlowTextFieldState();
// }
//
// class _GlowTextFieldState extends State<GlowTextField>
//     with SingleTickerProviderStateMixin {
//   bool _obscure = true;
//   bool _focused = false;
//   late AnimationController _ctrl;
//   late Animation<double> _glowAnim;
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
//     _glowAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _focusNode.addListener(() {
//       setState(() => _focused = _focusNode.hasFocus);
//       _focusNode.hasFocus ? _ctrl.forward() : _ctrl.reverse();
//     });
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _glowAnim,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused
//                 ? [
//               BoxShadow(
//                 color: const Color(0xFF9333EA).withOpacity(0.5 * _glowAnim.value),
//                 blurRadius: 18 * _glowAnim.value,
//                 spreadRadius: 2 * _glowAnim.value,
//               ),
//             ]
//                 : [],
//           ),
//           child: TextField(
//             focusNode: _focusNode,
//             obscureText: widget.isPassword && _obscure,
//             style: const TextStyle(color: Colors.white, fontSize: 15),
//             cursorColor: const Color(0xFFD4AF37),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 15),
//               prefixIcon: Icon(
//                 widget.prefixIcon,
//                 color: _focused ? const Color(0xFFD4AF37) : Colors.white.withOpacity(0.5),
//                 size: 20,
//               ),
//               suffixIcon: widget.isPassword
//                   ? GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Icon(
//                   _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                   color: Colors.white.withOpacity(0.5),
//                   size: 20,
//                 ),
//               )
//                   : null,
//               filled: true,
//               fillColor: Colors.white.withOpacity(0.09),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.2),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Color(0xFF9333EA), width: 1.8),
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// ─── Ripple Login Button ──────────────────────────────────────────────────────
// class RippleLoginButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const RippleLoginButton({super.key, required this.onTap});
//
//   @override
//   State<RippleLoginButton> createState() => _RippleLoginButtonState();
// }
//
// class _RippleLoginButtonState extends State<RippleLoginButton>
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
//               'Login',
//               style: TextStyle(
//                   color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.5),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ─── Google Sign In Button ────────────────────────────────────────────────────
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
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
//     _scale = Tween<double>(begin: 1.0, end: 0.96)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() => _ctrl.dispose();
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
//             border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.2),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CustomPaint(painter: _GoogleLogoPainter()),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Sign in with Google',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _GoogleLogoPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final r = size.width / 2;
//     final colors = [
//       const Color(0xFF4285F4),
//       const Color(0xFF34A853),
//       const Color(0xFFFBBC05),
//       const Color(0xFFEA4335),
//     ];
//     for (int i = 0; i < 4; i++) {
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         -math.pi / 2 + i * math.pi / 2,
//         math.pi / 2,
//         true,
//         Paint()..color = colors[i],
//       );
//     }
//     canvas.drawCircle(Offset(cx, cy), r * 0.55, Paint()..color = const Color(0xFF1A0A2E));
//     canvas.drawRect(
//       Rect.fromLTWH(cx, cy - r * 0.12, r, r * 0.24),
//       Paint()..color = const Color(0xFF4285F4),
//     );
//   }
//
//   @override
//   bool shouldRepaint(_) => false;
// }

// ─── Gold Coin ────────────────────────────────────────────────────────────────
// class _GoldCoin extends StatefulWidget {
//   final double size;
//   const _GoldCoin({required this.size});
//
//   @override
//   State<_GoldCoin> createState() => _GoldCoinState();
// }
//
// class _GoldCoinState extends State<_GoldCoin> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _float;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
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
//               colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFA07820)],
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

// // ─── Candle Stick ─────────────────────────────────────────────────────────────
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







// ─── LOGIN SCREEN ─────────────────────────────────────────────────────────────
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
//   late AnimationController _particleCtrl;
//   late AnimationController _waveCtrl;
//   late AnimationController _shieldGlowCtrl;
//   late AnimationController _entryCtrl;
//
//   late Animation<double> _fadeIn;
//   late Animation<Offset> _slideIn;
//
//   bool _rememberMe = true;
//
//   final List<Particle> _particles = List.generate(55, (i) {
//     final rng = math.Random(i * 17 + 3);
//     return Particle(
//       x: rng.nextDouble(),
//       y: rng.nextDouble(),
//       size: rng.nextDouble() * 1.8 + 0.4,
//       speed: rng.nextDouble() * 0.4 + 0.1,
//       opacity: rng.nextDouble() * 0.6 + 0.15,
//     );
//   });
//
//   @override
//   void initState() {
//     super.initState();
//     _particleCtrl =
//     AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
//     _waveCtrl =
//     AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
//     _shieldGlowCtrl =
//     AnimationController(vsync: this, duration: const Duration(seconds: 2))
//       ..repeat(reverse: true);
//     _entryCtrl =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
//     _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
//     _slideIn = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
//     Future.delayed(const Duration(milliseconds: 100), () => _entryCtrl.forward());
//   }
//
//   @override
//   void dispose() {
//     _particleCtrl.dispose();
//     _waveCtrl.dispose();
//     _shieldGlowCtrl.dispose();
//     _entryCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ── Device size for responsive sizing
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Responsive values
//     final logoSize = screenHeight * 0.16;          // ~130px on 800px screen
//     final bottomBarHeight = screenHeight * 0.18;   // wave + coins area
//     final hPad = screenWidth * 0.07;               // horizontal padding
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           // ── 1. Background gradient (full screen)
//           Container(
//             decoration: const BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment(0.0, -0.3),
//                 radius: 1.2,
//                 colors: [
//                   Color(0xFF3B0764),
//                   Color(0xFF1E0245),
//                   Color(0xFF0F0120),
//                 ],
//               ),
//             ),
//           ),
//
//           // ── 2. Particles (full screen, behind everything)
//           AnimatedBuilder(
//             animation: _particleCtrl,
//             builder: (_, __) => CustomPaint(
//               painter: ParticlePainter(_particleCtrl.value, _particles),
//               child: const SizedBox.expand(),
//             ),
//           ),
//
//           // ── 3. Wave + Coins + Candles FIXED at bottom
//           //       These never scroll — they stay in place always
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: bottomBarHeight,
//             child: IgnorePointer(   // ← wrap karo
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Wave
//                 Positioned.fill(
//                   child: AnimatedBuilder(
//                     animation: _waveCtrl,
//                     builder: (_, __) =>
//                         CustomPaint(painter: WavePainter(_waveCtrl.value)),
//                   ),
//                 ),
//                 // Left coin
//                 Positioned(
//                   bottom: bottomBarHeight * 0.15,
//                   left: screenWidth * 0.04,
//                   child: GoldCoin(size: screenHeight * 0.05),
//                 ),
//                 // Right coin
//                 Positioned(
//                   bottom: bottomBarHeight * 0.1,
//                   right: screenWidth * 0.04,
//                   child: GoldCoin(size: screenHeight * 0.06),
//                 ),
//                 // Left candle
//                 Positioned(
//                   bottom: bottomBarHeight * 0.2,
//                   left: screenWidth * 0.2,
//                   child: CandleStick(),
//                 ),
//                 // Right candle
//                 Positioned(
//                   bottom: bottomBarHeight * 0.15,
//                   right: screenWidth * 0.2,
//                   child: CandleStick(),
//                 ),
//               ],
//             ),
//             ),
//           ),
//
//           // ── 4. Main content — Column with Expanded
//           //       Content fills available space, bottom bar is reserved
//           SafeArea(
//             child: Column(
//               children: [
//                 // ── Scrollable form content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: FadeTransition(
//                       opacity: _fadeIn,
//                       child: SlideTransition(
//                         position: _slideIn,
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
//                           child: Column(
//                             children: [
//                               // ── Logo
//                               AnimatedBuilder(
//                                 animation: _shieldGlowCtrl,
//                                 builder: (_, __) {
//                                   final glow = _shieldGlowCtrl.value;
//                                   return SizedBox(
//                                     width: logoSize,
//                                     height: logoSize,
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         // Glow circle behind logo
//                                         Container(
//                                           width: logoSize * 0.55 + (glow * 4),
//                                           height: logoSize * 0.55 + (glow * 4),
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: const Color(0xFFD4AF37)
//                                                     .withOpacity(0.35 + 0.25 * glow),
//                                                 blurRadius: 30 + (20 * glow),
//                                                 spreadRadius: 8 + (8 * glow),
//                                               ),
//                                               BoxShadow(
//                                                 color: const Color(0xFF7C3AED)
//                                                     .withOpacity(0.25 + 0.2 * glow),
//                                                 blurRadius: 45 + (20 * glow),
//                                                 spreadRadius: 4 + (4 * glow),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         // Logo image
//                                         Image.asset(
//                                           'assets/logo.png',
//                                           width: logoSize,
//                                           height: logoSize,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//
//                               SizedBox(height: screenHeight * 0.025),
//
//                               // ── Welcome text
//                               Text(
//                                 'Welcome Back!',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: screenHeight * 0.033,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: 0.3,
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.006),
//                               Text(
//                                 'Login to your account',
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.55),
//                                   fontSize: screenHeight * 0.018,
//                                 ),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.035),
//
//                               // ── Email
//                               const GlowTextField(
//                                 hint: 'Email',
//                                 prefixIcon: Icons.mail_outline_rounded,
//                               ),
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Password
//                               const GlowTextField(
//                                 hint: 'Password',
//                                 prefixIcon: Icons.lock_outline_rounded,
//                                 isPassword: true,
//                               ),
//                               SizedBox(height: screenHeight * 0.014),
//
//                               // ── Remember me + Forgot
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () => setState(() => _rememberMe = !_rememberMe),
//                                     child: Row(
//                                       children: [
//                                         AnimatedContainer(
//                                           duration: const Duration(milliseconds: 200),
//                                           width: 20,
//                                           height: 20,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(5),
//                                             color: _rememberMe
//                                                 ? const Color(0xFF7C3AED)
//                                                 : Colors.transparent,
//                                             border: Border.all(
//                                               color: _rememberMe
//                                                   ? const Color(0xFF7C3AED)
//                                                   : Colors.white.withOpacity(0.4),
//                                               width: 1.5,
//                                             ),
//                                           ),
//                                           child: _rememberMe
//                                               ? const Icon(Icons.check,
//                                               size: 13, color: Colors.white)
//                                               : null,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           'Remember me',
//                                           style: TextStyle(
//                                             color: Colors.white.withOpacity(0.75),
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {},
//                                     child: const Text(
//                                       'Forgot Password?',
//                                       style: TextStyle(
//                                         color: Color(0xFFD4AF37),
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: screenHeight * 0.024),
//
//                               // ── Login Button
//                               RippleLoginButton(onTap: () {
//                                 Navigator.push(context, MaterialPageRoute(
//                                     builder: (_) => const HomeScreen()
//                                 ));
//                               }),
//
//                               SizedBox(height: screenHeight * 0.018),
//
//                               // ── Or divider
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Divider(
//                                         color: Colors.white.withOpacity(0.18),
//                                         thickness: 1),
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                     child: Text(
//                                       'Or',
//                                       style: TextStyle(
//                                           color: Colors.white.withOpacity(0.45),
//                                           fontSize: 14),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Divider(
//                                         color: Colors.white.withOpacity(0.18),
//                                         thickness: 1),
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Google Button
//                               const GoogleSignInButton(),
//
//                               SizedBox(height: screenHeight * 0.018),
//
//                               // ── Sign Up
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Don't have an account? ",
//                                     style: TextStyle(
//                                         color: Colors.white.withOpacity(0.6),
//                                         fontSize: 13.5),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//
//                                       // Login screen mein Sign Up button pe:
//                                       Navigator.push(context, MaterialPageRoute(
//                                           builder: (_) => const RegisterScreen()
//                                       ));
//
//                                     },
//                                     child: const Text(
//                                       'Sign Up',
//                                       style: TextStyle(
//                                         color: Color(0xFFD4AF37),
//                                         fontSize: 13.5,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               // Bottom padding so content doesn't go under wave
//                               SizedBox(height: bottomBarHeight + 8),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







//----------------------------------------- Old code ------------------------------------->







// // void main() {
// //   runApp(const VerveeApp());
// // }
// //
// // class VerveeApp extends StatelessWidget {
// //   const VerveeApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Vervee Academy',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         fontFamily: 'Poppins',
// //         scaffoldBackgroundColor: const Color(0xFF1A0A2E),
// //       ),
// //       home: const LoginScreen(),
// //     );
// //   }
// // }
//
// // ─── Animated Particle Background ────────────────────────────────────────────
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
//
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
//         Offset(p.x * size.width, y * size.height),
//         p.size,
//         paint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(ParticlePainter old) => true;
// }
//
// // ─── Wave Painter for Bottom Decorative Element ──────────────────────────────
// class WavePainter extends CustomPainter {
//   final double animValue;
//
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
//     path1.moveTo(0, size.height * 0.5);
//     for (double x = 0; x <= size.width; x++) {
//       final y = size.height * 0.5 +
//           math.sin((x / size.width * 2 * math.pi) + animValue * 2 * math.pi) *
//               size.height *
//               0.12 +
//           math.sin((x / size.width * 4 * math.pi) + animValue * 2 * math.pi) *
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
//     path2.moveTo(0, size.height * 0.62);
//     for (double x = 0; x <= size.width; x++) {
//       final y = size.height * 0.62 +
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
//
// // ─── Animated Text Field ─────────────────────────────────────────────────────
// class GlowTextField extends StatefulWidget {
//   final String hint;
//   final IconData prefixIcon;
//   final bool isPassword;
//
//   const GlowTextField({
//     super.key,
//     required this.hint,
//     required this.prefixIcon,
//     this.isPassword = false,
//   });
//
//   @override
//   State<GlowTextField> createState() => _GlowTextFieldState();
// }
//
// class _GlowTextFieldState extends State<GlowTextField>
//     with SingleTickerProviderStateMixin {
//   bool _obscure = true;
//   bool _focused = false;
//   late AnimationController _ctrl;
//   late Animation<double> _glowAnim;
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _glowAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _focusNode.addListener(() {
//       setState(() => _focused = _focusNode.hasFocus);
//       if (_focusNode.hasFocus) {
//         _ctrl.forward();
//       } else {
//         _ctrl.reverse();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _glowAnim,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused
//                 ? [
//               BoxShadow(
//                 color: const Color(0xFF9333EA)
//                     .withOpacity(0.5 * _glowAnim.value),
//                 blurRadius: 18 * _glowAnim.value,
//                 spreadRadius: 2 * _glowAnim.value,
//               ),
//             ]
//                 : [],
//           ),
//           child: TextField(
//             focusNode: _focusNode,
//             obscureText: widget.isPassword && _obscure,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             ),
//             cursorColor: const Color(0xFFD4AF37),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: TextStyle(
//                 color: Colors.white.withOpacity(0.45),
//                 fontSize: 15,
//               ),
//               prefixIcon: Icon(
//                 widget.prefixIcon,
//                 color: _focused
//                     ? const Color(0xFFD4AF37)
//                     : Colors.white.withOpacity(0.5),
//                 size: 20,
//               ),
//               suffixIcon: widget.isPassword
//                   ? GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Icon(
//                   _obscure
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   color: Colors.white.withOpacity(0.5),
//                   size: 20,
//                 ),
//               )
//                   : null,
//               filled: true,
//               fillColor: Colors.white.withOpacity(0.09),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: Colors.white.withOpacity(0.15),
//                   width: 1.2,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF9333EA),
//                   width: 1.8,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 18,
//                 horizontal: 16,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // ─── Ripple Login Button ──────────────────────────────────────────────────────
// class RippleLoginButton extends StatefulWidget {
//   final VoidCallback onTap;
//
//   const RippleLoginButton({super.key, required this.onTap});
//
//   @override
//   State<RippleLoginButton> createState() => _RippleLoginButtonState();
// }
//
// class _RippleLoginButtonState extends State<RippleLoginButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );
//     _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
//       CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
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
//       onTapUp: (_) async {
//         await _ctrl.reverse();
//         widget.onTap();
//       },
//       onTapCancel: () => _ctrl.reverse(),
//       child: ScaleTransition(
//         scale: _scale,
//         child: Container(
//           width: double.infinity,
//           height: 56,
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
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: const Center(
//             child: Text(
//               'Login',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Google Sign In Button ────────────────────────────────────────────────────
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
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );
//     _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
//       CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() => _ctrl.dispose();
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
//           height: 54,
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
//               // Google G logo using colored circles
//               SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CustomPaint(painter: _GoogleLogoPainter()),
//               ),
//               const SizedBox(width: 12),
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
//
// class _GoogleLogoPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final r = size.width / 2;
//
//     // Draw G segments
//     final colors = [
//       const Color(0xFF4285F4), // blue
//       const Color(0xFF34A853), // green
//       const Color(0xFFFBBC05), // yellow
//       const Color(0xFFEA4335), // red
//     ];
//
//     for (int i = 0; i < 4; i++) {
//       final paint = Paint()
//         ..color = colors[i]
//         ..style = PaintingStyle.fill;
//       final startAngle = -math.pi / 2 + i * math.pi / 2;
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         startAngle,
//         math.pi / 2,
//         true,
//         paint,
//       );
//     }
//
//     // White center hole
//     canvas.drawCircle(
//       Offset(cx, cy),
//       r * 0.55,
//       Paint()..color = const Color(0xFF1A0A2E),
//     );
//
//     // White G bar
//     canvas.drawRect(
//       Rect.fromLTWH(cx, cy - r * 0.12, r, r * 0.24),
//       Paint()..color = const Color(0xFF4285F4),
//     );
//   }
//
//   @override
//   bool shouldRepaint(_) => false;
// }
//
// // ─── Shield Logo Painter ──────────────────────────────────────────────────────
// class ShieldLogoPainter extends CustomPainter {
//   final double glowAnim;
//
//   ShieldLogoPainter(this.glowAnim);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final w = size.width;
//     final h = size.height;
//
//     // Glow behind shield
//     final glowPaint = Paint()
//       ..color = const Color(0xFFD4AF37).withOpacity(0.3 + 0.15 * glowAnim)
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 25 + 10 * glowAnim);
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(w / 2, h * 0.5),
//         width: w * 0.9,
//         height: h * 0.85,
//       ),
//       glowPaint,
//     );
//
//     // Shield outer shape
//     final shieldPath = Path();
//     shieldPath.moveTo(w * 0.5, h * 0.02);
//     shieldPath.lineTo(w * 0.98, h * 0.22);
//     shieldPath.lineTo(w * 0.98, h * 0.6);
//     shieldPath.quadraticBezierTo(w * 0.98, h * 0.88, w * 0.5, h * 0.98);
//     shieldPath.quadraticBezierTo(w * 0.02, h * 0.88, w * 0.02, h * 0.6);
//     shieldPath.lineTo(w * 0.02, h * 0.22);
//     shieldPath.close();
//
//     // Silver gradient fill
//     final silverPaint = Paint()
//       ..shader = LinearGradient(
//         colors: [
//           const Color(0xFFD0D0D0),
//           const Color(0xFF808080),
//           const Color(0xFFE8E8E8),
//           const Color(0xFF909090),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ).createShader(Rect.fromLTWH(0, 0, w, h));
//     canvas.drawPath(shieldPath, silverPaint);
//
//     // Shield inner (dark purple)
//     final innerPath = Path();
//     final inset = w * 0.09;
//     innerPath.moveTo(w * 0.5, h * 0.1);
//     innerPath.lineTo(w - inset, h * 0.27);
//     innerPath.lineTo(w - inset, h * 0.6);
//     innerPath.quadraticBezierTo(w - inset, h * 0.84, w * 0.5, h * 0.92);
//     innerPath.quadraticBezierTo(inset, h * 0.84, inset, h * 0.6);
//     innerPath.lineTo(inset, h * 0.27);
//     innerPath.close();
//     canvas.drawPath(
//       innerPath,
//       Paint()..color = const Color(0xFF2D0A5E),
//     );
//
//     // Gold bar charts
//     final barPaint = Paint()
//       ..shader = const LinearGradient(
//         colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
//         begin: Alignment.bottomCenter,
//         end: Alignment.topCenter,
//       ).createShader(Rect.fromLTWH(w * 0.25, h * 0.2, w * 0.5, h * 0.45));
//
//     final bars = [
//       [0.30, 0.60, 0.10, 0.24],
//       [0.40, 0.48, 0.10, 0.36],
//       [0.50, 0.36, 0.10, 0.48],
//       [0.60, 0.44, 0.10, 0.40],
//       [0.70, 0.54, 0.10, 0.30],
//     ];
//     for (final b in bars) {
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(w * b[0] - w * 0.04, h * b[1], w * b[2], h * b[3]),
//           const Radius.circular(2),
//         ),
//         barPaint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(ShieldLogoPainter old) => old.glowAnim != glowAnim;
// }
//
// @Preview(name: 'My Sample Text')
// Widget mySampleText() {
//  // return const Text('Hello, World!');
//   return LoginScreen();
// }
//
// // ─── Main Login Screen ────────────────────────────────────────────────────────
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _particleCtrl;
//   late AnimationController _waveCtrl;
//   late AnimationController _shieldGlowCtrl;
//   late AnimationController _entryCtrl;
//
//   late Animation<double> _fadeIn;
//   late Animation<Offset> _slideIn;
//
//   bool _rememberMe = true;
//
//   final List<Particle> _particles = List.generate(55, (i) {
//     final rng = math.Random(i * 17 + 3);
//     return Particle(
//       x: rng.nextDouble(),
//       y: rng.nextDouble(),
//       size: rng.nextDouble() * 1.8 + 0.4,
//       speed: rng.nextDouble() * 0.4 + 0.1,
//       opacity: rng.nextDouble() * 0.6 + 0.15,
//     );
//   });
//
//   @override
//   void initState() {
//     super.initState();
//
//     _particleCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//
//     _waveCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat();
//
//     _shieldGlowCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _entryCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
//     _slideIn = Tween<Offset>(
//       begin: const Offset(0, 0.08),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
//
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _entryCtrl.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _particleCtrl.dispose();
//     _waveCtrl.dispose();
//     _shieldGlowCtrl.dispose();
//     _entryCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           // ── Deep purple gradient background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment(0.0, -0.3),
//                 radius: 1.2,
//                 colors: [
//                   Color(0xFF3B0764),
//                   Color(0xFF1E0245),
//                   Color(0xFF0F0120),
//                 ],
//               ),
//             ),
//           ),
//
//           // ── Particle layer
//           AnimatedBuilder(
//             animation: _particleCtrl,
//             builder: (_, __) => CustomPaint(
//               painter: ParticlePainter(_particleCtrl.value, _particles),
//               child: const SizedBox.expand(),
//             ),
//           ),
//
//           // ── Bottom wave decorations
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: 220,
//             child: AnimatedBuilder(
//               animation: _waveCtrl,
//               builder: (_, __) => CustomPaint(
//                 painter: WavePainter(_waveCtrl.value),
//               ),
//             ),
//           ),
//
//           // ── Gold coin decorations (bottom)
//           Positioned(
//             bottom: 55,
//             right: 28,
//             child: _GoldCoin(size: 48),
//           ),
//           Positioned(
//             bottom: 88,
//             left: 36,
//             child: _GoldCoin(size: 36),
//           ),
//
//           // ── Candle decorations (bottom)
//           Positioned(
//             bottom: 68,
//             left: 80,
//             child: _CandleStick(),
//           ),
//           Positioned(
//             bottom: 60,
//             right: 85,
//             child: _CandleStick(),
//           ),
//
//           // ── Main scrollable content
//           SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: FadeTransition(
//                 opacity: _fadeIn,
//                 child: SlideTransition(
//                   position: _slideIn,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 32),
//
//                        // ── Shield Logo
//                         AnimatedBuilder(
//                           animation: _shieldGlowCtrl,
//                           builder: (_, __) {
//                             final glow = _shieldGlowCtrl.value; // 0.0 to 1.0
//                             return SizedBox(
//                               width: 160,
//                               height: 160,
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   // ── Glow layer (peeche)
//                                   Container(
//                                     width: 80 + (glow * 5),
//                                     height: 80 + (glow * 5),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: const Color(0xFFD4AF37)
//                                               .withOpacity(0.35 + 0.25 * glow),
//                                           blurRadius: 30 + (20 * glow),
//                                           spreadRadius: 8 + (8 * glow),
//                                         ),
//                                         BoxShadow(
//                                           color: const Color(0xFF7C3AED)
//                                               .withOpacity(0.3 + 0.2 * glow),
//                                           blurRadius: 50 + (20 * glow),
//                                           spreadRadius: 5 + (5 * glow),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   // ── PNG Logo (upar)
//                                   Image.asset(
//                                     'assets/iconfinal.png',
//                                     width: 140,
//                                     height: 140,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//
//                         // AnimatedBuilder(
//                         //   animation: _shieldGlowCtrl,
//                         //   builder: (_, __) => SizedBox(
//                         //     width: 140,
//                         //     height: 150,
//                         //     child: Stack(
//                         //       alignment: Alignment.center,
//                         //       children: [
//                         //         CustomPaint(
//                         //           size: const Size(140, 150),
//                         //           painter: ShieldLogoPainter(
//                         //               _shieldGlowCtrl.value),
//                         //         ),
//                         //         Positioned(
//                         //           bottom: 30,
//                         //           child: Column(
//                         //             children: [
//                         //               const Text(
//                         //                 'VERVEE',
//                         //                 style: TextStyle(
//                         //                   color: Color(0xFFD4AF37),
//                         //                   fontSize: 18,
//                         //                   fontWeight: FontWeight.w900,
//                         //                   letterSpacing: 2.5,
//                         //                 ),
//                         //               ),
//                         //               Text(
//                         //                 'ACADEMY',
//                         //                 style: TextStyle(
//                         //                   color: Colors.white.withOpacity(0.85),
//                         //                   fontSize: 8.5,
//                         //                   fontWeight: FontWeight.w600,
//                         //                   letterSpacing: 3,
//                         //                 ),
//                         //               ),
//                         //             ],
//                         //           ),
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//
//                         const SizedBox(height: 24),
//
//                         // ── Welcome text
//                         const Text(
//                           'Welcome Back!',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Login to your account',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.55),
//                             fontSize: 14.5,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         const SizedBox(height: 36),
//
//                         // ── Email Field
//                         const GlowTextField(
//                           hint: 'Email',
//                           prefixIcon: Icons.mail_outline_rounded,
//                         ),
//                         const SizedBox(height: 16),
//
//                         // ── Password Field
//                         const GlowTextField(
//                           hint: 'Password',
//                           prefixIcon: Icons.lock_outline_rounded,
//                           isPassword: true,
//                         ),
//                         const SizedBox(height: 14),
//
//                         // ── Remember me + Forgot
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () => setState(
//                                       () => _rememberMe = !_rememberMe),
//                               child: Row(
//                                 children: [
//                                   AnimatedContainer(
//                                     duration:
//                                     const Duration(milliseconds: 200),
//                                     width: 20,
//                                     height: 20,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: _rememberMe
//                                           ? const Color(0xFF7C3AED)
//                                           : Colors.transparent,
//                                       border: Border.all(
//                                         color: _rememberMe
//                                             ? const Color(0xFF7C3AED)
//                                             : Colors.white.withOpacity(0.4),
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     child: _rememberMe
//                                         ? const Icon(Icons.check,
//                                         size: 14,
//                                         color: Colors.white)
//                                         : null,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     'Remember me',
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.75),
//                                       fontSize: 13.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: const Text(
//                                 'Forgot Password?',
//                                 style: TextStyle(
//                                   color: Color(0xFFD4AF37),
//                                   fontSize: 13.5,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 26),
//
//                         // ── Login button
//                         RippleLoginButton(onTap: () {}),
//                         const SizedBox(height: 20),
//
//                         // ── Or divider
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.white.withOpacity(0.18),
//                                 thickness: 1,
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(horizontal: 12),
//                               child: Text(
//                                 'Or',
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.45),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Divider(
//                                 color: Colors.white.withOpacity(0.18),
//                                 thickness: 1,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 18),
//
//                         // ── Google button
//                         const GoogleSignInButton(),
//                         const SizedBox(height: 22),
//
//                         // ── Sign Up row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't have an account? ",
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.6),
//                                 fontSize: 14,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: const Text(
//                                 'Sign Up',
//                                 style: TextStyle(
//                                   color: Color(0xFFD4AF37),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 220), // space for wave
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Gold Coin Widget ─────────────────────────────────────────────────────────
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
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//     _float = Tween<double>(begin: 0, end: 10).animate(
//       CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
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
//               colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFA07820)],
//               center: Alignment(-0.3, -0.3),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFD4AF37).withOpacity(0.5),
//                 blurRadius: 12,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               '\$',
//               style: TextStyle(
//                 color: const Color(0xFF7A5500),
//                 fontSize: widget.size * 0.48,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Candle Stick Decoration ──────────────────────────────────────────────────
// class _CandleStick extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         _Bar(height: 28, color: const Color(0xFFD4AF37)),
//         const SizedBox(width: 3),
//         _Bar(height: 42, color: const Color(0xFFFFD700)),
//         const SizedBox(width: 3),
//         _Bar(height: 20, color: const Color(0xFFD4AF37)),
//         const SizedBox(width: 3),
//         _Bar(height: 34, color: const Color(0xFFFFD700)),
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
//       width: 6,
//       height: height,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.75),
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
//
// // void main() {
// //   runApp(MyApp());
// // }
//
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: LoginScreen(),
// //     );
// //   }
// // }
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool rememberMe = true;
//   bool obscurePassword = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//
//           Positioned.fill(
//             child: Image.asset(
//               "assets/bg.jpeg",
//               fit: BoxFit.cover, // screen ko fill karega
//             ),
//           ),
//
//           /// Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.6),
//                     Colors.transparent,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//
//           // /// Background
//           // Container(
//           //   decoration: BoxDecoration(
//           //     image: DecorationImage(
//           //       image: AssetImage("assets/bg.jpeg"),
//           //       fit: BoxFit.cover,
//           //     ),
//           //   ),
//           // ),
//           //
//           // /// Overlay
//           // Container(
//           //   decoration: BoxDecoration(
//           //     gradient: LinearGradient(
//           //       colors: [
//           //         Colors.black.withOpacity(0.6),
//           //         Colors.transparent,
//           //       ],
//           //       begin: Alignment.topCenter,
//           //       end: Alignment.bottomCenter,
//           //     ),
//           //   ),
//           // ),
//
//           /// Content
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 25),
//               child: Column(
//                 children: [
//                   SizedBox(height: 40),
//
//                   /// Logo
//                   Image.asset(
//                     "assets/logo.png",
//                     height: 120,
//                   ),
//
//                   SizedBox(height: 20),
//
//                   /// Title
//                   Text(
//                     "Welcome Back!",
//                     style: TextStyle(
//                       fontSize: 28,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   SizedBox(height: 8),
//
//                   Text(
//                     "Login to your account",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//
//                   SizedBox(height: 30),
//
//                   /// Email Field
//                   _buildTextField(
//                     icon: Icons.email_outlined,
//                     hint: "Email",
//                     obscure: false,
//                   ),
//
//                   SizedBox(height: 15),
//
//                   /// Password Field
//                   _buildTextField(
//                     icon: Icons.lock_outline,
//                     hint: "Password",
//                     obscure: obscurePassword,
//                     suffix: IconButton(
//                       icon: Icon(
//                         obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.white70,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           obscurePassword = !obscurePassword;
//                         });
//                       },
//                     ),
//                   ),
//
//                   SizedBox(height: 10),
//
//                   /// Remember + Forgot
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: rememberMe,
//                             onChanged: (value) {
//                               setState(() {
//                                 rememberMe = value!;
//                               });
//                             },
//                             activeColor: Colors.purple,
//                           ),
//                           Text(
//                             "Remember me",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "Forgot Password?",
//                         style: TextStyle(
//                           color: Colors.purpleAccent,
//                         ),
//                       )
//                     ],
//                   ),
//
//                   SizedBox(height: 10),
//
//                   /// Login Button
//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.purple, Colors.deepPurple],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Login",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 20),
//
//                   /// OR
//                   Text(
//                     "Or",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//
//                   SizedBox(height: 20),
//
//                   /// Google Button
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white30),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/google.png",
//                           height: 20,
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           "Sign in with Google",
//                           style: TextStyle(color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 20),
//
//                   /// Signup
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don’t have an account? ",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           color: Colors.purpleAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required IconData icon,
//     required String hint,
//     required bool obscure,
//     Widget? suffix,
//   }) {
//     return TextField(
//       obscureText: obscure,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white70),
//         suffixIcon: suffix,
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white70),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.1),
//         contentPadding: EdgeInsets.symmetric(vertical: 15),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
