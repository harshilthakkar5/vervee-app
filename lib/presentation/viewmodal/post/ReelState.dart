
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/post/ReelPost.dart';
//import '../../../domain/model/reel/ReelPost.dart';

part 'ReelState.freezed.dart';

@freezed
sealed class ReelState with _$ReelState {
  const factory ReelState({
    @Default([]) List<ReelPost> posts,
    @Default(false) bool isLoading,     // pehli baar load ho raha he
    @Default(false) bool isLoadingMore, // pagination — next page load ho raha he
    @Default(false) bool hasReachedEnd,
    @Default(1) int currentPage,
    String? errorMessage,
  }) = _ReelState;
}