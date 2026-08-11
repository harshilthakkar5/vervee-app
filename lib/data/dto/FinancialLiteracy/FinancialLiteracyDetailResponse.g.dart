// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FinancialLiteracyDetailResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialLiteracyDetailDto _$FinancialLiteracyDetailDtoFromJson(
  Map<String, dynamic> json,
) => _FinancialLiteracyDetailDto(
  id: (json['id'] as num).toInt(),
  learnAboutFinancialTitle: json['learnAboutFinancialTitle'] as String,
  learnAboutFinancialSubtitle: json['learnAboutFinancialSubtitle'] as String,
  content: json['content'] as String,
  file: json['file'] as String?,
  thumbnail: json['thumbnail'] as String?,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  likesCount: (json['likesCount'] as num).toInt(),
  isLiked: json['isLiked'] as bool? ?? false,
  isOwner: json['isOwner'] as bool? ?? false,
  userName: json['userName'] as String?,
  videos:
      (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mcqs:
      (json['mcqs'] as List<dynamic>?)
          ?.map((e) => McqDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FinancialLiteracyDetailDtoToJson(
  _FinancialLiteracyDetailDto instance,
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
  'userName': instance.userName,
  'videos': instance.videos,
  'mcqs': instance.mcqs,
};

_McqOptionDto _$McqOptionDtoFromJson(Map<String, dynamic> json) =>
    _McqOptionDto(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
      mcqId: (json['mcqId'] as num).toInt(),
    );

Map<String, dynamic> _$McqOptionDtoToJson(_McqOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isCorrect': instance.isCorrect,
      'mcqId': instance.mcqId,
    };

_McqDto _$McqDtoFromJson(Map<String, dynamic> json) => _McqDto(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  learnAboutFinancialId: (json['learnAboutFinancialId'] as num).toInt(),
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => McqOptionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$McqDtoToJson(_McqDto instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'learnAboutFinancialId': instance.learnAboutFinancialId,
  'options': instance.options,
};
