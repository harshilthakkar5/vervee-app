
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../domain/model/profile/UserFeedPost.dart';
//import '../../screen/HomeScreen.dart';
import '../../screen/PostDetailScreen.dart';
import '../../viewmodal/pofile/ProfileState.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import '../constants.dart';
// import '../application/state/profile_state.dart';
// import '../domain/models/profile_domain.dart';

class UserFeedGrid extends StatelessWidget {
  final UserFeedState  feedState;
  final VoidCallback   onAdd;
  final VoidCallback   onRetry;

  const UserFeedGrid({
    super.key,
    required this.feedState,
    required this.onAdd,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Loading
    if (feedState.isLoading) {
      return const _FeedGridShimmer();
    }

    // Error
    if (feedState.errorMessage != null) {
      return FeedGridError(
        message: feedState.errorMessage!,
        onRetry: onRetry,
      );
    }

    // Empty
    if (feedState.posts.isEmpty) {
      return EmptyFeedView(onAdd: onAdd);
    }

    // Grid
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.5,
        mainAxisSpacing: 2.5,
        childAspectRatio: 1,
      ),
      itemCount: feedState.posts.length,
      itemBuilder: (_, i) => FeedTile(post: feedState.posts[i]),
    );
  }
}

// ── Single tile ───────────────────────────────────────────────────────

class FeedTile extends StatelessWidget {
  final UserFeedPost post;

  const FeedTile({super.key, required this.post});

  // ✅ Backend kabhi scheme-less video URL bhejta he — fix karo (Home Screen jaisa hi)
  String _normalizeMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }

  @override
  Widget build(BuildContext context) {
    final col = _categoryColor(post.category);

    final hasImage = post.filePath != null &&
        post.filePath!.isNotEmpty &&
        post.fileType == 'image';

    final hasVideo = post.filePath != null && // ✅ NEW
        post.filePath!.isNotEmpty &&
        post.fileType == 'video';

    return GestureDetector(              // ← yeh line ADD karo
    onTap: () => openFeedDetail(context, post),
    child:Container(
      color: kBgCard,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Real image or gradient fallback ─────────────────
          // if (hasImage)
          //   Image.network(
          //     post.filePath!,
          //     fit: BoxFit.cover,
          //     errorBuilder: (_, __, ___) => _gradientFallback(col),
          //     loadingBuilder: (_, child, progress) {
          //       if (progress == null) return child;
          //       return _gradientFallback(col);
          //     },
          //   )
          // else
          //   _gradientFallback(col),

          if (hasImage)
            CachedNetworkImage(
              imageUrl: post.filePath!,
              fit: BoxFit.cover,
              // ✅ Disk pe cache hoga — offline pe bhi pehle se-loaded image dikhegi
              placeholder: (_, __) => _gradientFallback(col),
              errorWidget: (_, __, ___) => _gradientFallback(col),
            )
          else if (hasVideo) // ✅ NEW — video thumbnail + play badge
            _VideoTileThumbnail(
              videoUrl: _normalizeMediaUrl(post.filePath!),
              fallback: _gradientFallback(col),
            )
          else
            _gradientFallback(col),

          // ── Overlay: category badge ──────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                post.category,
                style: TextStyle(
                  color: col,
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ── Border overlay ───────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: kBgDeep, width: 0.5),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // Widget _gradientFallback(Color col) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: RadialGradient(
  //         colors: [col.withOpacity(0.2), kBgDeep],
  //         center: Alignment.center,
  //         radius: 1.0,
  //       ),
  //     ),
  //     child: Center(
  //       child: Text(
  //         _categoryEmoji(post.category),
  //         style: const TextStyle(fontSize: 22),
  //       ),
  //     ),
  //   );
  // }

  Widget _gradientFallback(Color col) {
    // Slightly lighter version of col for the glow
    final glowCol = col.withOpacity(0.55);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Base dark gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                col.withOpacity(0.12),
                Colors.black.withOpacity(0.95),
              ],
            ),
          ),
        ),

        // Top-left radial glow
        Positioned(
          top: -30, left: -30,
          child: Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [glowCol, Colors.transparent],
              ),
            ),
          ),
        ),

        // Bottom-right soft glow
        Positioned(
          bottom: -35, right: -35,
          child: Container(
            width: 75, height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [col.withOpacity(0.22), Colors.transparent],
              ),
            ),
          ),
        ),

        // Glass overlay
        Container(color: Colors.white.withOpacity(0.03)),

        // Thin border
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 0.5,
            ),
          ),
        ),

        // Center text
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.category.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: col,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 1.5,
                  width: 24,
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _categorySubtitle(post.category),
                  style: TextStyle(
                    color: col.withOpacity(0.55),
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom accent line
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 1.5,
            color: col.withOpacity(0.45),
          ),
        ),
      ],
    );
  }

