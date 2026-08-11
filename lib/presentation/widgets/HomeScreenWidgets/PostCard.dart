
// ─── LAYER 6C: UI — Updated _PostCard ─────────────────────────────────────────
// File: lib/features/post/presentation/screens/home_screen.dart
//         (sirf _PostCard class replace karo — baaki HomeScreen same rahega)
//
// Changes from old _PostCard:
//   ✅ onLikeTap → ab error snackbar bhi handle karta hai (async toggleLike)
//   ✅ comment icon → CommentBottomSheet open karta hai
//   ✅ more_horiz icon → PopupMenu with Edit / Delete options
//   ✅ Delete confirmation dialog before API call
//   ✅ Edit → EditPostSheet open karta hai
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart' show parse;
import 'package:vervee_app/presentation/widgets/HomeScreenWidgets/showCommentSheet.dart';
import 'package:vervee_app/presentation/widgets/HomeScreenWidgets/showEditPostSheet.dart';
import 'package:video_player/video_player.dart';
import '../../../domain/model/post/GetPost.dart';
import '../../../domain/model/post/PostComment.dart';
import '../../../utils/ShimmerBox.dart';
import '../../screen/HomeScreen.dart';
import '../../viewmodal/avatar/AvatarViewModel.dart';
import '../../viewmodal/post/GetPostViewModel.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//import '../../domain/entities/get_post.dart';
//import '../../viewmodal/post/GetPostViewModel.dart';
//import '../viewmodel/get_post_view_model.dart';
//import '../widgets/comment_bottom_sheet.dart';
//import '../widgets/edit_post_sheet.dart';

// ── Constants (apni file se import karo) ─────────────────────────────────────
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kGoldLight   = Color(0xFFFFD700);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);

