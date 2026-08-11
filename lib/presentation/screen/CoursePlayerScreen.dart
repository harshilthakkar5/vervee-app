import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../domain/model/course/LectureModel.dart';
import '../viewmodal/course/CoursesState.dart';
import '../viewmodal/course/CoursesViewModel.dart';
import '../widgets/Common_Widgets/ShimmerBox.dart';

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

class CoursePlayerScreen extends ConsumerStatefulWidget {
  final int courseId;
  final int lectureId;
  final int currentIndex;
  final List<LectureModel> allLectures;
  final String courseTitle;
  final LinearGradient gradient;

  const CoursePlayerScreen({
    super.key,
    required this.courseId,
    required this.lectureId,
    required this.currentIndex,
    required this.allLectures,
    required this.courseTitle,
    required this.gradient,
  });

  @override
  ConsumerState<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends ConsumerState<CoursePlayerScreen> {
  int _tab = 0;
  late final CoursePlayerArgs _args;

  // ── Video player state ─────────────────────────────────────────
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _videoError       = false;
  bool _isFullscreen     = false;
  final _seekBarKey      = GlobalKey();
  int _visibleLectureCount = 10;

  bool _completionHandled = false;
  bool _autoPlayNext = false;

  @override
  void initState() {
    super.initState();
    _args = (
    courseId:     widget.courseId,
    lectureId:    widget.lectureId,
    currentIndex: widget.currentIndex,
    allLectures:  widget.allLectures,
    );
  }

  // @override
  // void dispose() {
  //   _videoController?.dispose();
  //   super.dispose();
  // }

  @override
  void dispose() {
    _videoController?.removeListener(_handleVideoCompletion); // ✅ CHANGE 3: leak/crash avoid karo
    _videoController?.dispose();
    super.dispose();
  }

  // ── Init video ─────────────────────────────────────────────────
  // Future<void> _initVideo(String? url) async {
  //   if (url == null || url.isEmpty) return;
  //
  //   _videoController?.dispose();
  //   setState(() {
  //     _videoInitialized = false;
  //     _videoError       = false;
  //     _completionHandled = false;
  //   });
  //
  //   final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
  //   _videoController = ctrl;
  //
  //   try {
  //     await ctrl.initialize();
  //     if (mounted) setState(() => _videoInitialized = true);
  //   } catch (_) {
  //     if (mounted) setState(() => _videoError = true);
  //   }
  // }

  Future<void> _initVideo(String? url) async {
    if (url == null || url.isEmpty) return;

    _videoController?.dispose();
    setState(() {
      _videoInitialized = false;
      _videoError       = false;
      _completionHandled = false; // ✅ CHANGE 2a: naye video ke liye completion-flag reset karo
    });

    final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController = ctrl;

    try {
      await ctrl.initialize();
      if (mounted) {
        setState(() => _videoInitialized = true);
        ctrl.addListener(_handleVideoCompletion); // ✅ CHANGE 2b: completion listener lagao

        // ✅ CHANGE 2c: agar ye video "auto advance" se aaya he to turant play karo
        if (_autoPlayNext) {
          _autoPlayNext = false;
          ctrl.play();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  // ✅ CHANGE 2d: video ki progress track karta he — jab video end ke close pahuchta he
  // to automatically next lecture pe switch + play karta he
  void _handleVideoCompletion() {
    final ctrl = _videoController;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (_completionHandled) return;

    final pos = ctrl.value.position;
    final dur = ctrl.value.duration;

    // duration valid ho aur position duration ke bahut kareeb (ya barabar) ho, tabhi "complete" maano
    if (dur.inMilliseconds > 0 &&
        pos.inMilliseconds >= dur.inMilliseconds - 300) {
      _completionHandled = true; // dobara trigger na ho isliye lock kar diya
      _goToNextLectureAutomatically();
    }
  }

  // ✅ CHANGE 2e: next lecture pe switch karke auto-play flag set karta he
  void _goToNextLectureAutomatically() {
    final state = ref.read(coursePlayerViewModelProvider(_args));
    final currentIdx = state.currentIndex;
    final nextIdx = currentIdx + 1;

    // Agar aur lectures bache hi nahi he to kuch mat karo
    if (nextIdx >= widget.allLectures.length) return;

    _autoPlayNext = true; // ✅ agla video load hote hi play ho jayega

    _videoController?.removeListener(_handleVideoCompletion);
    _videoController?.dispose();
    _videoController = null;

    setState(() {
      _videoInitialized = false;
      _videoError       = false;
    });

    ref
        .read(coursePlayerViewModelProvider(_args).notifier)
        .switchLecture(nextIdx);
  }

  // ── Fullscreen ─────────────────────────────────────────────────
  Future<void> _openFullscreen() async {
    if (_videoController == null || !_videoInitialized) return;
    setState(() => _isFullscreen = true);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _FullscreenVideoPage(controller: _videoController!),
    ));
    if (!mounted) return;
    setState(() => _isFullscreen = false);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coursePlayerViewModelProvider(_args));

    // Jab lecture load ho — video init karo
    ref.listen(coursePlayerViewModelProvider(_args), (prev, next) {
      final url = next.lecture?.contentUpload;
      final prevUrl = prev?.lecture?.contentUpload;
      if (url != null && url != prevUrl && !_videoInitialized && !_videoError) {
        _initVideo(url);
      }
    });

    return Scaffold(
      backgroundColor: kBgDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(state),
            Expanded(
              child: state.isLoading
                  ? _buildShimmer()
                  : state.errorMessage != null
                  ? _buildError(state.errorMessage!)
                  : _buildContent(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CoursePlayerState state) {
    final lecture = state.lecture;
    if (lecture == null) return const SizedBox();

    final totalLectures = widget.allLectures.length;
    final currentIdx    = state.currentIndex;
    final progressPct   = totalLectures > 0 ? (currentIdx + 1) / totalLectures : 0.0;

    // Pehli baar lecture milte hi video load karo
    if (!_videoInitialized && !_videoError && _videoController == null) {
      _initVideo(lecture.contentUpload);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoPlayer(lecture),
          _buildVideoControls(),
          _buildLectureTitle(lecture),
          _buildCourseProgressCard(
            widget.courseTitle,
            progressPct,
            currentIdx + 1,
            totalLectures,
          ),
          _buildTabRow(),
          if (_tab == 0) _buildLectureDetailsCard(lecture),
          _buildCourseLectures(state),
        ],
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────
  Widget _buildTopBar(CoursePlayerState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: kBgCard,
        border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: kPurpleLight),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Preview course',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Courses / ${widget.courseTitle}',
                    style: const TextStyle(fontSize: 10, color: kTextMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Video Player ───────────────────────────────────────────────
  Widget _buildVideoPlayer(LectureModel lecture) {
    return Container(
      height: 210,
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          if (_videoInitialized && _videoController != null) {
            setState(() {
              _videoController!.value.isPlaying
                  ? _videoController!.pause()
                  : _videoController!.play();
            });
          }
        },
        child: SizedBox(
          width: double.infinity,
          height: 210,
          child: _buildVideoContent(lecture),
        ),
      ),
    );
  }

  Widget _buildVideoContent(LectureModel lecture) {
    // ── Video initialized — show karo ──────────────────────────
    if (_videoInitialized && _videoController != null) {
      return Stack(fit: StackFit.expand, children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width:  _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child:  VideoPlayer(_videoController!),
          ),
        ),
        // Pause overlay
        if (!_videoController!.value.isPlaying)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(
              child: Icon(Icons.play_circle_outline_rounded,
                  color: Colors.white, size: 56),
            ),
          ),
        // Fullscreen button
        Positioned(
          top: 10, right: 10,
          child: GestureDetector(
            onTap: _openFullscreen,
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: const Icon(Icons.fullscreen_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ]);
    }

    // ── Error ──────────────────────────────────────────────────
    if (_videoError) {
      return Container(
        color: kBgCard,
        child: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.broken_image_outlined, color: kTextMuted, size: 40),
            SizedBox(height: 8),
            Text('Video unavailable',
                style: TextStyle(color: kTextMuted, fontSize: 12)),
          ]),
        ),
      );
    }

    // ── Loading / placeholder ──────────────────────────────────
    return Container(
      decoration: BoxDecoration(gradient: widget.gradient),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('VERVEE',
            style: TextStyle(
                color: kGold, fontSize: 14,
                fontWeight: FontWeight.w900, letterSpacing: 3)),
        const Text('A C A D E M Y',
            style: TextStyle(
                color: kPurpleLight, fontSize: 7, letterSpacing: 3)),
        const SizedBox(height: 14),
        if (_videoController == null && (lecture.contentUpload.isEmpty))
          const Icon(Icons.play_circle_outline_rounded,
              color: Colors.white54, size: 44)
        else
          const SizedBox(
            width: 32, height: 32,
            child: CircularProgressIndicator(color: kGold, strokeWidth: 2),
          ),
      ]),
    );
  }

  // ── Video Controls ─────────────────────────────────────────────
  Widget _buildVideoControls() {
    return Container(
      color: kBgDeep,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: _videoInitialized && _videoController != null
          ? _buildRealControls()
          : _buildPlaceholderControls(),
    );
  }

  Widget _buildRealControls() {
    return ValueListenableBuilder(
      valueListenable: _videoController!,
      builder: (_, value, __) {
        final pos      = value.position;
        final dur      = value.duration;
        final progress = dur.inMilliseconds > 0
            ? pos.inMilliseconds / dur.inMilliseconds
            : 0.0;

        String fmt(Duration d) {
          final m = d.inMinutes;
          final s = (d.inSeconds % 60).toString().padLeft(2, '0');
          return '$m:$s';
        }

        void seekTo(Offset globalPos) {
          final box = _seekBarKey.currentContext?.findRenderObject() as RenderBox?;
          if (box == null) return;
          final local = box.globalToLocal(globalPos);
          final ratio = (local.dx / box.size.width).clamp(0.0, 1.0);
          _videoController!.seekTo(dur * ratio);
        }

        return Row(children: [
          // Play/Pause
          GestureDetector(
            onTap: () => value.isPlaying
                ? _videoController!.pause()
                : _videoController!.play(),
            child: Icon(
              value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: kPurpleLight, size: 18,
            ),
          ),
          const SizedBox(width: 8),

          // Seek bar
          Expanded(
            child: GestureDetector(
              onTapDown:            (d) => seekTo(d.globalPosition),
              onHorizontalDragUpdate: (d) => seekTo(d.globalPosition),
              child: Container(
                key: _seekBarKey,
                height: 20,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 4,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: kBorder,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kPurple,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Time
          Text('${fmt(pos)} / ${fmt(dur)}',
              style: const TextStyle(color: kTextMuted, fontSize: 9)),
          const SizedBox(width: 8),

          // Volume
          GestureDetector(
            onTap: () => value.volume > 0
                ? _videoController!.setVolume(0)
                : _videoController!.setVolume(1),
            child: Icon(
              value.volume > 0 ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: kPurpleLight, size: 16,
            ),
          ),
          const SizedBox(width: 8),

          // Fullscreen
          GestureDetector(
            onTap: _openFullscreen,
            child: const Icon(Icons.fullscreen_rounded, color: kPurpleLight, size: 18),
          ),
        ]);
      },
    );
  }

  Widget _buildPlaceholderControls() {
    return Row(children: [
      const Icon(Icons.play_arrow_rounded, color: kPurpleLight, size: 18),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          height: 4,
          decoration: BoxDecoration(
              color: kBorder, borderRadius: BorderRadius.circular(2)),
        ),
      ),
      const SizedBox(width: 8),
      const Text('--:-- / --:--',
          style: TextStyle(color: kTextMuted, fontSize: 9)),
    ]);
  }

  // ── Lecture title, progress card, tabs — same as before ───────
  Widget _buildLectureTitle(LectureModel lecture) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(children: [
        Expanded(
          child: Text(lecture.lectureTitle,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        const SizedBox(width: 8),
        Text(lecture.duration,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: kGold)),
      ]),
    );
  }

  Widget _buildCourseProgressCard(
      String courseTitle, double pct, int current, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kBgCard,
          border: Border.all(color: kBorder, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(courseTitle,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 6),
          _gradientBar(progress: pct, height: 5),
          const SizedBox(height: 4),
          Text('${(pct * 100).round()}% complete · $current of $total lectures',
              style: const TextStyle(fontSize: 10, color: kTextMuted)),
        ]),
      ),
    );
  }

  Widget _buildTabRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorder, width: 0.5))),
      child: Row(children: [
        _tabItem(0, Icons.description_outlined, 'Lecture details'),
        const SizedBox(width: 20),
        _tabItem(1, Icons.attach_file, 'Resources'),
      ]),
    );
  }

  Widget _tabItem(int index, IconData icon, String label) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: active ? kGold : Colors.transparent, width: 2)),
        ),
        child: Row(children: [
          Icon(icon, size: 14, color: active ? kGold : kTextMuted),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? kGold : kTextMuted)),
        ]),
      ),
    );
  }

  // Widget _buildLectureDetailsCard(LectureModel lecture) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
  //     child: Container(
  //       padding: const EdgeInsets.all(14),
  //       decoration: BoxDecoration(
  //         color: kBgCard,
  //         border: Border.all(color: kBorder, width: 0.5),
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //           const Icon(Icons.bookmark_rounded, color: kGold, size: 14),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: Text(lecture.lectureTitle,
  //                 style: const TextStyle(
  //                     color: kGold, fontSize: 11, fontWeight: FontWeight.w600)),
  //           ),
  //         ]),
  //         const SizedBox(height: 10),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 22),
  //           child: Text(_stripHtml(lecture.aboutLecture),
  //               style: const TextStyle(
  //                   color: Color(0xFFB0AECF), fontSize: 11, height: 1.7)),
  //         ),
  //       ]),
  //     ),
  //   );
  // }

  // ── Lecture Details Card — READ MORE added ────────────────────
  Widget _buildLectureDetailsCard(LectureModel lecture) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kBgCard,
          border: Border.all(color: kBorder, width: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.bookmark_rounded, color: kGold, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(lecture.lectureTitle,
                  style: const TextStyle(
                      color: kGold, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          // ── CHANGE 1: ReadMore widget added ──────────────────
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: _ReadMoreText(
              text: _stripHtml(lecture.aboutLecture),
              trimLines: 4,
            ),
          ),
        ]),
      ),
    );
  }

  // ── Course Lectures List ───────────────────────────────────────
  // Widget _buildCourseLectures(CoursePlayerState state) {
  //   final lectures   = widget.allLectures;
  //   final currentIdx = state.currentIndex;
  //
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           const Text('Course lectures',
  //               style: TextStyle(
  //                   fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
  //           Text('${currentIdx + 1} / ${lectures.length}',
  //               style: const TextStyle(fontSize: 10, color: kTextMuted)),
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //       Container(
  //         clipBehavior: Clip.antiAlias,
  //         decoration: BoxDecoration(
  //           color: kBgCard,
  //           border: Border.all(color: kBorder, width: 0.5),
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //         child: Column(
  //           children: List.generate(lectures.length, (i) {
  //             return _lectureItem(
  //               index:       i,
  //               lecture:     lectures[i],
  //               isActive:    i == currentIdx,
  //               showDivider: i > 0,
  //               onTap: () {
  //                 // Video dispose karo — naya lecture load hoga
  //                 _videoController?.dispose();
  //                 _videoController = null;
  //                 setState(() {
  //                   _videoInitialized = false;
  //                   _videoError       = false;
  //                 });
  //                 ref
  //                     .read(coursePlayerViewModelProvider(_args).notifier)
  //                     .switchLecture(i);
  //               },
  //             );
  //           }),
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  Widget _buildCourseLectures(CoursePlayerState state) {
    final lectures   = widget.allLectures;
    final currentIdx = state.currentIndex;

    // ── CHANGE 2a: visibleLectures — sirf _visibleLectureCount tak ──
    final visibleLectures = lectures.take(_visibleLectureCount).toList();
    final hasMore = _visibleLectureCount < lectures.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Course lectures',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            Text('${currentIdx + 1} / ${lectures.length}',
                style: const TextStyle(fontSize: 10, color: kTextMuted)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: kBgCard,
            border: Border.all(color: kBorder, width: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          // ── CHANGE 2b: visibleLectures use karo, lectures nahi ──
          child: Column(
            children: List.generate(visibleLectures.length, (i) {
              return _lectureItem(
                index:       i,
                lecture:     visibleLectures[i],
                isActive:    i == currentIdx,
                showDivider: i > 0,
                // onTap: () {
                //   _videoController?.dispose();
                //   _videoController = null;
                //   setState(() {
                //     _videoInitialized = false;
                //     _videoError       = false;
                //   });
                //   ref
                //       .read(coursePlayerViewModelProvider(_args).notifier)
                //       .switchLecture(i);
                // },
                onTap: () {
                  _videoController?.removeListener(_handleVideoCompletion); // ✅ CHANGE 4a
                  _videoController?.dispose();
                  _videoController = null;
                  _autoPlayNext = false; // ✅ CHANGE 4b: manual tap pe auto-play force mat karo
                  setState(() {
                    _videoInitialized = false;
                    _videoError       = false;
                  });
                  ref
                      .read(coursePlayerViewModelProvider(_args).notifier)
                      .switchLecture(i);
                },
              );
            }),
          ),
        ),

        // ── CHANGE 2c: Load More button — CourseDetailScreen jaisa ──
        if (hasMore) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _visibleLectureCount += 10), // ← +10 load karo
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
      ]),
    );
  }

  Widget _lectureItem({
    required int index,
    required LectureModel lecture,
    required bool isActive,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
              colors: [Color(0x407C3AED), Color(0x0D9333EA)])
              : null,
          border: showDivider
              ? const Border(top: BorderSide(color: kBorder, width: 0.5))
              : null,
        ),
        child: Row(children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? kGold : kBorder),
            child: Center(
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive ? const Color(0xFF1A0535) : kTextMuted)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lecture.lectureTitle,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? Colors.white : const Color(0xFFB0AECF))),
              const SizedBox(height: 2),
              Text(lecture.duration,
                  style: const TextStyle(fontSize: 9.5, color: kTextMuted)),
            ]),
          ),
          if (isActive)
            const Icon(Icons.play_arrow_rounded, size: 14, color: kGold),
        ]),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────
  Widget _gradientBar({required double progress, required double height}) {
    return LayoutBuilder(
      builder: (_, constraints) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: SizedBox(
          height: height,
          child: Stack(fit: StackFit.expand, children: [
            Container(color: kBorder),
            Positioned(
              left: 0, top: 0, bottom: 0,
              width: constraints.maxWidth * progress,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [kPurple, kGold])),
              ),
            ),
          ]),
        ),
      ),
    );
  }

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

  // Widget _buildShimmer() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(children: [
  //       Container(height: 210, color: kBgCard,
  //           margin: const EdgeInsets.only(bottom: 14)),
  //       ...List.generate(3, (_) => Container(
  //           height: 14, color: kBgCard,
  //           margin: const EdgeInsets.only(bottom: 10))),
  //     ]),
  //   );
  // }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const ShimmerBox(width: double.infinity, height: 210, radius: 0), // 👈 UPDATED
        const SizedBox(height: 14),
        const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
        const SizedBox(height: 10),
        const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
        const SizedBox(height: 10),
        const ShimmerBox(width: double.infinity, height: 14), // 👈 UPDATED
      ]),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: kTextMuted, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => ref
                .read(coursePlayerViewModelProvider(_args).notifier)
                .fetchLecture(widget.lectureId),
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
      ),
    );
  }
}

