
import 'package:freezed_annotation/freezed_annotation.dart';

part 'UserFeedPost.freezed.dart';

// ── 2. User Feed Post (GET /posts/for-user response item) ───────────
@freezed
abstract class UserFeedPost with _$UserFeedPost {
  const factory UserFeedPost({
    required int    id,
    required String title,
    required String content,
    required String category,
    String?         filePath,
    String?         fileType,
    String?         mimeType,
    required DateTime createdAt,
    required int    likesCount,
    required int    userId,
    required bool   isLiked,
  }) = _UserFeedPost;
}