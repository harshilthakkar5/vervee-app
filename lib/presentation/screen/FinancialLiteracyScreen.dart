
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vervee_app/presentation/screen/ProfileScreen.dart';

import '../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';
import '../viewmodal/FinancialLiteracy/FinancialLiteracyViewModel.dart';
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
//  FINANCIAL LITERACY SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class FinancialLiteracyScreen extends ConsumerStatefulWidget {
  const FinancialLiteracyScreen({super.key});

  @override
  ConsumerState<FinancialLiteracyScreen> createState() =>
      _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState
    extends ConsumerState<FinancialLiteracyScreen> {

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
      // Courses load karo
      ref.read(financialLiteracyViewModelProvider.notifier).loadCourses();

      // ✅ FIX — Subscription bhi yahan load karo agar abhi load nahi hui
      // Isse pehli tap tak subscription ready ho jaayegi
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.subscription == null && !subState.isLoading) {
        ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }
    });
  }

  // ── Course tap — subscription check with loading wait ────────────────────
  void _onCourseTap(BuildContext context, FinancialLiteracyCourse course, int index) async {
    // ✅ FIX — Agar already tap loading chal rahi hai toh ignore karo
    if (_isTapLoading) return;

    setState(() => _isTapLoading = true);

    try {
      // ✅ FIX — Subscription abhi load ho rahi hai toh uska wait karo
      // 3 second max wait — uske baad bhi check karo
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.isLoading) {
        // Max 3 seconds wait karo subscription load hone ke liye
        int waited = 0;
        while (ref.read(subscriptionViewModelProvider).isLoading && waited < 30) {
          await Future.delayed(const Duration(milliseconds: 100));
          waited++;
        }
      }

      // ✅ FIX — Agar subscription null hai toh fresh load trigger karo aur wait karo
      if (ref.read(subscriptionViewModelProvider).subscription == null &&
          !ref.read(subscriptionViewModelProvider).isLoading) {
        await ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }

      if (!mounted) return;

      final sub = ref.read(subscriptionViewModelProvider).subscription;
      final hasAccess = sub != null && (sub.isActive || sub.isTrialing);

      if (hasAccess) {
        _goToDetail(context, course, index);
      } else {
        final paid = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
        );
        if (paid == true && mounted) {
          _goToDetail(context, course, index);
        }
      }
    } finally {
      if (mounted) setState(() => _isTapLoading = false);
    }
  }

  void _goToDetail(BuildContext context, FinancialLiteracyCourse course, int index) {
    final courses = ref.read(financialLiteracyViewModelProvider).courses;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoDetailScreen(
          course: course,
          courseIndex: index,
          allCourses: courses,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      body: Stack(
        children: [
          Column(
            children: [
              VerveeTopBar(
                onProfile: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),

          // ✅ FIX — Tap loading overlay (subscription check ke dauran)
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
      bottomNavigationBar: SharedBottomNav(currentIndex: 1, popOnHome: true),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBody() {
    final state = ref.watch(financialLiteracyViewModelProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'Learn About Financial Literacy',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _buildDisclaimer(),
          const SizedBox(height: 14),

          if (state.isLoading)
            _buildShimmerGrid()
          else if (state.errorMessage != null)
            _buildError(state.errorMessage!)
          else if (state.courses.isEmpty)
              _buildEmpty()
            else
              _buildCourseGrid(state.courses),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Course Grid ────────────────────────────────────────────────────────────
  Widget _buildCourseGrid(List<FinancialLiteracyCourse> courses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.88,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _CourseCard(
            course: course,
            fallbackGradient: gradientForIndex(index),
            onTap: () => _goToDetail(context, course, index), //_onCourseTap(context, course, index),
          );
        },
      ),
    );
  }

  // ── Shimmer grid ───────────────────────────────────────────────────────────
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
          childAspectRatio: 0.88,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => _CardSkeleton(),
      ),
    );
  }

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
              .read(financialLiteracyViewModelProvider.notifier)
              .loadCourses(),
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
        const SizedBox(height: 6),
        const Text(
          'These Financial Literacy videos are provided solely for educational '
              'purposes. Vervee Academy does not offer any trading or investment '
              'advice. Any decisions made based on this content are entirely at '
              'your own discretion and risk.',
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
  final FinancialLiteracyCourse course;
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
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (course.thumbnail != null && course.thumbnail!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: course.thumbnail!,
                      fit: BoxFit.cover,
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

                  if (course.videos.isNotEmpty)
                    Positioned(
                      top: 6,
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

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                color: kBorder.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
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





// ══════════ With Integration ══════════════════════════════════════════════>





// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
// // import 'package:vervee_app/presentation/viewmodal/financial_literacy/financial_literacy_viewmodel.dart';
// // import 'package:vervee_app/presentation/viewmodal/financial_literacy/financial_literacy_dto.dart';
//
// import '../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';
// import '../viewmodal/FinancialLiteracy/FinancialLiteracyViewModel.dart';
// import '../viewmodal/pofile/ProfileViewmodels.dart';
// import '../widgets/Common_Widgets/SharedBottomNav.dart';
// import '../widgets/Common_Widgets/VerveeTopBar.dart';
// import 'PremiumMembershipScreen.dart';
// import 'VideoDetailScreen.dart';
//
// // ── Colors ─────────────────────────────────────────────────────────────────────
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
// // ── Fallback gradients (thumbnail load na ho toh) ─────────────────────────────
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
// //  FINANCIAL LITERACY SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
// class FinancialLiteracyScreen extends ConsumerStatefulWidget {
//   const FinancialLiteracyScreen({super.key});
//
//   @override
//   ConsumerState<FinancialLiteracyScreen> createState() =>
//       _FinancialLiteracyScreenState();
// }
//
// class _FinancialLiteracyScreenState
//     extends ConsumerState<FinancialLiteracyScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     // Screen open hote hi courses load karo
//     Future.microtask(
//           () => ref.read(financialLiteracyViewModelProvider.notifier).loadCourses(),
//     );
//   }
//
//   // ── Subscription check → navigate ─────────────────────────────────────────
//   void _onCourseTap(BuildContext context, FinancialLiteracyCourse course, int index) async {
//     final subState = ref.read(subscriptionViewModelProvider);
//     if (subState.isLoading) return;
//
//     final sub = subState.subscription;
//     final hasAccess = sub != null && (sub.isActive || sub.isTrialing);
//
//     if (hasAccess) {
//       _goToDetail(context, course, index);
//     } else {
//       final paid = await Navigator.push<bool>(
//         context,
//         MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
//       );
//       if (paid == true && mounted) {
//         _goToDetail(context, course, index);
//       }
//     }
//   }
//
//   void _goToDetail(BuildContext context, FinancialLiteracyCourse course, int index) {
//     final courses = ref.read(financialLiteracyViewModelProvider).courses;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => VideoDetailScreen(
//           course: course,
//           courseIndex: index,
//           allCourses: courses,
//         ),
//       ),
//     );
//   }
//
//   // ═════════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Column(
//         children: [
//           VerveeTopBar(
//             onProfile: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ProfileScreen()),
//             ),
//           ),
//           Expanded(child: _buildBody()),
//         ],
//       ),
//       bottomNavigationBar:
//       SharedBottomNav(currentIndex: 1, popOnHome: true),
//     );
//   }
//
//   // ═════════════════════════════════════════════════════════════════════════════
//   Widget _buildBody() {
//     final state = ref.watch(financialLiteracyViewModelProvider);
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
//           // ── States ───────────────────────────────────────────────────────
//           if (state.isLoading)
//             _buildShimmerGrid()
//           else if (state.errorMessage != null)
//             _buildError(state.errorMessage!)
//           else if (state.courses.isEmpty)
//               _buildEmpty()
//             else
//               _buildCourseGrid(state.courses),
//
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   // ── Course Grid ────────────────────────────────────────────────────────────
//   Widget _buildCourseGrid(List<FinancialLiteracyCourse> courses) {
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
//         itemCount: courses.length,
//         itemBuilder: (context, index) {
//           final course = courses[index];
//           return _CourseCard(
//             course: course,
//             fallbackGradient: gradientForIndex(index),
//             onTap: () => _onCourseTap(context, course, index),
//           );
//         },
//       ),
//     );
//   }
//
//   // ── Shimmer skeleton grid ──────────────────────────────────────────────────
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
//               .read(financialLiteracyViewModelProvider.notifier)
//               .loadCourses(),
//           child: Container(
//             padding:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
// //  COURSE CARD — Real thumbnail + fallback gradient
// // ═══════════════════════════════════════════════════════════════════════════════
// class _CourseCard extends StatelessWidget {
//   final FinancialLiteracyCourse course;
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
//             // ── Thumbnail ──────────────────────────────────────────────────
//             Expanded(
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // Thumbnail image (CachedNetworkImage)
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
//                   // Play icon overlay
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
//                   // Video count badge (top-right)
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
//             // ── Title ──────────────────────────────────────────────────────
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
// //  SKELETON CARD (shimmer loading)
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
//                 borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(12)),
//                 color: kBorder.withOpacity(0.5),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     height: 9, width: double.infinity, color: kBorder),
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
//
// // ── Helper classes (HomeScreen compat) ────────────────────────────────────────
// class _TopIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _TopIconBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 39,
//       height: 39,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: kBgDeep,
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Icon(icon, color: kPurpleLight, size: 25),
//     ),
//   );
// }






// ══════════ With API Integration ══════════════════════════════════════════════>






// import 'dart:math' as math;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // ✅ CHANGE #1 — HomeScreen wale sare imports add kiye
// import 'package:vervee_app/presentation/screen/AvatarCustomizationScreen.dart';
// import 'package:vervee_app/presentation/screen/ProfileScreen.dart';
// import 'package:vervee_app/presentation/screen/CreatePostScreen.dart';
// import 'package:vervee_app/presentation/viewmodal/avatar/AvatarViewModel.dart';
// import 'package:vervee_app/presentation/viewmodal/pofile/ProfileViewmodels.dart';
//
// import '../widgets/Common_Widgets/SharedBottomNav.dart';
// import '../widgets/Common_Widgets/VerveeTopBar.dart';
// import 'PremiumMembershipScreen.dart';
// import 'VideoDetailScreen.dart';
// //import 'video_detail_screen.dart';
//
// // ── Colors (HomeScreen se same) ───────────────────────────────────────────────
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
// // ── Video model ───────────────────────────────────────────────────────────────
// class VideoLesson {
//   final String title;
//   final LinearGradient gradient;
//   const VideoLesson({required this.title, required this.gradient});
// }
//
// // ── 10 lessons ────────────────────────────────────────────────────────────────
// final List<VideoLesson> _lessons = [
//   VideoLesson(
//     title: 'Money Challenge',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF1a0535), Color(0xFF3d1a6e)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Financial Control',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF0a1535), Color(0xFF1a3d6e)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Smart Saving',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF1a350a), Color(0xFF3d6e1a)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Investment Basics',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF35200a), Color(0xFF6e4a1a)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Debt Management',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF350a0a), Color(0xFF6e1a1a)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Credit Score',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF0a3535), Color(0xFF1a6e6e)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Tax Planning',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF20350a), Color(0xFF4a6e1a)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Emergency Fund',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF35000a), Color(0xFF6e001a)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Quote Lesson',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF1a1535), Color(0xFF3a2d6e)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
//   VideoLesson(
//     title: 'Wealth Mindset',
//     gradient: const LinearGradient(
//       colors: [Color(0xFF150a35), Color(0xFF2d1a6e)],
//       begin: Alignment.topLeft, end: Alignment.bottomRight,
//     ),
//   ),
// ];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  FINANCIAL LITERACY SCREEN
// //  ✅ CHANGE #1 — StatefulWidget → ConsumerStatefulWidget (Riverpod ke liye)
// // ═══════════════════════════════════════════════════════════════════════════════
// class FinancialLiteracyScreen extends ConsumerStatefulWidget {
//   const FinancialLiteracyScreen({super.key});
//
//   @override
//   ConsumerState<FinancialLiteracyScreen> createState() =>
//       _FinancialLiteracyScreenState();
// }
//
// class _FinancialLiteracyScreenState extends ConsumerState<FinancialLiteracyScreen>
//     with TickerProviderStateMixin {
//
//   int _currentNavIndex = 3; // Signals tab active (HomeScreen pattern same)
//
//   // ✅ CHANGE #1 — HomeScreen jaisa glow animation
//   late AnimationController _glowCtrl;
//
//   // ✅ CHANGE #2 — HomeScreen jaisa FAB scale state
//   double _fabScale = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     // ✅ CHANGE #1 — Glow animation init — HomeScreen se same
//     _glowCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     // ✅ ADD — screen open hote hi subscription status load karo
//     Future.microtask(
//           () => ref.read(subscriptionViewModelProvider.notifier).loadSubscription(),
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _glowCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Logout ─────────────────────────────────────────────────────────────────
//   // ✅ CHANGE #1 — HomeScreen ka exact logout logic copy kiya
//   Future<void> _logout() async {
//     // await PostCacheService.clearAllCache();
//     // await DefaultCacheManager().emptyCache();
//     // await AuthService.instance.logout(keepCredentials: true);
//     if (!mounted) return;
//     // Navigator.pushAndRemoveUntil(context,
//     //   MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
//   }
//
//   void _openprofile() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const ProfileScreen()),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   //  BUILD
//   // ═══════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: Column(
//         children: [
//           // ✅ CHANGE #1 — SharedAppBar HATAYA, HomeScreen jaisa _buildTopBar()
//          // _buildTopBar(context),
//           VerveeTopBar(onProfile: _openprofile),
//           Expanded(child: _buildBody()),
//         ],
//       ),
//       // ✅ CHANGE #2 — SharedBottomNav HATAYA, HomeScreen jaisa _buildBottomNav()
//       bottomNavigationBar: SharedBottomNav(currentIndex: 1, popOnHome: true), //_buildBottomNav(),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   //  TOP BAR — HomeScreen se EXACT COPY, sirf isTablet check hata diya
//   //  (mobile-only screen hai toh fixed fontSize use kiya)
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildTopBar(BuildContext context) {
//     // ✅ CHANGE #1 — HomeScreen jaisi providers watch kar raha hai
//     final avatarUrl      = ref.watch(avatarViewModelProvider).generatedMascotUrl;
//     final profileState   = ref.watch(profileInfoViewModelProvider);
//
//     return Container(
//       color: kBgCard,
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 8,
//         left: 16, right: 16, bottom: 10,
//       ),
//       child: Row(
//         children: [
//           // ── Logo + glow ──────────────────────────────────────────────────
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ✅ CHANGE #1 — AnimatedBuilder with _glowCtrl (HomeScreen same)
//               AnimatedBuilder(
//                 animation: _glowCtrl,
//                 builder: (_, __) => Text(
//                   'VERVEE',
//                   style: TextStyle(
//                     color: kGold,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w900,
//                     letterSpacing: 3,
//                     shadows: [
//                       Shadow(
//                         color: kGold.withOpacity(0.4 + 0.3 * _glowCtrl.value),
//                         blurRadius: 8 + 4 * _glowCtrl.value,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const Text(
//                 'A C A D E M Y',
//                 style: TextStyle(
//                   color: kPurpleLight,
//                   fontSize: 7.5,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 3,
//                 ),
//               ),
//             ],
//           ),
//
//           const Spacer(),
//
//           // ── Search button ─────────────────────────────────────────────────
//           // ✅ CHANGE #1 — HomeScreen jaisa search bottom sheet
//           _TopIconBtn(
//             icon: Icons.search_rounded,
//             onTap: () => _showSearchSheet(context),
//           ),
//           const SizedBox(width: 8),
//
//           // ── Avatar + PopupMenu ────────────────────────────────────────────
//           // ✅ CHANGE #1 — HomeScreen ka exact PopupMenuButton copy kiya
//           PopupMenuButton<String>(
//             offset: const Offset(0, 44),
//             color: kBgCard,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: const BorderSide(color: kBorder, width: 0.8),
//             ),
//             elevation: 8,
//             onSelected: (value) async {
//               switch (value) {
//                 case 'profile':
//                   await Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => const ProfileScreen()));
//                   break;
//                 case 'avatar':
//                   await Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => const AvatarCustomizationScreen()));
//                   break;
//                 case 'logout':
//                   _logout();
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               // ── Profile ─────────────────────────────────────────────────
//               PopupMenuItem<String>(
//                 value: 'profile',
//                 child: Row(children: [
//                   Container(
//                     width: 32, height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: kPurple.withOpacity(0.15),
//                     ),
//                     child: const Icon(Icons.person_outline_rounded,
//                         color: kPurpleLight, size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text('Profile',
//                       style: TextStyle(color: kTextPrimary,
//                           fontSize: 13, fontWeight: FontWeight.w500)),
//                 ]),
//               ),
//               // ── Avatar ──────────────────────────────────────────────────
//               PopupMenuItem<String>(
//                 value: 'avatar',
//                 child: Row(children: [
//                   Container(
//                     width: 32, height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: kGold.withOpacity(0.12),
//                     ),
//                     child: const Icon(Icons.face_rounded, color: kGold, size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text('Avatar',
//                       style: TextStyle(color: kTextPrimary,
//                           fontSize: 13, fontWeight: FontWeight.w500)),
//                 ]),
//               ),
//               // ── Divider ─────────────────────────────────────────────────
//               const PopupMenuDivider(height: 1),
//               // ── Logout ──────────────────────────────────────────────────
//               PopupMenuItem<String>(
//                 value: 'logout',
//                 child: Row(children: [
//                   Container(
//                     width: 32, height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFFEF4444).withOpacity(0.12),
//                     ),
//                     child: const Icon(Icons.logout_rounded,
//                         color: Color(0xFFEF4444), size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text('Logout',
//                       style: TextStyle(color: Color(0xFFEF4444),
//                           fontSize: 13, fontWeight: FontWeight.w500)),
//                 ]),
//               ),
//             ],
//             // ✅ CHANGE #1 — Avatar image ya gradient — HomeScreen same logic
//             child: Container(
//               width: 34, height: 34,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: avatarUrl == null
//                     ? const LinearGradient(
//                   colors: [kGold, kPurple],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//                     : null,
//               ),
//               child: avatarUrl != null
//                   ? ClipOval(
//                 child: Image.network(
//                   avatarUrl,
//                   width: 34, height: 34,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Center(
//                     child: Text(
//                       profileState.profile != null
//                           ? profileState.profile!.name
//                           .substring(0, 1)
//                           .toUpperCase()
//                           : 'VA',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//                   : const Center(
//                 child: Text('VA',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // FinancialLiteracyScreen mein — _buildBody() se pehle ADD karo:
//
//   /// Video tap pe subscription check karo
//   /// Paid/trialing → VideoDetailScreen
//   /// No subscription → PremiumMembershipScreen
//   // void _onVideoTap(BuildContext context, int index) {
//   //   final subState = ref.read(subscriptionViewModelProvider);
//   //
//   //   // Loading hai toh wait karo
//   //   if (subState.isLoading) return;
//   //
//   //   final sub = subState.subscription;
//   //   final hasAccess = sub != null && (sub.isActive || sub.isTrialing);
//   //
//   //   if (hasAccess) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (_) => VideoDetailScreen(
//   //           lesson: _lessons[index],
//   //           chapterIndex: index,
//   //           allLessons: _lessons,
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (_) => const PremiumMembershipScreen(),
//   //       ),
//   //     );
//   //   }
//   // }
//
//   void _onVideoTap(BuildContext context, int index) async {
//     final subState = ref.read(subscriptionViewModelProvider);
//
//     if (subState.isLoading) return;
//
//     final sub = subState.subscription;
//     final hasAccess = sub != null && (sub.isActive || sub.isTrialing);
//
//     if (hasAccess) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => VideoDetailScreen(
//             lesson: _lessons[index],
//             chapterIndex: index,
//             allLessons: _lessons,
//           ),
//         ),
//       );
//     } else {
//       // ← await karo — agar true return hua (payment done) toh video open karo
//       final paid = await Navigator.push<bool>(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const PremiumMembershipScreen(),
//         ),
//       );
//
//       if (paid == true && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => VideoDetailScreen(
//               lesson: _lessons[index],
//               chapterIndex: index,
//               allLessons: _lessons,
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//
//   // ── Search Bottom Sheet ────────────────────────────────────────────────────
//   // ✅ CHANGE #1 — HomeScreen ka exact search sheet (bina ViewModel call ke,
//   //               kyunki yahan feed nahi hai — sirf UI same rakhna tha)
//   void _showSearchSheet(BuildContext context) {
//     final ctrl = TextEditingController();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//           decoration: const BoxDecoration(
//             color: kBgCard,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                   color: kTextMuted,
//                   borderRadius: BorderRadius.circular(2)),
//             ),
//             TextField(
//               controller: ctrl,
//               autofocus: true,
//               style: const TextStyle(color: kTextPrimary),
//               decoration: InputDecoration(
//                 hintText: 'Search posts...',
//                 hintStyle: const TextStyle(color: kTextMuted),
//                 prefixIcon:
//                 const Icon(Icons.search_rounded, color: kTextMuted),
//                 filled: true,
//                 fillColor: kBgDeep,
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: kBorder)),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: kBorder)),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: kPurple)),
//               ),
//               onSubmitted: (q) {
//                 if (q.trim().isEmpty) return;
//                 Navigator.pop(context);
//                 // ✅ Yahan apna search logic add karo agar zaroorat ho
//               },
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   //  BOTTOM NAV — HomeScreen se EXACT COPY
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildBottomNav() {
//     // ✅ CHANGE #2 — HomeScreen jaisi exact items list
//     final items = [
//       _NavItem(icon: Icons.home_rounded,                label: 'Home'),
//       _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Courses'),
//       _NavItem(icon: Icons.add_rounded,                 label: 'Add'),
//       _NavItem(icon: Icons.wifi_tethering_rounded,      label: 'Signals'),
//       _NavItem(icon: Icons.person_outline_rounded,      label: 'Profile'),
//     ];
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(top: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(items.length, (i) {
//               final isSelected = _currentNavIndex == i;
//
//               // ✅ CHANGE #2 — Center FAB (index 2) — HomeScreen ka exact code
//               if (i == 2) {
//                 return GestureDetector(
//                   onTapDown: (_) => setState(() => _fabScale = 0.90),
//                   onTapUp:   (_) => setState(() => _fabScale = 1.0),
//                   onTapCancel: () => setState(() => _fabScale = 1.0),
//                   onTap: () async {
//                     setState(() => _fabScale = 0.90);
//                     await Future.delayed(const Duration(milliseconds: 80));
//                     if (mounted) setState(() => _fabScale = 1.0);
//
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const CreatePostScreen()),
//                     );
//                   },
//                   child: AnimatedScale(
//                     scale: _fabScale,
//                     duration: const Duration(milliseconds: 120),
//                     curve: Curves.easeOut,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       width: 60, height: 60,
//                       margin: const EdgeInsets.only(bottom: 15),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           colors: [kGoldLight, kPurple, kPurpleLight],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: kPurple.withOpacity(
//                                 _fabScale < 1 ? 0.25 : 0.45),
//                             blurRadius: _fabScale < 1 ? 10 : 22,
//                             spreadRadius: _fabScale < 1 ? 1 : 3,
//                           ),
//                           BoxShadow(
//                             color: kGold.withOpacity(
//                                 _fabScale < 1 ? 0.15 : 0.28),
//                             blurRadius: _fabScale < 1 ? 12 : 26,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.15),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: Container(
//                         margin: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: kBgCard,
//                         ),
//                         child: AnimatedRotation(
//                           turns: _fabScale < 1 ? 0.08 : 0,
//                           duration: const Duration(milliseconds: 150),
//                           child: const Icon(Icons.add_rounded,
//                               color: kGoldLight, size: 34),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }
//
//               // ✅ CHANGE #2 — Normal nav items — HomeScreen ka exact logic
//               return GestureDetector(
//                 onTap: () async {
//                   if (i == 0) {
//                     // Home — pop back karo
//                     setState(() => _currentNavIndex = i);
//                     Navigator.pop(context);
//                   } else if (i == 4) {
//                     // Profile tab — FadeTransition navigate (HomeScreen same)
//                     setState(() => _currentNavIndex = i);
//                     await Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (_, a, __) => const ProfileScreen(),
//                         transitionsBuilder: (_, a, __, child) =>
//                             FadeTransition(opacity: a, child: child),
//                         transitionDuration:
//                         const Duration(milliseconds: 300),
//                       ),
//                     );
//                   } else {
//                     setState(() => _currentNavIndex = i);
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? kPurple.withOpacity(0.15)
//                         : Colors.transparent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(items[i].icon, size: 22,
//                           color: isSelected ? kGold : kTextMuted),
//                       const SizedBox(height: 3),
//                       Text(items[i].label,
//                           style: TextStyle(
//                             fontSize: 9.5,
//                             fontWeight: isSelected
//                                 ? FontWeight.w600
//                                 : FontWeight.w400,
//                             color: isSelected ? kGold : kTextMuted,
//                           )),
//                       if (isSelected)
//                         Container(
//                           margin: const EdgeInsets.only(top: 3),
//                           width: 4, height: 4,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle, color: kGold,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ═══════════════════════════════════════════════════════════════════════════
//   //  BODY — BAKI SAB SAME (kuch nahi badla)
//   // ═══════════════════════════════════════════════════════════════════════════
//   Widget _buildBody() {
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
//           _buildVideoGrid(),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDisclaimer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.info_outline_rounded, color: kGold, size: 13),
//               const SizedBox(width: 5),
//               const Text('Disclaimer',
//                   style: TextStyle(
//                       color: kGold,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             'These Financial Literacy videos are provided solely for educational '
//                 'purposes. Vervee Academy does not offer any trading or investment '
//                 'advice. Any decisions made based on this content are entirely at '
//                 'your own discretion and risk.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: kTextMuted, fontSize: 10, height: 1.6),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVideoGrid() {
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
//         itemCount: _lessons.length,
//         itemBuilder: (context, index) {
//           return _VideoCard(
//             lesson: _lessons[index],
//             onTap: () => _onVideoTap(context, index),  // ← ye change
//             //     Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (_) => VideoDetailScreen(
//             //       lesson: _lessons[index],
//             //       chapterIndex: index,
//             //       allLessons: _lessons,
//             //     ),
//             //   ),
//             // ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  VIDEO CARD — KUCH NAHI BADLA
// // ═══════════════════════════════════════════════════════════════════════════════
// class _VideoCard extends StatelessWidget {
//   final VideoLesson lesson;
//   final VoidCallback onTap;
//   const _VideoCard({required this.lesson, required this.onTap});
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
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(gradient: lesson.gradient),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         lesson.title.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: kGold,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w900,
//                           letterSpacing: 1.5,
//                           height: 1.4,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: 30, height: 30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.18),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.5),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Icon(Icons.play_arrow_rounded,
//                           color: Colors.white, size: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
//               child: Text(
//                 lesson.title,
//                 style: const TextStyle(
//                   color: Color(0xFFCCCCCC),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
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
// // ── Helper widgets (HomeScreen se same) ──────────────────────────────────────
// class _TopIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _TopIconBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 39, height: 39,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle, color: kBgDeep,
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Icon(icon, color: kPurpleLight, size: 25),
//     ),
//   );
// }
//
// class _NavItem {
//   final IconData icon;
//   final String label;
//   _NavItem({required this.icon, required this.label});
// }