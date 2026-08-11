// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetPostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetPostResponse _$GetPostResponseFromJson(Map<String, dynamic> json) =>
    _GetPostResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      mimeType: json['mimeType'] as String?,
      category: json['category'] as String,
      filePath: json['filePath'] as String?,
      fileType: json['fileType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isLiked: json['isLiked'] as bool,
      isOwner: json['isOwner'] as bool,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$GetPostResponseToJson(_GetPostResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'mimeType': instance.mimeType,
      'category': instance.category,
      'filePath': instance.filePath,
      'fileType': instance.fileType,
      'createdAt': instance.createdAt.toIso8601String(),
      'likesCount': instance.likesCount,
      'userId': instance.userId,
      'user': instance.user,
      'isLiked': instance.isLiked,
      'isOwner': instance.isOwner,
      'userName': instance.userName,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  name: json['name'] as String,
  role: json['role'] as String,
  avatar: json['avatar'] == null
      ? null
      : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'name': instance.name,
  'role': instance.role,
  'avatar': instance.avatar,
};

_Avatar _$AvatarFromJson(Map<String, dynamic> json) =>
    _Avatar(mascotUrl: json['mascotUrl'] as String?);

Map<String, dynamic> _$AvatarToJson(_Avatar instance) => <String, dynamic>{
  'mascotUrl': instance.mascotUrl,
};
