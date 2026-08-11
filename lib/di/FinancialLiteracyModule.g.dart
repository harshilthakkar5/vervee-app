// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FinancialLiteracyModule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// FinancialLiteracyApi provider
/// — apni existing dio provider inject karo (jaise PostApi provider hai)

@ProviderFor(financialLiteracyApi)
const financialLiteracyApiProvider = FinancialLiteracyApiProvider._();

/// FinancialLiteracyApi provider
/// — apni existing dio provider inject karo (jaise PostApi provider hai)

final class FinancialLiteracyApiProvider
    extends
        $FunctionalProvider<
          FinancialLiteracyApi,
          FinancialLiteracyApi,
          FinancialLiteracyApi
        >
    with $Provider<FinancialLiteracyApi> {
  /// FinancialLiteracyApi provider
  /// — apni existing dio provider inject karo (jaise PostApi provider hai)
  const FinancialLiteracyApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialLiteracyApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialLiteracyApiHash();

  @$internal
  @override
  $ProviderElement<FinancialLiteracyApi> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinancialLiteracyApi create(Ref ref) {
    return financialLiteracyApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialLiteracyApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialLiteracyApi>(value),
    );
  }
}

String _$financialLiteracyApiHash() =>
    r'272d00c80fc876241d6b6770d1368413487e6553';

/// Repository provider

@ProviderFor(financialLiteracyRepository)
const financialLiteracyRepositoryProvider =
    FinancialLiteracyRepositoryProvider._();

/// Repository provider

final class FinancialLiteracyRepositoryProvider
    extends
        $FunctionalProvider<
          FinancialLiteracyRepository,
          FinancialLiteracyRepository,
          FinancialLiteracyRepository
        >
    with $Provider<FinancialLiteracyRepository> {
  /// Repository provider
  const FinancialLiteracyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialLiteracyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialLiteracyRepositoryHash();

  @$internal
  @override
  $ProviderElement<FinancialLiteracyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinancialLiteracyRepository create(Ref ref) {
    return financialLiteracyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialLiteracyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialLiteracyRepository>(value),
    );
  }
}

String _$financialLiteracyRepositoryHash() =>
    r'fac615bea7658c815e6bb205e57f73a393cc5a14';
