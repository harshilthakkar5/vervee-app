
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../domain/course_domain.dart';
// import '../viewmodel/course_viewmodels.dart';
import '../../domain/model/course/CourseModel.dart';
import '../viewmodal/course/CoursesViewModel.dart';
import '../widgets/Common_Widgets/ShimmerBox.dart';
import 'CourseDetailScreen.dart';
import 'ProfileScreen.dart';
import '../widgets/Common_Widgets/SharedBottomNav.dart';
import '../widgets/Common_Widgets/VerveeTopBar.dart';

// ── Colors ────────────────────────────────────────────────────
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
const kAccentGreen = Color(0xFF639922);

// Gradient list — course index ke hisaab se assign karo
const _gradients = [
  LinearGradient(
    colors: [Color(0xFF2D0A4A), kPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [Color(0xFF1A0535), Color(0xFF534AB7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [Color(0xFF0A1535), Color(0xFF3A4AB7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];

LinearGradient _gradientFor(int index) =>
    _gradients[index % _gradients.length];

// ══════════════════════════════════════════════════════════════
//  COURSES SCREEN
// ══════════════════════════════════════════════════════════════
class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {

  bool _imagesReady = false;
  List<String> _precachedFor = const [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  void _onCourseTap(CourseModel course, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
          gradient: _gradientFor(index),
        ),
      ),
    );
  }

  Future<void> _precacheThumbnails(List<CourseModel> courses) async {
    final urls = courses.map((c) => c.thumbnailPreview).toList();
    _precachedFor = urls; // lock — dobara trigger na ho isliye

    if (_imagesReady) setState(() => _imagesReady = false);

    await Future.wait(urls.map(
          (url) => precacheImage(NetworkImage(url), context).catchError((_) {}),
    ));

    if (!mounted) return;
    setState(() => _imagesReady = true);
  }

  // Future<void> _precacheThumbnails(List<CourseModel> courses) async {
  //   final urls = courses.map((c) => c.thumbnailPreview).toList();
  //   _precachedFor = urls;
  //
  //   if (_imagesReady) setState(() => _imagesReady = false);
  //
  //   await Future.wait(urls.map(
  //         (url) => precacheImage(
  //       ResizeImage(NetworkImage(url), width: 600), // 👈 UPDATED — decode resolution chhota
  //       context,
  //     ).timeout(const Duration(seconds: 3), onTimeout: () {}) // 👈 NAYA — max 3 sec wait
  //         .catchError((_) {}),
  //   ));
  //
  //   if (!mounted) return;
  //   setState(() => _imagesReady = true);
  // }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(coursesViewModelProvider);

    if (!state.isLoading && state.errorMessage == null && state.courses.isNotEmpty) {
      final urls = state.courses.map((c) => c.thumbnailPreview).toList();
      if (!listEquals(urls, _precachedFor)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _precacheThumbnails(state.courses);
        });
      }
    }

    return Scaffold(
      backgroundColor: kBgDark,
      body: Column(
        children: [
          VerveeTopBar(
           // onSearchTap: () {},
            onProfile: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar:
      const SharedBottomNav(currentIndex: 3, popOnHome: true),
    );
  }

  Widget _buildBody() {
    final state = ref.watch(coursesViewModelProvider);

    if (state.isLoading) return _buildShimmer();

    if (state.errorMessage != null) {
      return _buildError(
        state.errorMessage!,
        onRetry: () => ref.read(coursesViewModelProvider.notifier).fetchCourses(),
      );
    }

    if (state.courses.isEmpty) {
      return const Center(
        child: Text('No courses available',
            style: TextStyle(color: kTextMuted, fontSize: 13)),
      );
    }

    // 👈 NAYA: thumbnails precache ho rahi hain tab tak shimmer dikhao
    if (!_imagesReady) return _buildShimmer();

    return RefreshIndicator(
      color: kPurple,
      backgroundColor: kBgCard,
      onRefresh: () =>
          ref.read(coursesViewModelProvider.notifier).fetchCourses(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All courses',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.courses.length} courses available',
                style: const TextStyle(color: kTextMuted, fontSize: 11),
              ),
              const SizedBox(height: 14),
              ...List.generate(state.courses.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: i == state.courses.length - 1 ? 0 : 14),
                  child: _CourseCard(
                    course: state.courses[i],
                    gradient: _gradientFor(i),
                    onTap: () => _onCourseTap(state.courses[i], i),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildShimmer() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: List.generate(
  //         2,
  //             (_) => Container(
  //           margin: const EdgeInsets.only(bottom: 14),
  //           decoration: BoxDecoration(
  //             color: kBgCard,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: kBorder, width: 0.5),
  //           ),
  //           child: Column(
  //             children: [
  //               Container(
  //                 height: 130,
  //                 decoration: BoxDecoration(
  //                   color: kBorder,
  //                   borderRadius: const BorderRadius.vertical(
  //                       top: Radius.circular(12)),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(14),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(height: 12, width: double.infinity,
  //                         color: kBorder),
  //                     const SizedBox(height: 8),
  //                     Container(height: 12, width: 180, color: kBorder),
  //                     const SizedBox(height: 8),
  //                     Container(height: 10, width: 120, color: kBorder),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          2,
              (_) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            clipBehavior: Clip.hardEdge, // 👈 NAYA — top corners round rakhne ke liye
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder, width: 0.5),
            ),
            child: Column(
              children: [
                const ShimmerBox(width: double.infinity, height: 130, radius: 0), // 👈 UPDATED
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ShimmerBox(width: double.infinity, height: 12), // 👈 UPDATED
                      const SizedBox(height: 8),
                      const _ShimmerBox(width: 180, height: 12), // 👈 UPDATED
                      const SizedBox(height: 8),
                      const _ShimmerBox(width: 120, height: 10), // 👈 UPDATED
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildError(String message, {required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
            const SizedBox(height: 12),
            Text(message,
                style: const TextStyle(color: kTextMuted, fontSize: 13),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: kPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Retry',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  COURSE CARD
// ══════════════════════════════════════════════════════════════

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.gradient,
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
            // ── Thumbnail ─────────────────────────────────────────────
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail image — backend se aata hai
                  Image.network(
                    course.thumbnailPreview,
                    fit: BoxFit.cover,
                    //cacheWidth: 600,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(gradient: gradient),
                    ),
                  ),

                  // Dark overlay
                  Container(color: Colors.black.withOpacity(0.35)),
                  // Left accent bar
                 // Container(width: 4, color: kAccentGreen),
                  // BAAD MEIN
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: kAccentGreen),
                  ),
                  // Course title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        course.courseTitle.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  // Play button
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseTitle,
                    style: const TextStyle(
                      color: kTextPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Created by Vervee Academy',
                    style: TextStyle(color: kTextMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.subtitle,
                    style: const TextStyle(
                      color: Color(0xFFB0AECF),
                      fontSize: 11,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF412402),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.courseLevel,
                          style: const TextStyle(
                            color: Color(0xFFFAC775),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: kTextMuted, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lectureCount} videos',
                            style: const TextStyle(
                                color: kTextMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  SHIMMER BOX (animated sliding gradient placeholder)
// ══════════════════════════════════════════════════════════════
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -1.0, end: 2.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: const [
                Color(0xFF1A0535),
                Color(0xFF2D1050),
                Color(0xFF1A0535),
              ],
              transform: _SlidingGradientTransform(_anim.value),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}








//--------------------------------------------- Without API ---------------------------------------------------->








// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'CourseDetailScreen.dart';
// import 'ProfileScreen.dart';
// import '../widgets/Common_Widgets/SharedBottomNav.dart';
// import '../widgets/Common_Widgets/VerveeTopBar.dart';
//
// // ── Colors (existing app palette) ─────────────────────────────────────────────
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
// const kAccentGreen = Color(0xFF639922);
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  COURSE MODEL — abhi static data, baad mein API se replace kar sakte ho
// // ═══════════════════════════════════════════════════════════════════════════════
// class CourseItem {
//   final String title;       // grid pe uppercase title
//   final String name;        // card body title
//   final String createdBy;
//   final String description;
//   final String badge;       // e.g. "Bestseller"
//   final int videoCount;
//   final LinearGradient gradient;
//
//   const CourseItem({
//     required this.title,
//     required this.name,
//     required this.createdBy,
//     required this.description,
//     required this.badge,
//     required this.videoCount,
//     required this.gradient,
//   });
// }
//
// final List<CourseItem> _courses = [
//   CourseItem(
//     title: 'Basic of\ncurrency\ncourse',
//     name: 'Basic course of currency trading',
//     createdBy: 'Created by Vervee Academy',
//     description:
//     'Learn the fundamentals of currency trading, including key analysis '
//         'techniques and live market execution.',
//     badge: 'Bestseller',
//     videoCount: 7,
//     gradient: const LinearGradient(
//       colors: [Color(0xFF2D0A4A), kPurple],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ),
//   ),
//   CourseItem(
//     title: 'Advance\ntechnical\nanalysis',
//     name: 'Advance technical analysis',
//     createdBy: 'Created by Vervee Academy',
//     description:
//     'From candlesticks to market structure: practical, multi-market '
//         'trading techniques.',
//     badge: 'Bestseller',
//     videoCount: 5,
//     gradient: const LinearGradient(
//       colors: [Color(0xFF1A0535), Color(0xFF534AB7)],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ),
//   ),
// ];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  COURSES SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
// class CoursesScreen extends ConsumerStatefulWidget {
//   const CoursesScreen({super.key});
//
//   @override
//   ConsumerState<CoursesScreen> createState() =>
//       _CoursesScreenState();
// }
//
// class _CoursesScreenState
//     extends ConsumerState<CoursesScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//   }
//
//
// // ── Course tap — detail screen pe navigate karo ────────────────────────────
//   void _onCourseTap(BuildContext context, CourseItem course) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
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
//             onSearchTap: () {},
//             onProfile: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ProfileScreen()),
//             ),
//           ),
//           Expanded(child: _buildBody()),
//         ],
//       ),
//       bottomNavigationBar: const SharedBottomNav(currentIndex: 3, popOnHome: true),
//     );
//   }
//
//   // ═════════════════════════════════════════════════════════════════════════════
//   Widget _buildBody() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'All courses',
//               style: TextStyle(
//                 color: kTextPrimary,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${_courses.length} courses available',
//               style: const TextStyle(color: kTextMuted, fontSize: 11),
//             ),
//             const SizedBox(height: 14),
//
//             // ── Course list ─────────────────────────────────────────────────
//             ...List.generate(_courses.length, (i) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: i == _courses.length - 1 ? 0 : 14,
//                 ),
//                 child: _CourseCard(
//                   course: _courses[i],
//                   onTap: () => _onCourseTap(context, _courses[i]),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  COURSE CARD
// // ═══════════════════════════════════════════════════════════════════════════════
// class _CourseCard extends StatelessWidget {
//   final CourseItem course;
//   final VoidCallback onTap;
//
//   const _CourseCard({required this.course, required this.onTap});
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
//             // ── Thumbnail / banner ───────────────────────────────────────
//             Container(
//               height: 130,
//               width: double.infinity,
//               decoration: BoxDecoration(gradient: course.gradient),
//               child: Stack(
//                 children: [
//                   // Left accent bar
//                   Container(
//                     width: 4,
//                     height: double.infinity,
//                     color: kAccentGreen,
//                   ),
//
//                   // Title text
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
//                     child: Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Text(
//                         course.title.toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 1,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Play button overlay
//                   Positioned(
//                     bottom: 10,
//                     right: 12,
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black.withOpacity(0.4),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.5),
//                           width: 1.5,
//                         ),
//                       ),
//                       child: const Icon(Icons.play_arrow_rounded,
//                           color: Colors.white, size: 18),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── Info section ────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     course.name,
//                     style: const TextStyle(
//                       color: kTextPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     course.createdBy,
//                     style: const TextStyle(color: kTextMuted, fontSize: 11),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     course.description,
//                     style: const TextStyle(
//                       color: Color(0xFFB0AECF),
//                       fontSize: 11,
//                       height: 1.6,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Badge + video count row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF412402),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           course.badge,
//                           style: const TextStyle(
//                             color: Color(0xFFFAC775),
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.access_time_rounded,
//                               color: kTextMuted, size: 12),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${course.videoCount} videos',
//                             style: const TextStyle(
//                                 color: kTextMuted, fontSize: 10),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }