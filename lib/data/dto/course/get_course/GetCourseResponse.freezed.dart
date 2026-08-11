// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetCourseResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCourseResponse {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'courseTitle') String get courseTitle;@JsonKey(name: 'subtitle') String get subtitle;@JsonKey(name: 'courseDescription') String get courseDescription;@JsonKey(name: 'courseLevel') String get courseLevel;@JsonKey(name: 'price') String get price;@JsonKey(name: 'language') String get language;@JsonKey(name: 'requirements') String get requirements;@JsonKey(name: 'whatYoullLearn') String get whatYoullLearn;@JsonKey(name: 'whoThisCourseIsFor') String get whoThisCourseIsFor;@JsonKey(name: 'isPublished') bool get isPublished;@JsonKey(name: 'category') String get category;@JsonKey(name: 'videoPreview') String get videoPreview;@JsonKey(name: 'thumbnailPreview') String get thumbnailPreview;@JsonKey(name: 'lectures') List<CourseLectureDto> get lectures;
/// Create a copy of GetCourseResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCourseResponseCopyWith<GetCourseResponse> get copyWith => _$GetCourseResponseCopyWithImpl<GetCourseResponse>(this as GetCourseResponse, _$identity);

  /// Serializes this GetCourseResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCourseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.price, price) || other.price == price)&&(identical(other.language, language) || other.language == language)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.whatYoullLearn, whatYoullLearn) || other.whatYoullLearn == whatYoullLearn)&&(identical(other.whoThisCourseIsFor, whoThisCourseIsFor) || other.whoThisCourseIsFor == whoThisCourseIsFor)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other.lectures, lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,price,language,requirements,whatYoullLearn,whoThisCourseIsFor,isPublished,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(lectures));

