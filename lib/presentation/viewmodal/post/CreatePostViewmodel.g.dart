// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreatePostViewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreatePostViewModel)
const createPostViewModelProvider = CreatePostViewModelProvider._();

final class CreatePostViewModelProvider
    extends $NotifierProvider<CreatePostViewModel, NetworkResult<CreatePost>> {
  const CreatePostViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostViewModelHash();

  @$internal
  @override
  CreatePostViewModel create() => CreatePostViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkResult<CreatePost> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkResult<CreatePost>>(value),
    );
  }
}

String _$createPostViewModelHash() =>
    r'1675f2d32402a4f1262a34452e11c3aa4ffcd409';

abstract class _$CreatePostViewModel
    extends $Notifier<NetworkResult<CreatePost>> {
  NetworkResult<CreatePost> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<NetworkResult<CreatePost>, NetworkResult<CreatePost>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkResult<CreatePost>, NetworkResult<CreatePost>>,
              NetworkResult<CreatePost>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
