// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetSingleCourseResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetSingleCourseResponse {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'courseTitle') String get courseTitle;@JsonKey(name: 'subtitle') String get subtitle;@JsonKey(name: 'courseDescription') String get courseDescription;@JsonKey(name: 'courseLevel') String get courseLevel;@JsonKey(name: 'price') String get price;@JsonKey(name: 'language') String get language;@JsonKey(name: 'requirements') String get requirements;@JsonKey(name: 'whatYoullLearn') String get whatYoullLearn;@JsonKey(name: 'whoThisCourseIsFor') String get whoThisCourseIsFor;@JsonKey(name: 'isPublished') bool get isPublished;@JsonKey(name: 'category') String get category;@JsonKey(name: 'videoPreview') String get videoPreview;@JsonKey(name: 'thumbnailPreview') String get thumbnailPreview;@JsonKey(name: 'lectures') List<SingleCourseLectureDto> get lectures;
/// Create a copy of GetSingleCourseResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetSingleCourseResponseCopyWith<GetSingleCourseResponse> get copyWith => _$GetSingleCourseResponseCopyWithImpl<GetSingleCourseResponse>(this as GetSingleCourseResponse, _$identity);

  /// Serializes this GetSingleCourseResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetSingleCourseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.price, price) || other.price == price)&&(identical(other.language, language) || other.language == language)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.whatYoullLearn, whatYoullLearn) || other.whatYoullLearn == whatYoullLearn)&&(identical(other.whoThisCourseIsFor, whoThisCourseIsFor) || other.whoThisCourseIsFor == whoThisCourseIsFor)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other.lectures, lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,price,language,requirements,whatYoullLearn,whoThisCourseIsFor,isPublished,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(lectures));

