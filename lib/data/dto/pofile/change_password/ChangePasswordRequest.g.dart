// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChangePasswordRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordRequest(
  email: json['email'] as String,
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  _ChangePasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};
