
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../domain/model/FinancialLiteracy/McqQuestion.dart';
import '../../domain/model/VerveeUniverse/ChapterVideo.dart';
import '../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';
import '../viewmodal/VerveeUniverse/VerveeUniverseViewModel.dart';
import 'FinancialLiteracyScreen.dart'; // colors import

// ═══════════════════════════════════════════════════════════════════════════════
//  VIDEO DETAIL SCREEN
//  — MCQ & Video API (GET /vervee-universe/{id}) se real videos + MCQ load karta he
//  — har video/chapter ke apne mcqs he, isliye divide karne ki zaroorat nahi
// ═══════════════════════════════════════════════════════════════════════════════

class VerveeUniverseItemScreen extends ConsumerStatefulWidget {
  final VerveeUniverseItem course;
  final int courseIndex;
  final List<VerveeUniverseItem> allCourses;

  const VerveeUniverseItemScreen({
    super.key,
    required this.course,
    required this.courseIndex,
    required this.allCourses,
  });

  @override
  ConsumerState<VerveeUniverseItemScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VerveeUniverseItemScreen> {
  // ── Video player ───────────────────────────────────────────────────────────
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _videoError = false;
  bool _hasStartedPlaying = false;

  int _initGeneration = 0;

  // existing variables ke neeche add karo
  bool _isFullscreen = false;
  final _seekBarKey = GlobalKey();

  // ── Currently selected video inside the course ─────────────────────────────
  int _selectedVideoIndex = 0;

  // ── Quiz state ─────────────────────────────────────────────────────────────
  final Map<int, int> _selectedAnswers = {};
  bool _quizSubmitted = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    // ✅ Detail + per-chapter MCQs load karo — GET /vervee-universe/{id}
    Future.microtask(
          () => ref
          .read(universeDetailViewModelProvider(widget.course.id).notifier)
          .loadDetail(),
    );

    // If course already has videos in list-response, init first video
    if (widget.course.videos.isNotEmpty) {
      _initVideo(widget.course.videos.first.videoUrl);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ── Init video player ──────────────────────────────────────────────────────
  Future<void> _initVideo(String? url) async {
    if (url == null || url.isEmpty) return;

    final myGen = ++_initGeneration;

    _videoController?.dispose();
    setState(() {
      _videoInitialized = false;
      _videoError = false;
      _hasStartedPlaying = false;
    });

    final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController = ctrl;

    try {
      await ctrl.initialize();
      if (mounted && myGen == _initGeneration) {
        setState(() => _videoInitialized = true);
      }
    } catch (_) {
      if (mounted && myGen == _initGeneration) {
        setState(() => _videoError = true);
      }
    }
  }

  // ── Switch video ───────────────────────────────────────────────────────────
  void _switchVideo(int index, String? url) {
    setState(() {
      _selectedVideoIndex = index;
      _videoInitialized = false;
      _videoError = false;
      _hasStartedPlaying = false;
      _selectedAnswers.clear(); // ← video badalte hi quiz reset
      _quizSubmitted = false;
    });
    _initVideo(url);
  }

  // ── Quiz submit ────────────────────────────────────────────────────────────
  void _submitQuiz(List<McqQuestion> questions) {
    if (_selectedAnswers.length < questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please answer all questions before submitting.'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i].correctIndex) score++;
    }

    setState(() => _quizSubmitted = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You scored $score / ${questions.length}! '
              '${score == questions.length ? '🎉 Perfect!' : 'Keep learning!'}',
        ),
        backgroundColor: kPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Next course ────────────────────────────────────────────────────────────
  VerveeUniverseItem? get _nextCourse {
    final next = widget.courseIndex + 1;
    if (next < widget.allCourses.length) return widget.allCourses[next];
    return null;
  }

  // ═════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final detailState =
    ref.watch(universeDetailViewModelProvider(widget.course.id));

    // Videos — prefer detail (full), fallback to list-response
    final videos = detailState.detail?.videos.isNotEmpty == true
        ? detailState.detail!.videos
        : widget.course.videos;

    // ✅ Ab mcqs evenly divide nahi karne padte — har chapter/video ke apne
    //    mcqs detail response me already grouped he.
    final mcqs = detailState.detail?.mcqsForVideo(_selectedVideoIndex) ?? [];

    // If detail loaded & first video url changed, re-init
    // ref.listen(universeDetailViewModelProvider(widget.course.id), (_, next) {
    //   if (next.detail != null &&
    //       next.detail!.videos.isNotEmpty &&
    //       !_videoInitialized &&
    //       !_videoError) {
    //     _initVideo(next.detail!.videos.first.videoUrl);
    //   }
    // });

    ref.listen(universeDetailViewModelProvider(widget.course.id), (_, next) {
      final newUrl = next.detail?.videos.isNotEmpty == true
          ? next.detail!.videos.first.videoUrl
          : null;
      final alreadyPlaying = widget.course.videos.isNotEmpty &&
          widget.course.videos.first.videoUrl == newUrl;

      if (newUrl != null && !alreadyPlaying && !_videoInitialized && !_videoError) {
        _initVideo(newUrl);
      }
    });

    return Scaffold(
      backgroundColor: kBgDark,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildBackBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVideoPlayer(videos),
                  if (videos.length > 1) _buildVideoList(videos),
                  _buildChapterInfo(videos),
                  const SizedBox(height: 12),
                  if (detailState.isLoading && mcqs.isEmpty)
                    _buildMcqSkeleton()
                  else if (mcqs.isNotEmpty)
                    _buildQuizSection(mcqs),
                  const SizedBox(height: 12),
                  if (_nextCourse != null) _buildNextChapter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Back Bar ───────────────────────────────────────────────────────────────
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
        const Text('Vervee Universe',
            style: TextStyle(
                color: kTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        const Spacer(),
        Text(
          widget.course.title.length > 25
              ? '${widget.course.title.substring(0, 25)}...'
              : widget.course.title,
          style: const TextStyle(color: kTextMuted, fontSize: 11),
        )
      ]),
    );
  }

  // ── Video Player ───────────────────────────────────────────────────────────
  Widget _buildVideoPlayer(List<ChapterVideo> videos) {
    final currentVideo =
    videos.isNotEmpty ? videos[_selectedVideoIndex] : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: [
        // ── Video area ───────────────────────────────────────────────────
        GestureDetector(
          onTap: () {
            if (_videoInitialized && _videoController != null) {
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                  _hasStartedPlaying = true;
                }
              });
            }
          },
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: _buildVideoContent(currentVideo),
          ),
        ),

