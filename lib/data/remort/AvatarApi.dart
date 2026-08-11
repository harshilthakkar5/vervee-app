
// ─────────────────────────────────────────────────────────────────────────────
//  FILE: data/api/AvatarApi.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/avatar/customize_avatar/CustomizeAvatarResponse.dart';
import '../dto/avatar/select_mascot/SelectMascotResponse.dart';
import '../dto/avatar/user_info/AvatarUserInfoResponse.dart';
//import '../models/avatar/AvatarDto.dart';

part 'AvatarApi.g.dart';

@RestApi()
abstract class AvatarApi {
  factory AvatarApi(Dio dio, {String baseUrl}) = _AvatarApi;

  // ── 1. User info fetch (screen load pe) ──────────────────────────────────
  @GET('/avatar/user-info')
  Future<AvatarUserInfoResponse> getUserInfo(
      @Query('userId') int userId,
      );

  // ── 2. Mascot select (multipart — image bhi jaati hai) ───────────────────
  @POST('/avatar/select-mascot')
  @MultiPart()
  Future<SelectMascotResponse> selectMascot(
      @Body() FormData formData,
      );

  // ── 3. Customize avatar (gear items + prompt) ────────────────────────────
  @POST('/avatar/customize')
  Future<CustomizeAvatarResponse> customizeAvatar(
      @Body() Map<String, dynamic> body,
      );
}