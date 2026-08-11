
import 'package:dio/dio.dart';

import '../../domain/model/profile/ChangePasswordResult.dart';
import '../../domain/model/profile/CustomerPortalResult.dart';
import '../../domain/model/profile/SubscriptionInfo.dart';
import '../../domain/model/profile/UserFeedPost.dart';
import '../../domain/model/profile/UserProfile.dart';
import '../../domain/repository/ProfileRepository.dart';
import '../../utils/NetworkResult.dart';
import '../dto/pofile/change_password/ChangePasswordRequest.dart';
import '../dto/pofile/update_profile/UpdateProfileRequest.dart';
import '../remort/ProfileApi.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi _profileApi;

  ProfileRepositoryImpl(this._profileApi);

  // ── 1. Get My Info ─────────────────────────────────────────────
  @override
  Future<NetworkResult<UserProfile>> getMyInfo() async {
    try {
      final response = await _profileApi.getMyInfo();
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── 2. Update Profile ──────────────────────────────────────────
  @override
  Future<NetworkResult<UserProfile>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _profileApi.updateProfile(
        UpdateProfileRequest(name: name, email: email),
      );
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── 3. Change Password ─────────────────────────────────────────
  @override
  Future<NetworkResult<ChangePasswordResult>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _profileApi.changePassword(
        ChangePasswordRequest(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── 4. Get User Feed Posts ─────────────────────────────────────
  @override
  Future<NetworkResult<List<UserFeedPost>>> getUserFeedPosts() async {
    try {
      final response = await _profileApi.getUserFeedPosts();
      // DTO list → Domain list  (posts.map(...).toList() jaisi tarah)
      final posts = response.map((item) => item.toDomain()).toList();
      return NetworkResult.success(posts);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── GET /subscription/my-subscription ─────────────────────────────
  @override
  Future<NetworkResult<SubscriptionInfo>> getMySubscription() async {
    try {
      final response = await _profileApi.getMySubscription();
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── POST /subscription/customer-portal ────────────────────────────
  @override
  Future<NetworkResult<CustomerPortalResult>> getCustomerPortalUrl() async {
    try {
      final response = await _profileApi.getCustomerPortalUrl();
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── POST /subscription/create-checkout-session ─────────────────────
  @override
  Future<NetworkResult<CustomerPortalResult>> getCustomerCheckoutUrl() async {
    try {
      final response = await _profileApi.getCustomerCheckoutUrl();
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }


  // ── POST /subscription/create-checkout-session-promo ─────────────────────
  @override
  Future<NetworkResult<CustomerPortalResult>> getCustomerCheckoutWithPromoUrl(
      String promoCode,
      ) async {
    try {
      //final response = await _profileApi.getCustomerCheckoutWithPromoUrl(promoCode);
      final response = await _profileApi.getCustomerCheckoutWithPromoUrl({'referralCode': promoCode});
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Error Parser (PostRepositoryImpl se same) ──────────────────
  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}





























