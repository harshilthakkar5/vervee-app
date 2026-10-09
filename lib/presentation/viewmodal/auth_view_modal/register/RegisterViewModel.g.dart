// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegisterViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterViewModel)
const registerViewModelProvider = RegisterViewModelProvider._();

final class RegisterViewModelProvider
    extends
        $NotifierProvider<RegisterViewModel, NetworkResult<RegisteredUser>> {
  const RegisterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerViewModelHash();

  @$internal
  @override
  RegisterViewModel create() => RegisterViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<RegisteredUser> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<RegisteredUser>>(
        value,
      ),
    );
  }
}

String _$registerViewModelHash() => r'a49d59c884e1be8f4c120ecdd00742d8545acfe2';

abstract class _$RegisterViewModel
    extends $Notifier<NetworkResult<RegisteredUser>> {
  NetworkResult<RegisteredUser> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              NetworkResult<RegisteredUser>,
              NetworkResult<RegisteredUser>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                NetworkResult<RegisteredUser>,
                NetworkResult<RegisteredUser>
              >,
              NetworkResult<RegisteredUser>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