@override
String toString() {
  return 'GetSingleCourseResponse(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, price: $price, language: $language, requirements: $requirements, whatYoullLearn: $whatYoullLearn, whoThisCourseIsFor: $whoThisCourseIsFor, isPublished: $isPublished, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class $GetSingleCourseResponseCopyWith<$Res>  {
  factory $GetSingleCourseResponseCopyWith(GetSingleCourseResponse value, $Res Function(GetSingleCourseResponse) _then) = _$GetSingleCourseResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseTitle') String courseTitle,@JsonKey(name: 'subtitle') String subtitle,@JsonKey(name: 'courseDescription') String courseDescription,@JsonKey(name: 'courseLevel') String courseLevel,@JsonKey(name: 'price') String price,@JsonKey(name: 'language') String language,@JsonKey(name: 'requirements') String requirements,@JsonKey(name: 'whatYoullLearn') String whatYoullLearn,@JsonKey(name: 'whoThisCourseIsFor') String whoThisCourseIsFor,@JsonKey(name: 'isPublished') bool isPublished,@JsonKey(name: 'category') String category,@JsonKey(name: 'videoPreview') String videoPreview,@JsonKey(name: 'thumbnailPreview') String thumbnailPreview,@JsonKey(name: 'lectures') List<SingleCourseLectureDto> lectures
});




}
/// @nodoc
class _$GetSingleCourseResponseCopyWithImpl<$Res>
    implements $GetSingleCourseResponseCopyWith<$Res> {
  _$GetSingleCourseResponseCopyWithImpl(this._self, this._then);

  final GetSingleCourseResponse _self;
  final $Res Function(GetSingleCourseResponse) _then;

/// Create a copy of GetSingleCourseResponse
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
as List<SingleCourseLectureDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [GetSingleCourseResponse].
extension GetSingleCourseResponsePatterns on GetSingleCourseResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetSingleCourseResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetSingleCourseResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetSingleCourseResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetSingleCourseResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetSingleCourseResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetSingleCourseResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<SingleCourseLectureDto> lectures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetSingleCourseResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<SingleCourseLectureDto> lectures)  $default,) {final _that = this;
switch (_that) {
case _GetSingleCourseResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'courseTitle')  String courseTitle, @JsonKey(name: 'subtitle')  String subtitle, @JsonKey(name: 'courseDescription')  String courseDescription, @JsonKey(name: 'courseLevel')  String courseLevel, @JsonKey(name: 'price')  String price, @JsonKey(name: 'language')  String language, @JsonKey(name: 'requirements')  String requirements, @JsonKey(name: 'whatYoullLearn')  String whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor')  String whoThisCourseIsFor, @JsonKey(name: 'isPublished')  bool isPublished, @JsonKey(name: 'category')  String category, @JsonKey(name: 'videoPreview')  String videoPreview, @JsonKey(name: 'thumbnailPreview')  String thumbnailPreview, @JsonKey(name: 'lectures')  List<SingleCourseLectureDto> lectures)?  $default,) {final _that = this;
switch (_that) {
case _GetSingleCourseResponse() when $default != null:
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.price,_that.language,_that.requirements,_that.whatYoullLearn,_that.whoThisCourseIsFor,_that.isPublished,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetSingleCourseResponse extends GetSingleCourseResponse {
  const _GetSingleCourseResponse({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'courseTitle') required this.courseTitle, @JsonKey(name: 'subtitle') required this.subtitle, @JsonKey(name: 'courseDescription') required this.courseDescription, @JsonKey(name: 'courseLevel') required this.courseLevel, @JsonKey(name: 'price') required this.price, @JsonKey(name: 'language') required this.language, @JsonKey(name: 'requirements') required this.requirements, @JsonKey(name: 'whatYoullLearn') required this.whatYoullLearn, @JsonKey(name: 'whoThisCourseIsFor') required this.whoThisCourseIsFor, @JsonKey(name: 'isPublished') required this.isPublished, @JsonKey(name: 'category') required this.category, @JsonKey(name: 'videoPreview') required this.videoPreview, @JsonKey(name: 'thumbnailPreview') required this.thumbnailPreview, @JsonKey(name: 'lectures') required final  List<SingleCourseLectureDto> lectures}): _lectures = lectures,super._();
  factory _GetSingleCourseResponse.fromJson(Map<String, dynamic> json) => _$GetSingleCourseResponseFromJson(json);

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
 final  List<SingleCourseLectureDto> _lectures;
@override@JsonKey(name: 'lectures') List<SingleCourseLectureDto> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}


/// Create a copy of GetSingleCourseResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetSingleCourseResponseCopyWith<_GetSingleCourseResponse> get copyWith => __$GetSingleCourseResponseCopyWithImpl<_GetSingleCourseResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetSingleCourseResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSingleCourseResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.price, price) || other.price == price)&&(identical(other.language, language) || other.language == language)&&(identical(other.requirements, requirements) || other.requirements == requirements)&&(identical(other.whatYoullLearn, whatYoullLearn) || other.whatYoullLearn == whatYoullLearn)&&(identical(other.whoThisCourseIsFor, whoThisCourseIsFor) || other.whoThisCourseIsFor == whoThisCourseIsFor)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other._lectures, _lectures));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,price,language,requirements,whatYoullLearn,whoThisCourseIsFor,isPublished,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(_lectures));

@override
String toString() {
  return 'GetSingleCourseResponse(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, price: $price, language: $language, requirements: $requirements, whatYoullLearn: $whatYoullLearn, whoThisCourseIsFor: $whoThisCourseIsFor, isPublished: $isPublished, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class _$GetSingleCourseResponseCopyWith<$Res> implements $GetSingleCourseResponseCopyWith<$Res> {
  factory _$GetSingleCourseResponseCopyWith(_GetSingleCourseResponse value, $Res Function(_GetSingleCourseResponse) _then) = __$GetSingleCourseResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'courseTitle') String courseTitle,@JsonKey(name: 'subtitle') String subtitle,@JsonKey(name: 'courseDescription') String courseDescription,@JsonKey(name: 'courseLevel') String courseLevel,@JsonKey(name: 'price') String price,@JsonKey(name: 'language') String language,@JsonKey(name: 'requirements') String requirements,@JsonKey(name: 'whatYoullLearn') String whatYoullLearn,@JsonKey(name: 'whoThisCourseIsFor') String whoThisCourseIsFor,@JsonKey(name: 'isPublished') bool isPublished,@JsonKey(name: 'category') String category,@JsonKey(name: 'videoPreview') String videoPreview,@JsonKey(name: 'thumbnailPreview') String thumbnailPreview,@JsonKey(name: 'lectures') List<SingleCourseLectureDto> lectures
});




}
/// @nodoc
class __$GetSingleCourseResponseCopyWithImpl<$Res>
    implements _$GetSingleCourseResponseCopyWith<$Res> {
  __$GetSingleCourseResponseCopyWithImpl(this._self, this._then);

  final _GetSingleCourseResponse _self;
  final $Res Function(_GetSingleCourseResponse) _then;

/// Create a copy of GetSingleCourseResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseTitle = null,Object? subtitle = null,Object? courseDescription = null,Object? courseLevel = null,Object? price = null,Object? language = null,Object? requirements = null,Object? whatYoullLearn = null,Object? whoThisCourseIsFor = null,Object? isPublished = null,Object? category = null,Object? videoPreview = null,Object? thumbnailPreview = null,Object? lectures = null,}) {
  return _then(_GetSingleCourseResponse(
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
as List<SingleCourseLectureDto>,
  ));
}


}


