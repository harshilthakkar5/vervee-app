
// ─── LAYER 5: State + ViewModel (UPDATED) ─────────────────────────────────────
// File: lib/features/post/presentation/viewmodel/get_post_view_model.dart
//
// Changes:
//   ✅ toggleLike  → ab real API call hoti hai (optimistic + rollback on error)
//   ✅ likePost    → new real API method
//   ✅ addComment  → naya
//   ✅ deletePost  → naya (optimistic remove + rollback)
//   ✅ updatePost  → naya (optimistic update + rollback)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../di/PostModule.dart';
import '../../../domain/model/post/GetPost.dart';
import '../../../domain/model/post/PostComment.dart';
import '../../../utils/AuthService.dart';
import '../../../utils/NetworkResult.dart';
import '../../../utils/PostCacheService.dart';
import '../pofile/ProfileViewmodels.dart';
//import '../../domain/entities/get_post.dart';
//import '../../domain/entities/post_comment.dart';
//import '../../../auth/data/services/auth_service.dart';
//import '../../data/di/post_module.dart';  // postRepositoryProvider

part 'GetPostViewModel.freezed.dart';
part 'GetPostViewModel.g.dart';

// ─── State ────────────────────────────────────────────────────────────────────
@freezed
sealed class GetPostState with _$GetPostState {
  const factory GetPostState({
    @Default([])    List<GetPost> posts,

    // Pagination
    @Default(1)     int  currentPage,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedEnd,

    // Filters
    @Default('')    String searchQuery,
    @Default('All') String selectedCategory,

    // Per-post comment submitting state (postId → isLoading)
    @Default({}) Map<int, bool> commentLoading,

    // Error
    String? errorMessage,
  }) = _GetPostState;
}

// ─── ViewModel ────────────────────────────────────────────────────────────────
@riverpod
class GetPostViewModel extends _$GetPostViewModel {

  static const int _limit = 5;

