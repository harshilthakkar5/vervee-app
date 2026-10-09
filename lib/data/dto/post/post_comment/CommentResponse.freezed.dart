// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CommentResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentResponse {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'content') String get content;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'user') CommentUser get user;
/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentResponseCopyWith<CommentResponse> get copyWith => _$CommentResponseCopyWithImpl<CommentResponse>(this as CommentResponse, _$identity);

  /// Serializes this CommentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,user);

@override
String toString() {
  return 'CommentResponse(id: $id, content: $content, createdAt: $createdAt, user: $user)';
}


}

/// @nodoc
abstract mixin class $CommentResponseCopyWith<$Res>  {
  factory $CommentResponseCopyWith(CommentResponse value, $Res Function(CommentResponse) _then) = _$CommentResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'content') String content,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'user') CommentUser user
});


$CommentUserCopyWith<$Res> get user;

}
/// @nodoc
class _$CommentResponseCopyWithImpl<$Res>
    implements $CommentResponseCopyWith<$Res> {
  _$CommentResponseCopyWithImpl(this._self, this._then);

  final CommentResponse _self;
  final $Res Function(CommentResponse) _then;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? user = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as CommentUser,
  ));
}
/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentUserCopyWith<$Res> get user {
  
  return $CommentUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentResponse].
extension CommentResponsePatterns on CommentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentResponse value)  $default,){
final _that = this;
switch (_that) {
case _CommentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'content')  String content, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'user')  CommentUser user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'content')  String content, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'user')  CommentUser user)  $default,) {final _that = this;
switch (_that) {
case _CommentResponse():
return $default(_that.id,_that.content,_that.createdAt,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'content')  String content, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'user')  CommentUser user)?  $default,) {final _that = this;
switch (_that) {
case _CommentResponse() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentResponse extends CommentResponse {
  const _CommentResponse({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'content') required this.content, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'user') required this.user}): super._();
  factory _CommentResponse.fromJson(Map<String, dynamic> json) => _$CommentResponseFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'content') final  String content;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'user') final  CommentUser user;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentResponseCopyWith<_CommentResponse> get copyWith => __$CommentResponseCopyWithImpl<_CommentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,user);

@override
String toString() {
  return 'CommentResponse(id: $id, content: $content, createdAt: $createdAt, user: $user)';
}


}

/// @nodoc
abstract mixin class _$CommentResponseCopyWith<$Res> implements $CommentResponseCopyWith<$Res> {
  factory _$CommentResponseCopyWith(_CommentResponse value, $Res Function(_CommentResponse) _then) = __$CommentResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'content') String content,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'user') CommentUser user
});


@override $CommentUserCopyWith<$Res> get user;

}
/// @nodoc
class __$CommentResponseCopyWithImpl<$Res>
    implements _$CommentResponseCopyWith<$Res> {
  __$CommentResponseCopyWithImpl(this._self, this._then);

  final _CommentResponse _self;
  final $Res Function(_CommentResponse) _then;

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? user = null,}) {
  return _then(_CommentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as CommentUser,
  ));
}

/// Create a copy of CommentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentUserCopyWith<$Res> get user {
  
  return $CommentUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$CommentUser {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'avatar') CommentAvatar? get avatar;
/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentUserCopyWith<CommentUser> get copyWith => _$CommentUserCopyWithImpl<CommentUser>(this as CommentUser, _$identity);

  /// Serializes this CommentUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentUser&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatar);

@override
String toString() {
  return 'CommentUser(name: $name, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $CommentUserCopyWith<$Res>  {
  factory $CommentUserCopyWith(CommentUser value, $Res Function(CommentUser) _then) = _$CommentUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'avatar') CommentAvatar? avatar
});


$CommentAvatarCopyWith<$Res>? get avatar;

}
/// @nodoc
class _$CommentUserCopyWithImpl<$Res>
    implements $CommentUserCopyWith<$Res> {
  _$CommentUserCopyWithImpl(this._self, this._then);

  final CommentUser _self;
  final $Res Function(CommentUser) _then;

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as CommentAvatar?,
  ));
}
/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentAvatarCopyWith<$Res>? get avatar {
    if (_self.avatar == null) {
    return null;
  }

  return $CommentAvatarCopyWith<$Res>(_self.avatar!, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentUser].
extension CommentUserPatterns on CommentUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentUser value)  $default,){
final _that = this;
switch (_that) {
case _CommentUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentUser value)?  $default,){
final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'avatar')  CommentAvatar? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
return $default(_that.name,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'avatar')  CommentAvatar? avatar)  $default,) {final _that = this;
switch (_that) {
case _CommentUser():
return $default(_that.name,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'avatar')  CommentAvatar? avatar)?  $default,) {final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
return $default(_that.name,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentUser implements CommentUser {
  const _CommentUser({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'avatar') this.avatar});
  factory _CommentUser.fromJson(Map<String, dynamic> json) => _$CommentUserFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'avatar') final  CommentAvatar? avatar;

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentUserCopyWith<_CommentUser> get copyWith => __$CommentUserCopyWithImpl<_CommentUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentUser&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatar);

