// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CourseProgressModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseProgressModel {

 int get userId; int get courseId; int get lectureId; bool get isCompleted;
/// Create a copy of CourseProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseProgressModelCopyWith<CourseProgressModel> get copyWith => _$CourseProgressModelCopyWithImpl<CourseProgressModel>(this as CourseProgressModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseProgressModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureId, lectureId) || other.lectureId == lectureId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,userId,courseId,lectureId,isCompleted);

@override
String toString() {
  return 'CourseProgressModel(userId: $userId, courseId: $courseId, lectureId: $lectureId, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $CourseProgressModelCopyWith<$Res>  {
  factory $CourseProgressModelCopyWith(CourseProgressModel value, $Res Function(CourseProgressModel) _then) = _$CourseProgressModelCopyWithImpl;
@useResult
$Res call({
 int userId, int courseId, int lectureId, bool isCompleted
});




}
/// @nodoc
class _$CourseProgressModelCopyWithImpl<$Res>
    implements $CourseProgressModelCopyWith<$Res> {
  _$CourseProgressModelCopyWithImpl(this._self, this._then);

  final CourseProgressModel _self;
  final $Res Function(CourseProgressModel) _then;

/// Create a copy of CourseProgressModel
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


/// Adds pattern-matching-related methods to [CourseProgressModel].
extension CourseProgressModelPatterns on CourseProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int courseId,  int lectureId,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseProgressModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int courseId,  int lectureId,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _CourseProgressModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int courseId,  int lectureId,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _CourseProgressModel() when $default != null:
return $default(_that.userId,_that.courseId,_that.lectureId,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _CourseProgressModel implements CourseProgressModel {
  const _CourseProgressModel({required this.userId, required this.courseId, required this.lectureId, required this.isCompleted});
  

@override final  int userId;
@override final  int courseId;
@override final  int lectureId;
@override final  bool isCompleted;

/// Create a copy of CourseProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseProgressModelCopyWith<_CourseProgressModel> get copyWith => __$CourseProgressModelCopyWithImpl<_CourseProgressModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseProgressModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureId, lectureId) || other.lectureId == lectureId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,userId,courseId,lectureId,isCompleted);

@override
String toString() {
  return 'CourseProgressModel(userId: $userId, courseId: $courseId, lectureId: $lectureId, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$CourseProgressModelCopyWith<$Res> implements $CourseProgressModelCopyWith<$Res> {
  factory _$CourseProgressModelCopyWith(_CourseProgressModel value, $Res Function(_CourseProgressModel) _then) = __$CourseProgressModelCopyWithImpl;
@override @useResult
$Res call({
 int userId, int courseId, int lectureId, bool isCompleted
});




}
/// @nodoc
class __$CourseProgressModelCopyWithImpl<$Res>
    implements _$CourseProgressModelCopyWith<$Res> {
  __$CourseProgressModelCopyWithImpl(this._self, this._then);

  final _CourseProgressModel _self;
  final $Res Function(_CourseProgressModel) _then;

/// Create a copy of CourseProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? courseId = null,Object? lectureId = null,Object? isCompleted = null,}) {
  return _then(_CourseProgressModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureId: null == lectureId ? _self.lectureId : lectureId // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
