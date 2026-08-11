
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/model/profile/SubscriptionInfo.dart';
import '../../../domain/model/profile/UserFeedPost.dart';
import '../../../domain/model/profile/UserProfile.dart';
//import '../../domain/models/profile_domain.dart';

part 'ProfileState.freezed.dart';

// ── Profile Info State (GET/PATCH /v1/auth/my-info) ─────────────────
@freezed
sealed class ProfileInfoState with _$ProfileInfoState {
  const factory ProfileInfoState({
    UserProfile?        profile,
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,   // Save Profile button ke liye
    String?             errorMessage,
    String?             successMessage,
  }) = _ProfileInfoState;
}

// ── Change Password State (POST /v1/auth/new-password) ──────────────
@freezed
sealed class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(false) bool   isLoading,
    String?                errorMessage,
    String?                successMessage,
  }) = _ChangePasswordState;
}

// ── User Feed Posts State (GET /posts/for-user) ──────────────────────
@freezed
sealed class UserFeedState with _$UserFeedState {
  const factory UserFeedState({
    @Default([]) List<UserFeedPost> posts,
    @Default(false) bool isLoading,
    String?              errorMessage,
  }) = _UserFeedState;
}

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    // GET /subscription/my-subscription
    SubscriptionInfo? subscription,
    @Default(false) bool isLoading,
    String?              errorMessage,

    // POST /subscription/customer-portal
    @Default(false) bool isPortalLoading,  // Manage Subscription button loading
    String?              portalErrorMessage,
    String?              portalUrl,

    // POST /subscription/create-checkout-session (NEW)
    @Default(false) bool isCheckoutLoading,
    String?              checkoutErrorMessage,
    String?              checkoutUrl,

    // ── Promo checkout (NEW) ──────────────────────────────────────────
    @Default(false) bool isPromoCheckoutLoading,
    String?              promoCheckoutErrorMessage,
    String?              promoCheckoutUrl,
  }) = _SubscriptionState;
}






























