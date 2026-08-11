// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetTopicResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetTopicResponse {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'courseId') int get courseId;@JsonKey(name: 'lectureTitle') String get lectureTitle;@JsonKey(name: 'duration') String get duration;@JsonKey(name: 'contentUpload') String get contentUpload;@JsonKey(name: 'aboutLecture') String get aboutLecture;@JsonKey(name: 'assignment') dynamic get assignment;@JsonKey(name: 'mcqs') List<dynamic> get mcqs;@JsonKey(name: 'passedMcq') bool get passedMcq;
/// Create a copy of GetTopicResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetTopicResponseCopyWith<GetTopicResponse> get copyWith => _$GetTopicResponseCopyWithImpl<GetTopicResponse>(this as GetTopicResponse, _$identity);

  /// Serializes this GetTopicResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetTopicResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&const DeepCollectionEquality().equals(other.assignment, assignment)&&const DeepCollectionEquality().equals(other.mcqs, mcqs)&&(identical(other.passedMcq, passedMcq) || other.passedMcq == passedMcq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture,const DeepCollectionEquality().hash(assignment),const DeepCollectionEquality().hash(mcqs),passedMcq);

@override
String toString() {
  return 'GetTopicResponse(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture, assignment: $assignment, mcqs: $mcqs, passedMcq: $passedMcq)';
}


}

/// @nodoc
abstract mixin class $GetTopicResponseCopyWith<$Res>  {
  factory $GetTopicResponseCopyWith(GetTopicResponse value, $Res Function(GetTopicResponse) _then) = _$GetTopicResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'assignment') dynamic assignment,@JsonKey(name: 'mcqs') List<dynamic> mcqs,@JsonKey(name: 'passedMcq') bool passedMcq
});




}
/// @nodoc
class _$GetTopicResponseCopyWithImpl<$Res>
    implements $GetTopicResponseCopyWith<$Res> {
  _$GetTopicResponseCopyWithImpl(this._self, this._then);

  final GetTopicResponse _self;
  final $Res Function(GetTopicResponse) _then;

/// Create a copy of GetTopicResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,Object? assignment = freezed,Object? mcqs = null,Object? passedMcq = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<dynamic>,passedMcq: null == passedMcq ? _self.passedMcq : passedMcq // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GetTopicResponse].
extension GetTopicResponsePatterns on GetTopicResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetTopicResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetTopicResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetTopicResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetTopicResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetTopicResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetTopicResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'mcqs')  List<dynamic> mcqs, @JsonKey(name: 'passedMcq')  bool passedMcq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetTopicResponse() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment,_that.mcqs,_that.passedMcq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'mcqs')  List<dynamic> mcqs, @JsonKey(name: 'passedMcq')  bool passedMcq)  $default,) {final _that = this;
switch (_that) {
case _GetTopicResponse():
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment,_that.mcqs,_that.passedMcq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'mcqs')  List<dynamic> mcqs, @JsonKey(name: 'passedMcq')  bool passedMcq)?  $default,) {final _that = this;
switch (_that) {
case _GetTopicResponse() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment,_that.mcqs,_that.passedMcq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetTopicResponse extends GetTopicResponse {
  const _GetTopicResponse({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'courseId') required this.courseId, @JsonKey(name: 'lectureTitle') required this.lectureTitle, @JsonKey(name: 'duration') required this.duration, @JsonKey(name: 'contentUpload') required this.contentUpload, @JsonKey(name: 'aboutLecture') required this.aboutLecture, @JsonKey(name: 'assignment') required this.assignment, @JsonKey(name: 'mcqs') required final  List<dynamic> mcqs, @JsonKey(name: 'passedMcq') required this.passedMcq}): _mcqs = mcqs,super._();
  factory _GetTopicResponse.fromJson(Map<String, dynamic> json) => _$GetTopicResponseFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'courseId') final  int courseId;
@override@JsonKey(name: 'lectureTitle') final  String lectureTitle;
@override@JsonKey(name: 'duration') final  String duration;
@override@JsonKey(name: 'contentUpload') final  String contentUpload;
@override@JsonKey(name: 'aboutLecture') final  String aboutLecture;
@override@JsonKey(name: 'assignment') final  dynamic assignment;
 final  List<dynamic> _mcqs;
@override@JsonKey(name: 'mcqs') List<dynamic> get mcqs {
  if (_mcqs is EqualUnmodifiableListView) return _mcqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mcqs);
}

@override@JsonKey(name: 'passedMcq') final  bool passedMcq;

/// Create a copy of GetTopicResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetTopicResponseCopyWith<_GetTopicResponse> get copyWith => __$GetTopicResponseCopyWithImpl<_GetTopicResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetTopicResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetTopicResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&const DeepCollectionEquality().equals(other.assignment, assignment)&&const DeepCollectionEquality().equals(other._mcqs, _mcqs)&&(identical(other.passedMcq, passedMcq) || other.passedMcq == passedMcq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture,const DeepCollectionEquality().hash(assignment),const DeepCollectionEquality().hash(_mcqs),passedMcq);

@override
String toString() {
  return 'GetTopicResponse(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture, assignment: $assignment, mcqs: $mcqs, passedMcq: $passedMcq)';
}


}

/// @nodoc
abstract mixin class _$GetTopicResponseCopyWith<$Res> implements $GetTopicResponseCopyWith<$Res> {
  factory _$GetTopicResponseCopyWith(_GetTopicResponse value, $Res Function(_GetTopicResponse) _then) = __$GetTopicResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'assignment') dynamic assignment,@JsonKey(name: 'mcqs') List<dynamic> mcqs,@JsonKey(name: 'passedMcq') bool passedMcq
});




}
/// @nodoc
class __$GetTopicResponseCopyWithImpl<$Res>
    implements _$GetTopicResponseCopyWith<$Res> {
  __$GetTopicResponseCopyWithImpl(this._self, this._then);

  final _GetTopicResponse _self;
  final $Res Function(_GetTopicResponse) _then;

/// Create a copy of GetTopicResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,Object? assignment = freezed,Object? mcqs = null,Object? passedMcq = null,}) {
  return _then(_GetTopicResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,mcqs: null == mcqs ? _self._mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<dynamic>,passedMcq: null == passedMcq ? _self.passedMcq : passedMcq // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
