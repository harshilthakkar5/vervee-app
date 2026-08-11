
import 'package:freezed_annotation/freezed_annotation.dart';

import 'CourseProgressModel.dart';
import 'LectureModel.dart';

part 'CourseModel.freezed.dart';

// ══════════════════════════════════════════════════════════════
//  DOMAIN MODELS — Courses Feature
// ══════════════════════════════════════════════════════════════

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required int id,
    required String courseTitle,
    required String subtitle,
    required String courseDescription,
    required String courseLevel,
    required String language,
    required String category,
    required String videoPreview,
    required String thumbnailPreview,
    required List<LectureModel> lectures,
  }) = _CourseModel;

  const CourseModel._();
  int get lectureCount => lectures.length;
}