/// @nodoc
mixin _$SingleCourseLectureDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'aboutLecture') String get aboutLecture;@JsonKey(name: 'contentUpload') String get contentUpload;@JsonKey(name: 'assignment') dynamic get assignment;@JsonKey(name: 'lectureTitle') String get lectureTitle;@JsonKey(name: 'duration') String get duration;@JsonKey(name: 'mcqs') List<dynamic> get mcqs;
/// Create a copy of SingleCourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SingleCourseLectureDtoCopyWith<SingleCourseLectureDto> get copyWith => _$SingleCourseLectureDtoCopyWithImpl<SingleCourseLectureDto>(this as SingleCourseLectureDto, _$identity);

  /// Serializes this SingleCourseLectureDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SingleCourseLectureDto&&(identical(other.id, id) || other.id == id)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&const DeepCollectionEquality().equals(other.assignment, assignment)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.mcqs, mcqs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,aboutLecture,contentUpload,const DeepCollectionEquality().hash(assignment),lectureTitle,duration,const DeepCollectionEquality().hash(mcqs));

@override
String toString() {
  return 'SingleCourseLectureDto(id: $id, aboutLecture: $aboutLecture, contentUpload: $contentUpload, assignment: $assignment, lectureTitle: $lectureTitle, duration: $duration, mcqs: $mcqs)';
}


}

/// @nodoc
abstract mixin class $SingleCourseLectureDtoCopyWith<$Res>  {
  factory $SingleCourseLectureDtoCopyWith(SingleCourseLectureDto value, $Res Function(SingleCourseLectureDto) _then) = _$SingleCourseLectureDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'assignment') dynamic assignment,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'mcqs') List<dynamic> mcqs
});




}
/// @nodoc
class _$SingleCourseLectureDtoCopyWithImpl<$Res>
    implements $SingleCourseLectureDtoCopyWith<$Res> {
  _$SingleCourseLectureDtoCopyWithImpl(this._self, this._then);

  final SingleCourseLectureDto _self;
  final $Res Function(SingleCourseLectureDto) _then;

/// Create a copy of SingleCourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? aboutLecture = null,Object? contentUpload = null,Object? assignment = freezed,Object? lectureTitle = null,Object? duration = null,Object? mcqs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SingleCourseLectureDto].
extension SingleCourseLectureDtoPatterns on SingleCourseLectureDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SingleCourseLectureDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SingleCourseLectureDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SingleCourseLectureDto value)  $default,){
final _that = this;
switch (_that) {
case _SingleCourseLectureDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SingleCourseLectureDto value)?  $default,){
final _that = this;
switch (_that) {
case _SingleCourseLectureDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'mcqs')  List<dynamic> mcqs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SingleCourseLectureDto() when $default != null:
return $default(_that.id,_that.aboutLecture,_that.contentUpload,_that.assignment,_that.lectureTitle,_that.duration,_that.mcqs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'mcqs')  List<dynamic> mcqs)  $default,) {final _that = this;
switch (_that) {
case _SingleCourseLectureDto():
return $default(_that.id,_that.aboutLecture,_that.contentUpload,_that.assignment,_that.lectureTitle,_that.duration,_that.mcqs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'aboutLecture')  String aboutLecture, @JsonKey(name: 'contentUpload')  String contentUpload, @JsonKey(name: 'assignment')  dynamic assignment, @JsonKey(name: 'lectureTitle')  String lectureTitle, @JsonKey(name: 'duration')  String duration, @JsonKey(name: 'mcqs')  List<dynamic> mcqs)?  $default,) {final _that = this;
switch (_that) {
case _SingleCourseLectureDto() when $default != null:
return $default(_that.id,_that.aboutLecture,_that.contentUpload,_that.assignment,_that.lectureTitle,_that.duration,_that.mcqs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SingleCourseLectureDto extends SingleCourseLectureDto {
  const _SingleCourseLectureDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'aboutLecture') required this.aboutLecture, @JsonKey(name: 'contentUpload') required this.contentUpload, @JsonKey(name: 'assignment') required this.assignment, @JsonKey(name: 'lectureTitle') required this.lectureTitle, @JsonKey(name: 'duration') required this.duration, @JsonKey(name: 'mcqs') required final  List<dynamic> mcqs}): _mcqs = mcqs,super._();
  factory _SingleCourseLectureDto.fromJson(Map<String, dynamic> json) => _$SingleCourseLectureDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'aboutLecture') final  String aboutLecture;
