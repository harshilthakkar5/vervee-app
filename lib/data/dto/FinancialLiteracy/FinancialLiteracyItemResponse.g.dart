// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FinancialLiteracyItemResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialLiteracyItemDto _$FinancialLiteracyItemDtoFromJson(
  Map<String, dynamic> json,
) => _FinancialLiteracyItemDto(
  id: (json['id'] as num).toInt(),
  learnAboutFinancialTitle: json['learnAboutFinancialTitle'] as String,
  learnAboutFinancialSubtitle: json['learnAboutFinancialSubtitle'] as String,
  content: json['content'] as String,
  file: json['file'] as String?,
  thumbnail: json['thumbnail'] as String?,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  likesCount: (json['likesCount'] as num).toInt(),
  isLiked: json['isLiked'] as bool,
  isOwner: json['isOwner'] as bool,
  videos:
      (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FinancialLiteracyItemDtoToJson(
  _FinancialLiteracyItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'learnAboutFinancialTitle': instance.learnAboutFinancialTitle,
  'learnAboutFinancialSubtitle': instance.learnAboutFinancialSubtitle,
  'content': instance.content,
  'file': instance.file,
  'thumbnail': instance.thumbnail,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'likesCount': instance.likesCount,
  'isLiked': instance.isLiked,
  'isOwner': instance.isOwner,
  'videos': instance.videos,
};

_VideoDto _$VideoDtoFromJson(Map<String, dynamic> json) => _VideoDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  learnAboutFinancialId: (json['learnAboutFinancialId'] as num).toInt(),
  contentUpload: json['contentUpload'] as String?,
);

Map<String, dynamic> _$VideoDtoToJson(_VideoDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'learnAboutFinancialId': instance.learnAboutFinancialId,
  'contentUpload': instance.contentUpload,
};
