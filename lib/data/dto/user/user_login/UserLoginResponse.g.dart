// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserLoginResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLoginResponse _$UserLoginResponseFromJson(Map<String, dynamic> json) =>
    _UserLoginResponse(
      success: json['success'] as bool,
      accessToken: json['access_token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserLoginResponseToJson(_UserLoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'access_token': instance.accessToken,
      'user': instance.user,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  hasSeenTour: json['hasSeenTour'] as bool,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'hasSeenTour': instance.hasSeenTour,
};
