
class ChapterVideo {
  final int id;
  final String title;
  final String content;
  final String? videoUrl;
  final int? duration;

  const ChapterVideo({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
    this.duration,
  });
}
