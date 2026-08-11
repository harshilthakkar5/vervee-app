// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyInfoResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyInfoResponse _$MyInfoResponseFromJson(Map<String, dynamic> json) =>
    _MyInfoResponse(
      success: json['success'] as bool,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyInfoResponseToJson(_MyInfoResponse instance) =>
    <String, dynamic>{'success': instance.success, 'user': instance.user};

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
};
