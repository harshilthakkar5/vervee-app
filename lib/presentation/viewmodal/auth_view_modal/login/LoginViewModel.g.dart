// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginViewModel)
const loginViewModelProvider = LoginViewModelProvider._();

final class LoginViewModelProvider
    extends $NotifierProvider<LoginViewModel, NetworkResult<AuthUser>> {
  const LoginViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginViewModelHash();

  @$internal
  @override
  LoginViewModel create() => LoginViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<AuthUser> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<AuthUser>>(value),
    );
  }
}

String _$loginViewModelHash() => r'61ab4b30b4b3c9c5524703f03aa75ffe3b15f2df';

abstract class _$LoginViewModel extends $Notifier<NetworkResult<AuthUser>> {
  NetworkResult<AuthUser> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<NetworkResult<AuthUser>, NetworkResult<AuthUser>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkResult<AuthUser>, NetworkResult<AuthUser>>,
              NetworkResult<AuthUser>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
