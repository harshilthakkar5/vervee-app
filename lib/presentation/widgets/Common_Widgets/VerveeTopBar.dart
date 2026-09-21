import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vervee_app/presentation/screen/VerveeUniverseScreen.dart';

import '../../screen/VideoPostDetail.dart';
import '../../viewmodal/avatar/AvatarViewModel.dart';
import '../../viewmodal/pofile/ProfileViewmodels.dart';

// import '../../presentation/viewmodal/avatar/AvatarViewModel.dart';
// import '../../presentation/viewmodal/pofile/ProfileViewmodels.dart';

// ─── Constants (same as HomeScreen) ──────────────────────────────────────────
const _kBgCard      = Color(0xFF150328);
const _kBgDeep      = Color(0xFF0A0118);
const _kPurple      = Color(0xFF7C3AED);
const _kPurpleLight = Color(0xFF9333EA);
const _kGold        = Color(0xFFD4AF37);
const _kGoldLight   = Color(0xFFFFD700);
const _kBorder      = Color(0xFF2D1050);
const _kTextMuted   = Color(0xFF888888);

// ═══════════════════════════════════════════════════════════════════════════════
//  VERVEE TOP APP BAR  —  Common Widget
//
//  Usage:
//    Column(children: [
//      VerveeTopBar(
//        onSearchTap: () { /* search logic */ },   // optional
//      ),
//      Expanded(child: yourBody),
//    ])
//
//  Parameters:
//    onSearchTap  — search icon tap callback (null = search icon hidden)
//    title        — override title, default: 'VERVEE'
//    subtitle     — override subtitle, default: 'A C A D E M Y'
//
//  Naya: Avatar ke left me ek animated star icon hai — tap karne pe ek
//  attractive dropdown khulta hai jisme "Vervee Universe" seedha
//  VerveeUniverseScreen pe le jaata hai, baaki sections "Coming Soon" dikhate hai.
// ═══════════════════════════════════════════════════════════════════════════════
class VerveeTopBar extends ConsumerStatefulWidget {
  const VerveeTopBar({
    super.key,
    this.onSearchTap,
    required this.onProfile,
    this.title    = 'VERVEE',
    this.subtitle = 'A C A D E M Y',
  });

  final VoidCallback? onSearchTap;
  final String title;
  final String subtitle;
  final VoidCallback onProfile;

  @override
  ConsumerState<VerveeTopBar> createState() => _VerveeTopBarState();
}