// ── Fullscreen Page ────────────────────────────────────────────
class _FullscreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  const _FullscreenVideoPage({required this.controller});

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
  bool _showControls = true;
  final _seekKey     = GlobalKey();

  void _seekTo(Offset globalPos) {
    final box = _seekKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(globalPos);
    final ratio = (local.dx / box.size.width).clamp(0.0, 1.0);
    widget.controller.seekTo(widget.controller.value.duration * ratio);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
          if (_showControls)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: widget.controller,
                builder: (_, value, __) {
                  final pos      = value.position;
                  final dur      = value.duration;
                  final progress = dur.inMilliseconds > 0
                      ? pos.inMilliseconds / dur.inMilliseconds
                      : 0.0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTapDown:            (d) => _seekTo(d.globalPosition),
                          onHorizontalDragUpdate: (d) => _seekTo(d.globalPosition),
                          child: Container(
                            key: _seekKey,
                            height: 24,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 4,
                              child: Stack(children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: kBorder,
                                        borderRadius: BorderRadius.circular(2))),
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: progress.clamp(0.0, 1.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: kPurple,
                                          borderRadius: BorderRadius.circular(2))),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                        child: Row(children: [
                          IconButton(
                            icon: Icon(
                              value.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white, size: 28,
                            ),
                            onPressed: () => value.isPlaying
                                ? widget.controller.pause()
                                : widget.controller.play(),
                          ),
                          Text('${_fmt(pos)} / ${_fmt(dur)}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              value.volume > 0
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              color: Colors.white, size: 22,
                            ),
                            onPressed: () => value.volume > 0
                                ? widget.controller.setVolume(0)
                                : widget.controller.setVolume(1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.fullscreen_exit_rounded,
                                color: Colors.white, size: 26),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
                      ),
                    ],
                  );
                },
              ),
            ),
        ]),
      ),
    );
  }
}

