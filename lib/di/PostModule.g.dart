// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostModule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postApi)
const postApiProvider = PostApiProvider._();

final class PostApiProvider
    extends $FunctionalProvider<PostApi, PostApi, PostApi>
    with $Provider<PostApi> {
  const PostApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postApiHash();

  @$internal
  @override
  $ProviderElement<PostApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostApi create(Ref ref) {
    return postApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostApi>(value),
    );
  }
}

String _$postApiHash() => r'450b2fbd3a0b0d1bd09d4fde2f1b37b4c5b103f0';

@ProviderFor(postRepository)
const postRepositoryProvider = PostRepositoryProvider._();

final class PostRepositoryProvider
    extends $FunctionalProvider<PostRepository, PostRepository, PostRepository>
    with $Provider<PostRepository> {
  const PostRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRepositoryHash();

  @$internal
  @override
  $ProviderElement<PostRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostRepository create(Ref ref) {
    return postRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRepository>(value),
    );
  }
}

String _$postRepositoryHash() => r'e6188cf379302742feea16d6c65f81537137cbed';
