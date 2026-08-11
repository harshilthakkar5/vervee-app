
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/course/CourseProgressModel.dart';
//import '../../domain/course_domain.dart';

part 'GetProgressResponse.freezed.dart';
part 'GetProgressResponse.g.dart';

@freezed
abstract class GetProgressResponse with _$GetProgressResponse {
  const GetProgressResponse._();

  const factory GetProgressResponse({
    @JsonKey(name: 'userId') required int userId,
    @JsonKey(name: 'courseId') required int courseId,
    @JsonKey(name: 'lectureId') required int lectureId,
    @JsonKey(name: 'isCompleted') required bool isCompleted,
  }) = _GetProgressResponse;

  factory GetProgressResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProgressResponseFromJson(json);

  CourseProgressModel toDomain() => CourseProgressModel(
    userId: userId,
    courseId: courseId,
    lectureId: lectureId,
    isCompleted: isCompleted,
  );
}