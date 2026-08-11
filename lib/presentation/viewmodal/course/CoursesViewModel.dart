
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/CourseModule.dart';
import '../../../domain/model/course/CourseModel.dart';
import '../../../domain/model/course/CourseProgressModel.dart';
import '../../../domain/model/course/LectureModel.dart';
import '../../../domain/repository/CourseRepository.dart';
import '../../../utils/NetworkResultForCourse.dart';
import 'CoursesState.dart';



// ══════════════════════════════════════════════════════════════
//  VIEWMODEL 1 — CoursesScreen
// ══════════════════════════════════════════════════════════════

class CoursesViewModel extends StateNotifier<CoursesState> {
  final CourseRepository _repo;

  CoursesViewModel(this._repo) : super(const CoursesState()) {
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.getAllCourses();

    switch (result) {
      case Success<List<CourseModel>>():
        state = state.copyWith(isLoading: false, courses: result.data);
      case Failure<List<CourseModel>>():
        state = state.copyWith(
            isLoading: false, errorMessage: result.message);
    }
  }
}

final coursesViewModelProvider =
StateNotifierProvider<CoursesViewModel, CoursesState>((ref) {
  return CoursesViewModel(ref.watch(courseRepositoryProvider));
});


// ══════════════════════════════════════════════════════════════
//  VIEWMODEL 2 — CourseDetailScreen
//  courseId pass karke use karo
// ══════════════════════════════════════════════════════════════

class CourseDetailViewModel extends StateNotifier<CourseDetailState> {
  final CourseRepository _repo;
  final int courseId;

  CourseDetailViewModel(this._repo, this.courseId)
      : super(const CourseDetailState()) {
    fetchCourseDetail();
  }

  Future<void> fetchCourseDetail() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Course detail + progress parallel fetch karo
    final results = await Future.wait([
      _repo.getCourse(courseId),
      _repo.getProgress(courseId),
    ]);

    final courseResult = results[0] as NetworkResult<CourseModel>;
    final progressResult = results[1] as NetworkResult<CourseProgressModel>;

    CourseModel? course;
    CourseProgressModel? progress;
    String? error;

    switch (courseResult) {
      case Success<CourseModel>():
        course = courseResult.data;
      case Failure<CourseModel>():
        error = courseResult.message;
    }

    // Progress optional hai — error ignore karo
    if (progressResult case Success<CourseProgressModel>()) {
      progress = progressResult.data;
    }

    state = state.copyWith(
      isLoading: false,
      course: course,
      progress: progress,
      errorMessage: error,
    );
  }
}

// courseId ke saath provider banao
final courseDetailViewModelProvider = StateNotifierProvider.family<
    CourseDetailViewModel, CourseDetailState, int>((ref, courseId) {
  return CourseDetailViewModel(ref.watch(courseRepositoryProvider), courseId);
});

// ══════════════════════════════════════════════════════════════
//  VIEWMODEL 3 — CoursePlayerScreen
//  (courseId, lectureId, allLectures) pass karo
// ══════════════════════════════════════════════════════════════

typedef CoursePlayerArgs = ({
int courseId,
int lectureId,
int currentIndex,
List<LectureModel> allLectures
});

class CoursePlayerViewModel extends StateNotifier<CoursePlayerState> {
  final CourseRepository _repo;
  final CoursePlayerArgs _args;

  CoursePlayerViewModel(this._repo, this._args)
      : super(CoursePlayerState(currentIndex: _args.currentIndex)) {
    fetchLecture(_args.lectureId);
  }

  Future<void> fetchLecture(int lectureId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final results = await Future.wait([
      _repo.getLecture(_args.courseId, lectureId),
      _repo.getProgress(_args.courseId),
    ]);

    final lectureResult = results[0] as NetworkResult<LectureModel>;
    final progressResult = results[1] as NetworkResult<CourseProgressModel>;

    LectureModel? lecture;
    CourseProgressModel? progress;
    String? error;

    switch (lectureResult) {
      case Success<LectureModel>():
        lecture = lectureResult.data;
      case Failure<LectureModel>():
        error = lectureResult.message;
    }

    if (progressResult case Success<CourseProgressModel>()) {
      progress = progressResult.data;
    }

    state = state.copyWith(
      isLoading: false,
      lecture: lecture,
      progress: progress,
      errorMessage: error,
    );
  }

  // User dusre lecture pe tap kare tab
  Future<void> switchLecture(int index) async {
    final lecture = _args.allLectures[index];
    state = state.copyWith(currentIndex: index);
    await fetchLecture(lecture.id);
  }
}

final coursePlayerViewModelProvider = StateNotifierProvider.family<
    CoursePlayerViewModel, CoursePlayerState, CoursePlayerArgs>((ref, args) {
  return CoursePlayerViewModel(ref.watch(courseRepositoryProvider), args);
});
