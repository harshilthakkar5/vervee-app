
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/SubscriptionInfo.dart';
//import '../../../domain/model/subscription/SubscriptionInfo.dart';

part 'SubscriptionResponse.freezed.dart';
part 'SubscriptionResponse.g.dart';

// ── GET /subscription/my-subscription ───────────────────────────────
// Response: { "status": "trialing", "trialEnd": "2026-06-05T...", "cancelAtPeriodEnd": true }

@freezed
abstract class SubscriptionResponse with _$SubscriptionResponse {
  const SubscriptionResponse._();

  const factory SubscriptionResponse({
    @JsonKey(name: 'status')
    required String status,

    @JsonKey(name: 'trialEnd')
    DateTime? trialEnd,

    @JsonKey(name: 'cancelAtPeriodEnd')
    @Default(false) bool cancelAtPeriodEnd,
  }) = _SubscriptionResponse;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  // DTO → Domain
  SubscriptionInfo toDomain() => SubscriptionInfo(
    status:            status,
    trialEnd:          trialEnd,
    cancelAtPeriodEnd: cancelAtPeriodEnd,
  );
}