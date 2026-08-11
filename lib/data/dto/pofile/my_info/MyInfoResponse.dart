
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/UserProfile.dart';
//import '../../domain/models/profile_domain.dart';

part 'MyInfoResponse.freezed.dart';
part 'MyInfoResponse.g.dart';


@freezed
abstract class MyInfoResponse with _$MyInfoResponse {
  const MyInfoResponse._();   // toDomain() ke liye zaruri

  const factory MyInfoResponse({
    @JsonKey(name: 'success') required bool    success,
    @JsonKey(name: 'user')    required UserDto user,
  }) = _MyInfoResponse;

  factory MyInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$MyInfoResponseFromJson(json);

  /// DTO → Domain
  UserProfile toDomain() => user.toDomain();
}

// ── Nested user object ────────────────────────────────────────────────
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    @JsonKey(name: 'id')    required int    id,
    @JsonKey(name: 'name')  required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'role')  required String role,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  UserProfile toDomain() => UserProfile(
    id: id, name: name, email: email, role: role,
  );
}