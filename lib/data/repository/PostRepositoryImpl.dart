
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vervee_app/domain/model/post/CreatePost.dart';
import 'package:vervee_app/domain/model/post/GetPost.dart';
// import '../../data/remote/post_api.dart';
// import '../../data/dto/CreatePostRequest.dart';
// import '../../domain/models/post.dart';
import '../../domain/model/post/LikePost.dart';
import '../../domain/model/post/PostComment.dart';
import '../../domain/repository/PostRepository.dart';
//import '../../domain/repository/post_repository.dart';
import '../../utils/NetworkResult.dart';
//import '../../utils/network_result.dart';
import '../dto/post/post_create/CreatePostRequest.dart';
import '../dto/post/post_update/UpdatePostRequest.dart';
import '../remort/PostApi.dart';

class PostRepositoryImpl implements PostRepository {
  final PostApi _postApi;

  PostRepositoryImpl(this._postApi);

  // ── Create Post ────────────────────────────────────────────────────────────
  @override
  Future<NetworkResult<CreatePost>> createPost({
    required String title,
    required String content,
    required String category,
    File? file,
  }) async {
    try {
      final formData = await CreatePostRequest(
        title: title,
        content: content,
        category: category,
        file: file,
      ).toFormData();

      final response = await _postApi.createPost(formData);

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

  // ── Get All Posts ──────────────────────────────────────────────────────────────
  @override
  Future<NetworkResult<List<GetPost>>> getPosts({
    required int page,
    required int limit,
    String search = '',
    String category = 'All',
  }) async {
    try {
      final response = await _postApi.getPosts(
        page: page,
        limit: limit,
        search: search,
        category: category,
      );

      // ✅ DTO list → Domain list
      final posts = response.map((item) => item.toDomain()).toList();
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

  // ── Get Single Post ────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<GetPost>> getSinglePost(int postId) async {
    try {
      final response = await _postApi.getSinglePost(postId);
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

  // ── Like ──────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<LikePost>> likePost({
    required int postId,
    required int userId,
  }) async {
    try {
      final response = await _postApi.likePost({
        'postId': postId,
        'userId': userId,
      });
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

  // ── Unlike ──────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<LikePost>> unlikePost({
    required int postId,
    required int userId,
  }) async {
    try {
      final response = await _postApi.unlikePost({
        'postId': postId,
        'userId': userId,
      });
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

  // ── Add Comment ────────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<PostComment>> addComment({
    required int    postId,
    required String content,
  }) async {
    try {
      final response = await _postApi.addComment(
        postId,
        {'content': content},
      );
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

  // ── Get Comment ────────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<List<PostComment>>> getComments(int postId) async {
    try {
      final response = await _postApi.getComments(postId);
      final comments = response.map((c) => c.toDomain()).toList();
      return NetworkResult.success(comments);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Delete Post ────────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<void>> deletePost(int postId) async {
    try {
      await _postApi.deletePost(postId);       // response body ignore karo
      return const NetworkResult.success(null);
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Update Post ────────────────────────────────────────────────────────────  ✅ NEW
  @override
  Future<NetworkResult<CreatePost>> updatePost({
    required int postId,
    String? title,
    String? content,
    String? category,
    File?   file,
  }) async {
    try {
      final formData = await UpdatePostRequest(
        title:    title,
        content:  content,
        category: category,
        file:     file,
      ).toFormData();

      final response = await _postApi.updatePost(postId, formData);

      // ✅ CreatePostResponse → CreatePost (no crash — user/isLiked nahi chahiye)
      return NetworkResult.success(response.toDomain());

    } on DioException catch (e) {
      return NetworkResult.error(
        message:    _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  // ── Error parser ───────────────────────────────────────────────────────────
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


//---------------------------- old update repository -------------------------->

// @override
// Future<NetworkResult<GetPost>> updatePost({
//   required int    postId,
//   required String title,
//   required String content,
//   required String category,
//   File? file,
// }) async {
//   try {
//     final formData = await UpdatePostRequest(
//       title:    title,
//       content:  content,
//       category: category,
//       file:     file,
//     ).toFormData();
//
//     final response = await _postApi.updatePost(postId, formData);
//     return NetworkResult.success(response.toDomain());
//   } on DioException catch (e) {
//     return NetworkResult.error(
//       message: _parseDioError(e),
//       statusCode: e.response?.statusCode,
//     );
//   } catch (e) {
//     return NetworkResult.error(message: 'Unexpected error: $e');
//   }
// }





























