
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
import 'package:vervee_app/presentation/screen/VerveeUniverseItemScreen.dart';

import '../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';
import '../viewmodal/VerveeUniverse/VerveeUniverseViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../widgets/Common_Widgets/SharedBottomNav.dart';
import '../widgets/Common_Widgets/VerveeTopBar.dart';
import 'PremiumMembershipScreen.dart';
import 'VideoDetailScreen.dart';

// ── Colors ────────────────────────────────────────────────────────────────────
const kBgDark      = Color(0xFF0F0120);
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kGoldLight   = Color(0xFFFFD700);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);

// ── Fallback gradients ────────────────────────────────────────────────────────
final List<LinearGradient> _fallbackGradients = [
  const LinearGradient(colors: [Color(0xFF1a0535), Color(0xFF3d1a6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  const LinearGradient(colors: [Color(0xFF0a1535), Color(0xFF1a3d6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  const LinearGradient(colors: [Color(0xFF1a350a), Color(0xFF3d6e1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  const LinearGradient(colors: [Color(0xFF35200a), Color(0xFF6e4a1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  const LinearGradient(colors: [Color(0xFF350a0a), Color(0xFF6e1a1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  const LinearGradient(colors: [Color(0xFF0a3535), Color(0xFF1a6e6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
];

LinearGradient gradientForIndex(int index) =>
    _fallbackGradients[index % _fallbackGradients.length];

// ═══════════════════════════════════════════════════════════════════════════════
//  FINANCIAL LITERACY SCREEN  — ab /vervee-universe se data leta he
//
//  `embedded` — jab true ho (star menu se open kiya gaya) toh screen sirf
//  simple title + back button dikhata hai — VerveeTopBar aur SharedBottomNav
//  dono hide ho jaate hai, taaki ye ek standalone/simple screen jaisa lage.
// ═══════════════════════════════════════════════════════════════════════════════
class VerveeUniverseScreen extends ConsumerStatefulWidget {
  const VerveeUniverseScreen({super.key, this.embedded = false});

  /// True jab is screen ko star-menu (ya kisi aur simple entry point) se
  /// open kiya gaya ho — us case me full app chrome (top bar / bottom nav)
  /// nahi dikhana, sirf ek simple app bar (title + back).
  final bool embedded;

  @override
  ConsumerState<VerveeUniverseScreen> createState() =>
      _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState
    extends ConsumerState<VerveeUniverseScreen> {

  // ── Tap pe loading indicator dikhane ke liye ──────────────────────────────
  bool _isTapLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    Future.microtask(() {
      // ✅ Vervee Universe items load karo — GET /vervee-universe
      ref.read(verveeUniverseViewModelProvider.notifier).loadItems();

      // Subscription bhi yahan load karo agar abhi load nahi hui
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.subscription == null && !subState.isLoading) {
        ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }
    });
  }

  // ── Item tap — subscription check with loading wait ───────────────────────
  void _onItemTap(BuildContext context, VerveeUniverseItem item, int index) async {
    if (_isTapLoading) return;

    setState(() => _isTapLoading = true);

    try {
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.isLoading) {
        int waited = 0;
        while (ref.read(subscriptionViewModelProvider).isLoading && waited < 30) {
          await Future.delayed(const Duration(milliseconds: 100));
          waited++;
        }
      }

      if (ref.read(subscriptionViewModelProvider).subscription == null &&
          !ref.read(subscriptionViewModelProvider).isLoading) {
        await ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }

      if (!mounted) return;

      final sub = ref.read(subscriptionViewModelProvider).subscription;
      final hasAccess = sub != null && (sub.isActive || sub.isTrialing);

      if (hasAccess) {
        _goToDetail(context, item, index);
      } else {
        final paid = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
        );
        if (paid == true && mounted) {
          _goToDetail(context, item, index);
        }
      }
    } finally {
      if (mounted) setState(() => _isTapLoading = false);
    }
  }

  void _goToDetail(BuildContext context, VerveeUniverseItem item, int index) {
    final items = ref.read(verveeUniverseViewModelProvider).items;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerveeUniverseItemScreen(
          course: item,
          courseIndex: index,
          allCourses: items,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: widget.embedded ? _buildSimpleAppBar(context) : null,
      body: Stack(
        children: [
          Column(
            children: [
              if (!widget.embedded)
                VerveeTopBar(
                  onProfile: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
              Expanded(child: _buildBody()),
            ],
          ),

          // Tap loading overlay (subscription check ke dauran)
          if (_isTapLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(
                  color: kGold,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: widget.embedded
          ? null
          : SharedBottomNav(currentIndex: 1, popOnHome: true),
    );
  }

  // ── Simple app bar — sirf title + back button (embedded mode) ─────────────
  PreferredSizeWidget _buildSimpleAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBgDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 54,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kBgDeep,
              border: Border.all(color: kBorder, width: 0.5),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kGold,
              size: 15,
            ),
          ),
        ),
      ),
      title: const Text(
        'VERVEE UNIVERSE',
        style: TextStyle(
          color: kTextPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBody() {
    final state = ref.watch(verveeUniverseViewModelProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Center(
              // child: Text(
              //   'VERVEE UNIVERSE',
              //   style: TextStyle(
              //     color: kTextPrimary,
              //     fontSize: 14,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
            ),
          ),
          _buildDisclaimer(),
          const SizedBox(height: 14),

          if (state.isLoading)
            _buildShimmerGrid()
          else if (state.errorMessage != null)
            _buildError(state.errorMessage!)
          else if (state.items.isEmpty)
              _buildEmpty()
            else
              _buildItemGrid(state.items),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Item Grid ──────────────────────────────────────────────────────────────
  Widget _buildItemGrid(List<VerveeUniverseItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95, // ✅ thoda adjust — web design jaisa compact card
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _CourseCard(
            course: item,
            fallbackGradient: gradientForIndex(index),
            onTap: () => _goToDetail(context, item, index),
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,//0.95,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => _CardSkeleton(),
      ),
    );
  }

  // Widget _buildItemGrid(List<VerveeUniverseItem> items) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: GridView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 10,
  //         mainAxisSpacing: 10,
  //         childAspectRatio: 0.88,
  //       ),
  //       itemCount: items.length,
  //       itemBuilder: (context, index) {
  //         final item = items[index];
  //         return _CourseCard(
  //           course: item,
  //           fallbackGradient: gradientForIndex(index),
  //           onTap: () => _goToDetail(context, item, index), //_onItemTap(context, item, index),
  //         );
  //       },
  //     ),
  //   );
  // }

  // ── Shimmer grid ───────────────────────────────────────────────────────────
  // Widget _buildShimmerGrid() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: GridView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 10,
  //         mainAxisSpacing: 10,
  //         childAspectRatio: 0.88,
  //       ),
  //       itemCount: 6,
  //       itemBuilder: (_, __) => _CardSkeleton(),
  //     ),
  //   );
  // }

  // ── Error ──────────────────────────────────────────────────────────────────
  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
        const SizedBox(height: 12),
        Text(message,
            style: const TextStyle(color: kTextMuted, fontSize: 13),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => ref
              .read(verveeUniverseViewModelProvider.notifier)
              .loadItems(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: kPurple, borderRadius: BorderRadius.circular(8)),
            child: const Text('Retry',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  // ── Empty ──────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(children: [
        Icon(Icons.video_library_outlined, color: kTextMuted, size: 48),
        SizedBox(height: 12),
        Text('No courses available',
            style: TextStyle(color: kTextMuted, fontSize: 13)),
      ]),
    );
  }

  // ── Disclaimer ─────────────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.info_outline_rounded, color: kGold, size: 13),
          const SizedBox(width: 5),
          const Text('Disclaimer',
              style: TextStyle(
                  color: kGold, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 4),
        const Text(
          'These Vervee Universe contents are provided solely for educational purposes. Vervee Academy does not offer any trading or investment advice, and nothing in this content should be interpreted as such. Any trading or investment decisions made based on this material are entirely at your own discretion and risk. Vervee Academy bears no responsibility for any financial profits or losses incurred',
          textAlign: TextAlign.center,
          style: TextStyle(color: kTextMuted, fontSize: 10, height: 1.6),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  COURSE CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _CourseCard extends StatelessWidget {
  final VerveeUniverseItem course;
  final LinearGradient fallbackGradient;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.fallbackGradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed-height image area (16:9 jaisa) — image poori fill karegi, cover se ──
            // AspectRatio(
            //   aspectRatio: 16 / 9, // ✅ web design jaisa thumbnail ratio
            //   child: Stack(
            //     fit: StackFit.expand,
            //     children: [
            //       if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
            //         CachedNetworkImage(
            //           imageUrl: course.thumbnail!,
            //           fit: BoxFit.cover, // ✅ poora box fill, koi space nahi
            //           placeholder: (_, __) => Container(
            //             decoration: BoxDecoration(gradient: fallbackGradient),
            //           ),
            //           errorWidget: (_, __, ___) => Container(
            //             decoration: BoxDecoration(gradient: fallbackGradient),
            //             child: _TitleOverlay(title: course.title),
            //           ),
            //         )
            //       else
            //         Container(
            //           decoration: BoxDecoration(gradient: fallbackGradient),
            //           child: _TitleOverlay(title: course.title),
            //         ),

            AspectRatio(
              aspectRatio: 16 / 9, // thumbnails 16:9 hain toh exact ratio rakho
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: course.thumbnail!,
                      fit: BoxFit.cover, // ✅ poori image dikhegi, crop nahi hogi
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (_, __) => Container(
                        decoration: BoxDecoration(gradient: fallbackGradient),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        decoration: BoxDecoration(gradient: fallbackGradient),
                        child: _TitleOverlay(title: course.title),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(gradient: fallbackGradient),
                      child: _TitleOverlay(title: course.title),
                    ),

                  // Play icon
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),

                  // Video count badge
                  if (course.videos.isNotEmpty)
                    Positioned(
                      //top: 6,
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: kGold.withOpacity(0.4), width: 0.5),
                        ),
                        child: Text(
                          '${course.videos.length} ${course.videos.length == 1 ? 'video' : 'videos'}',
                          style: const TextStyle(
                              color: kGold,
                              fontSize: 8,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── ✅ NEW — thin gradient accent strip (web design jaisa) ──
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPurple, kGold],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            // ── Title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Text(
                course.title,
                style: const TextStyle(
                  color: Color(0xFFCCCCCC),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}







// class _CourseCard extends StatelessWidget {
//   final VerveeUniverseItem course;
//   final LinearGradient fallbackGradient;
//   final VoidCallback onTap;
//
//   const _CourseCard({
//     required this.course,
//     required this.fallbackGradient,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: kBgCard,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: kBorder, width: 0.5),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
//                   //   CachedNetworkImage(
//                   //     imageUrl: course.thumbnail!,
//                   //     fit: BoxFit.cover,
//                   //     placeholder: (_, __) => Container(
//                   //       decoration: BoxDecoration(gradient: fallbackGradient),
//                   //     ),
//                   //     errorWidget: (_, __, ___) => Container(
//                   //       decoration: BoxDecoration(gradient: fallbackGradient),
//                   //       child: _TitleOverlay(title: course.title),
//                   //     ),
//                   //   )
//                   if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
//                     Container(
//                       decoration: BoxDecoration(gradient: fallbackGradient),
//                       child: CachedNetworkImage(
//                         imageUrl: course.thumbnail!,
//                         fit: BoxFit.contain,          // 👈 cover → contain
//                         width: double.infinity,
//                         height: double.infinity,
//                         alignment: Alignment.center,
//                         placeholder: (_, __) => Container(
//                           decoration: BoxDecoration(gradient: fallbackGradient),
//                         ),
//                         errorWidget: (_, __, ___) => Container(
//                           decoration: BoxDecoration(gradient: fallbackGradient),
//                           child: _TitleOverlay(title: course.title),
//                         ),
//                       ),
//                     )
//                   else
//                     Container(
//                       decoration: BoxDecoration(gradient: fallbackGradient),
//                       child: _TitleOverlay(title: course.title),
//                     ),
//
//                   Center(
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black.withOpacity(0.4),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.6),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Icon(Icons.play_arrow_rounded,
//                           color: Colors.white, size: 16),
//                     ),
//                   ),
//
//                   if (course.videos.isNotEmpty)
//                     Positioned(
//                       top: 6,
//                       right: 6,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.55),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                               color: kGold.withOpacity(0.4), width: 0.5),
//                         ),
//                         child: Text(
//                           '${course.videos.length} ${course.videos.length == 1 ? 'video' : 'videos'}',
//                           style: const TextStyle(
//                               color: kGold,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//               child: Text(
//                 course.title,
//                 style: const TextStyle(
//                   color: Color(0xFFCCCCCC),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _TitleOverlay extends StatelessWidget {
  final String title;
  const _TitleOverlay({required this.title});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kGold,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          height: 1.4,
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SKELETON CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _CardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(color: kBorder.withOpacity(0.5)),
          ),
          Container(height: 5, color: kBorder.withOpacity(0.3)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 9, width: double.infinity, color: kBorder),
                const SizedBox(height: 4),
                Container(height: 9, width: 60, color: kBorder),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// class _CardSkeleton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(12)),
//                 color: kBorder.withOpacity(0.5),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(height: 9, width: double.infinity, color: kBorder),
//                 const SizedBox(height: 4),
//                 Container(height: 9, width: 60, color: kBorder),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
















// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
// import 'package:vervee_app/presentation/screen/VerveeUniverseItemScreen.dart';
//
// import '../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';
// import '../viewmodal/VerveeUniverse/VerveeUniverseViewModel.dart';
// import '../viewmodal/pofile/ProfileViewmodels.dart';
// import '../widgets/Common_Widgets/SharedBottomNav.dart';
// import '../widgets/Common_Widgets/VerveeTopBar.dart';
// import 'PremiumMembershipScreen.dart';
// import 'VideoDetailScreen.dart';
//
// // ── Colors ────────────────────────────────────────────────────────────────────
// const kBgDark      = Color(0xFF0F0120);
// const kBgCard      = Color(0xFF150328);
// const kBgDeep      = Color(0xFF0A0118);
// const kPurple      = Color(0xFF7C3AED);
// const kPurpleLight = Color(0xFF9333EA);
// const kGold        = Color(0xFFD4AF37);
// const kGoldLight   = Color(0xFFFFD700);
// const kBorder      = Color(0xFF2D1050);
// const kTextPrimary = Colors.white;
// const kTextMuted   = Color(0xFF888888);
//
// // ── Fallback gradients ────────────────────────────────────────────────────────
// final List<LinearGradient> _fallbackGradients = [
//   const LinearGradient(colors: [Color(0xFF1a0535), Color(0xFF3d1a6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//   const LinearGradient(colors: [Color(0xFF0a1535), Color(0xFF1a3d6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//   const LinearGradient(colors: [Color(0xFF1a350a), Color(0xFF3d6e1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//   const LinearGradient(colors: [Color(0xFF35200a), Color(0xFF6e4a1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//   const LinearGradient(colors: [Color(0xFF350a0a), Color(0xFF6e1a1a)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//   const LinearGradient(colors: [Color(0xFF0a3535), Color(0xFF1a6e6e)], begin: Alignment.topLeft, end: Alignment.bottomRight),
// ];
//
// LinearGradient gradientForIndex(int index) =>
//     _fallbackGradients[index % _fallbackGradients.length];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  FINANCIAL LITERACY SCREEN  — ab /vervee-universe se data leta he
// // ═══════════════════════════════════════════════════════════════════════════════
// class VerveeUniverseScreen extends ConsumerStatefulWidget {
//   const VerveeUniverseScreen({super.key});
//
//   @override
//   ConsumerState<VerveeUniverseScreen> createState() =>
//       _FinancialLiteracyScreenState();
// }
//
// class _FinancialLiteracyScreenState
//     extends ConsumerState<VerveeUniverseScreen> {
//
//   // ── Tap pe loading indicator dikhane ke liye ──────────────────────────────
//   bool _isTapLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//
//     Future.microtask(() {
//       // ✅ Vervee Universe items load karo — GET /vervee-universe
//       ref.read(verveeUniverseViewModelProvider.notifier).loadItems();
//
//       // Subscription bhi yahan load karo agar abhi load nahi hui
//       final subState = ref.read(subscriptionViewModelProvider);
//       if (subState.subscription == null && !subState.isLoading) {
//         ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
//       }
//     });
//   }
//
//   // ── Item tap — subscription check with loading wait ───────────────────────
//   void _onItemTap(BuildContext context, VerveeUniverseItem item, int index) async {
//     if (_isTapLoading) return;
//
//     setState(() => _isTapLoading = true);
//
//     try {
//       final subState = ref.read(subscriptionViewModelProvider);
//       if (subState.isLoading) {
//         int waited = 0;
//         while (ref.read(subscriptionViewModelProvider).isLoading && waited < 30) {
//           await Future.delayed(const Duration(milliseconds: 100));
//           waited++;
//         }
//       }
//
//       if (ref.read(subscriptionViewModelProvider).subscription == null &&
//           !ref.read(subscriptionViewModelProvider).isLoading) {
//         await ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
//       }
//
//       if (!mounted) return;
//
//       final sub = ref.read(subscriptionViewModelProvider).subscription;
//       final hasAccess = sub != null && (sub.isActive || sub.isTrialing);
//
//       if (hasAccess) {
//         _goToDetail(context, item, index);
//       } else {
//         final paid = await Navigator.push<bool>(
//           context,
//           MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
//         );
//         if (paid == true && mounted) {
//           _goToDetail(context, item, index);
//         }
//       }
//     } finally {
//       if (mounted) setState(() => _isTapLoading = false);
//     }
//   }
//
//   void _goToDetail(BuildContext context, VerveeUniverseItem item, int index) {
//     final items = ref.read(verveeUniverseViewModelProvider).items;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => VerveeUniverseItemScreen(
//           course: item,
//           courseIndex: index,
//           allCourses: items,
//         ),
//       ),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               VerveeTopBar(
//                 onProfile: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ProfileScreen()),
//                 ),
//               ),
//               Expanded(child: _buildBody()),
//             ],
//           ),
//
//           // Tap loading overlay (subscription check ke dauran)
//           if (_isTapLoading)
//             Container(
//               color: Colors.black.withOpacity(0.35),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: kGold,
//                   strokeWidth: 2,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: SharedBottomNav(currentIndex: 1, popOnHome: true),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildBody() {
//     final state = ref.watch(verveeUniverseViewModelProvider);
//
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Center(
//               child: Text(
//                 'Learn About Financial Literacy',
//                 style: TextStyle(
//                   color: kTextPrimary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//           _buildDisclaimer(),
//           const SizedBox(height: 14),
//
//           if (state.isLoading)
//             _buildShimmerGrid()
//           else if (state.errorMessage != null)
//             _buildError(state.errorMessage!)
//           else if (state.items.isEmpty)
//               _buildEmpty()
//             else
//               _buildItemGrid(state.items),
//
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   // ── Item Grid ──────────────────────────────────────────────────────────────
//   Widget _buildItemGrid(List<VerveeUniverseItem> items) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.88,
//         ),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return _CourseCard(
//             course: item,
//             fallbackGradient: gradientForIndex(index),
//             onTap: () => _goToDetail(context, item, index), //_onItemTap(context, item, index),
//           );
//         },
//       ),
//     );
//   }
//
//   // ── Shimmer grid ───────────────────────────────────────────────────────────
//   Widget _buildShimmerGrid() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.88,
//         ),
//         itemCount: 6,
//         itemBuilder: (_, __) => _CardSkeleton(),
//       ),
//     );
//   }
//
//   // ── Error ──────────────────────────────────────────────────────────────────
//   Widget _buildError(String message) {
//     return Padding(
//       padding: const EdgeInsets.all(32),
//       child: Column(children: [
//         const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
//         const SizedBox(height: 12),
//         Text(message,
//             style: const TextStyle(color: kTextMuted, fontSize: 13),
//             textAlign: TextAlign.center),
//         const SizedBox(height: 16),
//         GestureDetector(
//           onTap: () => ref
//               .read(verveeUniverseViewModelProvider.notifier)
//               .loadItems(),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//                 color: kPurple, borderRadius: BorderRadius.circular(8)),
//             child: const Text('Retry',
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w600)),
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── Empty ──────────────────────────────────────────────────────────────────
//   Widget _buildEmpty() {
//     return const Padding(
//       padding: EdgeInsets.all(32),
//       child: Column(children: [
//         Icon(Icons.video_library_outlined, color: kTextMuted, size: 48),
//         SizedBox(height: 12),
//         Text('No courses available',
//             style: TextStyle(color: kTextMuted, fontSize: 13)),
//       ]),
//     );
//   }
//
//   // ── Disclaimer ─────────────────────────────────────────────────────────────
//   Widget _buildDisclaimer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Icon(Icons.info_outline_rounded, color: kGold, size: 13),
//           const SizedBox(width: 5),
//           const Text('Disclaimer',
//               style: TextStyle(
//                   color: kGold, fontSize: 11, fontWeight: FontWeight.w700)),
//         ]),
//         const SizedBox(height: 6),
//         const Text(
//           'These Financial Literacy videos are provided solely for educational '
//               'purposes. Vervee Academy does not offer any trading or investment '
//               'advice. Any decisions made based on this content are entirely at '
//               'your own discretion and risk.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: kTextMuted, fontSize: 10, height: 1.6),
//         ),
//       ]),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  COURSE CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _CourseCard extends StatelessWidget {
//   final VerveeUniverseItem course;
//   final LinearGradient fallbackGradient;
//   final VoidCallback onTap;
//
//   const _CourseCard({
//     required this.course,
//     required this.fallbackGradient,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: kBgCard,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: kBorder, width: 0.5),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
//                     CachedNetworkImage(
//                       imageUrl: course.thumbnail!,
//                       fit: BoxFit.cover,
//                       placeholder: (_, __) => Container(
//                         decoration: BoxDecoration(gradient: fallbackGradient),
//                       ),
//                       errorWidget: (_, __, ___) => Container(
//                         decoration: BoxDecoration(gradient: fallbackGradient),
//                         child: _TitleOverlay(title: course.title),
//                       ),
//                     )
//                   else
//                     Container(
//                       decoration: BoxDecoration(gradient: fallbackGradient),
//                       child: _TitleOverlay(title: course.title),
//                     ),
//
//                   Center(
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black.withOpacity(0.4),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.6),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Icon(Icons.play_arrow_rounded,
//                           color: Colors.white, size: 16),
//                     ),
//                   ),
//
//                   if (course.videos.isNotEmpty)
//                     Positioned(
//                       top: 6,
//                       right: 6,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.55),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                               color: kGold.withOpacity(0.4), width: 0.5),
//                         ),
//                         child: Text(
//                           '${course.videos.length} ${course.videos.length == 1 ? 'video' : 'videos'}',
//                           style: const TextStyle(
//                               color: kGold,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//               child: Text(
//                 course.title,
//                 style: const TextStyle(
//                   color: Color(0xFFCCCCCC),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _TitleOverlay extends StatelessWidget {
//   final String title;
//   const _TitleOverlay({required this.title});
//
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Text(
//         title.toUpperCase(),
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: kGold,
//           fontSize: 9,
//           fontWeight: FontWeight.w900,
//           letterSpacing: 1.5,
//           height: 1.4,
//         ),
//       ),
//     ),
//   );
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  SKELETON CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _CardSkeleton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(12)),
//                 color: kBorder.withOpacity(0.5),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(height: 9, width: double.infinity, color: kBorder),
//                 const SizedBox(height: 4),
//                 Container(height: 9, width: 60, color: kBorder),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
