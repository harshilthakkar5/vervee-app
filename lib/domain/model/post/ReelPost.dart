
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ReelPost.freezed.dart';

// ✅ NEW — Reel screen ka apna independent domain model,
// GetPost se alag rakha he kyu ki ye dedicated /posts/reels API se aata he
@freezed
abstract class ReelPost with _$ReelPost {
  const factory ReelPost({
    required int      id,
    required String   title,
    required String   content,
    String?            filePath,
    required String   fileType,
    required String   category,
    required DateTime createdAt,
    required int      likesCount,
    required int      userId,
    required String   userName,
    String?            userAvatarUrl,
    required int      commentsCount,
    required bool     isLiked,
    required bool     isOwner,
  }) = _ReelPost;
}