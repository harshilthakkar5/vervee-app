
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/remort/VerveeUniverseApi.dart';
import '../data/repository/VerveeUniverseRepositoryImpl.dart';
import '../domain/repository/VerveeUniverseRepository.dart';
import 'AuthModule.dart';

// apni existing dioProvider AuthModule me he — usi ko reuse kiya he
// (FinancialLiteracyModule jaisa)

part 'VerveeUniverseModule.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DI PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════════

/// VerveeUniverseApi provider
@riverpod
VerveeUniverseApi verveeUniverseApi(Ref ref) {
  final dio = ref.watch(dioProvider); // ← existing dioProvider
  return VerveeUniverseApi(dio);
}

/// Repository provider
@riverpod
VerveeUniverseRepository verveeUniverseRepository(Ref ref) {
  return VerveeUniverseRepositoryImpl(
    ref.watch(verveeUniverseApiProvider),
  );
}
