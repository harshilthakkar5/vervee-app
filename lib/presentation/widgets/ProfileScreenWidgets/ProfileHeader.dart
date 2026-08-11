
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/model/profile/SubscriptionInfo.dart';
import '../../../domain/model/profile/UserProfile.dart';
import '../../screen/AvatarCustomizationScreen.dart';
//import '../../screen/HomeScreen.dart';
// import '../constants.dart';
// import '../domain/models/profile_domain.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile  profile;      // ← API data
  final VoidCallback onEdit;
  final VoidCallback onFinancialLiteracy;
  final VoidCallback onSettings;
  final VoidCallback onlogout;
  final int          activeTab;
  final ValueChanged<int> onTabChange;
  final int postsCount; // ✅ ADD KARO
  final String? avatarUrl; // ✅ ADD KARO
  final VoidCallback onAvatarTap; // ✅ ADD
  final SubscriptionInfo? subscription; // ← ADD

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onFinancialLiteracy,
    required this.onSettings,
    required this.onlogout,
    required this.activeTab,
    required this.onTabChange,
    required this.postsCount, // ✅ ADD KARO
    required this.avatarUrl, // ✅ ADD KARO
    required this.onAvatarTap, // ✅ ADD
    this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    // Name ki first letter initial ke liye
    final initial = profile.name.isNotEmpty
        ? profile.name[0].toUpperCase()
        : '?';

    return Container(
      color: kBgCard,
      child: Column(
        children: [
          // ── Cover + Avatar ────────────────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Container(
              //   height: 90,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         Color(0xFF3b0d6e),
              //         Color(0xFF7C3AED),
              //         Color(0xFF1a0a3e),
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //   ),
              // ),

        Container(
        height: 132, // ✅ 90 (cover) + 42 (avatar overlap)
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3b0d6e),
                      Color(0xFF7C3AED),
                      Color(0xFF1a0a3e),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

              // Positioned(
              //   bottom: -42,
              //   left: 20,
              //   child: GestureDetector(          // ✅ Pura avatar circle tappable
              //     behavior: HitTestBehavior.opaque,
              //     onTap: onAvatarTap,
              //     child: Stack(
              //       clipBehavior: Clip.none,
              //       children: [
              //         // ── Avatar circle ───────────────────────────────
              //         Container(
              //           width: 79, height: 79,
              //           margin: const EdgeInsets.only(right: 2),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             gradient: avatarUrl == null
              //                 ? const LinearGradient(
              //               colors: [kGold, kPurple],
              //               begin: Alignment.topLeft,
              //               end: Alignment.bottomRight,
              //             )
              //                 : null,
              //             border: Border.all(color: kBgCard, width: 3),
              //           ),
              //           child: avatarUrl != null
              //               ? ClipOval(
              //             child: Image.network(
              //               avatarUrl!,
              //               width: 79, height: 79,     // ✅ size fix — 34 nahi 79
              //               fit: BoxFit.cover,
              //               errorBuilder: (_, __, ___) => Center(
              //                 child: Text(initial,
              //                     style: const TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 28,
              //                         fontWeight: FontWeight.w700)),
              //               ),
              //             ),
              //           )
              //               : Center(
              //             child: Text(initial,         // ✅ 'VA' nahi, actual initial
              //                 style: const TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 28,
              //                     fontWeight: FontWeight.w700)),
              //           ),
              //         ),
              //
              //         // ── Add button badge ────────────────────────────
              //         Positioned(
              //           bottom: 0,
              //           right: 0,
              //           child: Container(          // ✅ GestureDetector hataya — parent se handle
              //             width: 26, height: 26,
              //             decoration: BoxDecoration(
              //               color: kPurple,
              //               shape: BoxShape.circle,
              //               border: Border.all(color: kBgCard, width: 2),
              //             ),
              //             child: const Icon(Icons.add, color: Colors.white, size: 15),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

            Positioned(
              top: 48, // 90 - 42 = 48
              left: 20,
              child: SizedBox(
                width: 86, height: 86,
                child: Stack(
                  children: [
                    // Avatar circle
                    Container(
                      width: 79, height: 79,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: avatarUrl == null
                            ? const LinearGradient(
                          colors: [kGold, kPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        border: Border.all(color: kBgCard, width: 3),
                      ),
                      child: avatarUrl != null
                          ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl!,
                          width: 79, height: 79,
                          fit: BoxFit.cover,
                          // ✅ Disk cache — offline pe bhi pehle se-loaded avatar dikhega
                          placeholder: (_, __) => Center(
                            child: Text(initial,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700)),
                          ),
                          errorWidget: (_, __, ___) => Center(
                            child: Text(initial,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      )
                      // child: avatarUrl != null
                      //     ? ClipOval(
                      //   child: Image.network(
                      //     avatarUrl!,
                      //     width: 79, height: 79,
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (_, __, ___) => Center(
                      //       child: Text(initial,
                      //           style: const TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 28,
                      //               fontWeight: FontWeight.w700)),
                      //     ),
                      //   ),
                      // )
                          : Center(
                        child: Text(initial,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),

                    // ✅ Add button — ab Stack ke andar hai, tap kaam karega
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          //print('ADD TAPPED'); // ✅ ab aayega
                          onAvatarTap();
                        },
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: kPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBgCard, width: 2),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),

            ],
          ),

          // ── Stats Row ─────────────────────────────────────────
          // Note: totalCourses/Certifications API mein nahi hain abhi
          // Isliye posts count use kar rahe hain — baad mein update karna
           Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //_StatItem(value: '—', label: 'Posts'),
                _StatItem(value: postsCount.toString(), label: 'Posts'),
                SizedBox(width: 24),
                _StatItem(value: '2', label: 'Courses'),
                SizedBox(width: 24),
                //_StatItem(value: 'Free', label: 'Plan'),
                _PlanStatItem(subscription: subscription),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Name / Email / Badge ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ← API se naam
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                // ← API se email
                Text(
                  profile.email,
                  style: const TextStyle(color: kTextMuted, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: kPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Vervee Academy Member',
                      style: TextStyle(
                          color: Color(0xFFa78bfa), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Action Buttons ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: onSettings,
                  ),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.logout_rounded,//Icons.list_outlined,
                  onTap: //onlogout,
                      () {
                    //onlogout;
                    _showLogoutDialog(context, onlogout);
                  },
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Subscription Banner ───────────────────────────────
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Container(
          //     padding:
          //     const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF251f3e),
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(color: const Color(0xFF4c3a7e)),
          //     ),
          //     child: Row(
          //       children: [
          //         const Expanded(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'No Active Subscription',
          //                 style: TextStyle(
          //                   color: Color(0xFFa78bfa),
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //               SizedBox(height: 2),
          //               Text(
          //                 'Upgrade to access premium content',
          //                 style: TextStyle(
          //                     color: Color(0xFF7a6a9a), fontSize: 10),
          //               ),
          //             ],
          //           ),
          //         ),
          //         ElevatedButton(
          //           onPressed: onFinancialLiteracy,
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: kPurple,
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 12, vertical: 6),
          //             minimumSize: Size.zero,
          //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //           child: const Text(
          //             'Upgrade',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // AFTER
          // _SubscriptionBanner(
          //   subscription: subscription,
          //   onAction: onFinancialLiteracy,
          // ),

          const SizedBox(height: 12),

          // ── Tab Bar ───────────────────────────────────────────
          // ── Tab Bar ───────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kBorder, width: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: kPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPurple, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.grid_on_rounded, size: 16, color: kPurple),
                      SizedBox(width: 6),
                      Text(
                        'Feeds',
                        style: TextStyle(
                          color: kPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     border: Border(top: BorderSide(color: kBorder, width: 0.5)),
          //   ),
          //   child: Row(
          //     children: [
          //       _TabIcon(
          //         icon: Icons.grid_on_rounded,
          //         isActive: activeTab == 0,
          //         onTap: () => onTabChange(0),
          //       ),
          //       _TabIcon(
          //         icon: Icons.phone_outlined,
          //         isActive: activeTab == 1,
          //         onTap: () => onTabChange(1),
          //       ),
          //       _TabIcon(
          //         icon: Icons.menu_book_outlined,
          //         isActive: activeTab == 2,
          //         onTap: () => onTabChange(2),
          //       ),
          //       _TabIcon(
          //         icon: Icons.bar_chart_rounded,
          //         isActive: activeTab == 3,
          //         onTap: () => onTabChange(3),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}


// ── Logout Popup ───────────────────────────────────────────
void _showLogoutDialog(
    BuildContext context,
    VoidCallback onLogout,
    ) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kBorder,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: kPurple.withOpacity(.25),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      kRed.withOpacity(.9),
                      Colors.redAccent,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Logout?",
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Are you sure you want to logout from your account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextMuted,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: kBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: kTextPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        // Actual Logout
                        onLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Yes, Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ── Sub-widgets (unchanged) ───────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: kTextPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: kTextMuted, fontSize: 11)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData  icon;
  final String?   label;
  final VoidCallback onTap;
  final bool      compact;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 0, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2b3e),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            if (label != null) ...[
              const SizedBox(width: 5),
              Text(label!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool     isActive;
  final VoidCallback onTap;

  const _TabIcon(
      {required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: isActive ? kPurple : Colors.transparent, width: 2),
            ),
          ),
          child: Icon(icon,
              size: 20, color: isActive ? kPurple : kTextMuted),
        ),
      ),
    );
  }
}


//------- Dynamic status ---------------------------------------------------------->


// ── Plan Stat Item (dynamic dot + text) ──────────────────────────────
class _PlanStatItem extends StatelessWidget {
  final SubscriptionInfo? subscription;
  const _PlanStatItem({this.subscription});

  @override
  Widget build(BuildContext context) {
    final sub = subscription;

    String text;
    Color color;

    if (sub != null && sub.isActive && !sub.cancelAtPeriodEnd) {
      text  = 'Active';
      color = kGreen;
    } else if (sub != null && sub.isPastDue) {
      text  = 'Due';
      color = kRed;
    } else if (sub != null && sub.isTrialing) {
      text  = 'Free';
      color = kPurpleLight;
    } else if (sub != null && sub.cancelAtPeriodEnd) {
      text  = 'Free';
      color = kGold;
    } else {
      text  = 'Free';
      color = kTextMuted;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 5),
            Container(
              margin: const EdgeInsets.only(top: 3),
              //padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              width: 6, height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Plan', style: TextStyle(color: kTextMuted, fontSize: 11)),
      ],
    );
  }
}

// ── Subscription Banner (dynamic) ─────────────────────────────────────
class _SubscriptionBanner extends StatelessWidget {
  final SubscriptionInfo? subscription;
  final VoidCallback onAction;

  const _SubscriptionBanner(
      {this.subscription, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final sub = subscription;

    // ── Active (not cancelling) ──────────────────────────────────
    if (sub != null && sub.isActive && !sub.cancelAtPeriodEnd) {
      return _banner(
        bg:       kGreen.withOpacity(0.09),
        border:   kGreen.withOpacity(0.35),
        title:    '✓ Premium Active',
        titleClr: kGreen,
        subtitle: 'You have full access to all content',
        subClr:   kGreen.withOpacity(0.65),
        // btnLabel / btnColor nahi → button nahi dikhega
      );
    }

    // ── Cancelling at period end ─────────────────────────────────
    if (sub != null && sub.cancelAtPeriodEnd) {
      final until = sub.trialEnd != null
          ? 'Access until ${_fmt(sub.trialEnd!)}'
          : 'Access ending soon';
      return _banner(
        bg:       kGold.withOpacity(0.09),
        border:   kGold.withOpacity(0.4),
        title:    'Subscription Cancelling',
        titleClr: kGold,
        subtitle: until,
        subClr:   kGold.withOpacity(0.65),
        btnLabel: 'Renew',      // ← rakho
        btnColor: kGold,        // ← rakho
      );
    }

    // ── Trialing ─────────────────────────────────────────────────
    if (sub != null && sub.isTrialing) {
      final ends = sub.trialEnd != null
          ? 'Trial ends ${_fmt(sub.trialEnd!)}'
          : 'Upgrade to keep access';
      return _banner(
        bg:       kPurpleLight.withOpacity(0.09),
        border:   kPurpleLight.withOpacity(0.4),
        title:    'Trial Active',
        titleClr: kPurpleLight,
        subtitle: ends,
        subClr:   kPurpleLight.withOpacity(0.65),
        // btnLabel / btnColor nahi
      );
    }

    // ── Past Due ─────────────────────────────────────────────────
    if (sub != null && sub.isPastDue) {
      return _banner(
        bg:       kRed.withOpacity(0.09),
        border:   kRed.withOpacity(0.4),
        title:    'Payment Past Due',
        titleClr: kRed,
        subtitle: 'Please update your payment method',
        subClr:   kRed.withOpacity(0.65),
        // btnLabel / btnColor nahi
        btnLabel: 'Update',    // ← rakho
        btnColor: kRed,      // ← rakho
      );
    }

    // ── No subscription (default) ────────────────────────────────
    return _banner(
      bg:       const Color(0xFF251f3e),
      border:   const Color(0xFF4c3a7e),
      title:    'No Active Subscription',
      titleClr: const Color(0xFFa78bfa),
      subtitle: 'Upgrade to access premium content',
      subClr:   const Color(0xFF7a6a9a),
      btnLabel: 'Upgrade',    // ← rakho
      btnColor: kPurple,      // ← rakho
    );
  }

  // Widget _banner({
  //   required Color bg,
  //   required Color border,
  //   required String title,
  //   required Color titleClr,
  //   required String subtitle,
  //   required Color subClr,
  //   required String btnLabel,
  //   required Color btnColor,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: bg,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: border),
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(title,
  //                     style: TextStyle(
  //                         color: titleClr,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600)),
  //                 const SizedBox(height: 2),
  //                 Text(subtitle,
  //                     style: TextStyle(color: subClr, fontSize: 10)),
  //               ],
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: onAction,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: btnColor,
  //               padding:
  //               const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               minimumSize: Size.zero,
  //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8)),
  //             ),
  //             child: Text(btnLabel,
  //                 style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w600)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // AFTER
  Widget _banner({
    required Color bg,
    required Color border,
    required String title,
    required Color titleClr,
    required String subtitle,
    required Color subClr,
    String? btnLabel,   // ← optional
    Color? btnColor,    // ← optional
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: titleClr,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(color: subClr, fontSize: 10)),
                ],
              ),
            ),
            // ── Button sirf tab dikhao jab label hai ────────────
            if (btnLabel != null && btnColor != null) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(btnLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    const m = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }
}





























