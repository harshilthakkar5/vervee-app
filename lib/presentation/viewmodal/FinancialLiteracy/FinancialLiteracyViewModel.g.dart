// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FinancialLiteracyViewModel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FinancialLiteracyViewModel)
const financialLiteracyViewModelProvider =
    FinancialLiteracyViewModelProvider._();

final class FinancialLiteracyViewModelProvider
    extends
        $NotifierProvider<FinancialLiteracyViewModel, FinancialLiteracyState> {
  const FinancialLiteracyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialLiteracyViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialLiteracyViewModelHash();

  @$internal
  @override
  FinancialLiteracyViewModel create() => FinancialLiteracyViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialLiteracyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialLiteracyState>(value),
    );
  }
}

String _$financialLiteracyViewModelHash() =>
    r'dbb2d1a1868627b13cfe559265dd1168a35d6100';

abstract class _$FinancialLiteracyViewModel
    extends $Notifier<FinancialLiteracyState> {
  FinancialLiteracyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<FinancialLiteracyState, FinancialLiteracyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FinancialLiteracyState, FinancialLiteracyState>,
              FinancialLiteracyState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CourseDetailViewModel)
const courseDetailViewModelProvider = CourseDetailViewModelFamily._();

final class CourseDetailViewModelProvider
    extends $NotifierProvider<CourseDetailViewModel, CourseDetailState> {
  const CourseDetailViewModelProvider._({
    required CourseDetailViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'courseDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$courseDetailViewModelHash();

  @override
  String toString() {
    return r'courseDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CourseDetailViewModel create() => CourseDetailViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CourseDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CourseDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CourseDetailViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$courseDetailViewModelHash() =>
    r'f72cea7e8adfcb353f774b93cde31e89624d5429';

final class CourseDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          CourseDetailViewModel,
          CourseDetailState,
          CourseDetailState,
          CourseDetailState,
          int
        > {
  const CourseDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'courseDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CourseDetailViewModelProvider call(int courseId) =>
      CourseDetailViewModelProvider._(argument: courseId, from: this);

  @override
  String toString() => r'courseDetailViewModelProvider';
}

abstract class _$CourseDetailViewModel extends $Notifier<CourseDetailState> {
  late final _$args = ref.$arg as int;
  int get courseId => _$args;

  CourseDetailState build(int courseId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<CourseDetailState, CourseDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CourseDetailState, CourseDetailState>,
              CourseDetailState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
