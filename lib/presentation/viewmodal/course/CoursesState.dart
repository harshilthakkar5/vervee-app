
//import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/model/course/CourseModel.dart';
import '../../../domain/model/course/CourseProgressModel.dart';
import '../../../domain/model/course/LectureModel.dart';

// import '../../domain/course_domain.dart';
// import '../../data/course_repository.dart';
// import '../../di/CourseModule.dart';

// ══════════════════════════════════════════════════════════════
//  STATE CLASSES
// ══════════════════════════════════════════════════════════════

class CoursesState {
  final bool isLoading;
  final List<CourseModel> courses;
  final String? errorMessage;

  const CoursesState({
    this.isLoading = false,
    this.courses = const [],
    this.errorMessage,
  });

  CoursesState copyWith({
    bool? isLoading,
    List<CourseModel>? courses,
    String? errorMessage,
  }) =>
      CoursesState(
        isLoading: isLoading ?? this.isLoading,
        courses: courses ?? this.courses,
        errorMessage: errorMessage,
      );
}

class CourseDetailState {
  final bool isLoading;
  final CourseModel? course;
  final CourseProgressModel? progress;
  final String? errorMessage;

  const CourseDetailState({
    this.isLoading = false,
    this.course,
    this.progress,
    this.errorMessage,
  });

  CourseDetailState copyWith({
    bool? isLoading,
    CourseModel? course,
    CourseProgressModel? progress,
    String? errorMessage,
  }) =>
      CourseDetailState(
        isLoading: isLoading ?? this.isLoading,
        course: course ?? this.course,
        progress: progress ?? this.progress,
        errorMessage: errorMessage,
      );
}

class CoursePlayerState {
  final bool isLoading;
  final LectureModel? lecture;
  final CourseProgressModel? progress;
  final String? errorMessage;

  // currently playing lecture index in the full lecture list
  final int currentIndex;

  const CoursePlayerState({
    this.isLoading = false,
    this.lecture,
    this.progress,
    this.errorMessage,
    this.currentIndex = 0,
  });

  CoursePlayerState copyWith({
    bool? isLoading,
    LectureModel? lecture,
    CourseProgressModel? progress,
    String? errorMessage,
    int? currentIndex,
  }) =>
      CoursePlayerState(
        isLoading: isLoading ?? this.isLoading,
        lecture: lecture ?? this.lecture,
        progress: progress ?? this.progress,
        errorMessage: errorMessage,
        currentIndex: currentIndex ?? this.currentIndex,
      );
}