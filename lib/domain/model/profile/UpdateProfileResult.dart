
import 'package:freezed_annotation/freezed_annotation.dart';

part 'UpdateProfileResult.freezed.dart';

// ── 3. Update Profile result ─────────────────────────────────────────
@freezed
abstract class UpdateProfileResult with _$UpdateProfileResult {
  const factory UpdateProfileResult({
    required int    id,
    required String name,
    required String email,
    required String role,
  }) = _UpdateProfileResult;
}