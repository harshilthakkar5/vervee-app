
import 'package:freezed_annotation/freezed_annotation.dart';

part 'DeleteAccountResult.freezed.dart';

@freezed
abstract class DeleteAccountResult with _$DeleteAccountResult {
  const factory DeleteAccountResult({
    required bool   success,
    required String message,
  }) = _DeleteAccountResult;
}