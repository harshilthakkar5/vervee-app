// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CourseModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseModel {

 int get id; String get courseTitle; String get subtitle; String get courseDescription; String get courseLevel; String get language; String get category; String get videoPreview; String get thumbnailPreview; List<LectureModel> get lectures;
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseModelCopyWith<CourseModel> get copyWith => _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.language, language) || other.language == language)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other.lectures, lectures));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,language,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(lectures));

@override
String toString() {
  return 'CourseModel(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, language: $language, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res>  {
  factory $CourseModelCopyWith(CourseModel value, $Res Function(CourseModel) _then) = _$CourseModelCopyWithImpl;
@useResult
$Res call({
 int id, String courseTitle, String subtitle, String courseDescription, String courseLevel, String language, String category, String videoPreview, String thumbnailPreview, List<LectureModel> lectures
});




}
/// @nodoc
class _$CourseModelCopyWithImpl<$Res>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseTitle = null,Object? subtitle = null,Object? courseDescription = null,Object? courseLevel = null,Object? language = null,Object? category = null,Object? videoPreview = null,Object? thumbnailPreview = null,Object? lectures = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,courseLevel: null == courseLevel ? _self.courseLevel : courseLevel // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,videoPreview: null == videoPreview ? _self.videoPreview : videoPreview // ignore: cast_nullable_to_non_nullable
as String,thumbnailPreview: null == thumbnailPreview ? _self.thumbnailPreview : thumbnailPreview // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self.lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<LectureModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseModel].
extension CourseModelPatterns on CourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String courseTitle,  String subtitle,  String courseDescription,  String courseLevel,  String language,  String category,  String videoPreview,  String thumbnailPreview,  List<LectureModel> lectures)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.language,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String courseTitle,  String subtitle,  String courseDescription,  String courseLevel,  String language,  String category,  String videoPreview,  String thumbnailPreview,  List<LectureModel> lectures)  $default,) {final _that = this;
switch (_that) {
case _CourseModel():
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.language,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String courseTitle,  String subtitle,  String courseDescription,  String courseLevel,  String language,  String category,  String videoPreview,  String thumbnailPreview,  List<LectureModel> lectures)?  $default,) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.courseTitle,_that.subtitle,_that.courseDescription,_that.courseLevel,_that.language,_that.category,_that.videoPreview,_that.thumbnailPreview,_that.lectures);case _:
  return null;

}
}

}

/// @nodoc


class _CourseModel extends CourseModel {
  const _CourseModel({required this.id, required this.courseTitle, required this.subtitle, required this.courseDescription, required this.courseLevel, required this.language, required this.category, required this.videoPreview, required this.thumbnailPreview, required final  List<LectureModel> lectures}): _lectures = lectures,super._();
  

@override final  int id;
@override final  String courseTitle;
@override final  String subtitle;
@override final  String courseDescription;
@override final  String courseLevel;
@override final  String language;
@override final  String category;
@override final  String videoPreview;
@override final  String thumbnailPreview;
 final  List<LectureModel> _lectures;
@override List<LectureModel> get lectures {
  if (_lectures is EqualUnmodifiableListView) return _lectures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lectures);
}


/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseModelCopyWith<_CourseModel> get copyWith => __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseTitle, courseTitle) || other.courseTitle == courseTitle)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.courseDescription, courseDescription) || other.courseDescription == courseDescription)&&(identical(other.courseLevel, courseLevel) || other.courseLevel == courseLevel)&&(identical(other.language, language) || other.language == language)&&(identical(other.category, category) || other.category == category)&&(identical(other.videoPreview, videoPreview) || other.videoPreview == videoPreview)&&(identical(other.thumbnailPreview, thumbnailPreview) || other.thumbnailPreview == thumbnailPreview)&&const DeepCollectionEquality().equals(other._lectures, _lectures));
}


@override
int get hashCode => Object.hash(runtimeType,id,courseTitle,subtitle,courseDescription,courseLevel,language,category,videoPreview,thumbnailPreview,const DeepCollectionEquality().hash(_lectures));

@override
String toString() {
  return 'CourseModel(id: $id, courseTitle: $courseTitle, subtitle: $subtitle, courseDescription: $courseDescription, courseLevel: $courseLevel, language: $language, category: $category, videoPreview: $videoPreview, thumbnailPreview: $thumbnailPreview, lectures: $lectures)';
}


}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res> implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(_CourseModel value, $Res Function(_CourseModel) _then) = __$CourseModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String courseTitle, String subtitle, String courseDescription, String courseLevel, String language, String category, String videoPreview, String thumbnailPreview, List<LectureModel> lectures
});




}
/// @nodoc
class __$CourseModelCopyWithImpl<$Res>
    implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseTitle = null,Object? subtitle = null,Object? courseDescription = null,Object? courseLevel = null,Object? language = null,Object? category = null,Object? videoPreview = null,Object? thumbnailPreview = null,Object? lectures = null,}) {
  return _then(_CourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseTitle: null == courseTitle ? _self.courseTitle : courseTitle // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,courseDescription: null == courseDescription ? _self.courseDescription : courseDescription // ignore: cast_nullable_to_non_nullable
as String,courseLevel: null == courseLevel ? _self.courseLevel : courseLevel // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,videoPreview: null == videoPreview ? _self.videoPreview : videoPreview // ignore: cast_nullable_to_non_nullable
as String,thumbnailPreview: null == thumbnailPreview ? _self.thumbnailPreview : thumbnailPreview // ignore: cast_nullable_to_non_nullable
as String,lectures: null == lectures ? _self._lectures : lectures // ignore: cast_nullable_to_non_nullable
as List<LectureModel>,
  ));
}


}

// dart format on
