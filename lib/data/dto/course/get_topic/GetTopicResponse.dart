
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/course/LectureModel.dart';
//import '../../domain/course_domain.dart';

part 'GetTopicResponse.freezed.dart';
part 'GetTopicResponse.g.dart';

@freezed
abstract class GetTopicResponse with _$GetTopicResponse {
  const GetTopicResponse._();

  const factory GetTopicResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'courseId') required int courseId,
    @JsonKey(name: 'lectureTitle') required String lectureTitle,
    @JsonKey(name: 'duration') required String duration,
    @JsonKey(name: 'contentUpload') required String contentUpload,
    @JsonKey(name: 'aboutLecture') required String aboutLecture,
    @JsonKey(name: 'assignment') required dynamic assignment,
    @JsonKey(name: 'mcqs') required List<dynamic> mcqs,
    @JsonKey(name: 'passedMcq') required bool passedMcq,
  }) = _GetTopicResponse;

  factory GetTopicResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTopicResponseFromJson(json);

  LectureModel toDomain() => LectureModel(
    id: id,
    courseId: courseId,
    lectureTitle: lectureTitle,
    duration: duration,
    contentUpload: contentUpload,
    aboutLecture: aboutLecture,
  );
}