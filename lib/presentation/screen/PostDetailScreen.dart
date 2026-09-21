
// ═══════════════════════════════════════════════════════════════════════════════
//  POST DETAIL SCREEN
//  Profile feed ke kisi bhi tile ko tap karne par yeh screen open hoti hai.
//  Owner ko Edit + Delete milta hai. Sab kuch PostCard aur _OwnerActionsSheet
//  ke design system se match karta hai.
// ═══════════════════════════════════════════════════════════════════════════════


// ═══════════════════════════════════════════════════════════════════════════════
//  POST DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
//  POST DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart' show parse;

import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../domain/model/post/GetPost.dart';
import '../../domain/model/profile/UserFeedPost.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../viewmodal/post/GetPostViewModel.dart';
import '../widgets/HomeScreenWidgets/PostCard.dart' show categoryColor;
import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
import '../widgets/HomeScreenWidgets/showEditPostSheet.dart' show showEditPostSheet;
import 'HomeScreen.dart' show kBgDark;

// ── Constants ─────────────────────────────────────────────────────────────────
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);


// ─────────────────────────────────────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────
void openFeedDetail(BuildContext context, UserFeedPost post) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => FeedDetailScreen(post: post)),
  );
}

// ════════════════════════════════════════════════════════════════════════════════
//  FEED DETAIL SCREEN
// ════════════════════════════════════════════════════════════════════════════════
class FeedDetailScreen extends ConsumerStatefulWidget {
  final UserFeedPost post;
  const FeedDetailScreen({super.key, required this.post});

  @override
  ConsumerState<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends ConsumerState<FeedDetailScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _likeCtrl;
  late Animation<double>   _likeScale;
  bool _isSharing = false;

  // ── Local like state (optimistic UI) ──────────────────────────────────────
  late bool _isLiked;
  late int  _likesCount;

