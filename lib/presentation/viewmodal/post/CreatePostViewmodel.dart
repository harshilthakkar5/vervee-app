
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/PostModule.dart';
import '../../../domain/model/post/CreatePost.dart';
import '../../../utils/NetworkResult.dart';
// import '../../di/post_module.dart';
// import '../../domain/models/post.dart';
//
//part 'CreatePostViewmodel.freezed.dart';
part 'CreatePostViewmodel.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────
// @freezed
// sealed class CreatePostState with _$CreatePostState {
//   const factory CreatePostState.initial()              = _Initial;
//   const factory CreatePostState.loading()              = _Loading;
//   const factory CreatePostState.success(CreatePost post)     = _Success;
//   const factory CreatePostState.error(String message)  = _Error;
// }
//
// // ── ViewModel ─────────────────────────────────────────────────────────────────
// @riverpod
// class CreatePostViewModel extends _$CreatePostViewModel {
//   @override
//   CreatePostState build() => const CreatePostState.initial();
//
//   Future<void> createPost({
//     required String title,
//     required String content,
//     required String category,
//     File? file,
//   }) async {
//     state = const CreatePostState.loading();
//
//     final result = await ref.read(postRepositoryProvider).createPost(
//       title: title,
//       content: content,
//       category: category,
//       file: file,
//     );
//
//     state = result.when(
//       success: (post) => CreatePostState.success(post),
//       error: (message, _) => CreatePostState.error(message),
//       loading: () => const CreatePostState.loading(),
//     );
//   }
//
//   void reset() => state = const CreatePostState.initial();
// }

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {

  @override
  NetworkResult<CreatePost> build() => const NetworkResult.initial();

  Future<void> createPost({
    required String title,
    required String content,
    required String category,
    File? file,
  }) async {
    if (title.trim().isEmpty) {
      state = const NetworkResult.error(message: 'Please enter a post title.');
      return;
    }

    state = const NetworkResult.loading();

    final result = await ref.read(postRepositoryProvider).createPost(
      title: title,
      content: content,
      category: category,
      file: file,
    );

    state = result;
  }

  void reset() => state = const NetworkResult.initial();
}
