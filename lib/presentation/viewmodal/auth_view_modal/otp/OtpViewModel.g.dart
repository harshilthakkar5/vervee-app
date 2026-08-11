// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OtpViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OtpViewModel)
const otpViewModelProvider = OtpViewModelProvider._();

final class OtpViewModelProvider
    extends $NotifierProvider<OtpViewModel, NetworkResult<OtpResult>> {
  const OtpViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpViewModelHash();

  @$internal
  @override
  OtpViewModel create() => OtpViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<OtpResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<OtpResult>>(value),
    );
  }
}

String _$otpViewModelHash() => r'0a0b1746f78311cb4ce26f4e7546b0c8f8e45058';

abstract class _$OtpViewModel extends $Notifier<NetworkResult<OtpResult>> {
  NetworkResult<OtpResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<NetworkResult<OtpResult>, NetworkResult<OtpResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkResult<OtpResult>, NetworkResult<OtpResult>>,
              NetworkResult<OtpResult>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
