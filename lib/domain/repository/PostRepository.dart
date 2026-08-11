
import 'dart:io';
import 'package:vervee_app/domain/model/post/CreatePost.dart';
import '../../utils/NetworkResult.dart';
import '../model/post/GetPost.dart';
import '../model/post/LikePost.dart';
import '../model/post/PostComment.dart';

abstract interface class PostRepository {

  // ── Create Post ────────────────────────────────────────────────────────────
  Future<NetworkResult<CreatePost>> createPost({
    required String title,
    required String content,
    required String category,
    File? file,
  });

  // // ── Get Posts ──────────────────────────────────────────────────────────────
  // Future<NetworkResult<List<GetPost>>> getPosts({
  //   required int page,
  //   required int limit,
  //   String search,
  //   String category,
  // });

  // ── Get All Posts (paginated) ──────────────────────────────────────────────
  Future<NetworkResult<List<GetPost>>> getPosts({
    required int page,
    required int limit,
    String search   = '',
    String category = 'All',
  });

  // ── Get Single Post ────────────────────────────────────────────────────────
  Future<NetworkResult<GetPost>> getSinglePost(int postId);

  // ── Like / Unlike ──────────────────────────────────────────────────────────
  Future<NetworkResult<LikePost>> likePost({
    required int postId,
    required int userId,
  });

  // ── Like / Unlike ──────────────────────────────────────────────────────────
  Future<NetworkResult<LikePost>> unlikePost({
    required int postId,
    required int userId,
  });

  // ── Add Comment ────────────────────────────────────────────────────────────
  Future<NetworkResult<PostComment>> addComment({
    required int    postId,
    required String content,
  });

  // ── Get Comment ────────────────────────────────────────────────────────────
  Future<NetworkResult<List<PostComment>>> getComments(int postId);

  // ── Delete Post ────────────────────────────────────────────────────────────
  Future<NetworkResult<void>> deletePost(int postId);

  // ── Update Post ────────────────────────────────────────────────────────────
  // ✅ CreatePost return — optional fields
  Future<NetworkResult<CreatePost>> updatePost({
    required int postId,
    String? title,
    String? content,
    String? category,
    File?   file,
  });


  // Future<NetworkResult<GetPost>> updatePost({
  //   required int    postId,
  //   required String title,
  //   required String content,
  //   required String category,
  //   File? file,
  // });
}






























