
// ─── LAYER 2A: Domain Entity — LikePost ──────────────────────────────────────
// File: lib/features/post/domain/entities/like_post.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'LikePost.freezed.dart';

@freezed
abstract class LikePost with _$LikePost {
  const factory LikePost({
    required bool liked,
    required int  likesCount,
  }) = _LikePost;
}