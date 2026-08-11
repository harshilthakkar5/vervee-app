// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AvatarViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvatarViewModel)
const avatarViewModelProvider = AvatarViewModelProvider._();

final class AvatarViewModelProvider
    extends $NotifierProvider<AvatarViewModel, AvatarState> {
  const AvatarViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarViewModelHash();

  @$internal
  @override
  AvatarViewModel create() => AvatarViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarState>(value),
    );
  }
}

String _$avatarViewModelHash() => r'977b0bf32485cae9d2d1e197cdfca173eaa1f2fe';

abstract class _$AvatarViewModel extends $Notifier<AvatarState> {
  AvatarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AvatarState, AvatarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AvatarState, AvatarState>,
              AvatarState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
