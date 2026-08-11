// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetProgressResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetProgressResponse {

@JsonKey(name: 'userId') int get userId;@JsonKey(name: 'courseId') int get courseId;@JsonKey(name: 'lectureId') int get lectureId;@JsonKey(name: 'isCompleted') bool get isCompleted;
/// Create a copy of GetProgressResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetProgressResponseCopyWith<GetProgressResponse> get copyWith => _$GetProgressResponseCopyWithImpl<GetProgressResponse>(this as GetProgressResponse, _$identity);

  /// Serializes this GetProgressResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetProgressResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureId, lectureId) || other.lectureId == lectureId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,courseId,lectureId,isCompleted);

@override
String toString() {
  return 'GetProgressResponse(userId: $userId, courseId: $courseId, lectureId: $lectureId, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $GetProgressResponseCopyWith<$Res>  {
  factory $GetProgressResponseCopyWith(GetProgressResponse value, $Res Function(GetProgressResponse) _then) = _$GetProgressResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') int userId,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureId') int lectureId,@JsonKey(name: 'isCompleted') bool isCompleted
});




}
/// @nodoc
class _$GetProgressResponseCopyWithImpl<$Res>
    implements $GetProgressResponseCopyWith<$Res> {
  _$GetProgressResponseCopyWithImpl(this._self, this._then);

  final GetProgressResponse _self;
  final $Res Function(GetProgressResponse) _then;

/// Create a copy of GetProgressResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? courseId = null,Object? lectureId = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureId: null == lectureId ? _self.lectureId : lectureId // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GetProgressResponse].
extension GetProgressResponsePatterns on GetProgressResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetProgressResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetProgressResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetProgressResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetProgressResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetProgressResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetProgressResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureId')  int lectureId, @JsonKey(name: 'isCompleted')  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetProgressResponse() when $default != null:
return $default(_that.userId,_that.courseId,_that.lectureId,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureId')  int lectureId, @JsonKey(name: 'isCompleted')  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _GetProgressResponse():
return $default(_that.userId,_that.courseId,_that.lectureId,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureId')  int lectureId, @JsonKey(name: 'isCompleted')  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _GetProgressResponse() when $default != null:
return $default(_that.userId,_that.courseId,_that.lectureId,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetProgressResponse extends GetProgressResponse {
  const _GetProgressResponse({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'courseId') required this.courseId, @JsonKey(name: 'lectureId') required this.lectureId, @JsonKey(name: 'isCompleted') required this.isCompleted}): super._();
  factory _GetProgressResponse.fromJson(Map<String, dynamic> json) => _$GetProgressResponseFromJson(json);

@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey(name: 'courseId') final  int courseId;
@override@JsonKey(name: 'lectureId') final  int lectureId;
@override@JsonKey(name: 'isCompleted') final  bool isCompleted;

/// Create a copy of GetProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetProgressResponseCopyWith<_GetProgressResponse> get copyWith => __$GetProgressResponseCopyWithImpl<_GetProgressResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetProgressResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetProgressResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureId, lectureId) || other.lectureId == lectureId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,courseId,lectureId,isCompleted);

@override
String toString() {
  return 'GetProgressResponse(userId: $userId, courseId: $courseId, lectureId: $lectureId, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$GetProgressResponseCopyWith<$Res> implements $GetProgressResponseCopyWith<$Res> {
  factory _$GetProgressResponseCopyWith(_GetProgressResponse value, $Res Function(_GetProgressResponse) _then) = __$GetProgressResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') int userId,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureId') int lectureId,@JsonKey(name: 'isCompleted') bool isCompleted
});




}
/// @nodoc
class __$GetProgressResponseCopyWithImpl<$Res>
    implements _$GetProgressResponseCopyWith<$Res> {
  __$GetProgressResponseCopyWithImpl(this._self, this._then);

  final _GetProgressResponse _self;
  final $Res Function(_GetProgressResponse) _then;

/// Create a copy of GetProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? courseId = null,Object? lectureId = null,Object? isCompleted = null,}) {
  return _then(_GetProgressResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureId: null == lectureId ? _self.lectureId : lectureId // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
