
import 'ChapterVideo.dart';
import 'UniverseChapter.dart';

class VerveeUniverseItem {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final String? thumbnail;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;
  final bool isOwner;
  final List<UniverseChapter> chapters;

  const VerveeUniverseItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    this.thumbnail,
    required this.createdAt,
    required this.likesCount,
    required this.isLiked,
    required this.isOwner,
    required this.chapters,
  });

  // ── Flattened list of videos, one per chapter (chapter order) ───────────────
  // Rakha gaya he taaki FinancialLiteracyScreen / VideoDetailScreen ka existing
  // UI code (jo `course.videos` expect karta he) bina change ke chalta rahe.
  List<ChapterVideo> get videos =>
      chapters.where((c) => c.video != null).map((c) => c.video!).toList();
}
