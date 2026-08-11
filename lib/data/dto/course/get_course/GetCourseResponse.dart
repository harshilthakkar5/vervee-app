
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/course/CourseModel.dart';
import '../../../../domain/model/course/LectureModel.dart';

//import '../../domain/course_domain.dart';

// part '../get_single_course/GetCourseResponse.freezed.dart';
// part '../get_single_course/GetCourseResponse.g.dart';

part 'GetCourseResponse.freezed.dart';
part 'GetCourseResponse.g.dart';

List<GetCourseResponse> getCourseResponseFromJson(String str) =>
    List<GetCourseResponse>.from(
      json.decode(str).map((x) => GetCourseResponse.fromJson(x)),
    );

@freezed
abstract class GetCourseResponse with _$GetCourseResponse {
  const GetCourseResponse._();

  const factory GetCourseResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'courseTitle') required String courseTitle,
    @JsonKey(name: 'subtitle') required String subtitle,
    @JsonKey(name: 'courseDescription') required String courseDescription,
    @JsonKey(name: 'courseLevel') required String courseLevel,
    @JsonKey(name: 'price') required String price,
    @JsonKey(name: 'language') required String language,
    @JsonKey(name: 'requirements') required String requirements,
    @JsonKey(name: 'whatYoullLearn') required String whatYoullLearn,
    @JsonKey(name: 'whoThisCourseIsFor') required String whoThisCourseIsFor,
    @JsonKey(name: 'isPublished') required bool isPublished,
    @JsonKey(name: 'category') required String category,
    @JsonKey(name: 'videoPreview') required String videoPreview,
    @JsonKey(name: 'thumbnailPreview') required String thumbnailPreview,
    @JsonKey(name: 'lectures') required List<CourseLectureDto> lectures,
  }) = _GetCourseResponse;

  factory GetCourseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCourseResponseFromJson(json);

  CourseModel toDomain() => CourseModel(
    id: id,
    courseTitle: courseTitle,
    subtitle: subtitle,
    courseDescription: courseDescription,
    courseLevel: courseLevel,
    language: language,
    category: category,
    videoPreview: videoPreview,
    thumbnailPreview: thumbnailPreview,
    lectures: lectures.map((l) => l.toDomain()).toList(),
  );
}

@freezed
abstract class CourseLectureDto with _$CourseLectureDto {
  const CourseLectureDto._();

  const factory CourseLectureDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'courseId') required int courseId,
    @JsonKey(name: 'lectureTitle') required String lectureTitle,
    @JsonKey(name: 'duration') required String duration,
    @JsonKey(name: 'contentUpload') required String contentUpload,
    @JsonKey(name: 'aboutLecture') required String aboutLecture,
    @JsonKey(name: 'assignment') required dynamic assignment,
  }) = _CourseLectureDto;

  factory CourseLectureDto.fromJson(Map<String, dynamic> json) =>
      _$CourseLectureDtoFromJson(json);

  LectureModel toDomain() => LectureModel(
    id: id,
    courseId: courseId,
    lectureTitle: lectureTitle,
    duration: duration,
    contentUpload: contentUpload,
    aboutLecture: aboutLecture,
  );
}