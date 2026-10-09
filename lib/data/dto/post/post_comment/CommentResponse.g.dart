// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) =>
    _CommentResponse(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: CommentUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentResponseToJson(_CommentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'user': instance.user,
    };

_CommentUser _$CommentUserFromJson(Map<String, dynamic> json) => _CommentUser(
  name: json['name'] as String,
  avatar: json['avatar'] == null
      ? null
      : CommentAvatar.fromJson(json['avatar'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CommentUserToJson(_CommentUser instance) =>
    <String, dynamic>{'name': instance.name, 'avatar': instance.avatar};

_CommentAvatar _$CommentAvatarFromJson(Map<String, dynamic> json) =>
    _CommentAvatar(mascotUrl: json['mascotUrl'] as String?);

Map<String, dynamic> _$CommentAvatarToJson(_CommentAvatar instance) =>
    <String, dynamic>{'mascotUrl': instance.mascotUrl};
