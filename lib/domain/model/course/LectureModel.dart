
import 'package:freezed_annotation/freezed_annotation.dart';

//import 'CourseProgressModel.dart';

part 'LectureModel.freezed.dart';

@freezed
abstract class LectureModel with _$LectureModel {
  const factory LectureModel({
    required int id,
    required int courseId,
    required String lectureTitle,
    required String duration,
    required String contentUpload,
    required String aboutLecture,
  }) = _LectureModel;
}