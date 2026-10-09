
// ─── LAYER 2B: Domain Entity — PostComment ────────────────────────────────────
// File: lib/features/post/domain/entities/post_comment.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'PostComment.freezed.dart';

@freezed
abstract class PostComment with _$PostComment {
  const factory PostComment({
    required int      id,
    required String   content,
    required DateTime createdAt,
    required String   userName,
    String? userAvatarUrl,
  }) = _PostComment;
}