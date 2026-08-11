
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/course/CourseModel.dart';
import '../../../../domain/model/course/LectureModel.dart';
//import '../../domain/course_domain.dart';

part 'GetSingleCourseResponse.freezed.dart';
part 'GetSingleCourseResponse.g.dart';

@freezed
abstract class GetSingleCourseResponse with _$GetSingleCourseResponse {
  const GetSingleCourseResponse._();

  const factory GetSingleCourseResponse({
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
    @JsonKey(name: 'lectures') required List<SingleCourseLectureDto> lectures,
  }) = _GetSingleCourseResponse;

  factory GetSingleCourseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSingleCourseResponseFromJson(json);

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
abstract class SingleCourseLectureDto with _$SingleCourseLectureDto {
  const SingleCourseLectureDto._();

  const factory SingleCourseLectureDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'aboutLecture') required String aboutLecture,
    @JsonKey(name: 'contentUpload') required String contentUpload,
    @JsonKey(name: 'assignment') required dynamic assignment,
    @JsonKey(name: 'lectureTitle') required String lectureTitle,
    @JsonKey(name: 'duration') required String duration,
    @JsonKey(name: 'mcqs') required List<dynamic> mcqs,
  }) = _SingleCourseLectureDto;

  factory SingleCourseLectureDto.fromJson(Map<String, dynamic> json) =>
      _$SingleCourseLectureDtoFromJson(json);

  LectureModel toDomain() => LectureModel(
    id: id,
    courseId: 0, // single course response mein courseId nahi aata
    lectureTitle: lectureTitle,
    duration: duration,
    contentUpload: contentUpload,
    aboutLecture: aboutLecture,
  );
}