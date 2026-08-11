
import 'package:freezed_annotation/freezed_annotation.dart';

part 'UserProfile.freezed.dart';

// ── 1. User Profile (GET /v1/auth/my-info response) ─────────────────
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int    id,
    required String name,
    required String email,
    required String role,   // 'user' | 'admin'
  }) = _UserProfile;
}