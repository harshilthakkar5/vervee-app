


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import '../../domain/model/affiliate/AffiliateInfo.dart';
import '../../domain/model/promo_code/AffiliateInfo.dart';
import '../../utils/NetworkResult.dart';
import '../viewmodal/promo_code/AffiliateViewModel.dart';
//import '../viewmodal/affiliate/AffiliateViewModel.dart';

/// ------------------------------------------------------------
/// Vervee Academy - Partner Promo Code Screen (Mobile UI)
/// API: GET /affiliate/me  →  AffiliateViewModel  →  ye screen
/// ------------------------------------------------------------

class VerveeColors {
  static const bgTop = Color(0xFF1B0B3F);
  static const bgBottom = Color(0xFF10052B);
  static const card = Color(0xFF2E1763);
  static const cardLight = Color(0xFF3B2080);
  static const border = Color(0x33FFFFFF);
  static const gold = Color(0xFFF6C945);
  static const goldDark = Color(0xFFD9A81E);
  static const green = Color(0xFF2ED47A);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB9A9E3);
}

// ✅ CHANGE 1: StatefulWidget → ConsumerStatefulWidget
class PartnerPromoCodeScreen extends ConsumerStatefulWidget {
  const PartnerPromoCodeScreen({super.key});

  @override
  ConsumerState<PartnerPromoCodeScreen> createState() =>
      _PartnerPromoCodeScreenState();
}

