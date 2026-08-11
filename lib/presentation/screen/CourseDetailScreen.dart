
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/course/CourseModel.dart';
// import '../domain/course_domain.dart';
// import '../viewmodel/course_viewmodels.dart';
import '../../domain/model/course/CourseProgressModel.dart';
import '../../domain/model/course/LectureModel.dart';
//import '../viewmodal/FinancialLiteracy/FinancialLiteracyViewModel.dart';
import '../viewmodal/course/CoursesViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../widgets/Common_Widgets/ShimmerBox.dart';
import 'CoursePlayerScreen.dart';
import 'PremiumMembershipScreen.dart';

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

// ══════════════════════════════════════════════════════════════
//  COURSE DETAIL SCREEN
// ══════════════════════════════════════════════════════════════
class CourseDetailScreen extends ConsumerStatefulWidget {
  final CourseModel course;           // CoursesScreen se basic model aata hai
  final LinearGradient gradient;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.gradient,
  });

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState
    extends ConsumerState<CourseDetailScreen> {
  int _expandedIndex = -1;
  int _visibleCount = 10;

  // ✅ NEW — Tap pe loading indicator dikhane ke liye (FinancialLiteracyScreen jaisa)
  bool _isTapLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // ✅ NEW — Subscription yahin preload kar lo, taaki "Continue learning"
    // tap karte waqt zyada wait na karna pade
    Future.microtask(() {
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.subscription == null && !subState.isLoading) {
        ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  void _openPlayer(CourseModel course, int lectureIndex) {
    final lecture = course.lectures[lectureIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoursePlayerScreen(
          courseId: course.id,
          lectureId: lecture.id,
          currentIndex: lectureIndex,
          allLectures: course.lectures,
          courseTitle: course.courseTitle,
          gradient: widget.gradient,
        ),
      ),
    );
  }

  // ── Continue learning — progress se last lecture dhundho ─────────────────
  // void _onContinueTap(CourseModel course, CourseProgressModel? progress) {
  //   int startIndex = 0;
  //   if (progress != null) {
  //     final idx =
  //     course.lectures.indexWhere((l) => l.id == progress.lectureId);
  //     if (idx >= 0) startIndex = idx;
  //   }
  //   _openPlayer(course, startIndex);
  // }

  // ✅ CHANGED — Pehle yeh direct player khol deta tha, ab subscription
  // check karta he (FinancialLiteracyScreen ke _onCourseTap jaisa exact pattern)
  void _onContinueTap(CourseModel course, CourseProgressModel? progress) async {
    // ✅ NEW — Agar already tap loading chal rahi hai toh ignore karo
    if (_isTapLoading) return;

    setState(() => _isTapLoading = true);

    try {
      // ✅ NEW — Subscription abhi load ho rahi hai toh uska wait karo
      // Max 3 second wait, uske baad bhi check karega
      final subState = ref.read(subscriptionViewModelProvider);
      if (subState.isLoading) {
        int waited = 0;
        while (ref.read(subscriptionViewModelProvider).isLoading && waited < 30) {
          await Future.delayed(const Duration(milliseconds: 100));
          waited++;
        }
      }

      // ✅ NEW — Agar subscription null hai toh fresh load trigger karo aur wait karo
      if (ref.read(subscriptionViewModelProvider).subscription == null &&
          !ref.read(subscriptionViewModelProvider).isLoading) {
        await ref.read(subscriptionViewModelProvider.notifier).loadSubscription();
      }

      if (!mounted) return;

      final sub = ref.read(subscriptionViewModelProvider).subscription;
      final hasAccess = sub != null && (sub.isActive || sub.isTrialing);

      // ── Purana logic — progress se start index nikalna (waisa hi rakha hai) ──
      int startIndex = 0;
      if (progress != null) {
        final idx =
        course.lectures.indexWhere((l) => l.id == progress.lectureId);
        if (idx >= 0) startIndex = idx;
      }

      if (hasAccess) {
        // Access he toh seedha player khol do
        _openPlayer(course, startIndex);
      } else {
        // ✅ NEW — Access nahi he toh PremiumMembershipScreen pe bhejo.
        // Payment successful hone par hi player khulega
        final paid = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const PremiumMembershipScreen()),
        );
        if (paid == true && mounted) {
          _openPlayer(course, startIndex);
        }
      }
    } finally {
      if (mounted) setState(() => _isTapLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
        courseDetailViewModelProvider(widget.course.id));

    // Fully loaded course use karo, otherwise fallback to passed course
    final course = state.course ?? widget.course;

    return Scaffold(
      backgroundColor: kBgDark,
      // body: Column(
      //   children: [
      //     SizedBox(height: MediaQuery.of(context).padding.top),
      //     _buildBackBar(),
      //     Expanded(
      //       child: state.isLoading
      //           ? _buildShimmer()
      //           : state.errorMessage != null
      //           ? _buildError(state.errorMessage!, course: course, progress: null)
      //           : _buildContent(course, state.progress),
      //     ),
      //   ],
      // ),

      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              _buildBackBar(),
              Expanded(
                child: state.isLoading
                    ? _buildShimmer()
                    : state.errorMessage != null
                    ? _buildError(state.errorMessage!, course: course, progress: null)
                    : _buildContent(course, state.progress),
              ),
            ],
          ),

          // ✅ NEW — Tap loading overlay (subscription check ke dauran)
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
    );
  }

  Widget _buildContent(CourseModel course, CourseProgressModel? progress) {
    // Progress percentage calculate karo
    final int completedIdx = progress != null
        ? (course.lectures.indexWhere((l) => l.id == progress.lectureId) + 1)
        .clamp(0, course.lectures.length)
        : 0;
    final double progressPct = course.lectures.isEmpty
        ? 0
        : completedIdx / course.lectures.length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(course),
          _buildTitleSection(course),
          const SizedBox(height: 16),
          _buildContinueButton(course, progress),
          const SizedBox(height: 16),
          if (progress != null)
            _buildProgressCard(
                course, completedIdx, progressPct),
          if (progress != null) const SizedBox(height: 16),
          _buildIncludesCard(course),
          const SizedBox(height: 16),
          _buildCurriculumSection(course),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Back Bar ─────────────────────────────────────────────────
  Widget _buildBackBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(
        color: kBgCard,
        border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPurpleLight, size: 18),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course details',
                style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            Text('All courses',
                style: TextStyle(color: kTextMuted, fontSize: 10)),
          ],
        ),
      ]),
    );
  }

  // ── Hero Banner with thumbnail ────────────────────────────────
  Widget _buildHeroBanner(CourseModel course) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      height: 160,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(children: [
        // Thumbnail
        Positioned.fill(
          child: Image.network(
            course.thumbnailPreview,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
        Container(color: Colors.black.withOpacity(0.4)),
        Container(width: 4, height: double.infinity, color: kAccentGreen),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              course.courseTitle.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                height: 1.3,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 12,
          child: Container(
            width: 38,
            height: 38,
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
      ]),
    );
  }

  // ── Title + Description ───────────────────────────────────────
  Widget _buildTitleSection(CourseModel course) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.courseTitle,
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            course.subtitle,
            style: const TextStyle(
              color: Color(0xFFB0AECF),
              fontSize: 11,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress card — only if progress available ─────────────────
  Widget _buildProgressCard(
      CourseModel course, int completed, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kBgCard,
          border: Border.all(color: kBorder, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.courseTitle,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            _gradientBar(progress: pct, height: 5),
            const SizedBox(height: 4),
            Text(
              '${(pct * 100).round()}% complete · $completed of ${course.lectures.length} lectures',
              style: const TextStyle(fontSize: 10, color: kTextMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ── Continue Button ───────────────────────────────────────────
  Widget _buildContinueButton(
      CourseModel course, CourseProgressModel? progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _openPlayer(course, 0),//_onContinueTap(course, progress),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kPurple, kPurpleLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Continue learning',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── This Course Includes ──────────────────────────────────────
  Widget _buildIncludesCard(CourseModel course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THIS COURSE INCLUDES',
              style: TextStyle(
                color: kGold,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            _includeRow(Icons.videocam_outlined, 'On-demand video content'),
            const SizedBox(height: 10),
            _includeRow(
                Icons.description_outlined, 'Category: ${course.category}'),
            const SizedBox(height: 10),
            _includeRow(
                Icons.translate_rounded, 'Language: ${course.language}'),
            const SizedBox(height: 10),
            _includeRow(
                Icons.bar_chart_rounded, 'Level: ${course.courseLevel}'),
          ],
        ),
      ),
    );
  }

  Widget _includeRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: kPurpleLight, size: 16),
      const SizedBox(width: 10),
      Text(text,
          style: const TextStyle(color: kTextPrimary, fontSize: 12)),
    ]);
  }

  // ── Course Curriculum Section ─────────────────────────────────
  Widget _buildCurriculumSection(CourseModel course) {
    final visibleLectures = course.lectures.take(_visibleCount).toList();
    final hasMore = _visibleCount < course.lectures.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course curriculum',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${course.lectures.length} lectures in this course',
            style: const TextStyle(color: kTextMuted, fontSize: 11),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder, width: 0.5),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: List.generate(visibleLectures.length, (i) {
                return _LectureTile(
                  lecture: visibleLectures[i],
                  isExpanded: _expandedIndex == i,
                  showTopBorder: i > 0,
                  onTap: () => _toggleExpand(i),
                  onPlay: () => _openPlayer(course, i),
                );
              }),
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _visibleCount += 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: kBgCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBorder, width: 0.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: kPurpleLight, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Load More',
                      style: TextStyle(
                        color: kPurpleLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildShimmer() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 160,
  //           decoration: BoxDecoration(
  //             color: kBgCard,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //         ),
  //         const SizedBox(height: 14),
  //         ...List.generate(
  //           4,
  //               (_) => Container(
  //             margin: const EdgeInsets.only(bottom: 10),
  //             height: 14,
  //             width: double.infinity,
  //             color: kBgCard,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ShimmerBox(width: double.infinity, height: 160, radius: 12), // 👈 UPDATED
          const SizedBox(height: 14),
          const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
          const SizedBox(height: 10),
          const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
          const SizedBox(height: 10),
          const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
          const SizedBox(height: 10),
          const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
        ],
      ),
    );
  }

  Widget _buildError(String message,
      {required CourseModel course, required CourseProgressModel? progress}) {
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
              onTap: () => ref
                  .read(courseDetailViewModelProvider(widget.course.id)
                  .notifier),
                 // .fetchCourseDetail(),
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

  Widget _gradientBar({required double progress, required double height}) {
    return LayoutBuilder(
      builder: (_, constraints) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: kBorder),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: constraints.maxWidth * progress,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [kPurple, kPurpleLight]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LECTURE TILE
// ══════════════════════════════════════════════════════════════
class _LectureTile extends StatelessWidget {
  final LectureModel lecture;
  final bool isExpanded;
  final bool showTopBorder;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  const _LectureTile({
    required this.lecture,
    required this.isExpanded,
    required this.showTopBorder,
    required this.onTap,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isExpanded
                  ? const Color(0xFF1A0535)
                  : Colors.transparent,
              border: showTopBorder
                  ? const Border(
                  top: BorderSide(color: kBorder, width: 0.5))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isExpanded
                            ? kPurple.withOpacity(0.2)
                            : kBorder.withOpacity(0.6),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: isExpanded ? kGold : kTextMuted,
                        size: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lecture.lectureTitle,
                        style: TextStyle(
                          color: isExpanded
                              ? kTextPrimary
                              : const Color(0xFFB0AECF),
                          fontSize: 12,
                          fontWeight: isExpanded
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                Row(children: [
                  Text(lecture.duration,
                      style: const TextStyle(
                          color: kTextMuted, fontSize: 10)),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: kPurpleLight,
                    size: 16,
                  ),
                ]),
              ],
            ),
          ),
        ),

        // Expanded section
        if (isExpanded)
          Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kBorder, width: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // aboutLecture HTML hai — simple text show karo
                // Agar flutter_html use karte ho to Html(data: lecture.aboutLecture) use karo
                Text(
                  _stripHtml(lecture.aboutLecture),
                  style: const TextStyle(
                    color: Color(0xFFB0AECF),
                    fontSize: 11,
                    height: 1.7,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // GestureDetector(
                //   onTap: onPlay,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 14, vertical: 8),
                //     decoration: BoxDecoration(
                //       color: kPurple.withOpacity(0.2),
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(color: kPurple, width: 0.5),
                //     ),
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.play_arrow_rounded,
                //             color: kGold, size: 14),
                //         SizedBox(width: 6),
                //         Text(
                //           'Play lecture',
                //           style: TextStyle(
                //             color: kGold,
                //             fontSize: 11,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
      ],
    );
  }

  // Simple HTML tag stripper — flutter_html nahi use kar rahe to kaam aayega
  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}








