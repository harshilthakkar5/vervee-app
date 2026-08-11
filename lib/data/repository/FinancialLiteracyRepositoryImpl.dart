
import 'package:dio/dio.dart';
import '../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';
import '../../domain/model/FinancialLiteracy/FinancialLiteracyDetail.dart';
import '../../domain/repository/FinancialLiteracyRepository.dart';
import '../../utils/NetworkResult.dart';
import '../remort/FinancialLiteracyApi.dart';
// import 'financial_literacy_api.dart';
// import 'financial_literacy_dto.dart';


// ═══════════════════════════════════════════════════════════════════════════════
//  IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════════
class FinancialLiteracyRepositoryImpl implements FinancialLiteracyRepository {
  final FinancialLiteracyApi _api;

  FinancialLiteracyRepositoryImpl(this._api);

  // ── GET /learn-about-financial ─────────────────────────────────────────────
  @override
  Future<NetworkResult<List<FinancialLiteracyCourse>>> getCourses() async {
    try {
      final response = await _api.getCourses();
      final courses = response.map((dto) => dto.toDomain()).toList();
      return NetworkResult.success(courses);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── GET /learn-about-financial/{id} ───────────────────────────────────────
  @override
  Future<NetworkResult<FinancialLiteracyDetail>> getCourseDetail(int id) async {
    try {
      final response = await _api.getCourseDetail(id);
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

  // ── Dio error parser (PostRepository jaisa) ───────────────────────────────
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