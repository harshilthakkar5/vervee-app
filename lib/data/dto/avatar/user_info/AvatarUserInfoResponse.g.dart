// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AvatarUserInfoResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvatarUserInfoResponse _$AvatarUserInfoResponseFromJson(
  Map<String, dynamic> json,
) => _AvatarUserInfoResponse(
  userId: (json['userId'] as num).toInt(),
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as String,
  mascotSelected: json['mascotSelected'] as bool,
  mascotId: json['mascotId'] as String?,
  mascotUrl: json['mascotUrl'] as String?,
  selectedItems: json['selectedItems'] as List<dynamic>? ?? const [],
  colors: json['colors'] == null
      ? null
      : AvatarColorsDto.fromJson(json['colors'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AvatarUserInfoResponseToJson(
  _AvatarUserInfoResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'age': instance.age,
  'gender': instance.gender,
  'mascotSelected': instance.mascotSelected,
  'mascotId': instance.mascotId,
  'mascotUrl': instance.mascotUrl,
  'selectedItems': instance.selectedItems,
  'colors': instance.colors,
};

_AvatarColorsDto _$AvatarColorsDtoFromJson(Map<String, dynamic> json) =>
    _AvatarColorsDto(
      cap: json['cap'] as String?,
      shoes: json['shoes'] as String?,
      clothes: json['clothes'] as String?,
      watch: json['watch'] as String?,
      chain: json['chain'] as String?,
    );

Map<String, dynamic> _$AvatarColorsDtoToJson(_AvatarColorsDto instance) =>
    <String, dynamic>{
      'cap': instance.cap,
      'shoes': instance.shoes,
      'clothes': instance.clothes,
      'watch': instance.watch,
      'chain': instance.chain,
    };
