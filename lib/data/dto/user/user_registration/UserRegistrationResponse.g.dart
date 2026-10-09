// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRegistrationResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRegistrationResponse _$UserRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _UserRegistrationResponse(
  success: json['success'] as bool,
  isUnder18: json['isUnder18'] as bool? ?? false,
  message: json['message'] as String,
);

Map<String, dynamic> _$UserRegistrationResponseToJson(
  _UserRegistrationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'isUnder18': instance.isUnder18,
  'message': instance.message,
};
