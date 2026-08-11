// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'FinancialLiteracyItemResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialLiteracyItemDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'learnAboutFinancialTitle') String get learnAboutFinancialTitle;@JsonKey(name: 'learnAboutFinancialSubtitle') String get learnAboutFinancialSubtitle;@JsonKey(name: 'content') String get content;@JsonKey(name: 'file') String? get file;@JsonKey(name: 'thumbnail') String? get thumbnail;@JsonKey(name: 'title') String get title;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'likesCount') int get likesCount;@JsonKey(name: 'isLiked') bool get isLiked;@JsonKey(name: 'isOwner') bool get isOwner;@JsonKey(name: 'videos') List<VideoDto> get videos;
/// Create a copy of FinancialLiteracyItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialLiteracyItemDtoCopyWith<FinancialLiteracyItemDto> get copyWith => _$FinancialLiteracyItemDtoCopyWithImpl<FinancialLiteracyItemDto>(this as FinancialLiteracyItemDto, _$identity);

  /// Serializes this FinancialLiteracyItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialLiteracyItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.learnAboutFinancialTitle, learnAboutFinancialTitle) || other.learnAboutFinancialTitle == learnAboutFinancialTitle)&&(identical(other.learnAboutFinancialSubtitle, learnAboutFinancialSubtitle) || other.learnAboutFinancialSubtitle == learnAboutFinancialSubtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.file, file) || other.file == file)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&const DeepCollectionEquality().equals(other.videos, videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,learnAboutFinancialTitle,learnAboutFinancialSubtitle,content,file,thumbnail,title,createdAt,likesCount,isLiked,isOwner,const DeepCollectionEquality().hash(videos));

@override
String toString() {
  return 'FinancialLiteracyItemDto(id: $id, learnAboutFinancialTitle: $learnAboutFinancialTitle, learnAboutFinancialSubtitle: $learnAboutFinancialSubtitle, content: $content, file: $file, thumbnail: $thumbnail, title: $title, createdAt: $createdAt, likesCount: $likesCount, isLiked: $isLiked, isOwner: $isOwner, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $FinancialLiteracyItemDtoCopyWith<$Res>  {
  factory $FinancialLiteracyItemDtoCopyWith(FinancialLiteracyItemDto value, $Res Function(FinancialLiteracyItemDto) _then) = _$FinancialLiteracyItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'learnAboutFinancialTitle') String learnAboutFinancialTitle,@JsonKey(name: 'learnAboutFinancialSubtitle') String learnAboutFinancialSubtitle,@JsonKey(name: 'content') String content,@JsonKey(name: 'file') String? file,@JsonKey(name: 'thumbnail') String? thumbnail,@JsonKey(name: 'title') String title,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'likesCount') int likesCount,@JsonKey(name: 'isLiked') bool isLiked,@JsonKey(name: 'isOwner') bool isOwner,@JsonKey(name: 'videos') List<VideoDto> videos
});




}
/// @nodoc
class _$FinancialLiteracyItemDtoCopyWithImpl<$Res>
    implements $FinancialLiteracyItemDtoCopyWith<$Res> {
  _$FinancialLiteracyItemDtoCopyWithImpl(this._self, this._then);

  final FinancialLiteracyItemDto _self;
  final $Res Function(FinancialLiteracyItemDto) _then;

/// Create a copy of FinancialLiteracyItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? learnAboutFinancialTitle = null,Object? learnAboutFinancialSubtitle = null,Object? content = null,Object? file = freezed,Object? thumbnail = freezed,Object? title = null,Object? createdAt = null,Object? likesCount = null,Object? isLiked = null,Object? isOwner = null,Object? videos = null,}) {
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
as bool,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialLiteracyItemDto].
extension FinancialLiteracyItemDtoPatterns on FinancialLiteracyItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialLiteracyItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialLiteracyItemDto value)  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialLiteracyItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'videos')  List<VideoDto> videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto() when $default != null:
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.videos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'videos')  List<VideoDto> videos)  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto():
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.videos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'learnAboutFinancialTitle')  String learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle')  String learnAboutFinancialSubtitle, @JsonKey(name: 'content')  String content, @JsonKey(name: 'file')  String? file, @JsonKey(name: 'thumbnail')  String? thumbnail, @JsonKey(name: 'title')  String title, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'likesCount')  int likesCount, @JsonKey(name: 'isLiked')  bool isLiked, @JsonKey(name: 'isOwner')  bool isOwner, @JsonKey(name: 'videos')  List<VideoDto> videos)?  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyItemDto() when $default != null:
return $default(_that.id,_that.learnAboutFinancialTitle,_that.learnAboutFinancialSubtitle,_that.content,_that.file,_that.thumbnail,_that.title,_that.createdAt,_that.likesCount,_that.isLiked,_that.isOwner,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialLiteracyItemDto extends FinancialLiteracyItemDto {
  const _FinancialLiteracyItemDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'learnAboutFinancialTitle') required this.learnAboutFinancialTitle, @JsonKey(name: 'learnAboutFinancialSubtitle') required this.learnAboutFinancialSubtitle, @JsonKey(name: 'content') required this.content, @JsonKey(name: 'file') this.file, @JsonKey(name: 'thumbnail') this.thumbnail, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'likesCount') required this.likesCount, @JsonKey(name: 'isLiked') required this.isLiked, @JsonKey(name: 'isOwner') required this.isOwner, @JsonKey(name: 'videos') final  List<VideoDto> videos = const []}): _videos = videos,super._();
  factory _FinancialLiteracyItemDto.fromJson(Map<String, dynamic> json) => _$FinancialLiteracyItemDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'learnAboutFinancialTitle') final  String learnAboutFinancialTitle;
