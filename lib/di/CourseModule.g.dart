// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CourseModule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(courseApi)
const courseApiProvider = CourseApiProvider._();

final class CourseApiProvider
    extends $FunctionalProvider<CourseApi, CourseApi, CourseApi>
    with $Provider<CourseApi> {
  const CourseApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseApiHash();

  @$internal
  @override
  $ProviderElement<CourseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseApi create(Ref ref) {
    return courseApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseApi>(value),
    );
  }
}

String _$courseApiHash() => r'83245478d7a95b4e8e061f330e3c024b59608453';

@ProviderFor(courseRepository)
const courseRepositoryProvider = CourseRepositoryProvider._();

final class CourseRepositoryProvider
    extends
        $FunctionalProvider<
          CourseRepository,
          CourseRepository,
          CourseRepository
        >
    with $Provider<CourseRepository> {
  const CourseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'courseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$courseRepositoryHash();

  @$internal
  @override
  $ProviderElement<CourseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CourseRepository create(Ref ref) {
    return courseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseRepository>(value),
    );
  }
}

String _$courseRepositoryHash() => r'9190c00d3a92c1fe02855f28267fb1340752dd91';
