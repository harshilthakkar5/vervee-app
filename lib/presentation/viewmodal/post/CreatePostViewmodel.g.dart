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
    r'48d3353c850ed8b1f2df32e2f12536ccc4bc4766';

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
