
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'LoginScreen.dart';

// Reusing the same particle/wave painters already defined for
// Login/Register/OTP screens. If your project keeps them in
// per-screen widget folders, just point this import at whichever
// one is already in your pubspec's import graph (they're identical).
import '../widgets/OtpScreenWidgets/Particle.dart';
import '../widgets/OtpScreenWidgets/WavePainter.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ─── REGISTRATION SUCCESS SCREEN ──────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════
// Shows a short, celebratory success animation after OTP verification,
// then auto-navigates to LoginScreen with email + password pre-filled
// so the user only needs to tap "Login" — no retyping required.
// ═══════════════════════════════════════════════════════════════════════════
class RegistrationSuccessScreen extends StatefulWidget {
  final String email;
  final String password;

  const RegistrationSuccessScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _particleCtrl;
  late final AnimationController _waveCtrl;

  // Checkmark circle — elastic pop-in
  late final AnimationController _checkCtrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkOpacity;

  // Ripple rings expanding outward from the checkmark
  late final AnimationController _rippleCtrl;

  // Text + button fade/slide in, staggered after the checkmark
  late final AnimationController _textCtrl;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // Soft glow pulse behind the checkmark (matches shield-glow style
  // already used on Login/Register/OTP)
  late final AnimationController _glowCtrl;

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

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _particleCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
    _waveCtrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);
    _checkOpacity = CurvedAnimation(
      parent: _checkCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Small beat before anything happens — lets the screen settle
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _checkCtrl.forward();
    _rippleCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _textCtrl.forward();

    // Total time on screen before auto-redirect ≈ 2.4s
    await Future.delayed(const Duration(milliseconds: 1900));
    _goToLogin();
  }

  void _goToLogin() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        pageBuilder: (_, __, ___) => LoginScreen(
          prefillEmail: widget.email,
          prefillPassword: widget.password,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _glowCtrl.dispose();
    _checkCtrl.dispose();
    _rippleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomBarHeight = screenHeight * 0.18;

    return Scaffold(
      body: GestureDetector(
        // Tap anywhere to skip straight to Login
        onTap: _goToLogin,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // ── 1. Background gradient — same Vervee purple as other screens
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

            // ── 3. Bottom wave (same signature look as Login/Register/OTP)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: bottomBarHeight,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _waveCtrl,
                  builder: (_, __) =>
                      CustomPaint(painter: WavePainter(_waveCtrl.value)),
                ),
              ),
            ),

            // ── 4. Center content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Animated checkmark with glow + expanding rings
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Expanding gold ripple rings
                            AnimatedBuilder(
                              animation: _rippleCtrl,
                              builder: (_, __) {
                                return CustomPaint(
                                  size: const Size(160, 160),
                                  painter: _RippleRingsPainter(_rippleCtrl.value),
                                );
                              },
                            ),

                            // Soft pulsing glow behind the circle
                            AnimatedBuilder(
                              animation: _glowCtrl,
                              builder: (_, __) {
                                final g = _glowCtrl.value;
                                return Container(
                                  width: 92 + g * 6,
                                  height: 92 + g * 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD4AF37)
                                            .withOpacity(0.35 + 0.25 * g),
                                        blurRadius: 34 + (20 * g),
                                        spreadRadius: 6 + (6 * g),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF7C3AED)
                                            .withOpacity(0.3 + 0.2 * g),
                                        blurRadius: 46 + (18 * g),
                                        spreadRadius: 3 + (4 * g),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            // The checkmark circle itself — elastic scale-in
                            ScaleTransition(
                              scale: _checkScale,
                              child: FadeTransition(
                                opacity: _checkOpacity,
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF34D399),
                                        Color(0xFF059669),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFFD4AF37),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 46,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // ── Text block — fades + slides up after checkmark
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              Text(
                                "You're All Set!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.034,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              Text(
                                'Your registration is successfully completed.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: screenHeight * 0.019,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),

                              // Small inline loader hinting auto-redirect
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFD4AF37),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Taking you to login…',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: screenHeight * 0.0165,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
}

// ─────────────────────────────────────────────────────────────────────────
// Two gold rings expanding outward from the checkmark and fading as they
// grow — classic "success pulse" effect.
// ─────────────────────────────────────────────────────────────────────────
class _RippleRingsPainter extends CustomPainter {
  _RippleRingsPainter(this.progress);
  final double progress; // 0.0 → 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const maxRadius = 78.0;
    const ringCount = 2;

    for (int i = 0; i < ringCount; i++) {
      // Stagger each ring slightly so they don't move in lockstep
      final t = (progress - (i * 0.22)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final radius = 34 + (maxRadius - 34) * t;
      final opacity = (1 - t) * 0.5;

      final paint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RippleRingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}