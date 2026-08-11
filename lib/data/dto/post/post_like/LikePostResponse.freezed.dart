// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'LikePostResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LikePostResponse {

@JsonKey(name: 'liked') bool get liked;@JsonKey(name: 'likesCount') int get likesCount;
/// Create a copy of LikePostResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikePostResponseCopyWith<LikePostResponse> get copyWith => _$LikePostResponseCopyWithImpl<LikePostResponse>(this as LikePostResponse, _$identity);

  /// Serializes this LikePostResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikePostResponse&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liked,likesCount);

@override
String toString() {
  return 'LikePostResponse(liked: $liked, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class $LikePostResponseCopyWith<$Res>  {
  factory $LikePostResponseCopyWith(LikePostResponse value, $Res Function(LikePostResponse) _then) = _$LikePostResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'liked') bool liked,@JsonKey(name: 'likesCount') int likesCount
});




}
/// @nodoc
class _$LikePostResponseCopyWithImpl<$Res>
    implements $LikePostResponseCopyWith<$Res> {
  _$LikePostResponseCopyWithImpl(this._self, this._then);

  final LikePostResponse _self;
  final $Res Function(LikePostResponse) _then;

/// Create a copy of LikePostResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? liked = null,Object? likesCount = null,}) {
  return _then(_self.copyWith(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LikePostResponse].
extension LikePostResponsePatterns on LikePostResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikePostResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikePostResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikePostResponse value)  $default,){
final _that = this;
switch (_that) {
case _LikePostResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikePostResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LikePostResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'liked')  bool liked, @JsonKey(name: 'likesCount')  int likesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikePostResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'liked')  bool liked, @JsonKey(name: 'likesCount')  int likesCount)  $default,) {final _that = this;
switch (_that) {
case _LikePostResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'liked')  bool liked, @JsonKey(name: 'likesCount')  int likesCount)?  $default,) {final _that = this;
switch (_that) {
case _LikePostResponse() when $default != null:
return $default(_that.liked,_that.likesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikePostResponse extends LikePostResponse {
  const _LikePostResponse({@JsonKey(name: 'liked') required this.liked, @JsonKey(name: 'likesCount') required this.likesCount}): super._();
  factory _LikePostResponse.fromJson(Map<String, dynamic> json) => _$LikePostResponseFromJson(json);

@override@JsonKey(name: 'liked') final  bool liked;
@override@JsonKey(name: 'likesCount') final  int likesCount;

/// Create a copy of LikePostResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikePostResponseCopyWith<_LikePostResponse> get copyWith => __$LikePostResponseCopyWithImpl<_LikePostResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikePostResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikePostResponse&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liked,likesCount);

@override
String toString() {
  return 'LikePostResponse(liked: $liked, likesCount: $likesCount)';
}


}

/// @nodoc
abstract mixin class _$LikePostResponseCopyWith<$Res> implements $LikePostResponseCopyWith<$Res> {
  factory _$LikePostResponseCopyWith(_LikePostResponse value, $Res Function(_LikePostResponse) _then) = __$LikePostResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'liked') bool liked,@JsonKey(name: 'likesCount') int likesCount
});




}
/// @nodoc
class __$LikePostResponseCopyWithImpl<$Res>
    implements _$LikePostResponseCopyWith<$Res> {
  __$LikePostResponseCopyWithImpl(this._self, this._then);

  final _LikePostResponse _self;
  final $Res Function(_LikePostResponse) _then;

/// Create a copy of LikePostResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? liked = null,Object? likesCount = null,}) {
  return _then(_LikePostResponse(
liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
