
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ResetPasswordResponse.freezed.dart';
part 'ResetPasswordResponse.g.dart';

// ────────────────────────────────────────────────
// Response:
// { "success": true, "message": "Password updated successfully!" }
// ────────────────────────────────────────────────
@freezed
abstract class ResetPasswordResponse with _$ResetPasswordResponse {
  const ResetPasswordResponse._();

  const factory ResetPasswordResponse({
    @JsonKey(name: "success") required bool success,
    @JsonKey(name: "message") required String message,
  }) = _ResetPasswordResponse;

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  String toDomain() => message;
}