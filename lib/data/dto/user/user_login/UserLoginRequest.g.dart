// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserLoginRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLoginRequest _$UserLoginRequestFromJson(Map<String, dynamic> json) =>
    _UserLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserLoginRequestToJson(_UserLoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};