// ═══════════════════════════════════════════════════════════════════════════════
//  UPDATED _PostCard
//  (replace the existing _PostCard class in home_screen.dart with this)
// ═══════════════════════════════════════════════════════════════════════════════
class PostCard extends ConsumerStatefulWidget {
  final GetPost post;
  final bool    isTablet;
  const PostCard({required this.post, required this.isTablet, super.key});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard>
    with TickerProviderStateMixin {
  late AnimationController _likeCtrl;
  late Animation<double>   _likeScale;
  bool _isSharing  = false;

  // ✅ NEW — Double-tap heart pop animation ke liye (Instagram jaisa)
  late AnimationController _heartPopCtrl;
  late Animation<double>   _heartPopScale;
  late Animation<double>   _heartPopOpacity;

  List<PostComment> _existingComments = [];
  int  _commentDelta    = 0;     // sheet me naya comment add hone par badhega
  bool _commentsLoading = true;

  // ✅ KEY: Image load status track karo
  // Agar post me image hi nahi hai → seedha ready
  bool _imageReady = false;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));


    // ✅ NEW — Heart pop controller: pop-up + fade-out timeline
    _heartPopCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _heartPopScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.3)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 35),
      TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
    ]).animate(_heartPopCtrl);

    _heartPopOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 30),
    ]).animate(_heartPopCtrl);


    // ✅ Agar post me image nahi hai → abhi se ready
    // final hasImage = widget.post.filePath != null &&
    //     widget.post.filePath!.isNotEmpty &&
    //     widget.post.fileType == 'image';
    // _imageReady = !hasImage;

    // ✅ Agar post me image/video nahi hai → abhi se ready
    final hasMedia = widget.post.filePath != null &&
        widget.post.filePath!.isNotEmpty &&
        (widget.post.fileType == 'image' || widget.post.fileType == 'video'); // ✅ video bhi
    _imageReady = !hasMedia;

    _loadCommentCount(); // 👈 NAYA
  }

  // ── Comment count fetch karo (showCommentSheet jaisa hi tarika) ─────────────
  Future<void> _loadCommentCount() async {
    final comments = await ref
        .read(getPostViewModelProvider.notifier)
        .fetchComments(widget.post.id);

    if (!mounted) return;
    setState(() {
      _existingComments = comments;
      _commentsLoading  = false;
    });
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    _heartPopCtrl.dispose(); // ✅ NEW
    super.dispose();
  }

  Future<void> _handleLike() async {
    _likeCtrl.forward(from: 0);
    final error = await ref
        .read(getPostViewModelProvider.notifier)
        .toggleLike(widget.post.id);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: const Color(0xFFEF4444),
      ));
    }
  }

  // ✅ NEW — Double-tap handler (poore card pe kahi bhi double tap = like)
  void _handleDoubleTapLike() {
    // Heart pop animation har double tap pe chalegi — regardless of state
    _heartPopCtrl.forward(from: 0);

    // ✅ Instagram jaisa rule — agar already liked he toh dusri baar
    // double-tap karne se UNLIKE nahi hoga, sirf animation dikhegi.
    // Sirf jab liked NAHI he tab hi same _handleLike() (toggleLike API) call hoga.
    if (!widget.post.isLiked) {
      _handleLike();
    }
  }

  void _handleComment() => showCommentSheet(context, ref, widget.post);

  // void _handleComment() {
  //   showCommentSheet(
  //     context, ref, widget.post,
  //     onCommentAdded: () {
  //       if (mounted) setState(() => _commentDelta++);
  //     },
  //   );
  // }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _OwnerActionsSheet(post: widget.post, ref: ref),
    );
  }

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
                      color: categoryColor(widget.post.category).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: categoryColor(widget.post.category).withOpacity(0.5)),
                    ),
                    child: Text(widget.post.category,
                        style: TextStyle(
                          color: categoryColor(widget.post.category),
                          fontSize: 10, fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                Text(widget.post.title,
                    style: const TextStyle(
                      color: kTextPrimary, fontSize: 16,
                      fontWeight: FontWeight.w800, height: 1.4,
                    )),
                const SizedBox(height: 6),
                Text(_timeAgo(widget.post.createdAt),
                    style: const TextStyle(color: kTextMuted, fontSize: 11)),
              ]),
            ),
            const Divider(color: kBorder, height: 1),
            // Expanded(
            //   child: SingleChildScrollView(
            //     controller: scrollCtrl,
            //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            //     child: Text(
            //       parseHtmlString(widget.post.content),
            //       style: const TextStyle(color: kTextMuted, fontSize: 14, height: 1.7),
            //     ),
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Html(
                  data: widget.post.content, // ✅ raw HTML seedha pass karo, plain text nahi
                  style: {
                    "body": Style(
                      color: kTextMuted,
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.7),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 10),
                    ),
                    "ul": Style(
                      margin: Margins.only(bottom: 10, left: 4),
                      padding: HtmlPaddings.only(left: 16),
                    ),
                    "ol": Style(
                      margin: Margins.only(bottom: 10, left: 4),
                      padding: HtmlPaddings.only(left: 16),
                    ),
                    "li": Style(
                      margin: Margins.only(bottom: 4),
                    ),
                    "strong": Style(
                      color: kTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    "em": Style(
                      fontStyle: FontStyle.italic,
                    ),
                    "a": Style(
                      color: kPurpleLight,
                    ),
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _stripHtml(String html) => parse(html).body?.text ?? '';
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    if (diff.inDays    < 7)  return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
  String _initial(String name) => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final post     = widget.post;
    final catColor = categoryColor(post.category);

    final avatarUrl     = ref.watch(avatarViewModelProvider).generatedMascotUrl;

    // ✅ Jab tak image load nahi hoti → pura card skeleton
    // if (!_imageReady) {
    //   return _CardSkeleton(isTablet: widget.isTablet, post: post);
    // }

    final isVideo = post.fileType == 'video';
    if (isVideo) {
      //return _buildRealCard(context, post, catColor);
      return _buildRealCard(context, post, catColor, avatarUrl);
    }

    // ✅ Image ready → poora card ek sath dikhao
    return Stack(
      children: [
      // ── Background mein image silently load karo ──────────────────────
      // Offstage = render nahi hota, sirf image cache hoti hai
      Offstage(
      offstage: true,
      child: _PostImageArea(
        post: post,
        isTablet: widget.isTablet,
        onImageReady: () {
          if (mounted && !_imageReady) {
            setState(() => _imageReady = true);
          }
        },
      ),
    ),

    // ── Skeleton ya real card ─────────────────────────────────────────
    if (!_imageReady)
    _CardSkeleton(isTablet: widget.isTablet, post: post)
    else
      AnimatedOpacity(
      opacity: 1.0, //_imageReady ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      //child: _buildRealCard(context, post, catColor),
        child: _buildRealCard(context, post, catColor, avatarUrl),

      // child: Container(
      //   margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
      //   decoration: BoxDecoration(
      //     color: kBgCard,
      //     borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
      //     border: widget.isTablet
      //         ? Border.all(color: kBorder, width: 0.5)
      //         : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      //   ),
      //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //
      //     // ── Header ────────────────────────────────────────────────────────
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      //       child: Row(children: [
      //         Container(
      //           width: 36, height: 36,
      //           decoration: const BoxDecoration(
      //             shape: BoxShape.circle,
      //             gradient: LinearGradient(
      //               colors: [kGold, kPurple],
      //               begin: Alignment.topLeft,
      //               end: Alignment.bottomRight,
      //             ),
      //           ),
      //           child: Center(
      //             child: Text(_initial(post.userName),
      //                 style: const TextStyle(
      //                     color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
      //           ),
      //         ),
      //         const SizedBox(width: 10),
      //         Expanded(
      //           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //             Text(post.userName,
      //                 style: const TextStyle(
      //                     color: kGold, fontSize: 12, fontWeight: FontWeight.w600)),
      //             Text(_timeAgo(post.createdAt),
      //                 style: const TextStyle(color: kTextMuted, fontSize: 10)),
      //           ]),
      //         ),
      //         Container(
      //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      //           decoration: BoxDecoration(
      //             color: catColor.withOpacity(0.12),
      //             borderRadius: BorderRadius.circular(20),
      //             border: Border.all(color: catColor.withOpacity(0.5), width: 0.8),
      //           ),
      //           child: Text(post.category,
      //               style: TextStyle(
      //                   color: catColor, fontSize: 9.5,
      //                   fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      //         ),
      //         const SizedBox(width: 8),
      //         if (post.isOwner)
      //           GestureDetector(
      //             onTap: () => _showMoreMenu(context),
      //             child: const Icon(Icons.more_horiz_rounded, color: kPurpleLight, size: 20),
      //           )
      //         else
      //           const SizedBox(width: 20),
      //       ]),
      //     ),
      //
      //     // ── Image (already loaded) ─────────────────────────────────────────
      //     _PostImageArea(
      //       post: post,
      //       isTablet: widget.isTablet,
      //       onImageReady: () {}, // Already ready, kuch nahi karna
      //     ),
      //
      //     // ── Title ─────────────────────────────────────────────────────────
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      //       child: Text(post.title,
      //         style: const TextStyle(
      //             color: kTextPrimary, fontSize: 13,
      //             fontWeight: FontWeight.w700, height: 1.4),
      //         maxLines: widget.isTablet ? 3 : 2,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //     ),
      //
      //     // ── Content preview + Actions ──────────────────────────────────────
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
      //       child: LayoutBuilder(
      //         builder: (context, constraints) {
      //           final text = _stripHtml(post.content);
      //           final textPainter = TextPainter(
      //             text: TextSpan(
      //                 text: text,
      //                 style: const TextStyle(fontSize: 12, height: 1.5)),
      //             maxLines: 2,
      //             textDirection: TextDirection.ltr,
      //           )..layout(maxWidth: constraints.maxWidth);
      //           final isOverflowing = textPainter.didExceedMaxLines;
      //
      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(text,
      //                 style: const TextStyle(
      //                     color: kTextMuted, fontSize: 12, height: 1.5),
      //                 maxLines: 2,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 8),
      //                 child: Row(children: [
      //                   // Like
      //                   GestureDetector(
      //                     onTap: _handleLike,
      //                     child: Row(children: [
      //                       ScaleTransition(
      //                         scale: _likeScale,
      //                         child: Icon(
      //                           post.isLiked
      //                               ? Icons.favorite_rounded
      //                               : Icons.favorite_border_rounded,
      //                           size: 18,
      //                           color: post.isLiked
      //                               ? const Color(0xFFEA4335)
      //                               : kTextMuted,
      //                         ),
      //                       ),
      //                       const SizedBox(width: 4),
      //                       Text('${post.likesCount}',
      //                           style: TextStyle(
      //                             fontSize: 11,
      //                             color: post.isLiked
      //                                 ? const Color(0xFFEA4335)
      //                                 : kTextMuted,
      //                           )),
      //                     ]),
      //                   ),
      //                   const SizedBox(width: 16),
      //                   // Comment
      //                   GestureDetector(
      //                     onTap: _handleComment,
      //                     child: const Row(children: [
      //                       Icon(Icons.chat_bubble_outline_rounded,
      //                           size: 16, color: kTextMuted),
      //                       SizedBox(width: 4),
      //                       Text('Comment',
      //                           style: TextStyle(
      //                               color: kTextMuted, fontSize: 11)),
      //                     ]),
      //                   ),
      //                   const SizedBox(width: 16),
      //                   // Share
      //                   GestureDetector(
      //                     onTap: _isSharing ? null : () async {
      //                       setState(() => _isSharing = true);
      //                       final hasImage = post.filePath != null &&
      //                           post.filePath!.isNotEmpty &&
      //                           post.fileType == 'image';
      //                       try {
      //                         if (hasImage) {
      //                           final response =
      //                           await http.get(Uri.parse(post.filePath!));
      //                           final tempDir =
      //                           await getTemporaryDirectory();
      //                           final tempFile = File(
      //                               '${tempDir.path}/share_image.jpg');
      //                           await tempFile
      //                               .writeAsBytes(response.bodyBytes);
      //                           await Share.shareXFiles(
      //                             [XFile(tempFile.path)],
      //                             text:
      //                             '${post.title}\n\n${_stripHtml(post.content)}',
      //                             subject: post.title,
      //                           );
      //                         } else {
      //                           await Share.share(
      //                             '${post.title}\n\n${_stripHtml(post.content)}',
      //                             subject: post.title,
      //                           );
      //                         }
      //                       } catch (_) {
      //                         await Share.share(
      //                           '${post.title}\n\n${_stripHtml(post.content)}',
      //                           subject: post.title,
      //                         );
      //                       } finally {
      //                         if (mounted)
      //                           setState(() => _isSharing = false);
      //                       }
      //                     },
      //                     child: _isSharing
      //                         ? const SizedBox(
      //                       width: 16, height: 16,
      //                       child: CircularProgressIndicator(
      //                           strokeWidth: 1.5, color: kTextMuted),
      //                     )
      //                         : const Icon(Icons.share_outlined,
      //                         size: 16, color: kTextMuted),
      //                   ),
      //                   const Spacer(),
      //                   if (isOverflowing)
      //                     GestureDetector(
      //                       onTap: () => _showFullContent(context),
      //                       child: const Text('Read more',
      //                           style: TextStyle(
      //                               color: kPurpleLight,
      //                               fontSize: 11,
      //                               fontWeight: FontWeight.w500)),
      //                     ),
      //                 ]),
      //               ),
      //             ],
      //           );
      //         },
      //       ),
      //     ),
      //   ]),
      // ),
    ),
  ],
    );
  }



  // Widget _buildRealCard(BuildContext context, GetPost post, Color catColor) {
  //   return Container(
  //     margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
  //     decoration: BoxDecoration(
  //       color: kBgCard,
  //       borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
  //       border: widget.isTablet
  //           ? Border.all(color: kBorder, width: 0.5)
  //           : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
  //     ),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       // ── Header ──────────────────────────────────────────────────────────
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
  //         child: Row(children: [
  //           Container(
  //             width: 36, height: 36,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //               gradient: LinearGradient(
  //                 colors: [kGold, kPurple],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(_initial(post.userName),
  //                   style: const TextStyle(
  //                       color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //           Expanded(
  //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //               Text(post.userName,
  //                   style: const TextStyle(
  //                       color: kGold, fontSize: 12, fontWeight: FontWeight.w600)),
  //               Text(_timeAgo(post.createdAt),
  //                   style: const TextStyle(color: kTextMuted, fontSize: 10)),
  //             ]),
  //           ),
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  //             decoration: BoxDecoration(
  //               color: catColor.withOpacity(0.12),
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(color: catColor.withOpacity(0.5), width: 0.8),
  //             ),
  //             child: Text(post.category,
  //                 style: TextStyle(
  //                     color: catColor, fontSize: 9.5,
  //                     fontWeight: FontWeight.w700, letterSpacing: 0.5)),
  //           ),
  //           const SizedBox(width: 8),
  //           if (post.isOwner)
  //             GestureDetector(
  //               onTap: () => _showMoreMenu(context),
  //               child: const Icon(Icons.more_horiz_rounded, color: kPurpleLight, size: 20),
  //             )
  //           else
  //             const SizedBox(width: 20),
  //         ]),
  //       ),
  //
  //       // ── Image (already loaded via Offstage) ───────────────────────────
  //       _PostImageArea(
  //         post: post,
  //         isTablet: widget.isTablet,
  //         onImageReady: () {}, // Already loaded, ignore
  //       ),
  //
  //       // ── Title ────────────────────────────────────────────────────────────
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
  //         child: Text(post.title,
  //           style: const TextStyle(
  //               color: kTextPrimary, fontSize: 13,
  //               fontWeight: FontWeight.w700, height: 1.4),
  //           maxLines: widget.isTablet ? 3 : 2,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //
  //       // ── Content + Actions ─────────────────────────────────────────────
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
  //         child: LayoutBuilder(
  //           builder: (context, constraints) {
  //             final text = _stripHtml(post.content);
  //             final textPainter = TextPainter(
  //               text: TextSpan(
  //                   text: text,
  //                   style: const TextStyle(fontSize: 12, height: 1.5)),
  //               maxLines: 2,
  //               textDirection: TextDirection.ltr,
  //             )..layout(maxWidth: constraints.maxWidth);
  //             final isOverflowing = textPainter.didExceedMaxLines;
  //
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(text,
  //                   style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.5),
  //                   maxLines: 2, overflow: TextOverflow.ellipsis,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8),
  //                   child: Row(children: [
  //                     GestureDetector(
  //                       onTap: _handleLike,
  //                       child: Row(children: [
  //                         ScaleTransition(
  //                           scale: _likeScale,
  //                           child: Icon(
  //                             post.isLiked
  //                                 ? Icons.favorite_rounded
  //                                 : Icons.favorite_border_rounded,
  //                             size: 18,
  //                             color: post.isLiked
  //                                 ? const Color(0xFFEA4335)
  //                                 : kTextMuted,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 4),
  //                         Text('${post.likesCount}',
  //                             style: TextStyle(
  //                               fontSize: 11,
  //                               color: post.isLiked
  //                                   ? const Color(0xFFEA4335)
  //                                   : kTextMuted,
  //                             )),
  //                       ]),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     GestureDetector(
  //                       onTap: _handleComment,
  //                       child: Row(children: [
  //                         const Icon(Icons.chat_bubble_outline_rounded,
  //                             size: 16, color: kTextMuted),
  //                         const SizedBox(width: 4),
  //                         if (!_commentsLoading)
  //                         // Text('comment',
  //                         //     style: const TextStyle(color: kTextMuted, fontSize: 11)),
  //                           Text(
  //                             '${_existingComments.length + _commentDelta}',
  //                             style: const TextStyle(color: kTextMuted, fontSize: 11),
  //                           ),
  //                       ]),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     GestureDetector(
  //                       onTap: _isSharing ? null : () async {
  //                         setState(() => _isSharing = true);
  //                         final hasImage = post.filePath != null &&
  //                             post.filePath!.isNotEmpty &&
  //                             post.fileType == 'image';
  //                         try {
  //                           if (hasImage) {
  //                             final response =
  //                             await http.get(Uri.parse(post.filePath!));
  //                             final tempDir = await getTemporaryDirectory();
  //                             final tempFile =
  //                             File('${tempDir.path}/share_image.jpg');
  //                             await tempFile.writeAsBytes(response.bodyBytes);
  //                             await Share.shareXFiles(
  //                               [XFile(tempFile.path)],
  //                               text: '${post.title}\n\n${_stripHtml(post.content)}',
  //                               subject: post.title,
  //                             );
  //                           } else {
  //                             await Share.share(
  //                               '${post.title}\n\n${_stripHtml(post.content)}',
  //                               subject: post.title,
  //                             );
  //                           }
  //                         } catch (_) {
  //                           await Share.share(
  //                             '${post.title}\n\n${_stripHtml(post.content)}',
  //                             subject: post.title,
  //                           );
  //                         } finally {
  //                           if (mounted) setState(() => _isSharing = false);
  //                         }
  //                       },
  //                       child: _isSharing
  //                           ? const SizedBox(
  //                         width: 16, height: 16,
  //                         child: CircularProgressIndicator(
  //                             strokeWidth: 1.5, color: kTextMuted),
  //                       )
  //                           : const Icon(Icons.share_outlined,
  //                           size: 16, color: kTextMuted),
  //                     ),
  //                     const Spacer(),
  //                     if (isOverflowing)
  //                       GestureDetector(
  //                         onTap: () => _showFullContent(context),
  //                         child: const Text('Read more',
  //                             style: TextStyle(
  //                                 color: kPurpleLight,
  //                                 fontSize: 11,
  //                                 fontWeight: FontWeight.w500)),
  //                       ),
  //                   ]),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  String _normalizeMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }

  Widget _buildRealCard(BuildContext context, GetPost post, Color catColor, String? avatarUrl) {
    // ✅ CHANGED — Pehle: `return Container(...)` seedha return hota tha.
    // Ab: GestureDetector(onDoubleTap) + Stack se wrap kiya hai, taaki
    // card pe kahi bhi double-tap karne se like ho jaye aur upar
    // Instagram jaisa heart pop animation dikhe.
    return GestureDetector(
      onDoubleTap: _handleDoubleTapLike, // ✅ NEW
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: kBgCard,
              borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
              border: widget.isTablet
                  ? Border.all(color: kBorder, width: 0.5)
                  : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Header ──────────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(children: [
                  // Container(
                  //   width: 36, height: 36,
                  //   decoration: const BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     gradient: LinearGradient(
                  //       colors: [kGold, kPurple],
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //     ),
                  //   ),
                  //   child: Center(
                  //     child: Text(_initial(post.userAvatarUrl),
                  //         style: const TextStyle(
                  //             color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  //   ),
                  // ),
                  _PostAvatar(
                    avatarUrl: post.userAvatarUrl,
                    userName: post.userName,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(post.userName,
                          style: const TextStyle(
                              color: kGold, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(_timeAgo(post.createdAt),
                          style: const TextStyle(color: kTextMuted, fontSize: 10)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: catColor.withOpacity(0.5), width: 0.8),
                    ),
                    child: Text(post.category,
                        style: TextStyle(
                            color: catColor, fontSize: 9.5,
                            fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 8),
                  if (post.isOwner)
                    GestureDetector(
                      onTap: () => _showMoreMenu(context),
                      child: const Icon(Icons.more_horiz_rounded, color: kPurpleLight, size: 20),
                    )
                  else
                    const SizedBox(width: 20),
                ]),
              ),

              // ── Image (already loaded via Offstage) ───────────────────────────
              _PostImageArea(
                post: post,
                isTablet: widget.isTablet,
                onImageReady: () {}, // Already loaded, ignore
              ),

              // ── Title ────────────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: Text(post.title,
                  style: const TextStyle(
                      color: kTextPrimary, fontSize: 13,
                      fontWeight: FontWeight.w700, height: 1.4),
                  maxLines: widget.isTablet ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ── Content + Actions ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final text = _stripHtml(post.content);
                    final textPainter = TextPainter(
                      text: TextSpan(
                          text: text,
                          style: const TextStyle(fontSize: 12, height: 1.5)),
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);
                    final isOverflowing = textPainter.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(text,
                          style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.5),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(children: [
                            GestureDetector(
                              onTap: _handleLike,
                              child: Row(children: [
                                ScaleTransition(
                                  scale: _likeScale,
                                  child: Icon(
                                    post.isLiked
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 25,
                                    color: post.isLiked
                                        ? const Color(0xFFEA4335)
                                        : kTextMuted,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text('${post.likesCount}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: post.isLiked
                                          ? const Color(0xFFEA4335)
                                          : kTextMuted,
                                    )),
                              ]),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _handleComment,
                              child: Row(children: [
                                const Icon(Icons.chat_bubble_outline_rounded,
                                    size: 25, color: kTextMuted),
                                const SizedBox(width: 4),
                                if (!_commentsLoading)
                                  Text(
                                    '${_existingComments.length + _commentDelta}',
                                    style: const TextStyle(color: kTextMuted, fontSize: 11),
                                  ),
                              ]),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              // onTap: _isSharing ? null : () async {
                              //   setState(() => _isSharing = true);
                              //   final hasImage = post.filePath != null &&
                              //       post.filePath!.isNotEmpty &&
                              //       post.fileType == 'image';
                              //   try {
                              //     if (hasImage) {
                              //       final response =
                              //       await http.get(Uri.parse(post.filePath!));
                              //       final tempDir = await getTemporaryDirectory();
                              //       final tempFile =
                              //       File('${tempDir.path}/share_image.jpg');
                              //       await tempFile.writeAsBytes(response.bodyBytes);
                              //       await Share.shareXFiles(
                              //         [XFile(tempFile.path)],
                              //         text: '${post.title}\n\n${_stripHtml(post.content)}',
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
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5, color: kTextMuted),
                              )
                                  : const Icon(Icons.share_outlined,
                                  size: 25, color: kTextMuted),
                            ),
                            const Spacer(),
                            if (isOverflowing)
                              GestureDetector(
                                onTap: () => _showFullContent(context),
                                child: const Text('Read more',
                                    style: TextStyle(
                                        color: kPurpleLight,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
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

          // ✅ NEW — Instagram-style big heart, double-tap pe pop ho ke fade ho jaata he
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _heartPopCtrl,
              builder: (context, _) {
                if (_heartPopCtrl.value == 0 && !_heartPopCtrl.isAnimating) {
                  return const SizedBox.shrink();
                }
                return Opacity(
                  opacity: _heartPopOpacity.value,
                  child: Transform.scale(
                    scale: _heartPopScale.value,
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.purpleAccent,
                      size: 90,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 14)],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Post header avatar — image agar present, warna initials fallback ─────────
class _PostAvatar extends StatelessWidget {
  const _PostAvatar({required this.avatarUrl, required this.userName});

  final String? avatarUrl;
  final String  userName;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasAvatar
            ? null
            : const LinearGradient(
          colors: [kGold, kPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: hasAvatar
          ? ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl!,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _initialsCircle(),
        ),
      )
          : _initialsCircle(),
    );
  }

  Widget _initialsCircle() {
    return Center(
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


// class PostCard extends ConsumerStatefulWidget {
//   final GetPost post;
//   final bool    isTablet;
//
//   // ✅ onLikeTap callback hata diya — ab internally ViewModel call hota hai
//   const PostCard({required this.post, required this.isTablet, super.key});
//
//   @override
//   ConsumerState<PostCard> createState() => _PostCardState();
// }
//
// class _PostCardState extends ConsumerState<PostCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _likeCtrl;
//   late Animation<double>   _likeScale;
//   bool _isSharing = false;
//
//   bool _imageReady = false;
//   bool _imageFailed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _likeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _likeScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _likeCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Like handler ─────────────────────────────────────────────────────────
//   // ✅ Animation play karo + ViewModel ka real API call karo
//   Future<void> _handleLike() async {
//     _likeCtrl.forward(from: 0);  // bounce animation
//
//     final error = await ref
//         .read(getPostViewModelProvider.notifier)
//         .toggleLike(widget.post.id);
//
//     if (error != null && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:         Text(error),
//           backgroundColor: const Color(0xFFEF4444),
//         ),
//       );
//     }
//   }
//
//   // ── Comment handler ───────────────────────────────────────────────────────
//   // ✅ CommentBottomSheet open karo
//   void _handleComment() {
//     showCommentSheet(context, ref, widget.post);
//   }
//
//   // ── More menu handler (owner only) ────────────────────────────────────────
//   // ✅ Edit ya Delete choose karo
//   void _showMoreMenu(BuildContext context) {
//     showModalBottomSheet(
//       context:         context,
//       backgroundColor: Colors.transparent,
//       builder:         (_) => _OwnerActionsSheet(
//         post: widget.post,
//         ref:  ref,
//       ),
//     );
//   }
//
//   // ── Full content sheet ────────────────────────────────────────────────────
//   // void _showFullContent(BuildContext context) {
//   //   showModalBottomSheet(
//   //     context:            context,
//   //     backgroundColor:    Colors.transparent,
//   //     isScrollControlled: true,
//   //     builder: (_) => DraggableScrollableSheet(
//   //       initialChildSize: 0.75,
//   //       minChildSize:     0.4,
//   //       maxChildSize:     0.95,
//   //       builder: (_, scrollCtrl) => Container(
//   //         padding: const EdgeInsets.all(20),
//   //         decoration: const BoxDecoration(
//   //           color:        kBgCard,
//   //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //         ),
//   //         child: SingleChildScrollView(
//   //           controller: scrollCtrl,
//   //           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//   //             Center(
//   //               child: Container(
//   //                 width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16),
//   //                 decoration: BoxDecoration(
//   //                     color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//   //               ),
//   //             ),
//   //             Text(widget.post.title,
//   //                 style: const TextStyle(
//   //                     color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
//   //             const SizedBox(height: 12),
//   //             Text(_stripHtml(widget.post.content),
//   //                 style: const TextStyle(color: kTextMuted, fontSize: 13, height: 1.6)),
//   //           ]),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // void _showFullContent(BuildContext context) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     backgroundColor: Colors.transparent,
//   //     isScrollControlled: true,
//   //     builder: (_) => DraggableScrollableSheet(
//   //       initialChildSize: 0.75,
//   //       minChildSize: 0.4,
//   //       maxChildSize: 0.95,
//   //       builder: (_, scrollCtrl) => Container(
//   //         decoration: const BoxDecoration(
//   //           color: kBgCard,
//   //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //         ),
//   //         child: Column(children: [
//   //           // Drag handle
//   //           Container(
//   //             width: 36, height: 4,
//   //             margin: const EdgeInsets.symmetric(vertical: 12),
//   //             decoration: BoxDecoration(color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//   //           ),
//   //           // Category + title header
//   //           Padding(
//   //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//   //             child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//   //               Container(
//   //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//   //                 decoration: BoxDecoration(
//   //                   color: _categoryColor(widget.post.category).withOpacity(0.12),
//   //                   borderRadius: BorderRadius.circular(20),
//   //                   border: Border.all(color: _categoryColor(widget.post.category).withOpacity(0.5)),
//   //                 ),
//   //                 child: Text(widget.post.category, style: TextStyle(
//   //                   color: _categoryColor(widget.post.category),
//   //                   fontSize: 10, fontWeight: FontWeight.w700,
//   //                 )),
//   //               ),
//   //               const SizedBox(height: 10),
//   //               Text(widget.post.title, style: const TextStyle(
//   //                 color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w800, height: 1.4,
//   //               )),
//   //               const SizedBox(height: 6),
//   //               Text(_timeAgo(widget.post.createdAt),
//   //                   style: const TextStyle(color: kTextMuted, fontSize: 11)),
//   //             ]),
//   //           ),
//   //           const Divider(color: kBorder, height: 1),
//   //           // ✅ CHANGE #4 — Scrollable full content text
//   //           Expanded(
//   //             child: SingleChildScrollView(
//   //               controller: scrollCtrl,
//   //               padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//   //               child: Text(
//   //                 parseHtmlString(widget.post.content),
//   //                 // widget.post.content,
//   //                 style: const TextStyle(
//   //                   color: kTextMuted, fontSize: 14, height: 1.7,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         ]),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//
//
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
//             // ── Drag handle ─────────────────────────────────────────────
//             Container(
//               width: 36, height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                   color: kTextMuted, borderRadius: BorderRadius.circular(2)),
//             ),
//
//             // ── Category + Title + Time header ───────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//
//                   // ✅ Badge sirf apni size lega — full width nahi
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: categoryColor(widget.post.category).withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: categoryColor(widget.post.category).withOpacity(0.5)),
//                       ),
//                       child: Text(widget.post.category,
//                           style: TextStyle(
//                             color: categoryColor(widget.post.category),
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                           )),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // ✅ Title — full width stretch
//                   Text(widget.post.title,
//                       style: const TextStyle(
//                         color: kTextPrimary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         height: 1.4,
//                       )),
//
//                   const SizedBox(height: 6),
//
//                   // ✅ Time — full width stretch
//                   Text(_timeAgo(widget.post.createdAt),
//                       style: const TextStyle(color: kTextMuted, fontSize: 11)),
//                 ],
//               ),
//             ),
//
//             const Divider(color: kBorder, height: 1),
//
//             // ── Scrollable full content ──────────────────────────────────
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
//   String _stripHtml(String html) => parse(html).body?.text ?? '';
//
//   String _timeAgo(DateTime dt) {
//     final diff = DateTime.now().difference(dt);
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours   < 24) return '${diff.inHours}h ago';
//     if (diff.inDays    < 7)  return '${diff.inDays}d ago';
//     return '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   String _initial(String name) => name.isNotEmpty ? name[0].toUpperCase() : '?';
//
//   @override
//   Widget build(BuildContext context) {
//     final post     = widget.post;
//     final catColor = categoryColor(post.category);
//
//     return Container(
//       margin: widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color:        kBgCard,
//         borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
//         border: widget.isTablet
//             ? Border.all(color: kBorder, width: 0.5)
//             : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//         // ── Header ──────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
//           child: Row(children: [
//             // Avatar
//             Container(
//               width: 36, height: 36,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [kGold, kPurple],
//                   begin:  Alignment.topLeft,
//                   end:    Alignment.bottomRight,
//                 ),
//               ),
//               child: Center(
//                 child: Text(_initial(post.userName),
//                     style: const TextStyle(
//                         color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(post.userName,
//                     style: const TextStyle(
//                         color: kGold, fontSize: 12, fontWeight: FontWeight.w600)),
//                 Text(_timeAgo(post.createdAt),
//                     style: const TextStyle(color: kTextMuted, fontSize: 10)),
//               ]),
//             ),
//             // Category badge
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color:        catColor.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(20),
//                 border:       Border.all(color: catColor.withOpacity(0.5), width: 0.8),
//               ),
//               child: Text(post.category,
//                   style: TextStyle(
//                       color: catColor, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
//             ),
//             const SizedBox(width: 8),
//
//             // ✅ More menu — sirf owner ko dikhao
//             if (post.isOwner)
//               GestureDetector(
//                 onTap: () => _showMoreMenu(context),
//                 child: const Icon(Icons.more_horiz_rounded,
//                     color: kPurpleLight, size: 20),
//               )
//             else
//               const SizedBox(width: 20), // spacing maintain karo
//           ]),
//         ),
//
//         // ── Image area ───────────────────────────────────────────────────────
//         _PostImageArea(post: post, isTablet: widget.isTablet),
//
//         // ── Title ────────────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//           child: Text(post.title,
//             style: const TextStyle(
//                 color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w700, height: 1.4),
//             maxLines: widget.isTablet ? 3 : 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//
//         // // ── Content preview ───────────────────────────────────────────────────
//         // Padding(
//         //   padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
//         //   child: Text(
//         //     _stripHtml(post.content),
//         //     style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.5),
//         //     maxLines: 2,
//         //     overflow: TextOverflow.ellipsis,
//         //   ),
//         // ),
//         //
//         // // ── Actions row ───────────────────────────────────────────────────────
//         // Padding(
//         //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
//         //   child: Row(children: [
//         //
//         //     // ✅ Like button (animation + real API)
//         //     GestureDetector(
//         //       onTap: _handleLike,
//         //       child: Row(children: [
//         //         ScaleTransition(
//         //           scale: _likeScale,
//         //           child: Icon(
//         //             post.isLiked
//         //                 ? Icons.favorite_rounded
//         //                 : Icons.favorite_border_rounded,
//         //             size:  18,
//         //             color: post.isLiked
//         //                 ? const Color(0xFFEA4335)
//         //                 : kTextMuted,
//         //           ),
//         //         ),
//         //         const SizedBox(width: 4),
//         //         Text('${post.likesCount}',
//         //             style: TextStyle(
//         //               fontSize: 11,
//         //               color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//         //             )),
//         //       ]),
//         //     ),
//         //
//         //     const SizedBox(width: 16),
//         //
//         //     // ✅ Comment button (opens CommentBottomSheet)
//         //     GestureDetector(
//         //       onTap: _handleComment,
//         //       child: const Row(children: [
//         //         Icon(Icons.chat_bubble_outline_rounded, size: 16, color: kTextMuted),
//         //         SizedBox(width: 4),
//         //         Text('Comment',
//         //             style: TextStyle(color: kTextMuted, fontSize: 11)),
//         //       ]),
//         //     ),
//         //
//         //     const SizedBox(width: 16),
//         //
//         //     // Share
//         //     GestureDetector(
//         //       onTap: () => Share.share(
//         //         '${post.title}\n\n${_stripHtml(post.content)}',
//         //         subject: post.title,
//         //       ),
//         //       child: const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
//         //     ),
//         //
//         //     const Spacer(),
//         //
//         //     // Read more
//         //     GestureDetector(
//         //       onTap: () => _showFullContent(context),
//         //       child: const Text('Read more',
//         //           style: TextStyle(
//         //               color: kPurpleLight, fontSize: 11, fontWeight: FontWeight.w500)),
//         //     ),
//         //   ]),
//         // ),
//
//         // ── Content preview + Read more (conditional) ─────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final text = _stripHtml(post.content);
//
//               // ✅ Check karo ki text 2 lines se zyada hai ya nahi
//               final textPainter = TextPainter(
//                 text: TextSpan(
//                   text: text,
//                   style: const TextStyle(fontSize: 12, height: 1.5),
//                 ),
//                 maxLines:        2,
//                 textDirection:   TextDirection.ltr,
//               )..layout(maxWidth: constraints.maxWidth);
//
//               final isOverflowing = textPainter.didExceedMaxLines;
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     text,
//                     style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.5),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//
//                   // ── Actions row ───────────────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Row(children: [
//
//                       // Like button
//                       GestureDetector(
//                         onTap: _handleLike,
//                         child: Row(children: [
//                           ScaleTransition(
//                             scale: _likeScale,
//                             child: Icon(
//                               post.isLiked
//                                   ? Icons.favorite_rounded
//                                   : Icons.favorite_border_rounded,
//                               size:  18,
//                               color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Text('${post.likesCount}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: post.isLiked ? const Color(0xFFEA4335) : kTextMuted,
//                               )),
//                         ]),
//                       ),
//
//                       const SizedBox(width: 16),
//
//                       // Comment button
//                       GestureDetector(
//                         onTap: _handleComment,
//                         child: const Row(children: [
//                           Icon(Icons.chat_bubble_outline_rounded, size: 16, color: kTextMuted),
//                           SizedBox(width: 4),
//                           Text('Comment', style: TextStyle(color: kTextMuted, fontSize: 11)),
//                         ]),
//                       ),
//
//                       const SizedBox(width: 16),
//
//                       // Share
//                       // GestureDetector(
//                       //   onTap: () => Share.share(
//                       //     '${post.title}\n\n${_stripHtml(post.content)}',
//                       //     subject: post.title,
//                       //   ),
//                       //   child: const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
//                       // ),
//
//                       // Share
//                       // Share
//                       GestureDetector(
//                         onTap: _isSharing ? null : () async {
//                           setState(() => _isSharing = true);
//
//                           final hasImage = post.filePath != null &&
//                               post.filePath!.isNotEmpty &&
//                               post.fileType == 'image';
//
//                           try {
//                             if (hasImage) {
//                               final response = await http.get(Uri.parse(post.filePath!));
//                               final tempDir  = await getTemporaryDirectory();
//                               final tempFile = File('${tempDir.path}/share_image.jpg');
//                               await tempFile.writeAsBytes(response.bodyBytes);
//
//                               await Share.shareXFiles(
//                                 [XFile(tempFile.path)],
//                                 text:    '${post.title}\n\n${_stripHtml(post.content)}',
//                                 subject: post.title,
//                               );
//                             } else {
//                               await Share.share(
//                                 '${post.title}\n\n${_stripHtml(post.content)}',
//                                 subject: post.title,
//                               );
//                             }
//                           } catch (_) {
//                             await Share.share(
//                               '${post.title}\n\n${_stripHtml(post.content)}',
//                               subject: post.title,
//                             );
//                           } finally {
//                             if (mounted) setState(() => _isSharing = false);
//                           }
//                         },
//                         child: _isSharing
//                             ? const SizedBox(
//                           width:  16,
//                           height: 16,
//                           child:  CircularProgressIndicator(
//                             strokeWidth: 1.5,
//                             color:       kTextMuted,
//                           ),
//                         )
//                             : const Icon(Icons.share_outlined, size: 16, color: kTextMuted),
//                       ),
//
//                       const Spacer(),
//
//                       // ✅ Read more — sirf tab dikhao jab text overflow ho
//                       if (isOverflowing)
//                         GestureDetector(
//                           onTap: () => _showFullContent(context),
//                           child: const Text('Read more',
//                               style: TextStyle(
//                                   color: kPurpleLight, fontSize: 11, fontWeight: FontWeight.w500)),
//                         ),
//                     ]),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ]),
//     );
//   }
// }



// ═══════════════════════════════════════════════════════════════════════════════
//  OWNER ACTIONS SHEET (Edit / Delete)
// ═══════════════════════════════════════════════════════════════════════════════
class _OwnerActionsSheet extends StatelessWidget {
  final GetPost   post;
  final WidgetRef ref;

  const _OwnerActionsSheet({required this.post, required this.ref});

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

    if (confirmed != true || !ctx.mounted) return;

    // ✅ FIX 2 — Navigator.pop se PEHLE messenger save karo
    // Pop ke baad ctx dispose ho jaata hai — messenger pehle pakad lo
    final messenger = ScaffoldMessenger.of(ctx);

    Navigator.pop(ctx); // sheet band karo

    final error = await ref
        .read(getPostViewModelProvider.notifier)
        .deletePost(post.id);

    // ✅ ctx.mounted check HATA diya — messenger already safe hai
    if (error == null) {
      messenger.showSnackBar(
        const SnackBar(
          content:         Text('Post deleted successfully.'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content:         Text('Delete failed: $error'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  // Future<void> _confirmDelete(BuildContext ctx) async {
  //   // ✅ PEHLE dialog dikhao
  //   final confirmed = await showDialog<bool>(
  //     context: ctx,
  //     builder: (dialogCtx) => AlertDialog(
  //       backgroundColor: kBgCard,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           side: const BorderSide(color: kBorder)),
  //       title: const Text('Delete Post',
  //           style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
  //       content: Text(
  //         'Are you sure you want to delete "${post.title}"? This cannot be undone.',
  //         style: const TextStyle(color: kTextMuted, fontSize: 13, height: 1.5),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogCtx, false),
  //           child: const Text('Cancel', style: TextStyle(color: kTextMuted)),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(dialogCtx, true),
  //           child: const Text('Delete',
  //               style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (confirmed != true || !ctx.mounted) return;
  //
  //   // ✅ PHIR sheet band karo
  //   Navigator.pop(ctx);
  //
  //   final error = await ref
  //       .read(getPostViewModelProvider.notifier)
  //       .deletePost(post.id);
  //
  //   if (!ctx.mounted) return;
  //
  //   if (error == null) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(
  //       const SnackBar(
  //         content:         Text('Post deleted successfully.'),
  //         backgroundColor: Color(0xFF22C55E),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(ctx).showSnackBar(
  //       SnackBar(
  //         content:         Text('Delete failed: $error'),
  //         backgroundColor: const Color(0xFFEF4444),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color:        kBgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: kTextMuted, borderRadius: BorderRadius.circular(2)),
          ),

          // ✅ EDIT
          _ActionTile(
            icon:  Icons.edit_outlined,
            label: 'Edit Post',
            color: kPurpleLight,
            onTap: () {
              Navigator.pop(context);  // sheet band karo
              showEditPostSheet(context, ref, post);
            },
          ),

          const SizedBox(height: 8),
          const Divider(color: kBorder, height: 1),
          const SizedBox(height: 8),

          // ✅ DELETE
          _ActionTile(
            icon:  Icons.delete_outline_rounded,
            label: 'Delete Post',
            color: const Color(0xFFEF4444),
            onTap: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding:      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration:   BoxDecoration(
        color:        kBgDeep,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        const Spacer(),
        Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.5), size: 18),
      ]),
    ),
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────
Color categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'gold & commodities':
    case 'gold':    return const Color(0xFFD4AF37);
    case 'oil market':
    case 'oil':     return const Color(0xFF22C55E);
    case 'forex & currency':
    case 'forex':   return const Color(0xFF3B82F6);
    case 'crypto':  return const Color(0xFFF59E0B);
    case 'stocks':  return const Color(0xFF8B5CF6);
    case 'economy': return const Color(0xFF06B6D4);
    default:        return const Color(0xFF6B7280);
  }
}


// ─── Full Card Skeleton ───────────────────────────────────────────────────────
class _CardSkeleton extends StatefulWidget {
  final bool isTablet;
  final GetPost post; // image preload ke liye

  const _CardSkeleton({required this.isTablet, required this.post});

  @override
  State<_CardSkeleton> createState() => _CardSkeletonState();
}

class _CardSkeletonState extends State<_CardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmerAnim =
        Tween<double>(begin: -1.0, end: 2.0).animate(_shimmerCtrl);

    // ✅ Background mein image preload karo — load hone par parent notify karo
    _preloadImage();
  }

  // void _preloadImage() {
  //   final hasImage = widget.post.filePath != null &&
  //       widget.post.filePath!.isNotEmpty &&
  //       widget.post.fileType == 'image';
  //
  //   if (!hasImage) return; // No image — should not reach here
  // }

  void _preloadImage() {
    final hasMedia = widget.post.filePath != null &&
        widget.post.filePath!.isNotEmpty &&
        (widget.post.fileType == 'image' || widget.post.fileType == 'video'); // ✅ video bhi

    if (!hasMedia) return; // No media — should not reach here
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: const [
                Color(0xFF1A0535),
                Color(0xFF2D1050),
                Color(0xFF1A0535),
              ],
              transform: _SlidingGradientTransform(_shimmerAnim.value),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      widget.isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: widget.isTablet ? BorderRadius.circular(14) : null,
        border: widget.isTablet
            ? Border.all(color: kBorder, width: 0.5)
            : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Header skeleton ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Row(children: [
            _shimmerBox(width: 36, height: 36, radius: 18), // avatar circle
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 100, height: 10),
                    const SizedBox(height: 6),
                    _shimmerBox(width: 60, height: 8),
                  ]),
            ),
            _shimmerBox(width: 60, height: 20, radius: 10),
          ]),
        ),

        // ── Image skeleton ────────────────────────────────────────────────
        _shimmerBox(
          width: double.infinity,
          height: widget.isTablet ? 140 : 160,
          radius: 0,
        ),

        // ── Title skeleton ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                _shimmerBox(width: 200, height: 12),
              ]),
        ),

        // ── Content + actions skeleton ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: double.infinity, height: 10),
                const SizedBox(height: 5),
                _shimmerBox(width: 240, height: 10),
                const SizedBox(height: 12),
                Row(children: [
                  _shimmerBox(width: 40, height: 10),
                  const SizedBox(width: 16),
                  _shimmerBox(width: 60, height: 10),
                  const SizedBox(width: 16),
                  _shimmerBox(width: 20, height: 10),
                ]),
              ]),
        ),
      ]),
    );
  }
}

