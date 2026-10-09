//
// import 'package:flutter/material.dart';
//
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData.dark(),
// //       home: const CreatePostScreen(),
// //     );
// //   }
// // }
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vervee_app/domain/model/post/CreatePost.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../utils/MediaAspectUtils.dart';
import '../../utils/NetworkResult.dart';
//import '../../utils/FeedMediaConfig.dart'; // ✅ dynamic feed-ratio clamp helper
import '../viewmodal/avatar/AvatarViewModel.dart';
import '../viewmodal/pofile/ProfileViewmodels.dart';
import '../viewmodal/post/CreatePostViewmodel.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
abstract class _C {
  static const bg        = Color(0xFF000000);
  static const surface   = Color(0xFF121212);
  static const surfaceEl = Color(0xFF1C1C1C);
  static const divider   = Color(0xFF262626);
  static const accent    = Color(0xFF0095F6);
  static const accentSec = Color(0xFFFF006E);
  static const textPri   = Color(0xFFFFFFFF);
  static const textSec   = Color(0xFFA8A8A8);
  static const textTer   = Color(0xFF555555);
  static const green     = Color(0xFF00D084);
  static const tag       = Color(0xFF1A2332);
}

// ─── MediaItem ────────────────────────────────────────────────────────────────
// isCropped = true means file is already a pixel-cropped PNG from GalleryPicker
class MediaItem {
  final String path;
  final bool   isImage;
  final bool   isCropped; // ← NEW: gallery se aaya cropped file
  MediaItem({required this.path, required this.isImage, this.isCropped = false});
}

// ═════════════════════════════════════════════════════════════════════════════
//  CREATE POST SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class CreatePostScreen extends ConsumerStatefulWidget {
  final List<MediaItem>? initialMedia;
  const CreatePostScreen({super.key, this.initialMedia});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  final _titleCtrl   = TextEditingController();
  final _quillCtrl   = QuillController.basic();
  final _editorFocus = FocusNode();
  final _scrollCtrl  = ScrollController();

  String _category = 'Oil Market';
  final List<String> _categories = [
    //'Forex & Currency', 'Crypto', 'Stocks', 'Commodities', 'Economy', 'Other',
    'Oil Market',
    'Gold & Commodities',
    'Forex & Currency',
    'Geopolitics',
    'Economic Policy',
    'Market Volatility',
    // 'Other',
  ];

  final List<MediaItem> _media = [];
  bool _isExpanded = true;

  late AnimationController _fabAnim;
  late Animation<double>   _fabScale;

  @override
  void initState() {
    super.initState();
    // Gallery se aaye cropped images — directly add karo, re-process mat karo
    if (widget.initialMedia != null && widget.initialMedia!.isNotEmpty) {
      _media.addAll(widget.initialMedia!);
    }
    _fabAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOutBack);
    Future.delayed(const Duration(milliseconds: 300), () => _fabAnim.forward());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _quillCtrl.dispose();
    _editorFocus.dispose();
    _scrollCtrl.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery, imageQuality: 85,
      maxWidth: 1920, maxHeight: 1920,
    );
    if (x != null) {
      final sizeMB = await File(x.path).length() / (1024 * 1024);
      if (sizeMB > 5) {
        if (mounted) _snack('Image too large. Please select an image under 5MB.', isError: true);
        return;
      }
      setState(() => _media.add(MediaItem(path: x.path, isImage: true)));
    }
  }

  Future<void> _pickFile() async {
    final r = await FilePicker.platform.pickFiles();
    if (r?.files.single.path != null) {
      final p      = r!.files.single.path!;
      final sizeMB = await File(p).length() / (1024 * 1024);
      if (sizeMB > 5) {
        if (mounted) _snack('File too large. Please select a file under 5MB.', isError: true);
        return;
      }
      final isImg = ['.jpg','.jpeg','.png','.gif','.webp']
          .any((e) => p.toLowerCase().endsWith(e));
      setState(() => _media.add(MediaItem(path: p, isImage: isImg)));
    }
  }

  Future<void> _publish() async {
    // final title = _titleCtrl.text.trim();
    // if (title.isEmpty) { _snack('Add a Title to your post', isError: true); return; }

    final title = _titleCtrl.text.trim();

    if (title.isEmpty) {
      _snack('Add a Title to your post', isError: true);
      return;
    }
    if (title.length < 3) {
      _snack('Title must be at least 3 characters', isError: true);
      return;
    }
    if (title.length > 100) {
      _snack('Title can be at most 100 characters', isError: true);
      return;
    }

    final plain = _quillCtrl.document.toPlainText().trim();
    if (plain.isEmpty || plain == '\n') {
      _snack('Write something in your post content', isError: true); return;
    }

    if (_media.isNotEmpty) {
      final sizeMB = await File(_media.first.path).length() / (1024 * 1024);
      if (sizeMB > 100) {
        _snack('Image too large (${sizeMB.toStringAsFixed(1)}MB). Max 5MB.', isError: true);
        return;
      }
    }

    HapticFeedback.mediumImpact();

    final deltaJson = _quillCtrl.document.toDelta().toJson();
    final html      = QuillDeltaToHtmlConverter(
      List.castFrom(deltaJson), ConverterOptions(),
    ).convert();

    await ref.read(createPostViewModelProvider.notifier).createPost(
      title: title, content: html, category: _category,
      file: _media.isNotEmpty ? File(_media.first.path) : null,
    );
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13))),
      ]),
      backgroundColor: isError ? const Color(0xFFE53935) : _C.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  void _preview() => Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, anim, __) => FadeTransition(opacity: anim,
        child: PreviewScreen(title: _titleCtrl.text, category: _category,
            quillCtrl: _quillCtrl, media: _media)),
    transitionDuration: const Duration(milliseconds: 250),
  ));

  @override
  Widget build(BuildContext context) {
    ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (_, next) {
      next.when(
        initial: () {},
        loading: () => ScaffoldMessenger.of(context).clearSnackBars(),
        success: (post) {
          HapticFeedback.lightImpact();
          _snack('✓  "${post.title}" shared!');
          ref.read(createPostViewModelProvider.notifier).reset();
          Future.delayed(const Duration(milliseconds: 800), () {
            //if (mounted) Navigator.maybePop(context);
            if (mounted) Navigator.pop(context, true); // ✅ true = post hua
          });
        },
        error: (msg, _) => _snack(msg, isError: true),
      );
    });

    final isLoading = ref.watch(createPostViewModelProvider) is Loading<CreatePost>;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: Stack(children: [
          SafeArea(
            child: Column(children: [
              _buildTopBar(isLoading),
              const _HairlineDivider(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // ── Media strip — dynamic aspect ratio, feed jaisa ──────
                    _MediaStrip(
                      items: _media,
                      onAdd: _pickImage,
                      onRemove: (i) => setState(() => _media.removeAt(i)),
                    ),
                    _CaptionRow(controller: _titleCtrl),
                    const _HairlineDivider(),
                    if (_media.isEmpty || !_media.first.isImage) ...[
                      _CategoryRow(
                        value: _category, items: _categories,
                        onChanged: (v) => setState(() => _category = v),
                      ),
                      const _HairlineDivider(),
                    ],
                    const _HairlineDivider(),
                    _ContentSection(
                      controller: _quillCtrl, focusNode: _editorFocus,
                      isExpanded: _isExpanded,
                      onToggle: () => setState(() => _isExpanded = !_isExpanded),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ]),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(child: _LoadingDots()),
            ),
        ]),
      ),
    );
  }

  Widget _buildTopBar(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(children: [
        _IgIconBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
        const Spacer(),
        const Text('New post', style: TextStyle(
            color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
        const Spacer(),
        _IgIconBtn(icon: Icons.remove_red_eye_outlined, onTap: _preview),
        ScaleTransition(
          scale: _fabScale,
          child: _ShareBtn(onTap: isLoading ? null : _publish),
        ),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  MEDIA STRIP
//  ✅ CHANGED — Ab strip FIXED ratio use nahi karti. Pehle item (jo primary
//  banega) ki ASLI aspect ratio decode karke — Instagram jaisa hi — sirf
//  extreme cases (bahut tall/wide) ko kFeedMinAspectRatio/kFeedMaxAspectRatio
//  ke beech clamp karti he. Baaki har normal portrait/landscape/square photo
//  apni asli shape me hi dikhta he — feed (PostCard) me bhi EXACT wahi ratio
//  use hoti he (WYSIWYG), isliye kahi bhi black space nahi aata.
//  Multi-image carousel me saare items isi (pehli image ki) height ke box me
//  BoxFit.cover se dikhte he — bilkul Instagram carousel jaisa.
// ═════════════════════════════════════════════════════════════════════════════
class _MediaStrip extends StatefulWidget {
  final List<MediaItem> items;
  final VoidCallback    onAdd;
  final ValueChanged<int> onRemove;

  const _MediaStrip({required this.items, required this.onAdd, required this.onRemove});

  @override
  State<_MediaStrip> createState() => _MediaStripState();
}

class _MediaStripState extends State<_MediaStrip> {
  double? _aspectRatio; // pehle (primary) item ki clamped aspect ratio

  @override
  void initState() {
    super.initState();
    _resolveAspectRatio();
  }

  @override
  void didUpdateWidget(_MediaStrip old) {
    super.didUpdateWidget(old);
    final oldFirst = old.items.isNotEmpty ? old.items.first.path : null;
    final newFirst = widget.items.isNotEmpty ? widget.items.first.path : null;
    if (oldFirst != newFirst) {
      setState(() => _aspectRatio = null);
      _resolveAspectRatio();
    }
  }

  Future<void> _resolveAspectRatio() async {
    if (widget.items.isEmpty || !widget.items.first.isImage) return;
    final file = File(widget.items.first.path);
    if (!file.existsSync()) return;

    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      frame.image.dispose();
      if (mounted && w > 0 && h > 0) {
        setState(() => _aspectRatio = clampFeedAspectRatio(w / h));
      }
    } catch (_) {
      if (mounted) setState(() => _aspectRatio = kFeedFallbackAspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Empty state
    if (widget.items.isEmpty) {
      return GestureDetector(
        onTap: widget.onAdd,
        child: Container(
          height: 220, width: double.infinity, color: _C.surfaceEl,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: _C.divider, shape: BoxShape.circle),
              child: const Icon(Icons.add_photo_alternate_outlined, color: _C.textSec, size: 30),
            ),
            const SizedBox(height: 12),
            const Text('Add photo or video',
                style: TextStyle(color: _C.textSec, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            const Text('Tap to select from gallery',
                style: TextStyle(color: _C.textTer, fontSize: 12)),
          ]),
        ),
      );
    }

    // Video ka apna native ratio he, image ka decoded/clamped ratio —
    // jab tak pata na chale tab tak neutral fallback dikhao.
    final ratio = widget.items.first.isImage
        ? (_aspectRatio ?? kFeedFallbackAspectRatio)
        : kFeedFallbackAspectRatio;

    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(children: [
        PageView.builder(
          itemCount: widget.items.length,
          itemBuilder: (_, i) {
            final m = widget.items[i];
            return Stack(children: [
              m.isImage
                  ? ClipRect(
                child: Image.file(
                  File(m.path),
                  width: double.infinity,
                  height: double.infinity,
                  // ✅ cover — box already asli/clamped ratio ka he, isliye
                  // pehli image ke liye exact fit, baaki carousel items ke
                  // liye center-crop (Instagram jaisa hi)
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                color: _C.surfaceEl,
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.insert_drive_file_outlined, color: _C.textSec, size: 48),
                  const SizedBox(height: 8),
                  Text(m.path.split('/').last,
                      style: const TextStyle(color: _C.textSec, fontSize: 12)),
                ])),
              ),

              // Remove button
              Positioned(
                top: 12, right: 12,
                child: GestureDetector(
                  onTap: () => widget.onRemove(i),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65), shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ]);
          },
        ),

        // Dot indicators
        if (widget.items.length > 1)
          Positioned(
            bottom: 12, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6, height: 6,
                decoration: const BoxDecoration(color: _C.accent, shape: BoxShape.circle),
              )),
            ),
          ),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Remaining widgets — same as before
// ═════════════════════════════════════════════════════════════════════════════

class _CaptionRow extends StatelessWidget {
  final TextEditingController controller;
  const _CaptionRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 38, height: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFf09433),Color(0xFFe6683c),Color(0xFFdc2743),
                Color(0xFFcc2366),Color(0xFFbc1888)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          // child: const Center(child: Text('D', style: TextStyle(
          //     color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
          child: const _UserAvatarContent(size: 38, fontSize: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _C.textPri, fontSize: 15, height: 1.45),
            maxLines: null,
            maxLength: 100,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
            null, // counter hide — sirf hard limit ke liye use ho raha hai
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Write a Title...',
              hintStyle: TextStyle(color: _C.textTer, fontSize: 15),
              border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
              color: _C.surfaceEl, borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _C.divider)),
          child: const Icon(Icons.image_outlined, color: _C.textTer, size: 22),
        ),
      ]),
    );
  }
}

// ─── User avatar content — avatar image ya name ka pehla letter ───────────────
class _UserAvatarContent extends ConsumerWidget {
  final double size;
  final double fontSize;
  const _UserAvatarContent({required this.size, required this.fontSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl    = ref.watch(avatarViewModelProvider).generatedMascotUrl;
    final profileState = ref.watch(profileInfoViewModelProvider);

    final String? name = profileState.profile?.name;
    final initial = (name != null && name.trim().isNotEmpty)
        ? name.trim().substring(0, 1).toUpperCase()
        : 'VA';

    Widget initialWidget() => Center(
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: fontSize,
        ),
      ),
    );

    if (avatarUrl == null || avatarUrl.isEmpty) return initialWidget();

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => initialWidget(),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _CategoryRow({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
        builder: (_) => _CategorySheet(selected: value, items: items,
            onSelect: (v) { onChanged(v); Navigator.pop(context); }),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(children: [
          const Icon(Icons.sell_outlined, color: _C.textSec, size: 20),
          const SizedBox(width: 14),
          const Text('Category', style: TextStyle(color: _C.textPri, fontSize: 15)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _C.tag, borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _C.accent.withOpacity(0.3))),
            child: Text(value, style: const TextStyle(color: _C.accent, fontSize: 12,
                fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, color: _C.textTer, size: 20),
        ]),
      ),
    );
  }
}

