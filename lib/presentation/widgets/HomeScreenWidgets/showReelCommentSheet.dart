
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../../../domain/model/reel/ReelPost.dart';      // ✅ NEW — GetPost ki jagah ReelPost
import '../../../domain/model/post/PostComment.dart';
import '../../../domain/model/post/ReelPost.dart';
import '../../viewmodal/post/GetPostViewModel.dart';      // ✅ like/comment backend reuse ho raha he

// ── Constants ─────────────────────────────────────────────────────────────────
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);

// ── Entry point ───────────────────────────────────────────────────────────────
// ✅ NEW — showCommentSheet ka hi copy, sirf ReelPost ke liye alag banaya
// he taaki showCommentSheet.dart (GetPost wala, jo PostCard.dart me use
// hota he) ko touch na karna pade
void showReelCommentSheet(BuildContext context, WidgetRef ref, ReelPost post) {
  showModalBottomSheet(
    context:            context,
    backgroundColor:    Colors.transparent,
    isScrollControlled: true,
    builder: (sheetCtx) => ScaffoldMessenger(
      child: Builder(
        builder: (innerCtx) => Scaffold(
          backgroundColor:          Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: _ReelCommentSheet(post: post, ref: ref),
        ),
      ),
    ),
  );
}

// ── Sheet Widget ──────────────────────────────────────────────────────────────
class _ReelCommentSheet extends StatefulWidget {
  final ReelPost  post; // ✅ CHANGED — GetPost → ReelPost
  final WidgetRef ref;

  const _ReelCommentSheet({required this.post, required this.ref});

  @override
  State<_ReelCommentSheet> createState() => _ReelCommentSheetState();
}

class _ReelCommentSheetState extends State<_ReelCommentSheet> {
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();
  final _sheetController = DraggableScrollableController();

  bool _submitting = false;
  bool _fetching   = true;

  List<PostComment> _existingComments = [];
  final List<PostComment> _sessionComments = [];

  @override
  void initState() {
    super.initState();
    _loadExistingComments();
    _focus.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocusChange);
    _ctrl.dispose();
    _focus.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focus.hasFocus && _sheetController.isAttached) {
      _sheetController.animateTo(
        0.92,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  // ── Existing comments fetch karo — same backend endpoint reuse ─────────────
  Future<void> _loadExistingComments() async {
    final comments = await widget.ref
        .read(getPostViewModelProvider.notifier)
        .fetchComments(widget.post.id);

    if (!mounted) return;
    setState(() {
      _existingComments = comments;
      _fetching         = false;
    });
  }

  // ── New comment submit karo ───────────────────────────────────────────────
  Future<void> _submit() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _submitting) return;

    setState(() => _submitting = true);

    final comment = await widget.ref
        .read(getPostViewModelProvider.notifier)
        .addComment(postId: widget.post.id, content: text);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (comment != null) {
      _ctrl.clear();
      _focus.unfocus();
      setState(() => _sessionComments.insert(0, comment));
    } else {
      _focus.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Failed to post comment. Try again.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _initial(String name) => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    final allComments = [..._sessionComments, ..._existingComments];
    final totalCount  = allComments.length;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.6,
      minChildSize:     0.4,
      maxChildSize:     0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color:        kBgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: kTextMuted, borderRadius: BorderRadius.circular(2)),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    color: kPurpleLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Comments on "${widget.post.title}"',
                    style: const TextStyle(
                        color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!_fetching)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:        kPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border:       Border.all(color: kPurple.withOpacity(0.4)),
                    ),
                    child: Text(
                      '$totalCount',
                      style: const TextStyle(
                          color: kPurpleLight, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
              ]),
            ),

            const Divider(color: kBorder, height: 1),

            Expanded(
              child: _fetching
                  ? const Center(
                child: CircularProgressIndicator(color: kPurple, strokeWidth: 2),
              )
                  : allComments.isEmpty
                  ? Center(
                child: SingleChildScrollView(
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          color: kTextMuted, size: 36),
                      SizedBox(height: 10),
                      Text(
                        'No comments yet.\nBe the first to comment!',
                        style: TextStyle(
                            color: kTextMuted, fontSize: 13, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.separated(
                controller:      scrollCtrl,
                padding:         const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount:       allComments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) {
                  final c = allComments[i];
                  final isNew = i < _sessionComments.length;
                  return _ReelCommentTile(
                    comment: c,
                    timeAgo: _timeAgo(c.createdAt),
                    initial: _initial(c.userName),
                    isNew:   isNew,
                  );
                },
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                left: 12, right: 12, top: 10,
                bottom: bottomPadding + 16,
              ),
              decoration: const BoxDecoration(
                color:  kBgDeep,
                border: Border(top: BorderSide(color: kBorder, width: 0.5)),
              ),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller:     _ctrl,
                    focusNode:      _focus,
                    autofocus:      true,
                    style:          const TextStyle(color: kTextPrimary, fontSize: 13),
                    maxLines:       null,
                    textInputAction: TextInputAction.send,
                    onSubmitted:    (_) => _submit(),
                    decoration: InputDecoration(
                      hintText:  'Write a comment...',
                      hintStyle: const TextStyle(color: kTextMuted, fontSize: 13),
                      filled:    true,
                      fillColor: kBgCard,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:   const BorderSide(color: kBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:   const BorderSide(color: kBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:   const BorderSide(color: kPurple),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitting ? null : _submit,
                  child: AnimatedContainer(
                    duration:   const Duration(milliseconds: 200),
                    width: 42,  height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _submitting ? kBorder : kPurple,
                    ),
                    child: _submitting
                        ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single Comment Tile ───────────────────────────────────────────────────────
class _ReelCommentTile extends StatelessWidget {
  final PostComment comment;
  final String      timeAgo;
  final String      initial;
  final bool        isNew;

  const _ReelCommentTile({
    required this.comment,
    required this.timeAgo,
    required this.initial,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [kGold, kPurple],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(initial,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isNew ? kPurple.withOpacity(0.08) : kBgDeep,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isNew ? kPurple.withOpacity(0.3) : kBorder,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(comment.userName,
                        style: const TextStyle(
                            color: kGold, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color:        kPurple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('NEW',
                            style: TextStyle(
                                color: kPurpleLight, fontSize: 8,
                                fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                      ),
                    const Spacer(),
                    Text(timeAgo,
                        style: const TextStyle(color: kTextMuted, fontSize: 10)),
                  ]),
                  const SizedBox(height: 4),
                  Text(comment.content,
                      style: const TextStyle(
                          color: kTextPrimary, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}