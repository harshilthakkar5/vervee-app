
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

//import '../dto/affiliate/AffiliateResponse.dart';
import '../dto/promo_code/AffiliateResponse.dart';

part 'AffiliateApi.g.dart';

@RestApi()
abstract class AffiliateApi {
  factory AffiliateApi(Dio dio, {String baseUrl}) = _AffiliateApi;

  // Promo code + referred users (Bearer token dio se auto-attach hoga)
  @GET('/affiliate/me')
  Future<AffiliateResponse> getMyAffiliate();
}