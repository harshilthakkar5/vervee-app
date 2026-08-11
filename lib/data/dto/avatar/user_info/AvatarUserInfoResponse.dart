
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/avatar/AvatarUserInfo.dart';
//import '../../../domain/models/avatar/AvatarDomain.dart';

part 'AvatarUserInfoResponse.freezed.dart';
part 'AvatarUserInfoResponse.g.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  1. GET /avatar/user-info  →  Response DTO
// ══════════════════════════════════════════════════════════════════════════════

@freezed
abstract class AvatarUserInfoResponse with _$AvatarUserInfoResponse {
  const AvatarUserInfoResponse._();

  const factory AvatarUserInfoResponse({
    @JsonKey(name: 'userId')        required int userId,
    @JsonKey(name: 'age')           required int age,
    @JsonKey(name: 'gender')        required String gender,
    @JsonKey(name: 'mascotSelected') required bool mascotSelected,
    @JsonKey(name: 'mascotId')      String? mascotId,
    @JsonKey(name: 'mascotUrl')     String? mascotUrl,
    @JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
    @JsonKey(name: 'colors')        AvatarColorsDto? colors,
  }) = _AvatarUserInfoResponse;

  factory AvatarUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarUserInfoResponseFromJson(json);

  AvatarUserInfo toDomain() => AvatarUserInfo(
    userId: userId,
    age: age,
    gender: gender,
    mascotSelected: mascotSelected,
    mascotId: mascotId,
    mascotUrl: mascotUrl,
    selectedItems: selectedItems.map((e) => e.toString()).toList(),
  );
}

@freezed
abstract class AvatarColorsDto with _$AvatarColorsDto {
  const factory AvatarColorsDto({
    @JsonKey(name: 'cap')     String? cap,
    @JsonKey(name: 'shoes')   String? shoes,
    @JsonKey(name: 'clothes') String? clothes,
    @JsonKey(name: 'watch')   String? watch,
    @JsonKey(name: 'chain')   String? chain,
  }) = _AvatarColorsDto;

  factory AvatarColorsDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarColorsDtoFromJson(json);
}