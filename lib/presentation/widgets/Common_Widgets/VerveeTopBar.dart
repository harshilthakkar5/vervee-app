
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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