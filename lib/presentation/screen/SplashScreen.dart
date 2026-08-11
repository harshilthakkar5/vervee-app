import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../utils/AppUpdateServices.dart';
import '../../utils/AuthService.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  VERVEE ACADEMY — SPLASH SCREEN
//  Animation sequence:
//  0.0s  → Background radial burst expands
//  0.4s  → Particles fade in
//  0.6s  → Shield logo scale-in with bounce + gold glow pulse
//  1.2s  → "VERVEE" text reveals letter by letter
//  1.8s  → "ACADEMY" subtitle slides up
//  2.2s  → Shimmer line sweeps across
//  2.6s  → Tagline fades in
//  3.2s  → Loading bar fills
//  4.2s  → Screen fades out → navigate to LoginScreen
// ════════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  /// Pass your LoginScreen (or any next screen) here
  //final Widget nextScreen;

  const SplashScreen({super.key});
  // required this.nextScreen

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Controllers ──────────────────────────────────────────────────────────
  late AnimationController _bgBurstCtrl;      // radial bg expand
  late AnimationController _particleCtrl;     // floating particles
  late AnimationController _logoCtrl;         // logo scale + fade
  late AnimationController _glowPulseCtrl;    // logo glow breathe
  late AnimationController _titleCtrl;        // VERVEE text
  late AnimationController _subtitleCtrl;     // ACADEMY text
  late AnimationController _shimmerCtrl;      // shimmer line
  late AnimationController _taglineCtrl;      // tagline
  late AnimationController _loadingCtrl;      // bottom bar
  late AnimationController _exitCtrl;         // full screen fade out
  late AnimationController _ringCtrl;         // rotating ring around logo

  // ── Animations ───────────────────────────────────────────────────────────
  late Animation<double> _bgScale;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowRadius;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _shimmerPos;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _loadingProgress;
  late Animation<double> _exitOpacity;
  late Animation<double> _ringRotation;

  // ── Particles ─────────────────────────────────────────────────────────────
  final List<_Particle> _particles = List.generate(60, (i) {
    final rng = math.Random(i * 31 + 7);
    return _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: rng.nextDouble() * 2.2 + 0.4,
      speed: rng.nextDouble() * 0.35 + 0.08,
      opacity: rng.nextDouble() * 0.55 + 0.15,
    );
  });

  // ── Gold burst particles ──────────────────────────────────────────────────
  final List<_BurstParticle> _burstParticles = List.generate(12, (i) {
    final angle = (i / 12) * 2 * math.pi;
    return _BurstParticle(angle: angle, speed: 0.4 + (i % 3) * 0.15);
  });

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    // Thoda delay taaki UI build ho jaye
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      await UpdateService.checkForUpdate(context);
    }
    // Uske baad tumhara normal splash navigation logic chalega
  }

  void _setupAnimations() {
    // Background burst
    _bgBurstCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _bgScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _bgBurstCtrl, curve: Curves.easeOut));

    // Particles
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 15))
      ..repeat();

    // Logo
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.0, 0.4)));

    // Glow pulse
    _glowPulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _glowRadius = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _glowPulseCtrl, curve: Curves.easeInOut));

    // Rotating ring
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
    _ringRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_ringCtrl);

    // Title
    _titleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut));
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut));

    // Subtitle
    _subtitleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOut));
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOut));

    // Shimmer
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _shimmerPos = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // Tagline
    _taglineCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut));
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut));

    // Loading bar
    _loadingCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _loadingProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _loadingCtrl, curve: Curves.easeInOut));

    // Exit fade
    _exitCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));

    // 1. Background burst
    _bgBurstCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // 2. Logo appears with bounce
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    // 3. Title slides up
    _titleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    // 4. Subtitle
    _subtitleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // 5. Shimmer sweep
    _shimmerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // 6. Tagline
    _taglineCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // 7. Loading bar
    _loadingCtrl.forward();

    // ── CHANGE: Animation chal rahi hai tabhi parallel mein auth check karo
    // Dono simultaneously hote hain — user ko wait nahi lagta
    final isLoggedIn = await AuthService.instance.isLoggedIn();

    await Future.delayed(const Duration(milliseconds: 1100));

    // 8. Exit
    _exitCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // if (mounted) {
    //   Navigator.of(context).pushReplacement(
    //     PageRouteBuilder(
    //       pageBuilder: (_, __, ___) => widget.nextScreen,
    //       transitionDuration: const Duration(milliseconds: 400),
    //       transitionsBuilder: (_, anim, __, child) =>
    //           FadeTransition(opacity: anim, child: child),
    //     ),
    //   );
    // }

    if (!mounted) return; // ── CHANGE: mounted check — widget dispose ho gaya toh navigate mat karo

    // ── CHANGE: Token ke hisaab se screen decide karo
    // Token mila → HomeScreen (login screen skip)
    // Token nahi mila → LoginScreen
    final nextScreen = isLoggedIn ? const HomeScreen() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextScreen, // ← CHANGE: dynamic next screen
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _bgBurstCtrl.dispose();
    _particleCtrl.dispose();
    _logoCtrl.dispose();
    _glowPulseCtrl.dispose();
    _ringCtrl.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _shimmerCtrl.dispose();
    _taglineCtrl.dispose();
    _loadingCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.height * 0.20;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0120),
      body: AnimatedBuilder(
        animation: _exitOpacity,
        builder: (_, __) => Opacity(
          opacity: _exitOpacity.value,
          child: Stack(
            children: [
              // ── 1. Deep background
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 1.0,
                    colors: [
                      Color(0xFF200040),
                      Color(0xFF120028),
                      Color(0xFF060010),
                    ],
                  ),
                ),
              ),

              // ── 2. Animated radial burst (expands on load)
              AnimatedBuilder(
                animation: _bgScale,
                builder: (_, __) => Center(
                  child: Transform.scale(
                    scale: _bgScale.value * 3.5,
                    child: Container(
                      width: size.width * 0.6,
                      height: size.width * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF7C3AED).withOpacity(0.25 * _bgScale.value),
                            const Color(0xFF3B0764).withOpacity(0.15 * _bgScale.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. Floating particles
              AnimatedBuilder(
                animation: _particleCtrl,
                builder: (_, __) => CustomPaint(
                  painter: _ParticlePainter(_particleCtrl.value, _particles),
                  child: const SizedBox.expand(),
                ),
              ),

              // ── 4. Burst particles (shoot outward on logo appear)
              AnimatedBuilder(
                animation: Listenable.merge([_logoCtrl, _glowPulseCtrl]),
                builder: (_, __) => CustomPaint(
                  painter: _BurstPainter(
                    progress: _logoCtrl.value,
                    particles: _burstParticles,
                    center: Offset(size.width / 2, size.height * 0.38),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

              // ── 5. Main content (centered)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.06),

                    // ── Logo with glow + rotating ring
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _logoCtrl, _glowPulseCtrl, _ringCtrl
                      ]),
                      builder: (_, __) {
                        final glow = _glowPulseCtrl.value;
                        return Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: SizedBox(
                              width: logoSize * 1.4,
                              height: logoSize * 1.4,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer gold glow
                                  Container(
                                    width: logoSize * 0.9,
                                    height: logoSize * 0.9,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF030900) // 0xFFD4AF37
                                              .withOpacity(0.4 + 0.3 * glow),
                                          blurRadius: 40 + 20 * glow,
                                          spreadRadius: 10 + 8 * glow,
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFF9333EA)
                                              .withOpacity(0.3 + 0.2 * glow),
                                          blurRadius: 60 + 20 * glow,
                                          spreadRadius: 5 + 5 * glow,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Rotating dashed ring
                                  Transform.rotate(
                                    angle: _ringRotation.value,
                                    child: CustomPaint(
                                      size: Size(logoSize * 1.25, logoSize * 1.25),
                                      painter: _RingPainter(
                                          opacity: _logoOpacity.value),
                                    ),
                                  ),

                                  // Counter-rotating ring (slower)
                                  Transform.rotate(
                                    angle: -_ringRotation.value * 0.6,
                                    child: CustomPaint(
                                      size: Size(logoSize * 1.05, logoSize * 1.05),
                                      painter: _RingPainter(
                                          opacity: _logoOpacity.value * 0.5,
                                          dashed: false),
                                    ),
                                  ),

                                  // Logo PNG
                                  Image.asset(
                                    'assets/vervee_app_icon_bgr.png',
                                    width: logoSize,
                                    height: logoSize,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: size.height * 0.04),

                    // ── VERVEE title
                    AnimatedBuilder(
                      animation: _titleCtrl,
                      builder: (_, __) => FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Stack(
                            children: [
                              // Shimmer sweep over text
                              AnimatedBuilder(
                                animation: _shimmerCtrl,
                                builder: (_, child) => ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment(_shimmerPos.value - 0.3, 0),
                                    end: Alignment(_shimmerPos.value + 0.3, 0),
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ).createShader(bounds),
                                  blendMode: BlendMode.srcATop,
                                  child: child,
                                ),
                                child: Text(
                                  'VERVEE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.065,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 8,
                                    shadows: [
                                      Shadow(
                                        color: const Color(0xFFD4AF37).withOpacity(0.8),
                                        blurRadius: 20,
                                      ),
                                      Shadow(
                                        color: const Color(0xFF9333EA).withOpacity(0.5),
                                        blurRadius: 35,
                                        offset: const Offset(0, 4),
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

                    SizedBox(height: size.height * 0.005),

                    // ── ACADEMY subtitle
                    AnimatedBuilder(
                      animation: _subtitleCtrl,
                      builder: (_, __) => FadeTransition(
                        opacity: _subtitleOpacity,
                        child: SlideTransition(
                          position: _subtitleSlide,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Left decorative line
                              Container(
                                width: size.width * 0.08,
                                height: 1.5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFFD4AF37).withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'A C A D E M Y',
                                style: TextStyle(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: size.height * 0.018,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Right decorative line
                              Container(
                                width: size.width * 0.08,
                                height: 1.5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFD4AF37).withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // ── Tagline
                    AnimatedBuilder(
                      animation: _taglineCtrl,
                      builder: (_, __) => FadeTransition(
                        opacity: _taglineOpacity,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: Text(
                            'Master the Markets. Build Your Future.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: size.height * 0.016,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 6. Bottom loading bar
              Positioned(
                bottom: size.height * 0.08,
                left: size.width * 0.15,
                right: size.width * 0.15,
                child: Column(
                  children: [
                    // Loading text
                    AnimatedBuilder(
                      animation: _loadingCtrl,
                      builder: (_, __) => Opacity(
                        opacity: _loadingCtrl.value,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Track
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: AnimatedBuilder(
                        animation: _loadingProgress,
                        builder: (_, __) => FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _loadingProgress.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD4AF37),
                                  Color(0xFF9333EA),
                                  Color(0xFFD4AF37),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 7. Corner decorative dots
              ..._buildCornerDots(size),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerDots(Size size) {
    return [
      Positioned(
        top: size.height * 0.05,
        left: size.width * 0.06,
        child: AnimatedBuilder(
          animation: _glowPulseCtrl,
          builder: (_, __) => _GlowDot(
              size: 6, opacity: 0.3 + 0.3 * _glowPulseCtrl.value),
        ),
      ),
      Positioned(
        top: size.height * 0.07,
        right: size.width * 0.1,
        child: _GlowDot(size: 4, opacity: 0.2),
      ),
      Positioned(
        bottom: size.height * 0.15,
        left: size.width * 0.08,
        child: AnimatedBuilder(
          animation: _glowPulseCtrl,
          builder: (_, __) => _GlowDot(
              size: 5, opacity: 0.2 + 0.2 * (1 - _glowPulseCtrl.value)),
        ),
      ),
      Positioned(
        bottom: size.height * 0.12,
        right: size.width * 0.07,
        child: _GlowDot(size: 4, opacity: 0.25),
      ),
    ];
  }
}

// ── Glow dot decoration ──────────────────────────────────────────────────────
class _GlowDot extends StatelessWidget {
  final double size;
  final double opacity;
  const _GlowDot({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD4AF37).withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(opacity * 0.8),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

// ── Particle model ────────────────────────────────────────────────────────────
class _Particle {
  double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

// ── Particle painter ──────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double animValue;
  final List<_Particle> particles;
  _ParticlePainter(this.animValue, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y - animValue * p.speed * 0.3) % 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(
          Offset(p.x * size.width, y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

// ── Burst particle model ──────────────────────────────────────────────────────
class _BurstParticle {
  final double angle;
  final double speed;
  _BurstParticle({required this.angle, required this.speed});
}

// ── Burst painter ─────────────────────────────────────────────────────────────
class _BurstPainter extends CustomPainter {
  final double progress;
  final List<_BurstParticle> particles;
  final Offset center;

  _BurstPainter({
    required this.progress,
    required this.particles,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 0.85) return;
    final fade = progress < 0.5 ? progress * 2 : (1 - progress) * 2;

    for (final p in particles) {
      final dist = progress * 120 * p.speed;
      final x = center.dx + math.cos(p.angle) * dist;
      final y = center.dy + math.sin(p.angle) * dist;

      final paint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(fade * 0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}

// ── Rotating ring painter ─────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double opacity;
  final bool dashed;

  _RingPainter({required this.opacity, this.dashed = true});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(opacity * 0.45)
      ..strokeWidth = dashed ? 1.2 : 0.8
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    if (dashed) {
      // Draw dashed arc segments
      const dashCount = 16;
      const gapFraction = 0.35;
      for (int i = 0; i < dashCount; i++) {
        final startAngle = (i / dashCount) * 2 * math.pi;
        final sweepAngle = (1 - gapFraction) * (2 * math.pi / dashCount);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: r),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
        // Small diamond dot at each gap
        final dotAngle = startAngle + sweepAngle + gapFraction * (2 * math.pi / dashCount) / 2;
        canvas.drawCircle(
          Offset(cx + math.cos(dotAngle) * r, cy + math.sin(dotAngle) * r),
          1.5,
          Paint()..color = const Color(0xFFD4AF37).withOpacity(opacity * 0.6),
        );
      }
    } else {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.opacity != opacity;
}
