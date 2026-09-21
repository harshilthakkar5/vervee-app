
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/profile/SubscriptionInfo.dart';
import '../../utils/AuthService.dart';
import '../../utils/PostCacheService.dart';
import '../../utils/ProfileCacheService.dart';
import '../../utils/WebViewScreen.dart';
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import 'HomeScreen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'LoginScreen.dart';
import 'ProfileScreen.dart' show kGreen;
// import '../../constants.dart';
// import '../../application/viewmodel/profile_viewmodels.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Profile se email lena hai (Change Password API ko email chahiye)
    final profileState = ref.watch(profileInfoViewModelProvider);
    final avatarUrl = ref.watch(avatarViewModelProvider).generatedMascotUrl; // ✅ ADD
    final userEmail    = profileState.profile?.email ?? '';

    return Scaffold(
      backgroundColor: kBgDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: kBgCard,
            expandedHeight: 160,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: kPurpleLight, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff040009), Color(0x552B044A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // 0xff040009 0x552B044A
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // CircleAvatar(
                        //   radius: 32,
                        //   backgroundColor: kPurple,
                        //   child: Text(
                        //     profileState.profile?.name.isNotEmpty == true
                        //         ? profileState.profile!.name[0].toUpperCase()
                        //         : 'D',
                        //     style: const TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 26,
                        //         fontWeight: FontWeight.w700),
                        //   ),
                        // ),
                        // BAAD MEIN (ye lagao):
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: avatarUrl == null
                                      ? const LinearGradient(
                                    colors: [kGold, kPurple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : null,
                                  border: Border.all(color: kBgDark, width: 2),
                                ),
                                child: avatarUrl != null
                                    ? ClipOval(
                                  child: Image.network(
                                    avatarUrl,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        profileState.profile?.name.isNotEmpty == true
                                            ? profileState.profile!.name[0].toUpperCase()
                                            : 'D',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                )
                                    : Center(
                                  child: Text(
                                    profileState.profile?.name.isNotEmpty == true
                                        ? profileState.profile!.name[0].toUpperCase()
                                        : 'D',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: kPurpleLight,
              indicatorWeight: 2,
              labelColor: kPurpleLight,
              unselectedLabelColor: kTextMuted,
              labelStyle: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              tabs: const [
                Tab(text: 'Account Management'),
               // Tab(text: 'Billing & Subscription'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            // Pass email from profile API
            _AccountTab(userEmail: userEmail),
           // const _BillingTab(),
          ],
        ),
      ),
    );
  }
}

// ── Account Management Tab ────────────────────────────────────────────

class _AccountTab extends ConsumerStatefulWidget {
  final String userEmail;
  const _AccountTab({required this.userEmail});

