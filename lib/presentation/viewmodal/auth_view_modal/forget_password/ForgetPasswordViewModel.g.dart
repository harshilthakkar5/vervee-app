// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ForgetPasswordViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForgetPasswordViewModel)
const forgetPasswordViewModelProvider = ForgetPasswordViewModelProvider._();

final class ForgetPasswordViewModelProvider
    extends $NotifierProvider<ForgetPasswordViewModel, NetworkResult<String>> {
  const ForgetPasswordViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgetPasswordViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgetPasswordViewModelHash();

  @$internal
  @override
  ForgetPasswordViewModel create() => ForgetPasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<String>>(value),
    );
  }
}

String _$forgetPasswordViewModelHash() =>
    r'c8365456aac399cf51e717d7e465b147c68d7d82';

abstract class _$ForgetPasswordViewModel
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
