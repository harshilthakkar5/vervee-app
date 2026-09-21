
import '../FinancialLiteracy/McqQuestion.dart';
import 'VerveeUniverseItem.dart';

class VerveeUniverseDetail extends VerveeUniverseItem {
  const VerveeUniverseDetail({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.content,
    super.thumbnail,
    required super.createdAt,
    required super.likesCount,
    required super.isLiked,
    required super.isOwner,
    required super.chapters,
  });

  /// MCQs jo `videoIndex` pe chal rahe video (= chapters[videoIndex]) ke he.
  /// Purani "mcqs ko video count se evenly divide karo" wali hack ki jagah —
  /// ab har chapter apne mcqs khud carry karta he.
  List<McqQuestion> mcqsForVideo(int videoIndex) {
    if (videoIndex < 0 || videoIndex >= chapters.length) return [];
    return chapters[videoIndex].mcqs;
  }

  /// Saare chapters ke saare mcqs ek saath (convenience getter).
  List<McqQuestion> get mcqs => chapters.expand((c) => c.mcqs).toList();
}
