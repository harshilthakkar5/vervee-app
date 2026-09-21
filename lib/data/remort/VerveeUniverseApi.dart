
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/vervee_universe/VerveeUniverseDetailResponse.dart';
import '../dto/vervee_universe/VerveeUniverseItemResponse.dart';

//import '../dto/VerveeUniverse/VerveeUniverseDetailResponse.dart';
//import '../dto/VerveeUniverse/VerveeUniverseItemResponse.dart';

part 'VerveeUniverseApi.g.dart';

@RestApi()
abstract class VerveeUniverseApi {
  factory VerveeUniverseApi(Dio dio, {String baseUrl}) = _VerveeUniverseApi;

  /// GET /vervee-universe
  /// Returns list of all Vervee Universe items (with nested chapters + video)
  @GET('/vervee-universe')
  Future<List<VerveeUniverseItemDto>> getUniverseItems();

  /// GET /vervee-universe/{id}
  /// Returns single item detail — chapters include video + mcqs
  @GET('/vervee-universe/{id}')
  Future<VerveeUniverseDetailDto> getUniverseItemDetail(
      @Path('id') int id,
      );
}
