
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/VerveeUniverse/VerveeUniverseDetail.dart';
import '../../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';

part 'VerveeUniverseState.freezed.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  STATES
// ═══════════════════════════════════════════════════════════════════════════════

// ── Items list state ────────────────────────────────────────────────────────
@freezed
sealed class VerveeUniverseState with _$VerveeUniverseState {
  const factory VerveeUniverseState({
    @Default([]) List<VerveeUniverseItem> items,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _VerveeUniverseState;
}

// ── Single item detail state ──────────────────────────────────────────────────
@freezed
sealed class UniverseDetailState with _$UniverseDetailState {
  const factory UniverseDetailState({
    VerveeUniverseDetail? detail,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _UniverseDetailState;
}