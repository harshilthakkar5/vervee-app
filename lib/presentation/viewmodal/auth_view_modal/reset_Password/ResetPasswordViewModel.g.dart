// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResetPasswordViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordViewModel)
const resetPasswordViewModelProvider = ResetPasswordViewModelProvider._();

final class ResetPasswordViewModelProvider
    extends $NotifierProvider<ResetPasswordViewModel, NetworkResult<String>> {
  const ResetPasswordViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordViewModelHash();

  @$internal
  @override
  ResetPasswordViewModel create() => ResetPasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<String>>(value),
    );
  }
}

String _$resetPasswordViewModelHash() =>
    r'a4430e9868ce18c28cf9e4e264dd15d9cd15bb5e';

abstract class _$ResetPasswordViewModel
    extends $Notifier<NetworkResult<String>> {
  NetworkResult<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NetworkResult<String>, NetworkResult<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkResult<String>, NetworkResult<String>>,
              NetworkResult<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
