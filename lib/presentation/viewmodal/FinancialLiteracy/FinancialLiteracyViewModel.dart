
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../di/FinancialLiteracyModule.dart';
import '../../../domain/repository/FinancialLiteracyRepository.dart';
import '../../../utils/NetworkResult.dart';
import 'FinancialLiteracyState.dart';


//part 'FinancialLiteracyViewModel.freezed.dart';
part 'FinancialLiteracyViewModel.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  VIEW MODEL — Courses List
// ═══════════════════════════════════════════════════════════════════════════════
@riverpod
class FinancialLiteracyViewModel extends _$FinancialLiteracyViewModel {
  @override
  FinancialLiteracyState build() => const FinancialLiteracyState();

  FinancialLiteracyRepository get _repo =>
      ref.read(financialLiteracyRepositoryProvider);

  Future<void> loadCourses() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.getCourses();

    result.when(
      initial: () {},                          // ← required
      loading: () {},                          // ← required
      success: (courses) {
        state = state.copyWith(isLoading: false, courses: courses);
      },
      error: (message, statusCode) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  VIEW MODEL — Single Course Detail + MCQs
// ═══════════════════════════════════════════════════════════════════════════════
@riverpod
class CourseDetailViewModel extends _$CourseDetailViewModel {
  @override
  CourseDetailState build(int courseId) => const CourseDetailState();

  FinancialLiteracyRepository get _repo =>
      ref.read(financialLiteracyRepositoryProvider);

  Future<void> loadDetail() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.getCourseDetail(courseId);

    result.when(
      initial: () {},                          // ← required
      loading: () {},                          // ← required
      success: (detail) {
        state = state.copyWith(isLoading: false, detail: detail);
      },
      error: (message, statusCode) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }
}




























