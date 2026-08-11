// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRegistrationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRegistrationRequest _$UserRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _UserRegistrationRequest(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
  age: json['age'] as String,
  country: json['country'] as String,
  gender: json['gender'] as String?,
  phoneNo: json['phoneNo'] as String,
  terms: json['terms'] as bool,
);

Map<String, dynamic> _$UserRegistrationRequestToJson(
  _UserRegistrationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
  'age': instance.age,
  'country': instance.country,
  'gender': instance.gender,
  'phoneNo': instance.phoneNo,
  'terms': instance.terms,
};
