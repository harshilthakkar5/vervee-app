import 'dart:math' as math;
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'ParentVerificationScreen.dart';
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
  final _parentEmailCtrl = TextEditingController();
  final _referralCtrl    = TextEditingController();
  DateTime? _selectedDob;
  Country? _phoneCountry;
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

  // DOB se nikli age 18 se kam hai ya nahi
  bool get _isUnder18 {
    final a = int.tryParse(_ageCtrl.text);
    return a != null && a < 18;
  }

  // ── Inline validation errors (key = field name)
  final Map<String, String?> _errors = {};

  static const _requiredKeys = [
    'name', 'email', 'password', 'confirm',
    'country', 'phone', 'age', 'terms',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // ── Har policy ka apna URL — apne actual URLs se replace karo
  static const String _privacyTermsUrl        = 'https://app.theverveeacademy.com/pdf/Vervee_Academy_Disclaimer.pdf';
  static const String _analysisDisclaimerUrl  = 'https://app.theverveeacademy.com/pdf/Vervee_Academy_Analysis_Disclaimer.pdf';
  static const String _comprehensiveDisclaimerUrl = 'https://app.theverveeacademy.com/pdf/Vervee_Academy_Comprehensive_Legal_Disclaimers.pdf';
  static const String _legalDisclaimerUrl     = 'https://app.theverveeacademy.com/pdf/Vervee_Academy_Legal_Disclaimer.pdf';

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
    _phoneCountry = Country.parse('US');   // ← default dial code +91

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


  // ── State class ke andar (dispose() se pehle) ye method add karo:
// Ek hi jagah se URL launch karega, error handling ke saath
  Future<void> _openPolicyLink(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,   // ← Chrome / default browser mein khulega
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Could not open link: $url'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
    }
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

    _parentEmailCtrl.dispose();
    _referralCtrl.dispose();

    _particleCtrl.dispose();
    _waveCtrl.dispose();
    _shieldGlowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  String? _validate(String key) {
    switch (key) {
      case 'name':
        return _nameCtrl.text.trim().isEmpty ? 'Name is required' : null;
      case 'email':
        final v = _emailCtrl.text.trim();
        if (v.isEmpty) return 'Email is required';
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
          return 'Enter a valid email address';
        }
        return null;
      case 'password':
        return _passwordCtrl.text.isEmpty ? 'Password is required' : null;
      case 'confirm':
        if (_confirmCtrl.text.isEmpty) return 'Please confirm your password';
        if (_confirmCtrl.text != _passwordCtrl.text) return 'Passwords do not match';
        return null;
      case 'country':
        return _selectedCountry == null ? 'Please select your country' : null;
      case 'phone':
        return _phoneCtrl.text.trim().isEmpty ? 'Phone number is required' : null;
      case 'age':
        return _ageCtrl.text.isEmpty ? 'Please select your date of birth' : null;
      case 'parentEmail':
        if (!_isUnder18) return null;
        final pv = _parentEmailCtrl.text.trim();
        if (pv.isEmpty) return "Parent's email is required";
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(pv)) {
          return 'Enter a valid email address';
        }
        if (pv.toLowerCase() == _emailCtrl.text.trim().toLowerCase()) {
          return "Parent's email must be different from your email";
        }
        return null;
      case 'terms':
        return _agreeToTerms ? null : 'Please accept terms and conditions';
    }
    return null;
  }

  void _validateField(String key) =>
      setState(() => _errors[key] = _validate(key));

