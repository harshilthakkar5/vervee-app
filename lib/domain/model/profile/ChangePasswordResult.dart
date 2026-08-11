
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ChangePasswordResult.freezed.dart';

// ── 4. Change Password result ────────────────────────────────────────
@freezed
abstract class ChangePasswordResult with _$ChangePasswordResult {
  const factory ChangePasswordResult({
    required bool   success,
    required String message,
  }) = _ChangePasswordResult;
}