        // ── Controls ─────────────────────────────────────────────────────
        Container(
          color: kBgDeep,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: _videoInitialized && _videoController != null
              ? _buildRealControls()
              : _buildPlaceholderControls(),
        ),
      ]),
    );
  }


  Widget _buildVideoContent(ChapterVideo? video) {
    // ── Video initialized — show karo ──────────────────────────
    if (_videoInitialized && _videoController != null) {
      return ValueListenableBuilder(
        valueListenable: _videoController!,
        builder: (context, value, child) {
          return Stack(fit: StackFit.expand, children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: value.size.width,
                height: value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
            // Pause overlay — sirf tab dikhao jab buffering na ho rahi ho
            if (!value.isPlaying && !value.isBuffering)
              Container(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      color: Colors.white, size: 56),
                ),
              ),
            // Buffering loader
            if (value.isBuffering)
              Container(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: kGold,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
          ]);
        },
      );
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
      decoration: BoxDecoration(
        gradient: gradientForIndex(widget.courseIndex),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('VERVEE',
            style: TextStyle(
                color: kGold,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 3)),
        const Text('A C A D E M Y',
            style: TextStyle(
                color: kPurpleLight, fontSize: 7, letterSpacing: 3)),
        const SizedBox(height: 12),
        if (_videoController == null && (video?.videoUrl?.isEmpty ?? true))
          const Icon(Icons.play_circle_outline_rounded,
              color: Colors.white54, size: 40)
        else
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(color: kGold, strokeWidth: 2),
          ),
      ]),
    );
  }

  Widget _buildRealControls() {
    return ValueListenableBuilder(
      valueListenable: _videoController!,
      builder: (_, value, __) {
        final pos = value.position;
        final dur = value.duration;
        final progress =
        dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;

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
          GestureDetector(
            onTap: () {
              value.isPlaying
                  ? _videoController!.pause()
                  : _videoController!.play();
            },
            child: Icon(
              value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: kPurpleLight,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          // ── Seek bar ──────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTapDown: (d) => seekTo(d.globalPosition),
              onHorizontalDragUpdate: (d) => seekTo(d.globalPosition),
              child: Container(
                key: _seekBarKey,
                height: 20,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 4,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPurple,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${fmt(pos)} / ${fmt(dur)}',
              style: const TextStyle(color: kTextMuted, fontSize: 9)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              value.volume > 0
                  ? _videoController!.setVolume(0)
                  : _videoController!.setVolume(1);
            },
            child: Icon(
              value.volume > 0 ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: kPurpleLight,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          // ── Fullscreen button ─────────────────────────────────────────
          GestureDetector(
            onTap: _openFullscreen,
            child: const Icon(Icons.fullscreen_rounded,
                color: kPurpleLight, size: 18),
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
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: kPurple, borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      const Text('--:-- / --:--',
          style: TextStyle(color: kTextMuted, fontSize: 9)),
    ]);
  }

  // ── Video List (multiple videos in a course) ───────────────────────────────
  Widget _buildVideoList(List<ChapterVideo> videos) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border:
              Border(bottom: BorderSide(color: kBorder, width: 0.5)),
            ),
            child: const Text('Videos in this course',
                style: TextStyle(
                    color: kGold,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
          ...List.generate(videos.length, (i) {
            final v = videos[i];
            final isSelected = _selectedVideoIndex == i;
            return GestureDetector(
              onTap: () => _switchVideo(i, v.videoUrl),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPurple.withOpacity(0.1)
                      : Colors.transparent,
                  border: Border(
                      bottom: BorderSide(
                          color: i < videos.length - 1
                              ? kBorder
                              : Colors.transparent,
                          width: 0.5)),
                ),
                child: Row(children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? kPurple
                          : kBorder.withOpacity(0.5),
                    ),
                    child: Icon(
                      isSelected
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      v.title,
                      style: TextStyle(
                        color: isSelected ? kGold : kTextPrimary,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('Video ${i + 1}',
                      style: const TextStyle(
                          color: kTextMuted, fontSize: 9)),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Chapter Info ───────────────────────────────────────────────────────────
  // Widget _buildChapterInfo(List<ChapterVideo> videos) {
  //   final currentVideo =
  //   videos.isNotEmpty ? videos[_selectedVideoIndex] : null;
  //
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Container(
  //         padding:
  //         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //         decoration: BoxDecoration(
  //             color: kBorder, borderRadius: BorderRadius.circular(20)),
  //         child: Text(
  //           'Course ${widget.courseIndex + 1}',
  //           style: const TextStyle(
  //               color: kPurpleLight,
  //               fontSize: 10,
  //               fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         currentVideo?.title ?? widget.course.title,
  //         style: const TextStyle(
  //             color: kTextPrimary,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w700),
  //       ),
  //       const SizedBox(height: 6),
  //       Text(
  //         currentVideo?.content ?? widget.course.content,
  //         style: const TextStyle(
  //             color: kTextMuted, fontSize: 11, height: 1.6),
  //         maxLines: 4,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ]),
  //   );
  // }


  Widget _buildChapterInfo(List<ChapterVideo> videos) {
    final currentVideo =
    videos.isNotEmpty ? videos[_selectedVideoIndex] : null;
    final chapterTitle = currentVideo?.title ?? widget.course.title;
    final content = currentVideo?.content ?? widget.course.content;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: kBorder, borderRadius: BorderRadius.circular(20)),
          child: Text(
            'Course ${widget.courseIndex + 1}',
            style: const TextStyle(
                color: kPurpleLight,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          chapterTitle,
          style: const TextStyle(
              color: kTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),

        // ✅ NEW — overflow detect + Read more
        LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(
                  text: content,
                  style: const TextStyle(fontSize: 11, height: 1.6)),
              maxLines: 4,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);
            final isOverflowing = textPainter.didExceedMaxLines;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                      color: kTextMuted, fontSize: 11, height: 1.6),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isOverflowing)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: GestureDetector(
                      onTap: () =>
                          _showFullChapterContent(chapterTitle, content),
                      child: const Text('Read more',
                          style: TextStyle(
                              color: kPurpleLight,
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
              ],
            );
          },
        ),
      ]),
    );
  }

  // ✅ NEW — full chapter/course content ke liye bottom sheet (PostCard._showFullContent jaisa)
  void _showFullChapterContent(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: kTextMuted, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: kBorder,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Course ${widget.courseIndex + 1}',
                        style: const TextStyle(
                            color: kPurpleLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(title,
                      style: const TextStyle(
                        color: kTextPrimary, fontSize: 16,
                        fontWeight: FontWeight.w800, height: 1.4,
                      )),
                ],
              ),
            ),
            const Divider(color: kBorder, height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Text(
                  content,
                  style: const TextStyle(
                      color: kTextMuted, fontSize: 14, height: 1.7),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Fullscreen ─────────────────────────────────────────────────────────────
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

  // ── MCQ Section ────────────────────────────────────────────────────────────
  Widget _buildQuizSection(List<McqQuestion> questions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: kBorder,
          child: Row(children: [
            const Icon(Icons.psychology_rounded, color: kGold, size: 16),
            const SizedBox(width: 6),
            const Text('Take quiz — test your knowledge',
                style: TextStyle(
                    color: kGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: kBgDeep,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${questions.length} Questions',
                style:
                const TextStyle(color: kPurpleLight, fontSize: 9),
              ),
            ),
          ]),
        ),

        // Questions
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
          child: Column(
            children: List.generate(questions.length,
                    (qi) => _buildQuestion(qi, questions[qi])),
          ),
        ),

        // Submit button
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
          child: GestureDetector(
            onTap: _quizSubmitted ? null : () => _submitQuiz(questions),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                gradient: _quizSubmitted
                    ? null
                    : const LinearGradient(
                  colors: [kPurple, kPurpleLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                color: _quizSubmitted ? kBorder : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _quizSubmitted
                          ? Icons.check_circle_outline_rounded
                          : Icons.send_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _quizSubmitted ? 'Submitted' : 'Submit Answers',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildQuestion(int qi, McqQuestion q) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Q${qi + 1}.',
          style: const TextStyle(
              color: kGold, fontSize: 10, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text(q.question,
          style: const TextStyle(
              color: kTextPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.5)),
      const SizedBox(height: 8),
      ...List.generate(q.options.length, (oi) {
        final isSelected = _selectedAnswers[qi] == oi;
        Color borderColor = kBorder;
        Color bgColor = kBgDeep;
        if (_quizSubmitted) {
          if (oi == q.correctIndex) {
            borderColor = const Color(0xFF22C55E);
            bgColor = const Color(0xFF0D2B1A);
          } else if (isSelected && oi != q.correctIndex) {
            borderColor = const Color(0xFFEF4444);
            bgColor = const Color(0xFF2B0D0D);
          }
        } else if (isSelected) {
          borderColor = kPurple;
          bgColor = const Color(0xFF1a0535);
        }

        return GestureDetector(
          onTap: _quizSubmitted
              ? null
              : () => setState(() => _selectedAnswers[qi] = oi),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Row(children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? kPurple : kBorder,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPurple,
                    ),
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(q.options[oi].text,
                    style: TextStyle(
                      color: isSelected
                          ? kTextPrimary
                          : const Color(0xFFCCCCCC),
                      fontSize: 10.5,
                    )),
              ),
              if (_quizSubmitted && oi == q.correctIndex)
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF22C55E), size: 14),
              if (_quizSubmitted &&
                  isSelected &&
                  oi != q.correctIndex)
                const Icon(Icons.cancel_rounded,
                    color: Color(0xFFEF4444), size: 14),
            ]),
          ),
        );
      }),
      if (qi < q.options.length)
        Container(
            height: 0.5,
            color: kBorder,
            margin: const EdgeInsets.symmetric(vertical: 10)),
    ]);
  }

  // ── MCQ Skeleton ───────────────────────────────────────────────────────────
  Widget _buildMcqSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Column(children: [
        Container(height: 12, color: kBorder),
        const SizedBox(height: 10),
        Container(height: 10, width: 200, color: kBorder),
        const SizedBox(height: 10),
        ...List.generate(
            3,
                (_) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 36,
                decoration: BoxDecoration(
                    color: kBorder.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8)))),
      ]),
    );
  }

  // ── Next Course Card ───────────────────────────────────────────────────────
  Widget _buildNextChapter() {
    final next = _nextCourse!;
    final nextIndex = widget.courseIndex + 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
              border:
              Border(bottom: BorderSide(color: kBorder, width: 0.5))),
          child: Text('Course ${nextIndex + 1}',
              style: const TextStyle(
                  color: kGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerveeUniverseItemScreen(
                course: next,
                courseIndex: nextIndex,
                allCourses: widget.allCourses,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 54,
                  height: 44,
                  child: next.thumbnail != null &&
                      next.thumbnail!.isNotEmpty
                      ? Image.network(next.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                            gradient: gradientForIndex(nextIndex)),
                      ))
                      : Container(
                    decoration: BoxDecoration(
                        gradient: gradientForIndex(nextIndex)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(next.title,
                          style: const TextStyle(
                              color: kTextPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Course ${nextIndex + 1} · Financial Literacy',
                          style: const TextStyle(
                              color: kTextMuted, fontSize: 10)),
                    ]),
              ),
              const Icon(Icons.play_circle_outline_rounded,
                  color: kPurpleLight, size: 22),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FULLSCREEN VIDEO PAGE
// ═══════════════════════════════════════════════════════════════════════════════

class _FullscreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  const _FullscreenVideoPage({required this.controller});

  @override
  State<_FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<_FullscreenVideoPage> {
  bool _showControls = true;
  final _seekKey = GlobalKey();

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video ──────────────────────────────────────────────────
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),

            // Buffering loader — fullscreen me bhi dikhega
            ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (_, value, __) {
                if (!value.isBuffering) return const SizedBox.shrink();
                return Container(
                  color: Colors.black.withOpacity(0.35),
                  child: const Center(
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: CircularProgressIndicator(
                        color: kGold,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Controls overlay ───────────────────────────────────────
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
                    final pos = value.position;
                    final dur = value.duration;
                    final progress = dur.inMilliseconds > 0
                        ? pos.inMilliseconds / dur.inMilliseconds
                        : 0.0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Seek bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTapDown: (d) => _seekTo(d.globalPosition),
                            onHorizontalDragUpdate: (d) =>
                                _seekTo(d.globalPosition),
                            child: Container(
                              key: _seekKey,
                              height: 24,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 4,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: kBorder,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kPurple,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Bottom row
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                          child: Row(children: [
                            IconButton(
                              icon: Icon(
                                value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () => value.isPlaying
                                  ? widget.controller.pause()
                                  : widget.controller.play(),
                            ),
                            Text(
                              '${_fmt(pos)} / ${_fmt(dur)}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                value.volume > 0
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_off_rounded,
                                color: Colors.white,
                                size: 22,
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
          ],
        ),
      ),
    );
  }
}
