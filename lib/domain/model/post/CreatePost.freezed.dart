// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CreatePost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreatePost {

 int get id; String get title; String get content; String get category; String get createdAt; int get likesCount; int get userId; String? get filePath; String? get fileType; String? get mimeType;
/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePostCopyWith<CreatePost> get copyWith => _$CreatePostCopyWithImpl<CreatePost>(this as CreatePost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,category,createdAt,likesCount,userId,filePath,fileType,mimeType);

@override
String toString() {
  return 'CreatePost(id: $id, title: $title, content: $content, category: $category, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, filePath: $filePath, fileType: $fileType, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $CreatePostCopyWith<$Res>  {
  factory $CreatePostCopyWith(CreatePost value, $Res Function(CreatePost) _then) = _$CreatePostCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content, String category, String createdAt, int likesCount, int userId, String? filePath, String? fileType, String? mimeType
});




}
/// @nodoc
class _$CreatePostCopyWithImpl<$Res>
    implements $CreatePostCopyWith<$Res> {
  _$CreatePostCopyWithImpl(this._self, this._then);

  final CreatePost _self;
  final $Res Function(CreatePost) _then;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? category = null,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? filePath = freezed,Object? fileType = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePost].
extension CreatePostPatterns on CreatePost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePost value)  $default,){
final _that = this;
switch (_that) {
case _CreatePost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePost value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String category,  String createdAt,  int likesCount,  int userId,  String? filePath,  String? fileType,  String? mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.category,_that.createdAt,_that.likesCount,_that.userId,_that.filePath,_that.fileType,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String category,  String createdAt,  int likesCount,  int userId,  String? filePath,  String? fileType,  String? mimeType)  $default,) {final _that = this;
switch (_that) {
case _CreatePost():
return $default(_that.id,_that.title,_that.content,_that.category,_that.createdAt,_that.likesCount,_that.userId,_that.filePath,_that.fileType,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content,  String category,  String createdAt,  int likesCount,  int userId,  String? filePath,  String? fileType,  String? mimeType)?  $default,) {final _that = this;
switch (_that) {
case _CreatePost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.category,_that.createdAt,_that.likesCount,_that.userId,_that.filePath,_that.fileType,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc


class _CreatePost implements CreatePost {
  const _CreatePost({required this.id, required this.title, required this.content, required this.category, required this.createdAt, required this.likesCount, required this.userId, this.filePath, this.fileType, this.mimeType});
  

@override final  int id;
@override final  String title;
@override final  String content;
@override final  String category;
@override final  String createdAt;
@override final  int likesCount;
@override final  int userId;
@override final  String? filePath;
@override final  String? fileType;
@override final  String? mimeType;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePostCopyWith<_CreatePost> get copyWith => __$CreatePostCopyWithImpl<_CreatePost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,category,createdAt,likesCount,userId,filePath,fileType,mimeType);

@override
String toString() {
  return 'CreatePost(id: $id, title: $title, content: $content, category: $category, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, filePath: $filePath, fileType: $fileType, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$CreatePostCopyWith<$Res> implements $CreatePostCopyWith<$Res> {
  factory _$CreatePostCopyWith(_CreatePost value, $Res Function(_CreatePost) _then) = __$CreatePostCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content, String category, String createdAt, int likesCount, int userId, String? filePath, String? fileType, String? mimeType
});




}
/// @nodoc
class __$CreatePostCopyWithImpl<$Res>
    implements _$CreatePostCopyWith<$Res> {
  __$CreatePostCopyWithImpl(this._self, this._then);

  final _CreatePost _self;
  final $Res Function(_CreatePost) _then;

/// Create a copy of CreatePost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? category = null,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? filePath = freezed,Object? fileType = freezed,Object? mimeType = freezed,}) {
  return _then(_CreatePost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