//--------------------------------------------- Without API ---------------------------------------------------->








// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'CoursePlayerScreen.dart';
// import 'CoursesScreen.dart'; // colors + CourseItem import
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  LECTURE MODELS — abhi static data, baad mein API se replace kar sakte ho
// // ═══════════════════════════════════════════════════════════════════════════════
//
// class LearningPoint {
//   final String text;
//   const LearningPoint(this.text);
// }
//
// class LectureItem {
//   final String title;
//   final String duration;
//   final String? chapterTitle;
//   final String? topicTitle;
//   final String? description;
//   final List<LearningPoint> learningPoints;
//
//   const LectureItem({
//     required this.title,
//     required this.duration,
//     this.chapterTitle,
//     this.topicTitle,
//     this.description,
//     this.learningPoints = const [],
//   });
//
//   bool get hasDetails => chapterTitle != null || description != null;
// }
//
// final List<LectureItem> _lectures = [
//   LectureItem(
//     title: 'History of the forex market',
//     duration: '02:00',
//     chapterTitle: 'Chapter 1: The currency trading market',
//     topicTitle: 'Topic 1: History of the forex market',
//     description:
//     'Welcome to the fascinating origin story of forex! In this lesson, '
//         'we take you on a time-traveling journey from the ancient days of '
//         'barter to the ultra-modern, digital 24/5 forex market we know today.',
//     learningPoints: [
//       LearningPoint('How early civilizations exchanged value before money'),
//       LearningPoint('The role of the gold standard and Bretton Woods'),
//     ],
//   ),
//   LectureItem(
//     title: 'Major currency pairs explained',
//     duration: '04:30',
//     chapterTitle: 'Chapter 1: The currency trading market',
//     topicTitle: 'Topic 2: Major currency pairs explained',
//     description:
//     'Every currency in forex is traded in pairs, and not all pairs are '
//         'created equal. In this lesson, we break down the difference between '
//         'major, minor, and exotic pairs, and why some pairs move the market '
//         'far more than others.',
//     learningPoints: [
//       LearningPoint('What makes a pair a "major" (like EUR/USD or GBP/USD)'),
//       LearningPoint('The difference between majors, minors, and exotics'),
//       LearningPoint('Why liquidity and spread vary across different pairs'),
//     ],
//   ),
//   LectureItem(
//     title: 'How exchange rates are determined',
//     duration: '06:15',
//     chapterTitle: 'Chapter 1: The currency trading market',
//     topicTitle: 'Topic 3: How exchange rates are determined',
//     description:
//     'Ever wondered why a currency goes up one day and crashes the next? '
//         'In this lesson, we explore the real forces behind exchange rate '
//         'movements — from central bank decisions to global economic events.',
//     learningPoints: [
//       LearningPoint('How supply and demand drive currency prices'),
//       LearningPoint('The role of interest rates and central bank policy'),
//       LearningPoint('How inflation, GDP, and geopolitical events impact rates'),
//     ],
//   ),
// ];
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
// //  COURSE DETAIL SCREEN
// // ═══════════════════════════════════════════════════════════════════════════════
// class CourseDetailScreen extends StatefulWidget {
//   final CourseItem course;
//
//   const CourseDetailScreen({super.key, required this.course});
//
//   @override
//   State<CourseDetailScreen> createState() => _CourseDetailScreenState();
// }
//
// class _CourseDetailScreenState extends State<CourseDetailScreen> {
//   // ── Currently expanded lecture index (-1 = sab collapsed) ──────────────────
//   int _expandedIndex = -1;
//   int _visibleCount = 10;   // ← ADD
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
//   void _toggleExpand(int index) {
//     setState(() {
//       _expandedIndex = _expandedIndex == index ? -1 : index;
//     });
//   }
//
//   // ── Continue Learning tap — CoursePlayerScreen screen pe navigate karo ────────────────────────────
//   void _onCourseTap(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CoursePlayerScreen()),
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
//           SizedBox(height: MediaQuery.of(context).padding.top),
//           _buildBackBar(),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeroBanner(),
//                   _buildTitleSection(),
//                   const SizedBox(height: 16),
//                   _buildContinueButton(),
//                   const SizedBox(height: 16),
//                   _buildIncludesCard(),
//                   const SizedBox(height: 16),
//                   _buildCurriculumSection(),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Back Bar ───────────────────────────────────────────────────────────────
//   Widget _buildBackBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Row(children: [
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: kPurpleLight, size: 18),
//         ),
//         const SizedBox(width: 10),
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Course details',
//                 style: TextStyle(
//                     color: kTextPrimary,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600)),
//             Text('All courses',
//                 style: TextStyle(color: kTextMuted, fontSize: 10)),
//           ],
//         ),
//       ]),
//     );
//   }
//
//   // ── Hero Banner ────────────────────────────────────────────────────────────
//   Widget _buildHeroBanner() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//       height: 150,
//       decoration: BoxDecoration(
//         gradient: widget.course.gradient,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Stack(children: [
//         // Left accent bar
//         Container(width: 4, height: double.infinity, color: kAccentGreen),
//
//         // Title text
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
//           child: Align(
//             alignment: Alignment.bottomLeft,
//             child: Text(
//               widget.course.title.toUpperCase(),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 1,
//                 height: 1.3,
//               ),
//             ),
//           ),
//         ),
//
//         // Play overlay
//         Positioned(
//           bottom: 10,
//           right: 12,
//           child: Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black.withOpacity(0.4),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.5),
//                 width: 1.5,
//               ),
//             ),
//             child: const Icon(Icons.play_arrow_rounded,
//                 color: Colors.white, size: 18),
//           ),
//         ),
//       ]),
//     );
//   }
//
//   // ── Title + Description ───────────────────────────────────────────────────
//   Widget _buildTitleSection() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.course.name,
//             style: const TextStyle(
//               color: kTextPrimary,
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               height: 1.35,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             widget.course.description,
//             style: const TextStyle(
//               color: Color(0xFFB0AECF),
//               fontSize: 11,
//               height: 1.7,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Continue Learning Button ──────────────────────────────────────────────
//   Widget _buildContinueButton() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: GestureDetector(
//         onTap: () {
//
//           _onCourseTap(context);
//           // pehle lecture / last-watched lecture pe navigate karo
//
//         },
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 13),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [kPurple, kPurpleLight],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
//               SizedBox(width: 8),
//               Text(
//                 'Continue learning',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── This Course Includes Card ─────────────────────────────────────────────
//   Widget _buildIncludesCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: kBgCard,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: kBorder, width: 0.5),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'THIS COURSE INCLUDES',
//               style: TextStyle(
//                 color: kGold,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _includeRow(Icons.videocam_outlined, 'On-demand video content'),
//             const SizedBox(height: 10),
//             _includeRow(Icons.description_outlined,
//                 'Category: Currency trading'),
//             const SizedBox(height: 10),
//             _includeRow(Icons.translate_rounded, 'Language: English'),
//             const SizedBox(height: 10),
//             _includeRow(Icons.bar_chart_rounded, 'Level: Beginner'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _includeRow(IconData icon, String text) {
//     return Row(children: [
//       Icon(icon, color: kPurpleLight, size: 16),
//       const SizedBox(width: 10),
//       Text(text, style: const TextStyle(color: kTextPrimary, fontSize: 12)),
//     ]);
//   }
//
//   // ── Course Curriculum Section ─────────────────────────────────────────────
//   Widget _buildCurriculumSection() {
//     final visibleLectures = _lectures.take(_visibleCount).toList();
//     final hasMore = _visibleCount < _lectures.length;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Course curriculum',
//             style: TextStyle(
//               color: kTextPrimary,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             '${_lectures.length} lectures in this course',
//             style: const TextStyle(color: kTextMuted, fontSize: 11),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               color: kBgCard,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: kBorder, width: 0.5),
//             ),
//             clipBehavior: Clip.hardEdge,
//             child: Column(
//               children: List.generate(visibleLectures.length, (i) {
//                 return _LectureTile(
//                   lecture: visibleLectures[i],
//                   isExpanded: _expandedIndex == i,
//                   showTopBorder: i > 0,
//                   onTap: () => _toggleExpand(i),
//                 );
//               }),
//             ),
//           ),
//
//           // ── Load More button ───────────────────────────────────────────
//           if (hasMore) ...[
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () => setState(() => _visibleCount += 10),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: kBgCard,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: kBorder, width: 0.5),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.keyboard_arrow_down_rounded,
//                         color: kPurpleLight, size: 18),
//                     SizedBox(width: 6),
//                     Text(
//                       'Load More',
//                       style: TextStyle(
//                         color: kPurpleLight,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  LECTURE TILE — header row + expandable details
// // ═══════════════════════════════════════════════════════════════════════════════
// class _LectureTile extends StatelessWidget {
//   final LectureItem lecture;
//   final bool isExpanded;
//   final bool showTopBorder;
//   final VoidCallback onTap;
//
//   const _LectureTile({
//     required this.lecture,
//     required this.isExpanded,
//     required this.showTopBorder,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ── Header row ─────────────────────────────────────────────────────
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: isExpanded ? const Color(0xFF1A0535) : Colors.transparent,
//               border: showTopBorder
//                   ? const Border(top: BorderSide(color: kBorder, width: 0.5))
//                   : null,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Row(children: [
//                     Container(
//                       width: 26,
//                       height: 26,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: isExpanded
//                             ? kPurple.withOpacity(0.2)
//                             : kBorder.withOpacity(0.6),
//                       ),
//                       child: Icon(
//                         Icons.play_arrow_rounded,
//                         color: isExpanded ? kGold : kTextMuted,
//                         size: 13,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         lecture.title,
//                         style: TextStyle(
//                           color: isExpanded ? kTextPrimary : const Color(0xFFB0AECF),
//                           fontSize: 12,
//                           fontWeight:
//                           isExpanded ? FontWeight.w600 : FontWeight.w400,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ]),
//                 ),
//                 const SizedBox(width: 8),
//                 Row(children: [
//                   Text(lecture.duration,
//                       style: const TextStyle(color: kTextMuted, fontSize: 10)),
//                  // if (lecture.hasDetails) ...[
//                     const SizedBox(width: 6),
//                     Icon(
//                       isExpanded
//                           ? Icons.keyboard_arrow_up_rounded
//                           : Icons.keyboard_arrow_down_rounded,
//                       color: kPurpleLight,
//                       size: 16,
//                     ),
//                  // ],
//                 ]),
//               ],
//             ),
//           ),
//         ),
//
//         // ── Expanded details ─────────────────────────────────────────────────
//         if (isExpanded && lecture.hasDetails)
//           Container(
//             padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//             decoration: const BoxDecoration(
//               border: Border(top: BorderSide(color: kBorder, width: 0.5)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 12),
//
//                 if (lecture.chapterTitle != null)
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.bookmark_outline_rounded,
//                           color: kGold, size: 14),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           lecture.chapterTitle!,
//                           style: const TextStyle(
//                               color: kGold,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 if (lecture.topicTitle != null) ...[
//                   const SizedBox(height: 10),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.lightbulb_outline_rounded,
//                           color: kPurpleLight, size: 14),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           lecture.topicTitle!,
//                           style: const TextStyle(
//                               color: kTextPrimary,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//
//                 if (lecture.description != null) ...[
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 22),
//                     child: Text(
//                       lecture.description!,
//                       style: const TextStyle(
//                           color: Color(0xFFB0AECF), fontSize: 11, height: 1.7),
//                     ),
//                   ),
//                 ],
//
//                 if (lecture.learningPoints.isNotEmpty) ...[
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 22),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Here is what you will learn:',
//                           style: TextStyle(
//                               color: kTextPrimary,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 6),
//                         ...lecture.learningPoints.map((p) => Padding(
//                           padding: const EdgeInsets.only(bottom: 6),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsets.only(top: 3),
//                                 child: Icon(Icons.circle,
//                                     color: kGold, size: 6),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   p.text,
//                                   style: const TextStyle(
//                                       color: Color(0xFFB0AECF),
//                                       fontSize: 11,
//                                       height: 1.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }