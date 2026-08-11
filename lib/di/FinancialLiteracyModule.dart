
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/remort/FinancialLiteracyApi.dart';
import '../data/repository/FinancialLiteracyRepositoryImpl.dart';
import '../domain/repository/FinancialLiteracyRepository.dart';
import 'AuthModule.dart';

// ── apni existing DI ke saath match karo (jaise PostRepository provider hai)
// import 'package:vervee_app/di/providers.dart';

part 'FinancialLiteracyModule.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DI PROVIDERS
//  (Apni existing DioProvider / ApiProvider ke saath match karo)
// ═══════════════════════════════════════════════════════════════════════════════

/// FinancialLiteracyApi provider
/// — apni existing dio provider inject karo (jaise PostApi provider hai)
@riverpod
FinancialLiteracyApi financialLiteracyApi(Ref ref) {
  final dio = ref.watch(dioProvider); // ← apna existing dioProvider
  return FinancialLiteracyApi(dio);
}

/// Repository provider
@riverpod
FinancialLiteracyRepository financialLiteracyRepository(Ref ref) {
  return FinancialLiteracyRepositoryImpl(
    ref.watch(financialLiteracyApiProvider),
  );
}