
// ─── LAYER 1B: DTO — Comment Response ────────────────────────────────────────
// File: lib/features/post/data/models/comment_response.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/post/PostComment.dart';
//import '../../domain/entities/post_comment.dart';

part 'CommentResponse.freezed.dart';
part 'CommentResponse.g.dart';

@freezed
abstract class CommentResponse with _$CommentResponse {
  const CommentResponse._();

  const factory CommentResponse({
    @JsonKey(name: 'id')        required int      id,
    @JsonKey(name: 'content')   required String   content,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'user')      required CommentUser user,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);

  PostComment toDomain() => PostComment(
    id:        id,
    content:   content,
    createdAt: createdAt,
    userName:  user.name,
    userAvatarUrl: user.avatar?.mascotUrl,
  );
}

@freezed
abstract class CommentUser with _$CommentUser {
  const factory CommentUser({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'avatar') CommentAvatar? avatar,
  }) = _CommentUser;

  factory CommentUser.fromJson(Map<String, dynamic> json) =>
      _$CommentUserFromJson(json);
}

@freezed
abstract class CommentAvatar with _$CommentAvatar {          // ✅ NEW
  const factory CommentAvatar({
    @JsonKey(name: 'mascotUrl') String? mascotUrl,
  }) = _CommentAvatar;

  factory CommentAvatar.fromJson(Map<String, dynamic> json) =>
      _$CommentAvatarFromJson(json);
}