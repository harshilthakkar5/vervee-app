// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LikePostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LikePostResponse _$LikePostResponseFromJson(Map<String, dynamic> json) =>
    _LikePostResponse(
      liked: json['liked'] as bool,
      likesCount: (json['likesCount'] as num).toInt(),
    );

Map<String, dynamic> _$LikePostResponseToJson(_LikePostResponse instance) =>
    <String, dynamic>{
      'liked': instance.liked,
      'likesCount': instance.likesCount,
    };
