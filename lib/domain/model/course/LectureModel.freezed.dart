// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'LectureModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LectureModel {

 int get id; int get courseId; String get lectureTitle; String get duration; String get contentUpload; String get aboutLecture;
/// Create a copy of LectureModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LectureModelCopyWith<LectureModel> get copyWith => _$LectureModelCopyWithImpl<LectureModel>(this as LectureModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LectureModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture);

@override
String toString() {
  return 'LectureModel(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture)';
}


}

/// @nodoc
abstract mixin class $LectureModelCopyWith<$Res>  {
  factory $LectureModelCopyWith(LectureModel value, $Res Function(LectureModel) _then) = _$LectureModelCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String lectureTitle, String duration, String contentUpload, String aboutLecture
});




}
/// @nodoc
class _$LectureModelCopyWithImpl<$Res>
    implements $LectureModelCopyWith<$Res> {
  _$LectureModelCopyWithImpl(this._self, this._then);

  final LectureModel _self;
  final $Res Function(LectureModel) _then;

/// Create a copy of LectureModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LectureModel].
extension LectureModelPatterns on LectureModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LectureModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LectureModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LectureModel value)  $default,){
final _that = this;
switch (_that) {
case _LectureModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LectureModel value)?  $default,){
final _that = this;
switch (_that) {
case _LectureModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String lectureTitle,  String duration,  String contentUpload,  String aboutLecture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LectureModel() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String lectureTitle,  String duration,  String contentUpload,  String aboutLecture)  $default,) {final _that = this;
switch (_that) {
case _LectureModel():
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String lectureTitle,  String duration,  String contentUpload,  String aboutLecture)?  $default,) {final _that = this;
switch (_that) {
case _LectureModel() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture);case _:
  return null;

}
}

}

/// @nodoc


class _LectureModel implements LectureModel {
  const _LectureModel({required this.id, required this.courseId, required this.lectureTitle, required this.duration, required this.contentUpload, required this.aboutLecture});
  

@override final  int id;
@override final  int courseId;
@override final  String lectureTitle;
@override final  String duration;
@override final  String contentUpload;
@override final  String aboutLecture;

/// Create a copy of LectureModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LectureModelCopyWith<_LectureModel> get copyWith => __$LectureModelCopyWithImpl<_LectureModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LectureModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture);

@override
String toString() {
  return 'LectureModel(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture)';
}


}

/// @nodoc
abstract mixin class _$LectureModelCopyWith<$Res> implements $LectureModelCopyWith<$Res> {
  factory _$LectureModelCopyWith(_LectureModel value, $Res Function(_LectureModel) _then) = __$LectureModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String lectureTitle, String duration, String contentUpload, String aboutLecture
});




}
/// @nodoc
class __$LectureModelCopyWithImpl<$Res>
    implements _$LectureModelCopyWith<$Res> {
  __$LectureModelCopyWithImpl(this._self, this._then);

  final _LectureModel _self;
  final $Res Function(_LectureModel) _then;

/// Create a copy of LectureModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,}) {
  return _then(_LectureModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