class _CategorySheet extends StatelessWidget {
  final String selected;
  final List<String> items;
  final ValueChanged<String> onSelect;
  const _CategorySheet({required this.selected, required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1C1C1C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 36, height: 4,
            decoration: BoxDecoration(color: _C.textTer, borderRadius: BorderRadius.circular(2))),
        const Padding(padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Select Category', style: TextStyle(color: _C.textPri, fontSize: 16,
                fontWeight: FontWeight.w700))),
        const _HairlineDivider(),
        ...items.map((cat) => InkWell(
          onTap: () => onSelect(cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(children: [
              Text(cat, style: TextStyle(
                color: cat == selected ? _C.accent : _C.textPri, fontSize: 15,
                fontWeight: cat == selected ? FontWeight.w600 : FontWeight.w400,
              )),
              const Spacer(),
              if (cat == selected) const Icon(Icons.check_rounded, color: _C.accent, size: 20),
            ]),
          ),
        )),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class _ContentSection extends StatefulWidget {
  final QuillController controller;
  final FocusNode       focusNode;
  final bool            isExpanded;
  final VoidCallback    onToggle;
  const _ContentSection({required this.controller, required this.focusNode,
    required this.isExpanded, required this.onToggle});
  @override State<_ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends State<_ContentSection> {
  bool _showToolbar = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: widget.onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(children: [
            const Icon(Icons.edit_note_rounded, color: _C.textSec, size: 22),
            const SizedBox(width: 14),
            const Text('Post Content', style: TextStyle(color: _C.textPri, fontSize: 15)),
            const Spacer(),
            _WordCountBadge(controller: widget.controller),
            const SizedBox(width: 8),
            Icon(widget.isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
                color: _C.textTer, size: 20),
          ]),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        child: widget.isExpanded
            ? Column(children: [
          const _HairlineDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              const Text('Formatting',
                  style: TextStyle(color: _C.textTer, fontSize: 12, letterSpacing: 0.4)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showToolbar = !_showToolbar),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _C.surfaceEl,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _C.divider)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.text_format,
                        color: _showToolbar ? _C.accent : _C.textSec, size: 16),
                    const SizedBox(width: 4),
                    Text(_showToolbar ? 'Hide tools' : 'Show tools',
                        style: TextStyle(
                            color: _showToolbar ? _C.accent : _C.textSec, fontSize: 12)),
                  ]),
                ),
              ),
            ]),
          ),
          if (_showToolbar)
            Container(
              color: const Color(0xFF111111),
              child: QuillSimpleToolbar(
                controller: widget.controller,
                config: QuillSimpleToolbarConfig(
                  showBoldButton: true, showItalicButton: true,
                  showUnderLineButton: true, showStrikeThrough: true,
                  showColorButton: true, showBackgroundColorButton: false,
                  showClearFormat: true, showAlignmentButtons: true,
                  showLeftAlignment: true, showCenterAlignment: true,
                  showRightAlignment: true, showJustifyAlignment: false,
                  showHeaderStyle: true, showListNumbers: true,
                  showListBullets: true, showListCheck: false,
                  showCodeBlock: true, showQuote: true, showIndent: false,
                  showLink: true, showSearchButton: false,
                  showSubscript: false, showSuperscript: false,
                  showSmallButton: false, showDividers: true,
                  showFontFamily: false, showFontSize: false,
                  showInlineCode: true, showDirection: false,
                  showUndo: true, showRedo: true,
                  toolbarIconAlignment: WrapAlignment.start,
                  decoration: const BoxDecoration(color: Color(0xFF111111)),
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    base: QuillToolbarBaseButtonOptions(
                      iconTheme: QuillIconTheme(
                        iconButtonSelectedData: IconButtonData(
                          style: IconButton.styleFrom(
                            backgroundColor: _C.accent.withOpacity(0.15),
                            foregroundColor: _C.accent,
                          ),
                        ),
                        iconButtonUnselectedData: IconButtonData(
                          style: IconButton.styleFrom(foregroundColor: _C.textSec),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: QuillEditor(
              controller: widget.controller,
              focusNode: widget.focusNode,
              scrollController: ScrollController(),
              config: QuillEditorConfig(
                minHeight: 160, maxHeight: 360, scrollable: true,
                autoFocus: false, expands: false, padding: EdgeInsets.zero,
                placeholder: 'Write something about your post...',
                customStyles: DefaultStyles(
                  placeHolder: DefaultTextBlockStyle(
                      const TextStyle(color: _C.textTer, fontSize: 15),
                      HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
                  paragraph: DefaultTextBlockStyle(
                      const TextStyle(color: _C.textPri, fontSize: 15, height: 1.6),
                      HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
                  bold: const TextStyle(color: _C.textPri, fontWeight: FontWeight.w700),
                  italic: const TextStyle(color: _C.textPri, fontStyle: FontStyle.italic),
                  h1: DefaultTextBlockStyle(
                      const TextStyle(color: _C.textPri, fontSize: 24, fontWeight: FontWeight.w800),
                      HorizontalSpacing.zero, const VerticalSpacing(8, 0), VerticalSpacing.zero, null),
                  h2: DefaultTextBlockStyle(
                      const TextStyle(color: _C.textPri, fontSize: 20, fontWeight: FontWeight.w700),
                      HorizontalSpacing.zero, const VerticalSpacing(6, 0), VerticalSpacing.zero, null),
                  quote: DefaultTextBlockStyle(
                      const TextStyle(color: _C.textSec, fontSize: 15, fontStyle: FontStyle.italic),
                      HorizontalSpacing.zero, const VerticalSpacing(6, 6), VerticalSpacing.zero,
                      const BoxDecoration(border: Border(left: BorderSide(color: _C.accent, width: 3)))),
                  code: DefaultTextBlockStyle(
                      const TextStyle(color: Color(0xFF9EFBB0), fontSize: 13, fontFamily: 'monospace'),
                      HorizontalSpacing.zero, const VerticalSpacing(4, 4), VerticalSpacing.zero,
                      BoxDecoration(color: const Color(0xFF0A0A0A), borderRadius: BorderRadius.circular(6))),
                ),
              ),
            ),
          ),
        ])
            : const SizedBox.shrink(),
      ),
      const _HairlineDivider(),
    ]);
  }
}

class _ShareBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const _ShareBtn({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, left: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: onTap == null ? _C.accent.withOpacity(0.4) : _C.accent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Share', style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.2)),
      ),
    );
  }
}

class _IgIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IgIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(padding: const EdgeInsets.all(10),
        child: Icon(icon, color: _C.textPri, size: 24)),
  );
}

class _HairlineDivider extends StatelessWidget {
  const _HairlineDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 0.5, color: _C.divider);
}

class _WordCountBadge extends StatefulWidget {
  final QuillController controller;
  const _WordCountBadge({required this.controller});
  @override State<_WordCountBadge> createState() => _WordCountBadgeState();
}

class _WordCountBadgeState extends State<_WordCountBadge> {
  int _words = 0;
  @override
  void initState() { super.initState(); widget.controller.addListener(_update); }
  void _update() {
    final text = widget.controller.document.toPlainText().trim();
    final w    = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    if (w != _words) setState(() => _words = w);
  }
  @override
  void dispose() { widget.controller.removeListener(_update); super.dispose(); }
  @override
  Widget build(BuildContext context) => _words == 0 ? const SizedBox.shrink()
      : Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: _C.surfaceEl, borderRadius: BorderRadius.circular(10)),
    child: Text('$_words w', style: const TextStyle(color: _C.textTer, fontSize: 11)),
  );
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();
  @override State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(14)),
      child: const Column(mainAxisSize: MainAxisSize.min, children: [
        CupertinoActivityIndicator(color: _C.accent, radius: 14),
        SizedBox(height: 10),
        Text('Sharing your post...', style: TextStyle(color: _C.textSec, fontSize: 13)),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  PREVIEW SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class PreviewScreen extends ConsumerWidget {
  final String title, category;
  final QuillController quillCtrl;
  final List<MediaItem> media;
  const PreviewScreen({super.key, required this.title, required this.category,
    required this.quillCtrl, required this.media});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(profileInfoViewModelProvider).profile?.name ?? 'You';
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(padding: EdgeInsets.all(10),
                  child: Icon(Icons.arrow_back_ios_new_rounded, color: _C.textPri, size: 20)),
            ),
            const Spacer(),
            const Text('Preview', style: TextStyle(color: _C.textPri, fontSize: 16,
                fontWeight: FontWeight.w700, letterSpacing: -0.3)),
            const Spacer(),
            const SizedBox(width: 44),
          ]),
        ),
        const _HairlineDivider(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(children: [
                  // Container(
                  //   width: 36, height: 36,
                  //   decoration: BoxDecoration(shape: BoxShape.circle,
                  //       border: Border.all(color: _C.accentSec, width: 2)),
                  //   child: const CircleAvatar(backgroundColor: _C.surfaceEl,
                  //       child: Text('D', style: TextStyle(color: _C.textPri,
                  //           fontWeight: FontWeight.w800, fontSize: 15))),
                  // ),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.surfaceEl,
                      border: Border.all(color: _C.accentSec, width: 2),
                    ),
                    child: const _UserAvatarContent(size: 32, fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('divyanshu', style: TextStyle(color: _C.textPri,
                        fontWeight: FontWeight.w600, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: _C.tag, borderRadius: BorderRadius.circular(4)),
                      child: Text(category, style: const TextStyle(color: _C.accent, fontSize: 10,
                          fontWeight: FontWeight.w600)),
                    ),
                  ]),
                  const Spacer(),
                  const Icon(Icons.more_horiz, color: _C.textSec, size: 22),
                ]),
              ),
              // ✅ CHANGED — dynamic clamped ratio, feed jaisa hi (WYSIWYG)
              if (media.isNotEmpty && media.first.isImage)
                _DynamicRatioImage(file: File(media.first.path)),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: Row(children: [
                  const Icon(Icons.favorite_border_rounded, color: _C.textPri, size: 26),
                  const SizedBox(width: 14),
                  const Icon(Icons.chat_bubble_outline_rounded, color: _C.textPri, size: 24),
                  const SizedBox(width: 14),
                  const Icon(Icons.near_me_outlined, color: _C.textPri, size: 24),
                  const Spacer(),
                  const Icon(Icons.bookmark_border_rounded, color: _C.textPri, size: 24),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Text('0 likes', style: TextStyle(color: _C.textPri,
                    fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                  child: RichText(text: TextSpan(children: [
                    const TextSpan(text: 'divyanshu  ',
                        style: TextStyle(color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 14)),
                    TextSpan(text: title,
                        style: const TextStyle(color: _C.textPri, fontSize: 14, height: 1.4)),
                  ])),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: Builder(builder: (context) {
                  quillCtrl.readOnly = true;
                  return QuillEditor(
                    controller: quillCtrl, focusNode: FocusNode(),
                    scrollController: ScrollController(),
                    config: QuillEditorConfig(
                      scrollable: false, autoFocus: false, expands: false, padding: EdgeInsets.zero,
                      customStyles: DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                            const TextStyle(color: _C.textSec, fontSize: 14, height: 1.6),
                            HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
                      ),
                    ),
                  );
                }),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 4, 14, 20),
                child: Text('Just now', style: TextStyle(color: _C.textTer, fontSize: 11,
                    letterSpacing: 0.2)),
              ),
            ]),
          ),
        ),
      ])),
    );
  }
}

// ─── Small helper — local file ka dynamic (clamped) aspect ratio + cover ──────
class _DynamicRatioImage extends StatefulWidget {
  final File file;
  const _DynamicRatioImage({required this.file});
  @override State<_DynamicRatioImage> createState() => _DynamicRatioImageState();
}