class _VerveeTopBarState extends ConsumerState<VerveeTopBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet      = MediaQuery.of(context).size.width > 600;
    final avatarUrl     = ref.watch(avatarViewModelProvider).generatedMascotUrl;
    final profileState  = ref.watch(profileInfoViewModelProvider);

    return Container(
      color: _kBgCard,
      padding: EdgeInsets.only(
        top   : MediaQuery.of(context).padding.top + 8,
        left  : 16,
        right : 16,
        bottom: 10,
      ),
      child: Row(
        children: [
          // ── Brand Logo ──────────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, __) => Text(
                  widget.title,
                  style: TextStyle(
                    color      : _kGold,
                    fontSize   : isTablet ? 22 : 18,
                    fontWeight : FontWeight.w900,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color     : _kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
                        blurRadius: 8 + 4 * _glowCtrl.value,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color        : _kPurpleLight,
                  fontSize     : isTablet ? 9 : 7.5,
                  fontWeight   : FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Search Icon (optional) ──────────────────────────────────────────
          if (widget.onSearchTap != null) ...[
            _TopIconBtn(icon: Icons.search_rounded, onTap: widget.onSearchTap!),
            const SizedBox(width: 8),
          ],

          // ── Animated Star Menu (left of avatar) ─────────────────────────────
          const _StarMenuButton(),
          const SizedBox(width: 10),

          // ── Profile Avatar  (showcase only — no action on tap) ─────────────
          _ProfileAvatar(
            avatarUrl    : avatarUrl,
            profileState : profileState,
            onTap        : widget.onProfile,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ANIMATED STAR MENU BUTTON  +  ATTRACTIVE DROPDOWN
// ═══════════════════════════════════════════════════════════════════════════════
class _StarMenuButton extends StatefulWidget {
  const _StarMenuButton();

  @override
  State<_StarMenuButton> createState() => _StarMenuButtonState();
}

class _StarMenuButtonState extends State<_StarMenuButton>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  // Continuous twinkle animation for the star icon itself.
  late final AnimationController _twinkleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  // Open/close animation for the dropdown panel.
  late final AnimationController _menuCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  @override
  void dispose() {
    _twinkleCtrl.dispose();
    _menuCtrl.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _menuCtrl.forward(from: 0);
  }

  Future<void> _closeMenu() async {
    if (!_isOpen) return;
    await _menuCtrl.reverse();
    _removeOverlay();
    if (mounted) setState(() => _isOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // void _handleItemTap(_StarMenuItem item) {
  //   _closeMenu();
  //   if (item.available) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const VerveeUniverseScreen(embedded: true),
  //       ),
  //     );
  //   } else {
  //     _showComingSoonSnack(context, item.label);
  //   }
  // }

  void _handleItemTap(_StarMenuItem item) {
    _closeMenu();
    if (item.available && item.screenBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: item.screenBuilder!),
      );
    } else if (!item.available) {
      _showComingSoonSnack(context, item.label);
    }
  }

  void _showComingSoonSnack(BuildContext context, String label) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(milliseconds: 1800),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_kBgCard, Color(0xFF1E0B3A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kGold.withOpacity(0.5), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: _kGold.withOpacity(0.15),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_kGold, _kPurple],
                  ),
                ),
                child: const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5, height: 1.3),
                    children: [
                      TextSpan(
                        text: '$label  ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text: 'is coming soon ✨',
                        style: TextStyle(
                          color: _kTextMuted,
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
      ),
    );
  }

  // List<_StarMenuItem> get _items => [
  //   _StarMenuItem(
  //     icon: Icons.school_rounded,
  //     label: 'Vervee Universe',
  //     subtitle: 'Courses & financial literacy',
  //     available: true,
  //   ),
  //   _StarMenuItem(
  //     icon: Icons.groups_rounded,
  //     label: 'Community Tab',
  //     subtitle: 'Connect with fellow instructor',
  //     available: false,
  //   ),
  //   _StarMenuItem(
  //     icon: Icons.live_tv_rounded,
  //     label: 'Trackers',
  //     subtitle: 'Track your money habits',
  //     available: false,
  //   ),
  //   _StarMenuItem(
  //     icon: Icons.card_giftcard_rounded,
  //     label: 'Support',
  //     subtitle: "We're here to help",
  //     available: false,
  //   ),
  //   _StarMenuItem(
  //     icon: Icons.show_chart_rounded,
  //     label: 'Report',
  //     subtitle: 'Your learning summary',
  //     available: false,
  //   ),
  // ];

  List<_StarMenuItem> get _items => [
    _StarMenuItem(
      icon: Icons.school_rounded,
      label: 'Vervee Universe',
      subtitle: 'Courses & financial literacy',
      available: true,
      screenBuilder: (_) => const VerveeUniverseScreen(embedded: true),
    ),
    _StarMenuItem(
      icon: Icons.movie_creation_rounded,
      label: 'Flash',
      subtitle: 'Watch quick money tips',
      available: true,
      screenBuilder: (_) => const PostDetailScreen(),
    ),
    _StarMenuItem(
      icon: Icons.groups_rounded,
      label: 'Community Tab',
      subtitle: 'Connect with fellow instructor',
      available: false,
    ),
    _StarMenuItem(
      icon: Icons.live_tv_rounded,
      label: 'Trackers',
      subtitle: 'Track your money habits',
      available: false,
    ),
    _StarMenuItem(
      icon: Icons.card_giftcard_rounded,
      label: 'Support',
      subtitle: "We're here to help",
      available: false,
    ),
    _StarMenuItem(
      icon: Icons.show_chart_rounded,
      label: 'Report',
      subtitle: 'Your learning summary',
      available: false,
    ),
  ];

  OverlayEntry _buildOverlayEntry() {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth < 300 ? screenWidth - 32 : 260.0;

    return OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            // Tap-outside barrier to close the menu.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
                child: const SizedBox.shrink(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 12),
              child: AnimatedBuilder(
                animation: _menuCtrl,
                builder: (_, child) {
                  final curved = CurvedAnimation(
                    parent: _menuCtrl,
                    curve: Curves.easeOutBack,
                    reverseCurve: Curves.easeIn,
                  );
                  return Opacity(
                    opacity: _menuCtrl.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      alignment: Alignment.topRight,
                      scale: 0.85 + (0.15 * curved.value.clamp(0.0, 1.15)),
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        width: menuWidth,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _kBgCard.withOpacity(0.97),
                              const Color(0xFF1E0B3A).withOpacity(0.97),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _kGold.withOpacity(0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _kPurple.withOpacity(0.35),
                              blurRadius: 24,
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: _kGold.withOpacity(0.12),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                              child: Row(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (r) => const LinearGradient(
                                      colors: [_kGoldLight, _kGold],
                                    ).createShader(r),
                                    child: const Icon(Icons.auto_awesome_rounded,
                                        color: Colors.white, size: 15),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'EXPLORE VERVEE',
                                    style: TextStyle(
                                      color: _kGold,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.6,
                              color: _kBorder.withOpacity(0.8),
                            ),
                            const SizedBox(height: 4),
                            for (final item in _items)
                              _MenuTile(
                                item: item,
                                onTap: () => _handleItemTap(item),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: AnimatedBuilder(
          animation: _twinkleCtrl,
          builder: (_, __) {
            final t = _twinkleCtrl.value; // 0 → 1 → 0
            final scale = 0.92 + (0.16 * t);
            final glow  = 0.35 + (0.45 * t);
            return Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                shape : BoxShape.circle,
                color : _isOpen ? _kPurple.withOpacity(0.18) : _kBgDeep,
                border: Border.all(
                  color: _isOpen ? _kGold : _kBorder,
                  width: _isOpen ? 1.2 : 0.5,
                ),
              ),
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [_kGoldLight, _kGold, _kPurpleLight],
                    ).createShader(rect),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                      shadows: [
                        Shadow(
                          color: _kGold.withOpacity(glow),
                          blurRadius: 10 + (6 * t),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Menu item data holder ──────────────────────────────────────────────────
class _StarMenuItem {
  const _StarMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.available,
    this.screenBuilder,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool available;
  final WidgetBuilder? screenBuilder;
}

// ─── Single dropdown row ────────────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item, required this.onTap});

  final _StarMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: _kPurple.withOpacity(0.15),
      highlightColor: _kPurple.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: item.available
                    ? const LinearGradient(colors: [_kGold, _kPurple])
                    : LinearGradient(
                  colors: [
                    _kBorder.withOpacity(0.9),
                    _kBgDeep,
                  ],
                ),
              ),
              child: Icon(
                item.icon,
                size: 17,
                color: item.available ? Colors.white : _kTextMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      color: item.available ? Colors.white : Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: _kTextMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!item.available)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _kPurple.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kPurpleLight.withOpacity(0.4)),
                ),
                child: const Text(
                  'Soon',
                  style: TextStyle(
                    color: _kPurpleLight,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded,
                  color: _kGold, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Avatar — showcase only, GestureDetector with no callback ─────────
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.avatarUrl,
    required this.profileState,
    required this.onTap,
  });

  final String? avatarUrl;
  final dynamic profileState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: avatarUrl == null
              ? const LinearGradient(
            colors: [_kGold, _kPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: avatarUrl != null
            ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl!,
            width: 34,
            height: 34,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) =>
                _initialsCircle(profileState),
          ),
        )
            : _initialsCircle(profileState),
      ),
    );
  }

  Widget _initialsCircle(dynamic profileState) {
    final initial = profileState.profile != null
        ? (profileState.profile!.name as String)
        .substring(0, 1)
        .toUpperCase()
        : 'VA';

    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Small circular icon button (reusable) ────────────────────────────────────
class _TopIconBtn extends StatelessWidget {
  const _TopIconBtn({required this.icon, required this.onTap});

  final IconData     icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width : 39,
        height: 39,
        decoration: BoxDecoration(
          shape : BoxShape.circle,
          color : _kBgDeep,
          border: Border.all(color: _kBorder, width: 0.5),
        ),
        child: Icon(icon, color: _kPurpleLight, size: 25),
      ),
    );
  }
}




















//-------- How to use this ---------------------------------------------------->

// Search button nahi chahiye:
// VerveeTopBar()

// // Search button chahiye:
// VerveeTopBar(onSearchTap: () => _showSearchSheet(context))

// // Custom title:
// VerveeTopBar(title: 'VERVEE', subtitle: 'C O U R S E S')






// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../viewmodal/avatar/AvatarViewModel.dart';
// import '../../viewmodal/pofile/ProfileViewmodels.dart';
//
// // import '../../presentation/viewmodal/avatar/AvatarViewModel.dart';
// // import '../../presentation/viewmodal/pofile/ProfileViewmodels.dart';
//
// // ─── Constants (same as HomeScreen) ──────────────────────────────────────────
// const _kBgCard      = Color(0xFF150328);
// const _kBgDeep      = Color(0xFF0A0118);
// const _kPurple      = Color(0xFF7C3AED);
// const _kPurpleLight = Color(0xFF9333EA);
// const _kGold        = Color(0xFFD4AF37);
// const _kBorder      = Color(0xFF2D1050);
// const _kTextMuted   = Color(0xFF888888);
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  VERVEE TOP APP BAR  —  Common Widget
// //
// //  Usage:
// //    Column(children: [
// //      VerveeTopBar(
// //        onSearchTap: () { /* search logic */ },   // optional
// //      ),
// //      Expanded(child: yourBody),
// //    ])
// //
// //  Parameters:
// //    onSearchTap  — search icon tap callback (null = search icon hidden)
// //    title        — override title, default: 'VERVEE'
// //    subtitle     — override subtitle, default: 'A C A D E M Y'
// // ═══════════════════════════════════════════════════════════════════════════════
// class VerveeTopBar extends ConsumerStatefulWidget {
//   const VerveeTopBar({
//     super.key,
//     this.onSearchTap,
//     required this.onProfile,
//     this.title    = 'VERVEE',
//     this.subtitle = 'A C A D E M Y',
//   });
//
//   final VoidCallback? onSearchTap;
//   final String title;
//   final String subtitle;
//   final VoidCallback onProfile;
//
//   @override
//   ConsumerState<VerveeTopBar> createState() => _VerveeTopBarState();
// }
//
// class _VerveeTopBarState extends ConsumerState<VerveeTopBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _glowCtrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _glowCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _glowCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isTablet      = MediaQuery.of(context).size.width > 600;
//     final avatarUrl     = ref.watch(avatarViewModelProvider).generatedMascotUrl;
//     final profileState  = ref.watch(profileInfoViewModelProvider);
//
//     return Container(
//       color: _kBgCard,
//       padding: EdgeInsets.only(
//         top   : MediaQuery.of(context).padding.top + 8,
//         left  : 16,
//         right : 16,
//         bottom: 10,
//       ),
//       child: Row(
//         children: [
//           // ── Brand Logo ──────────────────────────────────────────────────────
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedBuilder(
//                 animation: _glowCtrl,
//                 builder: (_, __) => Text(
//                   widget.title,
//                   style: TextStyle(
//                     color      : _kGold,
//                     fontSize   : isTablet ? 22 : 18,
//                     fontWeight : FontWeight.w900,
//                     letterSpacing: 3,
//                     shadows: [
//                       Shadow(
//                         color     : _kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
//                         blurRadius: 8 + 4 * _glowCtrl.value,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Text(
//                 widget.subtitle,
//                 style: TextStyle(
//                   color        : _kPurpleLight,
//                   fontSize     : isTablet ? 9 : 7.5,
//                   fontWeight   : FontWeight.w600,
//                   letterSpacing: 3,
//                 ),
//               ),
//             ],
//           ),
//
//           const Spacer(),
//
//          // ── Search Icon (optional) ──────────────────────────────────────────
//           if (widget.onSearchTap != null) ...[
//             _TopIconBtn(icon: Icons.search_rounded, onTap: widget.onSearchTap!),
//             const SizedBox(width: 8),
//           ],
//
//           // ── Profile Avatar  (showcase only — no action on tap) ─────────────
//           _ProfileAvatar(
//             avatarUrl    : avatarUrl,
//             profileState : profileState,
//             onTap        : widget.onProfile,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── Profile Avatar — showcase only, GestureDetector with no callback ─────────
// class _ProfileAvatar extends StatelessWidget {
//   const _ProfileAvatar({
//     required this.avatarUrl,
//     required this.profileState,
//     required this.onTap,
//   });
//
//   final String? avatarUrl;
//   final dynamic profileState;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: avatarUrl == null
//               ? const LinearGradient(
//             colors: [_kGold, _kPurple],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )
//               : null,
//         ),
//         child: avatarUrl != null
//             ? ClipOval(
//           child: CachedNetworkImage(
//             imageUrl: avatarUrl!,
//             width: 34,
//             height: 34,
//             fit: BoxFit.cover,
//             errorWidget: (_, __, ___) =>
//                 _initialsCircle(profileState),
//           ),
//         )
//             : _initialsCircle(profileState),
//       ),
//     );
//   }
//
//   Widget _initialsCircle(dynamic profileState) {
//     final initial = profileState.profile != null
//         ? (profileState.profile!.name as String)
//         .substring(0, 1)
//         .toUpperCase()
//         : 'VA';
//
//     return Center(
//       child: Text(
//         initial,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Small circular icon button (reusable) ────────────────────────────────────
// class _TopIconBtn extends StatelessWidget {
//   const _TopIconBtn({required this.icon, required this.onTap});
//
//   final IconData     icon;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width : 39,
//         height: 39,
//         decoration: BoxDecoration(
//           shape : BoxShape.circle,
//           color : _kBgDeep,
//           border: Border.all(color: _kBorder, width: 0.5),
//         ),
//         child: Icon(icon, color: _kPurpleLight, size: 25),
//       ),
//     );
//   }
// }


//-------- How to use this ---------------------------------------------------->

// Search button nahi chahiye:
// VerveeTopBar()

// // Search button chahiye:
// VerveeTopBar(onSearchTap: () => _showSearchSheet(context))

// // Custom title:
// VerveeTopBar(title: 'VERVEE', subtitle: 'C O U R S E S')