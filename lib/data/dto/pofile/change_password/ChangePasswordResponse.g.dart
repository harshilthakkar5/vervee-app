// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChangePasswordResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangePasswordResponse _$ChangePasswordResponseFromJson(
  Map<String, dynamic> json,
) => _ChangePasswordResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$ChangePasswordResponseToJson(
  _ChangePasswordResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
