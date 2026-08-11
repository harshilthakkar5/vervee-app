
// ═══════════════════════════════════════════════════════════════════════════════
//  FILE: lib/presentation/widgets/SharedBottomNav.dart
//
//  ✅ COMMON BOTTOM NAV — Ek baar banao, har screen pe use karo
//  Usage:
//    bottomNavigationBar: SharedBottomNav(currentIndex: 0),
//
//  Index Map:
//    0 = Home
//    1 = Financial
//    2 = Add (FAB)
//    3 = Courses
//    4 = Profile
// ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/screen/CoursesScreen.dart';
import 'package:vervee_app/presentation/screen/CreatePostScreen.dart';
import 'package:vervee_app/presentation/screen/FinancialLiteracyScreen.dart';
import 'package:vervee_app/presentation/screen/GalleryPickerScreen.dart';
import 'package:vervee_app/presentation/screen/HomeScreen.dart';
import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
import 'package:vervee_app/presentation/viewmodal/post/GetPostViewModel.dart';

// ── Colors (apni app ke constants file se import karo agar alag file hai) ─────
const _kBgCard      = Color(0xFF150328);
const _kPurple      = Color(0xFF7C3AED);
const _kPurpleLight = Color(0xFF9333EA);
const _kGold        = Color(0xFFD4AF37);
const _kGoldLight   = Color(0xFFFFD700);
const _kBorder      = Color(0xFF2D1050);
const _kTextMuted   = Color(0xFF888888);
const _kBgCard2     = Color(0xFF150328); // same as kBgCard — for FAB inner circle

// ── Nav Item Model ────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SHARED BOTTOM NAV WIDGET
// ═══════════════════════════════════════════════════════════════════════════════
class SharedBottomNav extends ConsumerStatefulWidget {
  /// Current active tab index (0=Home, 1=Financial, 2=Add, 3=Courses, 4=Profile)
  final int currentIndex;

  /// Agar true hai toh Home tab pop karke wapas jaata hai
  /// (non-home screens ke liye true karo)
  final bool popOnHome;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
    this.popOnHome = false,
  });

  @override
  ConsumerState<SharedBottomNav> createState() => _SharedBottomNavState();
}

class _SharedBottomNavState extends ConsumerState<SharedBottomNav> {
  double _fabScale = 1.0;

  static const _items = [
    _NavItem(icon: Icons.home_rounded,                label: 'Home'),
    _NavItem(icon: Icons.analytics_outlined, label: 'Financial'),
    _NavItem(icon: Icons.add_rounded,                 label: 'Add'),
    _NavItem(icon: Icons.play_circle_outline_rounded,      label: 'Courses'),
    _NavItem(icon: Icons.person_outline_rounded,      label: 'Profile'),
  ];

  // ── Navigation Logic ────────────────────────────────────────────────────────
  Future<void> _onTap(int i) async {
    // Already is tab pe hain — kuch mat karo
    if (i == widget.currentIndex && i != 0) return;

    switch (i) {
    // ── Home ──────────────────────────────────────────────────────────────
      case 0:
        if (widget.popOnHome) {
          // Non-home screen se Home tab dabaya — wapas jao
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        // HomeScreen pe already hain — scroll to top ka kaam HomeScreen
        // apne scrollController se kare, yahan kuch nahi karna
        break;

    // ── Financial ─────────────────────────────────────────────────────────
      case 1:
        if (widget.currentIndex != 1) {
          await AppNavigation.goToFinancial(context);
        }
        break;

    // ── Add (FAB) — case 2 is handled separately in build ─────────────────
      case 2:
        break;

    // ── Courses (future screen) ────────────────────────────────────────────
      case 3:
      // TODO: CoursesScreen navigate karo jab ready ho
      if (widget.currentIndex != 3) {
        await AppNavigation.goToCourses(context);
      }
        break;

    // ── Profile ───────────────────────────────────────────────────────────
      case 4:
        if (widget.currentIndex != 4) {
          await AppNavigation.goToProfile(context);
        }
        break;
    }
  }

  // ── FAB Tap ────────────────────────────────────────────────────────────────
  Future<void> _onFabTap() async {
    setState(() => _fabScale = 0.90);
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) setState(() => _fabScale = 1.0);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GalleryPickerScreen()), // CreatePostScreen()
    );

    // ✅ Feed refresh — sirf HomeScreen pe zaroorat hai
    if (context.mounted) {
      try {
        ref.read(getPostViewModelProvider.notifier).refresh();
      } catch (_) {
        // Agar provider available nahi hai toh ignore karo
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kBgCard,
        border: Border(top: BorderSide(color: _kBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              // ── CENTER FAB (index 2) ───────────────────────────────────────
              if (i == 2) {
                return _buildFab();
              }

              // ── NORMAL NAV ITEM ───────────────────────────────────────────
              return _buildNavItem(i);
            }),
          ),
        ),
      ),
    );
  }

  // ── FAB Widget ─────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return GestureDetector(
      onTapDown:  (_) => setState(() => _fabScale = 0.90),
      onTapUp:    (_) => setState(() => _fabScale = 1.0),
      onTapCancel: () => setState(() => _fabScale = 1.0),
      onTap: _onFabTap,
      child: AnimatedScale(
        scale: _fabScale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_kGoldLight, _kPurple, _kPurpleLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _kPurple.withOpacity(_fabScale < 1 ? 0.25 : 0.45),
                blurRadius: _fabScale < 1 ? 10 : 22,
                spreadRadius: _fabScale < 1 ? 1 : 3,
              ),
              BoxShadow(
                color: _kGold.withOpacity(_fabScale < 1 ? 0.15 : 0.28),
                blurRadius: _fabScale < 1 ? 12 : 26,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _kBgCard2,
            ),
            child: AnimatedRotation(
              turns: _fabScale < 1 ? 0.08 : 0,
              duration: const Duration(milliseconds: 150),
              child: const Icon(
                Icons.add_rounded,
                color: _kGoldLight,
                size: 34,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Normal Nav Item Widget ──────────────────────────────────────────────────
  Widget _buildNavItem(int i) {
    final isSelected = widget.currentIndex == i;

    return GestureDetector(
      onTap: () => _onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _kPurple.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ───────────────────────────────────────────────────────
            Icon(
              _items[i].icon,
              size: 22,
              color: isSelected ? _kGold : _kTextMuted,
            ),

            const SizedBox(height: 3),

            // ── Label ──────────────────────────────────────────────────────
            Text(
              _items[i].label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? _kGold : _kTextMuted,
              ),
            ),

            // ── Selected Dot ───────────────────────────────────────────────
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kGold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  APP NAVIGATION HELPER
//  Sab navigation ek jagah — agar route change karna ho toh sirf yahan badlo
// ═══════════════════════════════════════════════════════════════════════════════
class AppNavigation {
  AppNavigation._(); // instantiate mat karo

  /// Financial Literacy Screen
  static Future<void> goToFinancial(BuildContext context) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const FinancialLiteracyScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Profile Screen
  static Future<void> goToProfile(BuildContext context) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const ProfileScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Courses Screen
  static Future<void> goToCourses(BuildContext context) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const CoursesScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Home Screen (root tak wapas)
  static void goToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

// ── Future screens yahan add karo ─────────────────────────────────────────
// static Future<void> goToCourses(BuildContext context) { ... }
// static Future<void> goToSignals(BuildContext context) { ... }
}