@override@JsonKey(name: 'contentUpload') final  String contentUpload;
@override@JsonKey(name: 'assignment') final  dynamic assignment;
@override@JsonKey(name: 'lectureTitle') final  String lectureTitle;
@override@JsonKey(name: 'duration') final  String duration;
 final  List<dynamic> _mcqs;
@override@JsonKey(name: 'mcqs') List<dynamic> get mcqs {
  if (_mcqs is EqualUnmodifiableListView) return _mcqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mcqs);
}


/// Create a copy of SingleCourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SingleCourseLectureDtoCopyWith<_SingleCourseLectureDto> get copyWith => __$SingleCourseLectureDtoCopyWithImpl<_SingleCourseLectureDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SingleCourseLectureDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SingleCourseLectureDto&&(identical(other.id, id) || other.id == id)&&(identical(other.aboutLecture, aboutLecture) || other.aboutLecture == aboutLecture)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload)&&const DeepCollectionEquality().equals(other.assignment, assignment)&&(identical(other.lectureTitle, lectureTitle) || other.lectureTitle == lectureTitle)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other._mcqs, _mcqs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,aboutLecture,contentUpload,const DeepCollectionEquality().hash(assignment),lectureTitle,duration,const DeepCollectionEquality().hash(_mcqs));

@override
String toString() {
  return 'SingleCourseLectureDto(id: $id, aboutLecture: $aboutLecture, contentUpload: $contentUpload, assignment: $assignment, lectureTitle: $lectureTitle, duration: $duration, mcqs: $mcqs)';
}


}

/// @nodoc
abstract mixin class _$SingleCourseLectureDtoCopyWith<$Res> implements $SingleCourseLectureDtoCopyWith<$Res> {
  factory _$SingleCourseLectureDtoCopyWith(_SingleCourseLectureDto value, $Res Function(_SingleCourseLectureDto) _then) = __$SingleCourseLectureDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'aboutLecture') String aboutLecture,@JsonKey(name: 'contentUpload') String contentUpload,@JsonKey(name: 'assignment') dynamic assignment,@JsonKey(name: 'lectureTitle') String lectureTitle,@JsonKey(name: 'duration') String duration,@JsonKey(name: 'mcqs') List<dynamic> mcqs
});




}
/// @nodoc
class __$SingleCourseLectureDtoCopyWithImpl<$Res>
    implements _$SingleCourseLectureDtoCopyWith<$Res> {
  __$SingleCourseLectureDtoCopyWithImpl(this._self, this._then);

  final _SingleCourseLectureDto _self;
  final $Res Function(_SingleCourseLectureDto) _then;

/// Create a copy of SingleCourseLectureDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? aboutLecture = null,Object? contentUpload = null,Object? assignment = freezed,Object? lectureTitle = null,Object? duration = null,Object? mcqs = null,}) {
  return _then(_SingleCourseLectureDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,aboutLecture: null == aboutLecture ? _self.aboutLecture : aboutLecture // ignore: cast_nullable_to_non_nullable
as String,contentUpload: null == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String,assignment: freezed == assignment ? _self.assignment : assignment // ignore: cast_nullable_to_non_nullable
as dynamic,lectureTitle: null == lectureTitle ? _self.lectureTitle : lectureTitle // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,mcqs: null == mcqs ? _self._mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

// dart format on
