
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/CustomerPortalResult.dart';
//import '../../../domain/model/subscription/SubscriptionInfo.dart';

part 'CustomerPortalResponse.freezed.dart';
part 'CustomerPortalResponse.g.dart';

// ── POST /subscription/customer-portal ──────────────────────────────
// Response: { "url": "https://billing.stripe.com/p/session/live_..." }

@freezed
abstract class CustomerPortalResponse with _$CustomerPortalResponse {
  const CustomerPortalResponse._();

  const factory CustomerPortalResponse({
    @JsonKey(name: 'url')
    required String url,
  }) = _CustomerPortalResponse;

  factory CustomerPortalResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerPortalResponseFromJson(json);

  CustomerPortalResult toDomain() => CustomerPortalResult(url: url);
}