
// ─── LAYER 6B: UI — Edit Post Bottom Sheet ────────────────────────────────────
// File: lib/features/post/presentation/widgets/edit_post_sheet.dart
//
// CreatePostScreen ki tarah ka UI — lekin PATCH call karta hai.
// Features:
//   ✅ Pre-filled title, content (plain text), category
//   ✅ Optional new image pick karo
//   ✅ Save pe updatePost() call → optimistic update + rollback
//   ✅ Loading indicator during API call
//   ✅ Error snackbar
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:html/parser.dart' show parse;
import '../../../domain/model/post/GetPost.dart';
//import '../../domain/entities/get_post.dart';
import '../../viewmodal/pofile/ProfileViewmodels.dart';
import '../../viewmodal/post/GetPostViewModel.dart';
//import '../viewmodel/get_post_view_model.dart';

// ── Constants (apni constants file se import karo) ───────────────────────────
const kBgCard      = Color(0xFF150328);
const kBgDeep      = Color(0xFF0A0118);
const kPurple      = Color(0xFF7C3AED);
const kPurpleLight = Color(0xFF9333EA);
const kGold        = Color(0xFFD4AF37);
const kBorder      = Color(0xFF2D1050);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF888888);

const categories = [
  // 'Forex & Currency', 'Crypto', 'Stocks',
  // 'Commodities', 'Economy', 'Gold & Commodities', 'Oil Market', 'Other',

  'Oil Market',
  'Gold & Commodities',
  'Forex & Currency',
  'Geopolitics',
  'Economic Policy',
  'Market Volatility',
  'Other',
];

// ── Entry point ───────────────────────────────────────────────────────────────
void showEditPostSheet(
    BuildContext context,
    WidgetRef ref,
    GetPost post, {
bool isFromProfile = false, // ✅ NEW — batata hai konsa viewmodel use karna hai
}) {
  showModalBottomSheet(
    context:            context,
    backgroundColor:    Colors.transparent,
    isScrollControlled: true,
    builder:            (_) => _EditPostSheet(post: post, ref: ref, isFromProfile: isFromProfile,),
  );
}

class _EditPostSheet extends StatefulWidget {
  final GetPost   post;
  final WidgetRef ref;
  final bool      isFromProfile; // ✅ NEW

  const _EditPostSheet({required this.post, required this.ref, this.isFromProfile = false,});

