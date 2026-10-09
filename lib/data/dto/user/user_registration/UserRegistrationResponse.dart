// To parse this JSON data, do
//
//     final userRegistrationResponse = userRegistrationResponseFromJson(jsonString);
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/user/RegisteredUser.dart';

part 'UserRegistrationResponse.freezed.dart';
part 'UserRegistrationResponse.g.dart';

// UserRegistrationResponse userRegistrationResponseFromJson(String str) => UserRegistrationResponse.fromJson(json.decode(str));
//
// String userRegistrationResponseToJson(UserRegistrationResponse data) => json.encode(data.toJson());
















@freezed
abstract class UserRegistrationResponse with _$UserRegistrationResponse {

  const UserRegistrationResponse._();

  const factory UserRegistrationResponse({
    @JsonKey(name: "success")
    required bool success,
    @JsonKey(name: "isUnder18")
    @Default(false) bool isUnder18,
    @JsonKey(name: "message")
    required String message,
  }) = _UserRegistrationResponse;

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationResponseFromJson(json);

  // ✅ "success" filter — NetworkResult handle karega
  // Sirf message Domain model me
  RegisteredUser toDomain() {
    return RegisteredUser(message: message, isUnder18: isUnder18);
  }
}


// @freezed
// abstract class UserRegistrationResponse with _$UserRegistrationResponse {
//   const factory UserRegistrationResponse({
//     @JsonKey(name: "success")
//     required bool success,
//     @JsonKey(name: "message")
//     required String message,
//   }) = _UserRegistrationResponse;
//
//   factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) => _$UserRegistrationResponseFromJson(json);
// }
