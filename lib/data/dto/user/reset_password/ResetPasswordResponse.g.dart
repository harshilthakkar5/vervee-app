// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResetPasswordResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResetPasswordResponse _$ResetPasswordResponseFromJson(
  Map<String, dynamic> json,
) => _ResetPasswordResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$ResetPasswordResponseToJson(
  _ResetPasswordResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
