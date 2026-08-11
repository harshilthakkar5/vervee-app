
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/FinancialLiteracy/FinancialLiteracyDetailResponse.dart';
import '../dto/FinancialLiteracy/FinancialLiteracyItemResponse.dart';
//import 'financial_literacy_dto.dart';

part 'FinancialLiteracyApi.g.dart';

@RestApi()
abstract class FinancialLiteracyApi {
  factory FinancialLiteracyApi(Dio dio, {String baseUrl}) =
  _FinancialLiteracyApi;

  /// GET /learn-about-financial
  /// Returns list of all courses (with nested videos)
  @GET('/learn-about-financial')
  Future<List<FinancialLiteracyItemDto>> getCourses();

  /// GET /learn-about-financial/{id}
  /// Returns single course detail with MCQs
  @GET('/learn-about-financial/{id}')
  Future<FinancialLiteracyDetailDto> getCourseDetail(
      @Path('id') int id,
      );
}