// ✅ CHANGE 2: State → ConsumerState
class _PartnerPromoCodeScreenState
    extends ConsumerState<PartnerPromoCodeScreen> {
  static const String _registerBaseUrl =
      'https://app.theverveeacademy.com/register?promo=';

  final _searchController = TextEditingController();
  String _query = '';
  bool _codeCopied = false;
  bool _linkCopied = false;

  @override
  void initState() {
    super.initState();
    // ✅ CHANGE 3: screen open hote hi API call
    Future.microtask(
          () => ref.read(affiliateViewModelProvider.notifier).fetchAffiliate(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _copy(String text, {required bool isLink}) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    setState(() => isLink ? _linkCopied = true : _codeCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => isLink ? _linkCopied = false : _codeCopied = false);
    });
  }

  // Pull-to-refresh → silent refresh (list screen pe bani rehti he)
  Future<void> _refresh() {
    return ref
        .read(affiliateViewModelProvider.notifier)
        .fetchAffiliate(silent: true);
  }

  void _retry() {
    ref.read(affiliateViewModelProvider.notifier).fetchAffiliate();
  }

  List<ReferredUser> _filtered(List<ReferredUser> users) {
    if (_query.isEmpty) return users;
    final q = _query.toLowerCase();
    return users
        .where((u) =>
    u.name.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ CHANGE 4: ViewModel state watch karo
    final state = ref.watch(affiliateViewModelProvider);

    return Scaffold(
      backgroundColor: VerveeColors.bgBottom,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VerveeColors.bgTop, VerveeColors.bgBottom],
          ),
        ),
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            color: VerveeColors.gold,
            backgroundColor: VerveeColors.card,
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: _buildBody(state),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ CHANGE 5: state ke hisab se UI (loading / error / success)
  List<Widget> _buildBody(NetworkResult<AffiliateInfo> state) {
    if (state is Success<AffiliateInfo>) {
      final info = state.data;

      if (!info.isAffiliate || info.referralCode.isEmpty) {
        return [_buildNotAffiliateState()];
      }

      final code = info.referralCode;
      final link = '$_registerBaseUrl$code';

      return [
        _buildPromoCodeCard(code),
        const SizedBox(height: 14),
        _buildReferralLinkCard(link),
        const SizedBox(height: 14),
        _buildStatsRow(info),
        const SizedBox(height: 20),
        _buildReferredUsers(info.referredUsers),
      ];
    }

    if (state case Error(:final message)) {
      return [_buildErrorState(message)];
    }

    // initial / loading
    return [
      const Padding(
        padding: EdgeInsets.only(top: 120),
        child: Center(
          child: CircularProgressIndicator(color: VerveeColors.gold),
        ),
      ),
    ];
  }

  // ---------------------------------------------------------------
  // App bar
  // ---------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VerveeColors.bgTop,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leadingWidth: 48,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: RichText(
        text: const TextSpan(
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
          children: [
            TextSpan(
                text: 'PARTNER ', style: TextStyle(color: Color(0xFF8E5BFF))),
            TextSpan(
                text: 'PROMO CODE', style: TextStyle(color: VerveeColors.gold)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Promo code card
  // ---------------------------------------------------------------
  Widget _buildPromoCodeCard(String promoCode) {
    return _GlassCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A2894), Color(0xFF2E1763)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
              icon: Icons.local_activity_rounded, title: 'YOUR PROMO CODE'),
          const SizedBox(height: 6),
          const Text('Share this code with new users during registration.',
              style: TextStyle(color: VerveeColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: VerveeColors.gold.withOpacity(0.5), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      promoCode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: VerveeColors.gold,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _GoldButton(
                  label: _codeCopied ? 'Copied' : 'Copy',
                  icon: _codeCopied ? Icons.check_rounded : Icons.copy_rounded,
                  onTap: () => _copy(promoCode, isLink: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Referral link card
  // ---------------------------------------------------------------
  Widget _buildReferralLinkCard(String referralLink) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  child: _CardTitle(
                      icon: Icons.link_rounded, title: 'DIRECT REFERRAL LINK')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: VerveeColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: VerveeColors.green.withOpacity(0.5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: 12, color: VerveeColors.green),
                    SizedBox(width: 4),
                    Text('Auto-Applies',
                        style: TextStyle(
                            color: VerveeColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
              'Anyone opening this link will have your promo code automatically applied on sign up.',
              style: TextStyle(color: VerveeColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.28),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: VerveeColors.border),
            ),
            child: Text(
              referralLink,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'monospace',
                  color: VerveeColors.textSecondary,
                  fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _GoldButton(
              expanded: true,
              label: _linkCopied ? 'Link Copied' : 'Copy Link',
              icon: _linkCopied ? Icons.check_rounded : Icons.copy_rounded,
              onTap: () => _copy(referralLink, isLink: true),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------
  Widget _buildStatsRow(AffiliateInfo info) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.groups_rounded,
            label: 'Total\nNetwork',
            value: info.referredUsers.length,
            color: VerveeColors.gold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.verified_rounded,
            label: 'Active\nMembers',
            value: info.activeCount,
            color: VerveeColors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule_rounded,
            label: 'Pending\nVerification',
            value: info.pendingCount,
            color: const Color(0xFFFFA94D),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // Referred users
  // ---------------------------------------------------------------
  Widget _buildReferredUsers(List<ReferredUser> users) {
    final list = _filtered(users);
    return _GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: VerveeColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.people_alt_rounded,
                    color: VerveeColors.gold, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Referred Users (${users.length})',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const Text('Signed up using your code or link',
                        style: TextStyle(
                            color: VerveeColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.trim()),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            cursorColor: VerveeColors.gold,
            decoration: InputDecoration(
              hintText: 'Search name or email...',
              hintStyle: const TextStyle(color: VerveeColors.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: VerveeColors.textSecondary),
              filled: true,
              fillColor: Colors.black.withOpacity(0.25),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: VerveeColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: VerveeColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (list.isEmpty)
            _buildEmptyState(isSearching: _query.isNotEmpty)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _UserTile(user: list[i]),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({bool isSearching = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VerveeColors.cardLight.withOpacity(0.6),
                border: Border.all(color: VerveeColors.border),
              ),
              child: Icon(
                  isSearching
                      ? Icons.search_off_rounded
                      : Icons.person_add_alt_1_rounded,
                  color: VerveeColors.gold,
                  size: 32),
            ),
            const SizedBox(height: 14),
            Text(isSearching ? 'No matching users' : 'No users have joined yet',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                isSearching
                    ? 'Try a different name or email.'
                    : 'Share your promo code or referral link above to see your referred users here.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: VerveeColors.textSecondary, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Error / not-affiliate states
  // ---------------------------------------------------------------
  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: _GlassCard(
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFFF6B6B), size: 44),
            const SizedBox(height: 12),
            const Text('Could not load your promo code',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: VerveeColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            _GoldButton(
              label: 'Retry',
              icon: Icons.refresh_rounded,
              onTap: _retry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotAffiliateState() {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: _GlassCard(
        child: Column(
          children: [
            Icon(Icons.lock_outline_rounded,
                color: VerveeColors.gold, size: 44),
            SizedBox(height: 12),
            Text('Partner access not active',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text(
              'Your account is not a partner yet, so no promo code is available.',
              textAlign: TextAlign.center,
              style: TextStyle(color: VerveeColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// Reusable widgets
// =================================================================

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsets padding;

  const _GlassCard({
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? VerveeColors.card : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: VerveeColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CardTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: VerveeColors.gold, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8)),
        ),
      ],
    );
  }
}

class _GoldButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool expanded;

  const _GoldButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFFDB6E), VerveeColors.goldDark]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: VerveeColors.gold.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(icon,
                    key: ValueKey(icon),
                    size: 18,
                    color: const Color(0xFF2A1160)),
              ),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF2A1160),
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VerveeColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: VerveeColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 600),
            builder: (_, v, __) => Text('$v',
                style: TextStyle(
                    color: color, fontSize: 26, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: VerveeColors.textSecondary,
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final ReferredUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == ReferralStatus.active;
    final color = isActive ? VerveeColors.green : const Color(0xFFFFA94D);
    final d = user.joinedAt;
    final date = '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VerveeColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: VerveeColors.cardLight,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: VerveeColors.gold, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text(user.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: VerveeColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 2),
                Text('Joined $date',
                    style: const TextStyle(
                        color: VerveeColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(isActive ? 'Active' : 'Pending',
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
































// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// /// ------------------------------------------------------------
// /// Vervee Academy - Partner Promo Code Screen (Mobile UI)
// /// Sirf Flutter SDK use hua hai, koi extra package nahi chahiye.
// /// Baad me ise Riverpod + Freezed model se connect kar sakte ho.
// /// ------------------------------------------------------------
//
// class VerveeColors {
//   static const bgTop = Color(0xFF1B0B3F);
//   static const bgBottom = Color(0xFF10052B);
//   static const card = Color(0xFF2E1763);
//   static const cardLight = Color(0xFF3B2080);
//   static const border = Color(0x33FFFFFF);
//   static const gold = Color(0xFFF6C945);
//   static const goldDark = Color(0xFFD9A81E);
//   static const green = Color(0xFF2ED47A);
//   static const textPrimary = Colors.white;
//   static const textSecondary = Color(0xFFB9A9E3);
// }
//
// enum ReferralStatus { active, pending }
//
// class ReferredUser {
//   final String name;
//   final String email;
//   final DateTime joinedAt;
//   final ReferralStatus status;
//
//   const ReferredUser({
//     required this.name,
//     required this.email,
//     required this.joinedAt,
//     required this.status,
//   });
// }
//
// class PartnerPromoCodeScreen extends StatefulWidget {
//   const PartnerPromoCodeScreen({super.key});
//
//   @override
//   State<PartnerPromoCodeScreen> createState() => _PartnerPromoCodeScreenState();
// }
//
// class _PartnerPromoCodeScreenState extends State<PartnerPromoCodeScreen> {
//   static const String _promoCode = 'REF-215-C02131';
//   static const String _referralLink =
//       'https://app.theverveeacademy.com/register?promo=$_promoCode';
//
//   final _searchController = TextEditingController();
//   String _query = '';
//   bool _codeCopied = false;
//   bool _linkCopied = false;
//   bool _refreshing = false;
//
//   // API se aane wala data yahan aayega. Demo ke liye khali / sample.
//   List<ReferredUser> _users = const [];
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _copy(String text, {required bool isLink}) async {
//     await Clipboard.setData(ClipboardData(text: text));
//     HapticFeedback.lightImpact();
//     setState(() => isLink ? _linkCopied = true : _codeCopied = true);
//     Future.delayed(const Duration(seconds: 2), () {
//       if (!mounted) return;
//       setState(() => isLink ? _linkCopied = false : _codeCopied = false);
//     });
//   }
//
//   Future<void> _refresh() async {
//     setState(() => _refreshing = true);
//     await Future.delayed(const Duration(seconds: 1)); // API call yahan
//     if (!mounted) return;
//     setState(() => _refreshing = false);
//   }
//
//   List<ReferredUser> get _filtered {
//     if (_query.isEmpty) return _users;
//     final q = _query.toLowerCase();
//     return _users
//         .where((u) =>
//     u.name.toLowerCase().contains(q) ||
//         u.email.toLowerCase().contains(q))
//         .toList();
//   }
//
//   int get _active =>
//       _users.where((u) => u.status == ReferralStatus.active).length;
//   int get _pending =>
//       _users.where((u) => u.status == ReferralStatus.pending).length;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: VerveeColors.bgBottom,
//       appBar: _buildAppBar(),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [VerveeColors.bgTop, VerveeColors.bgBottom],
//           ),
//         ),
//         child: SafeArea(
//           top: false,
//           child: RefreshIndicator(
//             color: VerveeColors.gold,
//             backgroundColor: VerveeColors.card,
//             onRefresh: _refresh,
//             child: ListView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
//               children: [
//                 // _buildHeader(),
//                 // const SizedBox(height: 20),
//                 _buildPromoCodeCard(),
//                 const SizedBox(height: 14),
//                 _buildReferralLinkCard(),
//                 const SizedBox(height: 14),
//                 _buildStatsRow(),
//                 const SizedBox(height: 20),
//                 _buildReferredUsers(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------
//   // App bar
//   // ---------------------------------------------------------------
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: VerveeColors.bgTop,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       centerTitle: false,
//       titleSpacing: 0,
//       leadingWidth: 48,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded,
//             color: Colors.white, size: 20),
//         onPressed: () => Navigator.maybePop(context),
//       ),
//       title: RichText(
//         text: const TextSpan(
//           style: TextStyle(
//               fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
//           children: [
//             TextSpan(text: 'PARTNER ', style: TextStyle(color: Color(0xFF8E5BFF))), // Partner
//             TextSpan(text: 'PROMO CODE', style: TextStyle(color: VerveeColors.gold)), // Promo Code
//           ],
//         ),
//       ),
//     );
//   }
//
//   // actions: [
//   //   Container(
//   //     margin: const EdgeInsets.only(right: 12),
//   //     padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
//   //     decoration: BoxDecoration(
//   //       color: Colors.black.withOpacity(0.25),
//   //       borderRadius: BorderRadius.circular(30),
//   //       border: Border.all(color: VerveeColors.gold.withOpacity(0.6)),
//   //     ),
//   //     child: Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       // children: const [
//   //       //   CircleAvatar(
//   //       //     radius: 11,
//   //       //     backgroundColor: VerveeColors.gold,
//   //       //     child: Text('V',
//   //       //         style: TextStyle(
//   //       //             color: Color(0xFF2A1160),
//   //       //             fontWeight: FontWeight.w900,
//   //       //             fontSize: 12)),
//   //       //   ),
//   //       //   SizedBox(width: 6),
//   //       //   Text('285',
//   //       //       style: TextStyle(
//   //       //           color: VerveeColors.gold,
//   //       //           fontWeight: FontWeight.w800,
//   //       //           fontSize: 14)),
//   //       // ],
//   //     ),
//   //   ),
//   // ],
//
//   // ---------------------------------------------------------------
//   // Header
//   // ---------------------------------------------------------------
//   // Widget _buildHeader() {
//   //   return Row(
//   //     children: [
//   //       Container(
//   //         height: 52,
//   //         width: 52,
//   //         decoration: BoxDecoration(
//   //           gradient: const LinearGradient(
//   //               colors: [VerveeColors.gold, VerveeColors.goldDark]),
//   //           borderRadius: BorderRadius.circular(16),
//   //           boxShadow: [
//   //             BoxShadow(
//   //                 color: VerveeColors.gold.withOpacity(0.35),
//   //                 blurRadius: 16,
//   //                 offset: const Offset(0, 6))
//   //           ],
//   //         ),
//   //         child: const Icon(Icons.confirmation_number_rounded,
//   //             color: Color(0xFF2A1160), size: 28),
//   //       ),
//   //       const SizedBox(width: 14),
//   //       const Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Partner Promo Code',
//   //                 style: TextStyle(
//   //                     color: Colors.white,
//   //                     fontSize: 22,
//   //                     fontWeight: FontWeight.w800)),
//   //             SizedBox(height: 2),
//   //             Text('Share your code & grow your network',
//   //                 style: TextStyle(
//   //                     color: VerveeColors.textSecondary, fontSize: 13)),
//   //           ],
//   //         ),
//   //       ),
//   //       InkWell(
//   //         onTap: _refreshing ? null : _refresh,
//   //         borderRadius: BorderRadius.circular(14),
//   //         child: Container(
//   //           padding: const EdgeInsets.all(10),
//   //           decoration: BoxDecoration(
//   //             color: VerveeColors.card,
//   //             borderRadius: BorderRadius.circular(14),
//   //             border: Border.all(color: VerveeColors.border),
//   //           ),
//   //           child: _refreshing
//   //               ? const SizedBox(
//   //               height: 20,
//   //               width: 20,
//   //               child: CircularProgressIndicator(
//   //                   strokeWidth: 2, color: VerveeColors.gold))
//   //               : const Icon(Icons.refresh_rounded,
//   //               color: VerveeColors.gold, size: 20),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   // ---------------------------------------------------------------
//   // Promo code card
//   // ---------------------------------------------------------------
//   Widget _buildPromoCodeCard() {
//     return _GlassCard(
//       gradient: const LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [Color(0xFF4A2894), Color(0xFF2E1763)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const _CardTitle(
//               icon: Icons.local_activity_rounded, title: 'YOUR PROMO CODE'),
//           const SizedBox(height: 6),
//           const Text('Share this code with new users during registration.',
//               style: TextStyle(color: VerveeColors.textSecondary, fontSize: 13)),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                   color: VerveeColors.gold.withOpacity(0.5), width: 1.2),
//             ),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: FittedBox(
//                     alignment: Alignment.centerLeft,
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       _promoCode,
//                       style: TextStyle(
//                         fontFamily: 'monospace',
//                         color: VerveeColors.gold,
//                         fontSize: 22,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 _GoldButton(
//                   label: _codeCopied ? 'Copied' : 'Copy',
//                   icon: _codeCopied ? Icons.check_rounded : Icons.copy_rounded,
//                   onTap: () => _copy(_promoCode, isLink: false),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------
//   // Referral link card
//   // ---------------------------------------------------------------
//   Widget _buildReferralLinkCard() {
//     return _GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Expanded(
//                   child: _CardTitle(
//                       icon: Icons.link_rounded, title: 'DIRECT REFERRAL LINK')),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: VerveeColors.green.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(8),
//                   border:
//                   Border.all(color: VerveeColors.green.withOpacity(0.5)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(Icons.check_circle_outline_rounded,
//                         size: 12, color: VerveeColors.green),
//                     SizedBox(width: 4),
//                     Text('Auto-Applies',
//                         style: TextStyle(
//                             color: VerveeColors.green,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           const Text(
//               'Anyone opening this link will have your promo code automatically applied on sign up.',
//               style: TextStyle(color: VerveeColors.textSecondary, fontSize: 13)),
//           const SizedBox(height: 14),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.28),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: VerveeColors.border),
//             ),
//             child: const Text(
//               _referralLink,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   fontFamily: 'monospace',
//                   color: VerveeColors.textSecondary,
//                   fontSize: 12),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: _GoldButton(
//               expanded: true,
//               label: _linkCopied ? 'Link Copied' : 'Copy Link',
//               icon: _linkCopied ? Icons.check_rounded : Icons.copy_rounded,
//               onTap: () => _copy(_referralLink, isLink: true),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------
//   // Stats
//   // ---------------------------------------------------------------
//   Widget _buildStatsRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatCard(
//             icon: Icons.groups_rounded,
//             label: 'Total\nNetwork',
//             value: _users.length,
//             color: VerveeColors.gold,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _StatCard(
//             icon: Icons.verified_rounded,
//             label: 'Active\nMembers',
//             value: _active,
//             color: VerveeColors.green,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _StatCard(
//             icon: Icons.schedule_rounded,
//             label: 'Pending\nVerification',
//             value: _pending,
//             color: const Color(0xFFFFA94D),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ---------------------------------------------------------------
//   // Referred users
//   // ---------------------------------------------------------------
//   Widget _buildReferredUsers() {
//     final list = _filtered;
//     return _GlassCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: VerveeColors.gold.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.people_alt_rounded,
//                     color: VerveeColors.gold, size: 20),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Referred Users (${_users.length})',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700)),
//                     const Text('Signed up using your code or link',
//                         style: TextStyle(
//                             color: VerveeColors.textSecondary, fontSize: 12)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           TextField(
//             controller: _searchController,
//             onChanged: (v) => setState(() => _query = v.trim()),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//             cursorColor: VerveeColors.gold,
//             decoration: InputDecoration(
//               hintText: 'Search name or email...',
//               hintStyle: const TextStyle(color: VerveeColors.textSecondary),
//               prefixIcon: const Icon(Icons.search_rounded,
//                   color: VerveeColors.textSecondary),
//               filled: true,
//               fillColor: Colors.black.withOpacity(0.25),
//               contentPadding: const EdgeInsets.symmetric(vertical: 12),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: VerveeColors.border),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: VerveeColors.gold),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           if (list.isEmpty)
//             _buildEmptyState()
//           else
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: list.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (_, i) => _UserTile(user: list[i]),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 28),
//       child: Center(
//         child: Column(
//           children: [
//             Container(
//               height: 72,
//               width: 72,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: VerveeColors.cardLight.withOpacity(0.6),
//                 border: Border.all(color: VerveeColors.border),
//               ),
//               child: const Icon(Icons.person_add_alt_1_rounded,
//                   color: VerveeColors.gold, size: 32),
//             ),
//             const SizedBox(height: 14),
//             const Text('No users have joined yet',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700)),
//             const SizedBox(height: 6),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 'Share your promo code or referral link above to see your referred users here.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: VerveeColors.textSecondary, fontSize: 13, height: 1.4),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // =================================================================
// // Reusable widgets
// // =================================================================
//
// class _GlassCard extends StatelessWidget {
//   final Widget child;
//   final Gradient? gradient;
//   final EdgeInsets padding;
//
//   const _GlassCard({
//     required this.child,
//     this.gradient,
//     this.padding = const EdgeInsets.all(18),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: padding,
//       decoration: BoxDecoration(
//         color: gradient == null ? VerveeColors.card : null,
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: VerveeColors.border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.25),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
//
// class _CardTitle extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   const _CardTitle({required this.icon, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: VerveeColors.gold, size: 18),
//         const SizedBox(width: 8),
//         Flexible(
//           child: Text(title,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.8)),
//         ),
//       ],
//     );
//   }
// }
//
// class _GoldButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool expanded;
//
//   const _GoldButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//     this.expanded = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(14),
//         child: Ink(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//                 colors: [Color(0xFFFFDB6E), VerveeColors.goldDark]),
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                   color: VerveeColors.gold.withOpacity(0.35),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: Icon(icon,
//                     key: ValueKey(icon),
//                     size: 18,
//                     color: const Color(0xFF2A1160)),
//               ),
//               const SizedBox(width: 8),
//               Text(label,
//                   style: const TextStyle(
//                       color: Color(0xFF2A1160),
//                       fontWeight: FontWeight.w800,
//                       fontSize: 14)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final int value;
//   final Color color;
//
//   const _StatCard({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: VerveeColors.card,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: VerveeColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(7),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 18),
//           ),
//           const SizedBox(height: 12),
//           TweenAnimationBuilder<int>(
//             tween: IntTween(begin: 0, end: value),
//             duration: const Duration(milliseconds: 600),
//             builder: (_, v, __) => Text('$v',
//                 style: TextStyle(
//                     color: color, fontSize: 26, fontWeight: FontWeight.w900)),
//           ),
//           const SizedBox(height: 4),
//           Text(label,
//               style: const TextStyle(
//                   color: VerveeColors.textSecondary,
//                   fontSize: 11,
//                   height: 1.25,
//                   fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
//
// class _UserTile extends StatelessWidget {
//   final ReferredUser user;
//   const _UserTile({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     final isActive = user.status == ReferralStatus.active;
//     final color = isActive ? VerveeColors.green : const Color(0xFFFFA94D);
//     final d = user.joinedAt;
//     final date = '${d.day.toString().padLeft(2, '0')}/'
//         '${d.month.toString().padLeft(2, '0')}/${d.year}';
//
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: VerveeColors.border),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: VerveeColors.cardLight,
//             child: Text(
//               user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
//               style: const TextStyle(
//                   color: VerveeColors.gold, fontWeight: FontWeight.w800),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14)),
//                 Text(user.email,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         color: VerveeColors.textSecondary, fontSize: 12)),
//                 const SizedBox(height: 2),
//                 Text('Joined $date',
//                     style: const TextStyle(
//                         color: VerveeColors.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: color.withOpacity(0.5)),
//             ),
//             child: Text(isActive ? 'Active' : 'Pending',
//                 style: TextStyle(
//                     color: color, fontSize: 11, fontWeight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//   }
// }