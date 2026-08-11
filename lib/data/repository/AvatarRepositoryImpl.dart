
import 'dart:io';
import 'package:dio/dio.dart';

import '../../domain/model/avatar/AvatarResult.dart';
import '../../domain/model/avatar/AvatarUserInfo.dart';
import '../../domain/repository/AvatarRepository.dart';
import '../../utils/NetworkResult.dart';
import '../remort/AvatarApi.dart';
// import '../../data/api/AvatarApi.dart';
// import '../../domain/models/avatar/AvatarDomain.dart';
// import '../network/NetworkResult.dart'; // apna existing NetworkResult

// ══════════════════════════════════════════════════════════════════════════════
//  IMPLEMENTATION  (data/repository/AvatarRepositoryImpl.dart)
// ══════════════════════════════════════════════════════════════════════════════

class AvatarRepositoryImpl implements AvatarRepository {
  final AvatarApi _avatarApi;

  AvatarRepositoryImpl(this._avatarApi);

  // ── 1. GET user-info ───────────────────────────────────────────────────────
  @override
  Future<NetworkResult<AvatarUserInfo>> getUserInfo({
    required int userId,
  }) async {
    try {
      final response = await _avatarApi.getUserInfo(userId);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── 2. POST select-mascot (multipart) ─────────────────────────────────────
  @override
  Future<NetworkResult<AvatarResult>> selectMascot({
    required int    userId,
    required String mascotId,
    required File   avatarFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'userId':   userId.toString(),
        'mascotId': mascotId,
        'avatarFile': await MultipartFile.fromFile(
          avatarFile.path,
          filename: 'avatar_$mascotId.png',
        ),
      });

      final response = await _avatarApi.selectMascot(formData);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── 3. POST customize ─────────────────────────────────────────────────────
  @override
  Future<NetworkResult<AvatarResult>> customizeAvatar({
    required int          userId,
    required List<String> selectedItems,
    String                customPrompt = '',
  }) async {
    try {
      final body = <String, dynamic>{
        'userId':        userId,
        'selectedItems': selectedItems,
        if (customPrompt.trim().isNotEmpty)
          'customPrompt': customPrompt.trim(),
      };

      final response = await _avatarApi.customizeAvatar(body);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Error parser (same pattern) ───────────────────────────────────────────
  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}