  @override
  GetPostState build() {
    Future.microtask(() => loadPosts());
    return const GetPostState();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // EXISTING METHODS (unchanged)
  // ────────────────────────────────────────────────────────────────────────────

  // Future<void> loadPosts({bool isRefresh = false}) async {
  //   if (state.isLoading) return;
  //
  //   state = state.copyWith(
  //     isLoading:    true,
  //     errorMessage: null,
  //     posts:        isRefresh ? [] : state.posts,
  //     currentPage:  isRefresh ? 1  : state.currentPage,
  //     hasReachedEnd: isRefresh ? false : state.hasReachedEnd,
  //   );
  //
  //   final result = await ref.read(postRepositoryProvider).getPosts(
  //     page:     1,
  //     limit:    _limit,
  //     search:   state.searchQuery,
  //     category: state.selectedCategory,
  //   );
  //
  //   result.when(
  //     initial: () {},
  //     loading: () {},
  //     success: (posts) => state = state.copyWith(
  //       posts:        posts,
  //       currentPage:  1,
  //       isLoading:    false,
  //       hasReachedEnd: posts.length < _limit,
  //     ),
  //     error: (message, _) => state = state.copyWith(
  //       isLoading:    false,
  //       errorMessage: message,
  //     ),
  //   );
  // }

  // ── loadPosts — cache pehle, phir API ────────────────────────────────────────
  Future<void> loadPosts({bool isRefresh = false}) async {
    if (state.isLoading) return;

    // ✅ isRefresh nahi hai toh pehle cache check karo
    if (!isRefresh) {
      final cached = await PostCacheService.loadPosts(state.selectedCategory);

      if (cached != null && cached.isNotEmpty) {
        // ✅ Cache se instantly dikhao — loading nahi
        state = state.copyWith(
          posts:        cached,
          isLoading:    false,
          currentPage:  1,
          hasReachedEnd: cached.length < _limit,
          errorMessage: null,
        );

        // ✅ Cache expire ho gayi toh background me fresh data lao
        // final valid = await PostCacheService.isCacheValid(state.selectedCategory);
        // if (!valid)
          _backgroundRefresh();

        return; // Cache se show kar diya
      }
    }

    // ✅ Cache nahi hai ya force refresh — normal flow
    state = state.copyWith(
      isLoading:    true,
      errorMessage: null,
      posts:        isRefresh ? [] : state.posts,
      currentPage:  isRefresh ? 1  : state.currentPage,
      hasReachedEnd: isRefresh ? false : state.hasReachedEnd,
    );

    final result = await ref.read(postRepositoryProvider).getPosts(
      page:     1,
      limit:    _limit,
      search:   state.searchQuery,
      category: state.selectedCategory,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (posts) {
        state = state.copyWith(
          posts:        posts,
          currentPage:  1,
          isLoading:    false,
          hasReachedEnd: posts.length < _limit,
        );
        // ✅ Fresh data cache me save karo
        PostCacheService.savePosts(
          posts:    posts,
          category: state.selectedCategory,
        );
      },
      error: (message, _) => state = state.copyWith(
        isLoading:    false,
        errorMessage: message,
      ),
    );
  }

// ✅ Background refresh — user ko pata nahi chalega
  Future<void> _backgroundRefresh() async {
    try {
      final result = await ref.read(postRepositoryProvider).getPosts(
        page:     1,
        limit:    _limit,
        search:   state.searchQuery,
        category: state.selectedCategory,
      );

      result.when(
        initial: () {},
        loading: () {},
        success: (posts) {
          // ✅ Silently update + cache save
          state = state.copyWith(posts: posts);
          PostCacheService.savePosts(
            posts:    posts,
            category: state.selectedCategory,
          );
        },
        error: (_, __) {}, // Fail ho toh ignore
      );
    } catch (_) {}
  }

// ✅ refresh() — cache clear karke fresh data lao
  Future<void> refresh() async {
    await PostCacheService.clearAllCache();
    return loadPosts(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    final result = await ref.read(postRepositoryProvider).getPosts(
      page:     nextPage,
      limit:    _limit,
      search:   state.searchQuery,
      category: state.selectedCategory,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (newPosts) => state = state.copyWith(
        posts:         [...state.posts, ...newPosts],
        currentPage:   nextPage,
        isLoadingMore: false,
        hasReachedEnd: newPosts.length < _limit,
      ),
      error: (message, _) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage:  message,
      ),
    );
  }

  Future<void> filterByCategory(String category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    await loadPosts(isRefresh: true);
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    await loadPosts(isRefresh: true);
  }

 // Future<void> refresh() => loadPosts(isRefresh: true);

  // ────────────────────────────────────────────────────────────────────────────
  // ✅ LIKE / UNLIKE — Optimistic update + real API + rollback on error
  // ────────────────────────────────────────────────────────────────────────────

  Future<String?> toggleLike(int postId) async {
    final currentPost = state.posts.firstWhere(
          (p) => p.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    // Optimistic update
    final optimisticPosts = state.posts.map((post) {
      if (post.id != postId) return post;
      return post.copyWith(
        isLiked:    !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
    }).toList();
    state = state.copyWith(posts: optimisticPosts);

    final userId = await AuthService.instance.getUserId();
    if (userId == null) {
      _rollbackPost(currentPost);
      return 'Login required to like a post.';
    }

    // ✅ KEY FIX — isLiked check karo BEFORE optimistic update
    // currentPost.isLiked = purani value (optimistic se pehle)
    final NetworkResult result;
    if (currentPost.isLiked) {
      // ✅ Pehle se liked tha → UNLIKE karo
      result = await ref.read(postRepositoryProvider).unlikePost(
        postId: postId,
        userId: userId,
      );
    } else {
      // ✅ Liked nahi tha → LIKE karo
      result = await ref.read(postRepositoryProvider).likePost(
        postId: postId,
        userId: userId,
      );
    }

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (likeResult) {
        final syncedPosts = state.posts.map((post) {
          if (post.id != postId) return post;
          return post.copyWith(
            isLiked:    likeResult.liked,
            likesCount: likeResult.likesCount,
          );
        }).toList();
        state = state.copyWith(posts: syncedPosts);
        return null;
      },
      error: (message, _) {
        _rollbackPost(currentPost);
        return message;
      },
    );
  }

  /// Optimistic rollback helper — purani post restore karo
  void _rollbackPost(GetPost original) {
    final rolledBack = state.posts.map((p) {
      return p.id == original.id ? original : p;
    }).toList();
    state = state.copyWith(posts: rolledBack);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ✅ ADD COMMENT
  // ────────────────────────────────────────────────────────────────────────────

  /// Returns: `null` on success, error message string on failure
  Future<PostComment?> addComment({
    required int    postId,
    required String content,
  }) async {
    // Loading state set karo for this post
    state = state.copyWith(
      commentLoading: {...state.commentLoading, postId: true},
    );

    final result = await ref.read(postRepositoryProvider).addComment(
      postId:  postId,
      content: content,
    );

    // Loading hatao
    final updatedLoading = Map<int, bool>.from(state.commentLoading);
    updatedLoading.remove(postId);
    state = state.copyWith(commentLoading: updatedLoading);

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (comment) => comment,   // caller ko comment return karo
      error:   (message, _) => null,   // caller ko null milega → error handle karo
    );
  }

  /// Comment ki loading state check karo for given postId
  bool isCommentLoading(int postId) =>
      state.commentLoading[postId] == true;

  // ────────────────────────────────────────────────────────────────────────────
  // ✅ GET COMMENT
  // ────────────────────────────────────────────────────────────────────────────

  Future<List<PostComment>> fetchComments(int postId) async {
    final result = await ref.read(postRepositoryProvider).getComments(postId);

    return result.when(
      initial: () => [],
      loading: () => [],
      success: (comments) => comments,
      error:   (message, _) => [],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ✅ DELETE POST — Optimistic remove + rollback on error
  // ────────────────────────────────────────────────────────────────────────────

  /// Returns: `null` on success, error message string on failure
  Future<String?> deletePost(int postId) async {
    // Step 1 — Post save karo rollback ke liye
    final postToDelete = state.posts.firstWhere(
          (p) => p.id == postId,
      orElse: () => throw Exception('Post not found'),
    );
    final indexToDelete = state.posts.indexOf(postToDelete);

    // Step 2 — Optimistic remove
    final updatedPosts = state.posts.where((p) => p.id != postId).toList();
    state = state.copyWith(posts: updatedPosts);

    // Step 3 — Real API call
    final result = await ref.read(postRepositoryProvider).deletePost(postId);

    return result.when(
      initial: () => null,
      loading: () => null,
      //success: (_) => null,  // ✅ Success — post permanently removed
      success: (_) {
        // remove from local state...

        // ✅ NEW — Profile ka feed bhi sync karo
        ref.read(userFeedViewModelProvider.notifier).refresh();
        return null;
      },
      error:   (message, _) {
        // ✅ Rollback — post wapas add karo original position par
        final restored = List<GetPost>.from(state.posts);
        restored.insert(indexToDelete.clamp(0, restored.length), postToDelete);
        state = state.copyWith(posts: restored);
        return message;
      },
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // ✅ UPDATE POST — Optimistic update + rollback on error
  // ────────────────────────────────────────────────────────────────────────────

  /// Returns: `null` on success, error message string on failure
  Future<String?> updatePost({
    required int postId,
    String? title,
    String? content,
    String? category,
    File?   file,
  }) async {

    // Step 1 — Purana post save karo (rollback + merge ke liye)
    final oldPost = state.posts.firstWhere(
          (p) => p.id == postId,
      orElse: () => throw Exception('Post not found'),
    );

    // Step 2 — Optimistic update
    final optimistic = state.posts.map((p) {
      if (p.id != postId) return p;
      return p.copyWith(
        title:    title    ?? p.title,
        content:  content  ?? p.content,
        category: category ?? p.category,
      );
    }).toList();
    state = state.copyWith(posts: optimistic);

    // Step 3 — Real API call
    final result = await ref.read(postRepositoryProvider).updatePost(
      postId:   postId,
      title:    title,
      content:  content,
      category: category,
      file:     file,
    );

    return result.when(
      initial: () => null,
      loading: () => null,
      success: (createdPost) {
        // ✅ createdPost = CreatePost (server se aaya)
        // ✅ oldPost se isLiked, isOwner, userRole, userName preserve karo
        final synced = state.posts.map((p) {
          if (p.id != postId) return p;
          return p.copyWith(
            title:      createdPost.title,
           // content:    createdPost.content,
            content:    createdPost.content ?? p.content,
            category:   createdPost.category,
            filePath:   createdPost.filePath,
            fileType:   createdPost.fileType,
            mimeType:   createdPost.mimeType,
            likesCount: createdPost.likesCount,
            // ✅ Server nahi bhejta — oldPost se preserve
            isLiked:    oldPost.isLiked,
            isOwner:    oldPost.isOwner,
            userRole:   oldPost.userRole,
            userName:   oldPost.userName,
          );
        }).toList();
        state = state.copyWith(posts: synced);
        ref.read(userFeedViewModelProvider.notifier).refresh();
        return null;
      },
      error: (message, _) {
        _rollbackPost(oldPost);
        return message;
      },
    );
  }




  // Future<String?> updatePost({
  //   required int    postId,
  //   required String title,
  //   required String content,
  //   required String category,
  //   File? file,
  // }) async {
  //   // Step 1 — Old post save karo rollback ke liye
  //   final oldPost = state.posts.firstWhere(
  //         (p) => p.id == postId,
  //     orElse: () => throw Exception('Post not found'),
  //   );
  //
  //   // Step 2 — Optimistic update (text fields immediately reflect)
  //   final optimistic = state.posts.map((p) {
  //     if (p.id != postId) return p;
  //     return p.copyWith(
  //       title:    title,
  //       content:  content,
  //       category: category,
  //       // filePath optimistic nahi change karte (binary unknown)
  //     );
  //   }).toList();
  //   state = state.copyWith(posts: optimistic);
  //
  //   // Step 3 — Real API call
  //   final result = await ref.read(postRepositoryProvider).updatePost(
  //     postId:   postId,
  //     title:    title,
  //     content:  content,
  //     category: category,
  //     file:     file,
  //   );
  //
  //   return result.when(
  //     initial: () => null,
  //     loading: () => null,
  //     success: (updatedPost) {
  //       // ✅ API se aaya actual updated post (new filePath bhi include)
  //       final synced = state.posts.map((p) {
  //         return p.id == postId ? updatedPost : p;
  //       }).toList();
  //       state = state.copyWith(posts: synced);
  //       return null;
  //     },
  //     error: (message, _) {
  //       // ✅ Rollback
  //       _rollbackPost(oldPost);
  //       return message;
  //     },
  //   );
  // }
}








// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:vervee_app/domain/model/post/GetPost.dart';
// import '../../../di/PostModule.dart';
// import '../../../utils/NetworkResult.dart';
// // import '../../di/post_module.dart';
// // import '../../domain/models/feed_post.dart';
//
// part 'GetPostViewModel.freezed.dart';
// part 'GetPostViewModel.g.dart';
//
// // ─── State ────────────────────────────────────────────────────────────────────
// @freezed
// sealed class GetPostState with _$GetPostState {
//   const factory GetPostState({
//     // ✅ Posts list — accumulated (pagination ke liye append hoti hai)
//     @Default([]) List<GetPost> posts,
//
//     // ✅ Pagination
//     @Default(1)     int currentPage,
//     @Default(false) bool isLoading,        // first load / refresh
//     @Default(false) bool isLoadingMore,    // pagination load
//     @Default(false) bool hasReachedEnd,    // aur posts nahi hain
//
//     // ✅ Filters
//     @Default('') String searchQuery,
//     @Default('All') String selectedCategory,
//
//     // ✅ Error
//     String? errorMessage,
//   }) = _GetPostState;
// }
//
// // ─── ViewModel ────────────────────────────────────────────────────────────────
// @riverpod
// class GetPostViewModel extends _$GetPostViewModel {
//
//   static const int _limit = 5;
//
//   @override
//   GetPostState build() {
//     // ✅ Screen open hote hi posts load karo
//     Future.microtask(() => loadPosts());
//     return const GetPostState();
//   }
//
//   // ── Initial load / Refresh ─────────────────────────────────────────────────
//   Future<void> loadPosts({bool isRefresh = false}) async {
//     // Already loading hai to ignore karo
//     if (state.isLoading) return;
//
//     state = state.copyWith(
//       isLoading: true,
//       errorMessage: null,
//       // ✅ Refresh pe posts reset karo aur page 1 se shuru karo
//       posts: isRefresh ? [] : state.posts,
//       currentPage: isRefresh ? 1 : state.currentPage,
//       hasReachedEnd: isRefresh ? false : state.hasReachedEnd,
//     );
//
//     final result = await ref.read(postRepositoryProvider).getPosts(
//       page: 1,
//       limit: _limit,
//       search: state.searchQuery,
//       category: state.selectedCategory,
//     );
//
//     result.when(
//       initial: () {},
//       loading: () {},
//       success: (posts) {
//         state = state.copyWith(
//           posts: posts,
//           currentPage: 1,
//           isLoading: false,
//           // ✅ Agar limit se kam aaya to end aa gaya
//           hasReachedEnd: posts.length < _limit,
//         );
//       },
//       error: (message, _) {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: message,
//         );
//       },
//     );
//   }
//
//   // ── Load More (Pagination) ─────────────────────────────────────────────────
//   Future<void> loadMore() async {
//     // Already loading hai ya end aa gaya to ignore karo
//     if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;
//
//     state = state.copyWith(isLoadingMore: true);
//
//     final nextPage = state.currentPage + 1;
//
//     final result = await ref.read(postRepositoryProvider).getPosts(
//       page: nextPage,
//       limit: _limit,
//       search: state.searchQuery,
//       category: state.selectedCategory,
//     );
//
//     result.when(
//       initial: () {},
//       loading: () {},
//       success: (newPosts) {
//         state = state.copyWith(
//           // ✅ Purani list ke saath append karo
//           posts: [...state.posts, ...newPosts],
//           currentPage: nextPage,
//           isLoadingMore: false,
//           hasReachedEnd: newPosts.length < _limit,
//         );
//       },
//       error: (message, _) {
//         state = state.copyWith(
//           isLoadingMore: false,
//           errorMessage: message,
//         );
//       },
//     );
//   }
//
//   // ── Category Filter ────────────────────────────────────────────────────────
//   Future<void> filterByCategory(String category) async {
//     if (state.selectedCategory == category) return;
//     state = state.copyWith(selectedCategory: category);
//     await loadPosts(isRefresh: true);
//   }
//
//   // ── Search ─────────────────────────────────────────────────────────────────
//   Future<void> search(String query) async {
//     state = state.copyWith(searchQuery: query);
//     await loadPosts(isRefresh: true);
//   }
//
//   // ── Like/Unlike toggle (optimistic update) ─────────────────────────────────
//   // ✅ API call baad mein add karna — abhi UI instant update karo
//   void toggleLike(int postId) {
//     final updatedPosts = state.posts.map((post) {
//       if (post.id == postId) {
//         return post.copyWith(
//           isLiked: !post.isLiked,
//           likesCount: post.isLiked
//               ? post.likesCount - 1
//               : post.likesCount + 1,
//         );
//       }
//       return post;
//     }).toList();
//
//     state = state.copyWith(posts: updatedPosts);
//   }
//
//   // ── New post add karo (Create Post success pe) ─────────────────────────────
//   // ✅ Refresh karne ki jagah sirf list ke top pe add karo
//   Future<void> refresh() => loadPosts(isRefresh: true);
// }