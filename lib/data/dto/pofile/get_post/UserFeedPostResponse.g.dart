// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserFeedPostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserFeedPostResponse _$UserFeedPostResponseFromJson(
  Map<String, dynamic> json,
) => _UserFeedPostResponse(
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
  isLiked: json['isLiked'] as bool,
);

Map<String, dynamic> _$UserFeedPostResponseToJson(
  _UserFeedPostResponse instance,
) => <String, dynamic>{
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
  'isLiked': instance.isLiked,
};
