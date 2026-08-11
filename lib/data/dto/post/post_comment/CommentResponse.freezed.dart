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

@JsonKey(name: 'name') String get name;
/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentUserCopyWith<CommentUser> get copyWith => _$CommentUserCopyWithImpl<CommentUser>(this as CommentUser, _$identity);

  /// Serializes this CommentUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentUser&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CommentUser(name: $name)';
}


}

/// @nodoc
abstract mixin class $CommentUserCopyWith<$Res>  {
  factory $CommentUserCopyWith(CommentUser value, $Res Function(CommentUser) _then) = _$CommentUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name
});




}
/// @nodoc
class _$CommentUserCopyWithImpl<$Res>
    implements $CommentUserCopyWith<$Res> {
  _$CommentUserCopyWithImpl(this._self, this._then);

  final CommentUser _self;
  final $Res Function(CommentUser) _then;

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name)  $default,) {final _that = this;
switch (_that) {
case _CommentUser():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name)?  $default,) {final _that = this;
switch (_that) {
case _CommentUser() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentUser implements CommentUser {
  const _CommentUser({@JsonKey(name: 'name') required this.name});
  factory _CommentUser.fromJson(Map<String, dynamic> json) => _$CommentUserFromJson(json);

@override@JsonKey(name: 'name') final  String name;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentUser&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CommentUser(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CommentUserCopyWith<$Res> implements $CommentUserCopyWith<$Res> {
  factory _$CommentUserCopyWith(_CommentUser value, $Res Function(_CommentUser) _then) = __$CommentUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name
});




}
/// @nodoc
class __$CommentUserCopyWithImpl<$Res>
    implements _$CommentUserCopyWith<$Res> {
  __$CommentUserCopyWithImpl(this._self, this._then);

  final _CommentUser _self;
  final $Res Function(_CommentUser) _then;

/// Create a copy of CommentUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CommentUser(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