  @override
  ConsumerState<_AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<_AccountTab> {
  final _currPwCtrl    = TextEditingController();
  final _newPwCtrl     = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  bool _showCurr    = false;
  bool _showNew     = false;
  bool _showConfirm = false;
  bool _showDeleteConfirm = false;

  @override
  void dispose() {
    _currPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pwState = ref.watch(changePasswordViewModelProvider);

    // Listen for success/error → snackbar
    ref.listen(changePasswordViewModelProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: kBgDark,
          ),
        );
        // Clear fields on success
        _currPwCtrl.clear();
        _newPwCtrl.clear();
        _confirmPwCtrl.clear();
        ref
            .read(changePasswordViewModelProvider.notifier)
            .clearMessages();
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: kRed,
          ),
        );
        ref
            .read(changePasswordViewModelProvider.notifier)
            .clearMessages();
      }
    });


    // Delete Account listener — success pe logout + LoginScreen navigate
    ref.listen(deleteAccountViewModelProvider, (_, next) async {
      if (next.isDeleted) {
        // Same cleanup jo _logout() me hota hai — cache clear + session clear
        await PostCacheService.clearAllCache();
        await ProfileCacheService.instance.clearAll();
        await CachedNetworkImage.evictFromCache('');
        await DefaultCacheManager().emptyCache();
        await AuthService.instance.logout(keepCredentials: false);

        ref.invalidate(profileInfoViewModelProvider);
        ref.invalidate(userFeedViewModelProvider);
        ref.invalidate(subscriptionViewModelProvider);
        ref.invalidate(avatarViewModelProvider);
        ref.invalidate(deleteAccountViewModelProvider);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage ?? 'Account deleted'),
            backgroundColor: kBgDark,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: kRed,
          ),
        );
        ref.read(deleteAccountViewModelProvider.notifier).clearMessages();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Change Password Card ─────────────────────────────
          _SettingsCard(
            title: 'CHANGE PASSWORD',
            child: Column(
              children: [
                _PasswordField(
                  controller: _currPwCtrl,
                  hint: 'Current Password',
                  show: _showCurr,
                  onToggle: () =>
                      setState(() => _showCurr = !_showCurr),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _PasswordField(
                        controller: _newPwCtrl,
                        hint: 'New Password',
                        show: _showNew,
                        onToggle: () =>
                            setState(() => _showNew = !_showNew),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PasswordField(
                        controller: _confirmPwCtrl,
                        hint: 'Confirm',
                        show: _showConfirm,
                        onToggle: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // ← API call here
                    onPressed: pwState.isLoading
                        ? null
                        : () {
                      // Validate confirm password match
                      if (_newPwCtrl.text !=
                          _confirmPwCtrl.text) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                'New passwords do not match'),
                            backgroundColor: kRed,
                          ),
                        );
                        return;
                      }
                      ref
                          .read(changePasswordViewModelProvider
                          .notifier)
                          .changePassword(
                        email: widget.userEmail,
                        currentPassword:
                        _currPwCtrl.text.trim(),
                        newPassword: _newPwCtrl.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2a2b3e),
                      disabledBackgroundColor:
                      const Color(0xFF2a2b3e).withOpacity(0.5),
                      padding:
                      const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: kBorder),
                      ),
                    ),
                    child: pwState.isLoading
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Text(
                      'Change Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Account Deletion Card ────────────────────────────
          _SettingsCard(
            title: 'ACCOUNT DELETION',
            titleColor: kRed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Once deleted, your account and all associated data will be permanently removed. This action cannot be undone.',
                  style: TextStyle(
                      color: kTextMuted, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 14),
                if (!_showDeleteConfirm)
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _showDeleteConfirm = true),
                    icon: const Icon(Icons.delete_outline,
                        color: kRed, size: 16),
                    label: const Text('Delete Account',
                        style: TextStyle(color: kRed, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kRed),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1f0a0a),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: kRed.withOpacity(0.3), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Are you sure? This cannot be undone.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(
                                        () => _showDeleteConfirm = false),
                                style: OutlinedButton.styleFrom(
                                  side:
                                  const BorderSide(color: kBorder),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9),
                                ),
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        color: kTextMuted,
                                        fontSize: 13)),
                              ),
                            ),
                            // const SizedBox(width: 10),
                            // Expanded(
                            //   child: ElevatedButton(
                            //     // Delete API nahi hai abhi
                            //     onPressed: () {},
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: kRed,
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius:
                            //           BorderRadius.circular(8)),
                            //       padding: const EdgeInsets.symmetric(
                            //           vertical: 9),
                            //     ),
                            //     child: const Text('Yes, Delete',
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 13,
                            //             fontWeight: FontWeight.w600)),
                            //   ),
                            // ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final delState =
                                  ref.watch(deleteAccountViewModelProvider);
                                  return ElevatedButton(
                                    onPressed: delState.isLoading
                                        ? null
                                        : () {
                                      ref
                                          .read(deleteAccountViewModelProvider
                                          .notifier)
                                          .deleteAccount();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kRed,
                                      disabledBackgroundColor:
                                      kRed.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                    ),
                                    child: delState.isLoading
                                        ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2),
                                    )
                                        : const Text('Yes, Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w600)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Billing Tab (static — purchase API nahi hai abhi) ────────────────------->

class _BillingTab extends ConsumerStatefulWidget {
  const _BillingTab();

  @override
  ConsumerState<_BillingTab> createState() => _BillingTabState();
}

class _BillingTabState extends ConsumerState<_BillingTab> {
  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionViewModelProvider);

    // Portal error ko snackbar mein dikhao
    // ref.listen(subscriptionViewModelProvider, (_, next) {
    //   if (next.portalErrorMessage != null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(next.portalErrorMessage!),
    //         backgroundColor: kRed,
    //       ),
    //     );
    //     ref
    //         .read(subscriptionViewModelProvider.notifier)
    //         .clearPortalError();
    //   }
    // });

    // ── Listener: portalUrl aaya → WebViewScreen navigate karo ──────
    ref.listen(subscriptionViewModelProvider, (_, next) {

      // Portal URL ready → WebView mein open karo
      if (next.portalUrl != null) {
        ref.read(subscriptionViewModelProvider.notifier).clearPortalUrl();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(url: next.portalUrl!),
          ),
        );
      }

      // Portal error → snackbar
      if (next.portalErrorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.portalErrorMessage!),
            backgroundColor: kRed,
          ),
        );
        ref.read(subscriptionViewModelProvider.notifier).clearPortalError();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _SettingsCard(
        title: 'SUBSCRIPTION & BILLING',
        child: Column(
          children: [
            // ── Loading state ──────────────────────────────────
            if (subState.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(
                    color: kPurpleLight, strokeWidth: 2),
              )

            // ── Error state ────────────────────────────────────
            else if (subState.errorMessage != null && subState.subscription == null)
              _SubErrorWidget(
                message: subState.errorMessage!,
                onRetry: () => ref
                    .read(subscriptionViewModelProvider.notifier)
                    .loadSubscription(),
              )

            // ── Data loaded ────────────────────────────────────
            else ...[
                // Current subscription status card
                _CurrentSubCard(subscription: subState.subscription),
                // const SizedBox(height: 16),
                //
                // // Plan cards (Free / Pro)
                // _PlanCard(
                //   name: 'Free',
                //   price: '₹0',
                //   description: 'Basic feeds access only',
                //   features: const ['Access to public feeds', 'Limited posts'],
                //   featured: false,
                // ),
                // const SizedBox(height: 10),
                // _PlanCard(
                //   name: 'Pro',
                //   price: '₹999',
                //   description: 'All premium content',
                //   features: const [
                //     'All premium feeds',
                //     'Forex & crypto signals',
                //     'Certification courses',
                //     'Priority support',
                //   ],
                //   featured: true,
                // ),
                 const SizedBox(height: 16),

                // Manage Subscription button → POST /subscription/customer-portal
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: subState.isPortalLoading
                        ? null
                        : () => ref
                        .read(subscriptionViewModelProvider.notifier)
                        .openCustomerPortal(),
                    icon: subState.isPortalLoading
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Icon(Icons.settings_outlined,
                        color: Colors.white, size: 16),
                    label: Text(
                      subState.isPortalLoading
                          ? 'Opening...'
                          : 'Manage Subscription',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      disabledBackgroundColor: kPurple.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

// ── Current Subscription Status Card ────────────────────────────────────────
// API response: { status, trialEnd, cancelAtPeriodEnd }
// Web app ki tarah: plan name + status badge + trialEnd date dikhao
class _CurrentSubCard extends StatelessWidget {
  final SubscriptionInfo? subscription;
  const _CurrentSubCard({this.subscription});

  @override
  Widget build(BuildContext context) {
    if (subscription == null || subscription!.hasNoSub) {
      // No subscription
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: kBgDeep,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder),
        ),
        child: const Center(
          child: Text(
            "You don't have an active subscription.",
            style: TextStyle(color: kTextMuted, fontSize: 13),
          ),
        ),
      );
    }

    final sub = subscription!;
    final badgeColor  = _badgeColor(sub);
    final badgeText   = sub.statusLabel; // "Active" / "Trial" / "Cancelled" etc.

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBgDeep,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Your Current Subscription"
          const Text(
            'Your Current Subscription',
            style: TextStyle(
                color: kTextMuted, fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          // Plan name + status badge (same as web app)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subscription Plan',
                style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              // Status badge — e.g. "Cancelled" in orange, "Active" in green
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeColor.withOpacity(0.5)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                      color: badgeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          // Included items label
          if (!sub.hasNoSub) ...[
            const SizedBox(height: 8),
            const Text(
              'Included Items:',
              style: TextStyle(color: kTextMuted, fontSize: 11),
            ),
          ],

          // Trial end date (if trialing)
          if (sub.isTrialing && sub.trialEnd != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 12, color: kTextMuted),
                const SizedBox(width: 4),
                Text(
                  'Trial ends ${_formatDate(sub.trialEnd!)}',
                  style:
                  const TextStyle(color: kTextMuted, fontSize: 11),
                ),
              ],
            ),
          ],

          // Cancel at period end warning
          if (sub.cancelAtPeriodEnd && sub.trialEnd != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 12, color: kGold),
                const SizedBox(width: 4),
                Text(
                  'Cancels on ${_formatDate(sub.trialEnd!)}',
                  style: const TextStyle(color: kGold, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _badgeColor(SubscriptionInfo sub) {
    if (sub.cancelAtPeriodEnd || sub.isCanceled) return kGold;      // orange
    if (sub.isActive)   return kGreen;
    if (sub.isTrialing) return kPurpleLight;
    if (sub.isPastDue)  return kRed;
    return kTextMuted;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ── Subscription Error Widget ─────────────────────────────────────────────────
class _SubErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _SubErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 40),
          const SizedBox(height: 10),
          Text(message,
              style: const TextStyle(color: kTextMuted, fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kPurple),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Retry',
                style: TextStyle(color: kPurpleLight, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// class _BillingTab extends StatelessWidget {
//   const _BillingTab();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: _SettingsCard(
//         title: 'SUBSCRIPTION & BILLING',
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: kBgDeep,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: kBorder),
//               ),
//               child: const Center(
//                 child: Text(
//                   "You don't have an active subscription.",
//                   style: TextStyle(color: kTextMuted, fontSize: 13),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _PlanCard(
//               name: 'Free',
//               price: '₹0',
//               description: 'Basic feeds access only',
//               features: const ['Access to public feeds', 'Limited posts'],
//               featured: false,
//             ),
//             const SizedBox(height: 10),
//             _PlanCard(
//               name: 'Pro',
//               price: '₹999',
//               description: 'All premium content',
//               features: const [
//                 'All premium feeds',
//                 'Forex & crypto signals',
//                 'Certification courses',
//                 'Priority support',
//               ],
//               featured: true,
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 // Purchase API nahi hai abhi
//                 onPressed: () {},
//                 icon: const Icon(Icons.settings_outlined,
//                     color: Colors.white, size: 16),
//                 label: const Text(
//                   'Manage Subscription',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kPurple,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ── Shared sub-widgets ────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget child;
  const _SettingsCard(
      {required this.title, required this.child, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: titleColor ?? kPurpleLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;
  const _PasswordField(
      {required this.controller,
        required this.hint,
        required this.show,
        required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !show,
      style: const TextStyle(color: kTextPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextMuted, fontSize: 12),
        filled: true,
        fillColor: kBgDeep,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            show
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: kTextMuted,
            size: 18,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kPurple)),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name, price, description;
  final List<String> features;
  final bool featured;
  const _PlanCard(
      {required this.name,
        required this.price,
        required this.description,
        required this.features,
        required this.featured});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: featured ? const Color(0xFF251f3e) : kBgDeep,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: featured ? kPurple : kBorder, width: featured ? 1.5 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                            color: featured
                                ? const Color(0xFFa78bfa)
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    if (featured) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: kPurple.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('POPULAR',
                            style: TextStyle(
                                color: kPurpleLight,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(description,
                    style: const TextStyle(
                        color: kTextMuted, fontSize: 11)),
                const SizedBox(height: 8),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 12,
                          color:
                          featured ? kPurpleLight : kTextMuted),
                      const SizedBox(width: 5),
                      Text(f,
                          style: TextStyle(
                              color: featured
                                  ? Colors.white70
                                  : kTextMuted,
                              fontSize: 11)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: TextStyle(
                      color: featured ? kGold : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const Text('/mo',
                  style: TextStyle(color: kTextMuted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}