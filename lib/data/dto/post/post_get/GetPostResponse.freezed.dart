// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'GetPostResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetPostResponse {

@JsonKey(name: "id") int get id;@JsonKey(name: "title") String get title;@JsonKey(name: "content") String get content;@JsonKey(name: "mimeType") String? get mimeType;@JsonKey(name: "category") String get category;@JsonKey(name: "filePath") String? get filePath;@JsonKey(name: "fileType") String? get fileType;@JsonKey(name: "createdAt") DateTime get createdAt;@JsonKey(name: "likesCount") int get likesCount;@JsonKey(name: "userId") int get userId;@JsonKey(name: "user") User get user;@JsonKey(name: "isLiked") bool get isLiked;@JsonKey(name: "isOwner") bool get isOwner;@JsonKey(name: "userName") String get userName;
/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPostResponseCopyWith<GetPostResponse> get copyWith => _$GetPostResponseCopyWithImpl<GetPostResponse>(this as GetPostResponse, _$identity);

  /// Serializes this GetPostResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPostResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId,user,isLiked,isOwner,userName);

@override
String toString() {
  return 'GetPostResponse(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, user: $user, isLiked: $isLiked, isOwner: $isOwner, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $GetPostResponseCopyWith<$Res>  {
  factory $GetPostResponseCopyWith(GetPostResponse value, $Res Function(GetPostResponse) _then) = _$GetPostResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "content") String content,@JsonKey(name: "mimeType") String? mimeType,@JsonKey(name: "category") String category,@JsonKey(name: "filePath") String? filePath,@JsonKey(name: "fileType") String? fileType,@JsonKey(name: "createdAt") DateTime createdAt,@JsonKey(name: "likesCount") int likesCount,@JsonKey(name: "userId") int userId,@JsonKey(name: "user") User user,@JsonKey(name: "isLiked") bool isLiked,@JsonKey(name: "isOwner") bool isOwner,@JsonKey(name: "userName") String userName
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$GetPostResponseCopyWithImpl<$Res>
    implements $GetPostResponseCopyWith<$Res> {
  _$GetPostResponseCopyWithImpl(this._self, this._then);

  final GetPostResponse _self;
  final $Res Function(GetPostResponse) _then;

/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? user = null,Object? isLiked = null,Object? isOwner = null,Object? userName = null,}) {
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
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetPostResponse].
extension GetPostResponsePatterns on GetPostResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetPostResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetPostResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetPostResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetPostResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetPostResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetPostResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId, @JsonKey(name: "user")  User user, @JsonKey(name: "isLiked")  bool isLiked, @JsonKey(name: "isOwner")  bool isOwner, @JsonKey(name: "userName")  String userName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetPostResponse() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.user,_that.isLiked,_that.isOwner,_that.userName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId, @JsonKey(name: "user")  User user, @JsonKey(name: "isLiked")  bool isLiked, @JsonKey(name: "isOwner")  bool isOwner, @JsonKey(name: "userName")  String userName)  $default,) {final _that = this;
switch (_that) {
case _GetPostResponse():
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.user,_that.isLiked,_that.isOwner,_that.userName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "title")  String title, @JsonKey(name: "content")  String content, @JsonKey(name: "mimeType")  String? mimeType, @JsonKey(name: "category")  String category, @JsonKey(name: "filePath")  String? filePath, @JsonKey(name: "fileType")  String? fileType, @JsonKey(name: "createdAt")  DateTime createdAt, @JsonKey(name: "likesCount")  int likesCount, @JsonKey(name: "userId")  int userId, @JsonKey(name: "user")  User user, @JsonKey(name: "isLiked")  bool isLiked, @JsonKey(name: "isOwner")  bool isOwner, @JsonKey(name: "userName")  String userName)?  $default,) {final _that = this;
switch (_that) {
case _GetPostResponse() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mimeType,_that.category,_that.filePath,_that.fileType,_that.createdAt,_that.likesCount,_that.userId,_that.user,_that.isLiked,_that.isOwner,_that.userName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetPostResponse extends GetPostResponse {
  const _GetPostResponse({@JsonKey(name: "id") required this.id, @JsonKey(name: "title") required this.title, @JsonKey(name: "content") required this.content, @JsonKey(name: "mimeType") this.mimeType, @JsonKey(name: "category") required this.category, @JsonKey(name: "filePath") this.filePath, @JsonKey(name: "fileType") this.fileType, @JsonKey(name: "createdAt") required this.createdAt, @JsonKey(name: "likesCount") required this.likesCount, @JsonKey(name: "userId") required this.userId, @JsonKey(name: "user") required this.user, @JsonKey(name: "isLiked") required this.isLiked, @JsonKey(name: "isOwner") required this.isOwner, @JsonKey(name: "userName") required this.userName}): super._();
  factory _GetPostResponse.fromJson(Map<String, dynamic> json) => _$GetPostResponseFromJson(json);

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
@override@JsonKey(name: "user") final  User user;
@override@JsonKey(name: "isLiked") final  bool isLiked;
@override@JsonKey(name: "isOwner") final  bool isOwner;
@override@JsonKey(name: "userName") final  String userName;

/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetPostResponseCopyWith<_GetPostResponse> get copyWith => __$GetPostResponseCopyWithImpl<_GetPostResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetPostResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetPostResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.category, category) || other.category == category)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.user, user) || other.user == user)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,mimeType,category,filePath,fileType,createdAt,likesCount,userId,user,isLiked,isOwner,userName);

