// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomizeAvatarResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomizeAvatarResponse _$CustomizeAvatarResponseFromJson(
  Map<String, dynamic> json,
) => _CustomizeAvatarResponse(
  message: json['message'] as String,
  data: CustomizeAvatarData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomizeAvatarResponseToJson(
  _CustomizeAvatarResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

_CustomizeAvatarData _$CustomizeAvatarDataFromJson(Map<String, dynamic> json) =>
    _CustomizeAvatarData(
      id: json['id'] as String,
      userId: (json['userId'] as num).toInt(),
      mascotId: json['mascotId'] as String,
      mascotSelected: json['mascotSelected'] as bool,
      mascotUrl: json['mascotUrl'] as String,
      selectedItems: json['selectedItems'] as String?,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$CustomizeAvatarDataToJson(
  _CustomizeAvatarData instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'mascotId': instance.mascotId,
  'mascotSelected': instance.mascotSelected,
  'mascotUrl': instance.mascotUrl,
  'selectedItems': instance.selectedItems,
  'timestamp': instance.timestamp,
};