@override@JsonKey(name: 'learnAboutFinancialSubtitle') final  String learnAboutFinancialSubtitle;
@override@JsonKey(name: 'content') final  String content;
@override@JsonKey(name: 'file') final  String? file;
@override@JsonKey(name: 'thumbnail') final  String? thumbnail;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'likesCount') final  int likesCount;
@override@JsonKey(name: 'isLiked') final  bool isLiked;
@override@JsonKey(name: 'isOwner') final  bool isOwner;
 final  List<VideoDto> _videos;
@override@JsonKey(name: 'videos') List<VideoDto> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of FinancialLiteracyItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialLiteracyItemDtoCopyWith<_FinancialLiteracyItemDto> get copyWith => __$FinancialLiteracyItemDtoCopyWithImpl<_FinancialLiteracyItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialLiteracyItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialLiteracyItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.learnAboutFinancialTitle, learnAboutFinancialTitle) || other.learnAboutFinancialTitle == learnAboutFinancialTitle)&&(identical(other.learnAboutFinancialSubtitle, learnAboutFinancialSubtitle) || other.learnAboutFinancialSubtitle == learnAboutFinancialSubtitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.file, file) || other.file == file)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&const DeepCollectionEquality().equals(other._videos, _videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,learnAboutFinancialTitle,learnAboutFinancialSubtitle,content,file,thumbnail,title,createdAt,likesCount,isLiked,isOwner,const DeepCollectionEquality().hash(_videos));

@override
String toString() {
  return 'FinancialLiteracyItemDto(id: $id, learnAboutFinancialTitle: $learnAboutFinancialTitle, learnAboutFinancialSubtitle: $learnAboutFinancialSubtitle, content: $content, file: $file, thumbnail: $thumbnail, title: $title, createdAt: $createdAt, likesCount: $likesCount, isLiked: $isLiked, isOwner: $isOwner, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$FinancialLiteracyItemDtoCopyWith<$Res> implements $FinancialLiteracyItemDtoCopyWith<$Res> {
  factory _$FinancialLiteracyItemDtoCopyWith(_FinancialLiteracyItemDto value, $Res Function(_FinancialLiteracyItemDto) _then) = __$FinancialLiteracyItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'learnAboutFinancialTitle') String learnAboutFinancialTitle,@JsonKey(name: 'learnAboutFinancialSubtitle') String learnAboutFinancialSubtitle,@JsonKey(name: 'content') String content,@JsonKey(name: 'file') String? file,@JsonKey(name: 'thumbnail') String? thumbnail,@JsonKey(name: 'title') String title,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'likesCount') int likesCount,@JsonKey(name: 'isLiked') bool isLiked,@JsonKey(name: 'isOwner') bool isOwner,@JsonKey(name: 'videos') List<VideoDto> videos
});




}
/// @nodoc
class __$FinancialLiteracyItemDtoCopyWithImpl<$Res>
    implements _$FinancialLiteracyItemDtoCopyWith<$Res> {
  __$FinancialLiteracyItemDtoCopyWithImpl(this._self, this._then);

  final _FinancialLiteracyItemDto _self;
  final $Res Function(_FinancialLiteracyItemDto) _then;

/// Create a copy of FinancialLiteracyItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? learnAboutFinancialTitle = null,Object? learnAboutFinancialSubtitle = null,Object? content = null,Object? file = freezed,Object? thumbnail = freezed,Object? title = null,Object? createdAt = null,Object? likesCount = null,Object? isLiked = null,Object? isOwner = null,Object? videos = null,}) {
  return _then(_FinancialLiteracyItemDto(
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
as bool,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoDto>,
  ));
}


}


