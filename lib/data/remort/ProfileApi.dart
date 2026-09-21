
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/pofile/change_password/ChangePasswordRequest.dart';
import '../dto/pofile/change_password/ChangePasswordResponse.dart';
import '../dto/pofile/delete_account/DeleteAccountResponse.dart';
import '../dto/pofile/get_post/UserFeedPostResponse.dart';
import '../dto/pofile/my_info/MyInfoResponse.dart';
import '../dto/pofile/subscription/CustomerPortalResponse.dart';
import '../dto/pofile/subscription/SubscriptionResponse.dart';
import '../dto/pofile/update_profile/UpdateProfileRequest.dart';
//import '../dto/profile_dto.dart';

part 'ProfileApi.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String baseUrl}) = _ProfileApi;

  // ── 1. Get My Info ─────────────────────────────────────────────
  //  GET /v1/auth/my-info
  //  Headers: Authorization: Bearer <token>  ← Dio interceptor handle karta hai
  @GET('/v1/auth/my-info')
  Future<MyInfoResponse> getMyInfo();

  // ── 2. Update Profile ──────────────────────────────────────────
  //  PATCH /v1/auth/my-info
  //  Body: { name, email }
  @PATCH('/v1/auth/my-info')
  Future<MyInfoResponse> updateProfile(@Body() UpdateProfileRequest request);

  // ── 3. Change Password ─────────────────────────────────────────
  //  POST /v1/auth/new-password
  //  Body: { email, currentPassword, newPassword }
  @POST('/v1/auth/new-password')
  Future<ChangePasswordResponse> changePassword(
      @Body() ChangePasswordRequest request,
      );

  // ── 4. Get User Feed Posts ─────────────────────────────────────
  //  GET /posts/for-user
  //  Returns: List<UserFeedPostResponse>
  @GET('/posts/for-user')
  Future<List<UserFeedPostResponse>> getUserFeedPosts();

  // ── GET /subscription/my-subscription ─────────────────────────────
  // Tab open hote hi call karo — current subscription status fetch karo
  @GET('/subscription/my-subscription')
  Future<SubscriptionResponse> getMySubscription();

  // ── POST /subscription/customer-portal ────────────────────────────
  // "Manage Subscription" button click pe call karo
  // Response mein Stripe portal URL milta hai → browser mein open karo
  @POST('/subscription/customer-portal')
  Future<CustomerPortalResponse> getCustomerPortalUrl();

  // ── POST /subscription/customer-portal-checkout ────────────────────────────
  // "Manage Subscription" button click pe call karo
  // Response mein Stripe portal URL milta hai → browser mein open karo
  @POST('/subscription/create-checkout-session')
  Future<CustomerPortalResponse> getCustomerCheckoutUrl();

  // POST /subscription/create-checkout-session-promo
  // @POST('/subscription/create-checkout-session')
  // Future<CustomerPortalResponse> getCustomerCheckoutWithPromoUrl(
  //     @Query('referralCode') String promoCode,
  //     );

  // Baad mein
  @POST('/subscription/create-checkout-session')
  Future<CustomerPortalResponse> getCustomerCheckoutWithPromoUrl(
      @Body() Map<String, dynamic> body,
      );

  // ── 5. Delete Account ────────────────────────────────────────
  //  POST /v1/auth/delete-account
  //  No body, Authorization header interceptor se jayega
  @POST('/v1/auth/delete-account')
  Future<DeleteAccountResponse> deleteAccount();
}






























