import 'package:dio/dio.dart';

import '../../domain/model/user/AuthUser.dart';
import '../../domain/model/user/OtpResult.dart';
import '../../domain/model/user/RegisteredUser.dart';
import '../../domain/repository/AuthRepository.dart';
import '../../utils/NetworkResult.dart';
import '../dto/user/forgot_password/ForgetPasswordRequest.dart';
import '../dto/user/reset_password/ResetPasswordRequest.dart';
import '../dto/user/user_login/UserLoginRequest.dart';
import '../dto/user/user_otp/UserOtpRequest.dart';
import '../dto/user/user_registration/UserRegistrationRequest.dart';
import '../remort/AuthApi.dart';
// import '../../data/remote/auth_api.dart';
// import '../../data/dto/user_login_request.dart';
// import '../../domain/models/auth_user.dart';
// import '../../domain/repository/auth_repository.dart';
// import '../../utils/network_result.dart';

import 'package:dio/dio.dart';
// import '../../domain/models/auth_user.dart';
// import '../../domain/models/otp_result.dart';
// import '../../domain/models/registered_user.dart';
// import '../../domain/repository/auth_repository.dart';
// import '../../utils/network_result.dart';
// import '../remote/auth_api.dart';
// import '../dto/user_login_request.dart';
// import '../dto/user_registration_request.dart';
// import '../dto/user_otp_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  // ────────────────────────────────────────
  // Login
  // ────────────────────────────────────────
  @override
  Future<NetworkResult<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.login(
        UserLoginRequest(email: email, password: password),
      );

      // ✅ DTO → Domain Model
      // ✅ Ab — clean, ek line
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

  // ────────────────────────────────────────
  // Registration
  // ────────────────────────────────────────
  @override
  Future<NetworkResult<RegisteredUser>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String age,
    required String country,
     String? gender,
    required String phoneNo,
    required bool terms,
  }) async {
    try {
      final response = await _authApi.registration(
        UserRegistrationRequest(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          age: age,
          country: country,
          gender: gender,
          phoneNo: phoneNo,
          terms: terms,
        ),
      );

      // ✅ DTO → Domain Model
      // ✅ Ab — clean, ek line
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

  // ────────────────────────────────────────
  // OTP Verify
  // ────────────────────────────────────────
  @override
  Future<NetworkResult<OtpResult>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _authApi.otp(
        UserOtpRequest(email: email, otp: otp),
      );

      // ✅ DTO → Domain Model
      // ✅ Ab — clean, ek line
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


  // ────────────────────────────────────────
  // Forget Password — sends OTP to email
  // ────────────────────────────────────────
  @override
  Future<NetworkResult<String>> forgetPassword({
    required String email,
  }) async {
    try {
      final response = await _authApi.forgetPassword(
        ForgetPasswordRequest(email: email),
      );

      // ✅ DTO → Domain (yahan Domain = simple message String)
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


  // ────────────────────────────────────────
  // Reset Password — verifies OTP + sets new password
  // ────────────────────────────────────────
  @override
  Future<NetworkResult<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _authApi.resetPassword(
        ResetPasswordRequest(
          email: email,
          otp: otp,
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


  // ────────────────────────────────────────
  // Private Helper
  // ────────────────────────────────────────
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