
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import '../dto/user_login_request.dart';    // ✅ snake_case file names
// import '../dto/user_login_response.dart';

// part 'auth_api.g.dart';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:vervee_app/data/dto/user/user_otp/UserOtpRequest.dart';
import 'package:vervee_app/data/dto/user/user_otp/UserOtpResponse.dart';
import 'package:vervee_app/data/dto/user/user_registration/UserRegistrationRequest.dart';
import 'package:vervee_app/data/dto/user/user_registration/UserRegistrationResponse.dart';

import '../dto/user/forgot_password/ForgetPasswordRequest.dart';
import '../dto/user/forgot_password/ForgetPasswordResponse.dart';
import '../dto/user/reset_password/ResetPasswordRequest.dart';
import '../dto/user/reset_password/ResetPasswordResponse.dart';
import '../dto/user/user_login/UserLoginRequest.dart';
import '../dto/user/user_login/UserLoginResponse.dart';

part 'AuthApi.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/v1/auth/local/login')
  Future<UserLoginResponse> login(@Body() UserLoginRequest request);

  @POST('/v1/auth/local/register')
  Future<UserRegistrationResponse> registration(@Body() UserRegistrationRequest request);

  @PATCH('/v1/auth/confirm-email-otp')
  Future<UserOtpResponse> otp(@Body() UserOtpRequest request);

  // ✅ NAYA — Forget Password
  @POST('/v1/auth/forget-password')
  Future<ForgetPasswordResponse> forgetPassword(@Body() ForgetPasswordRequest request);

  // ✅ NAYA — Reset Password
  @POST('/v1/auth/reset-password')
  Future<ResetPasswordResponse> resetPassword(@Body() ResetPasswordRequest request);
}


// ✅ Interface (Contract)
// import 'package:dio/dio.dart';
// import 'package:vervee_app/data/dto/user/user_login/UserLoginResponse.dart';
// import 'package:vervee_app/data/dto/user/user_otp/UserOtpResponse.dart';
// import 'package:vervee_app/data/dto/user/user_registration/UserRegistrationResponse.dart';
//
// abstract class UserApiInterface {
//
//   // Ye method future return karega kyunki API call asynchronous hoti hai
//   // WeatherResponse return karega (DTO object)
//   // Parameter me city name lega
//   Future<UserLoginResponse> userLogin();
//   Future<UserRegistrationResponse> userRegister();
//   Future<UserOtpResponse> userOtp();
// }
//
// // ✅ Implementation Class
// // Ye actual implementation hai jo Dio use karke API call karega
//
// class UserApi implements UserApiInterface {
//
//   // Dio ek HTTP client hai jo network calls ke liye use hota hai
//   final Dio _dio;
//
//   // Constructor injection (Dependency Injection)
//   // Bahar se Dio pass kiya ja raha hai
//   // Isse testing easy hoti hai (mock Dio use kar sakte ho)
//   UserApi(this._dio);
//
//   @override
//   Future<UserLoginResponse> userLogin() {
//     // TODO: implement userLogin
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<UserOtpResponse> userOtp() {
//     // TODO: implement userOtp
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<UserRegistrationResponse> userRegister() {
//     // TODO: implement userRegister
//     throw UnimplementedError();
//   }
// }