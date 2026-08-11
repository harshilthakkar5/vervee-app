// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubscriptionResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionResponse _$SubscriptionResponseFromJson(
  Map<String, dynamic> json,
) => _SubscriptionResponse(
  status: json['status'] as String,
  trialEnd: json['trialEnd'] == null
      ? null
      : DateTime.parse(json['trialEnd'] as String),
  cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
);

Map<String, dynamic> _$SubscriptionResponseToJson(
  _SubscriptionResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'trialEnd': instance.trialEnd?.toIso8601String(),
  'cancelAtPeriodEnd': instance.cancelAtPeriodEnd,
};
