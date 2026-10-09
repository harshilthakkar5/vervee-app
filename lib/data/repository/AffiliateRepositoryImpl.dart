
import 'package:dio/dio.dart';

//import '../../domain/model/affiliate/AffiliateInfo.dart';
import '../../domain/model/promo_code/AffiliateInfo.dart';
import '../../domain/repository/AffiliateRepository.dart';
import '../../utils/NetworkResult.dart';
import '../remort/AffiliateApi.dart';

class AffiliateRepositoryImpl implements AffiliateRepository {
  final AffiliateApi _affiliateApi;

  AffiliateRepositoryImpl(this._affiliateApi);

  @override
  Future<NetworkResult<AffiliateInfo>> getMyAffiliate() async {
    try {
      final response = await _affiliateApi.getMyAffiliate();

      // DTO → Domain
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