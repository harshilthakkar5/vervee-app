// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRegistrationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRegistrationResponse _$UserRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _UserRegistrationResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$UserRegistrationResponseToJson(
  _UserRegistrationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
