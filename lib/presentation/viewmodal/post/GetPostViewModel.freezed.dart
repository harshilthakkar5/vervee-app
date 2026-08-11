// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetPostViewModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetPostState {

 List<GetPost> get posts;// Pagination
 int get currentPage; bool get isLoading; bool get isLoadingMore; bool get hasReachedEnd;// Filters
 String get searchQuery; String get selectedCategory;// Per-post comment submitting state (postId → isLoading)
 Map<int, bool> get commentLoading;// Error
 String? get errorMessage;
/// Create a copy of GetPostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPostStateCopyWith<GetPostState> get copyWith => _$GetPostStateCopyWithImpl<GetPostState>(this as GetPostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPostState&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedEnd, hasReachedEnd) || other.hasReachedEnd == hasReachedEnd)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&const DeepCollectionEquality().equals(other.commentLoading, commentLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),currentPage,isLoading,isLoadingMore,hasReachedEnd,searchQuery,selectedCategory,const DeepCollectionEquality().hash(commentLoading),errorMessage);

@override
String toString() {
  return 'GetPostState(posts: $posts, currentPage: $currentPage, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasReachedEnd: $hasReachedEnd, searchQuery: $searchQuery, selectedCategory: $selectedCategory, commentLoading: $commentLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $GetPostStateCopyWith<$Res>  {
  factory $GetPostStateCopyWith(GetPostState value, $Res Function(GetPostState) _then) = _$GetPostStateCopyWithImpl;
@useResult
$Res call({
 List<GetPost> posts, int currentPage, bool isLoading, bool isLoadingMore, bool hasReachedEnd, String searchQuery, String selectedCategory, Map<int, bool> commentLoading, String? errorMessage
});




}
/// @nodoc
class _$GetPostStateCopyWithImpl<$Res>
    implements $GetPostStateCopyWith<$Res> {
  _$GetPostStateCopyWithImpl(this._self, this._then);

  final GetPostState _self;
  final $Res Function(GetPostState) _then;

/// Create a copy of GetPostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? currentPage = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasReachedEnd = null,Object? searchQuery = null,Object? selectedCategory = null,Object? commentLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<GetPost>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedEnd: null == hasReachedEnd ? _self.hasReachedEnd : hasReachedEnd // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,commentLoading: null == commentLoading ? _self.commentLoading : commentLoading // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetPostState].
extension GetPostStatePatterns on GetPostState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetPostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetPostState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetPostState value)  $default,){
final _that = this;
switch (_that) {
case _GetPostState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetPostState value)?  $default,){
final _that = this;
switch (_that) {
case _GetPostState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GetPost> posts,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasReachedEnd,  String searchQuery,  String selectedCategory,  Map<int, bool> commentLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetPostState() when $default != null:
return $default(_that.posts,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasReachedEnd,_that.searchQuery,_that.selectedCategory,_that.commentLoading,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GetPost> posts,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasReachedEnd,  String searchQuery,  String selectedCategory,  Map<int, bool> commentLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _GetPostState():
return $default(_that.posts,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasReachedEnd,_that.searchQuery,_that.selectedCategory,_that.commentLoading,_that.errorMessage);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GetPost> posts,  int currentPage,  bool isLoading,  bool isLoadingMore,  bool hasReachedEnd,  String searchQuery,  String selectedCategory,  Map<int, bool> commentLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _GetPostState() when $default != null:
return $default(_that.posts,_that.currentPage,_that.isLoading,_that.isLoadingMore,_that.hasReachedEnd,_that.searchQuery,_that.selectedCategory,_that.commentLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _GetPostState implements GetPostState {
  const _GetPostState({final  List<GetPost> posts = const [], this.currentPage = 1, this.isLoading = false, this.isLoadingMore = false, this.hasReachedEnd = false, this.searchQuery = '', this.selectedCategory = 'All', final  Map<int, bool> commentLoading = const {}, this.errorMessage}): _posts = posts,_commentLoading = commentLoading;
  

 final  List<GetPost> _posts;
@override@JsonKey() List<GetPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

// Pagination
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasReachedEnd;
// Filters
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  String selectedCategory;
// Per-post comment submitting state (postId → isLoading)
 final  Map<int, bool> _commentLoading;
// Per-post comment submitting state (postId → isLoading)
@override@JsonKey() Map<int, bool> get commentLoading {
  if (_commentLoading is EqualUnmodifiableMapView) return _commentLoading;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_commentLoading);
}

// Error
@override final  String? errorMessage;

/// Create a copy of GetPostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetPostStateCopyWith<_GetPostState> get copyWith => __$GetPostStateCopyWithImpl<_GetPostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetPostState&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedEnd, hasReachedEnd) || other.hasReachedEnd == hasReachedEnd)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&const DeepCollectionEquality().equals(other._commentLoading, _commentLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),currentPage,isLoading,isLoadingMore,hasReachedEnd,searchQuery,selectedCategory,const DeepCollectionEquality().hash(_commentLoading),errorMessage);

@override
String toString() {
  return 'GetPostState(posts: $posts, currentPage: $currentPage, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasReachedEnd: $hasReachedEnd, searchQuery: $searchQuery, selectedCategory: $selectedCategory, commentLoading: $commentLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$GetPostStateCopyWith<$Res> implements $GetPostStateCopyWith<$Res> {
  factory _$GetPostStateCopyWith(_GetPostState value, $Res Function(_GetPostState) _then) = __$GetPostStateCopyWithImpl;
@override @useResult
$Res call({
 List<GetPost> posts, int currentPage, bool isLoading, bool isLoadingMore, bool hasReachedEnd, String searchQuery, String selectedCategory, Map<int, bool> commentLoading, String? errorMessage
});




}
/// @nodoc
class __$GetPostStateCopyWithImpl<$Res>
    implements _$GetPostStateCopyWith<$Res> {
  __$GetPostStateCopyWithImpl(this._self, this._then);

  final _GetPostState _self;
  final $Res Function(_GetPostState) _then;

/// Create a copy of GetPostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? currentPage = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasReachedEnd = null,Object? searchQuery = null,Object? selectedCategory = null,Object? commentLoading = null,Object? errorMessage = freezed,}) {
  return _then(_GetPostState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<GetPost>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedEnd: null == hasReachedEnd ? _self.hasReachedEnd : hasReachedEnd // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,commentLoading: null == commentLoading ? _self._commentLoading : commentLoading // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