@override
String toString() {
  return 'GetPostResponse(id: $id, title: $title, content: $content, mimeType: $mimeType, category: $category, filePath: $filePath, fileType: $fileType, createdAt: $createdAt, likesCount: $likesCount, userId: $userId, user: $user, isLiked: $isLiked, isOwner: $isOwner, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$GetPostResponseCopyWith<$Res> implements $GetPostResponseCopyWith<$Res> {
  factory _$GetPostResponseCopyWith(_GetPostResponse value, $Res Function(_GetPostResponse) _then) = __$GetPostResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "title") String title,@JsonKey(name: "content") String content,@JsonKey(name: "mimeType") String? mimeType,@JsonKey(name: "category") String category,@JsonKey(name: "filePath") String? filePath,@JsonKey(name: "fileType") String? fileType,@JsonKey(name: "createdAt") DateTime createdAt,@JsonKey(name: "likesCount") int likesCount,@JsonKey(name: "userId") int userId,@JsonKey(name: "user") User user,@JsonKey(name: "isLiked") bool isLiked,@JsonKey(name: "isOwner") bool isOwner,@JsonKey(name: "userName") String userName
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$GetPostResponseCopyWithImpl<$Res>
    implements _$GetPostResponseCopyWith<$Res> {
  __$GetPostResponseCopyWithImpl(this._self, this._then);

  final _GetPostResponse _self;
  final $Res Function(_GetPostResponse) _then;

/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? mimeType = freezed,Object? category = null,Object? filePath = freezed,Object? fileType = freezed,Object? createdAt = null,Object? likesCount = null,Object? userId = null,Object? user = null,Object? isLiked = null,Object? isOwner = null,Object? userName = null,}) {
  return _then(_GetPostResponse(
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
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of GetPostResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$User {

@JsonKey(name: "name") String get name;@JsonKey(name: "role") String get role;@JsonKey(name: "avatar") Avatar? get avatar;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,role,avatar);

@override
String toString() {
  return 'User(name: $name, role: $role, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "role") String role,@JsonKey(name: "avatar") Avatar? avatar
});


$AvatarCopyWith<$Res>? get avatar;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? role = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as Avatar?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarCopyWith<$Res>? get avatar {
    if (_self.avatar == null) {
    return null;
  }

  return $AvatarCopyWith<$Res>(_self.avatar!, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "name")  String name, @JsonKey(name: "role")  String role, @JsonKey(name: "avatar")  Avatar? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.name,_that.role,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "name")  String name, @JsonKey(name: "role")  String role, @JsonKey(name: "avatar")  Avatar? avatar)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.name,_that.role,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "name")  String name, @JsonKey(name: "role")  String role, @JsonKey(name: "avatar")  Avatar? avatar)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.name,_that.role,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(name: "name") required this.name, @JsonKey(name: "role") required this.role, @JsonKey(name: "avatar") this.avatar});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "role") final  String role;