class _DynamicRatioImageState extends State<_DynamicRatioImage> {
  double? _ratio;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    try {
      final bytes = await widget.file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      frame.image.dispose();
      if (mounted && w > 0 && h > 0) {
        setState(() => _ratio = clampFeedAspectRatio(w / h));
      }
    } catch (_) {
      if (mounted) setState(() => _ratio = kFeedFallbackAspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _ratio ?? kFeedFallbackAspectRatio,
      child: ClipRect(
        child: Image.file(
          widget.file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}























// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:vervee_app/domain/model/post/CreatePost.dart';
// import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
//
// import '../../utils/NetworkResult.dart';
// import '../viewmodal/post/CreatePostViewmodel.dart';
//
// // ─── Colors ───────────────────────────────────────────────────────────────────
// abstract class _C {
//   static const bg        = Color(0xFF000000);
//   static const surface   = Color(0xFF121212);
//   static const surfaceEl = Color(0xFF1C1C1C);
//   static const divider   = Color(0xFF262626);
//   static const accent    = Color(0xFF0095F6);
//   static const accentSec = Color(0xFFFF006E);
//   static const textPri   = Color(0xFFFFFFFF);
//   static const textSec   = Color(0xFFA8A8A8);
//   static const textTer   = Color(0xFF555555);
//   static const green     = Color(0xFF00D084);
//   static const tag       = Color(0xFF1A2332);
// }
//
// // ─── MediaItem ────────────────────────────────────────────────────────────────
// // isCropped = true means file is already a pixel-cropped PNG from GalleryPicker
// class MediaItem {
//   final String path;
//   final bool   isImage;
//   final bool   isCropped; // ← NEW: gallery se aaya cropped file
//   MediaItem({required this.path, required this.isImage, this.isCropped = false});
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  CREATE POST SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class CreatePostScreen extends ConsumerStatefulWidget {
//   final List<MediaItem>? initialMedia;
//   const CreatePostScreen({super.key, this.initialMedia});
//
//   @override
//   ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
// }
//
// class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
//     with SingleTickerProviderStateMixin {
//   final _titleCtrl   = TextEditingController();
//   final _quillCtrl   = QuillController.basic();
//   final _editorFocus = FocusNode();
//   final _scrollCtrl  = ScrollController();
//
//   String _category = 'Oil Market';
//   final List<String> _categories = [
//     //'Forex & Currency', 'Crypto', 'Stocks', 'Commodities', 'Economy', 'Other',
//     'Oil Market',
//     'Gold & Commodities',
//     'Forex & Currency',
//     'Geopolitics',
//     'Economic Policy',
//     'Market Volatility',
//    // 'Other',
//   ];
//
//   final List<MediaItem> _media = [];
//   bool _isExpanded = true;
//
//   late AnimationController _fabAnim;
//   late Animation<double>   _fabScale;
//
//   @override
//   void initState() {
//     super.initState();
//     // Gallery se aaye cropped images — directly add karo, re-process mat karo
//     if (widget.initialMedia != null && widget.initialMedia!.isNotEmpty) {
//       _media.addAll(widget.initialMedia!);
//     }
//     _fabAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//     _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOutBack);
//     Future.delayed(const Duration(milliseconds: 300), () => _fabAnim.forward());
//   }
//
//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _quillCtrl.dispose();
//     _editorFocus.dispose();
//     _scrollCtrl.dispose();
//     _fabAnim.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final x = await ImagePicker().pickImage(
//       source: ImageSource.gallery, imageQuality: 85,
//       maxWidth: 1920, maxHeight: 1920,
//     );
//     if (x != null) {
//       final sizeMB = await File(x.path).length() / (1024 * 1024);
//       if (sizeMB > 5) {
//         if (mounted) _snack('Image too large. Please select an image under 5MB.', isError: true);
//         return;
//       }
//       setState(() => _media.add(MediaItem(path: x.path, isImage: true)));
//     }
//   }
//
//   Future<void> _pickFile() async {
//     final r = await FilePicker.platform.pickFiles();
//     if (r?.files.single.path != null) {
//       final p      = r!.files.single.path!;
//       final sizeMB = await File(p).length() / (1024 * 1024);
//       if (sizeMB > 5) {
//         if (mounted) _snack('File too large. Please select a file under 5MB.', isError: true);
//         return;
//       }
//       final isImg = ['.jpg','.jpeg','.png','.gif','.webp']
//           .any((e) => p.toLowerCase().endsWith(e));
//       setState(() => _media.add(MediaItem(path: p, isImage: isImg)));
//     }
//   }
//
//   Future<void> _publish() async {
//     // final title = _titleCtrl.text.trim();
//     // if (title.isEmpty) { _snack('Add a Title to your post', isError: true); return; }
//
//     final title = _titleCtrl.text.trim();
//
//     if (title.isEmpty) {
//       _snack('Add a Title to your post', isError: true);
//       return;
//     }
//     if (title.length < 3) {
//       _snack('Title must be at least 3 characters', isError: true);
//       return;
//     }
//     if (title.length > 100) {
//       _snack('Title can be at most 100 characters', isError: true);
//       return;
//     }
//
//     final plain = _quillCtrl.document.toPlainText().trim();
//     if (plain.isEmpty || plain == '\n') {
//       _snack('Write something in your post content', isError: true); return;
//     }
//
//     if (_media.isNotEmpty) {
//       final sizeMB = await File(_media.first.path).length() / (1024 * 1024);
//       if (sizeMB > 100) {
//         _snack('Image too large (${sizeMB.toStringAsFixed(1)}MB). Max 5MB.', isError: true);
//         return;
//       }
//     }
//
//     HapticFeedback.mediumImpact();
//
//     final deltaJson = _quillCtrl.document.toDelta().toJson();
//     final html      = QuillDeltaToHtmlConverter(
//       List.castFrom(deltaJson), ConverterOptions(),
//     ).convert();
//
//     await ref.read(createPostViewModelProvider.notifier).createPost(
//       title: title, content: html, category: _category,
//       file: _media.isNotEmpty ? File(_media.first.path) : null,
//     );
//   }
//
//   // Future<void> _publish() async {
//   //   final title = _titleCtrl.text.trim();
//   //
//   //   if (title.isEmpty) {
//   //     _snack('Add a Title to your post', isError: true);
//   //     return;
//   //   }
//   //   if (title.length < 3) {
//   //     _snack('Title must be at least 3 characters', isError: true);
//   //     return;
//   //   }
//   //   if (title.length > 100) {
//   //     _snack('Title can be at most 100 characters', isError: true);
//   //     return;
//   //   }
//   //
//   //   // ❌ Yeh block hata do — content ab optional hai
//   //   // final plain = _quillCtrl.document.toPlainText().trim();
//   //   // if (plain.isEmpty || plain == '\n') {
//   //   //   _snack('Write something in your post content', isError: true); return;
//   //   // }
//   //
//   //   if (_media.isNotEmpty) {
//   //     final sizeMB = await File(_media.first.path).length() / (1024 * 1024);
//   //     if (sizeMB > 100) {
//   //       _snack('Image too large (${sizeMB.toStringAsFixed(1)}MB). Max 5MB.', isError: true);
//   //       return;
//   //     }
//   //   }
//   //
//   //   HapticFeedback.mediumImpact();
//   //
//   //   final plain = _quillCtrl.document.toPlainText().trim();
//   //   final isContentEmpty = plain.isEmpty || plain == '\n';
//   //
//   //   final deltaJson = _quillCtrl.document.toDelta().toJson();
//   //   final html      = QuillDeltaToHtmlConverter(
//   //     List.castFrom(deltaJson), ConverterOptions(),
//   //   ).convert();
//   //
//   //   await ref.read(createPostViewModelProvider.notifier).createPost(
//   //     title: title,
//   //     content: isContentEmpty ? null : html,   // ✅ empty hone par null bhejo
//   //     category: _category,
//   //     file: _media.isNotEmpty ? File(_media.first.path) : null,
//   //   );
//   // }
//
//   void _snack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [
//         Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
//             color: Colors.white, size: 18),
//         const SizedBox(width: 8),
//         Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13))),
//       ]),
//       backgroundColor: isError ? const Color(0xFFE53935) : _C.green,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 3),
//     ));
//   }
//
//   void _preview() => Navigator.push(context, PageRouteBuilder(
//     pageBuilder: (_, anim, __) => FadeTransition(opacity: anim,
//         child: PreviewScreen(title: _titleCtrl.text, category: _category,
//             quillCtrl: _quillCtrl, media: _media)),
//     transitionDuration: const Duration(milliseconds: 250),
//   ));
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (_, next) {
//       next.when(
//         initial: () {},
//         loading: () => ScaffoldMessenger.of(context).clearSnackBars(),
//         success: (post) {
//           HapticFeedback.lightImpact();
//           _snack('✓  "${post.title}" shared!');
//           ref.read(createPostViewModelProvider.notifier).reset();
//           Future.delayed(const Duration(milliseconds: 800), () {
//             //if (mounted) Navigator.maybePop(context);
//             if (mounted) Navigator.pop(context, true); // ✅ true = post hua
//           });
//         },
//         error: (msg, _) => _snack(msg, isError: true),
//       );
//     });
//
//     final isLoading = ref.watch(createPostViewModelProvider) is Loading<CreatePost>;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.bg,
//         body: Stack(children: [
//           SafeArea(
//             child: Column(children: [
//               _buildTopBar(isLoading),
//               const _HairlineDivider(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: _scrollCtrl,
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     // ── Media strip — cropped image exactly as adjusted ──────
//                     _MediaStrip(
//                       items: _media,
//                       onAdd: _pickImage,
//                       onRemove: (i) => setState(() => _media.removeAt(i)),
//                     ),
//                     // _CaptionRow(controller: _titleCtrl),
//                     // const _HairlineDivider(),
//                     // _CategoryRow(
//                     //   value: _category, items: _categories,
//                     //   onChanged: (v) => setState(() => _category = v),
//                     // ),
//                     // const _HairlineDivider(),
//                     _CaptionRow(controller: _titleCtrl),
//                     const _HairlineDivider(),
//                     if (_media.isEmpty || !_media.first.isImage) ...[
//                       _CategoryRow(
//                         value: _category, items: _categories,
//                         onChanged: (v) => setState(() => _category = v),
//                       ),
//                       const _HairlineDivider(),
//                     ],
//                    // _AttachRow(onFile: _pickFile, onImage: _pickImage),
//                     const _HairlineDivider(),
//                     _ContentSection(
//                       controller: _quillCtrl, focusNode: _editorFocus,
//                       isExpanded: _isExpanded,
//                       onToggle: () => setState(() => _isExpanded = !_isExpanded),
//                     ),
//                     const SizedBox(height: 100),
//                   ]),
//                 ),
//               ),
//             ]),
//           ),
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.6),
//               child: const Center(child: _LoadingDots()),
//             ),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildTopBar(bool isLoading) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Row(children: [
//         _IgIconBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)), //Navigator.maybePop(context)),
//         const Spacer(),
//         const Text('New post', style: TextStyle(
//             color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
//         const Spacer(),
//         _IgIconBtn(icon: Icons.remove_red_eye_outlined, onTap: _preview),
//         ScaleTransition(
//           scale: _fabScale,
//           child: _ShareBtn(onTap: isLoading ? null : _publish),
//         ),
//       ]),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  MEDIA STRIP
// //  • Gallery se aaya cropped image: BoxFit.cover (exact crop preserve)
// //  • Manually picked image: BoxFit.cover normal
// // ═════════════════════════════════════════════════════════════════════════════
// // ═════════════════════════════════════════════════════════════════════════════
// //  MEDIA STRIP  — dynamic height based on actual image aspect ratio
// // ═════════════════════════════════════════════════════════════════════════════
// class _MediaStrip extends StatefulWidget {
//   final List<MediaItem> items;
//   final VoidCallback    onAdd;
//   final ValueChanged<int> onRemove;
//
//   const _MediaStrip({required this.items, required this.onAdd, required this.onRemove});
//
//   @override
//   State<_MediaStrip> createState() => _MediaStripState();
// }
//
// class _MediaStripState extends State<_MediaStrip> {
//   // Pehli image ki actual size — isi se height calculate hogi
//   Size _imageSize = Size.zero;
//   bool _sizeLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadImageSize();
//   }
//
//   @override
//   void didUpdateWidget(_MediaStrip old) {
//     super.didUpdateWidget(old);
//     // Jab naya image aaye (gallery se ya manually add) — size reload karo
//     final oldFirst = old.items.isNotEmpty ? old.items.first.path : null;
//     final newFirst = widget.items.isNotEmpty ? widget.items.first.path : null;
//     if (oldFirst != newFirst) {
//       setState(() { _imageSize = Size.zero; _sizeLoaded = false; });
//       _loadImageSize();
//     }
//   }
//
//   Future<void> _loadImageSize() async {
//     if (widget.items.isEmpty || !widget.items.first.isImage) return;
//
//     final file = File(widget.items.first.path);
//     if (!file.existsSync()) return;
//
//     // Image dimensions read karo using flutter's image decoding
//     final bytes = await file.readAsBytes();
//     final codec = await ui.instantiateImageCodec(bytes);
//     final frame = await codec.getNextFrame();
//     final w = frame.image.width.toDouble();
//     final h = frame.image.height.toDouble();
//     frame.image.dispose();
//
//     if (mounted) {
//       setState(() {
//         _imageSize  = Size(w, h);
//         _sizeLoaded = true;
//       });
//     }
//   }
//
//   // Actual display height calculate karo — GalleryPickerScreen jaisi logic
//   double _calcHeight(double screenW) {
//     if (_imageSize == Size.zero) return 280; // fallback jab tak load na ho
//     final naturalH = screenW * _imageSize.height / _imageSize.width;
//     // Max height cap — bahut tall images screen bharr na le
//     return naturalH.clamp(180.0, screenW * 1.35);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Empty state
//     if (widget.items.isEmpty) {
//       return GestureDetector(
//         onTap: widget.onAdd,
//         child: Container(
//           height: 220, width: double.infinity, color: _C.surfaceEl,
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Container(
//               width: 64, height: 64,
//               decoration: BoxDecoration(color: _C.divider, shape: BoxShape.circle),
//               child: const Icon(Icons.add_photo_alternate_outlined, color: _C.textSec, size: 30),
//             ),
//             const SizedBox(height: 12),
//             const Text('Add photo or video',
//                 style: TextStyle(color: _C.textSec, fontSize: 14, fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             const Text('Tap to select from gallery',
//                 style: TextStyle(color: _C.textTer, fontSize: 12)),
//           ]),
//         ),
//       );
//     }
//
//     final screenW = MediaQuery.of(context).size.width;
//     final stripH  = _calcHeight(screenW);
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOut,
//       // ✅ Dynamic height — image ki actual aspect ratio se
//       height: stripH,
//       child: Stack(children: [
//         PageView.builder(
//           itemCount: widget.items.length,
//           itemBuilder: (_, i) {
//             final m = widget.items[i];
//             return Stack(children: [
//               m.isImage
//                   ? SizedBox(
//                 width: double.infinity,
//                 height: stripH,
//                 // ✅ BoxFit.fill — exactly wahi dikhao jo crop ke baad hai
//                 // cover nahi kyunki wo phir se crop karega
//                 child: Image.file(
//                   File(m.path),
//                   fit: BoxFit.fill, // ← KEY CHANGE: exact pixels, no re-cropping
//                 ),
//               )
//                   : Container(
//                 color: _C.surfaceEl,
//                 child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   const Icon(Icons.insert_drive_file_outlined, color: _C.textSec, size: 48),
//                   const SizedBox(height: 8),
//                   Text(m.path.split('/').last,
//                       style: const TextStyle(color: _C.textSec, fontSize: 12)),
//                 ])),
//               ),
//
//               // Remove button
//               Positioned(
//                 top: 12, right: 12,
//                 child: GestureDetector(
//                   onTap: () => widget.onRemove(i),
//                   child: Container(
//                     width: 30, height: 30,
//                     decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.65), shape: BoxShape.circle),
//                     child: const Icon(Icons.close, color: Colors.white, size: 16),
//                   ),
//                 ),
//               ),
//             ]);
//           },
//         ),
//
//         // Add more button
//         // Positioned(
//         //   bottom: 12, right: 12,
//         //   child: GestureDetector(
//         //     onTap: widget.onAdd,
//         //     child: Container(
//         //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//         //       decoration: BoxDecoration(
//         //         color: Colors.black.withOpacity(0.6),
//         //         borderRadius: BorderRadius.circular(20),
//         //         border: Border.all(color: Colors.white24),
//         //       ),
//         //       child: const Row(mainAxisSize: MainAxisSize.min, children: [
//         //         Icon(Icons.add_rounded, color: Colors.white, size: 16),
//         //         SizedBox(width: 4),
//         //         Text('Add more', style: TextStyle(color: Colors.white, fontSize: 12,
//         //             fontWeight: FontWeight.w500)),
//         //       ]),
//         //     ),
//         //   ),
//         // ),
//
//         // Dot indicators
//         if (widget.items.length > 1)
//           Positioned(
//             bottom: 12, left: 0, right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(widget.items.length, (i) => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 width: 6, height: 6,
//                 decoration: const BoxDecoration(color: _C.accent, shape: BoxShape.circle),
//               )),
//             ),
//           ),
//       ]),
//     );
//   }
// }
//
//
// // class _MediaStrip extends StatelessWidget {
// //   final List<MediaItem> items;
// //   final VoidCallback    onAdd;
// //   final ValueChanged<int> onRemove;
// //
// //   const _MediaStrip({required this.items, required this.onAdd, required this.onRemove});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (items.isEmpty) {
// //       return GestureDetector(
// //         onTap: onAdd,
// //         child: Container(
// //           height: 220, width: double.infinity, color: _C.surfaceEl,
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             Container(
// //               width: 64, height: 64,
// //               decoration: BoxDecoration(color: _C.divider, shape: BoxShape.circle),
// //               child: const Icon(Icons.add_photo_alternate_outlined, color: _C.textSec, size: 30),
// //             ),
// //             const SizedBox(height: 12),
// //             const Text('Add photo or video',
// //                 style: TextStyle(color: _C.textSec, fontSize: 14, fontWeight: FontWeight.w500)),
// //             const SizedBox(height: 4),
// //             const Text('Tap to select from gallery',
// //                 style: TextStyle(color: _C.textTer, fontSize: 12)),
// //           ]),
// //         ),
// //       );
// //     }
// //
// //     // Height: match the cropped image's aspect ratio for the first image
// //     // so it looks exactly like what user adjusted
// //     return SizedBox(
// //       height: 280,
// //       child: Stack(children: [
// //         PageView.builder(
// //           itemCount: items.length,
// //           itemBuilder: (_, i) {
// //             final m = items[i];
// //             return Stack(children: [
// //               // ✅ Cropped image — BoxFit.cover preserves exact crop
// //               m.isImage
// //                   ? Image.file(File(m.path),
// //                   width: double.infinity, height: 280,
// //                   fit: BoxFit.cover) // crop already applied in pixels
// //                   : Container(
// //                 color: _C.surfaceEl,
// //                 child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
// //                   const Icon(Icons.insert_drive_file_outlined, color: _C.textSec, size: 48),
// //                   const SizedBox(height: 8),
// //                   Text(m.path.split('/').last,
// //                       style: const TextStyle(color: _C.textSec, fontSize: 12)),
// //                 ])),
// //               ),
// //               // Remove button
// //               Positioned(
// //                 top: 12, right: 12,
// //                 child: GestureDetector(
// //                   onTap: () => onRemove(i),
// //                   child: Container(
// //                     width: 30, height: 30,
// //                     decoration: BoxDecoration(
// //                         color: Colors.black.withOpacity(0.65), shape: BoxShape.circle),
// //                     child: const Icon(Icons.close, color: Colors.white, size: 16),
// //                   ),
// //                 ),
// //               ),
// //             ]);
// //           },
// //         ),
// //         // Add more
// //         Positioned(
// //           bottom: 12, right: 12,
// //           child: GestureDetector(
// //             onTap: onAdd,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
// //               decoration: BoxDecoration(
// //                 color: Colors.black.withOpacity(0.6),
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: Colors.white24),
// //               ),
// //               child: const Row(mainAxisSize: MainAxisSize.min, children: [
// //                 Icon(Icons.add_rounded, color: Colors.white, size: 16),
// //                 SizedBox(width: 4),
// //                 Text('Add more', style: TextStyle(color: Colors.white, fontSize: 12,
// //                     fontWeight: FontWeight.w500)),
// //               ]),
// //             ),
// //           ),
// //         ),
// //         // Dot indicators
// //         if (items.length > 1)
// //           Positioned(
// //             bottom: 12, left: 0, right: 0,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: List.generate(items.length, (i) => Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 2),
// //                 width: 6, height: 6,
// //                 decoration: const BoxDecoration(color: _C.accent, shape: BoxShape.circle),
// //               )),
// //             ),
// //           ),
// //       ]),
// //     );
// //   }
// // }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  Remaining widgets — same as before
// // ═════════════════════════════════════════════════════════════════════════════
//
// class _CaptionRow extends StatelessWidget {
//   final TextEditingController controller;
//   const _CaptionRow({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//           width: 38, height: 38,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: [Color(0xFFf09433),Color(0xFFe6683c),Color(0xFFdc2743),
//                 Color(0xFFcc2366),Color(0xFFbc1888)],
//               begin: Alignment.topLeft, end: Alignment.bottomRight,
//             ),
//           ),
//           child: const Center(child: Text('D', style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
//         ),
//         const SizedBox(width: 12),
//         // Expanded(
//         //   child: TextField(
//         //     controller: controller,
//         //     style: const TextStyle(color: _C.textPri, fontSize: 15, height: 1.45),
//         //     maxLines: null,
//         //     textInputAction: TextInputAction.newline,
//         //     decoration: const InputDecoration(
//         //       hintText: 'Write a caption...',
//         //       hintStyle: TextStyle(color: _C.textTer, fontSize: 15),
//         //       border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true,
//         //     ),
//         //   ),
//         // ),
//         Expanded(
//           child: TextField(
//             controller: controller,
//             style: const TextStyle(color: _C.textPri, fontSize: 15, height: 1.45),
//             maxLines: null,
//             maxLength: 100,
//             buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
//             null, // counter hide — sirf hard limit ke liye use ho raha hai
//             textInputAction: TextInputAction.newline,
//             decoration: const InputDecoration(
//               hintText: 'Write a Title...',
//               hintStyle: TextStyle(color: _C.textTer, fontSize: 15),
//               border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           width: 46, height: 46,
//           decoration: BoxDecoration(
//               color: _C.surfaceEl, borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: _C.divider)),
//           child: const Icon(Icons.image_outlined, color: _C.textTer, size: 22),
//         ),
//       ]),
//     );
//   }
// }
//
// class _CategoryRow extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String> onChanged;
//   const _CategoryRow({required this.value, required this.items, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => showModalBottomSheet(
//         context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
//         builder: (_) => _CategorySheet(selected: value, items: items,
//             onSelect: (v) { onChanged(v); Navigator.pop(context); }),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//         child: Row(children: [
//           const Icon(Icons.sell_outlined, color: _C.textSec, size: 20),
//           const SizedBox(width: 14),
//           const Text('Category', style: TextStyle(color: _C.textPri, fontSize: 15)),
//           const Spacer(),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(color: _C.tag, borderRadius: BorderRadius.circular(6),
//                 border: Border.all(color: _C.accent.withOpacity(0.3))),
//             child: Text(value, style: const TextStyle(color: _C.accent, fontSize: 12,
//                 fontWeight: FontWeight.w600)),
//           ),
//           const SizedBox(width: 6),
//           const Icon(Icons.chevron_right_rounded, color: _C.textTer, size: 20),
//         ]),
//       ),
//     );
//   }
// }
//
// class _CategorySheet extends StatelessWidget {
//   final String selected;
//   final List<String> items;
//   final ValueChanged<String> onSelect;
//   const _CategorySheet({required this.selected, required this.items, required this.onSelect});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(color: Color(0xFF1C1C1C),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(margin: const EdgeInsets.only(top: 10, bottom: 6),
//             width: 36, height: 4,
//             decoration: BoxDecoration(color: _C.textTer, borderRadius: BorderRadius.circular(2))),
//         const Padding(padding: EdgeInsets.symmetric(vertical: 12),
//             child: Text('Select Category', style: TextStyle(color: _C.textPri, fontSize: 16,
//                 fontWeight: FontWeight.w700))),
//         const _HairlineDivider(),
//         ...items.map((cat) => InkWell(
//           onTap: () => onSelect(cat),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(children: [
//               Text(cat, style: TextStyle(
//                 color: cat == selected ? _C.accent : _C.textPri, fontSize: 15,
//                 fontWeight: cat == selected ? FontWeight.w600 : FontWeight.w400,
//               )),
//               const Spacer(),
//               if (cat == selected) const Icon(Icons.check_rounded, color: _C.accent, size: 20),
//             ]),
//           ),
//         )),
//         const SizedBox(height: 20),
//       ]),
//     );
//   }
// }
//
// // class _AttachRow extends StatelessWidget {
// //   final VoidCallback onFile, onImage;
// //   const _AttachRow({required this.onFile, required this.onImage});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(children: [
// //         _AttachTile(icon: Icons.photo_library_outlined, label: 'Add Photo', onTap: onImage),
// //         _AttachTile(icon: Icons.attach_file_rounded,    label: 'Attach File', onTap: onFile),
// //       ]),
// //     );
// //   }
// // }
// //
// // class _AttachTile extends StatelessWidget {
// //   final IconData icon;
// //   final String   label;
// //   final VoidCallback onTap;
// //   const _AttachTile({required this.icon, required this.label, required this.onTap});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: InkWell(
// //         onTap: onTap,
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
// //           child: Row(children: [
// //             Icon(icon, color: _C.textSec, size: 20),
// //             const SizedBox(width: 14),
// //             Text(label, style: const TextStyle(color: _C.textPri, fontSize: 15)),
// //           ]),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class _ContentSection extends StatefulWidget {
//   final QuillController controller;
//   final FocusNode       focusNode;
//   final bool            isExpanded;
//   final VoidCallback    onToggle;
//   const _ContentSection({required this.controller, required this.focusNode,
//     required this.isExpanded, required this.onToggle});
//   @override State<_ContentSection> createState() => _ContentSectionState();
// }
//
// class _ContentSectionState extends State<_ContentSection> {
//   bool _showToolbar = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       InkWell(
//         onTap: widget.onToggle,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//           child: Row(children: [
//             const Icon(Icons.edit_note_rounded, color: _C.textSec, size: 22),
//             const SizedBox(width: 14),
//             const Text('Post Content', style: TextStyle(color: _C.textPri, fontSize: 15)),
//             const Spacer(),
//             _WordCountBadge(controller: widget.controller),
//             const SizedBox(width: 8),
//             Icon(widget.isExpanded
//                 ? Icons.keyboard_arrow_up_rounded
//                 : Icons.keyboard_arrow_down_rounded,
//                 color: _C.textTer, size: 20),
//           ]),
//         ),
//       ),
//       AnimatedSize(
//         duration: const Duration(milliseconds: 280),
//         curve: Curves.easeInOut,
//         child: widget.isExpanded
//             ? Column(children: [
//           const _HairlineDivider(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(children: [
//               const Text('Formatting',
//                   style: TextStyle(color: _C.textTer, fontSize: 12, letterSpacing: 0.4)),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () => setState(() => _showToolbar = !_showToolbar),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(color: _C.surfaceEl,
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: _C.divider)),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.text_format,
//                         color: _showToolbar ? _C.accent : _C.textSec, size: 16),
//                     const SizedBox(width: 4),
//                     Text(_showToolbar ? 'Hide tools' : 'Show tools',
//                         style: TextStyle(
//                             color: _showToolbar ? _C.accent : _C.textSec, fontSize: 12)),
//                   ]),
//                 ),
//               ),
//             ]),
//           ),
//           if (_showToolbar)
//             Container(
//               color: const Color(0xFF111111),
//               child: QuillSimpleToolbar(
//                 controller: widget.controller,
//                 config: QuillSimpleToolbarConfig(
//                   showBoldButton: true, showItalicButton: true,
//                   showUnderLineButton: true, showStrikeThrough: true,
//                   showColorButton: true, showBackgroundColorButton: false,
//                   showClearFormat: true, showAlignmentButtons: true,
//                   showLeftAlignment: true, showCenterAlignment: true,
//                   showRightAlignment: true, showJustifyAlignment: false,
//                   showHeaderStyle: true, showListNumbers: true,
//                   showListBullets: true, showListCheck: false,
//                   showCodeBlock: true, showQuote: true, showIndent: false,
//                   showLink: true, showSearchButton: false,
//                   showSubscript: false, showSuperscript: false,
//                   showSmallButton: false, showDividers: true,
//                   showFontFamily: false, showFontSize: false,
//                   showInlineCode: true, showDirection: false,
//                   showUndo: true, showRedo: true,
//                   toolbarIconAlignment: WrapAlignment.start,
//                   decoration: const BoxDecoration(color: Color(0xFF111111)),
//                   buttonOptions: QuillSimpleToolbarButtonOptions(
//                     base: QuillToolbarBaseButtonOptions(
//                       iconTheme: QuillIconTheme(
//                         iconButtonSelectedData: IconButtonData(
//                           style: IconButton.styleFrom(
//                             backgroundColor: _C.accent.withOpacity(0.15),
//                             foregroundColor: _C.accent,
//                           ),
//                         ),
//                         iconButtonUnselectedData: IconButtonData(
//                           style: IconButton.styleFrom(foregroundColor: _C.textSec),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//             child: QuillEditor(
//               controller: widget.controller,
//               focusNode: widget.focusNode,
//               scrollController: ScrollController(),
//               config: QuillEditorConfig(
//                 minHeight: 160, maxHeight: 360, scrollable: true,
//                 autoFocus: false, expands: false, padding: EdgeInsets.zero,
//                 placeholder: 'Write something about your post...',
//                 customStyles: DefaultStyles(
//                   placeHolder: DefaultTextBlockStyle(
//                       const TextStyle(color: _C.textTer, fontSize: 15),
//                       HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
//                   paragraph: DefaultTextBlockStyle(
//                       const TextStyle(color: _C.textPri, fontSize: 15, height: 1.6),
//                       HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
//                   bold: const TextStyle(color: _C.textPri, fontWeight: FontWeight.w700),
//                   italic: const TextStyle(color: _C.textPri, fontStyle: FontStyle.italic),
//                   h1: DefaultTextBlockStyle(
//                       const TextStyle(color: _C.textPri, fontSize: 24, fontWeight: FontWeight.w800),
//                       HorizontalSpacing.zero, const VerticalSpacing(8, 0), VerticalSpacing.zero, null),
//                   h2: DefaultTextBlockStyle(
//                       const TextStyle(color: _C.textPri, fontSize: 20, fontWeight: FontWeight.w700),
//                       HorizontalSpacing.zero, const VerticalSpacing(6, 0), VerticalSpacing.zero, null),
//                   quote: DefaultTextBlockStyle(
//                       const TextStyle(color: _C.textSec, fontSize: 15, fontStyle: FontStyle.italic),
//                       HorizontalSpacing.zero, const VerticalSpacing(6, 6), VerticalSpacing.zero,
//                       const BoxDecoration(border: Border(left: BorderSide(color: _C.accent, width: 3)))),
//                   code: DefaultTextBlockStyle(
//                       const TextStyle(color: Color(0xFF9EFBB0), fontSize: 13, fontFamily: 'monospace'),
//                       HorizontalSpacing.zero, const VerticalSpacing(4, 4), VerticalSpacing.zero,
//                       BoxDecoration(color: const Color(0xFF0A0A0A), borderRadius: BorderRadius.circular(6))),
//                 ),
//               ),
//             ),
//           ),
//         ])
//             : const SizedBox.shrink(),
//       ),
//       const _HairlineDivider(),
//     ]);
//   }
// }
//
// class _ShareBtn extends StatelessWidget {
//   final VoidCallback? onTap;
//   const _ShareBtn({this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(right: 8, left: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//         decoration: BoxDecoration(
//           color: onTap == null ? _C.accent.withOpacity(0.4) : _C.accent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Text('Share', style: TextStyle(color: Colors.white,
//             fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: -0.2)),
//       ),
//     );
//   }
// }
//
// // leading: IconButton(
// // icon: const Icon(Icons.arrow_back_ios_new_rounded,
// // color: kPurpleLight, size: 20),
// // onPressed: () => Navigator.pop(context),
// // ),
//
// class _IgIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _IgIconBtn({required this.icon, required this.onTap});
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Padding(padding: const EdgeInsets.all(10),
//         child: Icon(icon, color: _C.textPri, size: 24)),
//   );
// }
//
// class _HairlineDivider extends StatelessWidget {
//   const _HairlineDivider();
//   @override
//   Widget build(BuildContext context) =>
//       const Divider(height: 1, thickness: 0.5, color: _C.divider);
// }
//
// class _WordCountBadge extends StatefulWidget {
//   final QuillController controller;
//   const _WordCountBadge({required this.controller});
//   @override State<_WordCountBadge> createState() => _WordCountBadgeState();
// }
//
// class _WordCountBadgeState extends State<_WordCountBadge> {
//   int _words = 0;
//   @override
//   void initState() { super.initState(); widget.controller.addListener(_update); }
//   void _update() {
//     final text = widget.controller.document.toPlainText().trim();
//     final w    = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
//     if (w != _words) setState(() => _words = w);
//   }
//   @override
//   void dispose() { widget.controller.removeListener(_update); super.dispose(); }
//   @override
//   Widget build(BuildContext context) => _words == 0 ? const SizedBox.shrink()
//       : Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//     decoration: BoxDecoration(color: _C.surfaceEl, borderRadius: BorderRadius.circular(10)),
//     child: Text('$_words w', style: const TextStyle(color: _C.textTer, fontSize: 11)),
//   );
// }
//
// class _LoadingDots extends StatefulWidget {
//   const _LoadingDots();
//   @override State<_LoadingDots> createState() => _LoadingDotsState();
// }
//
// class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
//   }
//   @override void dispose() { _ctrl.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(14)),
//       child: const Column(mainAxisSize: MainAxisSize.min, children: [
//         CupertinoActivityIndicator(color: _C.accent, radius: 14),
//         SizedBox(height: 10),
//         Text('Sharing your post...', style: TextStyle(color: _C.textSec, fontSize: 13)),
//       ]),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  PREVIEW SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class PreviewScreen extends StatelessWidget {
//   final String title, category;
//   final QuillController quillCtrl;
//   final List<MediaItem> media;
//   const PreviewScreen({super.key, required this.title, required this.category,
//     required this.quillCtrl, required this.media});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: SafeArea(child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//           child: Row(children: [
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: const Padding(padding: EdgeInsets.all(10),
//                   child: Icon(Icons.arrow_back_ios_new_rounded, color: _C.textPri, size: 20)),
//             ),
//             const Spacer(),
//             const Text('Preview', style: TextStyle(color: _C.textPri, fontSize: 16,
//                 fontWeight: FontWeight.w700, letterSpacing: -0.3)),
//             const Spacer(),
//             const SizedBox(width: 44),
//           ]),
//         ),
//         const _HairlineDivider(),
//         Expanded(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
//                 child: Row(children: [
//                   Container(
//                     width: 36, height: 36,
//                     decoration: BoxDecoration(shape: BoxShape.circle,
//                         border: Border.all(color: _C.accentSec, width: 2)),
//                     child: const CircleAvatar(backgroundColor: _C.surfaceEl,
//                         child: Text('D', style: TextStyle(color: _C.textPri,
//                             fontWeight: FontWeight.w800, fontSize: 15))),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     const Text('divyanshu', style: TextStyle(color: _C.textPri,
//                         fontWeight: FontWeight.w600, fontSize: 13)),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                       decoration: BoxDecoration(color: _C.tag, borderRadius: BorderRadius.circular(4)),
//                       child: Text(category, style: const TextStyle(color: _C.accent, fontSize: 10,
//                           fontWeight: FontWeight.w600)),
//                     ),
//                   ]),
//                   const Spacer(),
//                   const Icon(Icons.more_horiz, color: _C.textSec, size: 22),
//                 ]),
//               ),
//               // ✅ Cropped image — exact same crop as gallery picker
//               if (media.isNotEmpty && media.first.isImage)
//                 Image.file(File(media.first.path),
//                     width: double.infinity, fit: BoxFit.cover),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//                 child: Row(children: [
//                   const Icon(Icons.favorite_border_rounded, color: _C.textPri, size: 26),
//                   const SizedBox(width: 14),
//                   const Icon(Icons.chat_bubble_outline_rounded, color: _C.textPri, size: 24),
//                   const SizedBox(width: 14),
//                   const Icon(Icons.near_me_outlined, color: _C.textPri, size: 24),
//                   const Spacer(),
//                   const Icon(Icons.bookmark_border_rounded, color: _C.textPri, size: 24),
//                 ]),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//                 child: Text('0 likes', style: TextStyle(color: _C.textPri,
//                     fontWeight: FontWeight.w700, fontSize: 13)),
//               ),
//               if (title.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
//                   child: RichText(text: TextSpan(children: [
//                     const TextSpan(text: 'divyanshu  ',
//                         style: TextStyle(color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 14)),
//                     TextSpan(text: title,
//                         style: const TextStyle(color: _C.textPri, fontSize: 14, height: 1.4)),
//                   ])),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
//                 child: Builder(builder: (context) {
//                   quillCtrl.readOnly = true;
//                   return QuillEditor(
//                     controller: quillCtrl, focusNode: FocusNode(),
//                     scrollController: ScrollController(),
//                     config: QuillEditorConfig(
//                       scrollable: false, autoFocus: false, expands: false, padding: EdgeInsets.zero,
//                       customStyles: DefaultStyles(
//                         paragraph: DefaultTextBlockStyle(
//                             const TextStyle(color: _C.textSec, fontSize: 14, height: 1.6),
//                             HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(14, 4, 14, 20),
//                 child: Text('Just now', style: TextStyle(color: _C.textTer, fontSize: 11,
//                     letterSpacing: 0.2)),
//               ),
//             ]),
//           ),
//         ),
//       ])),
//     );
//   }
// }









//--------- This for fix image size -------------------------------------------->










// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:vervee_app/domain/model/post/CreatePost.dart';
// import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
//
// import '../../utils/NetworkResult.dart';
// import '../viewmodal/post/CreatePostViewmodel.dart';
// //import '../../utils/network_result.dart';
// //import '../../domain/models/post.dart';
// //import '../viewmodels/create_post_viewmodel.dart';
//
// // ─── Colors (Instagram-inspired dark) ─────────────────────────────────────────
// abstract class _C {
//   static const bg        = Color(0xFF000000);
//   static const surface   = Color(0xFF121212);
//   static const surfaceEl = Color(0xFF1C1C1C);
//   static const divider   = Color(0xFF262626);
//   static const accent    = Color(0xFF0095F6); // Instagram blue
//   static const accentSec = Color(0xFFFF006E); // story pink
//   static const textPri   = Color(0xFFFFFFFF);
//   static const textSec   = Color(0xFFA8A8A8);
//   static const textTer   = Color(0xFF555555);
//   static const green     = Color(0xFF00D084);
//   static const tag       = Color(0xFF1A2332);
// }
//
// // ─── Data model ───────────────────────────────────────────────────────────────
// class MediaItem {
//   final String path;
//   final bool isImage;
//   MediaItem({required this.path, required this.isImage});
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  MAIN SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class CreatePostScreen extends ConsumerStatefulWidget {
//   final List<MediaItem>? initialMedia;         // ← ADD THIS
//   const CreatePostScreen({super.key, this.initialMedia});
//
//   @override
//   ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
// }
//
// class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
//     with SingleTickerProviderStateMixin {
//   final _titleCtrl   = TextEditingController();
//   final _quillCtrl   = QuillController.basic();
//   final _editorFocus = FocusNode();
//   final _scrollCtrl  = ScrollController();
//
//   String _category = 'Forex & Currency';
//   final List<String> _categories = [
//     'Forex & Currency', 'Crypto', 'Stocks', 'Commodities', 'Economy', 'Other',
//   ];
//
//   final List<MediaItem> _media = [];
//   bool _isExpanded = false; // editor expand toggle
//
//   late AnimationController _fabAnim;
//   late Animation<double> _fabScale;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fabAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//   //   _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOutBack);
//   //   Future.delayed(const Duration(milliseconds: 300), () => _fabAnim.forward());
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     // ✅ Gallery se aaye images auto-populate karo MEDIA STRIP mein
//     if (widget.initialMedia != null && widget.initialMedia!.isNotEmpty) {
//       _media.addAll(widget.initialMedia!);
//     }
//     _fabAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//     _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOutBack);
//     Future.delayed(const Duration(milliseconds: 300), () => _fabAnim.forward());
//   }
//
//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _quillCtrl.dispose();
//     _editorFocus.dispose();
//     _scrollCtrl.dispose();
//     _fabAnim.dispose();
//     super.dispose();
//   }
//
//   // Future<void> _pickImage() async {
//   //   final x = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
//   //   if (x != null) setState(() => _media.add(MediaItem(path: x.path, isImage: true)));
//   // }
//
//   Future<void> _pickImage() async {
//     final x = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       // ✅ FIX 1: imageQuality 85 → 60 karo — large images automatically compress hongi
//       imageQuality: 85,
//       // ✅ FIX 2: maxWidth/maxHeight limit karo — 5MB se badi image automatically resize hogi
//       maxWidth: 1920,
//       maxHeight: 1920,
//     );
//     if (x != null) {
//       // ✅ FIX 3: File size check karo — 5MB se badi ho to user ko batao
//       final fileSize = await File(x.path).length();
//       final fileSizeMB = fileSize / (1024 * 1024);
//
//       if (fileSizeMB > 5) {
//         // ✅ imageQuality 60 ke baad bhi 5MB se badi hai — reject karo
//         if (mounted) {
//           _snack('Image too large. Please select an image under 5MB.', isError: true);
//         }
//         return;
//       }
//
//       setState(() => _media.add(MediaItem(path: x.path, isImage: true)));
//     }
//   }
//
//   // Future<void> _pickFile() async {
//   //   final r = await FilePicker.platform.pickFiles();
//   //   if (r?.files.single.path != null) {
//   //     final p = r!.files.single.path!;
//   //     final isImg = ['.jpg', '.jpeg', '.png', '.gif', '.webp']
//   //         .any((e) => p.toLowerCase().endsWith(e));
//   //     setState(() => _media.add(MediaItem(path: p, isImage: isImg)));
//   //   }
//   // }
//
//   Future<void> _pickFile() async {
//     final r = await FilePicker.platform.pickFiles();
//     if (r?.files.single.path != null) {
//       final p = r!.files.single.path!;
//
//       // ✅ FIX: File size check
//       final fileSize = await File(p).length();
//       final fileSizeMB = fileSize / (1024 * 1024);
//
//       if (fileSizeMB > 5) {
//         if (mounted) {
//           _snack('File too large. Please select a file under 5MB.', isError: true);
//         }
//         return;
//       }
//
//       final isImg = ['.jpg', '.jpeg', '.png', '.gif', '.webp']
//           .any((e) => p.toLowerCase().endsWith(e));
//       setState(() => _media.add(MediaItem(path: p, isImage: isImg)));
//     }
//   }
//
//   // Future<void> _publish() async {
//   //   final title = _titleCtrl.text.trim();
//   //   if (title.isEmpty) {
//   //     _snack('Add a caption to your post', isError: true);
//   //     return;
//   //   }
//   //   HapticFeedback.mediumImpact();
//   //   final html = _quillCtrl.document.toHtml();
//   //   final file = _media.isNotEmpty ? File(_media.first.path) : null;
//   //
//   //   await ref.read(createPostViewModelProvider.notifier).createPost(
//   //     title: title,
//   //     content: html,
//   //     category: _category,
//   //     file: file,
//   //   );
//   // }
//
//   // Future<void> _publish() async {
//   //   final title = _titleCtrl.text.trim();
//   //   if (title.isEmpty) {
//   //     _snack('Add a caption to your post', isError: true);
//   //     return;
//   //   }
//   //   HapticFeedback.mediumImpact();
//   //
//   //   // ✅ vsc_quill_delta_to_html se convert karo
//   //   final deltaJson = _quillCtrl.document.toDelta().toJson();
//   //   final converter = QuillDeltaToHtmlConverter(
//   //     List.castFrom(deltaJson),
//   //     ConverterOptions.forEmail(), // inline styles — backend friendly
//   //   );
//   //   final html = converter.convert();
//   //
//   //   final file = _media.isNotEmpty ? File(_media.first.path) : null;
//   //
//   //   await ref.read(createPostViewModelProvider.notifier).createPost(
//   //     title: title,
//   //     content: html,
//   //     category: _category,
//   //     file: file,
//   //   );
//   // }
//
//   Future<void> _publish() async {
//     final title = _titleCtrl.text.trim();
//     if (title.isEmpty) {
//       _snack('Add a caption to your post', isError: true);
//       return;
//     }
//
//     // ✅ FIX 1: Plain text check — editor actually empty hai ya nahi
//     final plainText = _quillCtrl.document.toPlainText().trim();
//     if (plainText.isEmpty || plainText == '\n') {
//       _snack('Write something in your post content', isError: true);
//       return;
//     }
//
//     // ✅ FIX: Publish se pehle ek baar aur size verify karo
//     if (_media.isNotEmpty) {
//       final fileSize = await File(_media.first.path).length();
//       final fileSizeMB = fileSize / (1024 * 1024);
//       if (fileSizeMB > 5) {
//         _snack('Image too large (${fileSizeMB.toStringAsFixed(1)}MB). Max 5MB allowed.', isError: true);
//         return;
//       }
//     }
//
//     HapticFeedback.mediumImpact();
//
//     // ✅ FIX 2: forEmail() hata diya — default ConverterOptions() use karo
//     // forEmail() inline CSS deta tha, backend simple HTML expect karta hai
//     final deltaJson = _quillCtrl.document.toDelta().toJson();
//     final converter = QuillDeltaToHtmlConverter(
//       List.castFrom(deltaJson),
//       ConverterOptions(), // ✅ clean <p>, <strong>, <em> tags — no inline CSS
//     );
//     final html = converter.convert();
//
//     // ✅ FIX 3: Sirf pehli file bhejo — API ek hi file leta hai
//     final file = _media.isNotEmpty ? File(_media.first.path) : null;
//
//     await ref.read(createPostViewModelProvider.notifier).createPost(
//       title: title,
//       content: html,
//       category: _category,
//       file: file,
//     );
//   }
//
//   void _snack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(children: [
//           Icon(
//             isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
//             color: Colors.white, size: 18,
//           ),
//           const SizedBox(width: 8),
//           Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13))),
//         ]),
//         backgroundColor: isError ? const Color(0xFFE53935) : _C.green,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   void _preview() => Navigator.push(
//     context,
//     PageRouteBuilder(
//       pageBuilder: (_, anim, __) => FadeTransition(
//         opacity: anim,
//         child: PreviewScreen(
//           title: _titleCtrl.text,
//           category: _category,
//           quillCtrl: _quillCtrl,
//           media: _media,
//         ),
//       ),
//       transitionDuration: const Duration(milliseconds: 250),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     // ── Listen to ViewModel state ──────────────────────────────────────────
//     // ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (_, next) {
//     //   next.when(
//     //     initial: () {},
//     //     loading: () {},
//     //     success: (post) {
//     //       HapticFeedback.lightImpact();
//     //       _snack('✓  "${post.title}" shared!');
//     //       Future.delayed(const Duration(milliseconds: 800), () {
//     //         if (mounted) Navigator.maybePop(context);
//     //       });
//     //     },
//     //     error: (msg, _) => _snack(msg, isError: true),
//     //   );
//     // });
//
//
//     ref.listen<NetworkResult<CreatePost>>(createPostViewModelProvider, (prev, next) {
//       next.when(
//         initial: () {},
//         // ✅ FIX 4: Loading pe previous error snack dismiss karo
//         loading: () => ScaffoldMessenger.of(context).clearSnackBars(),
//         success: (post) {
//           HapticFeedback.lightImpact();
//           _snack('✓  "${post.title}" shared!');
//           // ✅ FIX 5: Pop karne se pehle state reset karo
//           // Warna next baar screen open hone pe success state already set hogi
//           ref.read(createPostViewModelProvider.notifier).reset();
//           Future.delayed(const Duration(milliseconds: 800), () {
//             if (mounted) Navigator.maybePop(context);
//           });
//         },
//         error: (msg, _) => _snack(msg, isError: true),
//       );
//     });
//
//     final isLoading = ref.watch(createPostViewModelProvider) is Loading<CreatePost>;
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.bg,
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Column(
//                 children: [
//                   _buildTopBar(isLoading),
//                   const _HairlineDivider(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: _scrollCtrl,
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ── Media preview strip ──────────────────────────
//                           _MediaStrip(
//                             items: _media,
//                             onAdd: _pickImage,
//                             onRemove: (i) => setState(() => _media.removeAt(i)),
//                           ),
//
//                           // ── Caption / Title ──────────────────────────────
//                           _CaptionRow(controller: _titleCtrl),
//                           const _HairlineDivider(),
//
//                           // ── Category ─────────────────────────────────────
//                           _CategoryRow(
//                             value: _category,
//                             items: _categories,
//                             onChanged: (v) => setState(() => _category = v),
//                           ),
//                           const _HairlineDivider(),
//
//                           // ── Add file attachment ───────────────────────────
//                           _AttachRow(onFile: _pickFile, onImage: _pickImage),
//                           const _HairlineDivider(),
//
//                           // ── Rich text editor ──────────────────────────────
//                           _ContentSection(
//                             controller: _quillCtrl,
//                             focusNode: _editorFocus,
//                             isExpanded: _isExpanded,
//                             onToggle: () => setState(() => _isExpanded = !_isExpanded),
//                           ),
//                           const SizedBox(height: 100),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── Loading overlay ──────────────────────────────────────────────
//             if (isLoading)
//               Container(
//                 color: Colors.black.withOpacity(0.6),
//                 child: const Center(
//                   child: _LoadingDots(),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Top Bar ────────────────────────────────────────────────────────────────
//   Widget _buildTopBar(bool isLoading) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Row(children: [
//         // Back / Close
//         _IgIconBtn(
//           icon: Icons.close_rounded,
//           onTap: () => Navigator.maybePop(context),
//         ),
//
//         const Spacer(),
//
//         // Title
//         const Text(
//           'New post',
//           style: TextStyle(
//             color: _C.textPri,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             letterSpacing: -0.3,
//           ),
//         ),
//
//         const Spacer(),
//
//         // Preview
//         _IgIconBtn(
//           icon: Icons.remove_red_eye_outlined,
//           onTap: _preview,
//         ),
//
//         // Share button
//         ScaleTransition(
//           scale: _fabScale,
//           child: _ShareBtn(onTap: isLoading ? null : _publish),
//         ),
//       ]),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  MEDIA STRIP  (Instagram top image preview)
// // ═════════════════════════════════════════════════════════════════════════════
// class _MediaStrip extends StatelessWidget {
//   final List<MediaItem> items;
//   final VoidCallback onAdd;
//   final ValueChanged<int> onRemove;
//
//   const _MediaStrip({required this.items, required this.onAdd, required this.onRemove});
//
//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       // Empty state — tap to add
//       return GestureDetector(
//         onTap: onAdd,
//         child: Container(
//           height: 220,
//           width: double.infinity,
//           color: _C.surfaceEl,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 64, height: 64,
//                 decoration: BoxDecoration(
//                   color: _C.divider,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.add_photo_alternate_outlined,
//                     color: _C.textSec, size: 30),
//               ),
//               const SizedBox(height: 12),
//               const Text('Add photo or video',
//                   style: TextStyle(color: _C.textSec, fontSize: 14, fontWeight: FontWeight.w500)),
//               const SizedBox(height: 4),
//               const Text('Tap to select from gallery',
//                   style: TextStyle(color: _C.textTer, fontSize: 12)),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return SizedBox(
//       height: 280,
//       child: Stack(
//         children: [
//           // Main image
//           PageView.builder(
//             itemCount: items.length,
//             itemBuilder: (_, i) {
//               final m = items[i];
//               return Stack(
//                 children: [
//                   m.isImage
//                       ? Image.file(File(m.path),
//                       width: double.infinity, height: 280, fit: BoxFit.cover)
//                       : Container(
//                     color: _C.surfaceEl,
//                     child: Center(
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         const Icon(Icons.insert_drive_file_outlined,
//                             color: _C.textSec, size: 48),
//                         const SizedBox(height: 8),
//                         Text(m.path.split('/').last,
//                             style: const TextStyle(color: _C.textSec, fontSize: 12)),
//                       ]),
//                     ),
//                   ),
//                   // Remove btn
//                   Positioned(
//                     top: 12, right: 12,
//                     child: GestureDetector(
//                       onTap: () => onRemove(i),
//                       child: Container(
//                         width: 30, height: 30,
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.65),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.close, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           // Add more
//           Positioned(
//             bottom: 12, right: 12,
//             child: GestureDetector(
//               onTap: onAdd,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white24),
//                 ),
//                 child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.add_rounded, color: Colors.white, size: 16),
//                   SizedBox(width: 4),
//                   Text('Add more', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
//                 ]),
//               ),
//             ),
//           ),
//           // Dot indicators
//           if (items.length > 1)
//             Positioned(
//               bottom: 12, left: 0, right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(items.length, (i) => Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 2),
//                   width: 6, height: 6,
//                   decoration: const BoxDecoration(
//                     color: _C.accent, shape: BoxShape.circle,
//                   ),
//                 )),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  CAPTION ROW  (Instagram-style user + caption input)
// // ═════════════════════════════════════════════════════════════════════════════
// class _CaptionRow extends StatelessWidget {
//   final TextEditingController controller;
//   const _CaptionRow({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar
//           Container(
//             width: 38, height: 38,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFf09433), Color(0xFFe6683c), Color(0xFFdc2743),
//                   Color(0xFFcc2366), Color(0xFFbc1888)],
//                 begin: Alignment.topLeft, end: Alignment.bottomRight,
//               ),
//             ),
//             child: const Center(
//               child: Text('D', style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16,
//               )),
//             ),
//           ),
//           const SizedBox(width: 12),
//
//           // Caption input
//           Expanded(
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(color: _C.textPri, fontSize: 15, height: 1.45),
//               maxLines: null,
//               textInputAction: TextInputAction.newline,
//               decoration: const InputDecoration(
//                 hintText: 'Write a caption...',
//                 hintStyle: TextStyle(color: _C.textTer, fontSize: 15),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.zero,
//                 isDense: true,
//               ),
//             ),
//           ),
//
//           // Media preview thumb
//           const SizedBox(width: 10),
//           Container(
//             width: 46, height: 46,
//             decoration: BoxDecoration(
//               color: _C.surfaceEl,
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: _C.divider),
//             ),
//             child: const Icon(Icons.image_outlined, color: _C.textTer, size: 22),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  CATEGORY ROW  (Instagram "Tag people" style)
// // ═════════════════════════════════════════════════════════════════════════════
// class _CategoryRow extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String> onChanged;
//
//   const _CategoryRow({required this.value, required this.items, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => _showPicker(context),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//         child: Row(children: [
//           const Icon(Icons.sell_outlined, color: _C.textSec, size: 20),
//           const SizedBox(width: 14),
//           const Text('Category',
//               style: TextStyle(color: _C.textPri, fontSize: 15)),
//           const Spacer(),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: _C.tag,
//               borderRadius: BorderRadius.circular(6),
//               border: Border.all(color: _C.accent.withOpacity(0.3)),
//             ),
//             child: Text(value,
//                 style: const TextStyle(color: _C.accent, fontSize: 12, fontWeight: FontWeight.w600)),
//           ),
//           const SizedBox(width: 6),
//           const Icon(Icons.chevron_right_rounded, color: _C.textTer, size: 20),
//         ]),
//       ),
//     );
//   }
//
//   void _showPicker(BuildContext ctx) {
//     showModalBottomSheet(
//       context: ctx,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _CategorySheet(
//         selected: value,
//         items: items,
//         onSelect: (v) {
//           onChanged(v);
//           Navigator.pop(ctx);
//         },
//       ),
//     );
//   }
// }
//
// // ─── Bottom sheet for category ────────────────────────────────────────────────
// class _CategorySheet extends StatelessWidget {
//   final String selected;
//   final List<String> items;
//   final ValueChanged<String> onSelect;
//
//   const _CategorySheet({required this.selected, required this.items, required this.onSelect});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF1C1C1C),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           Container(
//             margin: const EdgeInsets.only(top: 10, bottom: 6),
//             width: 36, height: 4,
//             decoration: BoxDecoration(
//               color: _C.textTer, borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Text('Select Category',
//                 style: TextStyle(color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700)),
//           ),
//           const _HairlineDivider(),
//           ...items.map((cat) => InkWell(
//             onTap: () => onSelect(cat),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Row(children: [
//                 Text(cat, style: TextStyle(
//                   color: cat == selected ? _C.accent : _C.textPri,
//                   fontSize: 15,
//                   fontWeight: cat == selected ? FontWeight.w600 : FontWeight.w400,
//                 )),
//                 const Spacer(),
//                 if (cat == selected)
//                   const Icon(Icons.check_rounded, color: _C.accent, size: 20),
//               ]),
//             ),
//           )),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  ATTACH ROW  (Add Photo / File buttons)
// // ═════════════════════════════════════════════════════════════════════════════
// class _AttachRow extends StatelessWidget {
//   final VoidCallback onFile;
//   final VoidCallback onImage;
//
//   const _AttachRow({required this.onFile, required this.onImage});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(children: [
//         _AttachTile(
//           icon: Icons.photo_library_outlined,
//           label: 'Add Photo',
//           onTap: onImage,
//         ),
//         _AttachTile(
//           icon: Icons.attach_file_rounded,
//           label: 'Attach File',
//           onTap: onFile,
//         ),
//       ]),
//     );
//   }
// }
//
// class _AttachTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//
//   const _AttachTile({required this.icon, required this.label, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//           child: Row(children: [
//             Icon(icon, color: _C.textSec, size: 20),
//             const SizedBox(width: 14),
//             Text(label, style: const TextStyle(color: _C.textPri, fontSize: 15)),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  CONTENT / RICH EDITOR SECTION
// // ═════════════════════════════════════════════════════════════════════════════
// class _ContentSection extends StatefulWidget {
//   final QuillController controller;
//   final FocusNode focusNode;
//   final bool isExpanded;
//   final VoidCallback onToggle;
//
//   const _ContentSection({
//     required this.controller,
//     required this.focusNode,
//     required this.isExpanded,
//     required this.onToggle,
//   });
//
//   @override
//   State<_ContentSection> createState() => _ContentSectionState();
// }
//
// class _ContentSectionState extends State<_ContentSection> {
//   bool _showToolbar = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section header
//         InkWell(
//           onTap: widget.onToggle,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//             child: Row(children: [
//               const Icon(Icons.edit_note_rounded, color: _C.textSec, size: 22),
//               const SizedBox(width: 14),
//               const Text('Post Content',
//                   style: TextStyle(color: _C.textPri, fontSize: 15)),
//               const Spacer(),
//               _WordCountBadge(controller: widget.controller),
//               const SizedBox(width: 8),
//               Icon(
//                 widget.isExpanded
//                     ? Icons.keyboard_arrow_up_rounded
//                     : Icons.keyboard_arrow_down_rounded,
//                 color: _C.textTer, size: 20,
//               ),
//             ]),
//           ),
//         ),
//
//         // Collapsible editor
//         AnimatedSize(
//           duration: const Duration(milliseconds: 280),
//           curve: Curves.easeInOut,
//           child: widget.isExpanded
//               ? Column(
//             children: [
//               const _HairlineDivider(),
//               // Toolbar toggle
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 child: Row(children: [
//                   const Text('Formatting',
//                       style: TextStyle(color: _C.textTer, fontSize: 12, letterSpacing: 0.4)),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () => setState(() => _showToolbar = !_showToolbar),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _C.surfaceEl,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(color: _C.divider),
//                       ),
//                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                         Icon(
//                           _showToolbar ? Icons.text_format : Icons.text_format,
//                           color: _showToolbar ? _C.accent : _C.textSec,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           _showToolbar ? 'Hide tools' : 'Show tools',
//                           style: TextStyle(
//                             color: _showToolbar ? _C.accent : _C.textSec,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ),
//                 ]),
//               ),
//
//               // Toolbar
//               if (_showToolbar)
//                 Container(
//                   color: const Color(0xFF111111),
//                   child: QuillSimpleToolbar(
//                     controller: widget.controller,
//                     config: QuillSimpleToolbarConfig(
//                       showBoldButton: true,
//                       showItalicButton: true,
//                       showUnderLineButton: true,
//                       showStrikeThrough: true,
//                       showColorButton: true,
//                       showBackgroundColorButton: false,
//                       showClearFormat: true,
//                       showAlignmentButtons: true,
//                       showLeftAlignment: true,
//                       showCenterAlignment: true,
//                       showRightAlignment: true,
//                       showJustifyAlignment: false,
//                       showHeaderStyle: true,
//                       showListNumbers: true,
//                       showListBullets: true,
//                       showListCheck: false,
//                       showCodeBlock: true,
//                       showQuote: true,
//                       showIndent: false,
//                       showLink: true,
//                       showSearchButton: false,
//                       showSubscript: false,
//                       showSuperscript: false,
//                       showSmallButton: false,
//                       showDividers: true,
//                       showFontFamily: false,
//                       showFontSize: false,
//                       showInlineCode: true,
//                       showDirection: false,
//                       showUndo: true,
//                       showRedo: true,
//                       toolbarIconAlignment: WrapAlignment.start,
//                       decoration: const BoxDecoration(color: Color(0xFF111111)),
//                       buttonOptions: QuillSimpleToolbarButtonOptions(
//                         base: QuillToolbarBaseButtonOptions(
//                           iconTheme: QuillIconTheme(
//                             iconButtonSelectedData: IconButtonData(
//                               style: IconButton.styleFrom(
//                                 backgroundColor: _C.accent.withOpacity(0.15),
//                                 foregroundColor: _C.accent,
//                               ),
//                             ),
//                             iconButtonUnselectedData: IconButtonData(
//                               style: IconButton.styleFrom(
//                                 foregroundColor: _C.textSec,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//               // Editor
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                 child: QuillEditor(
//                   controller: widget.controller,
//                   focusNode: widget.focusNode,
//                   scrollController: ScrollController(),
//                   config: QuillEditorConfig(
//                     minHeight: 160,
//                     maxHeight: 360,
//                     scrollable: true,
//                     autoFocus: false,
//                     expands: false,
//                     padding: EdgeInsets.zero,
//                     placeholder: 'Write something about your post...',
//                     customStyles: DefaultStyles(
//                       placeHolder: DefaultTextBlockStyle(
//                         const TextStyle(color: _C.textTer, fontSize: 15),
//                         HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                       ),
//                       paragraph: DefaultTextBlockStyle(
//                         const TextStyle(color: _C.textPri, fontSize: 15, height: 1.6),
//                         HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                       ),
//                       bold: const TextStyle(color: _C.textPri, fontWeight: FontWeight.w700),
//                       italic: const TextStyle(color: _C.textPri, fontStyle: FontStyle.italic),
//                       h1: DefaultTextBlockStyle(
//                         const TextStyle(color: _C.textPri, fontSize: 24, fontWeight: FontWeight.w800),
//                         HorizontalSpacing.zero, const VerticalSpacing(8, 0), VerticalSpacing.zero, null,
//                       ),
//                       h2: DefaultTextBlockStyle(
//                         const TextStyle(color: _C.textPri, fontSize: 20, fontWeight: FontWeight.w700),
//                         HorizontalSpacing.zero, const VerticalSpacing(6, 0), VerticalSpacing.zero, null,
//                       ),
//                       quote: DefaultTextBlockStyle(
//                         const TextStyle(color: _C.textSec, fontSize: 15, fontStyle: FontStyle.italic),
//                         HorizontalSpacing.zero, const VerticalSpacing(6, 6), VerticalSpacing.zero,
//                         const BoxDecoration(
//                           border: Border(left: BorderSide(color: _C.accent, width: 3)),
//                         ),
//                       ),
//                       code: DefaultTextBlockStyle(
//                         const TextStyle(color: Color(0xFF9EFBB0), fontSize: 13, fontFamily: 'monospace'),
//                         HorizontalSpacing.zero, const VerticalSpacing(4, 4), VerticalSpacing.zero,
//                         BoxDecoration(
//                           color: const Color(0xFF0A0A0A),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//               : const SizedBox.shrink(),
//         ),
//
//         const _HairlineDivider(),
//       ],
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  SHARE BUTTON  (Instagram blue top-right)
// // ═════════════════════════════════════════════════════════════════════════════
// class _ShareBtn extends StatelessWidget {
//   final VoidCallback? onTap;
//   const _ShareBtn({this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(right: 8, left: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//         decoration: BoxDecoration(
//           color: onTap == null ? _C.accent.withOpacity(0.4) : _C.accent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Text(
//           'Share',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 14,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Icon Button ──────────────────────────────────────────────────────────────
// class _IgIconBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _IgIconBtn({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: Icon(icon, color: _C.textPri, size: 24),
//     ),
//   );
// }
//
// // ─── Hairline divider ─────────────────────────────────────────────────────────
// class _HairlineDivider extends StatelessWidget {
//   const _HairlineDivider();
//   @override
//   Widget build(BuildContext context) =>
//       const Divider(height: 1, thickness: 0.5, color: _C.divider);
// }
//
// // ─── Word Count Badge ─────────────────────────────────────────────────────────
// class _WordCountBadge extends StatefulWidget {
//   final QuillController controller;
//   const _WordCountBadge({required this.controller});
//   @override State<_WordCountBadge> createState() => _WordCountBadgeState();
// }
//
// class _WordCountBadgeState extends State<_WordCountBadge> {
//   int _words = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_update);
//   }
//
//   void _update() {
//     final text = widget.controller.document.toPlainText().trim();
//     final w = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
//     if (w != _words) setState(() => _words = w);
//   }
//
//   @override
//   void dispose() {
//     widget.controller.removeListener(_update);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => _words == 0
//       ? const SizedBox.shrink()
//       : Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//     decoration: BoxDecoration(
//       color: _C.surfaceEl,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Text(
//       '$_words w',
//       style: const TextStyle(color: _C.textTer, fontSize: 11),
//     ),
//   );
// }
//
// // ─── Loading Dots ─────────────────────────────────────────────────────────────
// class _LoadingDots extends StatefulWidget {
//   const _LoadingDots();
//   @override State<_LoadingDots> createState() => _LoadingDotsState();
// }
//
// class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
//       ..repeat();
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1C),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         const CupertinoActivityIndicator(color: _C.accent, radius: 14),
//         const SizedBox(height: 10),
//         const Text('Sharing your post...',
//             style: TextStyle(color: _C.textSec, fontSize: 13)),
//       ]),
//     );
//   }
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  PREVIEW SCREEN  (Instagram-style)
// // ═════════════════════════════════════════════════════════════════════════════
// class PreviewScreen extends StatelessWidget {
//   final String title;
//   final String category;
//   final QuillController quillCtrl;
//   final List<MediaItem> media;
//
//   const PreviewScreen({
//     super.key,
//     required this.title,
//     required this.category,
//     required this.quillCtrl,
//     required this.media,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               child: Row(children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Icon(Icons.arrow_back_ios_new_rounded,
//                         color: _C.textPri, size: 20),
//                   ),
//                 ),
//                 const Spacer(),
//                 const Text('Preview',
//                     style: TextStyle(
//                       color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700,
//                       letterSpacing: -0.3,
//                     )),
//                 const Spacer(),
//                 const SizedBox(width: 44),
//               ]),
//             ),
//             const _HairlineDivider(),
//
//             // Post content
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Post header
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
//                       child: Row(children: [
//                         // Avatar
//                         Container(
//                           width: 36, height: 36,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: _C.accentSec, width: 2),
//                           ),
//                           child: const CircleAvatar(
//                             backgroundColor: _C.surfaceEl,
//                             child: Text('D',
//                                 style: TextStyle(
//                                   color: _C.textPri,
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 15,
//                                 )),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                           const Text('divyanshu',
//                               style: TextStyle(
//                                 color: _C.textPri,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                               )),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: _C.tag,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(category,
//                                 style: const TextStyle(
//                                   color: _C.accent, fontSize: 10, fontWeight: FontWeight.w600,
//                                 )),
//                           ),
//                         ]),
//                         const Spacer(),
//                         const Icon(Icons.more_horiz, color: _C.textSec, size: 22),
//                       ]),
//                     ),
//
//                     // Image
//                     if (media.isNotEmpty && media.first.isImage)
//                       Image.file(
//                         File(media.first.path),
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//
//                     // Actions row
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
//                       child: Row(children: [
//                         const Icon(Icons.favorite_border_rounded, color: _C.textPri, size: 26),
//                         const SizedBox(width: 14),
//                         const Icon(Icons.chat_bubble_outline_rounded, color: _C.textPri, size: 24),
//                         const SizedBox(width: 14),
//                         const Icon(Icons.near_me_outlined, color: _C.textPri, size: 24),
//                         const Spacer(),
//                         const Icon(Icons.bookmark_border_rounded, color: _C.textPri, size: 24),
//                       ]),
//                     ),
//
//                     // Likes
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//                       child: Text('0 likes',
//                           style: TextStyle(color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 13)),
//                     ),
//
//                     // Caption
//                     if (title.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
//                         child: RichText(
//                           text: TextSpan(children: [
//                             const TextSpan(
//                               text: 'divyanshu  ',
//                               style: TextStyle(
//                                 color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 14,
//                               ),
//                             ),
//                             TextSpan(
//                               text: title,
//                               style: const TextStyle(color: _C.textPri, fontSize: 14, height: 1.4),
//                             ),
//                           ]),
//                         ),
//                       ),
//
//                     // Rich text body preview
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
//                       child: Builder(
//                         builder: (context) {
//                           quillCtrl.readOnly = true;
//                           return QuillEditor(
//                             controller: quillCtrl,
//                             focusNode: FocusNode(),
//                             scrollController: ScrollController(),
//                             config: QuillEditorConfig(
//                               scrollable: false,
//                               autoFocus: false,
//                               expands: false,
//                               padding: EdgeInsets.zero,
//                               customStyles: DefaultStyles(
//                                 paragraph: DefaultTextBlockStyle(
//                                   const TextStyle(color: _C.textSec, fontSize: 14, height: 1.6),
//                                   HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//
//                     // Timestamp
//                     const Padding(
//                       padding: EdgeInsets.fromLTRB(14, 4, 14, 20),
//                       child: Text('Just now',
//                           style: TextStyle(color: _C.textTer, fontSize: 11, letterSpacing: 0.2)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








// ─── UI Without Using Instagram theme ────────────────────────────────────────────








// import 'package:flutter/material.dart';
//
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:image_picker/image_picker.dart';
//
// // ─── Palette ──────────────────────────────────────────────────────────────────
// abstract class AppColors {
//   static const bg         = Color(0xFF12112A);
//   static const card       = Color(0xFF1C1B35);
//   static const border     = Color(0xFF2E2D4D);
//   static const toolbarBg  = Color(0xFF181730);
//   static const purple     = Color(0xFF7C6FCD);
//   static const green      = Color(0xFF4CAF87);
//   static const textPrimary = Color(0xFFEAE9FF);
//   static const textMuted  = Color(0xFF6B6A8E);
//   static const codeGreen  = Color(0xFF9EFBB0);
// }
//
// // ─── Data model ───────────────────────────────────────────────────────────────
// class MediaItem {
//   final String path;
//   final bool isImage;
//   MediaItem({required this.path, required this.isImage});
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  MAIN SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class CreatePostScreen extends StatefulWidget {
//   const CreatePostScreen({super.key});
//   @override
//   State<CreatePostScreen> createState() => _CreateNewPostScreenState();
// }
//
// class _CreateNewPostScreenState extends State<CreatePostScreen> {
//   final _titleCtrl    = TextEditingController();
//   final _quillCtrl    = QuillController.basic();
//   final _editorFocus  = FocusNode();
//   final _scrollCtrl   = ScrollController();
//
//   String _category = 'Forex & Currency';
//   final List<String> _categories = [
//     'Forex & Currency', 'Crypto', 'Stocks', 'Commodities', 'Economy',
//   ];
//
//   final List<MediaItem> _media = [];
//
//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _quillCtrl.dispose();
//     _editorFocus.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Pick image ─────────────────────────────────────────────────────────────
//   Future<void> _pickImage() async {
//     final x = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (x != null) setState(() => _media.add(MediaItem(path: x.path, isImage: true)));
//   }
//
//   // ── Pick file ──────────────────────────────────────────────────────────────
//   Future<void> _pickFile() async {
//     final r = await FilePicker.platform.pickFiles();
//     if (r?.files.single.path != null) {
//       final p = r!.files.single.path!;
//       final isImg = ['.jpg','.jpeg','.png','.gif','.webp']
//           .any((e) => p.toLowerCase().endsWith(e));
//       setState(() => _media.add(MediaItem(path: p, isImage: isImg)));
//     }
//   }
//
//   // ── Validate & Publish ─────────────────────────────────────────────────────
//   void _publish() {
//     final title = _titleCtrl.text.trim();
//     if (title.isEmpty) {
//       _snack('Please enter a post title', isError: true);
//       return;
//     }
//     // TODO: send to API — _quillCtrl.document.toDelta().toJson()
//     _snack('✓  Post "$title" published!');
//   }
//
//   void _snack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: isError ? Colors.redAccent : AppColors.green,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ));
//   }
//
//   // ── Preview ────────────────────────────────────────────────────────────────
//   void _preview() => Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => PreviewScreen(
//         title: _titleCtrl.text,
//         category: _category,
//         quillCtrl: _quillCtrl,
//         media: _media,
//       ),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── AppBar ──────────────────────────────────────────────────────
//             _TopBar(onBack: () => Navigator.maybePop(context)),
//
//             // ── Scrollable body ─────────────────────────────────────────────
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: _scrollCtrl,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _label('POST TITLE'),
//                     const SizedBox(height: 6),
//                     _TitleInput(controller: _titleCtrl),
//                     const SizedBox(height: 16),
//
//                     _label('CATEGORY'),
//                     const SizedBox(height: 6),
//                     _CategoryPicker(
//                       value: _category,
//                       items: _categories,
//                       onChanged: (v) => setState(() => _category = v!),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // Upload zone
//                     _UploadZone(onImage: _pickImage, onFile: _pickFile),
//
//                     // Media thumbnails
//                     if (_media.isNotEmpty) ...[
//                       const SizedBox(height: 10),
//                       _MediaRow(
//                         items: _media,
//                         onRemove: (i) => setState(() => _media.removeAt(i)),
//                       ),
//                     ],
//
//                     const SizedBox(height: 16),
//                     _label('POST CONTENT'),
//                     const SizedBox(height: 6),
//
//                     // ── Working Rich Text Editor ─────────────────────────────
//                     _RichEditor(controller: _quillCtrl, focusNode: _editorFocus),
//
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ── Bottom actions ──────────────────────────────────────────────
//             _BottomActions(onPreview: _preview, onPublish: _publish),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String t) => Text(t, style: const TextStyle(
//     color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4,
//   ));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// //  WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // ── Top AppBar ────────────────────────────────────────────────────────────────
// class _TopBar extends StatelessWidget {
//   final VoidCallback onBack;
//   const _TopBar({required this.onBack});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(children: [
//         GestureDetector(
//           onTap: onBack,
//           child: Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//               color: AppColors.purple.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColors.purple.withOpacity(0.35)),
//             ),
//             child: const Icon(Icons.article_outlined, color: AppColors.purple, size: 18),
//           ),
//         ),
//         const SizedBox(width: 12),
//         const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('Create New Post',
//               style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
//           Text('Feeds / New Feeds',
//               style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
//         ]),
//         const Spacer(),
//         CircleAvatar(
//           radius: 18,
//           backgroundColor: AppColors.purple,
//           child: const Text('d',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
//         ),
//       ]),
//     );
//   }
// }
//
// // ── Title Input ───────────────────────────────────────────────────────────────
// class _TitleInput extends StatelessWidget {
//   final TextEditingController controller;
//   const _TitleInput({required this.controller});
//
//   @override
//   Widget build(BuildContext context) => _Card(
//     child: TextField(
//       controller: controller,
//       style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//       decoration: const InputDecoration(
//         hintText: '✦ Enter title...',
//         hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
//         contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//         border: InputBorder.none,
//       ),
//     ),
//   );
// }
//
// // ── Category Picker ───────────────────────────────────────────────────────────
// class _CategoryPicker extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//   const _CategoryPicker({required this.value, required this.items, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) => _Card(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value, isExpanded: true,
//           dropdownColor: AppColors.card,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
//           style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//           items: items.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     ),
//   );
// }
//
// // ── Upload Zone ───────────────────────────────────────────────────────────────
// class _UploadZone extends StatelessWidget {
//   final VoidCallback onImage;
//   final VoidCallback onFile;
//   const _UploadZone({required this.onImage, required this.onFile});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         child: Column(children: [
//           Container(
//             width: 48, height: 48,
//             decoration: BoxDecoration(
//               color: AppColors.purple.withOpacity(0.15), shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.cloud_upload_outlined, color: AppColors.purple, size: 26),
//           ),
//           const SizedBox(height: 10),
//           const Text('Drag & Drop or Tap to Upload',
//               style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
//           const SizedBox(height: 4),
//           const Text('Supports images (JPEG, PNG) and files (PDF, DOC)',
//               style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
//           const SizedBox(height: 16),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             _UploadBtn(icon: Icons.image_outlined, label: 'Image', onTap: onImage),
//             const SizedBox(width: 12),
//             _UploadBtn(icon: Icons.attach_file_rounded, label: 'File', onTap: onFile),
//           ]),
//         ]),
//       ),
//     );
//   }
// }
//
// class _UploadBtn extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _UploadBtn({required this.icon, required this.label, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.purple.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.purple.withOpacity(0.4)),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: AppColors.purple, size: 16),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(
//             color: AppColors.purple, fontSize: 13, fontWeight: FontWeight.w600)),
//       ]),
//     ),
//   );
// }
//
// // ── Media Thumbnails ──────────────────────────────────────────────────────────
// class _MediaRow extends StatelessWidget {
//   final List<MediaItem> items;
//   final ValueChanged<int> onRemove;
//   const _MediaRow({required this.items, required this.onRemove});
//
//   @override
//   Widget build(BuildContext context) => Wrap(
//     spacing: 8, runSpacing: 8,
//     children: List.generate(items.length, (i) {
//       final m = items[i];
//       return Stack(children: [
//         Container(
//           width: 80, height: 80,
//           decoration: BoxDecoration(
//             color: AppColors.card,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: AppColors.border),
//             image: m.isImage
//                 ? DecorationImage(image: FileImage(File(m.path)), fit: BoxFit.cover)
//                 : null,
//           ),
//           child: m.isImage
//               ? null
//               : const Icon(Icons.insert_drive_file_outlined, color: AppColors.textMuted, size: 30),
//         ),
//         Positioned(
//           top: 4, right: 4,
//           child: GestureDetector(
//             onTap: () => onRemove(i),
//             child: Container(
//               width: 20, height: 20,
//               decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
//               child: const Icon(Icons.close, color: Colors.white, size: 12),
//             ),
//           ),
//         ),
//       ]);
//     }),
//   );
// }
//
// // ── Rich Text Editor ──────────────────────────────────────────────────────────
// class _RichEditor extends StatefulWidget {
//   final QuillController controller;
//   final FocusNode focusNode;
//   const _RichEditor({required this.controller, required this.focusNode});
//
//   @override
//   State<_RichEditor> createState() => _RichEditorState();
// }
//
// class _RichEditorState extends State<_RichEditor> {
//   bool _showToolbar = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.card,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(children: [
//         // ── Toolbar Header & Toggle ────────────────────────────────────────
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.toolbarBg,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(12),
//               topRight: const Radius.circular(12),
//               bottomLeft: Radius.circular(_showToolbar ? 0 : 12),
//               bottomRight: Radius.circular(_showToolbar ? 0 : 12),
//             ),
//             border: Border(bottom: BorderSide(color: _showToolbar ? AppColors.border : Colors.transparent)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('FORMATTING TOOLS',
//                         style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1)),
//                     GestureDetector(
//                       onTap: () => setState(() => _showToolbar = !_showToolbar),
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: AppColors.purple.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Icon(
//                           _showToolbar ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
//                           color: AppColors.purple,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_showToolbar)
//                 QuillSimpleToolbar(
//                   controller: widget.controller,
//                   config: QuillSimpleToolbarConfig(
//                     showBoldButton: true,
//                     showItalicButton: true,
//                     showUnderLineButton: true,
//                     showStrikeThrough: true,
//                     showColorButton: true,
//                     showBackgroundColorButton: false,
//                     showClearFormat: true,
//                     showAlignmentButtons: true,
//                     showLeftAlignment: true,
//                     showCenterAlignment: true,
//                     showRightAlignment: true,
//                     showJustifyAlignment: true,
//                     showHeaderStyle: true,
//                     showListNumbers: true,
//                     showListBullets: true,
//                     showListCheck: false,
//                     showCodeBlock: true,
//                     showQuote: true,
//                     showIndent: false,
//                     showLink: true,
//                     showSearchButton: false,
//                     showSubscript: false,
//                     showSuperscript: false,
//                     showSmallButton: false,
//                     showDividers: true,
//                     showFontFamily: false,
//                     showFontSize: true,
//                     showInlineCode: true,
//                     showDirection: false,
//                     showUndo: true,
//                     showRedo: true,
//                     toolbarIconAlignment: WrapAlignment.start,
//                     toolbarSectionSpacing: 2,
//                     buttonOptions: QuillSimpleToolbarButtonOptions(
//                       base: QuillToolbarBaseButtonOptions(
//                         iconTheme: QuillIconTheme(
//                           iconButtonSelectedData: IconButtonData(
//                             style: IconButton.styleFrom(
//                               backgroundColor: AppColors.purple.withOpacity(0.25),
//                               foregroundColor: AppColors.purple,
//                             ),
//                           ),
//                           iconButtonUnselectedData: IconButtonData(
//                             style: IconButton.styleFrom(
//                               foregroundColor: AppColors.textMuted,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     decoration: const BoxDecoration(color: AppColors.toolbarBg),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//
//         // ── Editor body ────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.all(14),
//           child: QuillEditor(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             scrollController: ScrollController(),
//             config: QuillEditorConfig(
//               minHeight: 220,
//               maxHeight: 420,
//               scrollable: true,
//               autoFocus: false,
//               expands: false,
//               padding: EdgeInsets.zero,
//               placeholder: 'Start writing your post...',
//               customStyles: DefaultStyles(
//                 placeHolder: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textMuted, fontSize: 14),
//                   HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                 ),
//                 paragraph: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.65),
//                   HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                 ),
//                 bold: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
//                 italic: const TextStyle(color: AppColors.textPrimary, fontStyle: FontStyle.italic),
//                 underline: const TextStyle(
//                   color: AppColors.textPrimary,
//                   decoration: TextDecoration.underline,
//                   decorationColor: AppColors.textPrimary,
//                 ),
//                 strikeThrough: const TextStyle(
//                   color: AppColors.textMuted,
//                   decoration: TextDecoration.lineThrough,
//                   decorationColor: AppColors.textMuted,
//                 ),
//                 h1: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.w800),
//                   HorizontalSpacing.zero, const VerticalSpacing(8, 0), VerticalSpacing.zero, null,
//                 ),
//                 h2: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
//                   HorizontalSpacing.zero, const VerticalSpacing(6, 0), VerticalSpacing.zero, null,
//                 ),
//                 h3: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
//                   HorizontalSpacing.zero, const VerticalSpacing(4, 0), VerticalSpacing.zero, null,
//                 ),
//                 lists: DefaultListBlockStyle(
//                   const TextStyle(color: AppColors.textPrimary, fontSize: 14),
//                   HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null, null,
//                 ),
//                 quote: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.textMuted, fontSize: 14, fontStyle: FontStyle.italic),
//                   HorizontalSpacing.zero, const VerticalSpacing(6, 6), VerticalSpacing.zero,
//                   const BoxDecoration(
//                     border: Border(left: BorderSide(color: AppColors.purple, width: 3)),
//                   ),
//                 ),
//                 code: DefaultTextBlockStyle(
//                   const TextStyle(color: AppColors.codeGreen, fontSize: 13, fontFamily: 'monospace'),
//                   HorizontalSpacing.zero, const VerticalSpacing(4, 4), VerticalSpacing.zero,
//                   BoxDecoration(
//                     color: const Color(0xFF0E0D24),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         // ── Word count ─────────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.only(right: 14, bottom: 10),
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: _WordCount(controller: widget.controller),
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// // ── Word Count ─────────────────────────────────────────────────────────────────
// class _WordCount extends StatefulWidget {
//   final QuillController controller;
//   const _WordCount({required this.controller});
//   @override State<_WordCount> createState() => _WordCountState();
// }
//
// class _WordCountState extends State<_WordCount> {
//   int _words = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_update);
//   }
//
//   void _update() {
//     final text = widget.controller.document.toPlainText().trim();
//     final w = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
//     if (w != _words) setState(() => _words = w);
//   }
//
//   @override
//   void dispose() {
//     widget.controller.removeListener(_update);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => Text(
//     '$_words word${_words == 1 ? '' : 's'}',
//     style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
//   );
// }
//
// // ── Bottom Actions ─────────────────────────────────────────────────────────────
// class _BottomActions extends StatelessWidget {
//   final VoidCallback onPreview;
//   final VoidCallback onPublish;
//   const _BottomActions({required this.onPreview, required this.onPublish});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     decoration: const BoxDecoration(
//       color: AppColors.bg,
//       border: Border(top: BorderSide(color: AppColors.border)),
//     ),
//     child: Row(children: [
//       Expanded(
//         child: OutlinedButton.icon(
//           onPressed: onPreview,
//           icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.textPrimary),
//           label: const Text('Preview',
//               style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
//           style: OutlinedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             side: const BorderSide(color: AppColors.border),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: ElevatedButton.icon(
//           onPressed: onPublish,
//           icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
//           label: const Text('Publish Post',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.green,
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             elevation: 0,
//           ),
//         ),
//       ),
//     ]),
//   );
// }
//
// // ── Shared Card wrapper ───────────────────────────────────────────────────────
// class _Card extends StatelessWidget {
//   final Widget child;
//   const _Card({required this.child});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: AppColors.card,
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: AppColors.border),
//     ),
//     child: child,
//   );
// }
//
// // ═════════════════════════════════════════════════════════════════════════════
// //  PREVIEW SCREEN
// // ═════════════════════════════════════════════════════════════════════════════
// class PreviewScreen extends StatelessWidget {
//   final String title;
//   final String category;
//   final QuillController quillCtrl;
//   final List<MediaItem> media;
//
//   const PreviewScreen({
//     super.key,
//     required this.title,
//     required this.category,
//     required this.quillCtrl,
//     required this.media,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: AppColors.bg,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Preview',
//             style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           // Category chip
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppColors.purple.withOpacity(0.18),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: AppColors.purple.withOpacity(0.4)),
//             ),
//             child: Text(category,
//                 style: const TextStyle(color: AppColors.purple, fontSize: 11, fontWeight: FontWeight.w600)),
//           ),
//           const SizedBox(height: 14),
//
//           // Title
//           Text(
//             title.isEmpty ? 'Untitled Post' : title,
//             style: const TextStyle(color: AppColors.textPrimary, fontSize: 22,
//                 fontWeight: FontWeight.w800, height: 1.3),
//           ),
//           const SizedBox(height: 16),
//
//           // Media
//           if (media.isNotEmpty) ...[
//             for (final m in media) ...[
//               if (m.isImage)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.file(File(m.path), width: double.infinity, height: 200, fit: BoxFit.cover),
//                 )
//               else
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.card,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: AppColors.border),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     const Icon(Icons.attach_file, color: AppColors.textMuted, size: 16),
//                     const SizedBox(width: 6),
//                     Text(m.path.split('/').last,
//                         style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
//                   ]),
//                 ),
//               const SizedBox(height: 10),
//             ],
//             const SizedBox(height: 6),
//           ],
//
//           // Body (read-only)
//           Builder(
//             builder: (context) {
//               quillCtrl.readOnly = true;
//               return QuillEditor(
//                 controller: quillCtrl,
//                 focusNode: FocusNode(),
//                 scrollController: ScrollController(),
//                 config: const QuillEditorConfig(
//                   scrollable: false,
//                   autoFocus: false,
//                   expands: false,
//                   padding: EdgeInsets.zero,
//                   customStyles: DefaultStyles(
//                     paragraph: DefaultTextBlockStyle(
//                       TextStyle(color: AppColors.textPrimary, fontSize: 15, height: 1.7),
//                       HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ]),
//       ),
//     );
//   }
// }