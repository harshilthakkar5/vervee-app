// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SelectMascotResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SelectMascotResponse _$SelectMascotResponseFromJson(
  Map<String, dynamic> json,
) => _SelectMascotResponse(
  message: json['message'] as String,
  data: SelectMascotData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SelectMascotResponseToJson(
  _SelectMascotResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

_SelectMascotData _$SelectMascotDataFromJson(Map<String, dynamic> json) =>
    _SelectMascotData(
      id: json['id'] as String,
      userId: (json['userId'] as num).toInt(),
      mascotId: json['mascotId'] as String,
      mascotSelected: json['mascotSelected'] as bool,
      mascotUrl: json['mascotUrl'] as String,
      selectedItems: json['selectedItems'] as String?,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$SelectMascotDataToJson(_SelectMascotData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mascotId': instance.mascotId,
      'mascotSelected': instance.mascotSelected,
      'mascotUrl': instance.mascotUrl,
      'selectedItems': instance.selectedItems,
      'timestamp': instance.timestamp,
    };
