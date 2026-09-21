
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/post/reel_post/ReelPostResponse.dart';
//import '../dto/reel/ReelPostResponse.dart';

part 'ReelApi.g.dart';

@RestApi()
abstract class ReelApi {
  factory ReelApi(Dio dio, {String baseUrl}) = _ReelApi;

  // ── GET /posts/reels?page=&limit=&initialPostId= ────────────────
  // page 1 pe initialPostId bhejo taaki backend tapped video ke
  // aas-paas ka context de sake. Aage ke pages me sirf page/limit.
  @GET('/posts/reels')
  Future<List<ReelPostResponse>> getReels({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('initialPostId') int? initialPostId,
  });
}