// Add this helper too
  String _categorySubtitle(String category) {
    switch (category.toLowerCase()) {
      case 'stocks': case 'stock market': return 'EQUITIES';
      case 'forex':  case 'forex & currency': return 'CURRENCY';
      case 'crypto': return 'DIGITAL ASSETS';
      case 'gold':   case 'gold & commodities': return 'COMMODITIES';
      case 'oil':    case 'oil market': return 'ENERGY';
      case 'economy': case 'macro': return 'MACRO';
      default: return 'MARKETS';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  _VideoTileThumbnail — grid tile ke liye video ka first frame + play badge
// ═══════════════════════════════════════════════════════════════════════════
class _VideoTileThumbnail extends StatefulWidget {
  final String videoUrl;
  final Widget fallback;

  const _VideoTileThumbnail({required this.videoUrl, required this.fallback});

  @override
  State<_VideoTileThumbnail> createState() => _VideoTileThumbnailState();
}

class _VideoTileThumbnailState extends State<_VideoTileThumbnail> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // ✅ Same cache-manager pattern jaisa PostCard me hai — local file se load
      final fileInfo = await DefaultCacheManager().getSingleFile(widget.videoUrl);
      final controller = VideoPlayerController.file(fileInfo);
      await controller.initialize(); // first frame yehi se milta hai, paused state me

      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _ready = true;
      });
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return widget.fallback;
    if (!_ready || _controller == null) return widget.fallback;

    return Stack(fit: StackFit.expand, children: [
      FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!), // paused — sirf first frame dikhta hai
        ),
      ),
      // ✅ Play icon badge — batata he ki ye video he
      Center(
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
        ),
      ),
    ]);
  }
}

// ── Empty state ───────────────────────────────────────────────────────

class EmptyFeedView extends StatelessWidget {
  final VoidCallback onAdd;
  const EmptyFeedView({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          const Text('No Feed Yet',
              style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Add your first market feed post',
              style: TextStyle(color: kTextMuted, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text('Add Feed',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurple,
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading shimmer ───────────────────────────────────────────────────
class _FeedGridShimmer extends StatelessWidget {
  const _FeedGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
        childAspectRatio: 1,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(color: kBorder),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────

class FeedGridError extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const FeedGridError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: kTextMuted, size: 40),
          const SizedBox(height: 8),
          Text(message,
              style: const TextStyle(color: kTextMuted, fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(color: kPurpleLight)),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'stocks': case 'stock market': return const Color(0xFF06B6D4);
    case 'forex':  case 'forex & currency': return const Color(0xFF3B82F6);
    case 'crypto': return const Color(0xFFF59E0B);
    case 'gold':   case 'gold & commodities': return const Color(0xFFD4AF37);
    case 'oil':    case 'oil market': return const Color(0xFF22C55E);
    case 'economy': case 'macro': return const Color(0xFFEF4444);
    default: return const Color(0xFF9333EA);
  }
}

String _categoryEmoji(String category) {
  switch (category.toLowerCase()) {
    case 'stocks': case 'stock market': return '📈';
    case 'forex':  case 'forex & currency': return '💱';
    case 'crypto': return '₿';
    case 'gold':   case 'gold & commodities': return '🥇';
    case 'oil':    case 'oil market': return '🛢️';
    case 'economy': return '🏦';
    default: return '📊';
  }
}


// class FeedTile extends ConsumerStatefulWidget {
//   final UserFeedPost post;
//   const FeedTile({super.key, required this.post});
//
//   @override
//   ConsumerState<FeedTile> createState() => _FeedTileState();
// }
//
// class _FeedTileState extends ConsumerState<FeedTile> {
//
//   // ── Same _showFullContent jo PostCard mein hai ────────────────
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
//
//             // Drag handle
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: kTextMuted,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//
//             // Category + Title + Time header
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: _categoryColor(widget.post.category).withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: _categoryColor(widget.post.category).withOpacity(0.5),
//                         ),
//                       ),
//                       child: Text(
//                         widget.post.category,
//                         style: TextStyle(
//                           color: _categoryColor(widget.post.category),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     widget.post.title,
//                     style: const TextStyle(
//                       color: kTextPrimary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     _timeAgo(widget.post.createdAt),
//                     style: const TextStyle(color: kTextMuted, fontSize: 11),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Divider(color: kBorder, height: 1),
//
//             // Image (agar hai to)
//             if (widget.post.filePath != null &&
//                 widget.post.filePath!.isNotEmpty &&
//                 widget.post.fileType == 'image')
//               Image.network(
//                 widget.post.filePath!,
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//               ),
//
//             // Scrollable full content
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: scrollCtrl,
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//                 child: Text(
//                   parseHtmlString(widget.post.content),
//                   style: const TextStyle(
//                     color: kTextMuted,
//                     fontSize: 14,
//                     height: 1.7,
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours   < 24) return '${diff.inHours}h ago';
//     if (diff.inDays    < 7)  return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final col = _categoryColor(widget.post.category);
//     final hasImage = widget.post.filePath != null &&
//         widget.post.filePath!.isNotEmpty &&
//         widget.post.fileType == 'image';
//
//     return GestureDetector(
//       onTap: () => _showFullContent(context), // ✅ tap pe sheet open
//       child: Container(
//         color: kBgCard,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Image ya gradient fallback
//             if (hasImage)
//               Image.network(
//                 widget.post.filePath!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => _gradientFallback(col),
//                 loadingBuilder: (_, child, get_progress) {
//                   if (get_progress == null) return child;
//                   return _gradientFallback(col);
//                 },
//               )
//             else
//               _gradientFallback(col),
//
//             // Category badge at bottom
//             Positioned(
//               bottom: 0, left: 0, right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
//                 color: Colors.black.withOpacity(0.5),
//                 child: Text(
//                   widget.post.category,
//                   style: TextStyle(
//                     color: col, fontSize: 7, fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//
//             // Border overlay
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: kBgDeep, width: 0.5),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _gradientFallback(Color col) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [col.withOpacity(0.2), kBgDeep],
//           center: Alignment.center,
//           radius: 1.0,
//         ),
//       ),
//       child: Center(
//         child: Text(
//           _categoryEmoji(widget.post.category),
//           style: const TextStyle(fontSize: 22),
//         ),
//       ),
//     );
//   }
// }