
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/VerveeUniverseModule.dart';
import '../../../domain/repository/VerveeUniverseRepository.dart';
import '../../../utils/NetworkResult.dart';
import 'VerveeUniverseState.dart';

part 'VerveeUniverseViewModel.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  VIEW MODEL — Universe Items List  (GET /vervee-universe)
// ═══════════════════════════════════════════════════════════════════════════════
@riverpod
class VerveeUniverseViewModel extends _$VerveeUniverseViewModel {
  @override
  VerveeUniverseState build() => const VerveeUniverseState();

  VerveeUniverseRepository get _repo =>
      ref.read(verveeUniverseRepositoryProvider);

  Future<void> loadItems() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.getUniverseItems();

    result.when(
      initial: () {}, // ← required
      loading: () {}, // ← required
      success: (items) {
        state = state.copyWith(isLoading: false, items: items);
      },
      error: (message, statusCode) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  VIEW MODEL — Single Item Detail + per-chapter MCQs (GET /vervee-universe/{id})
// ═══════════════════════════════════════════════════════════════════════════════
@riverpod
class UniverseDetailViewModel extends _$UniverseDetailViewModel {
  @override
  UniverseDetailState build(int itemId) => const UniverseDetailState();

  VerveeUniverseRepository get _repo =>
      ref.read(verveeUniverseRepositoryProvider);

  Future<void> loadDetail() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.getUniverseItemDetail(itemId);

    result.when(
      initial: () {}, // ← required
      loading: () {}, // ← required
      success: (detail) {
        state = state.copyWith(isLoading: false, detail: detail);
      },
      error: (message, statusCode) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }
}

