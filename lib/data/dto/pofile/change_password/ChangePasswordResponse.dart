
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/ChangePasswordResult.dart';
//import '../../domain/models/profile_domain.dart';

part 'ChangePasswordResponse.freezed.dart';
part 'ChangePasswordResponse.g.dart';


@freezed
abstract class ChangePasswordResponse with _$ChangePasswordResponse {
  const ChangePasswordResponse._();

  const factory ChangePasswordResponse({
    @JsonKey(name: 'success') required bool   success,
    @JsonKey(name: 'message') required String message,
  }) = _ChangePasswordResponse;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  ChangePasswordResult toDomain() =>
      ChangePasswordResult(success: success, message: message);
}