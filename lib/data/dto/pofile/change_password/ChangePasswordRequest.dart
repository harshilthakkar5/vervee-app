import 'package:freezed_annotation/freezed_annotation.dart';
//import '../../domain/models/profile_domain.dart';

part 'ChangePasswordRequest.freezed.dart';
part 'ChangePasswordRequest.g.dart';


@freezed
abstract class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    @JsonKey(name: 'email')           required String email,
    @JsonKey(name: 'currentPassword') required String currentPassword,
    @JsonKey(name: 'newPassword')     required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}