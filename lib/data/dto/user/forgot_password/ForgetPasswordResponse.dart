
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ForgetPasswordResponse.freezed.dart';
part 'ForgetPasswordResponse.g.dart';

// ────────────────────────────────────────────────
// Response:
// {
//   "success": true,
//   "message": "Reset password OTP has been sent to your email address."
// }
// ────────────────────────────────────────────────
@freezed
abstract class ForgetPasswordResponse with _$ForgetPasswordResponse {
  // ✅ toDomain() ke liye private constructor zaruri hai
  const ForgetPasswordResponse._();

  const factory ForgetPasswordResponse({
    @JsonKey(name: "success") required bool success,
    @JsonKey(name: "message") required String message,
  }) = _ForgetPasswordResponse;

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);

  // ✅ DTO → Domain
  // "success" filter ho gaya — NetworkResult handle karega
  // sirf "message" chahiye UI ko dikhane ke liye
  String toDomain() => message;
}