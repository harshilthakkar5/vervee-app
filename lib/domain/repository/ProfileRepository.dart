
// import '../models/profile_domain.dart';
// import '../../core/network_result.dart'; // apka existing NetworkResult

import '../../utils/NetworkResult.dart';
import '../model/profile/ChangePasswordResult.dart';
import '../model/profile/CustomerPortalResult.dart';
import '../model/profile/SubscriptionInfo.dart';
import '../model/profile/UserFeedPost.dart';
import '../model/profile/UserProfile.dart';

abstract interface class ProfileRepository {

  // ── 1. Get current user profile ──────────────────────────────
  Future<NetworkResult<UserProfile>> getMyInfo();

  // ── 2. Update name (email bhi send karna padta hai backend ko) ─
  Future<NetworkResult<UserProfile>> updateProfile({
    required String name,
    required String email,
  });

  // ── 3. Change password ────────────────────────────────────────
  Future<NetworkResult<ChangePasswordResult>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  // ── 4. Get user's own feed posts (profile grid ke liye) ───────
  Future<NetworkResult<List<UserFeedPost>>> getUserFeedPosts();

  // Tab open → subscription status fetch karo
  Future<NetworkResult<SubscriptionInfo>> getMySubscription();

  // Manage Subscription button → Stripe portal URL lo
  Future<NetworkResult<CustomerPortalResult>> getCustomerPortalUrl();

  // POST /subscription/create-checkout-session
  Future<NetworkResult<CustomerPortalResult>> getCustomerCheckoutUrl();

  // getCustomerCheckoutUrl() ke neeche ADD karo:
  Future<NetworkResult<CustomerPortalResult>> getCustomerCheckoutWithPromoUrl(
      String promoCode,
      );
}