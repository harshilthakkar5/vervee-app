
import 'package:dio/dio.dart';
//import '../../domain/model/reel/ReelPost.dart';
import '../../domain/model/post/ReelPost.dart';
import '../../domain/repository/ReelRepository.dart';
import '../../utils/NetworkResult.dart';
import '../remort/ReelApi.dart';

class ReelRepositoryImpl implements ReelRepository {
  final ReelApi _reelApi;
  ReelRepositoryImpl(this._reelApi);

  @override
  Future<NetworkResult<List<ReelPost>>> getReels({
    required int page,
    required int limit,
    int? initialPostId,
  }) async {
    try {
      final response = await _reelApi.getReels(
        page: page,
        limit: limit,
        initialPostId: initialPostId,
      );
      final posts = response.map((e) => e.toDomain()).toList();
      return NetworkResult.success(posts);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Error Parser (baki repositories jaisa hi) ────────────────────
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