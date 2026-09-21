
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/presentation/widgets/HomeScreenWidgets/showReelCommentSheet.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
//import '../../../domain/model/reel/ReelPost.dart'; // ✅ CHANGED — GetPost ki jagah
import '../../../domain/model/post/PostComment.dart';
import '../../domain/model/post/ReelPost.dart';
import '../viewmodal/post/GetPostViewModel.dart';   // ✅ like/comment ke liye reuse
//import '../viewmodal/reel/ReelViewModel.dart';       // ✅ NEW — reel API ke liye
import '../viewmodal/post/ReelViewModel.dart';
import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
import '../widgets/HomeScreenWidgets/PostCard.dart'; // kBgCard, kPurple, categoryColor, PostAvatar etc.

// ── Constants ──────────────────────────────────────────────────────────────
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kGoldLight   = Color(0xFFFFD700);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);

// ═══════════════════════════════════════════════════════════════════════════
//  PostDetailScreen — ab dedicated Reel API (paginated) use karta he,
//  local feed filter ki jagah
// ═══════════════════════════════════════════════════════════════════════════
class PostDetailScreen extends ConsumerStatefulWidget {
  final int initialPostId;
  const PostDetailScreen({this.initialPostId = 0, super.key});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

// class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
//   late final PageController _pageCtrl;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // ✅ CHANGED — ab initialPage compute karne ki zaroorat nahi,
//     // API khud tapped post ke context se list return karti he (index 0 pe)
//     _pageCtrl = PageController();
//   }
//
//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     super.dispose();
//   }
//
//   // ✅ NEW — end ke 2 items reh jaane par agla page load karo
//   void _onPageChanged(int index, int totalCount) {
//     setState(() => _currentIndex = index);
//     if (index >= totalCount - 2) {
//       ref.read(reelViewModelProvider(widget.initialPostId).notifier).loadMore();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ NEW — family provider, initialPostId ke hisaab se apna alag state rakhta he
//     final reelState = ref.watch(reelViewModelProvider(widget.initialPostId));
//
//     // ── Pehli baar loading ──────────────────────────────────────────────
//     if (reelState.isLoading && reelState.posts.isEmpty) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator(color: kPurple)),
//       );
//     }
//
//     // ── Empty ya error state ─────────────────────────────────────────────
//     if (reelState.posts.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Text(
//               reelState.errorMessage ?? 'No videos found',
//               style: const TextStyle(color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Go back', style: TextStyle(color: kPurpleLight)),
//             ),
//           ]),
//         ),
//       );
//     }
//
//     final videoPosts = reelState.posts;
//     final safeIndex  = _currentIndex.clamp(0, videoPosts.length - 1);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(children: [
//         PageView.builder(
//           controller: _pageCtrl,
//           scrollDirection: Axis.vertical,
//           itemCount: videoPosts.length,
//           onPageChanged: (i) => _onPageChanged(i, videoPosts.length),
//           itemBuilder: (context, index) => _ReelPage(
//             key: ValueKey(videoPosts[index].id),
//             post: videoPosts[index],
//             isActive: index == safeIndex,
//             reelInitialPostId: widget.initialPostId, // ✅ NEW — family key pass karo
//           ),
//         ),
//
//         // ✅ NEW — pagination loading indicator
//         if (reelState.isLoadingMore)
//           const Positioned(
//             bottom: 24, left: 0, right: 0,
//             child: Center(
//               child: CircularProgressIndicator(color: kPurple, strokeWidth: 2),
//             ),
//           ),
//
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 8,
//           left: 8,
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
//               child: const Icon(Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white, size: 18),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late final PageController _pageCtrl;
  int _currentIndex = 0;
  bool _hasSetInitialIndex = false; // ✅ NEW

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, int totalCount) {
    setState(() => _currentIndex = index);
    if (index >= totalCount - 2) {
      ref.read(reelViewModelProvider(widget.initialPostId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reelState = ref.watch(reelViewModelProvider(widget.initialPostId));

    if (reelState.isLoading && reelState.posts.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: kPurple)),
      );
    }

    if (reelState.posts.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              reelState.errorMessage ?? 'No videos found',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go back', style: TextStyle(color: kPurpleLight)),
            ),
          ]),
        ),
      );
    }

    final videoPosts = reelState.posts;

    // ✅ NEW — tapped post ka exact index list me dhoondo, sirf ek baar
    if (!_hasSetInitialIndex && videoPosts.isNotEmpty) {
      final targetIndex = videoPosts.indexWhere((p) => p.id == widget.initialPostId);
      _hasSetInitialIndex = true;
      if (targetIndex != -1) {
        _currentIndex = targetIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageCtrl.hasClients) {
            _pageCtrl.jumpToPage(targetIndex); // ✅ seedha wahi page pe le jao, animation nahi chahiye
          }
        });
      }
    }

    final safeIndex = _currentIndex.clamp(0, videoPosts.length - 1);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        PageView.builder(
          controller: _pageCtrl,
          scrollDirection: Axis.vertical,
          itemCount: videoPosts.length,
          onPageChanged: (i) => _onPageChanged(i, videoPosts.length),
          itemBuilder: (context, index) => _ReelPage(
            key: ValueKey(videoPosts[index].id),
            post: videoPosts[index],
            isActive: index == safeIndex,
            reelInitialPostId: widget.initialPostId,
          ),
        ),

        if (reelState.isLoadingMore)
          const Positioned(
            bottom: 24, left: 0, right: 0,
            child: Center(
              child: CircularProgressIndicator(color: kPurple, strokeWidth: 2),
            ),
          ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  _ReelPage — default unmuted + center play/pause tap icon + Read more
// ═══════════════════════════════════════════════════════════════════════════
class _ReelPage extends ConsumerStatefulWidget {
  final ReelPost post; // ✅ CHANGED — GetPost ki jagah ReelPost
  final bool isActive;
  final int reelInitialPostId; // ✅ NEW — like update ke liye family key chahiye
  const _ReelPage({
    required this.post,
    required this.isActive,
    required this.reelInitialPostId,
    super.key,
  });

  @override
  ConsumerState<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends ConsumerState<_ReelPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError    = false;
  bool _isMuted     = false;
  bool _isPlaying   = true;

  late ReelPost post; // ✅ CHANGED
  List<PostComment> _comments = [];
  bool _commentsLoading = true;

  late AnimationController _likeCtrl;
  late Animation<double> _likeScale;

  String _normalizeMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;

    _likeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));

    _initVideo();
    _loadComments();
  }

  // Future<void> _initVideo() async {
  //   if (post.filePath == null || post.filePath!.isEmpty) return;
  //   try {
  //     final fileInfo = await DefaultCacheManager()
  //         .getSingleFile(_normalizeMediaUrl(post.filePath!));
  //     final controller = VideoPlayerController.file(fileInfo);
  //     await controller.initialize();
  //     await controller.setLooping(true);
  //     await controller.setVolume(_isMuted ? 0 : 1);
  //
  //     if (!mounted) {
  //       controller.dispose();
  //       return;
  //     }
  //
  //     setState(() {
  //       _controller  = controller;
  //       _initialized = true;
  //     });
  //
  //     if (widget.isActive) {
  //       _controller!.play();
  //       setState(() => _isPlaying = true);
  //     } else {
  //       setState(() => _isPlaying = false);
  //     }
  //   } catch (_) {
  //     if (mounted) setState(() => _hasError = true);
  //   }
  // }

  Future<void> _initVideo() async {
    if (post.filePath == null || post.filePath!.isEmpty) return;
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(_normalizeMediaUrl(post.filePath!)),
      );
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(_isMuted ? 0 : 1);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller  = controller;
        _initialized = true;
      });

      if (widget.isActive) {
        _controller!.play();
        setState(() => _isPlaying = true);
      } else {
        setState(() => _isPlaying = false);
      }
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void didUpdateWidget(covariant _ReelPage old) {
    super.didUpdateWidget(old);
    if (_controller != null) {
      if (widget.isActive && !old.isActive) {
        _controller!.play();
        setState(() => _isPlaying = true);
      } else if (!widget.isActive && old.isActive) {
        _controller!.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  Future<void> _loadComments() async {
    // ✅ like/comment endpoints reuse ho rahe he — GetPostViewModel me hi he,
    // ye generic post-id based backend call he, kisi specific list se bandha nahi
    final comments = await ref
        .read(getPostViewModelProvider.notifier)
        .fetchComments(post.id);
    if (!mounted) return;
    setState(() {
      _comments = comments;
      _commentsLoading = false;
    });
  }

  Future<void> _handleLike() async {
    _likeCtrl.forward(from: 0);
    final newIsLiked    = !post.isLiked;
    final newLikesCount = post.isLiked ? post.likesCount - 1 : post.likesCount + 1;

    setState(() {
      post = post.copyWith(isLiked: newIsLiked, likesCount: newLikesCount);
    });
    // ✅ NEW — reel list ke state ko bhi sync rakho, taaki scroll back/forward
    // karne pe like state consistent rahe
    ref.read(reelViewModelProvider(widget.reelInitialPostId).notifier)
        .updateLikeLocally(post.id, newIsLiked, newLikesCount);

    final error = await ref
        .read(getPostViewModelProvider.notifier)
        .toggleLike(post.id);

    if (error != null && mounted) {
      final revertLiked = !newIsLiked;
      final revertCount = newIsLiked ? newLikesCount - 1 : newLikesCount + 1;
      setState(() {
        post = post.copyWith(isLiked: revertLiked, likesCount: revertCount);
      });
      ref.read(reelViewModelProvider(widget.reelInitialPostId).notifier)
          .updateLikeLocally(post.id, revertLiked, revertCount);
    }
  }

  // void _handleComment() {
  //   showCommentSheet(context, ref, post);
  //   Future.delayed(const Duration(milliseconds: 300), _loadComments);
  // }

    void _handleComment() {
    showReelCommentSheet(context, ref, post);
    Future.delayed(const Duration(milliseconds: 300), _loadComments);
  }

  void _toggleMute() {
    if (_controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  String _stripHtml(String html) => parse(html).body?.text ?? '';

  void _showFullContent(BuildContext context) {
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: categoryColor(post.category).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: categoryColor(post.category).withOpacity(0.5)),
                    ),
                    child: Text(post.category,
                        style: TextStyle(
                          color: categoryColor(post.category),
                          fontSize: 10, fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                Text(post.title,
                    style: const TextStyle(
                      color: kTextPrimary, fontSize: 16,
                      fontWeight: FontWeight.w800, height: 1.4,
                    )),
              ]),
            ),
            const Divider(color: kBorder, height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Html(
                  data: post.content,
                  style: {
                    "body": Style(
                      color: kTextMuted,
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.7),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(margin: Margins.only(bottom: 10)),
                    "ul": Style(
                      margin: Margins.only(bottom: 10, left: 4),
                      padding: HtmlPaddings.only(left: 16),
                    ),
                    "ol": Style(
                      margin: Margins.only(bottom: 10, left: 4),
                      padding: HtmlPaddings.only(left: 16),
                    ),
                    "li": Style(margin: Margins.only(bottom: 4)),
                    "strong": Style(color: kTextPrimary, fontWeight: FontWeight.w700),
                    "em": Style(fontStyle: FontStyle.italic),
                    "a": Style(color: kPurpleLight),
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _likeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColor(post.category);

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        color: Colors.black,
        child: Stack(fit: StackFit.expand, children: [
          if (_hasError)
            const Center(
              child: Icon(Icons.videocam_off_rounded, color: kTextMuted, size: 48),
            )
          else if (!_initialized || _controller == null)
            const Center(child: CircularProgressIndicator(color: kPurple))
          else
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),

          if (_initialized)
            Center(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 38),
                  ),
                ),
              ),
            ),

          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 50,
                left: 14, right: 14, bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                ),
              ),
              child: Row(children: [
                PostAvatar(avatarUrl: post.userAvatarUrl, userName: post.userName),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(post.userName,
                      style: const TextStyle(
                          color: kGold, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: catColor.withOpacity(0.6)),
                  ),
                  child: Text(post.category,
                      style: TextStyle(
                          color: catColor, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
          ),

          Positioned(
            right: 12, bottom: 110,
            child: Column(children: [
              GestureDetector(
                onTap: _handleLike,
                child: Column(children: [
                  ScaleTransition(
                    scale: _likeScale,
                    child: Icon(
                      post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 30,
                      color: post.isLiked ? const Color(0xFFEA4335) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text('${post.likesCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                ]),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _handleComment,
                child: Column(children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Colors.white),
                  const SizedBox(height: 3),
                  if (!_commentsLoading)
                    Text('${_comments.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11)),
                ]),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _toggleMute,
                child: Icon(
                  _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  size: 26, color: Colors.white,
                ),
              ),
            ]),
          ),

          Positioned(
            left: 14, right: 80, bottom: 24,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(post.title,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14,
                      fontWeight: FontWeight.w700, height: 1.3)),
              const SizedBox(height: 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  final text = _stripHtml(post.content);
                  const contentStyle = TextStyle(
                      color: Colors.white70, fontSize: 12, height: 1.4);
                  final textPainter = TextPainter(
                    text: TextSpan(text: text, style: contentStyle),
                    maxLines: 2,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);
                  final isOverflowing = textPainter.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: contentStyle),
                      if (isOverflowing)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: GestureDetector(
                            onTap: () => _showFullContent(context),
                            child: const Text('Read more',
                                style: TextStyle(
                                    color: kPurpleLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_html/flutter_html.dart'; // ✅ NEW — formatted content ke liye
// import 'package:html/parser.dart' show parse;
// import '../../../domain/model/post/GetPost.dart';
// import '../../../domain/model/post/PostComment.dart';
// import '../viewmodal/post/GetPostViewModel.dart';
// import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
// import '../widgets/HomeScreenWidgets/PostCard.dart'; // kBgCard, kPurple, categoryColor, PostAvatar etc.
//
// // ── Constants ──────────────────────────────────────────────────────────────
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
// // ═══════════════════════════════════════════════════════════════════════════
// //  PostDetailScreen — ab sirf tapped post ka id leta hai, video list
// //  reactively provider se live watch karta hai
// // ═══════════════════════════════════════════════════════════════════════════
// class PostDetailScreen extends ConsumerStatefulWidget {
//   final int initialPostId; // ✅ CHANGED — snapshot list ki jagah sirf id
//   const PostDetailScreen({required this.initialPostId, super.key});
//
//   @override
//   ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
// }
//
// class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
//   late final PageController _pageCtrl;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // ✅ Initial index sirf ek baar compute karo — initState mein ref.read theek hai
//     final allPosts   = ref.read(getPostViewModelProvider).posts;
//     final videoPosts = allPosts.where((p) => p.fileType == 'video').toList();
//     final startIndex = videoPosts.indexWhere((p) => p.id == widget.initialPostId);
//     _currentIndex = startIndex < 0 ? 0 : startIndex;
//     _pageCtrl = PageController(initialPage: _currentIndex);
//   }
//
//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ NEW — reactively watch karo, taaki refresh/load-more ke baad
//     // updated video list yahan turant reflect ho, koi frozen snapshot nahi
//     final allPosts   = ref.watch(getPostViewModelProvider).posts;
//     final videoPosts = allPosts.where((p) => p.fileType == 'video').toList();
//
//     if (videoPosts.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('No videos found', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       );
//     }
//
//     final safeIndex = _currentIndex.clamp(0, videoPosts.length - 1);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(children: [
//         PageView.builder(
//           controller: _pageCtrl,
//           scrollDirection: Axis.vertical,
//           itemCount: videoPosts.length,
//           onPageChanged: (i) => setState(() => _currentIndex = i),
//           itemBuilder: (context, index) => _ReelPage(
//             key: ValueKey(videoPosts[index].id), // ✅ NEW — stable identity per post
//             post: videoPosts[index],
//             isActive: index == safeIndex,
//           ),
//         ),
//
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 8,
//           left: 8,
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
//               child: const Icon(Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white, size: 18),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════
// //  _ReelPage — default unmuted + center play/pause tap icon + Read more
// // ═══════════════════════════════════════════════════════════════════════════
// class _ReelPage extends ConsumerStatefulWidget {
//   final GetPost post;
//   final bool isActive;
//   const _ReelPage({required this.post, required this.isActive, super.key});
//
//   @override
//   ConsumerState<_ReelPage> createState() => _ReelPageState();
// }
//
// class _ReelPageState extends ConsumerState<_ReelPage>
//     with SingleTickerProviderStateMixin {
//   VideoPlayerController? _controller;
//   bool _initialized = false;
//   bool _hasError    = false;
//   bool _isMuted     = false; // ✅ default unmuted
//   bool _isPlaying   = true;  // ✅ NEW — center play/pause icon ke liye
//
//   late GetPost post;
//   List<PostComment> _comments = [];
//   bool _commentsLoading = true;
//
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   String _normalizeMediaUrl(String url) {
//     if (url.startsWith('http://') || url.startsWith('https://')) return url;
//     return 'https://$url';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     post = widget.post;
//
//     _likeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//
//     _initVideo();
//     _loadComments();
//   }
//
//   Future<void> _initVideo() async {
//     if (post.filePath == null || post.filePath!.isEmpty) return;
//     try {
//       final fileInfo = await DefaultCacheManager()
//           .getSingleFile(_normalizeMediaUrl(post.filePath!));
//       final controller = VideoPlayerController.file(fileInfo);
//       await controller.initialize();
//       await controller.setLooping(true);
//       await controller.setVolume(_isMuted ? 0 : 1); // ✅ unmuted by default
//
//       if (!mounted) {
//         controller.dispose();
//         return;
//       }
//
//       setState(() {
//         _controller  = controller;
//         _initialized = true;
//       });
//
//       if (widget.isActive) {
//         _controller!.play();
//         setState(() => _isPlaying = true); // ✅ NEW
//       } else {
//         setState(() => _isPlaying = false); // ✅ NEW
//       }
//     } catch (_) {
//       if (mounted) setState(() => _hasError = true);
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant _ReelPage old) {
//     super.didUpdateWidget(old);
//     if (_controller != null) {
//       if (widget.isActive && !old.isActive) {
//         _controller!.play();
//         setState(() => _isPlaying = true); // ✅ NEW
//       } else if (!widget.isActive && old.isActive) {
//         _controller!.pause();
//         setState(() => _isPlaying = false); // ✅ NEW
//       }
//     }
//   }
//
//   Future<void> _loadComments() async {
//     final comments = await ref
//         .read(getPostViewModelProvider.notifier)
//         .fetchComments(post.id);
//     if (!mounted) return;
//     setState(() {
//       _comments = comments;
//       _commentsLoading = false;
//     });
//   }
//
//   Future<void> _handleLike() async {
//     _likeCtrl.forward(from: 0);
//     setState(() {
//       post = post.copyWith(
//         isLiked: !post.isLiked,
//         likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//       );
//     });
//
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .toggleLike(post.id);
//
//     if (error != null && mounted) {
//       setState(() {
//         post = post.copyWith(
//           isLiked: !post.isLiked,
//           likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//         );
//       });
//     }
//   }
//
//   void _handleComment() {
//     showCommentSheet(context, ref, post);
//     Future.delayed(const Duration(milliseconds: 300), _loadComments);
//   }
//
//   void _toggleMute() {
//     if (_controller == null) return;
//     setState(() {
//       _isMuted = !_isMuted;
//       _controller!.setVolume(_isMuted ? 0 : 1);
//     });
//   }
//
//   void _togglePlayPause() {
//     if (_controller == null) return;
//     setState(() {
//       if (_controller!.value.isPlaying) {
//         _controller!.pause();
//         _isPlaying = false; // ✅ NEW
//       } else {
//         _controller!.play();
//         _isPlaying = true; // ✅ NEW
//       }
//     });
//   }
//
//   String _stripHtml(String html) => parse(html).body?.text ?? '';
//
//   // ✅ NEW — PostCard jaisa hi full-content bottom sheet, formatted HTML ke sath
//   void _showFullContent(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.75,
//         minChildSize: 0.4,
//         maxChildSize: 0.95,
//         builder: (_, scrollCtrl) => Container(
//           decoration: const BoxDecoration(
//             color: kBgCard,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(children: [
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                   color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: categoryColor(post.category).withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                           color: categoryColor(post.category).withOpacity(0.5)),
//                     ),
//                     child: Text(post.category,
//                         style: TextStyle(
//                           color: categoryColor(post.category),
//                           fontSize: 10, fontWeight: FontWeight.w700,
//                         )),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(post.title,
//                     style: const TextStyle(
//                       color: kTextPrimary, fontSize: 16,
//                       fontWeight: FontWeight.w800, height: 1.4,
//                     )),
//               ]),
//             ),
//             const Divider(color: kBorder, height: 1),
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: scrollCtrl,
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//                 child: Html(
//                   data: post.content, // ✅ raw HTML seedha pass karo, plain text nahi
//                   style: {
//                     "body": Style(
//                       color: kTextMuted,
//                       fontSize: FontSize(14),
//                       lineHeight: LineHeight(1.7),
//                       margin: Margins.zero,
//                       padding: HtmlPaddings.zero,
//                     ),
//                     "p": Style(
//                       margin: Margins.only(bottom: 10),
//                     ),
//                     "ul": Style(
//                       margin: Margins.only(bottom: 10, left: 4),
//                       padding: HtmlPaddings.only(left: 16),
//                     ),
//                     "ol": Style(
//                       margin: Margins.only(bottom: 10, left: 4),
//                       padding: HtmlPaddings.only(left: 16),
//                     ),
//                     "li": Style(
//                       margin: Margins.only(bottom: 4),
//                     ),
//                     "strong": Style(
//                       color: kTextPrimary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     "em": Style(
//                       fontStyle: FontStyle.italic,
//                     ),
//                     "a": Style(
//                       color: kPurpleLight,
//                     ),
//                   },
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final catColor = categoryColor(post.category);
//
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Container(
//         color: Colors.black,
//         child: Stack(fit: StackFit.expand, children: [
//           if (_hasError)
//             const Center(
//               child: Icon(Icons.videocam_off_rounded, color: kTextMuted, size: 48),
//             )
//           else if (!_initialized || _controller == null)
//             const Center(
//               child: CircularProgressIndicator(color: kPurple),
//             )
//           else
//             FittedBox(
//               fit: BoxFit.contain,
//               child: SizedBox(
//                 width: _controller!.value.size.width,
//                 height: _controller!.value.size.height,
//                 child: VideoPlayer(_controller!),
//               ),
//             ),
//
//           // ✅ center play/pause icon, tap pe fade in/out
//           if (_initialized)
//             Center(
//               child: IgnorePointer(
//                 child: AnimatedOpacity(
//                   opacity: _isPlaying ? 0.0 : 1.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: Container(
//                     width: 64,
//                     height: 64,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow_rounded,
//                       color: Colors.white,
//                       size: 38,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//           Positioned(
//             top: 0, left: 0, right: 0,
//             child: Container(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).padding.top + 50,
//                 left: 14, right: 14, bottom: 16,
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                   colors: [Colors.black.withOpacity(0.55), Colors.transparent],
//                 ),
//               ),
//               child: Row(children: [
//                 PostAvatar(avatarUrl: post.userAvatarUrl, userName: post.userName),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(post.userName,
//                       style: const TextStyle(
//                           color: kGold, fontSize: 13, fontWeight: FontWeight.w600)),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: catColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: catColor.withOpacity(0.6)),
//                   ),
//                   child: Text(post.category,
//                       style: TextStyle(
//                           color: catColor, fontSize: 10, fontWeight: FontWeight.w700)),
//                 ),
//               ]),
//             ),
//           ),
//
//           Positioned(
//             right: 12, bottom: 110,
//             child: Column(children: [
//               GestureDetector(
//                 onTap: _handleLike,
//                 child: Column(children: [
//                   ScaleTransition(
//                     scale: _likeScale,
//                     child: Icon(
//                       post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                       size: 30,
//                       color: post.isLiked ? const Color(0xFFEA4335) : Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text('${post.likesCount}',
//                       style: const TextStyle(color: Colors.white, fontSize: 11)),
//                 ]),
//               ),
//               const SizedBox(height: 22),
//               GestureDetector(
//                 onTap: _handleComment,
//                 child: Column(children: [
//                   const Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Colors.white),
//                   const SizedBox(height: 3),
//                   if (!_commentsLoading)
//                     Text('${_comments.length}',
//                         style: const TextStyle(color: Colors.white, fontSize: 11)),
//                 ]),
//               ),
//               const SizedBox(height: 22),
//               GestureDetector(
//                 onTap: _toggleMute,
//                 child: Icon(
//                   _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
//                   size: 26, color: Colors.white,
//                 ),
//               ),
//             ]),
//           ),
//
//           // ✅ CHANGED — title + content ab LayoutBuilder ke andar, "Read more"
//           // ka option add kiya gaya he jab content 2 lines se overflow ho
//           Positioned(
//             left: 14, right: 80, bottom: 24,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(post.title,
//                   maxLines: 2, overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       color: Colors.white, fontSize: 14,
//                       fontWeight: FontWeight.w700, height: 1.3)),
//               const SizedBox(height: 4),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final text = _stripHtml(post.content);
//                   const contentStyle = TextStyle(
//                       color: Colors.white70, fontSize: 12, height: 1.4);
//                   final textPainter = TextPainter(
//                     text: TextSpan(text: text, style: contentStyle),
//                     maxLines: 2,
//                     textDirection: TextDirection.ltr,
//                   )..layout(maxWidth: constraints.maxWidth);
//                   final isOverflowing = textPainter.didExceedMaxLines;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(text,
//                           maxLines: 2, overflow: TextOverflow.ellipsis,
//                           style: contentStyle),
//                       if (isOverflowing)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: GestureDetector(
//                             onTap: () => _showFullContent(context),
//                             child: const Text('Read more',
//                                 style: TextStyle(
//                                     color: kPurpleLight,
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600)),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }













// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:html/parser.dart' show parse;
// import '../../../domain/model/post/GetPost.dart';
// import '../../../domain/model/post/PostComment.dart';
// import '../viewmodal/post/GetPostViewModel.dart';
// import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
// import '../widgets/HomeScreenWidgets/PostCard.dart'; // kBgCard, kPurple, categoryColor, PostAvatar etc.
//
// // ── Constants ──────────────────────────────────────────────────────────────
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
// // ═══════════════════════════════════════════════════════════════════════════
// //  PostDetailScreen — ab sirf tapped post ka id leta hai, video list
// //  reactively provider se live watch karta hai
// // ═══════════════════════════════════════════════════════════════════════════
// class PostDetailScreen extends ConsumerStatefulWidget {
//   final int initialPostId; // ✅ CHANGED — snapshot list ki jagah sirf id
//   const PostDetailScreen({required this.initialPostId, super.key});
//
//   @override
//   ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
// }
//
// class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
//   late final PageController _pageCtrl;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // ✅ Initial index sirf ek baar compute karo — initState mein ref.read theek hai
//     final allPosts   = ref.read(getPostViewModelProvider).posts;
//     final videoPosts = allPosts.where((p) => p.fileType == 'video').toList();
//     final startIndex = videoPosts.indexWhere((p) => p.id == widget.initialPostId);
//     _currentIndex = startIndex < 0 ? 0 : startIndex;
//     _pageCtrl = PageController(initialPage: _currentIndex);
//   }
//
//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ NEW — reactively watch karo, taaki refresh/load-more ke baad
//     // updated video list yahan turant reflect ho, koi frozen snapshot nahi
//     final allPosts   = ref.watch(getPostViewModelProvider).posts;
//     final videoPosts = allPosts.where((p) => p.fileType == 'video').toList();
//
//     if (videoPosts.isEmpty) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('No videos found', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       );
//     }
//
//     final safeIndex = _currentIndex.clamp(0, videoPosts.length - 1);
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(children: [
//         PageView.builder(
//           controller: _pageCtrl,
//           scrollDirection: Axis.vertical,
//           itemCount: videoPosts.length,
//           onPageChanged: (i) => setState(() => _currentIndex = i),
//           itemBuilder: (context, index) => _ReelPage(
//             key: ValueKey(videoPosts[index].id), // ✅ NEW — stable identity per post
//             post: videoPosts[index],
//             isActive: index == safeIndex,
//           ),
//         ),
//
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 8,
//           left: 8,
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
//               child: const Icon(Icons.arrow_back_ios_new_rounded,
//                   color: Colors.white, size: 18),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════
// //  _ReelPage — same as pehle (unchanged)
// // ═══════════════════════════════════════════════════════════════════════════
// class _ReelPage extends ConsumerStatefulWidget {
//   final GetPost post;
//   final bool isActive;
//   const _ReelPage({required this.post, required this.isActive, super.key});
//
//   @override
//   ConsumerState<_ReelPage> createState() => _ReelPageState();
// }
//
// class _ReelPageState extends ConsumerState<_ReelPage>
//     with SingleTickerProviderStateMixin {
//   VideoPlayerController? _controller;
//   bool _initialized = false;
//   bool _hasError    = false;
//   bool _isMuted     = false;
//
//   late GetPost post;
//   List<PostComment> _comments = [];
//   bool _commentsLoading = true;
//
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   String _normalizeMediaUrl(String url) {
//     if (url.startsWith('http://') || url.startsWith('https://')) return url;
//     return 'https://$url';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     post = widget.post;
//
//     _likeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//
//     _initVideo();
//     _loadComments();
//   }
//
//   Future<void> _initVideo() async {
//     if (post.filePath == null || post.filePath!.isEmpty) return;
//     try {
//       final fileInfo = await DefaultCacheManager()
//           .getSingleFile(_normalizeMediaUrl(post.filePath!));
//       final controller = VideoPlayerController.file(fileInfo);
//       await controller.initialize();
//       await controller.setLooping(true);
//       await controller.setVolume(_isMuted ? 0 : 1);
//
//       if (!mounted) {
//         controller.dispose();
//         return;
//       }
//
//       setState(() {
//         _controller  = controller;
//         _initialized = true;
//       });
//
//       if (widget.isActive) _controller!.play();
//     } catch (_) {
//       if (mounted) setState(() => _hasError = true);
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant _ReelPage old) {
//     super.didUpdateWidget(old);
//     if (_controller != null) {
//       if (widget.isActive && !old.isActive) {
//         _controller!.play();
//       } else if (!widget.isActive && old.isActive) {
//         _controller!.pause();
//       }
//     }
//   }
//
//   Future<void> _loadComments() async {
//     final comments = await ref
//         .read(getPostViewModelProvider.notifier)
//         .fetchComments(post.id);
//     if (!mounted) return;
//     setState(() {
//       _comments = comments;
//       _commentsLoading = false;
//     });
//   }
//
//   Future<void> _handleLike() async {
//     _likeCtrl.forward(from: 0);
//     setState(() {
//       post = post.copyWith(
//         isLiked: !post.isLiked,
//         likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//       );
//     });
//
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .toggleLike(post.id);
//
//     if (error != null && mounted) {
//       setState(() {
//         post = post.copyWith(
//           isLiked: !post.isLiked,
//           likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//         );
//       });
//     }
//   }
//
//   void _handleComment() {
//     showCommentSheet(context, ref, post);
//     Future.delayed(const Duration(milliseconds: 300), _loadComments);
//   }
//
//   void _toggleMute() {
//     if (_controller == null) return;
//     setState(() {
//       _isMuted = !_isMuted;
//       _controller!.setVolume(_isMuted ? 0 : 1);
//     });
//   }
//
//   void _togglePlayPause() {
//     if (_controller == null) return;
//     setState(() {
//       if (_controller!.value.isPlaying) {
//         _controller!.pause();
//       } else {
//         _controller!.play();
//       }
//     });
//   }
//
//   String _stripHtml(String html) => parse(html).body?.text ?? '';
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final catColor = categoryColor(post.category);
//
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Container(
//         color: Colors.black,
//         child: Stack(fit: StackFit.expand, children: [
//           if (_hasError)
//             const Center(
//               child: Icon(Icons.videocam_off_rounded, color: kTextMuted, size: 48),
//             )
//           else if (!_initialized || _controller == null)
//             const Center(
//               child: CircularProgressIndicator(color: kPurple),
//             )
//           else
//             FittedBox(
//               fit: BoxFit.contain,
//               child: SizedBox(
//                 width: _controller!.value.size.width,
//                 height: _controller!.value.size.height,
//                 child: VideoPlayer(_controller!),
//               ),
//             ),
//
//           Positioned(
//             top: 0, left: 0, right: 0,
//             child: Container(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).padding.top + 50,
//                 left: 14, right: 14, bottom: 16,
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                   colors: [Colors.black.withOpacity(0.55), Colors.transparent],
//                 ),
//               ),
//               child: Row(children: [
//                 PostAvatar(avatarUrl: post.userAvatarUrl, userName: post.userName),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(post.userName,
//                       style: const TextStyle(
//                           color: kGold, fontSize: 13, fontWeight: FontWeight.w600)),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: catColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: catColor.withOpacity(0.6)),
//                   ),
//                   child: Text(post.category,
//                       style: TextStyle(
//                           color: catColor, fontSize: 10, fontWeight: FontWeight.w700)),
//                 ),
//               ]),
//             ),
//           ),
//
//           Positioned(
//             right: 12, bottom: 110,
//             child: Column(children: [
//               GestureDetector(
//                 onTap: _handleLike,
//                 child: Column(children: [
//                   ScaleTransition(
//                     scale: _likeScale,
//                     child: Icon(
//                       post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                       size: 30,
//                       color: post.isLiked ? const Color(0xFFEA4335) : Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text('${post.likesCount}',
//                       style: const TextStyle(color: Colors.white, fontSize: 11)),
//                 ]),
//               ),
//               const SizedBox(height: 22),
//               GestureDetector(
//                 onTap: _handleComment,
//                 child: Column(children: [
//                   const Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Colors.white),
//                   const SizedBox(height: 3),
//                   if (!_commentsLoading)
//                     Text('${_comments.length}',
//                         style: const TextStyle(color: Colors.white, fontSize: 11)),
//                 ]),
//               ),
//               const SizedBox(height: 22),
//               GestureDetector(
//                 onTap: _toggleMute,
//                 child: Icon(
//                   _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
//                   size: 26, color: Colors.white,
//                 ),
//               ),
//             ]),
//           ),
//
//           Positioned(
//             left: 14, right: 80, bottom: 24,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(post.title,
//                   maxLines: 2, overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       color: Colors.white, fontSize: 14,
//                       fontWeight: FontWeight.w700, height: 1.3)),
//               const SizedBox(height: 4),
//               Text(_stripHtml(post.content),
//                   maxLines: 2, overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }



















// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_html/flutter_html.dart';
// import '../../../domain/model/post/GetPost.dart';
// import '../../../domain/model/post/PostComment.dart';
// //import '../../viewmodal/post/GetPostViewModel.dart';
// import '../viewmodal/post/GetPostViewModel.dart';
// import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
// import '../widgets/HomeScreenWidgets/PostCard.dart'; // kBgCard, kPurple, categoryColor, _PostImageArea etc.
//
//
// // ── Constants (apni file se import karo) ─────────────────────────────────────
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
//
// class PostDetailScreen extends ConsumerStatefulWidget {
//   final GetPost post;
//   const PostDetailScreen({required this.post, super.key});
//
//   @override
//   ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
// }
//
// class _PostDetailScreenState extends ConsumerState<PostDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late GetPost post; // local mutable copy — like/count update ke liye
//   late AnimationController _likeCtrl;
//   late Animation<double> _likeScale;
//
//   List<PostComment> _comments = [];
//   bool _commentsLoading = true;
//   bool _isSharing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     post = widget.post;
//
//     _likeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//
//     _loadComments();
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadComments() async {
//     final comments = await ref
//         .read(getPostViewModelProvider.notifier)
//         .fetchComments(post.id);
//     if (!mounted) return;
//     setState(() {
//       _comments = comments;
//       _commentsLoading = false;
//     });
//   }
//
//   Future<void> _handleLike() async {
//     _likeCtrl.forward(from: 0);
//     // ✅ Optimistic UI — screen apna alag copy rakhta he isliye local update zaroori
//     setState(() {
//       post = post.copyWith(
//         isLiked: !post.isLiked,
//         likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//       );
//     });
//
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .toggleLike(post.id);
//
//     if (error != null && mounted) {
//       // rollback on error
//       setState(() {
//         post = post.copyWith(
//           isLiked: !post.isLiked,
//           likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
//         );
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(error),
//         backgroundColor: const Color(0xFFEF4444),
//       ));
//     }
//   }
//
//   void _handleComment() {
//     showCommentSheet(context, ref, post);
//     // sheet band hone ke baad comment count refresh karo
//     Future.delayed(const Duration(milliseconds: 300), _loadComments);
//   }
//
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours < 24) return '${diff.inHours}h ago';
//     if (diff.inDays < 7) return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final catColor = categoryColor(post.category);
//
//     return Scaffold(
//       backgroundColor: kBgDeep,
//       appBar: AppBar(
//         backgroundColor: kBgDeep,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: kTextPrimary),
//         title: const Text('Post',
//             style: TextStyle(color: kTextPrimary, fontSize: 15)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(bottom: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header ─────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//               child: Row(children: [
//                 PostAvatar(avatarUrl: post.userAvatarUrl, userName: post.userName),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(post.userName,
//                           style: const TextStyle(
//                               color: kGold, fontSize: 13, fontWeight: FontWeight.w600)),
//                       Text(_timeAgo(post.createdAt),
//                           style: const TextStyle(color: kTextMuted, fontSize: 11)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: catColor.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: catColor.withOpacity(0.5)),
//                   ),
//                   child: Text(post.category,
//                       style: TextStyle(
//                           color: catColor, fontSize: 10, fontWeight: FontWeight.w700)),
//                 ),
//               ]),
//             ),
//
//             // ── Full-size media (video ya image) ──────────────────
//             // ✅ NOTE: yahan onTapVideo NAHI diya — is screen ke andar
//             // tap se video normally play/pause hoga, navigate nahi.
//             PostImageArea(
//               post: post,
//               isTablet: false,
//               onImageReady: () {},
//             ),
//
//             // ── Title ──────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
//               child: Text(post.title,
//                   style: const TextStyle(
//                       color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w800, height: 1.4)),
//             ),
//
//             // ── Full content (untruncated, HTML) ────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//               child: Html(
//                 data: post.content,
//                 style: {
//                   "body": Style(
//                       color: kTextMuted, fontSize: FontSize(13.5), lineHeight: LineHeight(1.7),
//                       margin: Margins.zero, padding: HtmlPaddings.zero),
//                   "strong": Style(color: kTextPrimary, fontWeight: FontWeight.w700),
//                   "a": Style(color: kPurpleLight),
//                 },
//               ),
//             ),
//
//             const Divider(color: kBorder, height: 1),
//
//             // ── Like / Comment / Share row ──────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//               child: Row(children: [
//                 GestureDetector(
//                   onTap: _handleLike,
//                   child: Row(children: [
//                     ScaleTransition(
//                       scale: _likeScale,
//                       child: Icon(
//                         post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                         size: 26,
//                         color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Text('${post.likesCount}',
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted)),
//                   ]),
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: _handleComment,
//                   child: Row(children: [
//                     const Icon(Icons.chat_bubble_outline_rounded, size: 26, color: kTextMuted),
//                     const SizedBox(width: 5),
//                     if (!_commentsLoading)
//                       Text('${_comments.length}',
//                           style: const TextStyle(color: kTextMuted, fontSize: 12)),
//                   ]),
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: _isSharing
//                       ? null
//                       : () async {
//                     setState(() => _isSharing = true);
//                     // existing share logic PostCard se yahan bhi reuse kar sakte ho
//                     setState(() => _isSharing = false);
//                   },
//                   child: const Icon(Icons.share_outlined, size: 26, color: kTextMuted),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }