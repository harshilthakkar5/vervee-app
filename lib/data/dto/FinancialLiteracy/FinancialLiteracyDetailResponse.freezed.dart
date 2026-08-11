// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'FinancialLiteracyDetailResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialLiteracyDetailDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'learnAboutFinancialTitle') String get learnAboutFinancialTitle;@JsonKey(name: 'learnAboutFinancialSubtitle') String get learnAboutFinancialSubtitle;@JsonKey(name: 'content') String get content;@JsonKey(name: 'file') String? get file;@JsonKey(name: 'thumbnail') String? get thumbnail;@JsonKey(name: 'title') String get title;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'likesCount') int get likesCount;// @JsonKey(name: 'isLiked')                   required bool        isLiked,
// @JsonKey(name: 'isOwner')                   required bool        isOwner,
// ✅ FIX — ye teen fields detail API response mein nahi hote
//          required rakha tha → Freezed parse fail → mcqs = []
@JsonKey(name: 'isLiked') bool get isLiked;@JsonKey(name: 'isOwner') bool get isOwner;@JsonKey(name: 'userName') String? get userName;@JsonKey(name: 'videos') List<VideoDto> get videos;@JsonKey(name: 'mcqs') List<McqDto> get mcqs;
/// Create a copy of FinancialLiteracyDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialLiteracyDetailDtoCopyWith<FinancialLiteracyDetailDto> get copyWith => _$FinancialLiteracyDetailDtoCopyWithImpl<FinancialLiteracyDetailDto>(this as FinancialLiteracyDetailDto, _$identity);

  /// Serializes this FinancialLiteracyDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialLiteracyDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.learnAboutFinancialTitle, learnAboutFinancialTitle) || other.learnAboutFinancialTitle == learnAboutFinancialTitle)&&(identical(other.learnAboutFinancialSubtitle, learnAboutFinancialSubtitle) || other.learnAboutFinancialSubtitle == learnAboutFinancialSubtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.file, file) || other.file == file)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName)&&const DeepCollectionEquality().equals(other.videos, videos)&&const DeepCollectionEquality().equals(other.mcqs, mcqs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,learnAboutFinancialTitle,learnAboutFinancialSubtitle,content,file,thumbnail,title,createdAt,likesCount,isLiked,isOwner,userName,const DeepCollectionEquality().hash(videos),const DeepCollectionEquality().hash(mcqs));

@override
String toString() {
  return 'FinancialLiteracyDetailDto(id: $id, learnAboutFinancialTitle: $learnAboutFinancialTitle, learnAboutFinancialSubtitle: $learnAboutFinancialSubtitle, content: $content, file: $file, thumbnail: $thumbnail, title: $title, createdAt: $createdAt, likesCount: $likesCount, isLiked: $isLiked, isOwner: $isOwner, userName: $userName, videos: $videos, mcqs: $mcqs)';
}


}

/// @nodoc
abstract mixin class $FinancialLiteracyDetailDtoCopyWith<$Res>  {
  factory $FinancialLiteracyDetailDtoCopyWith(FinancialLiteracyDetailDto value, $Res Function(FinancialLiteracyDetailDto) _then) = _$FinancialLiteracyDetailDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'learnAboutFinancialTitle') String learnAboutFinancialTitle,@JsonKey(name: 'learnAboutFinancialSubtitle') String learnAboutFinancialSubtitle,@JsonKey(name: 'content') String content,@JsonKey(name: 'file') String? file,@JsonKey(name: 'thumbnail') String? thumbnail,@JsonKey(name: 'title') String title,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'likesCount') int likesCount,@JsonKey(name: 'isLiked') bool isLiked,@JsonKey(name: 'isOwner') bool isOwner,@JsonKey(name: 'userName') String? userName,@JsonKey(name: 'videos') List<VideoDto> videos,@JsonKey(name: 'mcqs') List<McqDto> mcqs
});




}
/// @nodoc
class _$FinancialLiteracyDetailDtoCopyWithImpl<$Res>
    implements $FinancialLiteracyDetailDtoCopyWith<$Res> {
  _$FinancialLiteracyDetailDtoCopyWithImpl(this._self, this._then);

  final FinancialLiteracyDetailDto _self;
  final $Res Function(FinancialLiteracyDetailDto) _then;

/// Create a copy of FinancialLiteracyDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? learnAboutFinancialTitle = null,Object? learnAboutFinancialSubtitle = null,Object? content = null,Object? file = freezed,Object? thumbnail = freezed,Object? title = null,Object? createdAt = null,Object? likesCount = null,Object? isLiked = null,Object? isOwner = null,Object? userName = freezed,Object? videos = null,Object? mcqs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,learnAboutFinancialTitle: null == learnAboutFinancialTitle ? _self.learnAboutFinancialTitle : learnAboutFinancialTitle // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialSubtitle: null == learnAboutFinancialSubtitle ? _self.learnAboutFinancialSubtitle : learnAboutFinancialSubtitle // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoDto>,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialLiteracyDetailDto].
extension FinancialLiteracyDetailDtoPatterns on FinancialLiteracyDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialLiteracyDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialLiteracyDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialLiteracyDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'userName')  String? userName, @JsonKey(name: 'videos')  List<VideoDto> videos, @JsonKey(name: 'mcqs')  List<McqDto> mcqs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto() when $default != null:
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.userName,_that.videos,_that.mcqs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'userName')  String? userName, @JsonKey(name: 'videos')  List<VideoDto> videos, @JsonKey(name: 'mcqs')  List<McqDto> mcqs)  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto():
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.userName,_that.videos,_that.mcqs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'userName')  String? userName, @JsonKey(name: 'videos')  List<VideoDto> videos, @JsonKey(name: 'mcqs')  List<McqDto> mcqs)?  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyDetailDto() when $default != null:
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.userName,_that.videos,_that.mcqs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialLiteracyDetailDto extends FinancialLiteracyDetailDto {
  const _FinancialLiteracyDetailDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'learnAboutFinancialTitle') required this.learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle') required this.learnAboutFinancialSubtitle, @JsonKey(name: 'content') required this.content, @JsonKey(name: 'file') this.file, @JsonKey(name: 'thumbnail') this.thumbnail, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'likesCount') required this.likesCount, @JsonKey(name: 'isLiked') this.isLiked = false, @JsonKey(name: 'isOwner') this.isOwner = false, @JsonKey(name: 'userName') this.userName, @JsonKey(name: 'videos') final  List<VideoDto> videos = const [], @JsonKey(name: 'mcqs') final  List<McqDto> mcqs = const []}): _videos = videos,_mcqs = mcqs,super._();
  factory _FinancialLiteracyDetailDto.fromJson(Map<String, dynamic> json) => _$FinancialLiteracyDetailDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'learnAboutFinancialTitle') final  String learnAboutFinancialTitle;
@override@JsonKey(name: 'learnAboutFinancialSubtitle') final  String learnAboutFinancialSubtitle;
@override@JsonKey(name: 'content') final  String content;
@override@JsonKey(name: 'file') final  String? file;
@override@JsonKey(name: 'thumbnail') final  String? thumbnail;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'likesCount') final  int likesCount;
// @JsonKey(name: 'isLiked')                   required bool        isLiked,
// @JsonKey(name: 'isOwner')                   required bool        isOwner,
// ✅ FIX — ye teen fields detail API response mein nahi hote
//          required rakha tha → Freezed parse fail → mcqs = []
@override@JsonKey(name: 'isLiked') final  bool isLiked;
@override@JsonKey(name: 'isOwner') final  bool isOwner;
@override@JsonKey(name: 'userName') final  String? userName;
 final  List<VideoDto> _videos;
@override@JsonKey(name: 'videos') List<VideoDto> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}

 final  List<McqDto> _mcqs;
@override@JsonKey(name: 'mcqs') List<McqDto> get mcqs {
  if (_mcqs is EqualUnmodifiableListView) return _mcqs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mcqs);
}


/// Create a copy of FinancialLiteracyDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialLiteracyDetailDtoCopyWith<_FinancialLiteracyDetailDto> get copyWith => __$FinancialLiteracyDetailDtoCopyWithImpl<_FinancialLiteracyDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialLiteracyDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialLiteracyDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.learnAboutFinancialTitle, learnAboutFinancialTitle) || other.learnAboutFinancialTitle == learnAboutFinancialTitle)&&(identical(other.learnAboutFinancialSubtitle, learnAboutFinancialSubtitle) || other.learnAboutFinancialSubtitle == learnAboutFinancialSubtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.file, file) || other.file == file)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName)&&const DeepCollectionEquality().equals(other._videos, _videos)&&const DeepCollectionEquality().equals(other._mcqs, _mcqs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,learnAboutFinancialTitle,learnAboutFinancialSubtitle,content,file,thumbnail,title,createdAt,likesCount,isLiked,isOwner,userName,const DeepCollectionEquality().hash(_videos),const DeepCollectionEquality().hash(_mcqs));

@override
String toString() {
  return 'FinancialLiteracyDetailDto(id: $id, learnAboutFinancialTitle: $learnAboutFinancialTitle, learnAboutFinancialSubtitle: $learnAboutFinancialSubtitle, content: $content, file: $file, thumbnail: $thumbnail, title: $title, createdAt: $createdAt, likesCount: $likesCount, isLiked: $isLiked, isOwner: $isOwner, userName: $userName, videos: $videos, mcqs: $mcqs)';
}


}

/// @nodoc
abstract mixin class _$FinancialLiteracyDetailDtoCopyWith<$Res> implements $FinancialLiteracyDetailDtoCopyWith<$Res> {
  factory _$FinancialLiteracyDetailDtoCopyWith(_FinancialLiteracyDetailDto value, $Res Function(_FinancialLiteracyDetailDto) _then) = __$FinancialLiteracyDetailDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'learnAboutFinancialTitle') String learnAboutFinancialTitle,@JsonKey(name: 'learnAboutFinancialSubtitle') String learnAboutFinancialSubtitle,@JsonKey(name: 'content') String content,@JsonKey(name: 'file') String? file,@JsonKey(name: 'thumbnail') String? thumbnail,@JsonKey(name: 'title') String title,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'likesCount') int likesCount,@JsonKey(name: 'isLiked') bool isLiked,@JsonKey(name: 'isOwner') bool isOwner,@JsonKey(name: 'userName') String? userName,@JsonKey(name: 'videos') List<VideoDto> videos,@JsonKey(name: 'mcqs') List<McqDto> mcqs
});




}
/// @nodoc
class __$FinancialLiteracyDetailDtoCopyWithImpl<$Res>
    implements _$FinancialLiteracyDetailDtoCopyWith<$Res> {
  __$FinancialLiteracyDetailDtoCopyWithImpl(this._self, this._then);

  final _FinancialLiteracyDetailDto _self;
  final $Res Function(_FinancialLiteracyDetailDto) _then;

/// Create a copy of FinancialLiteracyDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? learnAboutFinancialTitle = null,Object? learnAboutFinancialSubtitle = null,Object? content = null,Object? file = freezed,Object? thumbnail = freezed,Object? title = null,Object? createdAt = null,Object? likesCount = null,Object? isLiked = null,Object? isOwner = null,Object? userName = freezed,Object? videos = null,Object? mcqs = null,}) {
  return _then(_FinancialLiteracyDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,learnAboutFinancialTitle: null == learnAboutFinancialTitle ? _self.learnAboutFinancialTitle : learnAboutFinancialTitle // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialSubtitle: null == learnAboutFinancialSubtitle ? _self.learnAboutFinancialSubtitle : learnAboutFinancialSubtitle // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoDto>,mcqs: null == mcqs ? _self._mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqDto>,
  ));
}


}


/// @nodoc
mixin _$McqOptionDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'text') String get text;@JsonKey(name: 'isCorrect') bool get isCorrect;@JsonKey(name: 'mcqId') int get mcqId;
/// Create a copy of McqOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqOptionDtoCopyWith<McqOptionDto> get copyWith => _$McqOptionDtoCopyWithImpl<McqOptionDto>(this as McqOptionDto, _$identity);

  /// Serializes this McqOptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqOptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.mcqId, mcqId) || other.mcqId == mcqId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,isCorrect,mcqId);

