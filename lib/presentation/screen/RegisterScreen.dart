import 'dart:math' as math;
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/screen/OtpScreen.dart';
    //hide WavePainter, Particle, ParticlePainter;

import '../../domain/model/user/RegisteredUser.dart';
import '../../utils/NetworkResult.dart';
import '../viewmodal/auth_view_modal/register/RegisterViewModel.dart';
import '../widgets/RegisterScreenWidgets/CandleStick.dart';
import '../widgets/RegisterScreenWidgets/GlowDropdown.dart';
import '../widgets/RegisterScreenWidgets/GlowDropdownCountry.dart';
import '../widgets/RegisterScreenWidgets/GlowTextField.dart';
import '../widgets/RegisterScreenWidgets/GoldCoin.dart';
import '../widgets/RegisterScreenWidgets/GoogleSignInButton.dart';
import '../widgets/RegisterScreenWidgets/Particle.dart';
import '../widgets/RegisterScreenWidgets/SignUpButton.dart';
import '../widgets/RegisterScreenWidgets/WavePainter.dart';
// import '../widgets/LoginScreenWidgets/CandleStick.dart';
// import '../widgets/LoginScreenWidgets/GoldCoin.dart';
// import '../widgets/LoginScreenWidgets/GoogleSignInButton.dart';
// import '../widgets/RegisterScreenWidgets/GlowTextField.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ─── REGISTRATION SCREEN ──────────────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

// ── CHANGE 1: StatefulWidget → ConsumerStatefulWidget
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

// ── CHANGE 2: State<RegisterScreen> → ConsumerState<RegisterScreen>
class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {

  // ── CHANGE 3: TextEditingControllers add kiye (har field ke liye ek)
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _ageCtrl      = TextEditingController();
  // Note: Country aur Gender ke liye controller nahi chahiye
  // kyunki woh dropdown hain — _selectedCountry/_selectedGender
  // already State variables hain

  late AnimationController _particleCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _shieldGlowCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  // Form state
  bool _agreeToTerms = false;
  Country? _selectedCountry;
  String? _selectedGender;

  // All Country
  late List<Country> _countries;

  // final List<String> _countries = [
  //   'India', 'United States', 'United Kingdom', 'Canada',
  //   'Australia', 'UAE', 'Singapore', 'Germany', 'France', 'Other'
  // ];

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

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

    // All Country
    _countries = CountryService().getAll();

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
  }

  @override
  void dispose() {

    // ── CHANGE 4: Naye controllers bhi dispose karo — memory leak avoid karne ke liye
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();

    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _shieldGlowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── CHANGE 5: Sign Up handler — ViewModel ko call karta hai
  //    Yeh method SignUpButton ke onTap mein use hoga
  void _onSignUp() {

    // Keyboard band karo (best practice — form submit pe)
    FocusScope.of(context).unfocus();

    // ref.read() use kiya — kyunki yeh ek baar ka action hai (button tap)
    // ref.watch() sirf build() mein use karte hain
    ref.read(registerViewModelProvider.notifier).register(
      name:            _nameCtrl.text,
      email:           _emailCtrl.text,
      password:        _passwordCtrl.text,
      confirmPassword: _confirmCtrl.text,
      age:             _ageCtrl.text,
      country:         _selectedCountry?.name ?? '',  // ✅ FIX   // dropdown value
      gender:          _selectedGender  ?? 'Male',   // dropdown value
      phoneNo:         _phoneCtrl.text,
      terms:           _agreeToTerms,
    );
  }

  @override
  Widget build(BuildContext context) {

    // ── CHANGE 6: ref.listen — state changes sunna (side effects ke liye)
    //    Success → OTPScreen navigate karo
    //    Error   → SnackBar dikhao
    //    Note: ref.listen() sirf build() ke andar likho, kisi function mein nahi

    // ref.listen<RegisterState>(registerViewModelProvider, (previous, next) {
    //   next.whenOrNull(
    //     success: (message) {
    //       // Registration successful → OTP screen pe jaao
    //       // message = "Registration successful!" (RegisteredUser.message)
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (_) => OTPScreen(email: _emailCtrl.text.trim()),
    //         ),
    //       );
    //     },
    //     error: (message) {
    //       // ViewModel se aaya error message dikhao
    //       // Yeh validation errors bhi hain (e.g. "Passwords do not match")
    //       // aur API errors bhi (e.g. "Email already exists")
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //         SnackBar(
    //           content: Text(message),
    //           backgroundColor: Colors.red.shade700,
    //           behavior: SnackBarBehavior.floating,
    //           margin: const EdgeInsets.all(16),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // });
    //
    // // ── CHANGE 7: ref.watch — loading state dekho, button disable karne ke liye
    // //    isLoading = true  → button disable + loading indicator dikhao
    // //    isLoading = false → button normal
    // final isLoading = ref.watch(registerViewModelProvider).maybeWhen(
    //   loading: () => true,
    //   orElse:  () => false,
    // );


    // ── CHANGE 1: ref.listen type update karo
// RegisterState → NetworkResult<RegisteredUser>
    ref.listen<NetworkResult<RegisteredUser>>(registerViewModelProvider, (previous, next) {

      // ✅ whenOrNull → switch — Dart 3 modern pattern
      switch (next) {

      // ✅ Success — OTP screen navigate karo
        case Success(:final data):
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(
                  email: _emailCtrl.text.trim(),
                  password: _passwordCtrl.text,

              ),
            ),
          );

      // ✅ Error — SnackBar dikhao
      // Validation errors bhi yahan aayenge (e.g. "Passwords do not match")
      // API errors bhi yahan aayenge (e.g. "Email already exists")
        case Error(:final message):
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

      // ✅ Initial aur Loading pe kuch nahi karna — UI already handle kar rahi hai
        default:
          break;
      }
    });

