// To parse this JSON data, do
//
//     final userRegistrationRequest = userRegistrationRequestFromJson(jsonString);
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'UserRegistrationRequest.freezed.dart';
part 'UserRegistrationRequest.g.dart';

// UserRegistrationRequest userRegistrationRequestFromJson(String str) => UserRegistrationRequest.fromJson(json.decode(str));

// String userRegistrationRequestToJson(UserRegistrationRequest data) => json.encode(data.toJson());

@freezed
abstract class UserRegistrationRequest with _$UserRegistrationRequest {
  const factory UserRegistrationRequest({
    @JsonKey(name: "name")
    required String name,
    @JsonKey(name: "email")
    required String email,
    @JsonKey(name: "password")
    required String password,
    @JsonKey(name: "confirmPassword")
    required String confirmPassword,
    @JsonKey(name: "age")
    required String age,
    @JsonKey(name: "country")
    required String country,
    @JsonKey(name: "gender")
     String? gender,
    @JsonKey(name: "phoneNo")
    required String phoneNo,
    @JsonKey(name: "terms")
    required bool terms,
  }) = _UserRegistrationRequest;

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) => _$UserRegistrationRequestFromJson(json);
}


//------------------------------ Important Point new update ------------------------------->

// run this command after every changes - dart run build_runner build --delete-conflicting-outputs

//------------------------------ Important Point ------------------------------->



//------------------------------ Important Point ------------------------------->

// run this command after every changes - flutter pub run build_runner build --delete-conflicting-outputs

//------------------------------ Important Point ------------------------------->



//------------------- Genrate JsonSerializable data class ------------------>

// https://app.quicktype.io/

//------------------- Genrate JsonSerializable data class ------------------>





// import 'package:json_annotation/json_annotation.dart';
// import 'dart:convert';
//
// part 'UserRegistrationRequest.g.dart';
//
// UserRegistrationRequest userRegistrationRequestFromJson(String str) => UserRegistrationRequest.fromJson(json.decode(str));
//
// String userRegistrationRequestToJson(UserRegistrationRequest data) => json.encode(data.toJson());
//
// @JsonSerializable()
// class UserRegistrationRequest {
//   @JsonKey(name: "name")
//   String name;
//   @JsonKey(name: "email")
//   String email;
//   @JsonKey(name: "password")
//   String password;
//   @JsonKey(name: "confirmPassword")
//   String confirmPassword;
//   @JsonKey(name: "age")
//   String age;
//   @JsonKey(name: "country")
//   String country;
//   @JsonKey(name: "gender")
//   String gender;
//   @JsonKey(name: "phoneNo")
//   String phoneNo;
//   @JsonKey(name: "terms")
//   bool terms;
//
//   UserRegistrationRequest({
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.confirmPassword,
//     required this.age,
//     required this.country,
//     required this.gender,
//     required this.phoneNo,
//     required this.terms,
//   });
//
//   factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) => _$UserRegistrationRequestFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);
// }
