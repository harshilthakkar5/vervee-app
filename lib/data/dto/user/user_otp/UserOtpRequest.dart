
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'UserOtpRequest.freezed.dart';
part 'UserOtpRequest.g.dart';

// UserOtpRequest userOtpRequestFromJson(String str) => UserOtpRequest.fromJson(json.decode(str));
//
// String userOtpRequestToJson(UserOtpRequest data) => json.encode(data.toJson());

@freezed
abstract class UserOtpRequest with _$UserOtpRequest {
  const factory UserOtpRequest({
    @JsonKey(name: "email")
    required String email,
    @JsonKey(name: "otp")
    required String otp,
  }) = _UserOtpRequest;

  factory UserOtpRequest.fromJson(Map<String, dynamic> json) => _$UserOtpRequestFromJson(json);
}









// import 'package:json_annotation/json_annotation.dart';
// import 'dart:convert';
//
// part 'UserOtpRequest.g.dart';
//
// UserOtpRequest userOtpRequestFromJson(String str) => UserOtpRequest.fromJson(json.decode(str));
//
// String userOtpRequestToJson(UserOtpRequest data) => json.encode(data.toJson());
//
// @JsonSerializable()
// class UserOtpRequest {
//   @JsonKey(name: "email")
//   String email;
//   @JsonKey(name: "otp")
//   String otp;
//
//   UserOtpRequest({
//     required this.email,
//     required this.otp,
//   });
//
//   factory UserOtpRequest.fromJson(Map<String, dynamic> json) => _$UserOtpRequestFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserOtpRequestToJson(this);
// }