// ── CHANGE 2: isLoading check update karo
// maybeWhen → switch pattern match
    final isLoading = switch (ref.watch(registerViewModelProvider)) {
      Loading() => true,   // ✅ Loading state — button disable
      _         => false,  // ✅ Baaki sab — button normal
    };

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenHeight * 0.12;
    final bottomBarHeight = screenHeight * 0.18;
    final hPad = screenWidth * 0.07;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── 1. Background
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

          // ── 3. Fixed bottom wave + coins + candles
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   height: bottomBarHeight,
          //   child: IgnorePointer(
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //
          //         // ✅ CHANGE 1: Yeh pehle se hai — same rehega
          //         Positioned.fill(
          //           child: AnimatedBuilder(
          //             animation: _waveCtrl,
          //             builder: (_, __) =>
          //                 CustomPaint(painter: WavePainter(_waveCtrl.value)),
          //           ),
          //         ),
          //
          //         // ✅ CHANGE 2: YEH NAYA ADD KARO — wave ke upar fade overlay
          //         // Scroll content wave ke upar aaye toh yeh usse hide kar dega
          //         Positioned.fill(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               gradient: LinearGradient(
          //                 begin: Alignment.topCenter,
          //                 end: Alignment.bottomCenter,
          //                 colors: [
          //                   const Color(0xFF1E0245).withOpacity(0.85), // top: content hide
          //                   const Color(0xFF1E0245).withOpacity(0.0),  // bottom: wave dikhti hai
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //         // ✅ CHANGE 3: Yeh sab pehle se hai — same rehega
          //         Positioned(
          //           bottom: bottomBarHeight * 0.15,
          //           left: screenWidth * 0.04,
          //           child: _GoldCoin(size: screenHeight * 0.05),
          //         ),
          //         Positioned(
          //           bottom: bottomBarHeight * 0.1,
          //           right: screenWidth * 0.04,
          //           child: _GoldCoin(size: screenHeight * 0.06),
          //         ),
          //         Positioned(
          //           bottom: bottomBarHeight * 0.2,
          //           left: screenWidth * 0.2,
          //           child: _CandleStick(),
          //         ),
          //         Positioned(
          //           bottom: bottomBarHeight * 0.15,
          //           right: screenWidth * 0.2,
          //           child: _CandleStick(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),


          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomBarHeight,
            child: IgnorePointer(   // ← wrap karo
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
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.15,
                  //   left: screenWidth * 0.04,
                  //   child: GoldCoin(size: screenHeight * 0.05),
                  // ),
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.1,
                  //   right: screenWidth * 0.04,
                  //   child: GoldCoin(size: screenHeight * 0.06),
                  // ),
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.2,
                  //   left: screenWidth * 0.2,
                  //   child: CandleStick(),
                  // ),
                  // Positioned(
                  //   bottom: bottomBarHeight * 0.15,
                  //   right: screenWidth * 0.2,
                  //   child: CandleStick(),
                  // ),
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
                    clipBehavior: Clip.hardEdge,  // ← yeh add karo
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: SlideTransition(
                        position: _slideIn,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Logo centered
                              Center(
                                child: AnimatedBuilder(
                                  animation: _shieldGlowCtrl,
                                  builder: (_, __) {
                                    final glow = _shieldGlowCtrl.value;
                                    return SizedBox(
                                      width: logoSize,
                                      height: logoSize,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
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
                              ),

                              SizedBox(height: screenHeight * 0.018),

                              // ── Title
                              Center(
                                child: Text(
                                  'Create your account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight * 0.028,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Center(
                                child: Text(
                                  'Enter your details to register',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: screenHeight * 0.016,
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.028),

                              // ── Name
                              _fieldLabel('Name'),
                              SizedBox(height: screenHeight * 0.008),
                               GlowTextField(
                                controller: _nameCtrl,   // ← controller wired
                                hint: 'Enter your name',
                                prefixIcon: Icons.person_outline_rounded,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Email
                              _fieldLabel('Email'),
                              SizedBox(height: screenHeight * 0.008),
                              GlowTextField(
                                controller: _emailCtrl,    // ← NAYA
                                hint: 'Enter your email',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Password
                              _fieldLabel('Password'),
                              SizedBox(height: screenHeight * 0.008),
                                GlowTextField(
                                controller: _passwordCtrl, // ← controller wired
                                hint: 'Enter your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Confirm Password
                              _fieldLabel('Confirm Password'),
                              SizedBox(height: screenHeight * 0.008),
                                GlowTextField(
                                controller: _confirmCtrl,  // ← controller wired
                                hint: 'Confirm your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Country Dropdown
                              _fieldLabel('Country'),
                              SizedBox(height: screenHeight * 0.008),
                              GlowDropdownCountry(
                                hint: 'Select your country',
                                prefixIcon: Icons.public_rounded,
                                items: _countries,
                                value: _selectedCountry,
                                onChanged: (val) =>
                                    setState(() => _selectedCountry = val),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Phone Number
                              _fieldLabel('Phone Number'),
                              SizedBox(height: screenHeight * 0.008),
                                GlowTextField(
                                controller: _phoneCtrl,  // ← controller wired
                                hint: '1234567890',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Age
                              _fieldLabel('Age'),
                              SizedBox(height: screenHeight * 0.008),
                                GlowTextField(
                                controller: _ageCtrl,
                                hint: 'Enter your age',
                                prefixIcon: Icons.cake_outlined,
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Gender Dropdown
                              _fieldLabel('Gender'),
                              SizedBox(height: screenHeight * 0.008),
                              GlowDropdown(
                                hint: 'Select gender',
                                prefixIcon: Icons.wc_rounded,
                                items: _genders,
                                value: _selectedGender,
                                onChanged: (val) =>
                                    setState(() => _selectedGender = val),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // ── Terms & Conditions checkbox
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _agreeToTerms = !_agreeToTerms),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: _agreeToTerms
                                            ? const Color(0xFF7C3AED)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: _agreeToTerms
                                              ? const Color(0xFF7C3AED)
                                              : Colors.white.withOpacity(0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: _agreeToTerms
                                          ? const Icon(Icons.check,
                                          size: 13, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 13,
                                          ),
                                          children: const [
                                            TextSpan(text: 'I agree to '),
                                            TextSpan(
                                              text: 'Privacy & Terms',
                                              style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(text: ', '),
                                            TextSpan(
                                              text: 'Analysis Disclaimer',
                                              style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(text: ', '),
                                            TextSpan(
                                              text: 'Comprehensive Disclaimer',
                                              style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(text: ' & '),
                                            TextSpan(
                                              text: 'Legal Disclaimer',
                                              style: TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.022),

                              // email: email
                              // ── Sign Up Button
                              SignUpButton(
                              //     onTap: () {
                              //   // Login screen mein Sign Up button pe:
                              //   Navigator.push(context, MaterialPageRoute(
                              //       builder: (_) => const OTPScreen(email: '',)
                              //   ));
                              // }

                                onTap:     isLoading ? null : _onSignUp,
                                isLoading: isLoading,

                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Or divider
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: Colors.white.withOpacity(0.18),
                                          thickness: 1)),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('Or',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.45),
                                            fontSize: 14)),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: Colors.white.withOpacity(0.18),
                                          thickness: 1)),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.014),

                              // ── Google Button
                              const GoogleSignInButton(),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Already have account
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 13.5),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate back to login
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom padding — wave ke niche nahi jayega
                              SizedBox(height: bottomBarHeight + 8),
                              // SizedBox(height: bottomBarHeight + 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.12),  // ← sirf yeh ek line
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Field label helper
  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }
}










// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _particleCtrl;
//   late AnimationController _waveCtrl;
//   late AnimationController _shieldGlowCtrl;
//   late AnimationController _entryCtrl;
//
//   late Animation<double> _fadeIn;
//   late Animation<Offset> _slideIn;
//
//   // Form state
//   bool _agreeToTerms = false;
//   String? _selectedCountry;
//   String? _selectedGender;
//
//   final List<String> _countries = [
//     'India', 'United States', 'United Kingdom', 'Canada',
//     'Australia', 'UAE', 'Singapore', 'Germany', 'France', 'Other'
//   ];
//
//   final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
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
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final logoSize = screenHeight * 0.12;
//     final bottomBarHeight = screenHeight * 0.18;
//     final hPad = screenWidth * 0.07;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           // ── 1. Background
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
//           // ── 2. Particles
//           AnimatedBuilder(
//             animation: _particleCtrl,
//             builder: (_, __) => CustomPaint(
//               painter: ParticlePainter(_particleCtrl.value, _particles),
//               child: const SizedBox.expand(),
//             ),
//           ),
//
//           // ── 3. Fixed bottom wave + coins + candles
//           // Positioned(
//           //   bottom: 0,
//           //   left: 0,
//           //   right: 0,
//           //   height: bottomBarHeight,
//           //   child: IgnorePointer(
//           //     child: Stack(
//           //       clipBehavior: Clip.none,
//           //       children: [
//           //
//           //         // ✅ CHANGE 1: Yeh pehle se hai — same rehega
//           //         Positioned.fill(
//           //           child: AnimatedBuilder(
//           //             animation: _waveCtrl,
//           //             builder: (_, __) =>
//           //                 CustomPaint(painter: WavePainter(_waveCtrl.value)),
//           //           ),
//           //         ),
//           //
//           //         // ✅ CHANGE 2: YEH NAYA ADD KARO — wave ke upar fade overlay
//           //         // Scroll content wave ke upar aaye toh yeh usse hide kar dega
//           //         Positioned.fill(
//           //           child: Container(
//           //             decoration: BoxDecoration(
//           //               gradient: LinearGradient(
//           //                 begin: Alignment.topCenter,
//           //                 end: Alignment.bottomCenter,
//           //                 colors: [
//           //                   const Color(0xFF1E0245).withOpacity(0.85), // top: content hide
//           //                   const Color(0xFF1E0245).withOpacity(0.0),  // bottom: wave dikhti hai
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //
//           //         // ✅ CHANGE 3: Yeh sab pehle se hai — same rehega
//           //         Positioned(
//           //           bottom: bottomBarHeight * 0.15,
//           //           left: screenWidth * 0.04,
//           //           child: _GoldCoin(size: screenHeight * 0.05),
//           //         ),
//           //         Positioned(
//           //           bottom: bottomBarHeight * 0.1,
//           //           right: screenWidth * 0.04,
//           //           child: _GoldCoin(size: screenHeight * 0.06),
//           //         ),
//           //         Positioned(
//           //           bottom: bottomBarHeight * 0.2,
//           //           left: screenWidth * 0.2,
//           //           child: _CandleStick(),
//           //         ),
//           //         Positioned(
//           //           bottom: bottomBarHeight * 0.15,
//           //           right: screenWidth * 0.2,
//           //           child: _CandleStick(),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//
//
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: bottomBarHeight,
//             child: IgnorePointer(   // ← wrap karo
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Positioned.fill(
//                   child: AnimatedBuilder(
//                     animation: _waveCtrl,
//                     builder: (_, __) =>
//                         CustomPaint(painter: WavePainter(_waveCtrl.value)),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: bottomBarHeight * 0.15,
//                   left: screenWidth * 0.04,
//                   child: GoldCoin(size: screenHeight * 0.05),
//                 ),
//                 Positioned(
//                   bottom: bottomBarHeight * 0.1,
//                   right: screenWidth * 0.04,
//                   child: GoldCoin(size: screenHeight * 0.06),
//                 ),
//                 Positioned(
//                   bottom: bottomBarHeight * 0.2,
//                   left: screenWidth * 0.2,
//                   child: CandleStick(),
//                 ),
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
//           // ── 4. Main scrollable content
//           SafeArea(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     clipBehavior: Clip.hardEdge,  // ← yeh add karo
//                     child: FadeTransition(
//                       opacity: _fadeIn,
//                       child: SlideTransition(
//                         position: _slideIn,
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // ── Logo centered
//                               Center(
//                                 child: AnimatedBuilder(
//                                   animation: _shieldGlowCtrl,
//                                   builder: (_, __) {
//                                     final glow = _shieldGlowCtrl.value;
//                                     return SizedBox(
//                                       width: logoSize,
//                                       height: logoSize,
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Container(
//                                             width: logoSize * 0.55 + (glow * 4),
//                                             height: logoSize * 0.55 + (glow * 4),
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: const Color(0xFFD4AF37)
//                                                       .withOpacity(0.35 + 0.25 * glow),
//                                                   blurRadius: 30 + (20 * glow),
//                                                   spreadRadius: 8 + (8 * glow),
//                                                 ),
//                                                 BoxShadow(
//                                                   color: const Color(0xFF7C3AED)
//                                                       .withOpacity(0.25 + 0.2 * glow),
//                                                   blurRadius: 45 + (20 * glow),
//                                                   spreadRadius: 4 + (4 * glow),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Image.asset(
//                                             'assets/logo.png',
//                                             width: logoSize,
//                                             height: logoSize,
//                                             fit: BoxFit.contain,
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.018),
//
//                               // ── Title
//                               Center(
//                                 child: Text(
//                                   'Create your account',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: screenHeight * 0.028,
//                                     fontWeight: FontWeight.w800,
//                                     letterSpacing: 0.3,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.005),
//                               Center(
//                                 child: Text(
//                                   'Enter your details to register',
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.55),
//                                     fontSize: screenHeight * 0.016,
//                                   ),
//                                 ),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.028),
//
//                               // ── Name
//                               _fieldLabel('Name'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: 'Enter your name',
//                                 prefixIcon: Icons.person_outline_rounded,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Email
//                               _fieldLabel('Email'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: 'Enter your email',
//                                 prefixIcon: Icons.mail_outline_rounded,
//                                 keyboardType: TextInputType.emailAddress,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Password
//                               _fieldLabel('Password'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: 'Enter your password',
//                                 prefixIcon: Icons.lock_outline_rounded,
//                                 isPassword: true,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Confirm Password
//                               _fieldLabel('Confirm Password'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: 'Confirm your password',
//                                 prefixIcon: Icons.lock_outline_rounded,
//                                 isPassword: true,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Country Dropdown
//                               _fieldLabel('Country'),
//                               SizedBox(height: screenHeight * 0.008),
//                               GlowDropdown(
//                                 hint: 'Select your country',
//                                 prefixIcon: Icons.public_rounded,
//                                 items: _countries,
//                                 value: _selectedCountry,
//                                 onChanged: (val) =>
//                                     setState(() => _selectedCountry = val),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Phone Number
//                               _fieldLabel('Phone Number'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: '1234567890',
//                                 prefixIcon: Icons.phone_outlined,
//                                 keyboardType: TextInputType.phone,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Age
//                               _fieldLabel('Age'),
//                               SizedBox(height: screenHeight * 0.008),
//                               const GlowTextField(
//                                 hint: 'Enter your age',
//                                 prefixIcon: Icons.cake_outlined,
//                                 keyboardType: TextInputType.number,
//                               ),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Gender Dropdown
//                               _fieldLabel('Gender'),
//                               SizedBox(height: screenHeight * 0.008),
//                               GlowDropdown(
//                                 hint: 'Select gender',
//                                 prefixIcon: Icons.wc_rounded,
//                                 items: _genders,
//                                 value: _selectedGender,
//                                 onChanged: (val) =>
//                                     setState(() => _selectedGender = val),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.02),
//
//                               // ── Terms & Conditions checkbox
//                               GestureDetector(
//                                 onTap: () =>
//                                     setState(() => _agreeToTerms = !_agreeToTerms),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     AnimatedContainer(
//                                       duration: const Duration(milliseconds: 200),
//                                       width: 20,
//                                       height: 20,
//                                       margin: const EdgeInsets.only(top: 2),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: _agreeToTerms
//                                             ? const Color(0xFF7C3AED)
//                                             : Colors.transparent,
//                                         border: Border.all(
//                                           color: _agreeToTerms
//                                               ? const Color(0xFF7C3AED)
//                                               : Colors.white.withOpacity(0.4),
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       child: _agreeToTerms
//                                           ? const Icon(Icons.check,
//                                           size: 13, color: Colors.white)
//                                           : null,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                       child: RichText(
//                                         text: TextSpan(
//                                           style: TextStyle(
//                                             color: Colors.white.withOpacity(0.7),
//                                             fontSize: 13,
//                                           ),
//                                           children: const [
//                                             TextSpan(text: 'I agree to '),
//                                             TextSpan(
//                                               text: 'Privacy & Terms',
//                                               style: TextStyle(
//                                                 color: Color(0xFFD4AF37),
//                                                 decoration: TextDecoration.underline,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             TextSpan(text: ', '),
//                                             TextSpan(
//                                               text: 'Analysis Disclaimer',
//                                               style: TextStyle(
//                                                 color: Color(0xFFD4AF37),
//                                                 decoration: TextDecoration.underline,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             TextSpan(text: ', '),
//                                             TextSpan(
//                                               text: 'Comprehensive Disclaimer',
//                                               style: TextStyle(
//                                                 color: Color(0xFFD4AF37),
//                                                 decoration: TextDecoration.underline,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             TextSpan(text: ' & '),
//                                             TextSpan(
//                                               text: 'Legal Disclaimer',
//                                               style: TextStyle(
//                                                 color: Color(0xFFD4AF37),
//                                                 decoration: TextDecoration.underline,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               SizedBox(height: screenHeight * 0.022),
//
//                              // email: email
//                               // ── Sign Up Button
//                               SignUpButton(onTap: () {
//                                 // Login screen mein Sign Up button pe:
//                                 Navigator.push(context, MaterialPageRoute(
//                                     builder: (_) => const OTPScreen()
//                                 ));
//                               }),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Or divider
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: Divider(
//                                           color: Colors.white.withOpacity(0.18),
//                                           thickness: 1)),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                     child: Text('Or',
//                                         style: TextStyle(
//                                             color: Colors.white.withOpacity(0.45),
//                                             fontSize: 14)),
//                                   ),
//                                   Expanded(
//                                       child: Divider(
//                                           color: Colors.white.withOpacity(0.18),
//                                           thickness: 1)),
//                                 ],
//                               ),
//
//                               SizedBox(height: screenHeight * 0.014),
//
//                               // ── Google Button
//                               const GoogleSignInButton(),
//
//                               SizedBox(height: screenHeight * 0.016),
//
//                               // ── Already have account
//                               Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Already have an account? ',
//                                       style: TextStyle(
//                                           color: Colors.white.withOpacity(0.6),
//                                           fontSize: 13.5),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         // Navigate back to login
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text(
//                                         'Sign In',
//                                         style: TextStyle(
//                                           color: Color(0xFFD4AF37),
//                                           fontSize: 13.5,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               // Bottom padding — wave ke niche nahi jayega
//                               SizedBox(height: bottomBarHeight + 8),
//                              // SizedBox(height: bottomBarHeight + 60),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.12),  // ← sirf yeh ek line
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Field label helper
//   Widget _fieldLabel(String label) {
//     return Text(
//       label,
//       style: TextStyle(
//         color: Colors.white.withOpacity(0.8),
//         fontSize: 13.5,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.2,
//       ),
//     );
//   }
// }