// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetPostViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetPostViewModel)
const getPostViewModelProvider = GetPostViewModelProvider._();

final class GetPostViewModelProvider
    extends $NotifierProvider<GetPostViewModel, GetPostState> {
  const GetPostViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPostViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPostViewModelHash();

  @$internal
  @override
  GetPostViewModel create() => GetPostViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPostState>(value),
    );
  }
}

String _$getPostViewModelHash() => r'c889e11eeb02e76e4c64d545b58936d131687965';

abstract class _$GetPostViewModel extends $Notifier<GetPostState> {
  GetPostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GetPostState, GetPostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GetPostState, GetPostState>,
              GetPostState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