// ── CHANGE 1b: ReadMore Widget — lecture details ke liye ──────
class _ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;

  const _ReadMoreText({required this.text, this.trimLines = 4});

  @override
  State<_ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<_ReadMoreText> {
  bool _expanded = false; // ← collapsed by default

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
              color: Color(0xFFB0AECF), fontSize: 11, height: 1.7),
          // ── collapsed ho to maxLines lagao, expanded ho to null ──
          maxLines: _expanded ? null : widget.trimLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        // ── Read More / Read Less button ──────────────────────
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Read Less ▲' : 'Read More ▼',
            style: const TextStyle(
              color: kPurpleLight,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../domain/model/course/LectureModel.dart';
// import '../viewmodal/course/CoursesState.dart';
// import '../viewmodal/course/CoursesViewModel.dart';
//
// // import '../domain/course_domain.dart';
// // import '../viewmodel/course_viewmodels.dart';
//
// // ── Colors ────────────────────────────────────────────────────
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
// // ══════════════════════════════════════════════════════════════
// //  COURSE PLAYER SCREEN
// //  CourseDetailScreen se navigate karo, ye args pass karo
// // ══════════════════════════════════════════════════════════════
// class CoursePlayerScreen extends ConsumerStatefulWidget {
//   final int courseId;
//   final int lectureId;
//   final int currentIndex;
//   final List<LectureModel> allLectures;
//   final String courseTitle;
//   final LinearGradient gradient;
//
//   const CoursePlayerScreen({
//     super.key,
//     required this.courseId,
//     required this.lectureId,
//     required this.currentIndex,
//     required this.allLectures,
//     required this.courseTitle,
//     required this.gradient,
//   });
//
//   @override
//   ConsumerState<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
// }
//
// class _CoursePlayerScreenState extends ConsumerState<CoursePlayerScreen> {
//   int _tab = 0; // 0 = Lecture details, 1 = Resources
//
//   late final CoursePlayerArgs _args;
//
//   @override
//   void initState() {
//     super.initState();
//     _args = (
//     courseId: widget.courseId,
//     lectureId: widget.lectureId,
//     currentIndex: widget.currentIndex,
//     allLectures: widget.allLectures,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(coursePlayerViewModelProvider(_args));
//
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             _buildTopBar(state),
//             Expanded(
//               child: state.isLoading
//                   ? _buildShimmer()
//                   : state.errorMessage != null
//                   ? _buildError(state.errorMessage!)
//                   : _buildContent(state),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CoursePlayerState state) {
//     final lecture = state.lecture;
//     if (lecture == null) return const SizedBox();
//
//     final totalLectures = widget.allLectures.length;
//     final currentIdx = state.currentIndex;
//
//     // Progress calculation
//     final progressPct = totalLectures > 0
//         ? (currentIdx + 1) / totalLectures
//         : 0.0;
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildVideoPlayer(lecture),
//           _buildVideoControls(lecture),
//           _buildLectureTitle(lecture),
//           _buildCourseProgressCard(
//             widget.courseTitle,
//             progressPct,
//             currentIdx + 1,
//             totalLectures,
//           ),
//           _buildTabRow(),
//           if (_tab == 0) _buildLectureDetailsCard(lecture),
//           _buildCourseLectures(state),
//         ],
//       ),
//     );
//   }
//
//   // ── Top Bar ──────────────────────────────────────────────────
//   Widget _buildTopBar(CoursePlayerState state) {
//     final lectureName = state.lecture?.lectureTitle ?? 'Loading...';
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.arrow_back_ios_new,
//                 size: 18, color: kPurpleLight),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Preview course',
//                   style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Courses / ${widget.courseTitle}',
//                   style: const TextStyle(fontSize: 10, color: kTextMuted),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Video Player — contentUpload URL se video chalao ─────────
//   // Note: video_player package use karo real playback ke liye
//   // Yahan placeholder UI hai — contentUpload URL available hai
//   Widget _buildVideoPlayer(LectureModel lecture) {
//     return SizedBox(
//       height: 190,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             decoration: BoxDecoration(gradient: widget.gradient),
//           ),
//           CustomPaint(painter: _DotGridPainter()),
//           Center(
//             child: Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.15),
//                 border: Border.all(
//                     color: Colors.white.withOpacity(0.5), width: 2),
//               ),
//               // ── VIDEO PLAYER INTEGRATION POINT ──────────────────
//               // Yahan video_player ya chewie widget use karo:
//               // VideoPlayer(controller) — controller mein lecture.contentUpload URL do
//               child: GestureDetector(
//                 onTap: () {
//                   // TODO: video player initialize/play karo
//                   // controller = VideoPlayerController.networkUrl(
//                   //   Uri.parse(lecture.contentUpload)
//                   // );
//                 },
//                 child: const Icon(Icons.play_arrow_rounded,
//                     size: 28, color: Colors.white),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 12,
//             right: 12,
//             child: Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black.withOpacity(0.4),
//               ),
//               child: const Icon(Icons.fullscreen, size: 18, color: Colors.white),
//             ),
//           ),
//           // Video URL debug (remove in prod)
//           Positioned(
//             bottom: 8,
//             left: 8,
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               child: Text(
//                 lecture.contentUpload.split('/').last,
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.5), fontSize: 8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Video Controls ───────────────────────────────────────────
//   Widget _buildVideoControls(LectureModel lecture) {
//     return Container(
//       color: kBgDeep,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       child: Column(
//         children: [
//           _gradientBar(progress: 0.0, height: 3),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(children: [
//                 const Icon(Icons.play_arrow_rounded,
//                     size: 16, color: kGold),
//                 const SizedBox(width: 10),
//                 Text(
//                   '0:00 / ${lecture.duration}',
//                   style: const TextStyle(fontSize: 10, color: kTextMuted),
//                 ),
//               ]),
//               const Row(children: [
//                 Icon(Icons.volume_up_rounded, size: 16, color: kPurpleLight),
//                 SizedBox(width: 12),
//                 Icon(Icons.open_in_full, size: 16, color: kPurpleLight),
//               ]),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Lecture Title ─────────────────────────────────────────────
//   Widget _buildLectureTitle(LectureModel lecture) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               lecture.lectureTitle,
//               style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             lecture.duration,
//             style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: kGold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Course Progress Card ──────────────────────────────────────
//   Widget _buildCourseProgressCard(
//       String courseTitle, double pct, int current, int total) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: kBgCard,
//           border: Border.all(color: kBorder, width: 0.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               courseTitle,
//               style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white),
//             ),
//             const SizedBox(height: 6),
//             _gradientBar(progress: pct, height: 5),
//             const SizedBox(height: 4),
//             Text(
//               '${(pct * 100).round()}% complete · $current of $total lectures',
//               style: const TextStyle(fontSize: 10, color: kTextMuted),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Tab Row ───────────────────────────────────────────────────
//   Widget _buildTabRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           _tabItem(0, Icons.description_outlined, 'Lecture details'),
//           const SizedBox(width: 20),
//           _tabItem(1, Icons.attach_file, 'Resources'),
//         ],
//       ),
//     );
//   }
//
//   Widget _tabItem(int index, IconData icon, String label) {
//     final active = _tab == index;
//     return GestureDetector(
//       onTap: () => setState(() => _tab = index),
//       child: Container(
//         padding: const EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//                 color: active ? kGold : Colors.transparent, width: 2),
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 14, color: active ? kGold : kTextMuted),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight:
//                 active ? FontWeight.w600 : FontWeight.w500,
//                 color: active ? kGold : kTextMuted,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Lecture Details — aboutLecture HTML content ───────────────
//   // flutter_html package use karo rich HTML content ke liye
//   // Dependency: flutter_html: ^3.0.0-beta.2
//   Widget _buildLectureDetailsCard(LectureModel lecture) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: kBgCard,
//           border: Border.all(color: kBorder, width: 0.5),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Icon(Icons.bookmark_rounded, color: kGold, size: 14),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   lecture.lectureTitle,
//                   style: const TextStyle(
//                       color: kGold,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 10),
//
//             // ── OPTION A: Simple stripped text ───────────────────
//             Padding(
//               padding: const EdgeInsets.only(left: 22),
//               child: Text(
//                 _stripHtml(lecture.aboutLecture),
//                 style: const TextStyle(
//                     color: Color(0xFFB0AECF), fontSize: 11, height: 1.7),
//               ),
//             ),
//
//             // ── OPTION B: flutter_html ke saath (uncomment karo) ─
//             // import 'package:flutter_html/flutter_html.dart';
//             // Html(
//             //   data: lecture.aboutLecture,
//             //   style: {
//             //     "body": Style(color: const Color(0xFFB0AECF), fontSize: FontSize(11)),
//             //     "h3": Style(color: kGold, fontSize: FontSize(12)),
//             //     "h4": Style(color: kPurpleLight, fontSize: FontSize(11)),
//             //     "strong": Style(color: Colors.white),
//             //     "ul": Style(color: const Color(0xFFB0AECF)),
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Course Lectures List ──────────────────────────────────────
//   Widget _buildCourseLectures(CoursePlayerState state) {
//     final lectures = widget.allLectures;
//     final currentIdx = state.currentIndex;
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Course lectures',
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white),
//               ),
//               Text(
//                 '${currentIdx + 1} / ${lectures.length}',
//                 style: const TextStyle(fontSize: 10, color: kTextMuted),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Container(
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               color: kBgCard,
//               border: Border.all(color: kBorder, width: 0.5),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Column(
//               children: List.generate(lectures.length, (i) {
//                 return _lectureItem(
//                   index: i,
//                   lecture: lectures[i],
//                   isActive: i == currentIdx,
//                   showDivider: i > 0,
//                   onTap: () => ref
//                       .read(coursePlayerViewModelProvider(_args).notifier)
//                       .switchLecture(i),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _lectureItem({
//     required int index,
//     required LectureModel lecture,
//     required bool isActive,
//     required bool showDivider,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: isActive
//               ? const LinearGradient(
//               colors: [Color(0x407C3AED), Color(0x0D9333EA)])
//               : null,
//           border: showDivider
//               ? const Border(top: BorderSide(color: kBorder, width: 0.5))
//               : null,
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 26,
//               height: 26,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isActive ? kGold : kBorder,
//               ),
//               child: Center(
//                 child: Text(
//                   '${index + 1}',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: isActive
//                         ? const Color(0xFF1A0535)
//                         : kTextMuted,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     lecture.lectureTitle,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: isActive
//                           ? FontWeight.w600
//                           : FontWeight.w400,
//                       color: isActive ? Colors.white : const Color(0xFFB0AECF),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     lecture.duration,
//                     style: const TextStyle(
//                         fontSize: 9.5, color: kTextMuted),
//                   ),
//                 ],
//               ),
//             ),
//             if (isActive)
//               const Icon(Icons.play_arrow_rounded, size: 14, color: kGold),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Helpers ───────────────────────────────────────────────────
//   Widget _gradientBar({required double progress, required double height}) {
//     return LayoutBuilder(
//       builder: (_, constraints) => ClipRRect(
//         borderRadius: BorderRadius.circular(height),
//         child: SizedBox(
//           height: height,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Container(color: kBorder),
//               Positioned(
//                 left: 0,
//                 top: 0,
//                 bottom: 0,
//                 width: constraints.maxWidth * progress,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(colors: [kPurple, kGold]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _stripHtml(String html) {
//     return html
//         .replaceAll(RegExp(r'<[^>]*>'), ' ')
//         .replaceAll('&amp;', '&')
//         .replaceAll('&lt;', '<')
//         .replaceAll('&gt;', '>')
//         .replaceAll('&nbsp;', ' ')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }
//
//   Widget _buildShimmer() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Container(
//               height: 190,
//               color: kBgCard,
//               margin: const EdgeInsets.only(bottom: 14)),
//           ...List.generate(
//             3,
//                 (_) => Container(
//               height: 14,
//               color: kBgCard,
//               margin: const EdgeInsets.only(bottom: 10),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildError(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.wifi_off_rounded, color: kTextMuted, size: 48),
//             const SizedBox(height: 12),
//             Text(message,
//                 style: const TextStyle(color: kTextMuted, fontSize: 13),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: () => ref
//                   .read(coursePlayerViewModelProvider(_args).notifier)
//                   .fetchLecture(widget.lectureId),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: kPurple,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text('Retry',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Dot Grid Painter ──────────────────────────────────────────
// class _DotGridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFD4AF37).withOpacity(0.15)
//       ..style = PaintingStyle.fill;
//     const spacing = 16.0;
//     for (double x = 0; x < size.width; x += spacing) {
//       for (double y = 0; y < size.height; y += spacing) {
//         canvas.drawCircle(Offset(x, y), 1.0, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(_DotGridPainter old) => false;
// }









