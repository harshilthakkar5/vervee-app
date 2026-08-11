
import 'package:freezed_annotation/freezed_annotation.dart';

//import 'CourseProgressModel.dart';

part 'CourseProgressModel.freezed.dart';

@freezed
abstract class CourseProgressModel with _$CourseProgressModel {
  const factory CourseProgressModel({
    required int userId,
    required int courseId,
    required int lectureId,
    required bool isCompleted,
  }) = _CourseProgressModel;
}