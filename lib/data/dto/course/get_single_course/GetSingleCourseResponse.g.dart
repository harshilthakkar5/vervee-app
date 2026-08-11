// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetSingleCourseResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetSingleCourseResponse _$GetSingleCourseResponseFromJson(
  Map<String, dynamic> json,
) => _GetSingleCourseResponse(
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
      .map((e) => SingleCourseLectureDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetSingleCourseResponseToJson(
  _GetSingleCourseResponse instance,
) => <String, dynamic>{
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

_SingleCourseLectureDto _$SingleCourseLectureDtoFromJson(
  Map<String, dynamic> json,
) => _SingleCourseLectureDto(
  id: (json['id'] as num).toInt(),
  aboutLecture: json['aboutLecture'] as String,
  contentUpload: json['contentUpload'] as String,
  assignment: json['assignment'],
  lectureTitle: json['lectureTitle'] as String,
  duration: json['duration'] as String,
  mcqs: json['mcqs'] as List<dynamic>,
);

Map<String, dynamic> _$SingleCourseLectureDtoToJson(
  _SingleCourseLectureDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'aboutLecture': instance.aboutLecture,
  'contentUpload': instance.contentUpload,
  'assignment': instance.assignment,
  'lectureTitle': instance.lectureTitle,
  'duration': instance.duration,
  'mcqs': instance.mcqs,
};
