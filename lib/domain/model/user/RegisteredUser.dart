
import 'package:freezed_annotation/freezed_annotation.dart';

part 'RegisteredUser.freezed.dart';

// ✅ Registration success ke baad sirf message chahiye UI ko
// Server "success: true" bhejta hai — but wo
// NetworkResult.success() se handle hota hai Repository me
// Isliye yahan sirf message field hai

@freezed
abstract class RegisteredUser with _$RegisteredUser {
  const factory RegisteredUser({
    required String message, // "Registration successful!" dikhayenge UI me
  }) = _RegisteredUser;
}