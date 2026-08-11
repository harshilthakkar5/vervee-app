// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'LikePost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LikePost {

 bool get liked; int get likesCount;
/// Create a copy of LikePost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikePostCopyWith<LikePost> get copyWith => _$LikePostCopyWithImpl<LikePost>(this as LikePost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikePost&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}


@override
int get hashCode => Object.hash(runtimeType,liked,likesCount);

@override
String toString() {
  return 'LikePost(liked: $liked, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class $LikePostCopyWith<$Res>  {
  factory $LikePostCopyWith(LikePost value, $Res Function(LikePost) _then) = _$LikePostCopyWithImpl;
@useResult
$Res call({
 bool liked, int likesCount
});




}
/// @nodoc
class _$LikePostCopyWithImpl<$Res>
    implements $LikePostCopyWith<$Res> {
  _$LikePostCopyWithImpl(this._self, this._then);

  final LikePost _self;
  final $Res Function(LikePost) _then;

/// Create a copy of LikePost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? liked = null,Object? likesCount = null,}) {
  return _then(_self.copyWith(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LikePost].
extension LikePostPatterns on LikePost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikePost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikePost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikePost value)  $default,){
final _that = this;
switch (_that) {
case _LikePost():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikePost value)?  $default,){
final _that = this;
switch (_that) {
case _LikePost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool liked,  int likesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikePost() when $default != null:
return $default(_that.liked,_that.likesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool liked,  int likesCount)  $default,) {final _that = this;
switch (_that) {
case _LikePost():
return $default(_that.liked,_that.likesCount);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool liked,  int likesCount)?  $default,) {final _that = this;
switch (_that) {
case _LikePost() when $default != null:
return $default(_that.liked,_that.likesCount);case _:
  return null;

}
}

}

/// @nodoc


class _LikePost implements LikePost {
  const _LikePost({required this.liked, required this.likesCount});
  

@override final  bool liked;
@override final  int likesCount;

/// Create a copy of LikePost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikePostCopyWith<_LikePost> get copyWith => __$LikePostCopyWithImpl<_LikePost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikePost&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}


@override
int get hashCode => Object.hash(runtimeType,liked,likesCount);

@override
String toString() {
  return 'LikePost(liked: $liked, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class _$LikePostCopyWith<$Res> implements $LikePostCopyWith<$Res> {
  factory _$LikePostCopyWith(_LikePost value, $Res Function(_LikePost) _then) = __$LikePostCopyWithImpl;
@override @useResult
$Res call({
 bool liked, int likesCount
});




}
/// @nodoc
class __$LikePostCopyWithImpl<$Res>
    implements _$LikePostCopyWith<$Res> {
  __$LikePostCopyWithImpl(this._self, this._then);

  final _LikePost _self;
  final $Res Function(_LikePost) _then;

/// Create a copy of LikePost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? liked = null,Object? likesCount = null,}) {
  return _then(_LikePost(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