  // ── FIX 1: Like API ke liye alag provider ─────────────────────────────────
  // Problem: getPostViewModelProvider HomeScreen ki post list manage karta hai.
  //          Profile posts us list mein nahi hote, isliye toggleLike() silently
  //          fail ya wrong post pe apply hoti thi.
  // Fix:     Directly userFeedViewModelProvider mein ek toggleLike() method
  //          add karo — ya directly API call karo via repository.
  //          Sabse simple fix: getPostViewModelProvider use karna BAND karo
  //          aur userFeedViewModelProvider.toggleLike() call karo.

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));

    _isLiked    = widget.post.isLiked;
    _likesCount = widget.post.likesCount;
  }

  String _normalizeMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  // ── FIX 2: Instant update ke liye current post userFeedViewModel se lo ─────
  // Problem: widget.post ek fixed snapshot tha — edit/delete ke baad
  //          userFeedViewModelProvider update hota tha lekin screen nahi.
  // Fix:     build() mein feedState se current post dhundo by ID.
  //          Agar mil gaya to usse use karo, warna widget.post fallback.
  UserFeedPost _currentPost() {
    final feedState = ref.watch(userFeedViewModelProvider);
    try {
      return feedState.posts.firstWhere((p) => p.id == widget.post.id);
    } catch (_) {
      return widget.post; // fallback if deleted
    }
  }

  // ── FIX 1: Like handler — userFeedViewModelProvider.toggleLike() call karo ─
  Future<void> _handleLike() async {
    _likeCtrl.forward(from: 0);

    // Optimistic UI
    setState(() {
      _isLiked    = !_isLiked;
      _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
    });

    // ✅ FIX: userFeedViewModelProvider ka toggleLike use karo
    //         ye profile posts ki list mein post dhundta hai
    final error = await ref
        .read(userFeedViewModelProvider.notifier)
        .toggleLike(widget.post.id);

    if (error != null && mounted) {
      // Revert on error
      setState(() {
        _isLiked    = !_isLiked;
        _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: const Color(0xFFEF4444)),
      );
    }
  }

  void _handleComment() {
    showCommentSheet(context, ref, _toGetPost(_currentPost()));
  }

  void _handleShare() {
    final post = _currentPost();
    Share.share(
      '${post.title}\n\n${_stripHtml(post.content)}',
      subject: post.title,
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailOwnerActionsSheet(
        post:      _currentPost(),
        ref:       ref,
        onDeleted: () => Navigator.pop(context),
      ),
    );
  }

  // ── FIX 2: build() mein _currentPost() use karo — widget.post nahi ─────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light,
    ));

    // ✅ FIX 2: Har rebuild pe latest post data lo
    final post     = _currentPost();
    final catColor = categoryColor(post.category);

    final hasImage = post.filePath != null &&
        post.filePath!.isNotEmpty &&
        post.fileType == 'image';

    final hasVideo = post.filePath != null && // ✅ NEW
        post.filePath!.isNotEmpty &&
        post.fileType == 'video';

    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPurpleLight, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: catColor.withOpacity(0.5)),
            ),
            child: Text(post.category, style: TextStyle(
              color: catColor, fontSize: 11, fontWeight: FontWeight.w700,
            )),
          ),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: kPurpleLight, size: 22),
            onPressed: _showMoreMenu,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: kBorder),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Image ─────────────────────────────────────────────────────────
          if (hasImage)
            Image.network(
              post.filePath!,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 260, color: const Color(0xFF1A0535),
                  child: const Center(child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: 2,
                  )),
                );
              },
              errorBuilder: (_, __, ___) =>
                  _ImageFallback(catColor: catColor, category: post.category),
            )
          else if (hasVideo) // ✅ NEW — video inline play
            _DetailVideoArea(videoUrl: _normalizeMediaUrl(post.filePath!))
          else
            _ImageFallback(catColor: catColor, category: post.category),

          // ── Author row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(children: [
              Container(
                width: 38, height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [kGold, kPurple],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Center(child: Text(
                  _authorInitial(),
                  style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700,
                  ),
                )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Consumer(builder: (_, ref, __) {
                    final profile = ref.watch(profileInfoViewModelProvider).profile;
                    return Text(
                      profile?.name ?? 'You',
                      style: const TextStyle(
                        color: kGold, fontSize: 13, fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                  Text(_timeAgo(post.createdAt),
                      style: const TextStyle(color: kTextMuted, fontSize: 11)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: kPurple.withOpacity(0.5)),
                ),
                child: const Text('MY POST', style: TextStyle(
                  color: kPurpleLight, fontSize: 9,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5,
                )),
              ),
            ]),
          ),

          // ── Title ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(post.title, style: const TextStyle(
              color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.w800, height: 1.4,
            )),
          ),

          // ── Actions (Like, Comment, Share) ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(children: [

              // Like
              GestureDetector(
                onTap: _handleLike,
                child: Row(children: [
                  ScaleTransition(
                    scale: _likeScale,
                    child: Icon(
                      _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 22,
                      color: _isLiked ? const Color(0xFFEA4335) : kTextMuted,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('$_likesCount', style: TextStyle(
                    color: _isLiked ? const Color(0xFFEA4335) : kTextMuted,
                    fontSize: 13,
                  )),
                ]),
              ),

              const SizedBox(width: 20),

              // Comment
              GestureDetector(
                onTap: _handleComment,
                child: const Row(children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 20, color: kTextMuted),
                  SizedBox(width: 5),
                  Text('Comment', style: TextStyle(color: kTextMuted, fontSize: 13)),
                ]),
              ),

              const SizedBox(width: 20),

              // Share
              // GestureDetector(
              //   onTap: _handleShare,
              //   child: const Icon(Icons.share_outlined, size: 20, color: kTextMuted),
              // ),
              GestureDetector(
                // onTap: _isSharing ? null : () async {
                //   setState(() => _isSharing = true);
                //
                //   final hasImage = post.filePath != null &&
                //       post.filePath!.isNotEmpty &&
                //       post.fileType == 'image';
                //
                //   try {
                //     if (hasImage) {
                //       final response = await http.get(Uri.parse(post.filePath!));
                //       final tempDir  = await getTemporaryDirectory();
                //       final tempFile = File('${tempDir.path}/share_image.jpg');
                //       await tempFile.writeAsBytes(response.bodyBytes);
                //
                //       await Share.shareXFiles(
                //         [XFile(tempFile.path)],
                //         text:    '${post.title}\n\n${_stripHtml(post.content)}',
                //         subject: post.title,
                //       );
                //     } else {
                //       await Share.share(
                //         '${post.title}\n\n${_stripHtml(post.content)}',
                //         subject: post.title,
                //       );
                //     }
                //   } catch (_) {
                //     await Share.share(
                //       '${post.title}\n\n${_stripHtml(post.content)}',
                //       subject: post.title,
                //     );
                //   } finally {
                //     if (mounted) setState(() => _isSharing = false);
                //   }
                // },

                onTap: _isSharing ? null : () async {
                  setState(() => _isSharing = true);

                  final hasImage = post.filePath != null &&
                      post.filePath!.isNotEmpty &&
                      post.fileType == 'image';
                  final hasVideoShare = post.filePath != null && // ✅ NEW
                      post.filePath!.isNotEmpty &&
                      post.fileType == 'video';

                  try {
                    if (hasImage) {
                      final response = await http.get(Uri.parse(post.filePath!));
                      final tempDir  = await getTemporaryDirectory();
                      final tempFile = File('${tempDir.path}/share_image.jpg');
                      await tempFile.writeAsBytes(response.bodyBytes);

                      await Share.shareXFiles(
                        [XFile(tempFile.path)],
                        text:    '${post.title}\n\n${_stripHtml(post.content)}',
                        subject: post.title,
                      );
                    } else if (hasVideoShare) { // ✅ NEW — video share karo file ke saath
                      final fileInfo = await DefaultCacheManager()
                          .getSingleFile(_normalizeMediaUrl(post.filePath!));
                      await Share.shareXFiles(
                        [XFile(fileInfo.path)],
                        text:    '${post.title}\n\n${_stripHtml(post.content)}',
                        subject: post.title,
                      );
                    } else {
                      await Share.share(
                        '${post.title}\n\n${_stripHtml(post.content)}',
                        subject: post.title,
                      );
                    }
                  } catch (_) {
                    await Share.share(
                      '${post.title}\n\n${_stripHtml(post.content)}',
                      subject: post.title,
                    );
                  } finally {
                    if (mounted) setState(() => _isSharing = false);
                  }
                },

                child: _isSharing
                    ? const SizedBox(
                  width:  16,
                  height: 16,
                  child:  CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color:       kTextMuted,
                  ),
                )
                    : const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
              ),
            ]),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: kBorder, height: 1),
          ),

          // ── Full content ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Text(_stripHtml(post.content), style: const TextStyle(
              color: kTextMuted, fontSize: 14, height: 1.75,
            )),
          ),
        ]),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _authorInitial() {
    final profile = ref.read(profileInfoViewModelProvider).profile;
    return (profile != null && profile.name.isNotEmpty)
        ? profile.name[0].toUpperCase()
        : 'Y';
  }

  String _stripHtml(String html) => parse(html).body?.text ?? '';

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    if (diff.inDays    < 7)  return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  GetPost _toGetPost(UserFeedPost p) => GetPost(
    id:         p.id,
    title:      p.title,
    content:    p.content,
    category:   p.category,
    filePath:   p.filePath,
    fileType:   p.fileType,
    createdAt:  p.createdAt,
    likesCount: _likesCount,
    userId:     p.userId,
    isLiked:    _isLiked,
    isOwner:    true,
    userName:   ref.read(profileInfoViewModelProvider).profile?.name ?? 'You',
    userRole:   '',
  );
}

