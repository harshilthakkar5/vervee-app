
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTopAppBar extends StatelessWidget {
  final bool isTablet;
  final AnimationController glowCtrl;

  // ✅ Search Button Callback
  final VoidCallback onSearchTap;

  // ✅ Profile/Logout Button Callback
  final VoidCallback onProfileTap;

  // ✅ COLORS PASS KIYE
  final Color kBgCard;
  final Color kGold;
  final Color kPurple;
  final Color kPurpleLight;

  const CommonTopAppBar({
    super.key,
    required this.isTablet,
    required this.glowCtrl,
    required this.onSearchTap,
    required this.onProfileTap,
    required this.kBgCard,
    required this.kGold,
    required this.kPurple,
    required this.kPurpleLight,
  });

  @override
  Widget build(BuildContext context) {

    // ✅ Status Bar Style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      color: kBgCard,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 10,
      ),

      child: Row(
        children: [

          // ✅ LOGO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              AnimatedBuilder(
                animation: glowCtrl,
                builder: (_, __) => Text(
                  'VERVEE',
                  style: TextStyle(
                    color: kGold,
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,

                    shadows: [
                      Shadow(
                        color: kGold.withOpacity(
                          0.4 + 0.3 * glowCtrl.value,
                        ),
                        blurRadius: 8 + 4 * glowCtrl.value,
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                'A C A D E M Y',
                style: TextStyle(
                  color: kPurpleLight,
                  fontSize: isTablet ? 9 : 7.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ✅ SEARCH BUTTON
          _TopIconBtn(
            icon: Icons.search_rounded,
            onTap: onSearchTap,
            kPurpleLight: kPurpleLight,
          ),

          const SizedBox(width: 8),

          // ✅ PROFILE / LOGOUT BUTTON
          GestureDetector(
            onTap: onProfileTap,

            child: Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: LinearGradient(
                  colors: [kGold, kPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: const Center(
                child: Text(
                  'VA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ COMMON ICON BUTTON
class _TopIconBtn extends StatelessWidget {

  final IconData icon;
  final VoidCallback onTap;
  final Color kPurpleLight;

  const _TopIconBtn({
    required this.icon,
    required this.onTap,
    required this.kPurpleLight,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 39,
        height: 39,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0A0118),

          border: Border.all(
            color: const Color(0xFF2D1050),
            width: 0.5,
          ),
        ),

        child: Icon(
          icon,
          color: kPurpleLight,
          size: 25,
        ),
      ),
    );
  }
}