@override
String toString() {
  return 'CommentUser(name: $name, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$CommentUserCopyWith<$Res> implements $CommentUserCopyWith<$Res> {
  factory _$CommentUserCopyWith(_CommentUser value, $Res Function(_CommentUser) _then) = __$CommentUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'avatar') CommentAvatar? avatar
});


@override $CommentAvatarCopyWith<$Res>? get avatar;

}
/// @nodoc
class __$CommentUserCopyWithImpl<$Res>
    implements _$CommentUserCopyWith<$Res> {
  __$CommentUserCopyWithImpl(this._self, this._then);

  final _CommentUser _self;
  final $Res Function(_CommentUser) _then;

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatar = freezed,}) {
  return _then(_CommentUser(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as CommentAvatar?,
  ));
}

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentAvatarCopyWith<$Res>? get avatar {
    if (_self.avatar == null) {
    return null;
  }

  return $CommentAvatarCopyWith<$Res>(_self.avatar!, (value) {
    return _then(_self.copyWith(avatar: value));
  });
}
}


/// @nodoc
mixin _$CommentAvatar {

@JsonKey(name: 'mascotUrl') String? get mascotUrl;
/// Create a copy of CommentAvatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentAvatarCopyWith<CommentAvatar> get copyWith => _$CommentAvatarCopyWithImpl<CommentAvatar>(this as CommentAvatar, _$identity);

  /// Serializes this CommentAvatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentAvatar&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mascotUrl);

@override
String toString() {
  return 'CommentAvatar(mascotUrl: $mascotUrl)';
}


}

/// @nodoc
abstract mixin class $CommentAvatarCopyWith<$Res>  {
  factory $CommentAvatarCopyWith(CommentAvatar value, $Res Function(CommentAvatar) _then) = _$CommentAvatarCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mascotUrl') String? mascotUrl
});




}
/// @nodoc
class _$CommentAvatarCopyWithImpl<$Res>
    implements $CommentAvatarCopyWith<$Res> {
  _$CommentAvatarCopyWithImpl(this._self, this._then);

  final CommentAvatar _self;
  final $Res Function(CommentAvatar) _then;

/// Create a copy of CommentAvatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mascotUrl = freezed,}) {
  return _then(_self.copyWith(
mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentAvatar].
extension CommentAvatarPatterns on CommentAvatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentAvatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentAvatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentAvatar value)  $default,){
final _that = this;
switch (_that) {
case _CommentAvatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentAvatar value)?  $default,){
final _that = this;
switch (_that) {
case _CommentAvatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'mascotUrl')  String? mascotUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentAvatar() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'mascotUrl')  String? mascotUrl)  $default,) {final _that = this;
switch (_that) {
case _CommentAvatar():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'mascotUrl')  String? mascotUrl)?  $default,) {final _that = this;
switch (_that) {
case _CommentAvatar() when $default != null:
return $default(_that.mascotUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentAvatar implements CommentAvatar {
  const _CommentAvatar({@JsonKey(name: 'mascotUrl') this.mascotUrl});
  factory _CommentAvatar.fromJson(Map<String, dynamic> json) => _$CommentAvatarFromJson(json);

@override@JsonKey(name: 'mascotUrl') final  String? mascotUrl;

/// Create a copy of CommentAvatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentAvatarCopyWith<_CommentAvatar> get copyWith => __$CommentAvatarCopyWithImpl<_CommentAvatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentAvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentAvatar&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mascotUrl);

@override
String toString() {
  return 'CommentAvatar(mascotUrl: $mascotUrl)';
}


}

/// @nodoc
abstract mixin class _$CommentAvatarCopyWith<$Res> implements $CommentAvatarCopyWith<$Res> {
  factory _$CommentAvatarCopyWith(_CommentAvatar value, $Res Function(_CommentAvatar) _then) = __$CommentAvatarCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mascotUrl') String? mascotUrl
});




}
/// @nodoc
class __$CommentAvatarCopyWithImpl<$Res>
    implements _$CommentAvatarCopyWith<$Res> {
  __$CommentAvatarCopyWithImpl(this._self, this._then);

  final _CommentAvatar _self;
  final $Res Function(_CommentAvatar) _then;

/// Create a copy of CommentAvatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mascotUrl = freezed,}) {
  return _then(_CommentAvatar(
mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
