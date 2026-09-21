
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/DeleteAccountResult.dart';

part 'DeleteAccountResponse.freezed.dart';
part 'DeleteAccountResponse.g.dart';

@freezed
abstract class DeleteAccountResponse with _$DeleteAccountResponse {
  const DeleteAccountResponse._();

  const factory DeleteAccountResponse({
    @JsonKey(name: 'success') required bool   success,
    @JsonKey(name: 'message') required String message,
  }) = _DeleteAccountResponse;

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountResponseFromJson(json);

  DeleteAccountResult toDomain() =>
      DeleteAccountResult(success: success, message: message);
}