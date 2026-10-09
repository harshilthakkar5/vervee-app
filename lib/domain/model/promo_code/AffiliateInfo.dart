
import 'package:freezed_annotation/freezed_annotation.dart';

part 'AffiliateInfo.freezed.dart';

enum ReferralStatus { active, pending }

@freezed
abstract class ReferredUser with _$ReferredUser {
  const factory ReferredUser({
    required int id,
    required String name,
    required String email,
    required DateTime joinedAt,
    required ReferralStatus status,
  }) = _ReferredUser;
}

@freezed
abstract class AffiliateInfo with _$AffiliateInfo {
  const AffiliateInfo._(); // custom getters allow karne ke liye

  const factory AffiliateInfo({
    required String referralCode,
    required bool isAffiliate,
    required List<ReferredUser> referredUsers,
  }) = _AffiliateInfo;

  int get activeCount =>
      referredUsers.where((u) => u.status == ReferralStatus.active).length;

  int get pendingCount =>
      referredUsers.where((u) => u.status == ReferralStatus.pending).length;
}