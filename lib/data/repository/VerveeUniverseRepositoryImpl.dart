
import 'package:dio/dio.dart';

import '../../domain/model/VerveeUniverse/VerveeUniverseDetail.dart';
import '../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';
import '../../domain/repository/VerveeUniverseRepository.dart';
import '../../utils/NetworkResult.dart';
import '../remort/VerveeUniverseApi.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════════
class VerveeUniverseRepositoryImpl implements VerveeUniverseRepository {
  final VerveeUniverseApi _api;

  VerveeUniverseRepositoryImpl(this._api);

  // ── GET /vervee-universe ────────────────────────────────────────────────────
  @override
  Future<NetworkResult<List<VerveeUniverseItem>>> getUniverseItems() async {
    try {
      final response = await _api.getUniverseItems();
      final items = response.map((dto) => dto.toDomain()).toList();
      return NetworkResult.success(items);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── GET /vervee-universe/{id} ───────────────────────────────────────────────
  @override
  Future<NetworkResult<VerveeUniverseDetail>> getUniverseItemDetail(
      int id,
      ) async {
    try {
      final response = await _api.getUniverseItemDetail(id);
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

  // ── Dio error parser (FinancialLiteracyRepositoryImpl jaisa) ────────────────
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
