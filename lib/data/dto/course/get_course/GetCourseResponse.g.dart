// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetCourseResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCourseResponse _$GetCourseResponseFromJson(Map<String, dynamic> json) =>
    _GetCourseResponse(
      id: (json['id'] as num).toInt(),
      courseTitle: json['courseTitle'] as String,
      subtitle: json['subtitle'] as String,
      courseDescription: json['courseDescription'] as String,
      courseLevel: json['courseLevel'] as String,
      price: json['price'] as String,
      language: json['language'] as String,
      requirements: json['requirements'] as String,
      whatYoullLearn: json['whatYoullLearn'] as String,
      whoThisCourseIsFor: json['whoThisCourseIsFor'] as String,
      isPublished: json['isPublished'] as bool,
      category: json['category'] as String,
      videoPreview: json['videoPreview'] as String,
      thumbnailPreview: json['thumbnailPreview'] as String,
      lectures: (json['lectures'] as List<dynamic>)
          .map((e) => CourseLectureDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCourseResponseToJson(_GetCourseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseTitle': instance.courseTitle,
      'subtitle': instance.subtitle,
      'courseDescription': instance.courseDescription,
      'courseLevel': instance.courseLevel,
      'price': instance.price,
      'language': instance.language,
      'requirements': instance.requirements,
      'whatYoullLearn': instance.whatYoullLearn,
      'whoThisCourseIsFor': instance.whoThisCourseIsFor,
      'isPublished': instance.isPublished,
      'category': instance.category,
      'videoPreview': instance.videoPreview,
      'thumbnailPreview': instance.thumbnailPreview,
      'lectures': instance.lectures,
    };

_CourseLectureDto _$CourseLectureDtoFromJson(Map<String, dynamic> json) =>
    _CourseLectureDto(
      id: (json['id'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      lectureTitle: json['lectureTitle'] as String,
      duration: json['duration'] as String,
      contentUpload: json['contentUpload'] as String,
      aboutLecture: json['aboutLecture'] as String,
      assignment: json['assignment'],
    );

Map<String, dynamic> _$CourseLectureDtoToJson(_CourseLectureDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'lectureTitle': instance.lectureTitle,
      'duration': instance.duration,
      'contentUpload': instance.contentUpload,
      'aboutLecture': instance.aboutLecture,
      'assignment': instance.assignment,
    };
