
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/post/post_comment/CommentResponse.dart';
import '../dto/post/post_create/CreatePostResponse.dart';
import '../dto/post/post_get/GetPostResponse.dart';
import '../dto/post/post_like/LikePostResponse.dart';

part 'PostApi.g.dart';

@RestApi()
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  // ── Create Post ────────────────────────────────────────────────────────────
 // // Multipart → FormData directly pass karo:
  @POST('/posts')
  @MultiPart()
  Future<CreatePostResponse> createPost(@Body() FormData formData);

  // ── Get All Posts (paginated) ──────────────────────────────────────────────
  // Query params: page, limit, search, category
  @GET('/posts')
  Future<List<GetPostResponse>> getPosts({
    @Query('page')     required int page,
    @Query('limit')    required int limit,
    @Query('search') String search = '',
    @Query('category') String category = 'All',
    // @Query('search')   @Default('') String search,
    // @Query('category') @Default('All') String category,
  });

  // ── Get Single Post ────────────────────────────────────────────────────────
  // GET /posts/{postId}
  @GET('/posts/{postId}')
  Future<GetPostResponse> getSinglePost(@Path('postId') int postId);

  // ── Like ──────────────────────────────────────────────────────────
  // POST /likes   body: { postId, userId }
  // Response: { liked: bool, likesCount: int }
  @POST('/likes')
  Future<LikePostResponse> likePost(@Body() Map<String, dynamic> body);

  // ── Unlike ──────────────────────────────────────────────────────────
  // POST /likes   body: { postId, userId }
  // Response: { liked: bool, likesCount: int }
  @DELETE('/likes')
  Future<LikePostResponse> unlikePost(@Body() Map<String, dynamic> body);

  // ── Add Comment ────────────────────────────────────────────────────────────
  // POST /posts/{postId}/comments   body: { content }
  // Response: { id, content, createdAt, user: { name } }
  @POST('/posts/{postId}/comments')
  Future<CommentResponse> addComment(
      @Path('postId') int    postId,
      @Body()         Map<String, dynamic> body,
      );

  // ── Get Comment ────────────────────────────────────────────────────────
  // GET /posts/{postId}
  @GET('/posts/{postId}/comments')
  Future<List<CommentResponse>> getComments(@Path('postId') int postId);

  // ── Delete Post ────────────────────────────────────────────────────────────
  // DELETE /posts/{postId}
  // Response: deleted post object (GetPostResponse shape) — we ignore the body
  @DELETE('/posts/{postId}')
  Future<void> deletePost(@Path('postId') int postId);
  // @DELETE('/posts/{postId}')
  // Future<GetPostResponse> deletePost(@Path('postId') int postId);

  // ── Update Post (PATCH — multipart FormData) ───────────────────────────────
  // PATCH /posts/{postId}
  // FormData: { title, content, category, file? }
  @PATCH('/posts/{postId}')
  @MultiPart()
  Future<CreatePostResponse> updatePost(
      @Path('postId') int      postId,
      @Body()         FormData formData,
      );

  //
  //
  // @PATCH('/posts/{postId}')
  // @MultiPart()
  // Future<GetPostResponse> updatePost(
  //     @Path('postId') int      postId,
  //     @Body()         FormData formData,
  //     );
}






























