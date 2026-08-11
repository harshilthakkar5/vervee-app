
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/user/OtpResult.dart';

part 'UserOtpResponse.freezed.dart';
part 'UserOtpResponse.g.dart';

// UserOtpResponse userOtpResponseFromJson(String str) => UserOtpResponse.fromJson(json.decode(str));
//
// String userOtpResponseToJson(UserOtpResponse data) => json.encode(data.toJson());


@freezed
abstract class UserOtpResponse with _$UserOtpResponse {

  const UserOtpResponse._();

  const factory UserOtpResponse({
    @JsonKey(name: "success")
    required bool success,
    @JsonKey(name: "message")
    required String message,
  }) = _UserOtpResponse;

  factory UserOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$UserOtpResponseFromJson(json);

  // ✅ Same pattern — success filter, message domain me
  OtpResult toDomain() {
    return OtpResult(message: message);
  }
}



// @freezed
// abstract class UserOtpResponse with _$UserOtpResponse {
//   const factory UserOtpResponse({
//     @JsonKey(name: "success")
//     required bool success,
//     @JsonKey(name: "message")
//     required String message,
//   }) = _UserOtpResponse;
//
//   factory UserOtpResponse.fromJson(Map<String, dynamic> json) => _$UserOtpResponseFromJson(json);
// }