@override
String toString() {
  return 'McqOptionDto(id: $id, text: $text, isCorrect: $isCorrect, mcqId: $mcqId)';
}


}

/// @nodoc
abstract mixin class $McqOptionDtoCopyWith<$Res>  {
  factory $McqOptionDtoCopyWith(McqOptionDto value, $Res Function(McqOptionDto) _then) = _$McqOptionDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'text') String text,@JsonKey(name: 'isCorrect') bool isCorrect,@JsonKey(name: 'mcqId') int mcqId
});




}
/// @nodoc
class _$McqOptionDtoCopyWithImpl<$Res>
    implements $McqOptionDtoCopyWith<$Res> {
  _$McqOptionDtoCopyWithImpl(this._self, this._then);

  final McqOptionDto _self;
  final $Res Function(McqOptionDto) _then;

/// Create a copy of McqOptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? isCorrect = null,Object? mcqId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,mcqId: null == mcqId ? _self.mcqId : mcqId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [McqOptionDto].
extension McqOptionDtoPatterns on McqOptionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McqOptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McqOptionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McqOptionDto value)  $default,){
final _that = this;
switch (_that) {
case _McqOptionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McqOptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _McqOptionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'text')  String text, @JsonKey(name: 'isCorrect')  bool isCorrect, @JsonKey(name: 'mcqId')  int mcqId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McqOptionDto() when $default != null:
return $default(_that.id,_that.text,_that.isCorrect,_that.mcqId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'text')  String text, @JsonKey(name: 'isCorrect')  bool isCorrect, @JsonKey(name: 'mcqId')  int mcqId)  $default,) {final _that = this;
switch (_that) {
case _McqOptionDto():
return $default(_that.id,_that.text,_that.isCorrect,_that.mcqId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'text')  String text, @JsonKey(name: 'isCorrect')  bool isCorrect, @JsonKey(name: 'mcqId')  int mcqId)?  $default,) {final _that = this;
switch (_that) {
case _McqOptionDto() when $default != null:
return $default(_that.id,_that.text,_that.isCorrect,_that.mcqId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _McqOptionDto implements McqOptionDto {
  const _McqOptionDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'text') required this.text, @JsonKey(name: 'isCorrect') required this.isCorrect, @JsonKey(name: 'mcqId') required this.mcqId});
  factory _McqOptionDto.fromJson(Map<String, dynamic> json) => _$McqOptionDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'text') final  String text;
@override@JsonKey(name: 'isCorrect') final  bool isCorrect;
@override@JsonKey(name: 'mcqId') final  int mcqId;

/// Create a copy of McqOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McqOptionDtoCopyWith<_McqOptionDto> get copyWith => __$McqOptionDtoCopyWithImpl<_McqOptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McqOptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McqOptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.mcqId, mcqId) || other.mcqId == mcqId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,isCorrect,mcqId);

@override
String toString() {
  return 'McqOptionDto(id: $id, text: $text, isCorrect: $isCorrect, mcqId: $mcqId)';
}


}

/// @nodoc
abstract mixin class _$McqOptionDtoCopyWith<$Res> implements $McqOptionDtoCopyWith<$Res> {
  factory _$McqOptionDtoCopyWith(_McqOptionDto value, $Res Function(_McqOptionDto) _then) = __$McqOptionDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'text') String text,@JsonKey(name: 'isCorrect') bool isCorrect,@JsonKey(name: 'mcqId') int mcqId
});




}
/// @nodoc
class __$McqOptionDtoCopyWithImpl<$Res>
    implements _$McqOptionDtoCopyWith<$Res> {
  __$McqOptionDtoCopyWithImpl(this._self, this._then);

  final _McqOptionDto _self;
  final $Res Function(_McqOptionDto) _then;

/// Create a copy of McqOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? isCorrect = null,Object? mcqId = null,}) {
  return _then(_McqOptionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,mcqId: null == mcqId ? _self.mcqId : mcqId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$McqDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'question') String get question;@JsonKey(name: 'learnAboutFinancialId') int get learnAboutFinancialId;@JsonKey(name: 'options') List<McqOptionDto> get options;
/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqDtoCopyWith<McqDto> get copyWith => _$McqDtoCopyWithImpl<McqDto>(this as McqDto, _$identity);

  /// Serializes this McqDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqDto&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.learnAboutFinancialId, learnAboutFinancialId) || other.learnAboutFinancialId == learnAboutFinancialId)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,learnAboutFinancialId,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'McqDto(id: $id, question: $question, learnAboutFinancialId: $learnAboutFinancialId, options: $options)';
}


}

