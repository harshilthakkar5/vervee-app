// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetProgressResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetProgressResponse _$GetProgressResponseFromJson(Map<String, dynamic> json) =>
    _GetProgressResponse(
      userId: (json['userId'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      lectureId: (json['lectureId'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$GetProgressResponseToJson(
  _GetProgressResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'courseId': instance.courseId,
  'lectureId': instance.lectureId,
  'isCompleted': instance.isCompleted,
};