  @override
  State<_EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends State<_EditPostSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late String _selectedCategory;
  File?   _newImage;
  bool    _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl        = TextEditingController(text: widget.post.title);
    // ✅ HTML strip karo — content plain text me dikhao
    _contentCtrl      = TextEditingController(text: _stripHtml(widget.post.content));
    _selectedCategory = categories.contains(widget.post.category)
        ? widget.post.category
        : categories.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  String _stripHtml(String html) {
    final doc = parse(html);
    return doc.body?.text ?? '';
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source:    ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _newImage = File(picked.path));
    }
  }

  // Future<void> _save() async {
  //   final title   = _titleCtrl.text.trim();
  //   final content = _contentCtrl.text.trim();
  //
  //   if (title.isEmpty || content.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content:         Text('Title and content are required.'),
  //         backgroundColor: Color(0xFFEF4444),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   setState(() => _saving = true);
  //
  //   final error = await widget.ref
  //       .read(getPostViewModelProvider.notifier)
  //       .updatePost(
  //     postId:   widget.post.id,
  //     title:    title,
  //     // ✅ Backend HTML expect karta hai — wrap karo
  //     content:  '<p>$content</p>',
  //     category: _selectedCategory,
  //     file:     _newImage,
  //   );
  //
  //   // ✅ Step 3 — FeedDetailScreen refresh karo (YE NAHI THA — isliye instant update nahi ho raha tha)
  //   widget.ref
  //       .read(userFeedViewModelProvider.notifier)
  //       .refresh();
  //
  //   if (!mounted) return;
  //   setState(() => _saving = false);
  //
  //   if (error == null) {
  //     // ✅ Success — sheet band karo
  //     Navigator.pop(context);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content:         Text('Post updated successfully!'),
  //         backgroundColor: Color(0xFF22C55E),
  //       ),
  //     );
  //   } else {
  //     // ✅ Error snackbar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:         Text('Update failed: $error'),
  //         backgroundColor: const Color(0xFFEF4444),
  //       ),
  //     );
  //   }
  // }

  Future<void> _save() async {
    final title   = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Title and content are required.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    // ✅ CHANGED — source ke hisaab se sahi viewmodel choose karo
    final String? error;
    if (widget.isFromProfile) {
      error = await widget.ref
          .read(userFeedViewModelProvider.notifier)
          .updatePost(
        postId:   widget.post.id,
        title:    title,
        content:  '<p>$content</p>',
        category: _selectedCategory,
        file:     _newImage,
      );
    } else {
      error = await widget.ref
          .read(getPostViewModelProvider.notifier)
          .updatePost(
        postId:   widget.post.id,
        title:    title,
        content:  '<p>$content</p>',
        category: _selectedCategory,
        file:     _newImage,
      );
      // ✅ Home se edit hua ho tab bhi Profile feed sync karo
      widget.ref.read(userFeedViewModelProvider.notifier).refresh();
    }

    if (!mounted) return;
    setState(() => _saving = false);

    if (error == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Post updated successfully!'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text('Update failed: $error'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }


  // Future<void> _save() async {
  //   final title   = _titleCtrl.text.trim();
  //   final content = _contentCtrl.text.trim();
  //
  //   if (title.isEmpty || content.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content:         Text('Title and content are required.'),
  //         backgroundColor: Color(0xFFEF4444),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   setState(() => _saving = true);
  //
  //   final error = await widget.ref
  //       .read(getPostViewModelProvider.notifier)
  //       .updatePost(
  //     postId:   widget.post.id,
  //     title:    title,
  //     content:  '<p>$content</p>',
  //     category: _selectedCategory,
  //     file:     _newImage,
  //   );
  //
  //   if (!mounted) return;
  //   setState(() => _saving = false);
  //
  //   if (error == null) {
  //
  //     // ✅ Step 1 — Sheet band karo
  //     Navigator.pop(context);
  //
  //     // ✅ Step 2 — API se fresh posts reload karo
  //     widget.ref
  //         .read(getPostViewModelProvider.notifier)
  //         .refresh();
  //
  //     // ✅ Step 3 — Success snackbar
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content:         Text('Post updated successfully!'),
  //           backgroundColor: Color(0xFF22C55E),
  //         ),
  //       );
  //     }
  //
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:         Text('Update failed: $error'),
  //         backgroundColor: const Color(0xFFEF4444),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize:     0.5,
      maxChildSize:     0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color:        kBgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── Handle + Header ───────────────────────────────────────────────
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: kTextMuted, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: kPurpleLight, size: 18),
                  const SizedBox(width: 8),
                  const Text('Edit Post',
                      style: TextStyle(
                          color: kTextPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  // ✅ Save button
                  GestureDetector(
                    onTap: _saving ? null : _save,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:        _saving ? kBorder : kPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _saving
                          ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                          : const Text('Save',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: kBorder, height: 1),

            // ── Form ─────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Title field
                    _label('Title'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _titleCtrl,
                      hint:       'Post title...',
                    ),
                    const SizedBox(height: 16),

                    // Content field
                    _label('Content'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: _contentCtrl,
                      hint:       'Write your post content...',
                      maxLines:   6,
                    ),
                    const SizedBox(height: 16),

                    // Category dropdown
                    _label('Category'),
                    const SizedBox(height: 6),
                    _CategoryDropdown(
                      selected: _selectedCategory,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    // Image picker
                    _label('Image (optional — change only if needed)'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:        kBgDeep,
                          borderRadius: BorderRadius.circular(12),
                          border:       Border.all(
                            color: _newImage != null ? kPurple : kBorder,
                            width: _newImage != null ? 1.5 : 0.8,
                          ),
                        ),
                        child: _newImage != null
                        // New image selected
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(_newImage!, fit: BoxFit.cover),
                        )
                        // Existing image preview
                            : widget.post.filePath != null
                            ? Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.network(
                              widget.post.filePath!,
                              width:  double.infinity,
                              height: 120,
                              fit:    BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _noImagePlaceholder(),
                            ),
                          ),
                          Positioned(
                            bottom: 6, right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Tap to change',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ])
                            : _noImagePlaceholder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: kGold, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5));

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) =>
      TextField(
        controller: controller,
        maxLines:   maxLines,
        style: const TextStyle(color: kTextPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText:       hint,
          hintStyle:      const TextStyle(color: kTextMuted, fontSize: 13),
          filled:         true,
          fillColor:      kBgDeep,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:   const BorderSide(color: kBorder)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:   const BorderSide(color: kBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:   const BorderSide(color: kPurple)),
        ),
      );

  Widget _noImagePlaceholder() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.add_photo_alternate_outlined, color: kTextMuted, size: 28),
      const SizedBox(height: 6),
      const Text('Tap to pick an image',
          style: TextStyle(color: kTextMuted, fontSize: 12)),
    ]),
  );
}

// ── Category Dropdown ─────────────────────────────────────────────────────────
class _CategoryDropdown extends StatelessWidget {
  final String          selected;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color:        kBgDeep,
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: kBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:         selected,
          onChanged:     onChanged,
          isExpanded:    true,
          dropdownColor: kBgCard,
          style: const TextStyle(color: kTextPrimary, fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kTextMuted),
          items: categories.map((c) => DropdownMenuItem(
            value: c,
            child: Text(c),
          )).toList(),
        ),
      ),
    );
  }
}