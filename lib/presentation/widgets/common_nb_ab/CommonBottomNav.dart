
import 'package:flutter/material.dart';

class CommonBottomNav extends StatelessWidget {

  final int currentIndex;

  // ✅ SCREEN CHANGE CALLBACK
  final Function(int index) onItemTap;

  // ✅ ADD BUTTON CALLBACK
  final VoidCallback onAddTap;

  // ✅ SCALE ANIMATION
  final double fabScale;

  // ✅ COLORS
  final Color kBgCard;
  final Color kBorder;
  final Color kPurple;
  final Color kPurpleLight;
  final Color kGold;
  final Color kGoldLight;
  final Color kTextMuted;

  const CommonBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemTap,
    required this.onAddTap,
    required this.fabScale,
    required this.kBgCard,
    required this.kBorder,
    required this.kPurple,
    required this.kPurpleLight,
    required this.kGold,
    required this.kGoldLight,
    required this.kTextMuted,
  });

  @override
  Widget build(BuildContext context) {

    final items = [

      // ✅ YAHAN LABEL + ICON DEFINE HOTE HAIN
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Courses'),
      _NavItem(icon: Icons.add_rounded, label: 'Add'),
      _NavItem(icon: Icons.wifi_tethering_rounded, label: 'Signals'),
      _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(

      decoration: BoxDecoration(
        color: kBgCard,

        border: Border(
          top: BorderSide(
            color: kBorder,
            width: 0.5,
          ),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: List.generate(items.length, (i) {

              final isSelected = currentIndex == i;

              // ✅ CENTER ADD BUTTON
              if (i == 2) {

                return GestureDetector(
                  onTap: onAddTap,

                  child: AnimatedScale(
                    scale: fabScale,
                    duration: const Duration(milliseconds: 120),

                    child: Container(
                      width: 60,
                      height: 60,

                      margin: const EdgeInsets.only(bottom: 15),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          colors: [
                            kGoldLight,
                            kPurple,
                            kPurpleLight,
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: kPurple.withOpacity(0.45),
                            blurRadius: 22,
                            spreadRadius: 3,
                          ),
                        ],
                      ),

                      child: Container(
                        margin: const EdgeInsets.all(4),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kBgCard,
                        ),

                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.amber,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // ✅ NORMAL ITEMS
              return GestureDetector(
                onTap: () {
                  onItemTap(i);
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? kPurple.withOpacity(0.15)
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      Icon(
                        items[i].icon,
                        size: 22,

                        color: isSelected
                            ? kGold
                            : kTextMuted,
                      ),

                      const SizedBox(height: 3),

                      Text(
                        items[i].label,

                        style: TextStyle(
                          fontSize: 9.5,

                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,

                          color: isSelected
                              ? kGold
                              : kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {

  final IconData icon;
  final String label;

  _NavItem({
    required this.icon,
    required this.label,
  });
}