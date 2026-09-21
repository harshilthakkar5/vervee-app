
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../di/ReelModule.dart';
import '../../../utils/NetworkResult.dart';
import 'ReelState.dart';

part 'ReelViewModel.g.dart';

// ✅ Family provider — har initialPostId ke liye alag state,
// isliye reelViewModelProvider(841) jaise call hoga
@riverpod
class ReelViewModel extends _$ReelViewModel {
  static const int _limit = 10;

  @override
  ReelState build(int initialPostId) {
    Future.microtask(() => _loadInitial(initialPostId));
    return const ReelState();
  }

  // ── Pehla page load karo, tapped post ke context ke saath ───────
  Future<void> _loadInitial(int initialPostId) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(reelRepositoryProvider).getReels(
      page: 1,
      limit: _limit,
      initialPostId: initialPostId,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (posts) {
        state = state.copyWith(
          posts: posts,
          isLoading: false,
          currentPage: 1,
          hasReachedEnd: posts.length < _limit,
        );
      },
      error: (message, _) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  // ── Infinite scroll — end ke paas pahunchte hi call hoga ────────
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    final result = await ref.read(reelRepositoryProvider).getReels(
      page: nextPage,
      limit: _limit,
    );

    result.when(
      initial: () {},
      loading: () {},
      success: (newPosts) {
        // ✅ duplicate-guard — page 1 ka initialPostId context overlap na kare
        final existingIds = state.posts.map((p) => p.id).toSet();
        final uniqueNew = newPosts.where((p) => !existingIds.contains(p.id)).toList();

        state = state.copyWith(
          posts: [...state.posts, ...uniqueNew],
          isLoadingMore: false,
          currentPage: nextPage,
          hasReachedEnd: newPosts.length < _limit,
        );
      },
      error: (message, _) {
        state = state.copyWith(isLoadingMore: false, errorMessage: message);
      },
    );
  }

  // ── Like toggle ke baad list state ko sync me rakho (optimistic UI) ─
  void updateLikeLocally(int postId, bool isLiked, int likesCount) {
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id != postId) return p;
        return p.copyWith(isLiked: isLiked, likesCount: likesCount);
      }).toList(),
    );
  }

  Future<void> refresh(int initialPostId) => _loadInitial(initialPostId);
}