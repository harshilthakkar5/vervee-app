
import 'package:freezed_annotation/freezed_annotation.dart';

part 'AvatarResult.freezed.dart';

// ── POST select-mascot / customize  →  Shared result domain ──────────────────
@freezed
abstract class AvatarResult with _$AvatarResult {
  const factory AvatarResult({
    required String message,
    required String mascotUrl,
    required String mascotId,
  }) = _AvatarResult;
}


