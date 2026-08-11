
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/avatar/AvatarResult.dart';
import '../../../../domain/model/avatar/AvatarUserInfo.dart';
//import '../../../domain/models/avatar/AvatarDomain.dart';

part 'CustomizeAvatarResponse.freezed.dart';
part 'CustomizeAvatarResponse.g.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  3. POST /avatar/customize  →  Response DTO
// ══════════════════════════════════════════════════════════════════════════════

@freezed
abstract class CustomizeAvatarResponse with _$CustomizeAvatarResponse {
  const CustomizeAvatarResponse._();

  const factory CustomizeAvatarResponse({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'data')    required CustomizeAvatarData data,
  }) = _CustomizeAvatarResponse;

  factory CustomizeAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomizeAvatarResponseFromJson(json);

  AvatarResult toDomain() => AvatarResult(
    message: message,
    mascotUrl: data.mascotUrl,
    mascotId: data.mascotId,
  );
}

@freezed
abstract class CustomizeAvatarData with _$CustomizeAvatarData {
  const factory CustomizeAvatarData({
    @JsonKey(name: 'id')             required String id,
    @JsonKey(name: 'userId')         required int userId,
    @JsonKey(name: 'mascotId')       required String mascotId,
    @JsonKey(name: 'mascotSelected') required bool mascotSelected,
    @JsonKey(name: 'mascotUrl')      required String mascotUrl,
    @JsonKey(name: 'selectedItems')  String? selectedItems,
  //  @JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
    @JsonKey(name: 'timestamp')      required String timestamp,
  }) = _CustomizeAvatarData;

  factory CustomizeAvatarData.fromJson(Map<String, dynamic> json) =>
      _$CustomizeAvatarDataFromJson(json);
}