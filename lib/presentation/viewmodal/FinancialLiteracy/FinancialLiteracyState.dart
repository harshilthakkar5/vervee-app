
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';
import '../../../domain/model/FinancialLiteracy/FinancialLiteracyDetail.dart';
// import 'financial_literacy_dto.dart';
// import 'financial_literacy_repository.dart';

part 'FinancialLiteracyState.freezed.dart';
//part 'FinancialLiteracyState.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  STATES — ProfileInfoState jaisa Freezed sealed pattern
// ═══════════════════════════════════════════════════════════════════════════════

// ── Courses list state ────────────────────────────────────────────────────────
@freezed
sealed class FinancialLiteracyState with _$FinancialLiteracyState {
  const factory FinancialLiteracyState({
    @Default([])    List<FinancialLiteracyCourse> courses,
    @Default(false) bool                          isLoading,
    String?                                       errorMessage,
  }) = _FinancialLiteracyState;
}

// ── Single course detail state ────────────────────────────────────────────────
@freezed
sealed class CourseDetailState with _$CourseDetailState {
  const factory CourseDetailState({
    FinancialLiteracyDetail? detail,
    @Default(false) bool     isLoading,
    String?                  errorMessage,
  }) = _CourseDetailState;
}