@override@JsonKey(name: "avatar") final  Avatar? avatar;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,role,avatar);

@override
String toString() {
  return 'User(name: $name, role: $role, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "role") String role,@JsonKey(name: "avatar") Avatar? avatar
});


@override $AvatarCopyWith<$Res>? get avatar;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? role = null,Object? avatar = freezed,}) {
  return _then(_User(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as Avatar?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarCopyWith<$Res>? get avatar {
    if (_self.avatar == null) {
    return null;
  }

  return $AvatarCopyWith<$Res>(_self.avatar!, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}
}


/// @nodoc
mixin _$Avatar {

@JsonKey(name: "mascotUrl") String? get mascotUrl;
/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarCopyWith<Avatar> get copyWith => _$AvatarCopyWithImpl<Avatar>(this as Avatar, _$identity);

  /// Serializes this Avatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Avatar&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mascotUrl);

@override
String toString() {
  return 'Avatar(mascotUrl: $mascotUrl)';
}


}

/// @nodoc
abstract mixin class $AvatarCopyWith<$Res>  {
  factory $AvatarCopyWith(Avatar value, $Res Function(Avatar) _then) = _$AvatarCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "mascotUrl") String? mascotUrl
});




}
/// @nodoc
class _$AvatarCopyWithImpl<$Res>
    implements $AvatarCopyWith<$Res> {
  _$AvatarCopyWithImpl(this._self, this._then);

  final Avatar _self;
  final $Res Function(Avatar) _then;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mascotUrl = freezed,}) {
  return _then(_self.copyWith(
mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Avatar].
extension AvatarPatterns on Avatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Avatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Avatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Avatar value)  $default,){
final _that = this;
switch (_that) {
case _Avatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Avatar value)?  $default,){
final _that = this;
switch (_that) {
case _Avatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "mascotUrl")  String? mascotUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Avatar() when $default != null:
return $default(_that.mascotUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "mascotUrl")  String? mascotUrl)  $default,) {final _that = this;
switch (_that) {
case _Avatar():
return $default(_that.mascotUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "mascotUrl")  String? mascotUrl)?  $default,) {final _that = this;
switch (_that) {
case _Avatar() when $default != null:
return $default(_that.mascotUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Avatar implements Avatar {
  const _Avatar({@JsonKey(name: "mascotUrl") this.mascotUrl});
  factory _Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

@override@JsonKey(name: "mascotUrl") final  String? mascotUrl;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarCopyWith<_Avatar> get copyWith => __$AvatarCopyWithImpl<_Avatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Avatar&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mascotUrl);

@override
String toString() {
  return 'Avatar(mascotUrl: $mascotUrl)';
}


}

/// @nodoc
abstract mixin class _$AvatarCopyWith<$Res> implements $AvatarCopyWith<$Res> {
  factory _$AvatarCopyWith(_Avatar value, $Res Function(_Avatar) _then) = __$AvatarCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "mascotUrl") String? mascotUrl
});




}
/// @nodoc
class __$AvatarCopyWithImpl<$Res>
    implements _$AvatarCopyWith<$Res> {
  __$AvatarCopyWithImpl(this._self, this._then);

  final _Avatar _self;
  final $Res Function(_Avatar) _then;

/// Create a copy of Avatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mascotUrl = freezed,}) {
  return _then(_Avatar(
mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
