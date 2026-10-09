import '../../utils/NetworkResult.dart';
import '../../domain/model/user/AuthUser.dart';
import '../../domain/model/user/OtpResult.dart';
import '../../domain/model/user/RegisteredUser.dart';


// import '../../utils/network_result.dart';
// import '../models/auth_user.dart';
// import '../models/registered_user.dart';
// import '../models/otp_result.dart';

abstract interface class AuthRepository {

  // ✅ Login — AuthUser milega success pe
  Future<NetworkResult<AuthUser>> login({
    required String email,
    required String password,
  });

  // ✅ Registration — RegisteredUser milega success pe
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
    String? parentEmail,    // ✅ NEW
    String? referralCode,
  });

  // ✅ OTP Verify — OtpResult milega success pe
  Future<NetworkResult<OtpResult>> verifyOtp({
    required String email,
    required String otp,
  });

  // ✅ forgetPassword
  Future<NetworkResult<String>> forgetPassword({
    required String email,
  });

  // ✅ resetPassword
  Future<NetworkResult<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}