//--------------------------------------------- Without API ---------------------------------------------------->










// import 'package:flutter/material.dart';
//
// // ─── Color constants ──────────────────────────────────────────────────────────
// // Remove kBgDark / kBgCard / kPurple / kGold if already defined in your project
// const Color kBgDark      = Color(0xFF0F0120);
// const Color kBgCard      = Color(0xFF150328);
// const Color _kBgDeep     = Color(0xFF0A0118);
// const Color _kBorder     = Color(0xFF2D1050);
// const Color kPurple      = Color(0xFF7C3AED);
// const Color kPurpleLight = Color(0xFF9333EA);
// const Color kGold        = Color(0xFFD4AF37);
// const Color _kMuted      = Color(0xFFB0AECF);
// const Color _kGrey       = Color(0xFF888888);
// const kBgDeep      = Color(0xFF0A0118);
// const kGoldLight   = Color(0xFFFFD700);
// const kBorder      = Color(0xFF2D1050);
// const kTextPrimary = Colors.white;
// const kTextMuted   = Color(0xFF888888);
// const kAccentGreen = Color(0xFF639922);
//
// // ─── Local data model ─────────────────────────────────────────────────────────
// class _Lecture {
//   final String title;
//   final String duration;
//   final bool isActive;
//   const _Lecture({
//     required this.title,
//     required this.duration,
//     required this.isActive,
//   });
// }
//
// // ─── Screen ───────────────────────────────────────────────────────────────────
// class CoursePlayerScreen extends StatefulWidget {
//   const CoursePlayerScreen({super.key});
//
//   @override
//   State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
// }
//
// class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
//   int _tab = 0; // 0 = Lecture details, 1 = Resources
//
//   static const _lectures = [
//     _Lecture(title: 'History of the forex market', duration: '00:02:00 sec', isActive: true),
//     _Lecture(title: 'Forex sectors',               duration: '00:02:14 sec', isActive: false),
//     _Lecture(title: 'Risks in forex trading',      duration: '00:02:22 sec', isActive: false),
//     _Lecture(title: 'Benefits of forex trading',   duration: '00:01:53 sec', isActive: false),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBgDark,
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             _buildTopBar(),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildVideoPlayer(),
//                     _buildVideoControls(),
//                     _buildLectureTitle(),
//                     _buildCourseProgressCard(),
//                     _buildTabRow(),
//                     if (_tab == 0) _buildLectureDetailsCard(),
//                     _buildCourseLectures(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─── Top Bar ─────────────────────────────────────────────────────────────────
//   Widget _buildTopBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: const BoxDecoration(
//         color: kBgCard,
//         border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.arrow_back_ios_new, size: 18, color: kPurpleLight),
//           ),
//           const SizedBox(width: 10),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Preview course',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 'Courses / Basic of currency',
//                 style: TextStyle(fontSize: 10, color: _kGrey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Video Player ─────────────────────────────────────────────────────────────
//   Widget _buildVideoPlayer() {
//     return SizedBox(
//       height: 190,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Gradient bg
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF2D0A4A), kPurple],
//               ),
//             ),
//           ),
//           // Dot grid overlay
//           CustomPaint(painter: _DotGridPainter()),
//           // Play button
//           Center(
//             child: Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.15),
//                 border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
//               ),
//               child: const Icon(Icons.play_arrow_rounded, size: 28, color: Colors.white),
//             ),
//           ),
//           // Fullscreen button
//           Positioned(
//             top: 12,
//             right: 12,
//             child: Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black.withOpacity(0.4),
//               ),
//               child: const Icon(Icons.fullscreen, size: 18, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Video Controls ───────────────────────────────────────────────────────────
//   Widget _buildVideoControls() {
//     return Container(
//       color: _kBgDeep,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       child: Column(
//         children: [
//           _gradientBar(progress: 0.22, height: 3, colors: [kPurple, kGold]),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Row(children: [
//                 Icon(Icons.play_arrow_rounded, size: 16, color: kGold),
//                 SizedBox(width: 10),
//                 Text('0:26 / 2:00', style: TextStyle(fontSize: 10, color: _kMuted)),
//               ]),
//               Row(children: [
//                 Icon(Icons.volume_up_rounded, size: 16, color: kPurpleLight),
//                 SizedBox(width: 12),
//                 Icon(Icons.open_in_full, size: 16, color: kPurpleLight),
//               ]),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Lecture Title + Duration ─────────────────────────────────────────────────
//   Widget _buildLectureTitle() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Row(
//         children: const [
//           Expanded(
//             child: Text(
//               'History of the forex market',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
//             ),
//           ),
//           SizedBox(width: 8),
//           Text(
//             '00:02:00',
//             style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: kGold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Course Progress Card ─────────────────────────────────────────────────────
//   Widget _buildCourseProgressCard() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: kBgCard,
//           border: Border.all(color: _kBorder, width: 0.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Basic course of currency trading',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
//             ),
//             const SizedBox(height: 6),
//             _gradientBar(progress: 0.08, height: 5, colors: [kPurple, kPurpleLight]),
//             const SizedBox(height: 4),
//             const Text(
//               '8% complete · 1 of 12 lectures',
//               style: TextStyle(fontSize: 10, color: _kGrey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─── Tab Row ──────────────────────────────────────────────────────────────────
//   Widget _buildTabRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: _kBorder, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           _tabItem(0, Icons.description_outlined, 'Lecture details'),
//           const SizedBox(width: 20),
//           _tabItem(1, Icons.attach_file, 'Resources'),
//         ],
//       ),
//     );
//   }
//
//   Widget _tabItem(int index, IconData icon, String label) {
//     final active = _tab == index;
//     return GestureDetector(
//       onTap: () => setState(() => _tab = index),
//       child: Container(
//         padding: const EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: active ? kGold : Colors.transparent, width: 2),
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 14, color: active ? kGold : _kGrey),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: active ? FontWeight.w600 : FontWeight.w500,
//                 color: active ? kGold : _kGrey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─── Lecture Details Card ─────────────────────────────────────────────────────
//   Widget _buildLectureDetailsCard() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: kBgCard,
//           border: Border.all(color: _kBorder, width: 0.5),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Chapter
//             _infoRow(
//               icon: Icons.bookmark_rounded,
//               iconColor: kGold,
//               text: 'Chapter 1: The currency trading market',
//               textColor: kGold,
//             ),
//             const SizedBox(height: 10),
//             // Topic
//             _infoRow(
//               icon: Icons.lightbulb_outline,
//               iconColor: kPurpleLight,
//               text: 'Topic 1: History of the forex market',
//               textColor: Colors.white,
//             ),
//             const SizedBox(height: 10),
//             // Description
//             const Padding(
//               padding: EdgeInsets.only(left: 22),
//               child: Text(
//                 'Welcome to the fascinating origin story of forex! In this lesson, we take you on a time-traveling journey from the ancient days of barter to the ultra-modern, digital 24/5 forex market we know today.',
//                 style: TextStyle(fontSize: 11, color: _kMuted, height: 1.7),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // What you'll learn header
//             const Padding(
//               padding: EdgeInsets.only(left: 22),
//               child: Text(
//                 'Here is what you will learn:',
//                 style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 6),
//             _bullet('How early civilizations exchanged value before money'),
//             const SizedBox(height: 6),
//             _bullet('The role of the gold standard and Bretton Woods'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow({
//     required IconData icon,
//     required Color iconColor,
//     required String text,
//     required Color textColor,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 2),
//           child: Icon(icon, size: 14, color: iconColor),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _bullet(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 22),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(top: 4),
//             child: Icon(Icons.circle, size: 5, color: kGold),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 11, color: _kMuted, height: 1.6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── Course Lectures List ─────────────────────────────────────────────────────
//   Widget _buildCourseLectures() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 'Course lectures',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//               Text('1 / 12', style: TextStyle(fontSize: 10, color: _kGrey)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Container(
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               color: kBgCard,
//               border: Border.all(color: _kBorder, width: 0.5),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Column(
//               children: [
//                 ..._lectures.asMap().entries.map(
//                       (e) => _lectureItem(
//                     index: e.key + 1,
//                     lecture: e.value,
//                     showDivider: e.key > 0,
//                   ),
//                 ),
//                 // Show all button
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: const BoxDecoration(
//                     border: Border(top: BorderSide(color: _kBorder, width: 0.5)),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'Show all 12 lectures',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: kPurpleLight,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _lectureItem({
//     required int index,
//     required _Lecture lecture,
//     required bool showDivider,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         // Active item gets a subtle purple gradient highlight
//         gradient: lecture.isActive
//             ? const LinearGradient(colors: [Color(0x407C3AED), Color(0x0D9333EA)])
//             : null,
//         border: showDivider
//             ? const Border(top: BorderSide(color: _kBorder, width: 0.5))
//             : null,
//       ),
//       child: Row(
//         children: [
//           // Number badge
//           Container(
//             width: 26,
//             height: 26,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: lecture.isActive ? kGold : _kBorder,
//             ),
//             child: Center(
//               child: Text(
//                 '$index',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: lecture.isActive ? const Color(0xFF1A0535) : _kGrey,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Title + duration
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   lecture.title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: lecture.isActive ? FontWeight.w600 : FontWeight.w400,
//                     color: lecture.isActive ? Colors.white : _kMuted,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   lecture.duration,
//                   style: const TextStyle(fontSize: 9.5, color: _kGrey),
//                 ),
//               ],
//             ),
//           ),
//           if (lecture.isActive)
//             const Icon(Icons.play_arrow_rounded, size: 14, color: kGold),
//         ],
//       ),
//     );
//   }
//
//   // ─── Gradient Progress Bar (reusable) ────────────────────────────────────────
//   Widget _gradientBar({
//     required double progress,
//     required double height,
//     required List<Color> colors,
//   }) {
//     return LayoutBuilder(
//       builder: (_, constraints) => ClipRRect(
//         borderRadius: BorderRadius.circular(height),
//         child: SizedBox(
//           height: height,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Container(color: _kBorder),
//               Positioned(
//                 left: 0,
//                 top: 0,
//                 bottom: 0,
//                 width: constraints.maxWidth * progress,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: colors),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Dot Grid Painter ─────────────────────────────────────────────────────────
// class _DotGridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFD4AF37).withOpacity(0.15)
//       ..style = PaintingStyle.fill;
//
//     const spacing = 16.0;
//     for (double x = 0; x < size.width; x += spacing) {
//       for (double y = 0; y < size.height; y += spacing) {
//         canvas.drawCircle(Offset(x, y), 1.0, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(_DotGridPainter oldDelegate) => false;
// }