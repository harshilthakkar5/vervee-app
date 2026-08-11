
// ─────────────────────────────────────────────────────────────────────────────
//  FILE: presentation/screens/AvatarCustomizationScreen.dart
//  API integrated — GET user-info, POST select-mascot, POST customize
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../viewmodal/avatar/AvatarState.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';

//import '../viewmodel/avatar/AvatarViewModel.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════════════════════════════════════
const Color kBgDark      = Color(0xFF0F0120);
const Color kBgCard      = Color(0xFF150328);
const Color kBgDeep      = Color(0xFF0A0118);
const Color kPurple      = Color(0xFF7C3AED);
const Color kPurpleLight = Color(0xFF9333EA);
const Color kNeon        = Color(0xFFCC00FF);
const Color kGold        = Color(0xFFD4AF37);
const Color kGoldLight   = Color(0xFFFFD700);
const Color kBorder      = Color(0xFF2D1050);
const Color kTextMuted   = Color(0xFF888888);
const Color kTextPrimary = Colors.white;
const Color kRed         = Color(0xFFEF4444);
const Color kGreen       = Color(0xFF22C55E);

// ─── Gear Item Model ──────────────────────────────────────────────────────
class _GearItem {
  final String emoji;
  final String label;
  bool equipped;
  _GearItem(this.emoji, this.label, {this.equipped = false});
}

// ─── Avatar Customization Screen ─────────────────────────────────────────
// ✅ StatefulWidget → ConsumerStatefulWidget (Riverpod ke liye)
class AvatarCustomizationScreen extends ConsumerStatefulWidget {
  const AvatarCustomizationScreen({super.key});

