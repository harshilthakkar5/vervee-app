// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProfileViewmodels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileInfoViewModel)
const profileInfoViewModelProvider = ProfileInfoViewModelProvider._();

final class ProfileInfoViewModelProvider
    extends $NotifierProvider<ProfileInfoViewModel, ProfileInfoState> {
  const ProfileInfoViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileInfoViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileInfoViewModelHash();

  @$internal
  @override
  ProfileInfoViewModel create() => ProfileInfoViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileInfoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileInfoState>(value),
    );
  }
}

String _$profileInfoViewModelHash() =>
    r'7f02da3d92110b077ccbb33a556497320642a74c';

abstract class _$ProfileInfoViewModel extends $Notifier<ProfileInfoState> {
  ProfileInfoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileInfoState, ProfileInfoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileInfoState, ProfileInfoState>,
              ProfileInfoState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChangePasswordViewModel)
const changePasswordViewModelProvider = ChangePasswordViewModelProvider._();

final class ChangePasswordViewModelProvider
    extends $NotifierProvider<ChangePasswordViewModel, ChangePasswordState> {
  const ChangePasswordViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordViewModelHash();

  @$internal
  @override
  ChangePasswordViewModel create() => ChangePasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePasswordState>(value),
    );
  }
}

String _$changePasswordViewModelHash() =>
    r'6f402fdb7eb5918af66b5ca70f24d9755ac70921';

abstract class _$ChangePasswordViewModel
    extends $Notifier<ChangePasswordState> {
  ChangePasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChangePasswordState, ChangePasswordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChangePasswordState, ChangePasswordState>,
              ChangePasswordState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserFeedViewModel)
const userFeedViewModelProvider = UserFeedViewModelProvider._();

final class UserFeedViewModelProvider
    extends $NotifierProvider<UserFeedViewModel, UserFeedState> {
  const UserFeedViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userFeedViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userFeedViewModelHash();

  @$internal
  @override
  UserFeedViewModel create() => UserFeedViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserFeedState>(value),
    );
  }
}

String _$userFeedViewModelHash() => r'4675b434b58a95a01d95cbe7aa4ba063c45cb727';

abstract class _$UserFeedViewModel extends $Notifier<UserFeedState> {
  UserFeedState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserFeedState, UserFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserFeedState, UserFeedState>,
              UserFeedState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SubscriptionViewModel)
const subscriptionViewModelProvider = SubscriptionViewModelProvider._();

final class SubscriptionViewModelProvider
    extends $NotifierProvider<SubscriptionViewModel, SubscriptionState> {
  const SubscriptionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionViewModelHash();

  @$internal
  @override
  SubscriptionViewModel create() => SubscriptionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionState>(value),
    );
  }
}

String _$subscriptionViewModelHash() =>
    r'f7d79a46d297318515328678bff5a28e4d6b5fd5';

abstract class _$SubscriptionViewModel extends $Notifier<SubscriptionState> {
  SubscriptionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SubscriptionState, SubscriptionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SubscriptionState, SubscriptionState>,
              SubscriptionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
