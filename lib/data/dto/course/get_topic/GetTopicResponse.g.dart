// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetTopicResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetTopicResponse _$GetTopicResponseFromJson(Map<String, dynamic> json) =>
    _GetTopicResponse(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      lectureTitle: json['lectureTitle'] as String,
      duration: json['duration'] as String,
      contentUpload: json['contentUpload'] as String,
      aboutLecture: json['aboutLecture'] as String,
      assignment: json['assignment'],
      mcqs: json['mcqs'] as List<dynamic>,
      passedMcq: json['passedMcq'] as bool,
    );

Map<String, dynamic> _$GetTopicResponseToJson(_GetTopicResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lectureTitle': instance.lectureTitle,
      'duration': instance.duration,
      'contentUpload': instance.contentUpload,
      'aboutLecture': instance.aboutLecture,
      'assignment': instance.assignment,
      'mcqs': instance.mcqs,
      'passedMcq': instance.passedMcq,
    };