/// @nodoc
mixin _$VideoDto {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'title') String get title;@JsonKey(name: 'content') String get content;@JsonKey(name: 'learnAboutFinancialId') int get learnAboutFinancialId;@JsonKey(name: 'contentUpload') String? get contentUpload;
/// Create a copy of VideoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoDtoCopyWith<VideoDto> get copyWith => _$VideoDtoCopyWithImpl<VideoDto>(this as VideoDto, _$identity);

  /// Serializes this VideoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.learnAboutFinancialId, learnAboutFinancialId) || other.learnAboutFinancialId == learnAboutFinancialId)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,learnAboutFinancialId,contentUpload);

@override
String toString() {
  return 'VideoDto(id: $id, title: $title, content: $content, learnAboutFinancialId: $learnAboutFinancialId, contentUpload: $contentUpload)';
}


}

/// @nodoc
abstract mixin class $VideoDtoCopyWith<$Res>  {
  factory $VideoDtoCopyWith(VideoDto value, $Res Function(VideoDto) _then) = _$VideoDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'title') String title,@JsonKey(name: 'content') String content,@JsonKey(name: 'learnAboutFinancialId') int learnAboutFinancialId,@JsonKey(name: 'contentUpload') String? contentUpload
});




}
/// @nodoc
class _$VideoDtoCopyWithImpl<$Res>
    implements $VideoDtoCopyWith<$Res> {
  _$VideoDtoCopyWithImpl(this._self, this._then);

  final VideoDto _self;
  final $Res Function(VideoDto) _then;

/// Create a copy of VideoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? learnAboutFinancialId = null,Object? contentUpload = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialId: null == learnAboutFinancialId ? _self.learnAboutFinancialId : learnAboutFinancialId // ignore: cast_nullable_to_non_nullable
as int,contentUpload: freezed == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoDto].
extension VideoDtoPatterns on VideoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoDto value)  $default,){
final _that = this;
switch (_that) {
case _VideoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoDto value)?  $default,){
final _that = this;
switch (_that) {
case _VideoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'title')  String title, @JsonKey(name: 'content')  String content, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'contentUpload')  String? contentUpload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoDto() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.learnAboutFinancialId,_that.contentUpload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'title')  String title, @JsonKey(name: 'content')  String content, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'contentUpload')  String? contentUpload)  $default,) {final _that = this;
switch (_that) {
case _VideoDto():
return $default(_that.id,_that.title,_that.content,_that.learnAboutFinancialId,_that.contentUpload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'title')  String title, @JsonKey(name: 'content')  String content, @JsonKey(name: 'learnAboutFinancialId')  int learnAboutFinancialId, @JsonKey(name: 'contentUpload')  String? contentUpload)?  $default,) {final _that = this;
switch (_that) {
case _VideoDto() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.learnAboutFinancialId,_that.contentUpload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoDto implements VideoDto {
  const _VideoDto({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'content') required this.content, @JsonKey(name: 'learnAboutFinancialId') required this.learnAboutFinancialId, @JsonKey(name: 'contentUpload') this.contentUpload});
  factory _VideoDto.fromJson(Map<String, dynamic> json) => _$VideoDtoFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'content') final  String content;
@override@JsonKey(name: 'learnAboutFinancialId') final  int learnAboutFinancialId;
@override@JsonKey(name: 'contentUpload') final  String? contentUpload;

/// Create a copy of VideoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoDtoCopyWith<_VideoDto> get copyWith => __$VideoDtoCopyWithImpl<_VideoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.learnAboutFinancialId, learnAboutFinancialId) || other.learnAboutFinancialId == learnAboutFinancialId)&&(identical(other.contentUpload, contentUpload) || other.contentUpload == contentUpload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,learnAboutFinancialId,contentUpload);

@override
String toString() {
  return 'VideoDto(id: $id, title: $title, content: $content, learnAboutFinancialId: $learnAboutFinancialId, contentUpload: $contentUpload)';
}


}

/// @nodoc
abstract mixin class _$VideoDtoCopyWith<$Res> implements $VideoDtoCopyWith<$Res> {
  factory _$VideoDtoCopyWith(_VideoDto value, $Res Function(_VideoDto) _then) = __$VideoDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'title') String title,@JsonKey(name: 'content') String content,@JsonKey(name: 'learnAboutFinancialId') int learnAboutFinancialId,@JsonKey(name: 'contentUpload') String? contentUpload
});




}
/// @nodoc
class __$VideoDtoCopyWithImpl<$Res>
    implements _$VideoDtoCopyWith<$Res> {
  __$VideoDtoCopyWithImpl(this._self, this._then);

  final _VideoDto _self;
  final $Res Function(_VideoDto) _then;

/// Create a copy of VideoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? learnAboutFinancialId = null,Object? contentUpload = freezed,}) {
  return _then(_VideoDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,learnAboutFinancialId: null == learnAboutFinancialId ? _self.learnAboutFinancialId : learnAboutFinancialId // ignore: cast_nullable_to_non_nullable
as int,contentUpload: freezed == contentUpload ? _self.contentUpload : contentUpload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
