
import 'package:freezed_annotation/freezed_annotation.dart';

part 'GetPost.freezed.dart';

@freezed
abstract class GetPost with _$GetPost {
  const factory GetPost({
    required int id,
    required String title,
    required String content,
    String? mimeType,
    required String category,
    String? filePath,
    String? fileType,
    required DateTime createdAt,
    required int likesCount,
    required int userId,
    required String userRole,
    required bool isLiked,
    required bool isOwner,
    required String userName,
    String? userAvatarUrl,
  }) = _GetPost;
}



























