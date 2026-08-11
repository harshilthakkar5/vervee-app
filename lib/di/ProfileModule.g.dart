// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfileModule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileApi)
const profileApiProvider = ProfileApiProvider._();

final class ProfileApiProvider
    extends $FunctionalProvider<ProfileApi, ProfileApi, ProfileApi>
    with $Provider<ProfileApi> {
  const ProfileApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileApiHash();

  @$internal
  @override
  $ProviderElement<ProfileApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileApi create(Ref ref) {
    return profileApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileApi>(value),
    );
  }
}

String _$profileApiHash() => r'56ee6c64efd7dd9c9f6bc5be16b58fb8f7373c1d';

@ProviderFor(profileRepository)
const profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  const ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'8d24988114ce009741eb8b2b34dd2c57c4af6bd4';