@override
String toString() {
  return 'GetCourseResponse(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, price: $price, language: $language, requirements: $requirements, whatYoullLearn: $whatYoullLearn, whoThisCourseIsFor: $whoThisCourseIsFor, isPublished: $isPublished, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class $GetCourseResponseCopyWith<$Res>  {
  factory $GetCourseResponseCopyWith(GetCourseResponse value, $Res Function(GetCourseResponse) _then) = _$GetCourseResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseTitle') String courseTitle,@JsonKey(name: 'subtitle') String subtitle,@JsonKey(name: 'courseDescription') String courseDescription,@JsonKey(name: 'courseLevel') String courseLevel,@JsonKey(name: 'price') String price,@JsonKey(name: 'language') String language,@JsonKey(name: 'requirements') String requirements,@JsonKey(name: 'whatYoullLearn') String whatYoullLearn,@JsonKey(name: 'whoThisCourseIsFor') String whoThisCourseIsFor,@JsonKey(name: 'isPublished') bool isPublished,@JsonKey(name: 'category') String category,@JsonKey(name: 'videoPreview') String videoPreview,@JsonKey(name: 'thumbnailPreview') String thumbnailPreview,@JsonKey(name: 'lectures') List<CourseLectureDto> lectures
});




}
/// @nodoc
class _$GetCourseResponseCopyWithImpl<$Res>
    implements $GetCourseResponseCopyWith<$Res> {
  _$GetCourseResponseCopyWithImpl(this._self, this._then);

  final GetCourseResponse _self;
  final $Res Function(GetCourseResponse) _then;

/// Create a copy of GetCourseResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseTitle = null,Object? subtitle = null,Object? courseDescription = null,Object? courseLevel = null,Object? price = null,Object? language = null,Object? requirements = null,Object? whatYoullLearn = null,Object? whoThisCourseIsFor = null,Object? isPublished = null,Object? category = null,Object? videoPreview = null,Object? thumbnailPreview = null,Object? lectures = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,courseLevel: null == courseLevel ? _self.courseLevel : courseLevel // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,whatYoullLearn: null == whatYoullLearn ? _self.whatYoullLearn : whatYoullLearn // ignore: cast_nullable_to_non_nullable
as String,whoThisCourseIsFor: null == whoThisCourseIsFor ? _self.whoThisCourseIsFor : whoThisCourseIsFor // ignore: cast_nullable_to_non_nullable
as String,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,videoPreview: null == videoPreview ? _self.videoPreview : videoPreview // ignore: cast_nullable_to_non_nullable
as String,thumbnailPreview: null == thumbnailPreview ? _self.thumbnailPreview : thumbnailPreview // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self.lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<CourseLectureDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCourseResponse].
extension GetCourseResponsePatterns on GetCourseResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCourseResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCourseResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCourseResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetCourseResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCourseResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetCourseResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<CourseLectureDto> lectures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCourseResponse() when $default != null:
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.price,_that.language,_that.requirements,_that.whatYoullLearn,_that.whoThisCourseIsFor,_that.isPublished,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<CourseLectureDto> lectures)  $default,) {final _that = this;
switch (_that) {
case _GetCourseResponse():
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.price,_that.language,_that.requirements,_that.whatYoullLearn,_that.whoThisCourseIsFor,_that.isPublished,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<CourseLectureDto> lectures)?  $default,) {final _that = this;
switch (_that) {
case _GetCourseResponse() when $default != null:
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.price,_that.language,_that.requirements,_that.whatYoullLearn,_that.whoThisCourseIsFor,_that.isPublished,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetCourseResponse extends GetCourseResponse {
  const _GetCourseResponse({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'courseTitle') required this.courseTitle, @JsonKey(name: 'subtitle') required this.subtitle, @JsonKey(name: 'courseDescription') required this.courseDescription, @JsonKey(name: 'courseLevel') required this.courseLevel, @JsonKey(name: 'price') required this.price, @JsonKey(name: 'language') required this.language, @JsonKey(name: 'requirements') required this.requirements, @JsonKey(name: 'whatYoullLearn') required this.whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor') required this.whoThisCourseIsFor, @JsonKey(name: 'isPublished') required this.isPublished, @JsonKey(name: 'category') required this.category, @JsonKey(name: 'videoPreview') required this.videoPreview, @JsonKey(name: 'thumbnailPreview') required this.thumbnailPreview, @JsonKey(name: 'lectures') required final  List<CourseLectureDto> lectures}): _lectures = lectures,super._();
  factory _GetCourseResponse.fromJson(Map<String, dynamic> json) => _$GetCourseResponseFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'courseTitle') final  String courseTitle;
@override@JsonKey(name: 'subtitle') final  String subtitle;
@override@JsonKey(name: 'courseDescription') final  String courseDescription;
@override@JsonKey(name: 'courseLevel') final  String courseLevel;
@override@JsonKey(name: 'price') final  String price;
@override@JsonKey(name: 'language') final  String language;
@override@JsonKey(name: 'requirements') final  String requirements;
@override@JsonKey(name: 'whatYoullLearn') final  String whatYoullLearn;
@override@JsonKey(name: 'whoThisCourseIsFor') final  String whoThisCourseIsFor;
@override@JsonKey(name: 'isPublished') final  bool isPublished;
@override@JsonKey(name: 'category') final  String category;
@override@JsonKey(name: 'videoPreview') final  String videoPreview;
@override@JsonKey(name: 'thumbnailPreview') final  String thumbnailPreview;
 final  List<CourseLectureDto> _lectures;
@override@JsonKey(name: 'lectures') List<CourseLectureDto> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}


/// Create a copy of GetCourseResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCourseResponseCopyWith<_GetCourseResponse> get copyWith => __$GetCourseResponseCopyWithImpl<_GetCourseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCourseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCourseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.price, price) || other.price == price)&&(identical(other.language, language) || other.language == language)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.whatYoullLearn, whatYoullLearn) || other.whatYoullLearn == whatYoullLearn)&&(identical(other.whoThisCourseIsFor, whoThisCourseIsFor) || other.whoThisCourseIsFor == whoThisCourseIsFor)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other._lectures, _lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,price,language,requirements,whatYoullLearn,whoThisCourseIsFor,isPublished,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(_lectures));

@override
String toString() {
  return 'GetCourseResponse(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, price: $price, language: $language, requirements: $requirements, whatYoullLearn: $whatYoullLearn, whoThisCourseIsFor: $whoThisCourseIsFor, isPublished: $isPublished, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class _$GetCourseResponseCopyWith<$Res> implements $GetCourseResponseCopyWith<$Res> {
  factory _$GetCourseResponseCopyWith(_GetCourseResponse value, $Res Function(_GetCourseResponse) _then) = __$GetCourseResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseTitle') String courseTitle,@JsonKey(name: 'subtitle') String subtitle,@JsonKey(name: 'courseDescription') String courseDescription,@JsonKey(name: 'courseLevel') String courseLevel,@JsonKey(name: 'price') String price,@JsonKey(name: 'language') String language,@JsonKey(name: 'requirements') String requirements,@JsonKey(name: 'whatYoullLearn') String whatYoullLearn,@JsonKey(name: 'whoThisCourseIsFor') String whoThisCourseIsFor,@JsonKey(name: 'isPublished') bool isPublished,@JsonKey(name: 'category') String category,@JsonKey(name: 'videoPreview') String videoPreview,@JsonKey(name: 'thumbnailPreview') String thumbnailPreview,@JsonKey(name: 'lectures') List<CourseLectureDto> lectures
});




}
/// @nodoc
class __$GetCourseResponseCopyWithImpl<$Res>
    implements _$GetCourseResponseCopyWith<$Res> {
  __$GetCourseResponseCopyWithImpl(this._self, this._then);

  final _GetCourseResponse _self;
  final $Res Function(_GetCourseResponse) _then;

/// Create a copy of GetCourseResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseTitle = null,Object? subtitle = null,Object? courseDescription = null,Object? courseLevel = null,Object? price = null,Object? language = null,Object? requirements = null,Object? whatYoullLearn = null,Object? whoThisCourseIsFor = null,Object? isPublished = null,Object? category = null,Object? videoPreview = null,Object? thumbnailPreview = null,Object? lectures = null,}) {
  return _then(_GetCourseResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,courseLevel: null == courseLevel ? _self.courseLevel : courseLevel // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as String,whatYoullLearn: null == whatYoullLearn ? _self.whatYoullLearn : whatYoullLearn // ignore: cast_nullable_to_non_nullable
as String,whoThisCourseIsFor: null == whoThisCourseIsFor ? _self.whoThisCourseIsFor : whoThisCourseIsFor // ignore: cast_nullable_to_non_nullable
as String,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,videoPreview: null == videoPreview ? _self.videoPreview : videoPreview // ignore: cast_nullable_to_non_nullable
as String,thumbnailPreview: null == thumbnailPreview ? _self.thumbnailPreview : thumbnailPreview // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self._lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<CourseLectureDto>,
  ));
}


}