  @override
  ConsumerState<AvatarCustomizationScreen> createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState
    extends ConsumerState<AvatarCustomizationScreen>
    with TickerProviderStateMixin {

  int _activeTab     = 0;
  int _avatarIndex   = 0;
  int _equippedCount = 0;
  bool _resetPressed = false;
  int? _savedAvatarIndex;
 // bool _userSwitchedAvatar = false; // class level variable

  late AnimationController _glowCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double>   _glowAnim;
  late Animation<double>   _rotateAnim;
  late Animation<double>   _bounceAnim;

  final TextEditingController _visionCtrl = TextEditingController();

  final List<String> _avatarImages = [
    'assets/avatar/my-avatar-falcor.png',
    'assets/avatar/my-avatar-hugo.png',
    'assets/avatar/my-avatar-maxbull.png',
    'assets/avatar/my-avatar-grizz.png',
    'assets/avatar/my-avatar-blazefox.png',
    'assets/avatar/my-avatar-rockyshell.png',
  ];
  final List<String> _avatarNames = ['Falcor','Hugo','MaxBull','Grizz','BlazeFox','RockyShell'];
  final List<String> _avatarClass = [
    'Cyber-Paladin','Gold Hunter','Shadow Trader',
    'Market Fox','Bull Rider','Sky Analyst'
  ];

  final List<_GearItem> _gearItems = [
    _GearItem('👕', 'Shirt'),
    _GearItem('🧢', 'Headwear'),
    _GearItem('⌚', 'Watch'),
    _GearItem('💍', 'Accessory'),
    _GearItem('👟', 'Footwear'),
    _GearItem('🎧', 'Audio'),
    _GearItem('🕶️', 'Eyewear'),
    _GearItem('🎒', 'Backpack'),
    _GearItem('🛹', 'Gear'),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _rotateCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _rotateAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateCtrl);

    _bounceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _bounceAnim = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));

    // ✅ ADD — build ke baad ek baar check karo, cached state se URL milega
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final savedUrl = ref.read(avatarViewModelProvider).generatedMascotUrl;
    //   if (savedUrl != null) {
    //     // ✅ Pehle se URL hai — switched flag false rakho taaki turant dikhe
    //     setState(() => _userSwitchedAvatar = false);
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedUrl = ref.read(avatarViewModelProvider).generatedMascotUrl;
      if (savedUrl != null) {
        // ✅ Pehle se saved avatar hai — current index ko saved maano
        setState(() => _savedAvatarIndex = _avatarIndex);
      }
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _rotateCtrl.dispose();
    _bounceCtrl.dispose();
    _visionCtrl.dispose();
    super.dispose();
  }

  void _toggleGear(int idx) {
    setState(() {
      _gearItems[idx].equipped = !_gearItems[idx].equipped;
      _equippedCount = _gearItems.where((g) => g.equipped).length;
    });
    _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
  }

  // void _prevAvatar() => setState(() =>
  // _avatarIndex = (_avatarIndex - 1 + _avatarImages.length) % _avatarImages.length);
  //
  // void _nextAvatar() => setState(() =>
  // _avatarIndex = (_avatarIndex + 1) % _avatarImages.length);

  // void _prevAvatar() => setState(() {
  //   _userSwitchedAvatar = true;  // ✅ user ne switch kiya
  //   _avatarIndex = (_avatarIndex - 1 + _avatarImages.length) % _avatarImages.length;
  // });
  //
  // void _nextAvatar() => setState(() {
  //   _userSwitchedAvatar = true;  // ✅ user ne switch kiya
  //   _avatarIndex = (_avatarIndex + 1) % _avatarImages.length;
  // });

  void _prevAvatar() => setState(() =>
  _avatarIndex = (_avatarIndex - 1 + _avatarImages.length) % _avatarImages.length);

  void _nextAvatar() => setState(() =>
  _avatarIndex = (_avatarIndex + 1) % _avatarImages.length);

  // ── ✅ API: asset image ko temp File mein convert karo ───────────────────
  Future<File> _assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir  = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file     = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  // ── ✅ API: POST select-mascot ────────────────────────────────────────────
  Future<void> _selectMascot() async {
    final file = await _assetToFile(_avatarImages[_avatarIndex]);
    await ref.read(avatarViewModelProvider.notifier).selectMascot(
      avatarIndex: _avatarIndex,
      avatarFile:  file,
    );
  }

  // ── ✅ API: POST customize (Generate New Look) ────────────────────────────
  Future<void> _generateLook() async {
    final equippedLabels = _gearItems
        .where((g) => g.equipped)
        .map((g) => g.label)
        .toList();

    await ref.read(avatarViewModelProvider.notifier).generateLook(
      equippedLabels: equippedLabels,
      customPrompt:   _visionCtrl.text,
    );
  }

  // ── SnackBar helpers ──────────────────────────────────────────────────────
  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kPurple,
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade800,
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // ✅ ViewModel state listen karo
    final avatarState = ref.watch(avatarViewModelProvider);

    // ✅ Side effects — success/error snackbars
    ref.listen(avatarViewModelProvider, (prev, next) {
      // Error
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        _showError(next.errorMessage!);
        ref.read(avatarViewModelProvider.notifier).clearError();
      }

      // ✅ ADD — loadUserInfo complete hone pe savedAvatarIndex set karo
      if (prev?.isLoadingInfo == true && next.isLoadingInfo == false) {
        if (next.generatedMascotUrl != null) {
          setState(() => _savedAvatarIndex = _avatarIndex);
        }
      }

      // Mascot save success
      // if (next.mascotSaved && !(prev?.mascotSaved ?? false)) {
      //   setState(() => _userSwitchedAvatar = false);
      //   _showSuccess('Avatar saved successfully! ✦');
      //   ref.read(avatarViewModelProvider.notifier).resetSuccessFlags();
      // }
      // // Customize/generate success
      // if (next.customizeSuccess && !(prev?.customizeSuccess ?? false)) {
      //   setState(() => _userSwitchedAvatar = false);
      //   _showSuccess('New look generated! ✦');
      //   ref.read(avatarViewModelProvider.notifier).resetSuccessFlags();
      // }
      // ── ref.listen mein — save success pe savedAvatarIndex set karo ───────────

// Mascot save success
      if (next.mascotSaved && !(prev?.mascotSaved ?? false)) {
        setState(() => _savedAvatarIndex = _avatarIndex); // ✅ current index save karo
        _showSuccess('Avatar saved successfully! ✦');
        ref.read(avatarViewModelProvider.notifier).resetSuccessFlags();
      }

// Generate success
      if (next.customizeSuccess && !(prev?.customizeSuccess ?? false)) {
        setState(() => _savedAvatarIndex = _avatarIndex); // ✅ same here
        _showSuccess('New look generated! ✦');
        ref.read(avatarViewModelProvider.notifier).resetSuccessFlags();
      }
    });

    // ✅ Generate button ka loading — ViewModel se lo
    final bool isGenerating = avatarState.isGenerating;

    // ✅ CHANGE 2: avatar unsaved he ya nahi wo check karo — savedIndex != current index matlab unsaved
    final bool isAvatarUnsaved = _savedAvatarIndex != _avatarIndex;

    return Scaffold(
      backgroundColor: kBgDark,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Loading shimmer jab user-info load ho raha ho ──────────
                if (avatarState.isLoadingInfo)
                  const SliverToBoxAdapter(child: _LoadingBar()),

                SliverToBoxAdapter(child: _buildHeroSection(size, isTablet, avatarState)),
                SliverToBoxAdapter(child: _buildActionRow(avatarState)),
                SliverToBoxAdapter(child: _buildTabs()),
                SliverToBoxAdapter(
                  child: _activeTab == 0
                      ? _buildCustomizeTab(size, isGenerating, isAvatarUnsaved)
                      : _buildDetailsTab(avatarState),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    final avatarUrl = ref.watch(avatarViewModelProvider).generatedMascotUrl; // ✅ ADD
    final profileState = ref.watch(profileInfoViewModelProvider);
    return Container(
      color: kBgCard,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 4, right: 12, bottom: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [kGold, kGoldLight],
                    ).createShader(bounds),
                    child: const Text('VERVEE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3)),
                  ),
                  const Text('A C A D E M Y',
                      style: TextStyle(
                          color: kPurpleLight,
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3)),
                ],
              ),
              const Spacer(),
              // IconButton(
              //   icon: const Icon(Icons.search_rounded, color: kPurpleLight, size: 22),
              //   onPressed: () {},
              // ),
              Container(
                width: 34, height: 34,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ✅ Agar URL hai to gradient hatao, warna rakhao
                  gradient: avatarUrl == null
                      ? const LinearGradient(
                    colors: [kGold, kPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                ),
                child: avatarUrl != null
                // ✅ Saved avatar image dikhao
                    ? ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 34, height: 34,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        // API se naam aaya to initial, warna 'VA'
                        profileState.profile != null
                            ? profileState.profile!.name
                            .substring(0, 1)
                            .toUpperCase()
                            : 'VA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                // ✅ Default 'VA' text
                    : const Center(
                  child: Text('VA',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ),

              // Container(
              //   width: 34, height: 34,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     gradient: LinearGradient(
              //       colors: [kGold, kPurple],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //   ),
              //   child: const Center(
              //     child: Text('VA',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 11,
              //             fontWeight: FontWeight.w700)),
              //   ),
              // ),
            ],
          ),
          Container(height: 0.5, color: kBorder),
        ],
      ),
    );
  }

  // ── Hero Section ────────────────────────────────────────────────────────
  // ✅ avatarState pass kiya — agar server se URL aaya hai to wo dikhao
  Widget _buildHeroSection(Size size, bool isTablet, AvatarState avatarState) {
    final String? serverUrl = avatarState.generatedMascotUrl;
    final double heroHeight = isTablet ? 580.0 : 460.0; // 480.0 : 360.0;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        children: [
          // ── Full bleed avatar image ─────────────────────────────
          // ── Full bleed avatar image ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: heroHeight * 0.88, // ✅ hero ka 85% — top pe space milega
            child: avatarState.isLoadingInfo
                ? Container(
              color: const Color(0xFF0A0118),
              child: const Center(
                child: CircularProgressIndicator(color: kNeon, strokeWidth: 2.5),
              ),
            )
                : (_savedAvatarIndex == _avatarIndex && serverUrl != null)
                ? Image.network(
              serverUrl,
              fit: BoxFit.contain, // ✅ cover → contain, image crop nahi hogi
              alignment: Alignment.topCenter,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                // return Image.asset(
                //   _avatarImages[_avatarIndex],
                //   fit: BoxFit.contain,
                //   alignment: Alignment.topCenter,
                // );
                return Container(
                  color: const Color(0xFF0A0118),
                  child: const Center(
                    child: CircularProgressIndicator(color: kNeon, strokeWidth: 2.5),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Image.asset(
                _avatarImages[_avatarIndex],
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            )
                : Image.asset(
              _avatarImages[_avatarIndex],
              fit: BoxFit.contain, // ✅ contain
              alignment: Alignment.topCenter,
            ),
          ),


          // Positioned.fill(
          //   child: avatarState.isLoadingInfo
          //       ? Container(
          //     color: const Color(0xFF0A0118),
          //     child: const Center(
          //       child: CircularProgressIndicator(color: kNeon, strokeWidth: 2.5),
          //     ),
          //   )
          //       : (_savedAvatarIndex == _avatarIndex && serverUrl != null)
          //       ? Image.network(
          //     serverUrl,
          //     fit: BoxFit.cover,
          //     //alignment: const Alignment(0, 0.3), // ✅ thoda neeche shift
          //     alignment: Alignment.topCenter, // ✅ face upar rahe
          //     loadingBuilder: (context, child, progress) {
          //       if (progress == null) return child;
          //       return Image.asset(
          //         _avatarImages[_avatarIndex],
          //         fit: BoxFit.cover,
          //         alignment: Alignment.topCenter,
          //         //alignment: const Alignment(0, 0.3),
          //       );
          //     },
          //     errorBuilder: (_, __, ___) => Image.asset(
          //       _avatarImages[_avatarIndex],
          //       fit: BoxFit.cover,
          //       alignment: Alignment.topCenter,
          //       //alignment: const Alignment(0, 0.3),
          //     ),
          //   )
          //       : Image.asset(
          //     _avatarImages[_avatarIndex],
          //     fit: BoxFit.cover,
          //     alignment: Alignment.topCenter,
          //     //alignment: const Alignment(0, 0.3), // ✅ thoda neeche shift
          //   ),
          // ),

          // ── Top fade + label ────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC0A0118), Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.only(top: 16, left: 18, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (_, __) => Text(
                      '⚡  AVATAR CUSTOMIZATION',
                      style: TextStyle(
                        color: kNeon,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            color: kNeon.withOpacity(0.5 * _glowAnim.value),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kGold.withOpacity(0.4), width: 0.8),
                    ),
                    child: const Text(
                      '⭐  LEGENDARY',
                      style: TextStyle(
                        color: kGold, fontSize: 9,
                        fontWeight: FontWeight.w700, letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom fade + name + arrows ─────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 60, 18, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xF00A0118), Color(0x880A0118), Colors.transparent],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Name + class
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            _avatarNames[_avatarIndex].toUpperCase(),
                            key: ValueKey(_avatarIndex),
                            style: const TextStyle(
                              color: kGold,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            '${_avatarClass[_avatarIndex].toUpperCase()} CLASS',
                            key: ValueKey(_avatarIndex),
                            style: const TextStyle(
                              color: kPurpleLight,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrows
                  Row(
                    children: [
                      _ArrowBtn(icon: Icons.chevron_left_rounded, onTap: _prevAvatar),
                      const SizedBox(width: 8),
                      _ArrowBtn(icon: Icons.chevron_right_rounded, onTap: _nextAvatar),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



//   Widget _buildHeroSection(Size size, bool isTablet, AvatarState avatarState) {
//     final circleSize = isTablet ? 200.0 : 170.0;
//
//     // ✅ Server se generated URL hai to network image, warna local asset
//     final String? serverUrl = avatarState.generatedMascotUrl;
//     //final String? serverUrl = avatarState.generatedMascotUrl;
//
//     return Container(
//       color: kBgCard,
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           AnimatedBuilder(
//             animation: _glowAnim,
//             builder: (_, __) => Text(
//               '⚡  AVATAR CUSTOMIZATION',
//               style: TextStyle(
//                 color: kNeon,
//                 fontSize: isTablet ? 13 : 11,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 3,
//                 shadows: [
//                   Shadow(
//                     color: kNeon.withOpacity(0.5 * _glowAnim.value),
//                     blurRadius: 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _ArrowBtn(icon: Icons.chevron_left_rounded, onTap: _prevAvatar),
//               const SizedBox(width: 16),
//
//               AnimatedBuilder(
//                 animation: Listenable.merge([_glowAnim, _rotateAnim, _bounceAnim]),
//                 builder: (_, __) => ScaleTransition(
//                   scale: _bounceAnim,
//                   child: SizedBox(
//                     width: circleSize + 24,
//                     height: circleSize + 24,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Glow
//                         Container(
//                           width: circleSize + 20,
//                           height: circleSize + 20,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: kNeon.withOpacity(0.25 * _glowAnim.value),
//                                 blurRadius: 30, spreadRadius: 6,
//                               ),
//                               BoxShadow(
//                                 color: kGold.withOpacity(0.15 * _glowAnim.value),
//                                 blurRadius: 50, spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Rotating ring
//                         Transform.rotate(
//                           angle: _rotateAnim.value,
//                           child: CustomPaint(
//                             size: Size(circleSize + 16, circleSize + 16),
//                             painter: _RingPainter(opacity: 0.4 * _glowAnim.value),
//                           ),
//                         ),
//                         // Avatar circle
//                         Container(
//                           width: circleSize,
//                           height: circleSize,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: const RadialGradient(
//                               colors: [Color(0xFF2D0A5E), kBgDeep],
//                             ),
//                             border: Border.all(
//                               color: kPurple.withOpacity(0.6), width: 1.5,
//                             ),
//                           ),
//                           // child: ClipOval(
//                           //   child: serverUrl != null
//                           //   // ✅ Server se aaya URL — NetworkImage
//                           //       ? Image.network(
//                           //     serverUrl,
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //     errorBuilder: (_, __, ___) => Image.asset(
//                           //       _avatarImages[_avatarIndex],
//                           //       fit: BoxFit.cover,
//                           //     ),
//                           //   )
//                           //   // ✅ Local asset
//                           //       : Image.asset(
//                           //     _avatarImages[_avatarIndex],
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //   ),
//                           // ),
//                           // ✅ User ne switch kiya ho to local asset, warna server URL
//
//                           // child: ClipOval(
//                           //   child: (!_userSwitchedAvatar && serverUrl != null)
//                           //       ? Image.network(
//                           //     serverUrl,
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //     errorBuilder: (_, __, ___) => Image.asset(
//                           //         _avatarImages[_avatarIndex], fit: BoxFit.cover),
//                           //   )
//                           //       : Image.asset(
//                           //     _avatarImages[_avatarIndex],
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //   ),
//                           // ),
//
//                           // ── 3. FIX: Arrow click pe sirf current index ka URL clear karo ──────────
// // _buildHeroSection mein image widget update karo:
//
//                           // child: ClipOval(
//                           //   child: (!_userSwitchedAvatar && serverUrl != null)
//                           //       ? Image.network(
//                           //     serverUrl,
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //     // ✅ Network image load hone tak local asset dikhao — no blank flash
//                           //     loadingBuilder: (context, child, loadingProgress) {
//                           //       if (loadingProgress == null) return child;
//                           //       return Image.asset(
//                           //         _avatarImages[_avatarIndex],
//                           //         width:  isTablet ? 260 : 160,
//                           //         height: isTablet ? 260 : 160,
//                           //         fit: BoxFit.cover,
//                           //       );
//                           //     },
//                           //     errorBuilder: (_, __, ___) => Image.asset(
//                           //         _avatarImages[_avatarIndex], fit: BoxFit.cover),
//                           //   )
//                           //       : Image.asset(
//                           //     _avatarImages[_avatarIndex],
//                           //     width:  isTablet ? 260 : 160,
//                           //     height: isTablet ? 260 : 160,
//                           //     fit: BoxFit.cover,
//                           //   ),
//                           // ),
//
//                           // ── Hero Section image logic — REPLACE karo ───────────────────────────────
//
//                           child: ClipOval(
//                             child: avatarState.isLoadingInfo
//                             // ✅ API load ho rahi he — loading spinner dikhao
//                                 ? Container(
//                               color: const Color(0xFF1A0535),
//                               child: const Center(
//                                 child: SizedBox(
//                                   width: 40, height: 40,
//                                   child: CircularProgressIndicator(
//                                     color: kNeon,
//                                     strokeWidth: 2.5,
//                                   ),
//                                 ),
//                               ),
//                             )
//                                 : (_savedAvatarIndex == _avatarIndex && serverUrl != null)
//                                 ? Image.network(
//                               serverUrl,
//                               width:  isTablet ? 260 : 160,
//                               height: isTablet ? 260 : 160,
//                               fit: BoxFit.cover,
//                               // ✅ Network image load hone tak bhi loading dikhao
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Container(
//                                   color: const Color(0xFF1A0535),
//                                   child: const Center(
//                                     child: SizedBox(
//                                       width: 40, height: 40,
//                                       child: CircularProgressIndicator(
//                                         color: kNeon,
//                                         strokeWidth: 2.5,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (_, __, ___) => Image.asset(
//                                   _avatarImages[_avatarIndex], fit: BoxFit.cover),
//                             )
//                                 : Image.asset(
//                               _avatarImages[_avatarIndex],
//                               width:  isTablet ? 260 : 160,
//                               height: isTablet ? 260 : 160,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//               _ArrowBtn(icon: Icons.chevron_right_rounded, onTap: _nextAvatar),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 250),
//             child: Text(
//               _avatarNames[_avatarIndex],
//               key: ValueKey(_avatarIndex),
//               style: const TextStyle(
//                   color: kGold, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 3),
//             ),
//           ),
//           const SizedBox(height: 4),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 250),
//             child: Text(
//               '${_avatarClass[_avatarIndex].toUpperCase()} CLASS',
//               key: ValueKey(_avatarIndex),
//               style: const TextStyle(
//                   color: kPurpleLight, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 2),
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//             decoration: BoxDecoration(
//               color: kGold.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: kGold.withOpacity(0.4), width: 0.8),
//             ),
//             child: const Text(
//               '⭐  LEGENDARY TIER',
//               style: TextStyle(
//                   color: kGold, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  // ── Action Row ──────────────────────────────────────────────────────────
  // ✅ Download = select-mascot API call, Reset = gear clear
  Widget _buildActionRow(AvatarState avatarState) {
    final bool saving = avatarState.isSelectingMascot;

    return Container(
      color: kBgCard,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _ActionBtn(
              icon:        saving ? Icons.hourglass_top_rounded : Icons.download_rounded,
              label:       saving ? 'Saving...' : 'Save Avatar',
              color:       !_resetPressed ? kPurpleLight : kTextMuted,
              borderColor: !_resetPressed ? kPurple      : kBorder,
              bgColor:     !_resetPressed ? kPurple.withOpacity(0.12) : Colors.transparent,
              onTap: saving
                  ? () {} // loading me tap disable
                  : () {
                setState(() => _resetPressed = false);
                _selectMascot(); // ✅ API call
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionBtn(
              icon:        Icons.refresh_rounded,
              label:       'Reset Avatar',
              color:       _resetPressed ? kPurpleLight : kTextMuted,
              borderColor: _resetPressed ? kPurple      : kBorder,
              bgColor:     _resetPressed ? kPurple.withOpacity(0.12) : Colors.transparent,
              onTap: () {
                setState(() {
                  _resetPressed = true;
                  for (var g in _gearItems) g.equipped = false;
                  _equippedCount = 0;
                  _visionCtrl.clear();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────────────
  Widget _buildTabs() {
    return Container(
      color: kBgDeep,
      child: Row(
        children: [
          _TabItem(
            label: 'Customize', icon: Icons.brush_rounded,
            isActive: _activeTab == 0,
            onTap: () => setState(() => _activeTab = 0),
          ),
          _TabItem(
            label: 'Details', icon: Icons.info_outline_rounded,
            isActive: _activeTab == 1,
            onTap: () => setState(() => _activeTab = 1),
          ),
        ],
      ),
    );
  }

  // ── Customize Tab ───────────────────────────────────────────────────────
  // Widget _buildCustomizeTab(Size size, bool isGenerating) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _SectionLabel(icon: Icons.checkroom_rounded, label: 'Equipment & Gear', color: kNeon),
  //         const SizedBox(height: 12),
  //
  //         GridView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3, crossAxisSpacing: 10,
  //             mainAxisSpacing: 10, childAspectRatio: 1.0,
  //           ),
  //           itemCount: _gearItems.length,
  //           itemBuilder: (_, i) => _GearTile(
  //             item: _gearItems[i], onTap: () => _toggleGear(i),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 20),
  //
  //         Row(children: [
  //           Expanded(child: Divider(color: kBorder, thickness: 0.5)),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             child: Text('— OR —',
  //                 style: TextStyle(
  //                     color: kTextMuted.withOpacity(0.6),
  //                     fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600)),
  //           ),
  //           Expanded(child: Divider(color: kBorder, thickness: 0.5)),
  //         ]),
  //
  //         const SizedBox(height: 18),
  //
  //         _SectionLabel(icon: Icons.auto_awesome_rounded, label: 'Describe Your Vision', color: kNeon),
  //         const SizedBox(height: 10),
  //
  //         Container(
  //           decoration: BoxDecoration(
  //             color: kBgDeep,
  //             borderRadius: BorderRadius.circular(14),
  //             border: Border.all(color: kBorder, width: 0.8),
  //           ),
  //           child: TextField(
  //             controller: _visionCtrl,
  //             maxLines: 3,
  //             style: const TextStyle(color: Colors.white, fontSize: 13),
  //             cursorColor: kGold,
  //             decoration: InputDecoration(
  //               hintText: 'e.g., "A futuristic space pirate with a glowing robotic eye and a cool leather jacket."',
  //               hintStyle: TextStyle(
  //                   color: kTextMuted.withOpacity(0.6), fontSize: 12, height: 1.5),
  //               border: InputBorder.none,
  //               contentPadding: const EdgeInsets.all(14),
  //             ),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 16),
  //
  //         // ✅ Generate button — ViewModel ka isGenerating use karo
  //         _GenerateBtn(isLoading: isGenerating, onTap: _generateLook),
  //
  //         const SizedBox(height: 20),
  //       ],
  //     ),
  //   );
  // }

  // ── Customize Tab ───────────────────────────────────────────────────────
// ✅ CHANGE 3: naya parameter `isLocked` add kiya — jab true hoga tab section blur+disabled dikhega
  Widget _buildCustomizeTab(Size size, bool isGenerating, bool isLocked) {
    return Stack(
      children: [
        // ✅ CHANGE 3a: original content ko IgnorePointer se wrap kiya —
        // taaki lock state me user gear/textfield/generate button ko touch hi na kar paye
        IgnorePointer(
          ignoring: isLocked,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(icon: Icons.checkroom_rounded, label: 'Equipment & Gear', color: kNeon),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10,
                    mainAxisSpacing: 10, childAspectRatio: 1.0,
                  ),
                  itemCount: _gearItems.length,
                  itemBuilder: (_, i) => _GearTile(
                    item: _gearItems[i], onTap: () => _toggleGear(i),
                  ),
                ),

                const SizedBox(height: 20),

                Row(children: [
                  Expanded(child: Divider(color: kBorder, thickness: 0.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('— OR —',
                        style: TextStyle(
                            color: kTextMuted.withOpacity(0.6),
                            fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Divider(color: kBorder, thickness: 0.5)),
                ]),

                const SizedBox(height: 18),

                _SectionLabel(icon: Icons.auto_awesome_rounded, label: 'Describe Your Vision', color: kNeon),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: kBgDeep,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder, width: 0.8),
                  ),
                  child: TextField(
                    controller: _visionCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    cursorColor: kGold,
                    decoration: InputDecoration(
                      hintText: 'e.g., "A futuristic space pirate with a glowing robotic eye and a cool leather jacket."',
                      hintStyle: TextStyle(
                          color: kTextMuted.withOpacity(0.6), fontSize: 12, height: 1.5),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _GenerateBtn(isLoading: isGenerating, onTap: _generateLook),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // ✅ CHANGE 3b: lock overlay — sirf tab dikhega jab isLocked == true
        if (isLocked)
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6), // ✅ blur effect
                child: Container(
                  color: kBgDark.withOpacity(0.55), // ✅ halka dark overlay blur ke upar
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: kBgCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: kGold.withOpacity(0.5), width: 1),
                          ),
                          child: const Icon(Icons.lock_outline_rounded, color: kGold, size: 26),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Please save your avatar first',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You need to save the selected avatar before you can customize it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextMuted.withOpacity(0.9),
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Details Tab ─────────────────────────────────────────────────────────
  Widget _buildDetailsTab(AvatarState avatarState) {
    final String? serverUrl = avatarState.generatedMascotUrl;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kGold.withOpacity(0.3), width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  width: 54, height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [const Color(0xFF2D0A5E), kNeon.withOpacity(0.2)],
                    ),
                    border: Border.all(color: kPurple, width: 0.8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: serverUrl != null
                        ? Image.network(serverUrl, width: 54, height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                            _avatarImages[_avatarIndex], fit: BoxFit.cover))
                        : Image.asset(_avatarImages[_avatarIndex],
                        width: 54, height: 54, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_avatarNames[_avatarIndex],
                          style: const TextStyle(
                              color: kGold, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('${_avatarClass[_avatarIndex]} Class',
                          style: const TextStyle(color: kTextMuted, fontSize: 11)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kGold.withOpacity(0.35), width: 0.7),
                        ),
                        child: const Text('⭐ Legendary Tier',
                            style: TextStyle(
                                color: kGold, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          _SectionLabel(icon: Icons.bar_chart_rounded, label: 'Customization Stats', color: kNeon),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '$_equippedCount',
                  label: 'Items Equipped',
                  valueColor: kNeon,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: '${_avatarImages.length}',
                  label: 'Available Styles',
                  valueColor: kGold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder, width: 0.5),
            ),
            child: Text(
              'Customize your avatar with unique items and styles. When you\'re satisfied with your creation, confirm to save it as your profile identity.',
              style: TextStyle(
                  color: kTextMuted.withOpacity(0.9), fontSize: 12, height: 1.7),
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Confirm = select-mascot API
          _ConfirmBtn(
            isSaving: avatarState.isSelectingMascot,
            onTap: _selectMascot,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  SMALL WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

// ─── Loading Bar ──────────────────────────────────────────────────────────
class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      backgroundColor: kBgDeep,
      color: kNeon,
      minHeight: 2,
    );
  }
}

// ─── Arrow Button ─────────────────────────────────────────────────────────
class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle, color: kBgDeep,
          border: Border.all(color: kPurple.withOpacity(0.6), width: 1),
        ),
        child: Icon(icon, color: kPurpleLight, size: 22),
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color borderColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon, required this.label,
    required this.color, required this.borderColor,
    required this.bgColor, required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.93)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { _ctrl.forward(from: 0); setState(() => _pressed = true); },
      onTapUp:   (_) { _ctrl.reverse(); setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () { _ctrl.reverse(); setState(() => _pressed = false); },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 42,
          decoration: BoxDecoration(
            color: _pressed
                ? widget.bgColor == Colors.transparent
                ? Colors.white.withOpacity(0.07)
                : Color.lerp(widget.bgColor, Colors.white, 0.15)
                : widget.bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _pressed ? Color.lerp(widget.borderColor, Colors.white, 0.3)! : widget.borderColor,
              width: _pressed ? 1.2 : 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _pressed ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Icon(widget.icon, color: widget.color, size: 16),
              ),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: TextStyle(
                      color: widget.color, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tab Item ─────────────────────────────────────────────────────────────
class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({required this.label, required this.icon,
    required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: isActive ? kNeon : Colors.transparent, width: 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: isActive ? kNeon : kTextMuted),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      color: isActive ? kNeon : kTextMuted,
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionLabel({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(label.toUpperCase(),
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2.5)),
      ],
    );
  }
}

// ─── Gear Tile ────────────────────────────────────────────────────────────
class _GearTile extends StatelessWidget {
  final _GearItem item;
  final VoidCallback onTap;

  const _GearTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: item.equipped ? kPurple.withOpacity(0.25) : kBgDeep,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.equipped ? kNeon : kBorder,
            width: item.equipped ? 1.2 : 0.5,
          ),
          boxShadow: item.equipped
              ? [BoxShadow(color: kNeon.withOpacity(0.2), blurRadius: 10, spreadRadius: 1)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(item.label,
                style: TextStyle(
                    color: item.equipped ? Colors.white : kTextMuted,
                    fontSize: 10,
                    fontWeight: item.equipped ? FontWeight.w600 : FontWeight.w400)),
            if (item.equipped)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 16, height: 3,
                decoration: BoxDecoration(
                  color: kNeon, borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Generate Button ──────────────────────────────────────────────────────
class _GenerateBtn extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _GenerateBtn({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity, height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [kPurple, kNeon],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: kNeon.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
          )
              : const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✦ ', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Generate New Look',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatCard({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: kBgCard, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: valueColor, fontSize: 28, fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: valueColor.withOpacity(0.4), blurRadius: 10)])),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: kTextMuted, fontSize: 10),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Confirm Button ───────────────────────────────────────────────────────
// ✅ isSaving state add kiya
class _ConfirmBtn extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onTap;
  const _ConfirmBtn({required this.onTap, this.isSaving = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: Container(
        width: double.infinity, height: 50,
        decoration: BoxDecoration(
          color: kPurple.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kPurple, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSaving
                ? const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(color: kPurpleLight, strokeWidth: 2),
            )
                : const Icon(Icons.check_circle_outline_rounded,
                color: kPurpleLight, size: 18),
            const SizedBox(width: 8),
            Text(
              isSaving ? 'Saving...' : 'Confirm & Save Avatar',
              style: const TextStyle(
                  color: kPurpleLight, fontSize: 14,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ring Painter ─────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double opacity;
  _RingPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width / 2 - 4;

    const dashCount = 18;
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i / dashCount) * 2 * math.pi;
      final sweepAngle = 0.65 * (2 * math.pi / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle, sweepAngle, false,
        Paint()
          ..color = kNeon.withOpacity(opacity)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke,
      );
      final dotAngle = startAngle + sweepAngle + 0.3 * (2 * math.pi / dashCount);
      canvas.drawCircle(
        Offset(cx + math.cos(dotAngle) * r, cy + math.sin(dotAngle) * r),
        2,
        Paint()..color = kGold.withOpacity(opacity * 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.opacity != opacity;
}










//------------ Without API ----------------------------------------------------->


// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// // ═══════════════════════════════════════════════════════════════════════════
// //  VERVEE ACADEMY — AVATAR CUSTOMIZATION SCREEN
// // ═══════════════════════════════════════════════════════════════════════════
//
// const Color kBgDark      = Color(0xFF0F0120);
// const Color kBgCard      = Color(0xFF150328);
// const Color kBgDeep      = Color(0xFF0A0118);
// const Color kPurple      = Color(0xFF7C3AED);
// const Color kPurpleLight = Color(0xFF9333EA);
// const Color kNeon        = Color(0xFFCC00FF);
// const Color kGold        = Color(0xFFD4AF37);
// const Color kGoldLight   = Color(0xFFFFD700);
// const Color kBorder      = Color(0xFF2D1050);
// const Color kTextMuted   = Color(0xFF888888);
//
// // ─── Gear Item Model ──────────────────────────────────────────────────────
// class _GearItem {
//   final String emoji;
//   final String label;
//   bool equipped;
//   _GearItem(this.emoji, this.label, {this.equipped = false});
// }
//
// // ─── Avatar Customization Screen ─────────────────────────────────────────
// class AvatarCustomizationScreen extends StatefulWidget {
//   const AvatarCustomizationScreen({super.key});
//
//   @override
//   State<AvatarCustomizationScreen> createState() =>
//       _AvatarCustomizationScreenState();
// }
//
// class _AvatarCustomizationScreenState
//     extends State<AvatarCustomizationScreen> with TickerProviderStateMixin {
//
//   int _activeTab        = 0; // 0=Customize, 1=Details
//   int _avatarIndex      = 0;
//   int _equippedCount    = 0;
//   bool _isGenerating    = false;
//   bool _resetPressed = false; // ✅ ADD KARO
//
//   late AnimationController _glowCtrl;
//   late AnimationController _rotateCtrl;
//   late AnimationController _bounceCtrl;
//   late Animation<double>   _glowAnim;
//   late Animation<double>   _rotateAnim;
//   late Animation<double>   _bounceAnim;
//
//   final TextEditingController _visionCtrl = TextEditingController();
//
//   //final List<String> _avatarEmojis = ['🐻', '🦁', '🐺', '🦊', '🐯', '🦅'];
//   final List<String> _avatarImages = [
//     'assets/avatar/my-avatar-falcor.png', // 24
//     'assets/avatar/my-avatar-hugo.png', // 25
//     'assets/avatar/my-avatar-maxbull.png', // 21
//     'assets/avatar/my-avatar-grizz.png', // 22
//     'assets/avatar/my-avatar-blazefox.png', //26
//     'assets/avatar/my-avatar-rockyshell.png', //27
//   ];
//   final List<String> _avatarNames  = ['Falcor','Hugo','MaxBull','Grizz','BlazeFox','RockyShell'];
//   final List<String> _avatarClass  = [
//     'Cyber-Paladin','Gold Hunter','Shadow Trader',
//     'Market Fox','Bull Rider','Sky Analyst'
//   ];
//
//   final List<_GearItem> _gearItems = [
//     _GearItem('👕', 'Shirt'),
//     _GearItem('🧢', 'Headwear'),
//     _GearItem('⌚', 'Watch'),
//     _GearItem('💍', 'Accessory'),
//     _GearItem('👟', 'Footwear'),
//     _GearItem('🎧', 'Audio'),
//     _GearItem('🕶️', 'Eyewear'),
//     _GearItem('🎒', 'Backpack'),
//     _GearItem('🛹', 'Gear'),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//
//     _glowCtrl = AnimationController(
//         vsync: this, duration: const Duration(seconds: 2))
//       ..repeat(reverse: true);
//     _glowAnim = Tween<double>(begin: 0.3, end: 1.0)
//         .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
//
//     _rotateCtrl = AnimationController(
//         vsync: this, duration: const Duration(seconds: 8))
//       ..repeat();
//     _rotateAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateCtrl);
//
//     _bounceCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));
//     _bounceAnim = Tween<double>(begin: 1.0, end: 0.92)
//         .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _glowCtrl.dispose();
//     _rotateCtrl.dispose();
//     _bounceCtrl.dispose();
//     _visionCtrl.dispose();
//     super.dispose();
//   }
//
//   void _toggleGear(int idx) {
//     setState(() {
//       _gearItems[idx].equipped = !_gearItems[idx].equipped;
//       _equippedCount = _gearItems.where((g) => g.equipped).length;
//     });
//     _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
//   }
//
//   // void _prevAvatar() => setState(() =>
//   // _avatarIndex = (_avatarIndex - 1 + _avatarEmojis.length) % _avatarEmojis.length);
//   // void _nextAvatar() => setState(() =>
//   // _avatarIndex = (_avatarIndex + 1) % _avatarEmojis.length);
//   //
//   // Future<void> _generateLook() async {
//   //   setState(() => _isGenerating = true);
//   //   await Future.delayed(const Duration(milliseconds: 1200));
//   //   setState(() {
//   //     _avatarIndex = math.Random().nextInt(_avatarEmojis.length);
//   //     _isGenerating = false;
//   //   });
//   // }
//
//   void _prevAvatar() => setState(() =>
//   _avatarIndex = (_avatarIndex - 1 + _avatarImages.length) % _avatarImages.length);
//
//   void _nextAvatar() => setState(() =>
//   _avatarIndex = (_avatarIndex + 1) % _avatarImages.length);
//
//   Future<void> _generateLook() async {
//     setState(() => _isGenerating = true);
//     await Future.delayed(const Duration(milliseconds: 1200));
//     setState(() {
//       _avatarIndex = math.Random().nextInt(_avatarImages.length);
//       _isGenerating = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Column(
//         children: [
//           _buildAppBar(context),
//           Expanded(
//             child: CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 SliverToBoxAdapter(child: _buildHeroSection(size, isTablet)),
//                 SliverToBoxAdapter(child: _buildActionRow()),
//                 SliverToBoxAdapter(child: _buildTabs()),
//                 SliverToBoxAdapter(
//                   child: _activeTab == 0
//                       ? _buildCustomizeTab(size)
//                       : _buildDetailsTab(),
//                 ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 32)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── App Bar (same as ProfileScreen) ────────────────────────────────────
//   Widget _buildAppBar(BuildContext context) {
//     return Container(
//       color: kBgCard,
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 8,
//         left: 4,
//         right: 12,
//         bottom: 10,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               // Back arrow
//               IconButton(
//                 icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white, size: 18),
//                 onPressed: () => Navigator.pop(context),
//               ),
//
//               // VERVEE ACADEMY title
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ShaderMask(
//                     shaderCallback: (bounds) => const LinearGradient(
//                       colors: [kGold, kGoldLight],
//                     ).createShader(bounds),
//                     child: const Text(
//                       'VERVEE',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w900,
//                         letterSpacing: 3,
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     'A C A D E M Y',
//                     style: TextStyle(
//                       color: kPurpleLight,
//                       fontSize: 7,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 3,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const Spacer(),
//
//               // Search icon
//               IconButton(
//                 icon: const Icon(Icons.search_rounded,
//                     color: kPurpleLight, size: 22),
//                 onPressed: () {},
//               ),
//
//               // Avatar circle
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [kGold, kPurple],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text('VA',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700)),
//                 ),
//               ),
//             ],
//           ),
//           Container(height: 0.5, color: kBorder),
//         ],
//       ),
//     );
//   }
//
//   // ── Hero Section ────────────────────────────────────────────────────────
//   Widget _buildHeroSection(Size size, bool isTablet) {
//     final circleSize = isTablet ? 200.0 : 170.0;
//
//     return Container(
//       color: kBgCard,
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           // Page title
//           AnimatedBuilder(
//             animation: _glowAnim,
//             builder: (_, __) => Text(
//               '⚡  AVATAR CUSTOMIZATION',
//               style: TextStyle(
//                 color: kNeon,
//                 fontSize: isTablet ? 13 : 11,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 3,
//                 shadows: [
//                   Shadow(
//                     color: kNeon.withOpacity(0.5 * _glowAnim.value),
//                     blurRadius: 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           // Avatar display with rotating ring
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Left arrow
//               _ArrowBtn(icon: Icons.chevron_left_rounded, onTap: _prevAvatar),
//
//               const SizedBox(width: 16),
//
//               // Avatar circle
//               AnimatedBuilder(
//                 animation: Listenable.merge([_glowAnim, _rotateAnim, _bounceAnim]),
//                 builder: (_, __) => ScaleTransition(
//                   scale: _bounceAnim,
//                   child: SizedBox(
//                     width: circleSize + 24,
//                     height: circleSize + 24,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Outer glow
//                         Container(
//                           width: circleSize + 20,
//                           height: circleSize + 20,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: kNeon.withOpacity(0.25 * _glowAnim.value),
//                                 blurRadius: 30,
//                                 spreadRadius: 6,
//                               ),
//                               BoxShadow(
//                                 color: kGold.withOpacity(0.15 * _glowAnim.value),
//                                 blurRadius: 50,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Rotating dashed ring
//                         Transform.rotate(
//                           angle: _rotateAnim.value,
//                           child: CustomPaint(
//                             size: Size(circleSize + 16, circleSize + 16),
//                             painter: _RingPainter(
//                               opacity: 0.4 * _glowAnim.value,
//                             ),
//                           ),
//                         ),
//
//                         // Avatar circle
//                         Container(
//                           width: circleSize,
//                           height: circleSize,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: RadialGradient(
//                               colors: [
//                                 const Color(0xFF2D0A5E),
//                                 kBgDeep,
//                               ],
//                             ),
//                             border: Border.all(
//                               color: kPurple.withOpacity(0.6),
//                               width: 1.5,
//                             ),
//                           ),
//                           child: Center(
//                             // child: Text(
//                             //   _avatarEmojis[_avatarIndex],
//                             //   style: TextStyle(
//                             //     fontSize: isTablet ? 90 : 76,
//                             //   ),
//                             // ),
//                             // NAYA (image wala):
//                             child: ClipOval(
//                               child: Image.asset(
//                                 _avatarImages[_avatarIndex],
//                                 width: isTablet ? 260 : 160,
//                                 height: isTablet ? 260 : 160,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//
//               // Right arrow
//               _ArrowBtn(icon: Icons.chevron_right_rounded, onTap: _nextAvatar),
//             ],
//           ),
//
//           const SizedBox(height: 14),
//
//           // Avatar name
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 250),
//             child: Text(
//               _avatarNames[_avatarIndex],
//               key: ValueKey(_avatarIndex),
//               style: const TextStyle(
//                 color: kGold,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 3,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 250),
//             child: Text(
//               '${_avatarClass[_avatarIndex].toUpperCase()} CLASS',
//               key: ValueKey(_avatarIndex),
//               style: const TextStyle(
//                 color: kPurpleLight,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 2,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // Tier badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//             decoration: BoxDecoration(
//               color: kGold.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: kGold.withOpacity(0.4), width: 0.8),
//             ),
//             child: const Text(
//               '⭐  LEGENDARY TIER',
//               style: TextStyle(
//                 color: kGold,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Action Row ──────────────────────────────────────────────────────────
//   // Widget _buildActionRow() {
//   //   return Container(
//   //     color: kBgCard,
//   //     padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           child: _ActionBtn(
//   //             icon: Icons.download_rounded,
//   //             label: 'Download Avatar',
//   //             color: kPurpleLight,
//   //             borderColor: kPurple,
//   //             bgColor: kPurple.withOpacity(0.12),
//   //             onTap: () {},
//   //           ),
//   //         ),
//   //         const SizedBox(width: 10),
//   //         Expanded(
//   //           child: _ActionBtn(
//   //             icon: Icons.refresh_rounded,
//   //             label: 'Reset Avatar',
//   //             color: kTextMuted,
//   //             borderColor: kBorder,
//   //             bgColor: Colors.transparent,
//   //             onTap: () {
//   //               setState(() {
//   //                 for (var g in _gearItems) g.equipped = false;
//   //                 _equippedCount = 0;
//   //                 _visionCtrl.clear();
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   // Widget _buildActionRow() {
//   //   // ✅ Bool ke basis pe colors swap ho jaate hain
//   //   final downloadColor      = _resetPressed ? kTextMuted    : kPurpleLight;
//   //   final downloadBorder     = _resetPressed ? kBorder       : kPurple;
//   //   final downloadBg         = _resetPressed ? Colors.transparent : kPurple.withOpacity(0.12);
//   //
//   //   final resetColor         = _resetPressed ? kPurpleLight  : kTextMuted;
//   //   final resetBorder        = _resetPressed ? kPurple       : kBorder;
//   //   final resetBg            = _resetPressed ? kPurple.withOpacity(0.12) : Colors.transparent;
//   //
//   //   return Container(
//   //     color: kBgCard,
//   //     padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           child: _ActionBtn(
//   //             icon: Icons.download_rounded,
//   //             label: 'Download Avatar',
//   //             color: downloadColor,
//   //             borderColor: downloadBorder,
//   //             bgColor: downloadBg,
//   //             onTap: () {},
//   //           ),
//   //         ),
//   //         const SizedBox(width: 10),
//   //         Expanded(
//   //           child: _ActionBtn(
//   //             icon: Icons.refresh_rounded,
//   //             label: 'Reset Avatar',
//   //             color: resetColor,
//   //             borderColor: resetBorder,
//   //             bgColor: resetBg,
//   //             onTap: () async {
//   //
//   //               // ✅ Color swap ON
//   //               setState(() => _resetPressed = true);
//   //
//   //               // ✅ Reset logic (same as pehle)
//   //               setState(() {
//   //                 for (var g in _gearItems) g.equipped = false;
//   //                 _equippedCount = 0;
//   //                 _visionCtrl.clear();
//   //               });
//   //
//   //               // ✅ 600ms baad color wapas
//   //               await Future.delayed(const Duration(milliseconds: 100));
//   //               if (mounted) setState(() => _resetPressed = false);
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildActionRow() {
//     return Container(
//       color: kBgCard,
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: _ActionBtn(
//               icon: Icons.download_rounded,
//               label: 'Download Avatar',
//               // ✅ Download active jab _resetPressed = false
//               color:       !_resetPressed ? kPurpleLight          : kTextMuted,
//               borderColor: !_resetPressed ? kPurple               : kBorder,
//               bgColor:     !_resetPressed ? kPurple.withOpacity(0.12) : Colors.transparent,
//               onTap: () {
//                 // ✅ Download tap = Download active ho jaaye
//                 setState(() => _resetPressed = false);
//               },
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: _ActionBtn(
//               icon: Icons.refresh_rounded,
//               label: 'Reset Avatar',
//               // ✅ Reset active jab _resetPressed = true
//               color:       _resetPressed ? kPurpleLight          : kTextMuted,
//               borderColor: _resetPressed ? kPurple               : kBorder,
//               bgColor:     _resetPressed ? kPurple.withOpacity(0.12) : Colors.transparent,
//               onTap: () {
//                 // ✅ Reset tap = Reset active + reset logic
//                 setState(() {
//                   _resetPressed = true;
//                   for (var g in _gearItems) g.equipped = false;
//                   _equippedCount = 0;
//                   _visionCtrl.clear();
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   // ── Tabs ────────────────────────────────────────────────────────────────
//   Widget _buildTabs() {
//     return Container(
//       color: kBgDeep,
//       child: Row(
//         children: [
//           _TabItem(
//             label: 'Customize',
//             icon: Icons.brush_rounded,
//             isActive: _activeTab == 0,
//             onTap: () => setState(() => _activeTab = 0),
//           ),
//           _TabItem(
//             label: 'Details',
//             icon: Icons.info_outline_rounded,
//             isActive: _activeTab == 1,
//             onTap: () => setState(() => _activeTab = 1),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Customize Tab ───────────────────────────────────────────────────────
//   Widget _buildCustomizeTab(Size size) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Equipment & Gear
//           _SectionLabel(
//             icon: Icons.checkroom_rounded,
//             label: 'Equipment & Gear',
//             color: kNeon,
//           ),
//           const SizedBox(height: 12),
//
//           // 3x3 Gear Grid
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 1.0,
//             ),
//             itemCount: _gearItems.length,
//             itemBuilder: (_, i) => _GearTile(
//               item: _gearItems[i],
//               onTap: () => _toggleGear(i),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // OR divider
//           Row(children: [
//             Expanded(child: Divider(color: kBorder, thickness: 0.5)),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 '— OR —',
//                 style: TextStyle(
//                     color: kTextMuted.withOpacity(0.6),
//                     fontSize: 11,
//                     letterSpacing: 2,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             Expanded(child: Divider(color: kBorder, thickness: 0.5)),
//           ]),
//
//           const SizedBox(height: 18),
//
//           // Describe Your Vision
//           _SectionLabel(
//             icon: Icons.auto_awesome_rounded,
//             label: 'Describe Your Vision',
//             color: kNeon,
//           ),
//           const SizedBox(height: 10),
//
//           Container(
//             decoration: BoxDecoration(
//               color: kBgDeep,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: kBorder, width: 0.8),
//             ),
//             child: TextField(
//               controller: _visionCtrl,
//               maxLines: 3,
//               style: const TextStyle(color: Colors.white, fontSize: 13),
//               cursorColor: kGold,
//               decoration: InputDecoration(
//                 hintText:
//                 'e.g., "A futuristic space pirate with a glowing robotic eye and a cool leather jacket."',
//                 hintStyle: TextStyle(
//                     color: kTextMuted.withOpacity(0.6), fontSize: 12, height: 1.5),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.all(14),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Generate Button
//           _GenerateBtn(
//             isLoading: _isGenerating,
//             onTap: _generateLook,
//           ),
//
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   // ── Details Tab ─────────────────────────────────────────────────────────
//   Widget _buildDetailsTab() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Selected avatar card
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: kBgCard,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: kGold.withOpacity(0.3), width: 0.8),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 54,
//                   height: 54,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF2D0A5E),
//                         kNeon.withOpacity(0.2)
//                       ],
//                     ),
//                     border: Border.all(color: kPurple, width: 0.8),
//                   ),
//                   child: Center(
//                     // child: Text(_avatarEmojis[_avatarIndex],
//                     //     style: const TextStyle(fontSize: 28)),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.asset(
//                         _avatarImages[_avatarIndex],
//                         width: 32,
//                         height: 32,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(_avatarNames[_avatarIndex],
//                           style: const TextStyle(
//                               color: kGold,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700)),
//                       const SizedBox(height: 2),
//                       Text('${_avatarClass[_avatarIndex]} Class',
//                           style: const TextStyle(
//                               color: kTextMuted, fontSize: 11)),
//                       const SizedBox(height: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: kGold.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                               color: kGold.withOpacity(0.35), width: 0.7),
//                         ),
//                         child: const Text('⭐ Legendary Tier',
//                             style: TextStyle(
//                                 color: kGold,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 18),
//
//           // Customization Stats
//           _SectionLabel(
//             icon: Icons.bar_chart_rounded,
//             label: 'Customization Stats',
//             color: kNeon,
//           ),
//           const SizedBox(height: 12),
//
//           Row(
//             children: [
//               Expanded(
//                 child: _StatCard(
//                   value: '$_equippedCount',
//                   label: 'Items Equipped',
//                   valueColor: kNeon,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: _StatCard(
//                   value: '6',
//                   label: 'Available Styles',
//                   valueColor: kGold,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           // Description
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: kBgCard,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: kBorder, width: 0.5),
//             ),
//             child: Text(
//               'Customize your avatar with unique items and styles. When you\'re satisfied with your creation, confirm to save it as your profile identity.',
//               style: TextStyle(
//                   color: kTextMuted.withOpacity(0.9),
//                   fontSize: 12,
//                   height: 1.7),
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           // Confirm button
//           _ConfirmBtn(onTap: () {}),
//
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════
// //  SMALL WIDGETS
// // ═══════════════════════════════════════════════════════════════════════════
//
// // ─── Arrow Button ─────────────────────────────────────────────────────────
// class _ArrowBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _ArrowBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 38,
//         height: 38,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: kBgDeep,
//           border: Border.all(color: kPurple.withOpacity(0.6), width: 1),
//         ),
//         child: Icon(icon, color: kPurpleLight, size: 22),
//       ),
//     );
//   }
// }
//
// // ─── Action Button ────────────────────────────────────────────────────────
// class _ActionBtn extends StatefulWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final Color borderColor;
//   final Color bgColor;
//   final VoidCallback onTap;
//
//   const _ActionBtn({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.borderColor,
//     required this.bgColor,
//     required this.onTap,
//   });
//
//   @override
//   State<_ActionBtn> createState() => _ActionBtnState();
// }
//
// // class _ActionBtnState extends State<_ActionBtn>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _ctrl;
// //   late Animation<double> _scale;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _ctrl = AnimationController(
// //         vsync: this, duration: const Duration(milliseconds: 100));
// //     _scale = Tween<double>(begin: 1.0, end: 0.95)
// //         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
// //   }
// //
// //   @override
// //   void dispose() {
// //     _ctrl.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       //onTapDown: (_) => _ctrl.forward(),
// //       onTapDown: (_) => _ctrl.forward(from: 0),
// //       onTapUp: (_) async {
// //         await _ctrl.reverse();
// //         widget.onTap();
// //       },
// //       onTapCancel: () => _ctrl.reverse(),
// //       child: ScaleTransition(
// //         scale: _scale,
// //         child: Container(
// //           height: 42,
// //           decoration: BoxDecoration(
// //             color: widget.bgColor,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: widget.borderColor, width: 0.8),
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(widget.icon, color: widget.color, size: 16),
// //               const SizedBox(width: 6),
// //               Text(
// //                 widget.label,
// //                 style: TextStyle(
// //                     color: widget.color,
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class _ActionBtnState extends State<_ActionBtn>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _scale;
//   bool _pressed = false; // ✅ local press state
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 120));
//     _scale = Tween<double>(begin: 1.0, end: 0.93)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
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
//       onTapDown: (_) {
//         _ctrl.forward(from: 0);
//         setState(() => _pressed = true); // ✅ overlay ON
//       },
//       onTapUp: (_) {
//         _ctrl.reverse();
//         setState(() => _pressed = false); // ✅ overlay OFF
//         widget.onTap();
//       },
//       onTapCancel: () {
//         _ctrl.reverse();
//         setState(() => _pressed = false);
//       },
//       child: ScaleTransition(
//         scale: _scale,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 120),
//           height: 42,
//           decoration: BoxDecoration(
//             // ✅ Press pe thoda bright ho jaata hai background
//             color: _pressed
//                 ? widget.bgColor == Colors.transparent
//                 ? Colors.white.withOpacity(0.07)
//                 : Color.lerp(widget.bgColor, Colors.white, 0.15)
//                 : widget.bgColor,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               // ✅ Press pe border thoda bright
//               color: _pressed
//                   ? Color.lerp(widget.borderColor, Colors.white, 0.3)!
//                   : widget.borderColor,
//               width: _pressed ? 1.2 : 0.8,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // ✅ Press pe icon thoda bada
//               AnimatedScale(
//                 scale: _pressed ? 1.15 : 1.0,
//                 duration: const Duration(milliseconds: 100),
//                 child: Icon(widget.icon, color: widget.color, size: 16),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 widget.label,
//                 style: TextStyle(
//                   color: widget.color,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
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
// // ─── Tab Item ─────────────────────────────────────────────────────────────
// class _TabItem extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isActive;
//   final VoidCallback onTap;
//
//   const _TabItem({
//     required this.label,
//     required this.icon,
//     required this.isActive,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: isActive ? kNeon : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon,
//                   size: 15,
//                   color: isActive ? kNeon : kTextMuted),
//               const SizedBox(width: 5),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isActive ? kNeon : kTextMuted,
//                   fontSize: 12,
//                   fontWeight:
//                   isActive ? FontWeight.w700 : FontWeight.w400,
//                   letterSpacing: 0.3,
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
// // ─── Section Label ────────────────────────────────────────────────────────
// class _SectionLabel extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//
//   const _SectionLabel({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 14),
//         const SizedBox(width: 6),
//         Text(
//           label.toUpperCase(),
//           style: TextStyle(
//             color: color,
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 2.5,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Gear Tile ────────────────────────────────────────────────────────────
// class _GearTile extends StatelessWidget {
//   final _GearItem item;
//   final VoidCallback onTap;
//
//   const _GearTile({required this.item, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: item.equipped
//               ? kPurple.withOpacity(0.25)
//               : kBgDeep,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: item.equipped ? kNeon : kBorder,
//             width: item.equipped ? 1.2 : 0.5,
//           ),
//           boxShadow: item.equipped
//               ? [
//             BoxShadow(
//               color: kNeon.withOpacity(0.2),
//               blurRadius: 10,
//               spreadRadius: 1,
//             )
//           ]
//               : [],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(item.emoji,
//                 style: const TextStyle(fontSize: 24)),
//             const SizedBox(height: 6),
//             Text(
//               item.label,
//               style: TextStyle(
//                 color: item.equipped ? Colors.white : kTextMuted,
//                 fontSize: 10,
//                 fontWeight: item.equipped
//                     ? FontWeight.w600
//                     : FontWeight.w400,
//               ),
//             ),
//             if (item.equipped)
//               Container(
//                 margin: const EdgeInsets.only(top: 4),
//                 width: 16,
//                 height: 3,
//                 decoration: BoxDecoration(
//                   color: kNeon,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Generate Button ──────────────────────────────────────────────────────
// class _GenerateBtn extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback onTap;
//
//   const _GenerateBtn({required this.isLoading, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           gradient: const LinearGradient(
//             colors: [kPurple, kNeon],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: kNeon.withOpacity(0.35),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Center(
//           child: isLoading
//               ? const SizedBox(
//             width: 22,
//             height: 22,
//             child: CircularProgressIndicator(
//                 color: Colors.white, strokeWidth: 2.5),
//           )
//               : const Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('✦ ',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16)),
//               Text(
//                 'Generate New Look',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.8,
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
// // ─── Stat Card ────────────────────────────────────────────────────────────
// class _StatCard extends StatelessWidget {
//   final String value;
//   final String label;
//   final Color valueColor;
//
//   const _StatCard({
//     required this.value,
//     required this.label,
//     required this.valueColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor,
//               fontSize: 28,
//               fontWeight: FontWeight.w800,
//               shadows: [
//                 Shadow(color: valueColor.withOpacity(0.4), blurRadius: 10),
//               ],
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(color: kTextMuted, fontSize: 10),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Confirm Button ───────────────────────────────────────────────────────
// class _ConfirmBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   const _ConfirmBtn({required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 50,
//         decoration: BoxDecoration(
//           color: kPurple.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: kPurple, width: 1),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.check_circle_outline_rounded,
//                 color: kPurpleLight, size: 18),
//             SizedBox(width: 8),
//             Text(
//               'Currently Selected',
//               style: TextStyle(
//                 color: kPurpleLight,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Ring Painter ─────────────────────────────────────────────────────────
// class _RingPainter extends CustomPainter {
//   final double opacity;
//   _RingPainter({required this.opacity});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final r  = size.width / 2 - 4;
//
//     const dashCount = 18;
//     for (int i = 0; i < dashCount; i++) {
//       final startAngle = (i / dashCount) * 2 * math.pi;
//       final sweepAngle = 0.65 * (2 * math.pi / dashCount);
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         startAngle,
//         sweepAngle,
//         false,
//         Paint()
//           ..color = kNeon.withOpacity(opacity)
//           ..strokeWidth = 1.5
//           ..style = PaintingStyle.stroke,
//       );
//       // Diamond dot
//       final dotAngle = startAngle + sweepAngle + 0.3 * (2 * math.pi / dashCount);
//       canvas.drawCircle(
//         Offset(cx + math.cos(dotAngle) * r,
//             cy + math.sin(dotAngle) * r),
//         2,
//         Paint()..color = kGold.withOpacity(opacity * 0.8),
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(_RingPainter old) => old.opacity != opacity;
// }