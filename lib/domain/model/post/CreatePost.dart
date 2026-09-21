
import 'package:freezed_annotation/freezed_annotation.dart';

part 'CreatePost.freezed.dart';

@freezed
abstract class CreatePost with _$CreatePost {
  const factory CreatePost({
    required int id,
    required String title,
     String? content,
    required String category,
    required String createdAt,
    required int likesCount,
    required int userId,
    String? filePath,
    String? fileType,
    String? mimeType,
  }) = _CreatePost;
}





