// Error dikh raha ho toh user type karte hi live update/clear ho jaye
  void _revalidateIfError(String key) {
    if (_errors[key] != null) _validateField(key);
  }

  // bool _validateAll() {
  //   setState(() {
  //     for (final k in _requiredKeys) {
  //       _errors[k] = _validate(k);
  //     }
  //   });
  //   return _requiredKeys.every((k) => _errors[k] == null);
  // }

  bool _validateAll() {
    final keys = [..._requiredKeys, if (_isUnder18) 'parentEmail'];
    setState(() {
      for (final k in keys) {
        _errors[k] = _validate(k);
      }
      if (!_isUnder18) _errors['parentEmail'] = null;
    });
    return keys.every((k) => _errors[k] == null);
  }

  // ── CHANGE 5: Sign Up handler — ViewModel ko call karta hai
  //    Yeh method SignUpButton ke onTap mein use hoga
  void _onSignUp() {

    // Keyboard band karo (best practice — form submit pe)
    FocusScope.of(context).unfocus();

    if (!_validateAll()) return;

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
      //phoneNo:         _phoneCtrl.text,
      phoneNo: '+${_phoneCountry?.phoneCode ?? '91'}${_phoneCtrl.text.trim()}',
      terms:           _agreeToTerms,
      parentEmail:     _isUnder18 ? _parentEmailCtrl.text.trim() : null, // ✅ NEW
      referralCode:    _referralCtrl.text.trim().isEmpty
          ? null
          : _referralCtrl.text.trim(),
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
      //   case Success(:final data):
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => OTPScreen(
      //             email: _emailCtrl.text.trim(),
      //             password: _passwordCtrl.text,
      //
      //         ),
      //       ),
      //     );

        case Success(:final data):
          if (data.isUnder18) {
            // ✅ Under 18 → OTP nahi, Parent Verification screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ParentVerificationScreen(
                  parentEmail: _parentEmailCtrl.text.trim(),
                  message: data.message,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OTPScreen(
                  email: _emailCtrl.text.trim(),
                  password: _passwordCtrl.text,
                ),
              ),
            );
          }

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


          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   height: bottomBarHeight,
          //   child: IgnorePointer(   // ← wrap karo
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //         Positioned.fill(
          //           child: AnimatedBuilder(
          //             animation: _waveCtrl,
          //             builder: (_, __) =>
          //                 CustomPaint(painter: WavePainter(_waveCtrl.value)),
          //           ),
          //         ),
          //         // Positioned(
          //         //   bottom: bottomBarHeight * 0.15,
          //         //   left: screenWidth * 0.04,
          //         //   child: GoldCoin(size: screenHeight * 0.05),
          //         // ),
          //         // Positioned(
          //         //   bottom: bottomBarHeight * 0.1,
          //         //   right: screenWidth * 0.04,
          //         //   child: GoldCoin(size: screenHeight * 0.06),
          //         // ),
          //         // Positioned(
          //         //   bottom: bottomBarHeight * 0.2,
          //         //   left: screenWidth * 0.2,
          //         //   child: CandleStick(),
          //         // ),
          //         // Positioned(
          //         //   bottom: bottomBarHeight * 0.15,
          //         //   right: screenWidth * 0.2,
          //         //   child: CandleStick(),
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),

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
                              SizedBox(height: screenHeight * 0.006),
                             // SizedBox(height: screenHeight * 0.006),
                              Center(
                                child: Text(
                                  'Enter your details to register',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: screenHeight * 0.016,
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),
                              SizedBox(height: screenHeight * 0.006),

                              Center(
                                child: Text(
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
                              ),

                              SizedBox(height: screenHeight * 0.028),

                              // ── Name
                              _fieldLabel('Name',isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              //  GlowTextField(
                              //   controller: _nameCtrl,   // ← controller wired
                              //   hint: 'Enter your name',
                              //   prefixIcon: Icons.person_outline_rounded,
                              // ),
                              GlowTextField(
                                controller: _nameCtrl,
                                hint: 'Enter your name',
                                prefixIcon: Icons.person_outline_rounded,
                                errorText: _errors['name'],
                                onFocusLost: () => _validateField('name'),
                                onChanged: (_) => _revalidateIfError('name'),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Email
                              _fieldLabel('Email', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              // GlowTextField(
                              //   controller: _emailCtrl,    // ← NAYA
                              //   hint: 'Enter your email',
                              //   prefixIcon: Icons.mail_outline_rounded,
                              //   keyboardType: TextInputType.emailAddress,
                              // ),

                              // Email
                              GlowTextField(
                                controller: _emailCtrl,
                                hint: 'Enter your email',
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                errorText: _errors['email'],
                                onFocusLost: () => _validateField('email'),
                                onChanged: (_) => _revalidateIfError('email'),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Password
                              _fieldLabel('Password', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              //   GlowTextField(
                              //   controller: _passwordCtrl, // ← controller wired
                              //   hint: 'Enter your password',
                              //   prefixIcon: Icons.lock_outline_rounded,
                              //   isPassword: true,
                              // ),

                              // Password
                              GlowTextField(
                                controller: _passwordCtrl,
                                hint: 'Enter your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                errorText: _errors['password'],
                                onFocusLost: () {
                                  _validateField('password');
                                  if (_confirmCtrl.text.isNotEmpty) _validateField('confirm');
                                },
                                onChanged: (_) {
                                  _revalidateIfError('password');
                                  if (_confirmCtrl.text.isNotEmpty) _validateField('confirm'); // password badla toh match dobara check
                                },
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Confirm Password
                              _fieldLabel('Confirm Password', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              //   GlowTextField(
                              //   controller: _confirmCtrl,  // ← controller wired
                              //   hint: 'Confirm your password',
                              //   prefixIcon: Icons.lock_outline_rounded,
                              //   isPassword: true,
                              // ),

                              // Confirm Password
                              GlowTextField(
                                controller: _confirmCtrl,
                                hint: 'Confirm your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                errorText: _errors['confirm'],
                                onFocusLost: () => _validateField('confirm'),
                                onChanged: (_) => _revalidateIfError('confirm'),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Country Dropdown
                              _fieldLabel('Country', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              // GlowDropdownCountry(
                              //   hint: 'Select your country',
                              //   prefixIcon: Icons.public_rounded,
                              //   items: _countries,
                              //   value: _selectedCountry,
                              //   onChanged: (val) =>
                              //       setState(() => _selectedCountry = val),
                              // ),

                              // Country
                              GlowDropdownCountry(
                                hint: 'Select your country',
                                prefixIcon: Icons.public_rounded,
                                items: _countries,
                                value: _selectedCountry,
                                errorText: _errors['country'],
                                onChanged: (val) => setState(() {
                                  _selectedCountry = val;
                                  _errors['country'] = null;

                                  // ✅ NEW: country select hote hi phone code auto-set
                                  if (val != null) {
                                    _phoneCountry = val;
                                  }
                                }),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Phone Number
                              // ── Phone Number
                              _fieldLabel('Phone Number', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Country code button (flag + dial code)
                                  GestureDetector(
                                    onTap: _pickPhoneCountryCode,
                                    child: Container(
                                      height: 54,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.09),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_phoneCountry?.flagEmoji ?? '🌐', style: const TextStyle(fontSize: 20)),
                                          const SizedBox(width: 4),
                                          Text(
                                            '+${_phoneCountry?.phoneCode ?? '91'}',
                                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                          Icon(Icons.arrow_drop_down_rounded, color: Colors.white.withOpacity(0.6), size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // ── Number field
                                  Expanded(
                                    // child: GlowTextField(
                                    //   controller: _phoneCtrl,
                                    //   hint: '1234567890',
                                    //   prefixIcon: Icons.phone_outlined,
                                    //   keyboardType: TextInputType.phone,
                                    // ),

                                    // Phone number field (Row ke andar wala GlowTextField)
                                    child: GlowTextField(
                                      controller: _phoneCtrl,
                                      hint: '1234567890',
                                      prefixIcon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      errorText: _errors['phone'],
                                      onFocusLost: () => _validateField('phone'),
                                      onChanged: (_) => _revalidateIfError('phone'),
                                    ),
                                  ),
                                ],
                              ),


                              // _fieldLabel('Phone Number', isRequired: true),
                              // SizedBox(height: screenHeight * 0.008),
                              //   GlowTextField(
                              //   controller: _phoneCtrl,  // ← controller wired
                              //   hint: '1234567890',
                              //   prefixIcon: Icons.phone_outlined,
                              //   keyboardType: TextInputType.phone,
                              // ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Age
                              // _fieldLabel('Age', isRequired: true),
                              // SizedBox(height: screenHeight * 0.008),
                              //   GlowTextField(
                              //   controller: _ageCtrl,
                              //   hint: 'Enter your age',
                              //   prefixIcon: Icons.cake_outlined,
                              //   keyboardType: TextInputType.number,
                              // ),

                              _fieldLabel('Age', isRequired: true),
                              SizedBox(height: screenHeight * 0.008),
                              GestureDetector(
                                onTap: _pickDateOfBirth,
                                child: AbsorbPointer(   // ← keyboard nahi khulega, sirf calendar khulega
                                  // child: GlowTextField(
                                  //   controller: _ageCtrl,
                                  //   hint: 'Select date of birth to auto-fill age',
                                  //   prefixIcon: Icons.cake_outlined,
                                  //   keyboardType: TextInputType.number,
                                  // ),

                                  child: GlowTextField(
                                    controller: _ageCtrl,
                                    hint: 'Select date of birth to auto-fill age',
                                    prefixIcon: Icons.cake_outlined,
                                    keyboardType: TextInputType.number,
                                    errorText: _errors['age'],
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.016),

                              // ── Parent Email (sirf under 18)
                              AnimatedSize(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                                alignment: Alignment.topCenter,
                                child: _isUnder18
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel("Parent's Email", isRequired: true),
                                    SizedBox(height: screenHeight * 0.008),
                                    GlowTextField(
                                      controller: _parentEmailCtrl,
                                      hint: "Enter your parent's email",
                                      prefixIcon: Icons.family_restroom_rounded,
                                      keyboardType: TextInputType.emailAddress,
                                      errorText: _errors['parentEmail'],
                                      onFocusLost: () => _validateField('parentEmail'),
                                      onChanged: (_) => _revalidateIfError('parentEmail'),
                                    ),
                                    SizedBox(height: screenHeight * 0.006),
                                    Text(
                                      'Since you are under 18, a verification link will be sent to your parent.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.016),
                                  ],
                                )
                                    : const SizedBox.shrink(),
                              ),

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

                             // SizedBox(height: screenHeight * 0.02),

                              SizedBox(height: screenHeight * 0.016),

                              _fieldLabel('Referral Code (optional)'),
                              SizedBox(height: screenHeight * 0.008),
                              GlowTextField(
                                controller: _referralCtrl,
                                hint: 'Enter referral code',
                                prefixIcon: Icons.card_giftcard_rounded,
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // ── Terms & Conditions checkbox
                              GestureDetector(
                                // onTap: () =>
                                //     setState(() => _agreeToTerms = !_agreeToTerms),
                                onTap: () => setState(() {
                                  _agreeToTerms = !_agreeToTerms;
                                  _errors['terms'] = _validate('terms');
                                }),
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
                                      // ── NOTE: ab RichText direct GestureDetector ke andar nahi hai,
                                      // isliye checkbox toggle aur link tap dono independently kaam karenge.
                                      // Checkbox ke text area ko tap karne se bhi checkbox toggle hoga
                                      // (jaisa pehle tha), sirf underlined links pe tap karne se link khulega.
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 13,
                                          ),
                                          children: [
                                            const TextSpan(text: 'I agree to '),
                                            TextSpan(
                                              text: 'Privacy & Terms',
                                              style: const TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _openPolicyLink(_privacyTermsUrl),
                                            ),
                                            const TextSpan(text: ', '),
                                            TextSpan(
                                              text: 'Analysis Disclaimer',
                                              style: const TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _openPolicyLink(_analysisDisclaimerUrl),
                                            ),
                                            const TextSpan(text: ', '),
                                            TextSpan(
                                              text: 'Comprehensive Disclaimer',
                                              style: const TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _openPolicyLink(_comprehensiveDisclaimerUrl),
                                            ),
                                            const TextSpan(text: ' & '),
                                            TextSpan(
                                              text: 'Legal Disclaimer',
                                              style: const TextStyle(
                                                color: Color(0xFFD4AF37),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => _openPolicyLink(_legalDisclaimerUrl),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_errors['terms'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, left: 4),
                                  child: Text(
                                    _errors['terms']!,
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                  ),
                                ),




                              // GestureDetector(
                              //   onTap: () =>
                              //       setState(() => _agreeToTerms = !_agreeToTerms),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       AnimatedContainer(
                              //         duration: const Duration(milliseconds: 200),
                              //         width: 20,
                              //         height: 20,
                              //         margin: const EdgeInsets.only(top: 2),
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(5),
                              //           color: _agreeToTerms
                              //               ? const Color(0xFF7C3AED)
                              //               : Colors.transparent,
                              //           border: Border.all(
                              //             color: _agreeToTerms
                              //                 ? const Color(0xFF7C3AED)
                              //                 : Colors.white.withOpacity(0.4),
                              //             width: 1.5,
                              //           ),
                              //         ),
                              //         child: _agreeToTerms
                              //             ? const Icon(Icons.check,
                              //             size: 13, color: Colors.white)
                              //             : null,
                              //       ),
                              //       const SizedBox(width: 10),
                              //       Expanded(
                              //         child: RichText(
                              //           text: TextSpan(
                              //             style: TextStyle(
                              //               color: Colors.white.withOpacity(0.7),
                              //               fontSize: 13,
                              //             ),
                              //             children: const [
                              //               TextSpan(text: 'I agree to '),
                              //               TextSpan(
                              //                 text: 'Privacy & Terms',
                              //                 style: TextStyle(
                              //                   color: Color(0xFFD4AF37),
                              //                   decoration: TextDecoration.underline,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               TextSpan(text: ', '),
                              //               TextSpan(
                              //                 text: 'Analysis Disclaimer',
                              //                 style: TextStyle(
                              //                   color: Color(0xFFD4AF37),
                              //                   decoration: TextDecoration.underline,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               TextSpan(text: ', '),
                              //               TextSpan(
                              //                 text: 'Comprehensive Disclaimer',
                              //                 style: TextStyle(
                              //                   color: Color(0xFFD4AF37),
                              //                   decoration: TextDecoration.underline,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //               TextSpan(text: ' & '),
                              //               TextSpan(
                              //                 text: 'Legal Disclaimer',
                              //                 style: TextStyle(
                              //                   color: Color(0xFFD4AF37),
                              //                   decoration: TextDecoration.underline,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

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
                              SizedBox(height: bottomBarHeight + 24),
                              // SizedBox(height: bottomBarHeight + 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: screenHeight * 0.12),  // ← sirf yeh ek line
                //SizedBox(height: 60),  // ← sirf yeh ek line
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomBarHeight,
            child: IgnorePointer(  // taps neeche content tak pahunch jayenge
              child: AnimatedBuilder(
                animation: _waveCtrl,
                builder: (_, __) => CustomPaint(painter: WavePainter(_waveCtrl.value)),
              ),
            ),
          ),

        ],
      ),
    );
  }

  // ── Country code picker — search built-in hai, bas theme dark lagayi
  void _pickPhoneCountryCode() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,   // list mein dial code bhi dikhega
      countryListTheme: CountryListThemeData(
        backgroundColor: const Color(0xFF1E0245),
        textStyle: const TextStyle(color: Colors.white, fontSize: 15),
        searchTextStyle: const TextStyle(color: Colors.white),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        inputDecoration: InputDecoration(
          hintText: 'Search country or code',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      onSelect: (country) {
        setState(() => _phoneCountry = country);
      },
    );
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initial = _selectedDob ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendar, // ← calendar mode se start (recommended)
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9333EA),
              onPrimary: Colors.white,
              surface: Color(0xFF1E0245),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E0245),

            // ✅ YEH NAYA ADD KARO — manual date entry text field ka color fix karega
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(color: Color(0xFFD4AF37)),
              floatingLabelStyle: const TextStyle(color: Color(0xFFD4AF37)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9333EA), width: 1.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF9333EA), width: 2),
              ),
            ),

            // ✅ Typed text ka color white karega
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    // if (picked != null) {
    //   setState(() {
    //     _selectedDob = picked;
    //     _ageCtrl.text = _calculateAge(picked).toString();
    //   });
    // }

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _ageCtrl.text = _calculateAge(picked).toString();
        _errors['age'] = null;
        if (!_isUnder18) _errors['parentEmail'] = null;
      });
    } else {
      _validateField('age');
    }
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  // ── Field label helper
  // Widget _fieldLabel(String label) {
  //   return Text(
  //     label,
  //     style: TextStyle(
  //       color: Colors.white.withOpacity(0.8),
  //       fontSize: 13.5,
  //       fontWeight: FontWeight.w500,
  //       letterSpacing: 0.2,
  //     ),
  //   );
  // }
  // ── Field label helper
  // isRequired: true → label ke baad ek RED "*" add hota hai
  Widget _fieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        children: isRequired
            ? const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,   // ← sirf star red
              fontWeight: FontWeight.w700,
            ),
          ),
        ]
            : null,
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