// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetPost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetPost {

 int get id; String get title; String get content; String? get mimeType; String get category; String? get filePath; String? get fileType; DateTime get createdAt; int get likesCount; int get userId; String get userRole; bool get isLiked; bool get isOwner; String get userName; String? get userAvatarUrl;
/// Create a copy of GetPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPostCopyWith<GetPost> get copyWith => _$GetPostCopyWithImpl<GetPost>(this as GetPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId,userRole,isLiked,isOwner,userName,userAvatarUrl);

@override
String toString() {
  return 'GetPost(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, userRole: $userRole, isLiked: $isLiked, isOwner: $isOwner, userName: $userName, userAvatarUrl: $userAvatarUrl)';
}


}

/// @nodoc
abstract mixin class $GetPostCopyWith<$Res>  {
  factory $GetPostCopyWith(GetPost value, $Res Function(GetPost) _then) = _$GetPostCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content, String? mimeType, String category, String? filePath, String? fileType, DateTime createdAt, int likesCount, int userId, String userRole, bool isLiked, bool isOwner, String userName, String? userAvatarUrl
});




}
/// @nodoc
class _$GetPostCopyWithImpl<$Res>
    implements $GetPostCopyWith<$Res> {
  _$GetPostCopyWithImpl(this._self, this._then);

  final GetPost _self;
  final $Res Function(GetPost) _then;

/// Create a copy of GetPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? userRole = null,Object? isLiked = null,Object? isOwner = null,Object? userName = null,Object? userAvatarUrl = freezed,}) {
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
as int,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetPost].
extension GetPostPatterns on GetPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetPost value)  $default,){
final _that = this;
switch (_that) {
case _GetPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetPost value)?  $default,){
final _that = this;
switch (_that) {
case _GetPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String? mimeType,  String category,  String? filePath,  String? fileType,  DateTime createdAt,  int likesCount,  int userId,  String userRole,  bool isLiked,  bool isOwner,  String userName,  String? userAvatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.userRole,_that.isLiked,_that.isOwner,_that.userName,_that.userAvatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content,  String? mimeType,  String category,  String? filePath,  String? fileType,  DateTime createdAt,  int likesCount,  int userId,  String userRole,  bool isLiked,  bool isOwner,  String userName,  String? userAvatarUrl)  $default,) {final _that = this;
switch (_that) {
case _GetPost():
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.userRole,_that.isLiked,_that.isOwner,_that.userName,_that.userAvatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content,  String? mimeType,  String category,  String? filePath,  String? fileType,  DateTime createdAt,  int likesCount,  int userId,  String userRole,  bool isLiked,  bool isOwner,  String userName,  String? userAvatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _GetPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.userRole,_that.isLiked,_that.isOwner,_that.userName,_that.userAvatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _GetPost implements GetPost {
  const _GetPost({required this.id, required this.title, required this.content, this.mimeType, required this.category, this.filePath, this.fileType, required this.createdAt, required this.likesCount, required this.userId, required this.userRole, required this.isLiked, required this.isOwner, required this.userName, this.userAvatarUrl});
  

@override final  int id;
@override final  String title;
@override final  String content;
@override final  String? mimeType;
@override final  String category;
@override final  String? filePath;
@override final  String? fileType;
@override final  DateTime createdAt;
@override final  int likesCount;
@override final  int userId;
@override final  String userRole;
@override final  bool isLiked;
@override final  bool isOwner;
@override final  String userName;
@override final  String? userAvatarUrl;

/// Create a copy of GetPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetPostCopyWith<_GetPost> get copyWith => __$GetPostCopyWithImpl<_GetPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId,userRole,isLiked,isOwner,userName,userAvatarUrl);

@override
String toString() {
  return 'GetPost(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, userRole: $userRole, isLiked: $isLiked, isOwner: $isOwner, userName: $userName, userAvatarUrl: $userAvatarUrl)';
}


}

/// @nodoc
abstract mixin class _$GetPostCopyWith<$Res> implements $GetPostCopyWith<$Res> {
  factory _$GetPostCopyWith(_GetPost value, $Res Function(_GetPost) _then) = __$GetPostCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content, String? mimeType, String category, String? filePath, String? fileType, DateTime createdAt, int likesCount, int userId, String userRole, bool isLiked, bool isOwner, String userName, String? userAvatarUrl
});




}
/// @nodoc
class __$GetPostCopyWithImpl<$Res>
    implements _$GetPostCopyWith<$Res> {
  __$GetPostCopyWithImpl(this._self, this._then);

  final _GetPost _self;
  final $Res Function(_GetPost) _then;

/// Create a copy of GetPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? userRole = null,Object? isLiked = null,Object? isOwner = null,Object? userName = null,Object? userAvatarUrl = freezed,}) {
  return _then(_GetPost(
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
as int,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
