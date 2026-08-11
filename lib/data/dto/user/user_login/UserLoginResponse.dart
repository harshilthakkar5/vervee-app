
// To parse this JSON data, do
// final userLoginResponse = userLoginResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/user/AuthUser.dart';

part 'UserLoginResponse.freezed.dart';
part 'UserLoginResponse.g.dart';

// UserLoginResponse userLoginResponseFromJson(String str) => UserLoginResponse.fromJson(json.decode(str));

// String userLoginResponseToJson(UserLoginResponse data) => json.encode(data.toJson());

@freezed
abstract class UserLoginResponse with _$UserLoginResponse {

  // ✅ toDomain() ke liye private constructor zaruri hai
  const UserLoginResponse._();

  const factory UserLoginResponse({
    @JsonKey(name: "success")
    required bool success,
    @JsonKey(name: "access_token")
    required String accessToken,
    @JsonKey(name: "user")
    required User user,
  }) = _UserLoginResponse;

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$UserLoginResponseFromJson(json);

  // ✅ DTO → Domain Model
  // "success" field filter ho gaya — NetworkResult handle karega
  // "accessToken" Domain model me gaya — auth ke liye zaruri hai
  AuthUser toDomain() {
    return AuthUser(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      accessToken: accessToken,
      hasSeenTour: user.hasSeenTour,
    );
  }
}

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: "id")
    required int id,
    @JsonKey(name: "name")
    required String name,
    @JsonKey(name: "email")
    required String email,
    @JsonKey(name: "role")
    required String role,
    @JsonKey(name: "hasSeenTour")
    required bool hasSeenTour,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}


// @freezed
// abstract class UserLoginResponse with _$UserLoginResponse {
//   const factory UserLoginResponse({
//     required bool success,
//     required String accessToken,
//     required User user,
//   }) = _UserLoginResponse;
//
//   factory UserLoginResponse.fromJson(Map<String, dynamic> json) => _$UserLoginResponseFromJson(json);
// }
//
// @freezed
// abstract class User with _$User {
//   const factory User({
//     required int id,
//     required String name,
//     required String email,
//     required String role,
//     required bool hasSeenTour,
//   }) = _User;
//
//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
// }
