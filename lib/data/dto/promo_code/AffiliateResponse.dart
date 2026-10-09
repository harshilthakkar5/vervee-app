
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../domain/model/promo_code/AffiliateInfo.dart';

//import '../../../domain/model/affiliate/AffiliateInfo.dart';

part 'AffiliateResponse.freezed.dart';
part 'AffiliateResponse.g.dart';

AffiliateResponse affiliateResponseFromJson(String str) =>
    AffiliateResponse.fromJson(json.decode(str));

@freezed
abstract class AffiliateResponse with _$AffiliateResponse {
  const AffiliateResponse._(); // custom method allow karne ke liye

  const factory AffiliateResponse({
    @JsonKey(name: "referralCode") String? referralCode,
    @JsonKey(name: "isAffiliate") @Default(false) bool isAffiliate,
    @JsonKey(name: "referredUsers")
    @Default(<ReferredUserDto>[])
    List<ReferredUserDto> referredUsers,
  }) = _AffiliateResponse;

  factory AffiliateResponse.fromJson(Map<String, dynamic> json) =>
      _$AffiliateResponseFromJson(json);

  // DTO → Domain model
  AffiliateInfo toDomain() {
    return AffiliateInfo(
      referralCode: referralCode ?? '',
      isAffiliate: isAffiliate,
      referredUsers: referredUsers.map((u) => u.toDomain()).toList(),
    );
  }
}

@freezed
abstract class ReferredUserDto with _$ReferredUserDto {
  const ReferredUserDto._();

  const factory ReferredUserDto({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "status") required String status, // "Approve" / "Pending"
    @JsonKey(name: "createdAt") required String createdAt, // ISO-8601
  }) = _ReferredUserDto;

  factory ReferredUserDto.fromJson(Map<String, dynamic> json) =>
      _$ReferredUserDtoFromJson(json);

  ReferredUser toDomain() {
    final s = status.trim().toLowerCase();
    final isActive = s == 'approve' || s == 'approved' || s == 'active';

    return ReferredUser(
      id: id,
      name: name,
      email: email,
      joinedAt: DateTime.tryParse(createdAt)?.toLocal() ?? DateTime.now(),
      status: isActive ? ReferralStatus.active : ReferralStatus.pending,
    );
  }
}