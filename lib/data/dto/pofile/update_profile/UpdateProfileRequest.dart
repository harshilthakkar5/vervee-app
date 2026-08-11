
import 'package:freezed_annotation/freezed_annotation.dart';
//import '../../domain/models/profile_domain.dart';

part 'UpdateProfileRequest.freezed.dart';
part 'UpdateProfileRequest.g.dart';

@freezed
abstract class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    @JsonKey(name: 'name')  required String name,
    @JsonKey(name: 'email') required String email,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}