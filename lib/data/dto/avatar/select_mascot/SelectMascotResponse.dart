
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/avatar/AvatarResult.dart';
import '../../../../domain/model/avatar/AvatarUserInfo.dart';
//import '../../../domain/models/avatar/AvatarDomain.dart';

part 'SelectMascotResponse.freezed.dart';
part 'SelectMascotResponse.g.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  2. POST /avatar/select-mascot  →  Response DTO
// ══════════════════════════════════════════════════════════════════════════════

@freezed
abstract class SelectMascotResponse with _$SelectMascotResponse {
  const SelectMascotResponse._();

  const factory SelectMascotResponse({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'data')    required SelectMascotData data,
  }) = _SelectMascotResponse;

  factory SelectMascotResponse.fromJson(Map<String, dynamic> json) =>
      _$SelectMascotResponseFromJson(json);

  AvatarResult toDomain() => AvatarResult(
    message: message,
    mascotUrl: data.mascotUrl,
    mascotId: data.mascotId,
  );
}

@freezed
abstract class SelectMascotData with _$SelectMascotData {
  const factory SelectMascotData({
    @JsonKey(name: 'id')             required String id,
    @JsonKey(name: 'userId')         required int userId,
    @JsonKey(name: 'mascotId')       required String mascotId,
    @JsonKey(name: 'mascotSelected') required bool mascotSelected,
    @JsonKey(name: 'mascotUrl')      required String mascotUrl,
    @JsonKey(name: 'selectedItems')  String? selectedItems,
    //@JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
    @JsonKey(name: 'timestamp')      required String timestamp,
  }) = _SelectMascotData;

  factory SelectMascotData.fromJson(Map<String, dynamic> json) =>
      _$SelectMascotDataFromJson(json);
}