/// @nodoc
abstract mixin class $McqDtoCopyWith<$Res>  {
  factory $McqDtoCopyWith(McqDto value, $Res Function(McqDto) _then) = _$McqDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'question') String question,@JsonKey(name: 'learnAboutFinancialId') int learnAboutFinancialId,@JsonKey(name: 'options') List<McqOptionDto> options
});




}
/// @nodoc
class _$McqDtoCopyWithImpl<$Res>
    implements $McqDtoCopyWith<$Res> {
  _$McqDtoCopyWithImpl(this._self, this._then);

  final McqDto _self;
  final $Res Function(McqDto) _then;

/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? learnAboutFinancialId = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialId: null == learnAboutFinancialId ? _self.learnAboutFinancialId : learnAboutFinancialId // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<McqOptionDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [McqDto].
extension McqDtoPatterns on McqDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McqDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McqDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McqDto value)  $default,){
final _that = this;
switch (_that) {
case _McqDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McqDto value)?  $default,){
final _that = this;
switch (_that) {
case _McqDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'question')  String question, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'options')  List<McqOptionDto> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McqDto() when $default != null:
return $default(_that.id,_that.question,_that.learnAboutFinancialId,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'question')  String question, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'options')  List<McqOptionDto> options)  $default,) {final _that = this;
switch (_that) {
case _McqDto():
return $default(_that.id,_that.question,_that.learnAboutFinancialId,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'question')  String question, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'options')  List<McqOptionDto> options)?  $default,) {final _that = this;
switch (_that) {
case _McqDto() when $default != null:
return $default(_that.id,_that.question,_that.learnAboutFinancialId,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _McqDto implements McqDto {
  const _McqDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'question') required this.question, @JsonKey(name: 'learnAboutFinancialId') required this.learnAboutFinancialId, @JsonKey(name: 'options') final  List<McqOptionDto> options = const []}): _options = options;
  factory _McqDto.fromJson(Map<String, dynamic> json) => _$McqDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'question') final  String question;
@override@JsonKey(name: 'learnAboutFinancialId') final  int learnAboutFinancialId;
 final  List<McqOptionDto> _options;
@override@JsonKey(name: 'options') List<McqOptionDto> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McqDtoCopyWith<_McqDto> get copyWith => __$McqDtoCopyWithImpl<_McqDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McqDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McqDto&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.learnAboutFinancialId, learnAboutFinancialId) || other.learnAboutFinancialId == learnAboutFinancialId)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,learnAboutFinancialId,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'McqDto(id: $id, question: $question, learnAboutFinancialId: $learnAboutFinancialId, options: $options)';
}


}

/// @nodoc
abstract mixin class _$McqDtoCopyWith<$Res> implements $McqDtoCopyWith<$Res> {
  factory _$McqDtoCopyWith(_McqDto value, $Res Function(_McqDto) _then) = __$McqDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'question') String question,@JsonKey(name: 'learnAboutFinancialId') int learnAboutFinancialId,@JsonKey(name: 'options') List<McqOptionDto> options
});




}
/// @nodoc
class __$McqDtoCopyWithImpl<$Res>
    implements _$McqDtoCopyWith<$Res> {
  __$McqDtoCopyWithImpl(this._self, this._then);

  final _McqDto _self;
  final $Res Function(_McqDto) _then;

/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? learnAboutFinancialId = null,Object? options = null,}) {
  return _then(_McqDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialId: null == learnAboutFinancialId ? _self.learnAboutFinancialId : learnAboutFinancialId // ignore: cast_nullable_to_non_nullable
as int,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<McqOptionDto>,
  ));
}


}

// dart format on
