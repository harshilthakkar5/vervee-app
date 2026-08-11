
// ─── FILE: lib/presentation/widgets/HomeScreenWidgets/post_card_skeleton.dart ─
// ✅ CHANGE 2 (NEW FILE) — PostCard ka skeleton placeholder
//    Actual PostCard ki exact layout copy karta hai:
//      • Header  : avatar circle + 2 text lines + category badge
//      • Image   : full-width rectangle (160px)
//      • Title   : 2 text lines
//      • Actions : like / comment / share icons ke size ke rectangles
//    Har element ShimmerBox se replace kiya hai.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import 'ShimmerBox.dart';
//import 'shimmer_box.dart';
//import 'package:shimmer/shimmer.dart';

// ✅ CHANGE 2a — Ek standalone skeleton card
//    isTablet flag rakha taaki grid/list dono me same size dikhe
class PostCardSkeleton extends StatelessWidget {
  final bool isTablet;

  const PostCardSkeleton({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {

    // ── border/margin same as PostCard ──────────────────────────────────────
    return Container(
      margin: isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF150328),
        borderRadius: isTablet ? BorderRadius.circular(14) : null,
        border: isTablet
            ? Border.all(color: const Color(0xFF2D1050), width: 0.5)
            : const Border(
            bottom: BorderSide(color: Color(0xFF2D1050), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── HEADER skeleton ───────────────────────────────────────────────
          // ✅ CHANGE 2b — Avatar (circle) + username + time + category badge
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [

                // Avatar circle
                const ShimmerBox(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 10),

                // Username + timestamp column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 90, height: 10), // username
                      SizedBox(height: 5),
                      ShimmerBox(width: 55, height: 8),  // time
                    ],
                  ),
                ),

                // Category badge
                const ShimmerBox(width: 64, height: 20, borderRadius: 20),
                const SizedBox(width: 8),

                // More icon placeholder
                const ShimmerBox(width: 20, height: 20, borderRadius: 4),
              ],
            ),
          ),

          // ── IMAGE skeleton ────────────────────────────────────────────────
          // ✅ CHANGE 2c — Full-width rectangle same height as PostCard image
          ShimmerBox(
            width:        double.infinity,
            height:       isTablet ? 140 : 160,
            borderRadius: 0, // edge-to-edge, no radius
          ),

          // ── TITLE skeleton ────────────────────────────────────────────────
          // ✅ CHANGE 2d — 2 lines: full width + partial width
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 11), // line 1
                SizedBox(height: 6),
                ShimmerBox(width: 200, height: 11),             // line 2 (partial)
              ],
            ),
          ),

          // ── CONTENT PREVIEW skeleton ──────────────────────────────────────
          // ✅ CHANGE 2e — 2 lines content preview
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 9),
                SizedBox(height: 5),
                ShimmerBox(width: 260, height: 9),
              ],
            ),
          ),

          // ── ACTIONS skeleton ──────────────────────────────────────────────
          // ✅ CHANGE 2f — Like / Comment / Share icons ke size ke boxes
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 14),
            child: Row(
              children: [
                ShimmerBox(width: 40, height: 14), // like
                SizedBox(width: 16),
                ShimmerBox(width: 60, height: 14), // comment
                SizedBox(width: 16),
                ShimmerBox(width: 18, height: 14), // share icon
              ],
            ),
          ),
        ],
      ),
    );
  }
}