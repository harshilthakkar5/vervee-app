
import 'CourseVideo.dart';

class FinancialLiteracyCourse {
  final int id;
  final String title;
  final String subtitle;
  final String content;
  final String? thumbnail;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;
  final bool isOwner;
  final List<CourseVideo> videos;

  const FinancialLiteracyCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    this.thumbnail,
    required this.createdAt,
    required this.likesCount,
    required this.isLiked,
    required this.isOwner,
    required this.videos,
  });
}













