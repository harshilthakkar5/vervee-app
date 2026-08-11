
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ResetPasswordRequest.freezed.dart';
part 'ResetPasswordRequest.g.dart';

// ────────────────────────────────────────────────
// POST /v1/auth/reset-password
// Body: { "email": "...", "otp": "...", "newPassword": "..." }
// ────────────────────────────────────────────────
@freezed
abstract class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "otp") required String otp,
    @JsonKey(name: "newPassword") required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}