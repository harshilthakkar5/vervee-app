
class CourseVideo {
  final int id;
  final String title;
  final String content;
  final String? videoUrl;

  const CourseVideo({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
  });
}