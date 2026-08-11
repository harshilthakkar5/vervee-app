// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AvatarModule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(avatarApi)
const avatarApiProvider = AvatarApiProvider._();

final class AvatarApiProvider
    extends $FunctionalProvider<AvatarApi, AvatarApi, AvatarApi>
    with $Provider<AvatarApi> {
  const AvatarApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarApiHash();

  @$internal
  @override
  $ProviderElement<AvatarApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarApi create(Ref ref) {
    return avatarApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarApi>(value),
    );
  }
}

String _$avatarApiHash() => r'99849192697fc02062fbdcf11f7c79c68598c4d2';

@ProviderFor(avatarRepository)
const avatarRepositoryProvider = AvatarRepositoryProvider._();

final class AvatarRepositoryProvider
    extends
        $FunctionalProvider<
          AvatarRepository,
          AvatarRepository,
          AvatarRepository
        >
    with $Provider<AvatarRepository> {
  const AvatarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarRepositoryHash();

  @$internal
  @override
  $ProviderElement<AvatarRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarRepository create(Ref ref) {
    return avatarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarRepository>(value),
    );
  }
}

String _$avatarRepositoryHash() => r'b658fcceff2e4ec73beab25814c639993bdbfaf4';