// Shimmer slide gradient transform
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

// ─── Post Image Area (unchanged from original) ────────────────────────────────
class _PostImageArea extends StatefulWidget {
  final GetPost post;
  final bool isTablet;
  final VoidCallback onImageReady; // ✅ NEW

  const _PostImageArea({
    required this.post,
    required this.isTablet,
    required this.onImageReady, // ✅ NEW
  });

  @override
  State<_PostImageArea> createState() => _PostImageAreaState();
}

class _PostImageAreaState extends State<_PostImageArea> {
  // @override
  // Widget build(BuildContext context) {
  //   final catColor = categoryColor(widget.post.category);
  //   final hasImage = widget.post.filePath != null &&
  //       widget.post.filePath!.isNotEmpty &&
  //       widget.post.fileType == 'image';
  //
  //   if (hasImage) {
  //     return Stack(children: [
  //       CachedNetworkImage(
  //         imageUrl: widget.post.filePath!,
  //         width: double.infinity,
  //         fit: BoxFit.contain,
  //         // ✅ Image load ho gayi → parent ko notify karo
  //         imageBuilder: (context, imageProvider) {
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             if (mounted) widget.onImageReady();
  //           });
  //           return Image(
  //               image: imageProvider,
  //               fit: BoxFit.contain,
  //               width: double.infinity);
  //         },
  //         placeholder: (context, url) => const SizedBox.shrink(),
  //         errorWidget: (context, url, error) {
  //           // Error pe bhi ready karo — fallback dikhao
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             if (mounted) widget.onImageReady();
  //           });
  //           return _chartFallback(catColor);
  //         },
  //       ),
  //       if (widget.post.isOwner)
  //         Positioned(
  //           top: 8, right: 10,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //             decoration: BoxDecoration(
  //               color: kPurple.withOpacity(0.8),
  //               borderRadius: BorderRadius.circular(3),
  //             ),
  //             child: const Text('MY POST', style: TextStyle(
  //               color: Colors.white, fontSize: 8,
  //               fontWeight: FontWeight.w700, letterSpacing: 1,
  //             )),
  //           ),
  //         ),
  //     ]);
  //   }
  //
  //   return _chartFallback(catColor);
  // }

