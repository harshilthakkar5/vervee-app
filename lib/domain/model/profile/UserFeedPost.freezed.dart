// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserFeedPost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserFeedPost {

 int get id; String get title; String get content; String get category; String? get filePath; String? get fileType; String? get mimeType; DateTime get createdAt; int get likesCount; int get userId; bool get isLiked;
/// Create a copy of UserFeedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFeedPostCopyWith<UserFeedPost> get copyWith => _$UserFeedPostCopyWithImpl<UserFeedPost>(this as UserFeedPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFeedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,category,filePath,fileType,mimeType,createdAt,likesCount,userId,isLiked);

@override
String toString() {
  return 'UserFeedPost(id: $id, title: $title, content: $content, category: $category, filePath: $filePath, fileType: $fileType, mimeType: $mimeType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class $UserFeedPostCopyWith<$Res>  {
  factory $UserFeedPostCopyWith(UserFeedPost value, $Res Function(UserFeedPost) _then) = _$UserFeedPostCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content, String category, String? filePath, String? fileType, String? mimeType, DateTime createdAt, int likesCount, int userId, bool isLiked
});




}
/// @nodoc
class _$UserFeedPostCopyWithImpl<$Res>
    implements $UserFeedPostCopyWith<$Res> {
  _$UserFeedPostCopyWithImpl(this._self, this._then);

  final UserFeedPost _self;
  final $Res Function(UserFeedPost) _then;

/// Create a copy of UserFeedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? mimeType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? isLiked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFeedPost].
extension UserFeedPostPatterns on UserFeedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFeedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFeedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFeedPost value)  $default,){
final _that = this;
switch (_that) {
case _UserFeedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFeedPost value)?  $default,){
final _that = this;
switch (_that) {
case _UserFeedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String category,  String? filePath,  String? fileType,  String? mimeType,  DateTime createdAt,  int likesCount,  int userId,  bool isLiked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFeedPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.category,_that.filePath,_that.fileType,_that.mimeType,_that.createdAt,_that.likesCount,_that.userId,_that.isLiked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String category,  String? filePath,  String? fileType,  String? mimeType,  DateTime createdAt,  int likesCount,  int userId,  bool isLiked)  $default,) {final _that = this;
switch (_that) {
case _UserFeedPost():
return $default(_that.id,_that.title,_that.content,_that.category,_that.filePath,_that.fileType,_that.mimeType,_that.createdAt,_that.likesCount,_that.userId,_that.isLiked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content,  String category,  String? filePath,  String? fileType,  String? mimeType,  DateTime createdAt,  int likesCount,  int userId,  bool isLiked)?  $default,) {final _that = this;
switch (_that) {
case _UserFeedPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.category,_that.filePath,_that.fileType,_that.mimeType,_that.createdAt,_that.likesCount,_that.userId,_that.isLiked);case _:
  return null;

}
}

}

/// @nodoc


class _UserFeedPost implements UserFeedPost {
  const _UserFeedPost({required this.id, required this.title, required this.content, required this.category, this.filePath, this.fileType, this.mimeType, required this.createdAt, required this.likesCount, required this.userId, required this.isLiked});
  

@override final  int id;
@override final  String title;
@override final  String content;
@override final  String category;
@override final  String? filePath;
@override final  String? fileType;
@override final  String? mimeType;
@override final  DateTime createdAt;
@override final  int likesCount;
@override final  int userId;
@override final  bool isLiked;

/// Create a copy of UserFeedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFeedPostCopyWith<_UserFeedPost> get copyWith => __$UserFeedPostCopyWithImpl<_UserFeedPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFeedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,category,filePath,fileType,mimeType,createdAt,likesCount,userId,isLiked);

@override
String toString() {
  return 'UserFeedPost(id: $id, title: $title, content: $content, category: $category, filePath: $filePath, fileType: $fileType, mimeType: $mimeType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, isLiked: $isLiked)';
}


}

/// @nodoc
abstract mixin class _$UserFeedPostCopyWith<$Res> implements $UserFeedPostCopyWith<$Res> {
  factory _$UserFeedPostCopyWith(_UserFeedPost value, $Res Function(_UserFeedPost) _then) = __$UserFeedPostCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content, String category, String? filePath, String? fileType, String? mimeType, DateTime createdAt, int likesCount, int userId, bool isLiked
});




}
/// @nodoc
class __$UserFeedPostCopyWithImpl<$Res>
    implements _$UserFeedPostCopyWith<$Res> {
  __$UserFeedPostCopyWithImpl(this._self, this._then);

  final _UserFeedPost _self;
  final $Res Function(_UserFeedPost) _then;

/// Create a copy of UserFeedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? mimeType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? isLiked = null,}) {
  return _then(_UserFeedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
