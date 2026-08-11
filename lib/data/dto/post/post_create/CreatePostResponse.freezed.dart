// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CreatePostResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePostResponse {

@JsonKey(name: "id") int get id;@JsonKey(name: "title") String get title;@JsonKey(name: "content") String get content;@JsonKey(name: "mimeType") String? get mimeType;@JsonKey(name: "category") String get category;@JsonKey(name: "filePath") String? get filePath;@JsonKey(name: "fileType") String? get fileType;@JsonKey(name: "createdAt") DateTime get createdAt;@JsonKey(name: "likesCount") int get likesCount;@JsonKey(name: "userId") int get userId;
/// Create a copy of CreatePostResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePostResponseCopyWith<CreatePostResponse> get copyWith => _$CreatePostResponseCopyWithImpl<CreatePostResponse>(this as CreatePostResponse, _$identity);

  /// Serializes this CreatePostResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePostResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId);

@override
String toString() {
  return 'CreatePostResponse(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $CreatePostResponseCopyWith<$Res>  {
  factory $CreatePostResponseCopyWith(CreatePostResponse value, $Res Function(CreatePostResponse) _then) = _$CreatePostResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "content") String content,@JsonKey(name: "mimeType") String? mimeType,@JsonKey(name: "category") String category,@JsonKey(name: "filePath") String? filePath,@JsonKey(name: "fileType") String? fileType,@JsonKey(name: "createdAt") DateTime createdAt,@JsonKey(name: "likesCount") int likesCount,@JsonKey(name: "userId") int userId
});




}
/// @nodoc
class _$CreatePostResponseCopyWithImpl<$Res>
    implements $CreatePostResponseCopyWith<$Res> {
  _$CreatePostResponseCopyWithImpl(this._self, this._then);

  final CreatePostResponse _self;
  final $Res Function(CreatePostResponse) _then;

/// Create a copy of CreatePostResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePostResponse].
extension CreatePostResponsePatterns on CreatePostResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePostResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePostResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePostResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreatePostResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePostResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePostResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePostResponse() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId)  $default,) {final _that = this;
switch (_that) {
case _CreatePostResponse():
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId)?  $default,) {final _that = this;
switch (_that) {
case _CreatePostResponse() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePostResponse extends CreatePostResponse {
  const _CreatePostResponse({@JsonKey(name: "id") required this.id, @JsonKey(name: "title") required this.title, @JsonKey(name: "content") required this.content, @JsonKey(name: "mimeType") this.mimeType, @JsonKey(name: "category") required this.category, @JsonKey(name: "filePath") this.filePath, @JsonKey(name: "fileType") this.fileType, @JsonKey(name: "createdAt") required this.createdAt, @JsonKey(name: "likesCount") required this.likesCount, @JsonKey(name: "userId") required this.userId}): super._();
  factory _CreatePostResponse.fromJson(Map<String, dynamic> json) => _$CreatePostResponseFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "content") final  String content;
@override@JsonKey(name: "mimeType") final  String? mimeType;
@override@JsonKey(name: "category") final  String category;
@override@JsonKey(name: "filePath") final  String? filePath;
@override@JsonKey(name: "fileType") final  String? fileType;
@override@JsonKey(name: "createdAt") final  DateTime createdAt;
@override@JsonKey(name: "likesCount") final  int likesCount;
@override@JsonKey(name: "userId") final  int userId;

/// Create a copy of CreatePostResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePostResponseCopyWith<_CreatePostResponse> get copyWith => __$CreatePostResponseCopyWithImpl<_CreatePostResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePostResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePostResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId);

@override
String toString() {
  return 'CreatePostResponse(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$CreatePostResponseCopyWith<$Res> implements $CreatePostResponseCopyWith<$Res> {
  factory _$CreatePostResponseCopyWith(_CreatePostResponse value, $Res Function(_CreatePostResponse) _then) = __$CreatePostResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "content") String content,@JsonKey(name: "mimeType") String? mimeType,@JsonKey(name: "category") String category,@JsonKey(name: "filePath") String? filePath,@JsonKey(name: "fileType") String? fileType,@JsonKey(name: "createdAt") DateTime createdAt,@JsonKey(name: "likesCount") int likesCount,@JsonKey(name: "userId") int userId
});




}
/// @nodoc
class __$CreatePostResponseCopyWithImpl<$Res>
    implements _$CreatePostResponseCopyWith<$Res> {
  __$CreatePostResponseCopyWithImpl(this._self, this._then);

  final _CreatePostResponse _self;
  final $Res Function(_CreatePostResponse) _then;

/// Create a copy of CreatePostResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,}) {
  return _then(_CreatePostResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
