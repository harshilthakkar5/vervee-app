
import 'ChapterVideo.dart';
import '../FinancialLiteracy/McqQuestion.dart';

// ── Ek chapter = ek video + (optional) uske apne mcqs ──────────────────────────
// Purani FinancialLiteracy flow me mcqs top-level flat list the aur video count
// se manually divide karne padte the. Vervee Universe API me har chapter apne
// mcqs khud carry karta he, isliye ab woh hack zaroori nahi.
class UniverseChapter {
  final int id;
  final String title;
  final String description;
  final int order;
  final ChapterVideo? video;
  final List<McqQuestion> mcqs;

  const UniverseChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.video,
    this.mcqs = const [],
  });
}