  // ✅ Backend kabhi kabhi scheme-less URL bhejta he (video ke liye) — fix karo
  String _normalizeMediaUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColor(widget.post.category);
    final hasImage = widget.post.filePath != null &&
        widget.post.filePath!.isNotEmpty &&
        widget.post.fileType == 'image';
    final hasVideo = widget.post.filePath != null && // ✅ NEW
        widget.post.filePath!.isNotEmpty &&
        widget.post.fileType == 'video';

    if (hasImage) {
      return Stack(children: [
        CachedNetworkImage(
          imageUrl: widget.post.filePath!,
          width: double.infinity,
          fit: BoxFit.contain,
          imageBuilder: (context, imageProvider) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onImageReady();
            });
            return Image(
                image: imageProvider,
                fit: BoxFit.contain,
                width: double.infinity);
          },
          placeholder: (context, url) => const SizedBox.shrink(),
          errorWidget: (context, url, error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onImageReady();
            });
            return _chartFallback(catColor);
          },
        ),
        if (widget.post.isOwner)
          Positioned(
            top: 8, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('MY POST', style: TextStyle(
                color: Colors.white, fontSize: 8,
                fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
            ),
          ),
      ]);
    }

    // ✅ NEW — Video post
    if (hasVideo) {
      return Stack(children: [
        _PostVideoArea(
          videoUrl: _normalizeMediaUrl(widget.post.filePath!), // ✅ scheme fix
          isTablet: widget.isTablet,
          onReady: widget.onImageReady, // same callback reuse karo
        ),
        if (widget.post.isOwner)
          Positioned(
            top: 8, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('MY POST', style: TextStyle(
                color: Colors.white, fontSize: 8,
                fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
            ),
          ),
      ]);
    }

    return _chartFallback(catColor);
  }

  Widget _chartFallback(Color catColor) {
    return SizedBox(
      height: widget.isTablet ? 140 : 160,
      width: double.infinity,
      child: Stack(fit: StackFit.expand, children: [
        Container(color: const Color(0xFF0A0118)),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: catColor.withOpacity(0.4), width: 0.8),
            ),
            child: Text(widget.post.category.toUpperCase(),
                style: TextStyle(
                    color: catColor, fontSize: 18,
                    fontWeight: FontWeight.w900, letterSpacing: 3)),
          ),
        ),
        if (widget.post.isOwner)
          Positioned(
            top: 8, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text('MY POST', style: TextStyle(
                color: Colors.white, fontSize: 8,
                fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
            ),
          ),
      ]),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════