// ════════════════════════════════════════════════════════════════════════════════
//  DETAIL VIDEO AREA — full-width inline video playback with controls
// ════════════════════════════════════════════════════════════════════════════════
class _DetailVideoArea extends StatefulWidget {
  final String videoUrl;
  const _DetailVideoArea({required this.videoUrl});

  @override
  State<_DetailVideoArea> createState() => _DetailVideoAreaState();
}

class _DetailVideoAreaState extends State<_DetailVideoArea> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying   = false;
  bool _isMuted     = false; // ✅ Detail screen me by default sound ON
  bool _hasError    = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // ✅ Local cache se play — pehli baar download, uske baad instant
      final fileInfo = await DefaultCacheManager().getSingleFile(widget.videoUrl);
      final controller = VideoPlayerController.file(fileInfo);
      await controller.initialize();
      await controller.setLooping(true);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller  = controller;
        _initialized = true;
      });
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _togglePlay() {
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

  void _toggleMute() {
    if (_controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 260, width: double.infinity, color: const Color(0xFF1A0535),
        child: const Center(
          child: Icon(Icons.videocam_off_rounded, color: kTextMuted, size: 40),
        ),
      );
    }

    if (!_initialized || _controller == null) {
      return Container(
        height: 260, width: double.infinity, color: const Color(0xFF1A0535),
        child: const Center(
          child: CircularProgressIndicator(color: kPurple, strokeWidth: 2),
        ),
      );
    }

    final aspect = _controller!.value.aspectRatio;

    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(alignment: Alignment.center, children: [
        AspectRatio(
          aspectRatio: aspect,
          child: VideoPlayer(_controller!),
        ),
        if (!_isPlaying)
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
          ),
        Positioned(
          bottom: 12, right: 12,
          child: GestureDetector(
            onTap: _toggleMute,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55), shape: BoxShape.circle),
              child: Icon(
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white, size: 18,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
//  IMAGE FALLBACK
// ════════════════════════════════════════════════════════════════════════════════
class _ImageFallback extends StatelessWidget {
  final Color  catColor;
  final String category;
  const _ImageFallback({required this.catColor, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240, width: double.infinity, color: kBgDeep,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: catColor.withOpacity(0.4), width: 0.8),
          ),
          child: Text(category.toUpperCase(), style: TextStyle(
            color: catColor, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3,
          )),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
//  OWNER ACTIONS SHEET
// ════════════════════════════════════════════════════════════════════════════════
class _DetailOwnerActionsSheet extends StatelessWidget {
  final UserFeedPost post;
  final WidgetRef    ref;
  final VoidCallback onDeleted;
  const _DetailOwnerActionsSheet({
    required this.post, required this.ref, required this.onDeleted,
  });

  Future<void> _confirmDelete(BuildContext ctx) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: kBgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kBorder),
        ),
        title: const Text('Delete Post',
            style: TextStyle(
                color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to delete "${post.title}"? This cannot be undone.',
          style: const TextStyle(color: kTextMuted, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel', style: TextStyle(color: kTextMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Delete',
                style: TextStyle(
                    color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    // if (confirmed != true || !ctx.mounted) return;
    //
    // // ✅ Pop se pehle messenger save karo
    // final messenger = ScaffoldMessenger.of(ctx);
    // Navigator.pop(ctx); // sheet band karo
    //
    // final error = await ref
    //     .read(getPostViewModelProvider.notifier)
    //     .deletePost(post.id);
    //
    // if (error == null) {
    //   // ✅ Feed list update karo — warna profile screen pe purani list dikhegi
    //   ref.read(userFeedViewModelProvider.notifier).refresh();
    //
    //   // ✅ FeedDetailScreen band karo
    //   onDeleted();
    //
    //   messenger.showSnackBar(
    //     const SnackBar(
    //       content:         Text('Post deleted successfully.'),
    //       backgroundColor: Color(0xFF22C55E),
    //     ),
    //   );
    // } else {
    //   messenger.showSnackBar(
    //     SnackBar(
    //       content:         Text('Delete failed: $error'),
    //       backgroundColor: const Color(0xFFEF4444),
    //     ),
    //   );
    // }

    if (confirmed != true || !ctx.mounted) return;

    final messenger = ScaffoldMessenger.of(ctx);
    Navigator.pop(ctx);

    // ✅ CHANGED — ab userFeedViewModelProvider se hi delete karo
    final error = await ref
        .read(userFeedViewModelProvider.notifier)
        .deletePost(post.id);

    if (error == null) {
      onDeleted();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully.'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Delete failed: $error'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  // Future<void> _confirmDelete(BuildContext ctx) async {
  //   final confirmed = await showDialog<bool>(
  //     context: ctx,
  //     builder: (dialogCtx) => AlertDialog(
  //       backgroundColor: kBgCard,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: const BorderSide(color: kBorder),
  //       ),
  //       title: const Text('Delete Post', style: TextStyle(
  //         color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700,
  //       )),
  //       content: Text(
  //         'Are you sure you want to delete "${post.title}"?\nThis cannot be undone.',
  //         style: const TextStyle(color: kTextMuted, fontSize: 13, height: 1.5),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogCtx, false),
  //           child: const Text('Cancel', style: TextStyle(color: kTextMuted)),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogCtx, true),
  //           child: const Text('Delete', style: TextStyle(
  //             color: Color(0xFFEF4444), fontWeight: FontWeight.w700,
  //           )),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (confirmed != true || !ctx.mounted) return;
  //   Navigator.pop(ctx); // sheet band karo
  //
  //   // ✅ getPostViewModelProvider.deletePost() — existing API
  //   final error = await ref
  //       .read(getPostViewModelProvider.notifier)
  //       .deletePost(post.id);
  //
  //   if (!ctx.mounted) return;
  //
  //   if (error == null) {
  //     // ✅ FIX 2: userFeedViewModelProvider refresh karo — instant update
  //     ref.read(userFeedViewModelProvider.notifier).refresh();
  //     onDeleted(); // detail screen band karo
  //
  //     ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
  //       content: Text('Post deleted successfully.'),
  //       backgroundColor: Color(0xFF22C55E),
  //     ));
  //   } else {
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text('Delete failed: $error'),
  //       backgroundColor: const Color(0xFFEF4444),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 36, height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: kTextMuted, borderRadius: BorderRadius.circular(2)),
        ),
        _ActionTile(
          icon: Icons.edit_outlined, label: 'Edit Post', color: kPurpleLight,
          onTap: () {
            Navigator.pop(context);
          //  showEditPostSheet(context, ref, _toGetPost(post, ref));
            showEditPostSheet(
              context, ref, _toGetPost(post, ref),
              isFromProfile: true, // ✅ NEW
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(color: kBorder, height: 1),
        const SizedBox(height: 8),
        _ActionTile(
          icon: Icons.delete_outline_rounded, label: 'Delete Post',
          color: const Color(0xFFEF4444),
          onTap: () => _confirmDelete(context),
        ),
      ]),
    );
  }

  static GetPost _toGetPost(UserFeedPost p, WidgetRef ref) => GetPost(
    id: p.id, title: p.title, content: p.content, category: p.category,
    filePath: p.filePath, fileType: p.fileType, createdAt: p.createdAt,
    likesCount: p.likesCount, userId: p.userId, isLiked: p.isLiked,
    isOwner: true,
    userName: ref.read(profileInfoViewModelProvider).profile?.name ?? 'You',
    userRole: '',
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon, required this.label,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kBgDeep, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        const Spacer(),
        Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.5), size: 18),
      ]),
    ),
  );
}





// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:html/parser.dart' show parse;
//
// import '../../domain/model/post/GetPost.dart';
// import '../../domain/model/profile/UserFeedPost.dart';
// import '../viewmodal/pofile/ProfileViewmodels.dart';
// import '../viewmodal/post/GetPostViewModel.dart';
// import '../widgets/HomeScreenWidgets/PostCard.dart' show categoryColor;
// import '../widgets/HomeScreenWidgets/showCommentSheet.dart';
// import '../widgets/HomeScreenWidgets/showEditPostSheet.dart' show showEditPostSheet;
// import 'HomeScreen.dart' show kBgDark;
//
// // ── Apne existing imports adjust karo ────────────────────────────────
// // import '../../constants.dart';
// // import '../../domain/models/profile_domain.dart';        // UserFeedPost
// // import '../../application/viewmodel/profile_viewmodels.dart';
// // import '../../application/viewmodel/get_post_viewmodel.dart'; // toggleLike, deletePost
// // import '../home/comment_sheet.dart';    // showCommentSheet
// // import '../home/edit_post_sheet.dart';  // showEditPostSheet
//
// // ─────────────────────────────────────────────────────────────────────
// //  ENTRY POINT — FeedTile ke onTap mein call karo
// // ─────────────────────────────────────────────────────────────────────
// void openFeedDetail(BuildContext context, UserFeedPost post) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => FeedDetailScreen(post: post),
//     ),
//   );
// }
//
// // ════════════════════════════════════════════════════════════════════
// //  MAIN SCREEN
// // ════════════════════════════════════════════════════════════════════
// class FeedDetailScreen extends ConsumerStatefulWidget {
//   final UserFeedPost post;
//
//   const FeedDetailScreen({super.key, required this.post});
//
//   @override
//   ConsumerState<FeedDetailScreen> createState() => _FeedDetailScreenState();
// }
//
// class _FeedDetailScreenState extends ConsumerState<FeedDetailScreen>
//     with SingleTickerProviderStateMixin {
//
//   // ── Like animation — PostCard jaisi ──────────────────────────────
//   late AnimationController _likeCtrl;
//   late Animation<double>   _likeScale;
//
//   // ── Local like state — optimistic UI ─────────────────────────────
//   // CHANGE #1: UserFeedPost se initial values lete hain,
//   //            phir locally update karte hain — API call ke baad sync hoga
//   late bool _isLiked;
//   late int  _likesCount;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Like animation setup (PostCard ki tarah)
//     _likeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//
//     // CHANGE #1: UserFeedPost se initial values
//     _isLiked    = widget.post.isLiked;
//     _likesCount = widget.post.likesCount;
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   // ════════════════════════════════════════════════════════════════
//   //  HANDLERS
//   // ════════════════════════════════════════════════════════════════
//
//   // CHANGE #2: Like handler — PostCard._handleLike() ki exact copy
//   //            + local optimistic update
//   Future<void> _handleLike() async {
//     // Animation play karo
//     _likeCtrl.forward(from: 0);
//
//     // Optimistic UI update
//     setState(() {
//       _isLiked    = !_isLiked;
//       _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
//     });
//
//     // ✅ Existing getPostViewModelProvider.toggleLike() call karo
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .toggleLike(widget.post.id);
//
//     if (error != null && mounted) {
//       // Revert optimistic update on error
//       setState(() {
//         _isLiked    = !_isLiked;
//         _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:         Text(error),
//           backgroundColor: const Color(0xFFEF4444),
//         ),
//       );
//     }
//   }
//
//   // CHANGE #3: Comment — existing showCommentSheet() ko call karo
//   //            UserFeedPost ko GetPost mein convert karna padega
//   //            (ya ek adapter banao — neeche dekho)
//   void _handleComment() {
//     // ✅ existing showCommentSheet(context, ref, post) call karo
//     // Note: showCommentSheet GetPost expect karta hai, UserFeedPost nahi
//     // Isliye _toGetPost() adapter use karo (neeche diya hua hai)
//     showCommentSheet(context, ref, _toGetPost(widget.post));
//   }
//
//   // CHANGE #4: Share
//   void _handleShare() {
//     Share.share(
//       '${widget.post.title}\n\n${_stripHtml(widget.post.content)}',
//       subject: widget.post.title,
//     );
//   }
//
//   // CHANGE #5: More menu — sirf owner ko (isOwner check)
//   //            UserFeedPost.userId == current user id hone ka matlab owner
//   void _showMoreMenu() {
//     showModalBottomSheet(
//       context:         context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _DetailOwnerActionsSheet(
//         post: widget.post,
//         ref:  ref,
//         onDeleted: () => Navigator.pop(context), // detail screen bhi band karo
//       ),
//     );
//   }
//
//   // ════════════════════════════════════════════════════════════════
//   //  BUILD
//   // ════════════════════════════════════════════════════════════════
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor:           Colors.transparent,
//       statusBarIconBrightness:  Brightness.light,
//     ));
//
//     final post     = widget.post;
//     final catColor = categoryColor(post.category);
//     final hasImage = post.filePath != null &&
//         post.filePath!.isNotEmpty &&
//         post.fileType == 'image';
//
//     // CHANGE #6: isOwner — UserFeedPost mein userId hai
//     //            Profile screen pe hum apne hi posts dekh rahe hain
//     //            isliye by default owner = true
//     //            Agar general use karna ho to profileState.profile?.id == post.userId check karo
//     const isOwner = true; // Profile grid = apne posts = always owner
//
//     return Scaffold(
//       backgroundColor: kBgDark,
//
//       // ── AppBar ─────────────────────────────────────────────────
//       // CHANGE #7: Custom AppBar with back + category + more menu
//       appBar: AppBar(
//         backgroundColor:   kBgCard,
//         elevation:         0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: kPurpleLight,
//             size:  20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             // Category badge in title
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color:        catColor.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(20),
//                 border:       Border.all(color: catColor.withOpacity(0.5)),
//               ),
//               child: Text(
//                 post.category,
//                 style: TextStyle(
//                   color:      catColor,
//                   fontSize:   11,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         // CHANGE #7: More menu — owner hone ki wajah se dikhao
//         actions: [
//           if (isOwner)
//             IconButton(
//               icon: const Icon(
//                 Icons.more_vert_rounded,
//                 color: kPurpleLight,
//                 size:  22,
//               ),
//               onPressed: _showMoreMenu,
//             ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(0.5),
//           child: Container(height: 0.5, color: kBorder),
//         ),
//       ),
//
//       // ── Body ───────────────────────────────────────────────────
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             // ── CHANGE #8: Post Image (full width) ───────────────
//             if (hasImage)
//               Image.network(
//                 post.filePath!,
//                 width:  double.infinity,
//                 fit:    BoxFit.cover,
//                 loadingBuilder: (_, child, get_progress) {
//                   if (get_progress == null) return child;
//                   return Container(
//                     height: 260,
//                     color:  const Color(0xFF1A0535),
//                     child:  const Center(
//                       child: CircularProgressIndicator(
//                           color: kPurple, strokeWidth: 2),
//                     ),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => _ImageFallback(
//                   catColor: catColor,
//                   category: post.category,
//                 ),
//               )
//             else
//               _ImageFallback(catColor: catColor, category: post.category),
//
//             // ── CHANGE #9: Author row ─────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//               child: Row(
//                 children: [
//                   // Avatar
//                   Container(
//                     width:  38,
//                     height: 38,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [kGold, kPurple],
//                         begin:  Alignment.topLeft,
//                         end:    Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         // post.userName nahi hai UserFeedPost mein —
//                         // CHANGE #10: profile se naam lenge
//                         // (neeche _authorInitial dekho)
//                         _authorInitial(),
//                         style: const TextStyle(
//                           color:      Colors.white,
//                           fontSize:   14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // CHANGE #10: ProfileInfoViewModel se naam lenge
//                         Consumer(
//                           builder: (_, ref, __) {
//                             final profile = ref
//                                 .watch(profileInfoViewModelProvider)
//                                 .profile;
//                             return Text(
//                               profile?.name ?? 'You',
//                               style: const TextStyle(
//                                 color:      kGold,
//                                 fontSize:   13,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             );
//                           },
//                         ),
//                         Text(
//                           _timeAgo(post.createdAt),
//                           style: const TextStyle(
//                               color: kTextMuted, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // MY POST badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color:        kPurple.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(6),
//                       border:       Border.all(
//                           color: kPurple.withOpacity(0.5)),
//                     ),
//                     child: const Text(
//                       'MY POST',
//                       style: TextStyle(
//                         color:       kPurpleLight,
//                         fontSize:    9,
//                         fontWeight:  FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── CHANGE #11: Title ─────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
//               child: Text(
//                 post.title,
//                 style: const TextStyle(
//                   color:      kTextPrimary,
//                   fontSize:   18,
//                   fontWeight: FontWeight.w800,
//                   height:     1.4,
//                 ),
//               ),
//             ),
//
//             // ── CHANGE #12: Action row (Like, Comment, Share) ─────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
//               child: Row(
//                 children: [
//
//                   // ── Like button (animation + API) ──────────────
//                   GestureDetector(
//                     onTap: _handleLike,
//                     child: Row(
//                       children: [
//                         ScaleTransition(
//                           scale: _likeScale,
//                           child: Icon(
//                             _isLiked
//                                 ? Icons.favorite_rounded
//                                 : Icons.favorite_border_rounded,
//                             size:  22,
//                             color: _isLiked
//                                 ? const Color(0xFFEA4335)
//                                 : kTextMuted,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           '$_likesCount',
//                           style: TextStyle(
//                             color:    _isLiked
//                                 ? const Color(0xFFEA4335)
//                                 : kTextMuted,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 20),
//
//                   // ── Comment button ─────────────────────────────
//                   GestureDetector(
//                     onTap: _handleComment,
//                     child: const Row(
//                       children: [
//                         Icon(
//                           Icons.chat_bubble_outline_rounded,
//                           size:  20,
//                           color: kTextMuted,
//                         ),
//                         SizedBox(width: 5),
//                         Text(
//                           'Comment',
//                           style: TextStyle(
//                               color: kTextMuted, fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 20),
//
//                   // ── Share button ───────────────────────────────
//                   GestureDetector(
//                     onTap: _handleShare,
//                     child: const Icon(
//                       Icons.share_outlined,
//                       size:  20,
//                       color: kTextMuted,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── Divider ───────────────────────────────────────────
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 14),
//               child:   Divider(color: kBorder, height: 1),
//             ),
//
//             // ── CHANGE #13: Full content (HTML stripped) ──────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//               child: Text(
//                 _stripHtml(post.content),
//                 style: const TextStyle(
//                   color:    kTextMuted,
//                   fontSize: 14,
//                   height:   1.75,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ════════════════════════════════════════════════════════════════
//   //  HELPERS
//   // ════════════════════════════════════════════════════════════════
//
//   // CHANGE #10: UserFeedPost mein userName nahi hai — profile se lete hain
//   String _authorInitial() {
//     final profile =
//         ref.read(profileInfoViewModelProvider).profile;
//     if (profile != null && profile.name.isNotEmpty) {
//       return profile.name[0].toUpperCase();
//     }
//     return 'Y'; // You
//   }
//
//   String _stripHtml(String html) => parse(html).body?.text ?? '';
//
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
//     if (diff.inHours   < 24)  return '${diff.inHours}h ago';
//     if (diff.inDays    < 7)   return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   // CHANGE #3: UserFeedPost → GetPost adapter
//   // showCommentSheet aur showEditPostSheet GetPost expect karte hain
//   // Yeh adapter UserFeedPost ko GetPost ki tarah wrap karta hai
//   GetPost _toGetPost(UserFeedPost p) => GetPost(
//     id:         p.id,
//     title:      p.title,
//     content:    p.content,
//     category:   p.category,
//     filePath:   p.filePath,
//     fileType:   p.fileType,
//     createdAt:  p.createdAt,
//     likesCount: _likesCount,  // local updated value use karo
//     userId:     p.userId,
//     isLiked:    _isLiked,     // local updated value
//     isOwner:    true,         // profile grid = apne posts
//     // userName: profile se lena hoga — ya GetPost mein optional karo
//     userName: ref.read(profileInfoViewModelProvider).profile?.name ?? 'You',
//     userRole: "",
//   );
// }
//
// // ════════════════════════════════════════════════════════════════════
// //  IMAGE FALLBACK WIDGET
// // ════════════════════════════════════════════════════════════════════
// class _ImageFallback extends StatelessWidget {
//   final Color  catColor;
//   final String category;
//
//   const _ImageFallback({required this.catColor, required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 240,
//       width:  double.infinity,
//       color:  kBgDeep,
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           decoration: BoxDecoration(
//             color:        Colors.black.withOpacity(0.4),
//             borderRadius: BorderRadius.circular(10),
//             border:       Border.all(
//                 color: catColor.withOpacity(0.4), width: 0.8),
//           ),
//           child: Text(
//             category.toUpperCase(),
//             style: TextStyle(
//               color:       catColor,
//               fontSize:    20,
//               fontWeight:  FontWeight.w900,
//               letterSpacing: 3,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ════════════════════════════════════════════════════════════════════
// //  OWNER ACTIONS SHEET (Profile version)
// //  PostCard._OwnerActionsSheet ki tarah — sirf onDeleted callback extra
// // ════════════════════════════════════════════════════════════════════
// class _DetailOwnerActionsSheet extends StatelessWidget {
//   final UserFeedPost post;
//   final WidgetRef    ref;
//   final VoidCallback onDeleted; // screen band karne ke liye
//
//   const _DetailOwnerActionsSheet({
//     required this.post,
//     required this.ref,
//     required this.onDeleted,
//   });
//
//   // CHANGE #14: Delete → existing getPostViewModelProvider.deletePost()
//   Future<void> _confirmDelete(BuildContext ctx) async {
//     final confirmed = await showDialog<bool>(
//       context: ctx,
//       builder: (dialogCtx) => AlertDialog(
//         backgroundColor: kBgCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side:         const BorderSide(color: kBorder),
//         ),
//         title: const Text(
//           'Delete Post',
//           style: TextStyle(
//               color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           'Are you sure you want to delete "${post.title}"?\nThis cannot be undone.',
//           style: const TextStyle(
//               color: kTextMuted, fontSize: 13, height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogCtx, false),
//             child:     const Text('Cancel',
//                 style: TextStyle(color: kTextMuted)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(dialogCtx, true),
//             child:     const Text('Delete',
//                 style: TextStyle(
//                     color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//
//     if (confirmed != true || !ctx.mounted) return;
//
//     // Sheet band karo
//     Navigator.pop(ctx);
//
//     // ✅ Existing deletePost() call
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .deletePost(post.id);
//
//     if (!ctx.mounted) return;
//
//     if (error == null) {
//       // Feed refresh karo aur detail screen bhi band karo
//       ref.read(userFeedViewModelProvider.notifier).refresh();
//       onDeleted(); // Navigator.pop(context) — detail screen band
//
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content:         Text('Post deleted successfully.'),
//           backgroundColor: Color(0xFF22C55E),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         SnackBar(
//           content:         Text('Delete failed: $error'),
//           backgroundColor: const Color(0xFFEF4444),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//       decoration: const BoxDecoration(
//         color:        kBgCard,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 36, height: 4,
//             margin: const EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//                 color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//           ),
//
//           // ── EDIT ──────────────────────────────────────────────
//           // CHANGE #15: showEditPostSheet() call karo
//           //             UserFeedPost → GetPost adapter use karo
//           _ActionTile(
//             icon:  Icons.edit_outlined,
//             label: 'Edit Post',
//             color: kPurpleLight,
//             onTap: () {
//               Navigator.pop(context); // sheet band karo
//
//               // ✅ Existing showEditPostSheet() call
//               showEditPostSheet(
//                 context,
//                 ref,
//                 _userFeedToGetPost(post, ref), // adapter
//               );
//             },
//           ),
//
//           const SizedBox(height: 8),
//           const Divider(color: kBorder, height: 1),
//           const SizedBox(height: 8),
//
//           // ── DELETE ─────────────────────────────────────────────
//           _ActionTile(
//             icon:  Icons.delete_outline_rounded,
//             label: 'Delete Post',
//             color: const Color(0xFFEF4444),
//             onTap: () => _confirmDelete(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // CHANGE #3 (same adapter as above — static version)
//   static GetPost _userFeedToGetPost(UserFeedPost p, WidgetRef ref) =>
//       GetPost(
//         id:         p.id,
//         title:      p.title,
//         content:    p.content,
//         category:   p.category,
//         filePath:   p.filePath,
//         fileType:   p.fileType,
//         createdAt:  p.createdAt,
//         likesCount: p.likesCount,
//         userId:     p.userId,
//         isLiked:    p.isLiked,
//         isOwner:    true,
//         userName:
//         ref.read(profileInfoViewModelProvider).profile?.name ?? 'You',
//         userRole: '',
//       );
// }
//
// // ── _ActionTile (PostCard._ActionTile ki copy) ────────────────────────
// class _ActionTile extends StatelessWidget {
//   final IconData icon;
//   final String   label;
//   final Color    color;
//   final VoidCallback onTap;
//
//   const _ActionTile({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color:        kBgDeep,
//         borderRadius: BorderRadius.circular(12),
//         border:       Border.all(color: kBorder, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.w600),
//           ),
//           const Spacer(),
//           Icon(
//             Icons.chevron_right_rounded,
//             color: color.withOpacity(0.5),
//             size:  18,
//           ),
//         ],
//       ),
//     ),
//   );
// }
