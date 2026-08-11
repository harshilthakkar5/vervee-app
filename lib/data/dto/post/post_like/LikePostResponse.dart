
// ─── LAYER 1A: DTO — Like Post Response ──────────────────────────────────────
// File: lib/features/post/data/models/like_post_response.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/post/LikePost.dart';
//import '../../domain/entities/like_post.dart';

part 'LikePostResponse.freezed.dart';
part 'LikePostResponse.g.dart';

@freezed
abstract class LikePostResponse with _$LikePostResponse {
  const LikePostResponse._();

  const factory LikePostResponse({
    @JsonKey(name: 'liked')      required bool liked,
    @JsonKey(name: 'likesCount') required int  likesCount,
  }) = _LikePostResponse;

  factory LikePostResponse.fromJson(Map<String, dynamic> json) =>
      _$LikePostResponseFromJson(json);

  LikePost toDomain() => LikePost(
      liked: liked,
      likesCount: likesCount
  );
}