//  _PostVideoArea — inline video playback with tap-to-play + mute toggle
// ═══════════════════════════════════════════════════════════════════════════
class _PostVideoArea extends StatefulWidget {
  final String videoUrl;
  final bool   isTablet;
  final VoidCallback onReady;

  const _PostVideoArea({
    required this.videoUrl,
    required this.isTablet,
    required this.onReady,
  });

  @override
  State<_PostVideoArea> createState() => _PostVideoAreaState();
}

class _PostVideoAreaState extends State<_PostVideoArea> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying   = false;
  bool _isMuted     = true; // default muted, Instagram jaisa
  bool _hasError    = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Future<void> _init() async {
  //   try {
  //     final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
  //     await controller.initialize();
  //     await controller.setVolume(0); // muted by default
  //     await controller.setLooping(true);
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
  //     widget.onReady(); // ✅ parent ko batao ready hai (skeleton hide hoga)
  //   } catch (_) {
  //     if (mounted) {
  //       setState(() => _hasError = true);
  //       widget.onReady(); // error pe bhi skeleton hide karo
  //     }
  //   }
  // }

  Future<void> _init() async {
    try {
      // ✅ NEW — Video ko disk pe cache karo (flutter_cache_manager).
      // Pehli baar network se download hoga, uske baad HAMESHA local
      // file se play hoga — isliye "baar baar load" wala issue fix.
      final fileInfo = await DefaultCacheManager().getSingleFile(widget.videoUrl);

      final controller = VideoPlayerController.file(fileInfo); // ✅ network nahi, local file
      await controller.initialize();
      await controller.setVolume(0); // muted by default
      await controller.setLooping(true);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller  = controller;
        _initialized = true;
      });
      widget.onReady(); // ✅ parent ko batao ready hai (skeleton hide hoga)
    } catch (_) {
      if (mounted) {
        setState(() => _hasError = true);
        widget.onReady(); // error pe bhi skeleton hide karo
      }
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
        height: widget.isTablet ? 140 : 220,
        width: double.infinity,
        color: const Color(0xFF0A0118),
        child: const Center(
          child: Icon(Icons.videocam_off_rounded, color: kTextMuted, size: 40),
        ),
      );
    }

    if (!_initialized || _controller == null) {
      return Container(
        height: widget.isTablet ? 140 : 220,
        width: double.infinity,
        color: const Color(0xFF0A0118),
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
        // Play icon jab paused ho
        if (!_isPlaying)
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
          ),
        // Mute toggle
        Positioned(
          bottom: 10, right: 10,
          child: GestureDetector(
            onTap: _toggleMute,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55), shape: BoxShape.circle),
              child: Icon(
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.white, size: 16,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}



// class _PostImageArea extends StatelessWidget {
//   final GetPost post;
//   final bool    isTablet;
//   const _PostImageArea({required this.post, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final catColor = categoryColor(post.category);
//     final hasImage = post.filePath != null &&
//         post.filePath!.isNotEmpty &&
//         post.fileType == 'image';
//
//     if (hasImage) {
//       return Stack(
//         children: [
//
//           // ✅ AspectRatio HATA diya — image apni natural height legi
//           // CachedNetworkImage = disk cache — scroll/restart pe reload nahi
//           CachedNetworkImage(
//             imageUrl:  post.filePath!,
//             fit:       BoxFit.contain,  // poori image dikhegi, cut nahi hogi
//             width:     double.infinity,
//
//             // ✅ Loading shimmer
//             placeholder: (context, url) => ShimmerBox(
//               width:        double.infinity,
//               height:       isTablet ? 140 : 160,
//               borderRadius: 0,
//             ),
//
//             // ✅ Error fallback
//             errorWidget: (context, url, error) => _chartFallback(catColor),
//           ),
//
//           // MY POST badge
//           if (post.isOwner)
//             Positioned(
//               top: 8, right: 10,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color:        kPurple.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//                 child: const Text('MY POST',
//                     style: TextStyle(
//                         color:         Colors.white,
//                         fontSize:      8,
//                         fontWeight:    FontWeight.w700,
//                         letterSpacing: 1)),
//               ),
//             ),
//         ],
//       );
//     }
//
//     return _chartFallback(catColor);
//   }
//
//   Widget _chartFallback(Color catColor) => SizedBox(
//     height: isTablet ? 140 : 160,
//     width:  double.infinity,
//     child: Stack(fit: StackFit.expand, children: [
//       Container(color: const Color(0xFF0A0118)),
//       Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color:        Colors.black.withOpacity(0.45),
//             borderRadius: BorderRadius.circular(8),
//             border:       Border.all(color: catColor.withOpacity(0.4), width: 0.8),
//           ),
//           child: Text(post.category.toUpperCase(),
//               style: TextStyle(
//                   color:         catColor,
//                   fontSize:      18,
//                   fontWeight:    FontWeight.w900,
//                   letterSpacing: 3)),
//         ),
//       ),
//       if (post.isOwner)
//         Positioned(
//           top: 8, right: 10,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//               color:        kPurple.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: const Text('MY POST',
//                 style: TextStyle(
//                     color:         Colors.white,
//                     fontSize:      8,
//                     fontWeight:    FontWeight.w700,
//                     letterSpacing: 1)),
//           ),
//         ),
//     ]),
//   );
// }


// class _PostImageArea extends StatelessWidget {
//   final GetPost post;
//   final bool    isTablet;
//   const _PostImageArea({required this.post, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     final catColor = categoryColor(post.category);
//     final hasImage = post.filePath != null &&
//         post.filePath!.isNotEmpty &&
//         post.fileType == 'image';
//
//     if (hasImage) {
//       return Stack(children: [
//         Image.network(
//           post.filePath!,
//           width: double.infinity,
//           fit:   BoxFit.contain,
//           loadingBuilder: (_, child, get_progress) {
//             if (get_progress == null) return child;
//             // return Container(
//             //   height: isTablet ? 140 : 160,
//             //   color:  const Color(0xFF1A0535),
//             //   child: const Center(
//             //       child: CircularProgressIndicator(color: kPurple, strokeWidth: 2)),
//             // );
//             // ✅ CHANGE 4a — Shimmer box same size as image area
//             return ShimmerBox(
//               width:        double.infinity,
//               height:       isTablet ? 140 : 160,
//               borderRadius: 0,
//             );
//           },
//           errorBuilder: (_, __, ___) => _chartFallback(catColor),
//         ),
//         if (post.isOwner)
//           Positioned(
//             top: 8, right: 10,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                   color: kPurple.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(3)),
//               child: const Text('MY POST',
//                   style: TextStyle(color: Colors.white, fontSize: 8,
//                       fontWeight: FontWeight.w700, letterSpacing: 1)),
//             ),
//           ),
//       ]);
//     }
//     return _chartFallback(catColor);
//   }
//
//   Widget _chartFallback(Color catColor) => SizedBox(
//     height: isTablet ? 140 : 160,
//     width: double.infinity,
//     child: Stack(fit: StackFit.expand, children: [
//       Container(color: const Color(0xFF0A0118)),
//       Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color:  Colors.black.withOpacity(0.45),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: catColor.withOpacity(0.4), width: 0.8),
//           ),
//           child: Text(post.category.toUpperCase(),
//               style: TextStyle(color: catColor, fontSize: 18,
//                   fontWeight: FontWeight.w900, letterSpacing: 3)),
//         ),
//       ),
//       if (post.isOwner)
//         Positioned(
//           top: 8, right: 10,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//                 color: kPurple.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(3)),
//             child: const Text('MY POST',
//                 style: TextStyle(color: Colors.white, fontSize: 8,
//                     fontWeight: FontWeight.w700, letterSpacing: 1)),
//           ),
//         ),
//     ]),
//   );
// }


// ═══════════════════════════════════════════════════════════════════════════════
// HOW TO USE PostCard in SliverList / SliverGrid (HomeScreen me update karo)
// ═══════════════════════════════════════════════════════════════════════════════
//
// OLD code:
// _PostCard(
//   post: feedState.posts[index],
//   isTablet: false,
//   onLikeTap: () => ref.read(getPostViewModelProvider.notifier)
//       .toggleLike(feedState.posts[index].id),
// )
//
// NEW code (onLikeTap hatao — PostCard internally handle karta hai):
// PostCard(
//   post:     feedState.posts[index],
//   isTablet: false,
// )
//
// ════════════════════════════════════════════════════════════════════════════
