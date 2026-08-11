// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreatePostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePostResponse _$CreatePostResponseFromJson(Map<String, dynamic> json) =>
    _CreatePostResponse(
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
    );

Map<String, dynamic> _$CreatePostResponseToJson(_CreatePostResponse instance) =>
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
    };
