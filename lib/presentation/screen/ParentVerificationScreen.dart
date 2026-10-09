
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../widgets/RegisterScreenWidgets/Particle.dart';
import '../widgets/RegisterScreenWidgets/WavePainter.dart';

class ParentVerificationScreen extends StatefulWidget {
  final String parentEmail;
  final String message;

  const ParentVerificationScreen({
    super.key,
    required this.parentEmail,
    required this.message,
  });

  @override
  State<ParentVerificationScreen> createState() =>
      _ParentVerificationScreenState();
}

class _ParentVerificationScreenState extends State<ParentVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

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
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _glowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // Login screen pe wapas — beech ka poora stack (Register) hata do
  void _goToSignIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final bottomBarHeight = h * 0.18;
    final hPad = w * 0.07;

    return PopScope(
      canPop: false, // back dabane par Register pe wapas nahi jayega
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToSignIn();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // 1. Background
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

            // 2. Particles
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => CustomPaint(
                painter: ParticlePainter(_particleCtrl.value, _particles),
                child: const SizedBox.expand(),
              ),
            ),

            // 3. Wave
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

            // 4. Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            Image.asset(
                              'assets/vervee_app_icon_bgr.png',
                              width: 64,
                              height: 64,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 14),

                            const Text(
                              'Parent Verification Required',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Verification email has been sent to your parent',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Glow mail icon
                            AnimatedBuilder(
                              animation: _glowCtrl,
                              builder: (_, __) {
                                final g = _glowCtrl.value;
                                return Container(
                                  width: 78,
                                  height: 78,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.06),
                                    border: Border.all(
                                      color: const Color(0xFFD4AF37)
                                          .withOpacity(0.4 + 0.3 * g),
                                      width: 1.8,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD4AF37)
                                            .withOpacity(0.18 + 0.17 * g),
                                        blurRadius: 20 + (14 * g),
                                        spreadRadius: 2 + (3 * g),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.forward_to_inbox_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 34,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Verification Link Sent',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Server ka message; empty ho to fallback
                            Text(
                              widget.message.isNotEmpty
                                  ? widget.message
                                  : "We have sent a verification link to your parent's email (${widget.parentEmail}). After successful verification, you can login.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13.5,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Go to Sign In
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE6C84A),
                                      Color(0xFFFFD700),
                                      Color(0xFFD4AF37),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD4AF37)
                                          .withOpacity(0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _goToSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Go to Sign In',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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