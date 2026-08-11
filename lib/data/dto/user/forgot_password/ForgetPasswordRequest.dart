
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ForgetPasswordRequest.freezed.dart';
part 'ForgetPasswordRequest.g.dart';

// ────────────────────────────────────────────────
// POST /v1/auth/forget-password
// Body: { "email": "..." }
// ────────────────────────────────────────────────
@freezed
abstract class ForgetPasswordRequest with _$ForgetPasswordRequest {
  const factory ForgetPasswordRequest({
    @JsonKey(name: "email") required String email,
  }) = _ForgetPasswordRequest;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestFromJson(json);
}