/// @nodoc
mixin _$CourseLectureDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'courseId') int get courseId;@JsonKey(name: 'lectureTitle') String get lectureTitle;@JsonKey(name: 'duration') String get duration;@JsonKey(name: 'contentUpload') String get contentUpload;@JsonKey(name: 'aboutLecture') String get aboutLecture;@JsonKey(name: 'assignment') dynamic get assignment;
/// Create a copy of CourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseLectureDtoCopyWith<CourseLectureDto> get copyWith => _$CourseLectureDtoCopyWithImpl<CourseLectureDto>(this as CourseLectureDto, _$identity);

  /// Serializes this CourseLectureDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseLectureDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&const DeepCollectionEquality().equals(other.assignment, assignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture,const DeepCollectionEquality().hash(assignment));

@override
String toString() {
  return 'CourseLectureDto(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture, assignment: $assignment)';
}


}

/// @nodoc
abstract mixin class $CourseLectureDtoCopyWith<$Res>  {
  factory $CourseLectureDtoCopyWith(CourseLectureDto value, $Res Function(CourseLectureDto) _then) = _$CourseLectureDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'assignment') dynamic assignment
});




}
/// @nodoc
class _$CourseLectureDtoCopyWithImpl<$Res>
    implements $CourseLectureDtoCopyWith<$Res> {
  _$CourseLectureDtoCopyWithImpl(this._self, this._then);

  final CourseLectureDto _self;
  final $Res Function(CourseLectureDto) _then;

/// Create a copy of CourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,Object? assignment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseLectureDto].
extension CourseLectureDtoPatterns on CourseLectureDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseLectureDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseLectureDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseLectureDto value)  $default,){
final _that = this;
switch (_that) {
case _CourseLectureDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseLectureDto value)?  $default,){
final _that = this;
switch (_that) {
case _CourseLectureDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseLectureDto() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment)  $default,) {final _that = this;
switch (_that) {
case _CourseLectureDto():
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseId')  int courseId, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'assignment')  dynamic assignment)?  $default,) {final _that = this;
switch (_that) {
case _CourseLectureDto() when $default != null:
return $default(_that.id,_that.courseId,_that.lectureTitle,_that.duration,_that.contentUpload,_that.aboutLecture,_that.assignment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseLectureDto extends CourseLectureDto {
  const _CourseLectureDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'courseId') required this.courseId, @JsonKey(name: 'lectureTitle') required this.lectureTitle, @JsonKey(name: 'duration') required this.duration, @JsonKey(name: 'contentUpload') required this.contentUpload, @JsonKey(name: 'aboutLecture') required this.aboutLecture, @JsonKey(name: 'assignment') required this.assignment}): super._();
  factory _CourseLectureDto.fromJson(Map<String, dynamic> json) => _$CourseLectureDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'courseId') final  int courseId;
@override@JsonKey(name: 'lectureTitle') final  String lectureTitle;
@override@JsonKey(name: 'duration') final  String duration;
@override@JsonKey(name: 'contentUpload') final  String contentUpload;
@override@JsonKey(name: 'aboutLecture') final  String aboutLecture;
@override@JsonKey(name: 'assignment') final  dynamic assignment;

/// Create a copy of CourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseLectureDtoCopyWith<_CourseLectureDto> get copyWith => __$CourseLectureDtoCopyWithImpl<_CourseLectureDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseLectureDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseLectureDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&const DeepCollectionEquality().equals(other.assignment, assignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,lectureTitle,duration,contentUpload,aboutLecture,const DeepCollectionEquality().hash(assignment));

@override
String toString() {
  return 'CourseLectureDto(id: $id, courseId: $courseId, lectureTitle: $lectureTitle, duration: $duration, contentUpload: $contentUpload, aboutLecture: $aboutLecture, assignment: $assignment)';
}


}

/// @nodoc
abstract mixin class _$CourseLectureDtoCopyWith<$Res> implements $CourseLectureDtoCopyWith<$Res> {
  factory _$CourseLectureDtoCopyWith(_CourseLectureDto value, $Res Function(_CourseLectureDto) _then) = __$CourseLectureDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseId') int courseId,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'assignment') dynamic assignment
});




}
/// @nodoc
class __$CourseLectureDtoCopyWithImpl<$Res>
    implements _$CourseLectureDtoCopyWith<$Res> {
  __$CourseLectureDtoCopyWithImpl(this._self, this._then);

  final _CourseLectureDto _self;
  final $Res Function(_CourseLectureDto) _then;

/// Create a copy of CourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? lectureTitle = null,Object? duration = null,Object? contentUpload = null,Object? aboutLecture = null,Object? assignment = freezed,}) {
  return _then(_CourseLectureDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
