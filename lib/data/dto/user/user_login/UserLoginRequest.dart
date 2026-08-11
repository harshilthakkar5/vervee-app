// To parse this JSON data, do
// final userLoginRequest = userLoginRequestFromJson(jsonString);
import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';

part 'UserLoginRequest.freezed.dart';
part 'UserLoginRequest.g.dart';

// UserLoginRequest userLoginRequestFromJson(String str) => UserLoginRequest.fromJson(json.decode(str));
// String userLoginRequestToJson(UserLoginRequest data) => json.encode(data.toJson());

@freezed
abstract class UserLoginRequest with _$UserLoginRequest {
  const factory UserLoginRequest({
    @JsonKey(name: "email")
    required String email,
    @JsonKey(name: "password")
    required String password,
  }) = _UserLoginRequest;

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) => _$UserLoginRequestFromJson(json);
}


// import 'package:json_annotation/json_annotation.dart';
// import 'dart:convert';
//
// part 'UserLoginRequest.g.dart';
//
// UserLoginRequest userLoginRequestFromJson(String str) => UserLoginRequest.fromJson(json.decode(str));
//
// String userLoginRequestToJson(UserLoginRequest data) => json.encode(data.toJson());
//
// @JsonSerializable()
// class UserLoginRequest {
//   @JsonKey(name: "email")
//   String email;
//   @JsonKey(name: "password")
//   String password;
//
//   UserLoginRequest({
//     required this.email,
//     required this.password,
//   });
//
//   factory UserLoginRequest.fromJson(Map<String, dynamic> json) => _$UserLoginRequestFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
// }
