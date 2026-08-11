
import 'package:freezed_annotation/freezed_annotation.dart';

part 'AvatarUserInfo.freezed.dart';

// ── GET /avatar/user-info  →  Domain model ────────────────────────────────────
@freezed
abstract class AvatarUserInfo with _$AvatarUserInfo {
  const factory AvatarUserInfo({
    required int    userId,
    required int    age,
    required String gender,
    required bool   mascotSelected,
    String?         mascotId,
    String?         mascotUrl,
    @Default([]) List<String> selectedItems,
  }) = _AvatarUserInfo;
}