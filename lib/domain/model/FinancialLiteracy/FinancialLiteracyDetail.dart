
import 'FinancialLiteracyCourse.dart';
import 'McqQuestion.dart';

class FinancialLiteracyDetail extends FinancialLiteracyCourse {
  final List<McqQuestion> mcqs;

  const FinancialLiteracyDetail({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.content,
    super.thumbnail,
    required super.createdAt,
    required super.likesCount,
    required super.isLiked,
    required super.isOwner,
    required super.videos,
    required this.mcqs,
  });
}









