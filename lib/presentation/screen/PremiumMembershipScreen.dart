
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vervee_app/presentation/viewmodal/pofile/ProfileViewmodels.dart';

import '../../utils/WebViewScreen.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
const _bgDeep      = Color(0xFF0A0118);
const _bgCard      = Color(0xFF150328);
const _bgBase      = Color(0xFF0F0120);
const _borderColor = Color(0xFF2D1050);
const _gold        = Color(0xFFD4AF37);
const _goldLight   = Color(0x1AD4AF37);
const _goldBorder  = Color(0x59D4AF37);
const _purple      = Color(0xFF7C3AED);
const _purpleLight = Color(0x1F7C3AED);
const _purpleMid   = Color(0xFF9333EA);
const _purpleBorder= Color(0x8C9333EA);
const _green       = Color(0xFF22C55E);
const _textMuted   = Color(0xFF888888);
const _textDim     = Color(0xFF555555);

class PremiumMembershipScreen extends ConsumerStatefulWidget {
  const PremiumMembershipScreen({super.key});

  @override
  ConsumerState<PremiumMembershipScreen> createState() =>
      _PremiumMembershipScreenState();
}

class _PremiumMembershipScreenState
    extends ConsumerState<PremiumMembershipScreen> {
  final _promoController = TextEditingController();
  String? _promoMessage;      // null = kuch nahi dikhao
  bool _promoValid = false;   // true = green, false = red

  @override
  void initState() {
    super.initState();
    // Screen open hote hi subscription status refresh karo
    Future.microtask(
          () => ref.read(subscriptionViewModelProvider.notifier).loadSubscription(),
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  // ── Checkout URL aane pe inAppWebView mein open karo ─────────────────────
  // Future<void> _launchCheckoutUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.inAppWebView);
  //
  //     // WebView se wapas aane ke baad subscription status re-fetch karo
  //     // (user ne payment ki hogi toh status update ho jayega)
  //     if (mounted) {
  //       ref
  //           .read(subscriptionViewModelProvider.notifier)
  //           .loadSubscription();
  //       ref
  //           .read(subscriptionViewModelProvider.notifier)
  //           .clearCheckoutUrl();
  //     }
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text('Could not open checkout. Please try again.'),
  //           backgroundColor: Colors.red.shade700,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10)),
  //         ),
  //       );
  //     }
  //   }
  // }

  // _launchCheckoutUrl() method ko ye se replace karo:

  // Future<void> _launchCheckoutUrl(String url) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => WebViewScreen(
  //         url: url,
  //         title: 'Checkout',
  //       ),
  //     ),
  //   );
  //
  //   // WebView close hone ke baad subscription re-fetch karo
  //   if (mounted) {
  //     ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
  //     ref.read(subscriptionViewModelProvider.notifier).clearCheckoutUrl();
  //   }
  // }

  // ── Checkout URL aane pe inAppWebView mein open karo ─────────────────────
  Future<void> _launchCheckoutUrl(String url) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          url: url,
          title: 'Checkout',
        ),
      ),
    );

    if (!mounted) return;

    // ── WebView close hone ke baad subscription re-fetch karo ──────────
    ref.read(subscriptionViewModelProvider.notifier).clearCheckoutUrl();

    // Loading indicator dikhao jab tak fetch ho
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Verifying subscription...'),
          ],
        ),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    await ref
        .read(subscriptionViewModelProvider.notifier)
        .loadSubscription();

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final sub = ref.read(subscriptionViewModelProvider).subscription;
    final hasAccess = sub != null && (sub.isActive || sub.isTrialing);

    if (hasAccess) {
      // ✅ Payment successful — screen pop karo, caller (_onVideoTap) dobara
      // subscription check karega aur VideoDetailScreen push karega
      Navigator.pop(context, true); // ← true = payment done
    } else {
      // ❌ Payment pending/failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Subscription is pending. Please complete payment to access videos.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2D1050),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ── Checkout-promo dalne pe URL aane pe inAppWebView mein open karo ─────────────────────
  Future<void> _launchPromoCheckoutUrl(String url) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebViewScreen(url: url, title: 'Checkout'),
      ),
    );

    if (!mounted) return;

    ref.read(subscriptionViewModelProvider.notifier).clearPromoCheckoutUrl();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Verifying subscription...'),
          ],
        ),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    await ref.read(subscriptionViewModelProvider.notifier).loadSubscription();

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final sub = ref.read(subscriptionViewModelProvider).subscription;
    final hasAccess = sub != null && (sub.isActive || sub.isTrialing);

    if (hasAccess) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Subscription is pending. Please complete payment to access videos.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2D1050),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionViewModelProvider);

    // ── Checkout URL aate hi launch karo ─────────────────────────────────
    ref.listen(subscriptionViewModelProvider, (prev, next) {
      if (next.checkoutUrl != null &&
          next.checkoutUrl != prev?.checkoutUrl) {
        _launchCheckoutUrl(next.checkoutUrl!);
      }
      if (next.checkoutErrorMessage != null &&
          next.checkoutErrorMessage != prev?.checkoutErrorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.checkoutErrorMessage!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        ref
            .read(subscriptionViewModelProvider.notifier)
            .clearCheckoutError();
      }

      // ── Promo checkout listeners (NEW) ─────────────────────────────────
      // if (next.promoCheckoutUrl != null &&
      //     next.promoCheckoutUrl != prev?.promoCheckoutUrl) {
      //   _launchPromoCheckoutUrl(next.promoCheckoutUrl!);
      // }
      // if (next.promoCheckoutErrorMessage != null &&
      //     next.promoCheckoutErrorMessage != prev?.promoCheckoutErrorMessage) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(next.promoCheckoutErrorMessage!),
      //     backgroundColor: Colors.red.shade700,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   ));
      //   ref.read(subscriptionViewModelProvider.notifier).clearPromoCheckoutError();
      // }
      // Promo success — WebView open karo
      if (next.promoCheckoutUrl != null &&
          next.promoCheckoutUrl != prev?.promoCheckoutUrl) {
        setState(() {
          _promoMessage = 'Promo code applied successfully!';
          _promoValid = true;
        });
        _launchPromoCheckoutUrl(next.promoCheckoutUrl!);
      }

// Promo error — red message dikhao, WebView mat kholo
      if (next.promoCheckoutErrorMessage != null &&
          next.promoCheckoutErrorMessage != prev?.promoCheckoutErrorMessage) {
        setState(() {
          _promoMessage = next.promoCheckoutErrorMessage; // "Invalid promo code" from backend
          _promoValid = false;
        });
        ref.read(subscriptionViewModelProvider.notifier).clearPromoCheckoutError();
      }
    });

    return Scaffold(
      backgroundColor: _bgBase,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroSection(),
            const SizedBox(height: 16),
            _FeaturesCard(),
            const SizedBox(height: 13),
            //_PlanCard(promoController: _promoController),
            // build() mein _PlanCard ki line replace karo:
            // _PlanCard(
            //   promoController: _promoController,
            //   isPromoLoading: subState.isPromoCheckoutLoading,
            //   onApplyPromo: () {
            //     final code = _promoController.text.trim();
            //     if (code.isEmpty) {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: const Text('Please enter a promo code.'),
            //         backgroundColor: Colors.red.shade700,
            //         behavior: SnackBarBehavior.floating,
            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //       ));
            //       return;
            //     }
            //     ref
            //         .read(subscriptionViewModelProvider.notifier)
            //         .openCheckoutWithPromo(code);
            //   },
            // ),
            _PlanCard(
              promoController: _promoController,
              isPromoLoading: subState.isPromoCheckoutLoading,
              promoMessage: _promoMessage,
              promoValid: _promoValid,

              onApplyPromo: () {
                setState(() => _promoMessage = null);
                final code = _promoController.text.trim();

                if (code.isEmpty) {
                  setState(() {
                    _promoMessage = 'Please enter a promo code.';
                    _promoValid = false;
                  });
                  return;
                }

                // ── API hi validate karegi, backend decide karega valid/invalid ──
                ref.read(subscriptionViewModelProvider.notifier).openCheckoutWithPromo(code);
              },

            ),
            const SizedBox(height: 16),
            _CtaButton(
              isLoading: subState.isCheckoutLoading,
              onTap: () {
                ref
                    .read(subscriptionViewModelProvider.notifier)
                    .openCheckout();
              },
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Cancel anytime during the 7-day trial period',
                style: TextStyle(color: _textDim, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: _bgCard,
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _borderColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _bgDeep,
                      shape: BoxShape.circle,
                      border: Border.all(color: _borderColor, width: 0.5),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: _purpleMid,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Premium Membership',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CTA Button — loading state support ──────────────────────────────────────
class _CtaButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _CtaButton({required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLoading ? _purple.withOpacity(0.6) : _purple,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Text(
          'Start Free Trial',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────
// (same as before — kuch nahi badla)
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: _goldLight,
            border: Border.all(color: _goldBorder, width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_awesome_rounded, color: _gold, size: 11),
              SizedBox(width: 5),
              Text(
                'VERVEE ACADEMY',
                style: TextStyle(
                  color: _gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _goldLight,
            border: Border.all(color: _gold, width: 1.5),
          ),
          child: const Icon(Icons.workspace_premium_rounded,
              color: _gold, size: 28),
        ),
        const SizedBox(height: 16),
        const Text(
          'PREMIUM MEMBERSHIP',
          style: TextStyle(
            color: _gold,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Unlock full access to premium courses, expert insights, and priority support',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted, fontSize: 12, height: 1.6),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _purpleLight,
            border: Border.all(color: _purpleBorder, width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('\$49.99',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              SizedBox(width: 4),
              Text('/ year',
                  style: TextStyle(color: _textMuted, fontSize: 11)),
              SizedBox(width: 6),
              Text('•', style: TextStyle(color: _textDim, fontSize: 10)),
              SizedBox(width: 6),
              Text('7-day free trial',
                  style: TextStyle(
                      color: _gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Features Card ────────────────────────────────────────────────────────────
class _FeaturesCard extends StatelessWidget {
  static const _features = [
    'Unlimited access to all premium courses',
    'Daily expert market analysis & insights',
    'In-depth Crypto market coverage',
    'Comprehensive Commodity breakdowns',
    'Weekly professional reports & summaries',
    'Investment portfolio guidance',
    'Priority customer support',
    'Enhanced account security',
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      label: "WHAT'S INCLUDED",
      child: Column(
        children: _features
            .asMap()
            .entries
            .map((e) => _FeatureItem(
          text: e.value,
          showDivider: e.key < _features.length - 1,
        ))
            .toList(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final bool showDivider;
  const _FeatureItem({required this.text, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: _green, size: 17),
              const SizedBox(width: 10),
              Expanded(
                child: Text(text,
                    style: const TextStyle(
                        color: Color(0xE0FFFFFF), fontSize: 12.5)),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
              color: Color(0x99200840), height: 0.5, thickness: 0.5),
      ],
    );
  }
}

// ─── Plan Card ────────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final TextEditingController promoController;
  final bool isPromoLoading;          // ← NEW
  final VoidCallback onApplyPromo;    // ← NEW
  final String? promoMessage;
  final bool promoValid;

  //const _PlanCard({required this.promoController});
  const _PlanCard({
    required this.promoController,
    required this.isPromoLoading,
    required this.onApplyPromo,
    this.promoMessage,
    this.promoValid = false,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      label: 'START YOUR MEMBERSHIP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Simple, transparent pricing — no hidden charges.',
              style: TextStyle(color: _textMuted, fontSize: 11.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _purpleLight,
              border: Border.all(color: _purple, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _purpleMid, width: 2),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: _purpleMid),
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text.rich(TextSpan(
                        text: 'Premium Annual Plan ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: '(7-Day Free Trial)',
                            style: TextStyle(
                                color: _textMuted,
                                fontWeight: FontWeight.w400,
                                fontSize: 11),
                          ),
                        ],
                      )),
                      SizedBox(height: 3),
                      Text('\$49.99 / Year',
                          style: TextStyle(
                              color: _gold,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Have a promo code?',
              style: TextStyle(color: _textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoController,
                  style:
                  const TextStyle(color: Colors.white, fontSize: 12.5),
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    hintStyle:
                    const TextStyle(color: _textDim, fontSize: 12.5),
                    filled: true,
                    fillColor: _bgDeep,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 11),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: _borderColor, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: _purple, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // GestureDetector(
              //   onTap: () {
              //     // TODO: apply promo
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 15, vertical: 11),
              //     decoration: BoxDecoration(
              //       color: _purpleLight,
              //       border: Border.all(color: _purple, width: 0.5),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const Text('Apply',
              //         style: TextStyle(
              //             color: _purpleMid,
              //             fontSize: 12.5,
              //             fontWeight: FontWeight.w500)),
              //   ),
              // ),
              // Sirf Apply button wala GestureDetector replace karo:
              GestureDetector(
                onTap: isPromoLoading ? null : onApplyPromo,  // ← changed
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  decoration: BoxDecoration(
                    color: isPromoLoading
                        ? _purple.withOpacity(0.4)
                        : _purpleLight,
                    border: Border.all(color: _purple, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isPromoLoading
                      ? const SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: _purpleMid,
                    ),
                  )
                      : const Text('Apply',
                      style: TextStyle(
                          color: _purpleMid,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          if (promoMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              promoMessage!,
              style: TextStyle(
                color: promoValid ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Reusable Card Wrapper ────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String label;
  final Widget child;
  const _Card({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgCard,
        border: Border.all(color: _borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: _purpleMid,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}












// import 'package:flutter/material.dart';
//
// // ─── Color Palette ───────────────────────────────────────────────────────────
// const _bgDeep = Color(0xFF0A0118);
// const _bgCard = Color(0xFF150328);
// const _bgBase = Color(0xFF0F0120);
// const _borderColor = Color(0xFF2D1050);
// const _gold = Color(0xFFD4AF37);
// const _goldLight = Color(0x1AD4AF37);
// const _goldBorder = Color(0x59D4AF37);
// const _purple = Color(0xFF7C3AED);
// const _purpleLight = Color(0x1F7C3AED);
// const _purpleMid = Color(0xFF9333EA);
// const _purpleBorder = Color(0x8C9333EA);
// const _green = Color(0xFF22C55E);
// const _textMuted = Color(0xFF888888);
// const _textDim = Color(0xFF555555);
//
// class PremiumMembershipScreen extends StatefulWidget {
//   const PremiumMembershipScreen({super.key});
//
//   @override
//   State<PremiumMembershipScreen> createState() =>
//       _PremiumMembershipScreenState();
// }
//
// class _PremiumMembershipScreenState extends State<PremiumMembershipScreen> {
//   final _promoController = TextEditingController();
//
//   @override
//   void dispose() {
//     _promoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bgBase,
//       appBar: _buildAppBar(context),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 22, 16, 32),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _HeroSection(),
//             const SizedBox(height: 16),
//             _FeaturesCard(),
//             const SizedBox(height: 13),
//             _PlanCard(promoController: _promoController),
//             const SizedBox(height: 16),
//             _CtaButton(
//               onTap: () {
//                 // TODO: trigger Stripe subscription flow
//               },
//             ),
//             const SizedBox(height: 10),
//             const Center(
//               child: Text(
//                 'Cancel anytime during the 7-day trial period',
//                 style: TextStyle(color: _textDim, fontSize: 11),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(56),
//       child: Container(
//         color: _bgCard,
//         child: SafeArea(
//           bottom: false,
//           child: Container(
//             height: 56,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: _borderColor, width: 0.5),
//               ),
//             ),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: _bgDeep,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: _borderColor, width: 0.5),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_rounded,
//                       color: _purpleMid,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Premium Membership',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Hero Section ─────────────────────────────────────────────────────────────
// class _HeroSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Vervee Academy badge
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//           decoration: BoxDecoration(
//             color: _goldLight,
//             border: Border.all(color: _goldBorder, width: 0.5),
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Icon(Icons.auto_awesome_rounded, color: _gold, size: 11),
//               SizedBox(width: 5),
//               Text(
//                 'VERVEE ACADEMY',
//                 style: TextStyle(
//                   color: _gold,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // Crown ring
//         Container(
//           width: 68,
//           height: 68,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _goldLight,
//             border: Border.all(color: _gold, width: 1.5),
//           ),
//           child: const Icon(Icons.workspace_premium_rounded,
//               color: _gold, size: 28),
//         ),
//         const SizedBox(height: 16),
//
//         // Title
//         const Text(
//           'PREMIUM MEMBERSHIP',
//           style: TextStyle(
//             color: _gold,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 2.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Subtitle
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             'Unlock full access to premium courses, expert insights, and priority support',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: _textMuted,
//               fontSize: 12,
//               height: 1.6,
//             ),
//           ),
//         ),
//         const SizedBox(height: 14),
//
//         // Price pill
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           decoration: BoxDecoration(
//             color: _purpleLight,
//             border: Border.all(color: _purpleBorder, width: 0.5),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Text(
//                 '\$29.99',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(width: 4),
//               Text(
//                 '/ year',
//                 style: TextStyle(color: _textMuted, fontSize: 11),
//               ),
//               SizedBox(width: 6),
//               Text('•', style: TextStyle(color: _textDim, fontSize: 10)),
//               SizedBox(width: 6),
//               Text(
//                 '7-day free trial',
//                 style: TextStyle(
//                   color: _gold,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─── Features Card ────────────────────────────────────────────────────────────
// class _FeaturesCard extends StatelessWidget {
//   static const _features = [
//     'Unlimited access to all premium courses',
//     'Daily expert market analysis & insights',
//     'In-depth Crypto market coverage',
//     'Comprehensive Commodity breakdowns',
//     'Weekly professional reports & summaries',
//     'Investment portfolio guidance',
//     'Priority customer support',
//     'Enhanced account security',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       label: "WHAT'S INCLUDED",
//       child: Column(
//         children: _features
//             .asMap()
//             .entries
//             .map((e) => _FeatureItem(
//           text: e.value,
//           showDivider: e.key < _features.length - 1,
//         ))
//             .toList(),
//       ),
//     );
//   }
// }
//
// class _FeatureItem extends StatelessWidget {
//   final String text;
//   final bool showDivider;
//
//   const _FeatureItem({required this.text, required this.showDivider});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 7),
//           child: Row(
//             children: [
//               const Icon(Icons.check_circle_rounded, color: _green, size: 17),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   text,
//                   style: const TextStyle(
//                     color: Color(0xE0FFFFFF),
//                     fontSize: 12.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (showDivider)
//           const Divider(
//             color: Color(0x99200840),
//             height: 0.5,
//             thickness: 0.5,
//           ),
//       ],
//     );
//   }
// }
//
// // ─── Plan Card ────────────────────────────────────────────────────────────────
// class _PlanCard extends StatelessWidget {
//   final TextEditingController promoController;
//
//   const _PlanCard({required this.promoController});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       label: 'START YOUR MEMBERSHIP',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Simple, transparent pricing — no hidden charges.',
//             style: TextStyle(color: _textMuted, fontSize: 11.5),
//           ),
//           const SizedBox(height: 12),
//
//           // Selected plan row
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: _purpleLight,
//               border: Border.all(color: _purple, width: 1.5),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 // Radio
//                 Container(
//                   width: 18,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: _purpleMid, width: 2),
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _purpleMid,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 13),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text.rich(
//                         TextSpan(
//                           text: 'Premium Annual Plan ',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: '(7-Day Free Trial)',
//                               style: TextStyle(
//                                 color: _textMuted,
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 3),
//                       Text(
//                         '\$29.99 / Year',
//                         style: TextStyle(
//                           color: _gold,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 14),
//
//           // Promo code
//           const Text(
//             'Have a promo code?',
//             style: TextStyle(color: _textMuted, fontSize: 12),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: promoController,
//                   style: const TextStyle(color: Colors.white, fontSize: 12.5),
//                   decoration: InputDecoration(
//                     hintText: 'Enter promo code',
//                     hintStyle:
//                     const TextStyle(color: _textDim, fontSize: 12.5),
//                     filled: true,
//                     fillColor: _bgDeep,
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 11),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                       const BorderSide(color: _borderColor, width: 0.5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                       const BorderSide(color: _purple, width: 1),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   // TODO: apply promo
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15, vertical: 11),
//                   decoration: BoxDecoration(
//                     color: _purpleLight,
//                     border: Border.all(color: _purple, width: 0.5),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Text(
//                     'Apply',
//                     style: TextStyle(
//                       color: _purpleMid,
//                       fontSize: 12.5,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─── CTA Button ───────────────────────────────────────────────────────────────
// class _CtaButton extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const _CtaButton({required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: _purple,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         alignment: Alignment.center,
//         child: const Text(
//           'Start Free Trial',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 0.4,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Reusable Card Wrapper ────────────────────────────────────────────────────
// class _Card extends StatelessWidget {
//   final String label;
//   final Widget child;
//
//   const _Card({required this.label, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _bgCard,
//         border: Border.all(color: _borderColor, width: 0.5),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: _purpleMid,
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.8,
//             ),
//           ),
//           const SizedBox(height: 14),
//           child,
//         ],
//       ),
//     );
//   }
// }