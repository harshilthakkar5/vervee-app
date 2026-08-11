
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// import 'package:vervee_app/presentation/viewmodal/financial_literacy/financial_literacy_viewmodel.dart';
// import 'package:vervee_app/presentation/viewmodal/financial_literacy/financial_literacy_dto.dart';

import '../../domain/model/FinancialLiteracy/CourseVideo.dart';
import '../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';
import '../../domain/model/FinancialLiteracy/McqQuestion.dart';
import '../viewmodal/FinancialLiteracy/FinancialLiteracyViewModel.dart';
import 'FinancialLiteracyScreen.dart'; // colors import

// ═══════════════════════════════════════════════════════════════════════════════
//  VIDEO DETAIL SCREEN
//  — API se real videos + MCQ load karta hai (CourseDetailViewModel)
// ═══════════════════════════════════════════════════════════════════════════════

class VideoDetailScreen extends ConsumerStatefulWidget {
  final FinancialLiteracyCourse course;
  final int courseIndex;
  final List<FinancialLiteracyCourse> allCourses;

  const VideoDetailScreen({
    super.key,
    required this.course,
    required this.courseIndex,
    required this.allCourses,
  });

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  // ── Video player ───────────────────────────────────────────────────────────
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _videoError = false;
  bool _hasStartedPlaying = false;

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
    // Load detail + MCQs
    Future.microtask(
          () => ref
          .read(courseDetailViewModelProvider(widget.course.id).notifier)
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
      if (mounted) {
        setState(() => _videoInitialized = true);
      }
    } catch (_) {
      if (mounted) {
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
      _selectedAnswers.clear();  // ← ADD
      _quizSubmitted = false;    // ← ADD
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
  FinancialLiteracyCourse? get _nextCourse {
    final next = widget.courseIndex + 1;
    if (next < widget.allCourses.length) return widget.allCourses[next];
    return null;
  }

  List<McqQuestion> _mcqsForVideo(List<McqQuestion> allMcqs, int videoCount, int selectedVideoIndex) {
    if (allMcqs.isEmpty || videoCount <= 1) return allMcqs;
    final perVideo = allMcqs.length ~/ videoCount;
    if (perVideo == 0) return allMcqs;
    final start = selectedVideoIndex * perVideo;
    final isLastVideo = selectedVideoIndex == videoCount - 1;
    final end = isLastVideo ? allMcqs.length : start + perVideo;
    if (start >= allMcqs.length) return [];
    return allMcqs.sublist(start, end.clamp(0, allMcqs.length));
  }

  // ═════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final detailState =
    ref.watch(courseDetailViewModelProvider(widget.course.id));

    // Videos — prefer detail (full), fallback to list-response
    final videos = detailState.detail?.videos.isNotEmpty == true
        ? detailState.detail!.videos
        : widget.course.videos;

     //final mcqs = detailState.detail?.mcqs ?? [];

    // AB:
    final allMcqs = detailState.detail?.mcqs ?? [];
    final mcqs = _mcqsForVideo(allMcqs, videos.length, _selectedVideoIndex);

    // // ── AFTER ──
    // final mcqs = videos.isNotEmpty
    //     ? videos[_selectedVideoIndex].mcqs
    //     : <McqQuestion>[];

    // If detail loaded & first video url changed, re-init
    ref.listen(courseDetailViewModelProvider(widget.course.id), (_, next) {
      if (next.detail != null &&
          next.detail!.videos.isNotEmpty &&
          !_videoInitialized &&
          !_videoError) {
        _initVideo(next.detail!.videos.first.videoUrl);
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
        const Text('Financial Literacy',
            style: TextStyle(
                color: kTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        const Spacer(),
        // Text(widget.course.title,
        //     style: const TextStyle(color: kTextMuted, fontSize: 11)),
        Text(
          widget.course.title.length > 25
              ? '${widget.course.title.substring(0, 25)}...'
              : widget.course.title,
            style: const TextStyle(color: kTextMuted, fontSize: 11)
        )
      ]),
    );
  }

  // ── Video Player ───────────────────────────────────────────────────────────
  Widget _buildVideoPlayer(List<CourseVideo> videos) {
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
              // setState(() {
              //   _videoController!.value.isPlaying
              //       ? _videoController!.pause()
              //       : _videoController!.play();
              // });
              setState(() {
                if (_videoController!.value.isPlaying) {
                  _videoController!.pause();
                } else {
                  _videoController!.play();
                  _hasStartedPlaying = true; // ✅ CHANGE 3: pehli baar play dabaya — ab thumbnail hatega
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

  // Widget _buildVideoContent(CourseVideo? video) {
  //   if (_isFullscreen) return Container(color: Colors.black);
  //
  //   // ✅ CHANGE 4: thumbnail nikal liya — jab tak _hasStartedPlaying false he tab tak yahi dikhega
  //   final String? courseThumbnail = widget.course.thumbnail;
  //   final bool hasThumbnail = courseThumbnail != null && courseThumbnail.isNotEmpty;
  //
  //   Widget thumbnailBackground({required Widget overlayChild}) {
  //     return Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         if (hasThumbnail)
  //           CachedNetworkImage(
  //             imageUrl: courseThumbnail,
  //             fit: BoxFit.cover,
  //             placeholder: (_, __) => Container(
  //               decoration: BoxDecoration(gradient: gradientForIndex(widget.courseIndex)),
  //             ),
  //             errorWidget: (_, __, ___) => Container(
  //               decoration: BoxDecoration(gradient: gradientForIndex(widget.courseIndex)),
  //             ),
  //           )
  //         else
  //           Container(decoration: BoxDecoration(gradient: gradientForIndex(widget.courseIndex))),
  //         Container(
  //           color: Colors.black.withOpacity(0.4),
  //           child: overlayChild,
  //         ),
  //       ],
  //     );
  //   }
  //
  //   // ✅ CHANGE 4a: video initialize ho chuka he LEKIN user ne abhi play nahi dabaya —
  //   // isliye video frame ki jagah thumbnail + play icon dikhao
  //   if (_videoInitialized && _videoController != null && !_hasStartedPlaying) {
  //     return thumbnailBackground(
  //       overlayChild: const Center(
  //         child: Icon(Icons.play_circle_outline_rounded, color: Colors.white, size: 52),
  //       ),
  //     );
  //   }
  //
  //   // ✅ CHANGE 4b: user play dabā chuka he — ab actual video player dikhao (pause overlay ke sath)
  //   if (_videoInitialized && _videoController != null && _hasStartedPlaying) {
  //     return Stack(fit: StackFit.expand, children: [
  //       FittedBox(
  //         fit: BoxFit.cover,
  //         child: SizedBox(
  //           width: _videoController!.value.size.width,
  //           height: _videoController!.value.size.height,
  //           child: VideoPlayer(_videoController!),
  //         ),
  //       ),
  //       // Play/pause overlay
  //       if (!_videoController!.value.isPlaying)
  //         Container(
  //           color: Colors.black.withOpacity(0.35),
  //           child: const Center(
  //             child: Icon(Icons.play_circle_outline_rounded,
  //                 color: Colors.white, size: 52),
  //           ),
  //         ),
  //     ]);
  //   }
  //
  //   if (_videoError) {
  //     // ✅ CHANGE 4c: error state me bhi thumbnail background rahega
  //     return thumbnailBackground(
  //       overlayChild: const Center(
  //         child: Column(mainAxisSize: MainAxisSize.min, children: [
  //           Icon(Icons.broken_image_outlined, color: kTextMuted, size: 36),
  //           SizedBox(height: 8),
  //           Text('Video unavailable',
  //               style: TextStyle(color: kTextMuted, fontSize: 11)),
  //         ]),
  //       ),
  //     );
  //   }
  //
  //   // ── Loading / placeholder ──────────────────────────────────────────────
  //   // ✅ CHANGE 4d: video abhi load ho raha he — yahan bhi thumbnail background + branding/loader
  //   return thumbnailBackground(
  //     overlayChild: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       const Text('VERVEE',
  //           style: TextStyle(
  //               color: kGold,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w900,
  //               letterSpacing: 3)),
  //       const Text('A C A D E M Y',
  //           style: TextStyle(
  //               color: kPurpleLight, fontSize: 7, letterSpacing: 3)),
  //       const SizedBox(height: 12),
  //       if (_videoController == null && (video?.videoUrl?.isEmpty ?? true))
  //         const Icon(Icons.play_circle_outline_rounded,
  //             color: Colors.white54, size: 40)
  //       else
  //         const SizedBox(
  //           width: 32,
  //           height: 32,
  //           child: CircularProgressIndicator(
  //               color: kGold, strokeWidth: 2),
  //         ),
  //     ]),
  //   );
  // }

  Widget _buildVideoContent(CourseVideo? video) {
    if (_isFullscreen) return Container(color: Colors.black);
    if (_videoInitialized && _videoController != null) {
      return Stack(fit: StackFit.expand, children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
        // Play/pause overlay
        if (!_videoController!.value.isPlaying)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(
              child: Icon(Icons.play_circle_outline_rounded,
                  color: Colors.white, size: 52),
            ),
          ),
      ]);
    }

    if (_videoError) {
      return Container(
        color: kBgCard,
        child: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.broken_image_outlined, color: kTextMuted, size: 36),
            SizedBox(height: 8),
            Text('Video unavailable',
                style: TextStyle(color: kTextMuted, fontSize: 11)),
          ]),
        ),
      );
    }

    // Loading / placeholder
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
            child: CircularProgressIndicator(
                color: kGold, strokeWidth: 2),
          ),
      ]),
    );
  }

  // Widget _buildRealControls() {
  //   return ValueListenableBuilder(
  //     valueListenable: _videoController!,
  //     builder: (_, value, __) {
  //       final pos = value.position;
  //       final dur = value.duration;
  //       final get_progress =
  //       dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;
  //
  //       String _fmt(Duration d) {
  //         final m = d.inMinutes;
  //         final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  //         return '$m:$s';
  //       }
  //
  //       return Row(children: [
  //         Icon(
  //           value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
  //           color: kPurpleLight, size: 18,
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: GestureDetector(
  //             onTapDown: (d) {
  //               final box = context.findRenderObject() as RenderBox?;
  //               if (box != null) {
  //                 // Seek on tap (rough position)
  //                 final newPos = dur * get_progress;
  //                 _videoController!.seekTo(newPos);
  //               }
  //             },
  //             child: Container(
  //               height: 4,
  //               decoration: BoxDecoration(
  //                   color: kBorder, borderRadius: BorderRadius.circular(2)),
  //               child: FractionallySizedBox(
  //                 alignment: Alignment.centerLeft,
  //                 widthFactor: get_progress.clamp(0.0, 1.0),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                       color: kPurple, borderRadius: BorderRadius.circular(2)),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Text('${_fmt(pos)} / ${_fmt(dur)}',
  //             style: const TextStyle(color: kTextMuted, fontSize: 9)),
  //         const SizedBox(width: 8),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               value.volume > 0
  //                   ? _videoController!.setVolume(0)
  //                   : _videoController!.setVolume(1);
  //             });
  //           },
  //           child: Icon(
  //             value.volume > 0
  //                 ? Icons.volume_up_rounded
  //                 : Icons.volume_off_rounded,
  //             color: kPurpleLight,
  //             size: 16,
  //           ),
  //         ),
  //       ]);
  //     },
  //   );
  // }


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
          // ── Seek bar (fixed) ──────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTapDown: (d) => seekTo(d.globalPosition),
              onHorizontalDragUpdate: (d) => seekTo(d.globalPosition),
              child: Container(
                key: _seekBarKey,
                height: 20, // bada tap area
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SizedBox(
                 // key: _seekBarKey,
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

                // Container(
                //   height: 4,
                //   decoration: BoxDecoration(
                //       color: kBorder, borderRadius: BorderRadius.circular(2)),
                //   child: FractionallySizedBox(
                //     alignment: Alignment.centerLeft,
                //     widthFactor: progress.clamp(0.0, 1.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: kPurple, borderRadius: BorderRadius.circular(2)),
                //     ),
                //   ),
                // ),
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
  Widget _buildVideoList(List<CourseVideo> videos) {
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
  Widget _buildChapterInfo(List<CourseVideo> videos) {
    final currentVideo =
    videos.isNotEmpty ? videos[_selectedVideoIndex] : null;

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
          currentVideo?.title ?? widget.course.title,
          style: const TextStyle(
              color: kTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          currentVideo?.content ?? widget.course.content,
          style: const TextStyle(
              color: kTextMuted, fontSize: 11, height: 1.6),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }

  // new changes ------------------------------------------------>

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
              builder: (_) => VideoDetailScreen(
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
                                //key: _seekKey,
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

                              // Container(
                              //   height: 3,
                              //   decoration: BoxDecoration(
                              //     color: Colors.white24,
                              //     borderRadius: BorderRadius.circular(2),
                              //   ),
                              //   child: FractionallySizedBox(
                              //     alignment: Alignment.centerLeft,
                              //     widthFactor: progress.clamp(0.0, 1.0),
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         color: kPurpleLight,
                              //         borderRadius: BorderRadius.circular(2),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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



// ══════════ Without API Integration ══════════════════════════════════════════════>




// ═══════════════════════════════════════════════════════════════════════════════
//  video_detail_screen.dart
//  SCREEN 2 — Video Detail + MCQ Quiz + Next Chapter
//
//  CHANGES / NOTES:
//  ✅ HTML ka exact layout Flutter me convert kiya
//  ✅ Video player UI (thumbnail + get_progress bar + controls)
//  ✅ Chapter badge + title + description
//  ✅ MCQ Quiz section — radio buttons, selected state, Submit button
//  ✅ Next Chapter card bottom me
//  ✅ Quiz answers local state me manage hote hain (Map<int, int>)
//  ✅ Submit pe score snackbar dikhata hai
//  ✅ SharedBottomNav reuse kiya
// ═══════════════════════════════════════════════════════════════════════════════

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// //import '../widgets/HomeScreenWidgets/PostCard.dart';
// //import 'AvatarCustomizationScreen.dart';
// //import 'AvatarCustomizationScreen.dart' show kBgDark;
// import 'FinancialLiteracyScreen.dart';
// // import 'shared_widgets.dart';
// // import 'financial_literacy_screen.dart'; // VideoLesson model ke liye
//
// // ── Quiz question model ───────────────────────────────────────────────────────
// class QuizQuestion {
//   final String question;
//   final List<String> options;
//   final int correctIndex;
//
//   const QuizQuestion({
//     required this.question,
//     required this.options,
//     required this.correctIndex,
//   });
// }
//
// // ── Sample questions — Money Challenge chapter ────────────────────────────────
// final List<QuizQuestion> _moneyQuestions = [
//   const QuizQuestion(
//     question: 'What is the main goal of the 7-Day No-Spend Challenge?',
//     options: [
//       'To stop all spending completely',
//       'To build financial discipline by cutting non-essential expenses',
//       'To earn more money',
//       'To reduce eat-and-bills',
//     ],
//     correctIndex: 1,
//   ),
//   const QuizQuestion(
//     question: 'During the challenge, what type of expenses are allowed?',
//     options: [
//       'Luxury shopping and takeout',
//       'Only essential expenses like food, rent, utilities, and transport',
//       'Entertainment and online shopping',
//       'Subscriptions and gadgets',
//     ],
//     correctIndex: 1,
//   ),
//   const QuizQuestion(
//     question: 'Which of the following is an example of a non-essential expense?',
//     options: [
//       'Medicine',
//       'Groceries for home cooking',
//       'Impulse online shopping',
//       'Electricity bill',
//     ],
//     correctIndex: 2,
//   ),
// ];
//
// // ═══════════════════════════════════════════════════════════════════════════════
// class VideoDetailScreen extends StatefulWidget {
//   final VideoLesson lesson;
//   final int chapterIndex;
//   final List<VideoLesson> allLessons;
//
//   const VideoDetailScreen({
//     super.key,
//     required this.lesson,
//     required this.chapterIndex,
//     required this.allLessons,
//   });
//
//   @override
//   State<VideoDetailScreen> createState() => _VideoDetailScreenState();
// }
//
// class _VideoDetailScreenState extends State<VideoDetailScreen> {
//   // ── Video player state ────────────────────────────────────────────────────
//   bool _isPlaying = false;
//   double _progress = 0.25; // 25% get_progress default (same as HTML)
//
//   // ── Quiz state ─────────────────────────────────────────────────────────────
//   // ✅ Map<questionIndex, selectedOptionIndex>
//   final Map<int, int> _selectedAnswers = {};
//   bool _quizSubmitted = false;
//
//   int _currentNavIndex = 3; // Learn tab active
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
//   // ── Next lesson (wrap around) ─────────────────────────────────────────────
//   VideoLesson? get _nextLesson {
//     final nextIndex = widget.chapterIndex + 1;
//     if (nextIndex < widget.allLessons.length) {
//       return widget.allLessons[nextIndex];
//     }
//     return null;
//   }
//
//   // ── Submit quiz ────────────────────────────────────────────────────────────
//   void _submitQuiz() {
//     if (_selectedAnswers.length < _moneyQuestions.length) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please answer all questions before submitting.'),
//           backgroundColor: const Color(0xFFEF4444),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//       return;
//     }
//
//     // ✅ Score calculate karo
//     int score = 0;
//     for (int i = 0; i < _moneyQuestions.length; i++) {
//       if (_selectedAnswers[i] == _moneyQuestions[i].correctIndex) score++;
//     }
//
//     setState(() => _quizSubmitted = true);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'You scored $score / ${_moneyQuestions.length}! '
//               '${score == _moneyQuestions.length ? '🎉 Perfect!' : 'Keep learning!'}',
//         ),
//         backgroundColor: kPurple,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
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
//           // ✅ Status bar padding
//           SizedBox(height: MediaQuery.of(context).padding.top),
//
//           // ── Back bar (same as HTML back-bar) ───────────────────────────
//           _buildBackBar(),
//
//           // ── Scrollable content ─────────────────────────────────────────
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildVideoPlayer(),
//                   _buildChapterInfo(),
//                   const SizedBox(height: 12),
//                   _buildQuizSection(),
//                   const SizedBox(height: 12),
//                   if (_nextLesson != null) _buildNextChapter(),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       // bottomNavigationBar: SharedBottomNav(
//       //   currentIndex: _currentNavIndex,
//       //   onTabChanged: (i) => setState(() => _currentNavIndex = i),
//       //   onAddTap: () {},
//       // ),
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
//       child: Row(
//         children: [
//           // Back button
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: kPurpleLight,
//               size: 18,
//             ),
//           ),
//           const SizedBox(width: 10),
//           // Title
//           const Text(
//             'Financial Literacy',
//             style: TextStyle(
//               color: kTextPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const Spacer(),
//           // Subtitle — chapter name
//           Text(
//             widget.lesson.title,
//             style: const TextStyle(
//               color: kTextMuted,
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Video Player ───────────────────────────────────────────────────────────
//   Widget _buildVideoPlayer() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Column(
//         children: [
//           // ── Thumbnail / video area ──────────────────────────────────
//           GestureDetector(
//             onTap: () => setState(() => _isPlaying = !_isPlaying),
//             child: Container(
//               height: 180,
//               width: double.infinity,
//               decoration: BoxDecoration(gradient: widget.lesson.gradient),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Vervee logo inside video
//                   const Text(
//                     'VERVEE',
//                     style: TextStyle(
//                       color: kGold,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: 3,
//                     ),
//                   ),
//                   const Text(
//                     'A C A D E M Y',
//                     style: TextStyle(
//                       color: kPurpleLight,
//                       fontSize: 7,
//                       letterSpacing: 3,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // ✅ Play/pause toggle
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.18),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.6),
//                         width: 2,
//                       ),
//                     ),
//                     child: Icon(
//                       _isPlaying
//                           ? Icons.pause_rounded
//                           : Icons.play_arrow_rounded,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // ── Controls bar ───────────────────────────────────────────
//           Container(
//             color: kBgDeep,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 // Play/pause icon
//                 Icon(
//                   _isPlaying
//                       ? Icons.pause_rounded
//                       : Icons.play_arrow_rounded,
//                   color: kPurpleLight,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//
//                 // ✅ Progress bar — GestureDetector se seekable
//                 Expanded(
//                   child: GestureDetector(
//                     onTapDown: (d) {
//                       final box = context.findRenderObject() as RenderBox?;
//                       if (box != null) {
//                         // Simple seek on tap
//                         setState(() => _progress = 0.5);
//                       }
//                     },
//                     child: Container(
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: kBorder,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                       child: FractionallySizedBox(
//                         alignment: Alignment.centerLeft,
//                         widthFactor: _progress,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: kPurple,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//
//                 // Time
//                 const Text(
//                   '0:37 / 2:30',
//                   style: TextStyle(color: kTextMuted, fontSize: 9),
//                 ),
//                 const SizedBox(width: 8),
//
//                 // Volume + fullscreen icons
//                 const Icon(Icons.volume_up_rounded, color: kPurpleLight, size: 16),
//                 const SizedBox(width: 6),
//                 const Icon(Icons.fullscreen_rounded, color: kPurpleLight, size: 16),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Chapter Info ───────────────────────────────────────────────────────────
//   Widget _buildChapterInfo() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Chapter badge pill
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: kBorder,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               'Chapter ${widget.chapterIndex + 1}',
//               style: const TextStyle(
//                 color: kPurpleLight,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // Title
//           Text(
//             widget.lesson.title,
//             style: const TextStyle(
//               color: kTextPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           // Description
//           const Text(
//             'Take control of your spending and boost your savings with Vervee Academy\'s '
//                 '7-Day No-Spend Challenge — a simple, powerful way to reset your finances '
//                 'and build lasting money habits.',
//             style: TextStyle(
//               color: kTextMuted,
//               fontSize: 11,
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Quiz Section ───────────────────────────────────────────────────────────
//   Widget _buildQuizSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Quiz header ───────────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             color: kBorder,
//             child: Row(
//               children: [
//                 const Icon(Icons.psychology_rounded, color: kGold, size: 16),
//                 const SizedBox(width: 6),
//                 const Text(
//                   'Take quiz — test your knowledge',
//                   style: TextStyle(
//                     color: kGold,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const Spacer(),
//                 // Question count badge
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: kBgDeep,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Text(
//                     '7 Questions',
//                     style: TextStyle(color: kPurpleLight, fontSize: 9),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // ── Questions ─────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
//             child: Column(
//               children: List.generate(_moneyQuestions.length, (qi) {
//                 return _buildQuestion(qi, _moneyQuestions[qi]);
//               }),
//             ),
//           ),
//
//           // ── Submit button ─────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
//             child: GestureDetector(
//               onTap: _quizSubmitted ? null : _submitQuiz,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 13),
//                 decoration: BoxDecoration(
//                   // ✅ Disabled state after submit
//                   gradient: _quizSubmitted
//                       ? null
//                       : const LinearGradient(
//                     colors: [kPurple, kPurpleLight],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   color: _quizSubmitted ? kBorder : null,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _quizSubmitted
//                           ? Icons.check_circle_outline_rounded
//                           : Icons.send_rounded,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       _quizSubmitted ? 'Submitted' : 'Submit Answers',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Single Question Widget ─────────────────────────────────────────────────
//   Widget _buildQuestion(int qi, QuizQuestion q) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Q number
//         Text(
//           'Q${qi + 1}.',
//           style: const TextStyle(
//             color: kGold,
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 4),
//
//         // Question text
//         Text(
//           q.question,
//           style: const TextStyle(
//             color: kTextPrimary,
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             height: 1.5,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Options
//         ...List.generate(q.options.length, (oi) {
//           final isSelected = _selectedAnswers[qi] == oi;
//           // ✅ After submit: show correct/wrong colors
//           Color borderColor = kBorder;
//           Color bgColor = kBgDeep;
//           if (_quizSubmitted) {
//             if (oi == q.correctIndex) {
//               borderColor = const Color(0xFF22C55E);
//               bgColor = const Color(0xFF0D2B1A);
//             } else if (isSelected && oi != q.correctIndex) {
//               borderColor = const Color(0xFFEF4444);
//               bgColor = const Color(0xFF2B0D0D);
//             }
//           } else if (isSelected) {
//             borderColor = kPurple;
//             bgColor = const Color(0xFF1a0535);
//           }
//
//           return GestureDetector(
//             onTap: _quizSubmitted
//                 ? null
//                 : () => setState(() => _selectedAnswers[qi] = oi),
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: borderColor, width: 0.8),
//               ),
//               child: Row(
//                 children: [
//                   // Radio circle
//                   Container(
//                     width: 15,
//                     height: 15,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: isSelected ? kPurple : kBorder,
//                         width: 1.5,
//                       ),
//                     ),
//                     child: isSelected
//                         ? Center(
//                       child: Container(
//                         width: 7,
//                         height: 7,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: kPurple,
//                         ),
//                       ),
//                     )
//                         : null,
//                   ),
//                   const SizedBox(width: 9),
//                   // Option text
//                   Expanded(
//                     child: Text(
//                       q.options[oi],
//                       style: TextStyle(
//                         color: isSelected ? kTextPrimary : const Color(0xFFCCCCCC),
//                         fontSize: 10.5,
//                       ),
//                     ),
//                   ),
//                   // ✅ After submit: correct/wrong icon
//                   if (_quizSubmitted && oi == q.correctIndex)
//                     const Icon(Icons.check_circle_rounded,
//                         color: Color(0xFF22C55E), size: 14),
//                   if (_quizSubmitted &&
//                       isSelected &&
//                       oi != q.correctIndex)
//                     const Icon(Icons.cancel_rounded,
//                         color: Color(0xFFEF4444), size: 14),
//                 ],
//               ),
//             ),
//           );
//         }),
//
//         // Divider between questions
//         if (qi < _moneyQuestions.length - 1)
//           Container(
//             height: 0.5,
//             color: kBorder,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//           ),
//       ],
//     );
//   }
//
//   // ── Next Chapter Card ──────────────────────────────────────────────────────
//   Widget _buildNextChapter() {
//     final next = _nextLesson!;
//     final nextIndex = widget.chapterIndex + 1;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: kBgCard,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder, width: 0.5),
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Chapter label header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//             ),
//             child: Text(
//               'Chapter ${nextIndex + 1}',
//               style: const TextStyle(
//                 color: kGold,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//
//           // ✅ Next lesson row — tap karne pe VideoDetailScreen push karo
//           GestureDetector(
//             onTap: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => VideoDetailScreen(
//                   lesson: next,
//                   chapterIndex: nextIndex,
//                   allLessons: widget.allLessons,
//                 ),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   // Mini thumbnail
//                   Container(
//                     width: 54,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       gradient: next.gradient,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                       child: Text(
//                         next.title.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: kGold,
//                           fontSize: 6.5,
//                           fontWeight: FontWeight.w900,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//
//                   // Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           next.title,
//                           style: const TextStyle(
//                             color: kTextPrimary,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           'Chapter ${nextIndex + 1} · Financial Literacy',
//                           style: const TextStyle(
//                             color: kTextMuted,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Play icon
//                   const Icon(
//                     Icons.play_circle_outline_rounded,
//                     color: kPurpleLight,
//                     size: 22,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }