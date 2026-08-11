// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserLoginResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLoginResponse {

@JsonKey(name: "success") bool get success;@JsonKey(name: "access_token") String get accessToken;@JsonKey(name: "user") User get user;
/// Create a copy of UserLoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLoginResponseCopyWith<UserLoginResponse> get copyWith => _$UserLoginResponseCopyWithImpl<UserLoginResponse>(this as UserLoginResponse, _$identity);

  /// Serializes this UserLoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLoginResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,accessToken,user);

@override
String toString() {
  return 'UserLoginResponse(success: $success, accessToken: $accessToken, user: $user)';
}


}

/// @nodoc
abstract mixin class $UserLoginResponseCopyWith<$Res>  {
  factory $UserLoginResponseCopyWith(UserLoginResponse value, $Res Function(UserLoginResponse) _then) = _$UserLoginResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "user") User user
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$UserLoginResponseCopyWithImpl<$Res>
    implements $UserLoginResponseCopyWith<$Res> {
  _$UserLoginResponseCopyWithImpl(this._self, this._then);

  final UserLoginResponse _self;
  final $Res Function(UserLoginResponse) _then;

/// Create a copy of UserLoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? accessToken = null,Object? user = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}
/// Create a copy of UserLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserLoginResponse].
extension UserLoginResponsePatterns on UserLoginResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLoginResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserLoginResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserLoginResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "user")  User user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLoginResponse() when $default != null:
return $default(_that.success,_that.accessToken,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "user")  User user)  $default,) {final _that = this;
switch (_that) {
case _UserLoginResponse():
return $default(_that.success,_that.accessToken,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "access_token")  String accessToken, @JsonKey(name: "user")  User user)?  $default,) {final _that = this;
switch (_that) {
case _UserLoginResponse() when $default != null:
return $default(_that.success,_that.accessToken,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLoginResponse extends UserLoginResponse {
  const _UserLoginResponse({@JsonKey(name: "success") required this.success, @JsonKey(name: "access_token") required this.accessToken, @JsonKey(name: "user") required this.user}): super._();
  factory _UserLoginResponse.fromJson(Map<String, dynamic> json) => _$UserLoginResponseFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "access_token") final  String accessToken;
@override@JsonKey(name: "user") final  User user;

/// Create a copy of UserLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLoginResponseCopyWith<_UserLoginResponse> get copyWith => __$UserLoginResponseCopyWithImpl<_UserLoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLoginResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,accessToken,user);

@override
String toString() {
  return 'UserLoginResponse(success: $success, accessToken: $accessToken, user: $user)';
}


}

/// @nodoc
abstract mixin class _$UserLoginResponseCopyWith<$Res> implements $UserLoginResponseCopyWith<$Res> {
  factory _$UserLoginResponseCopyWith(_UserLoginResponse value, $Res Function(_UserLoginResponse) _then) = __$UserLoginResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "access_token") String accessToken,@JsonKey(name: "user") User user
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$UserLoginResponseCopyWithImpl<$Res>
    implements _$UserLoginResponseCopyWith<$Res> {
  __$UserLoginResponseCopyWithImpl(this._self, this._then);

  final _UserLoginResponse _self;
  final $Res Function(_UserLoginResponse) _then;

/// Create a copy of UserLoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? accessToken = null,Object? user = null,}) {
  return _then(_UserLoginResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of UserLoginResponse
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

@JsonKey(name: "id") int get id;@JsonKey(name: "name") String get name;@JsonKey(name: "email") String get email;@JsonKey(name: "role") String get role;@JsonKey(name: "hasSeenTour") bool get hasSeenTour;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.hasSeenTour, hasSeenTour) || other.hasSeenTour == hasSeenTour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,hasSeenTour);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, role: $role, hasSeenTour: $hasSeenTour)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "role") String role,@JsonKey(name: "hasSeenTour") bool hasSeenTour
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? hasSeenTour = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,hasSeenTour: null == hasSeenTour ? _self.hasSeenTour : hasSeenTour // ignore: cast_nullable_to_non_nullable
as bool,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "role")  String role, @JsonKey(name: "hasSeenTour")  bool hasSeenTour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.hasSeenTour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "role")  String role, @JsonKey(name: "hasSeenTour")  bool hasSeenTour)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.role,_that.hasSeenTour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int id, @JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "role")  String role, @JsonKey(name: "hasSeenTour")  bool hasSeenTour)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.hasSeenTour);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "email") required this.email, @JsonKey(name: "role") required this.role, @JsonKey(name: "hasSeenTour") required this.hasSeenTour});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: "id") final  int id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "role") final  String role;
@override@JsonKey(name: "hasSeenTour") final  bool hasSeenTour;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.hasSeenTour, hasSeenTour) || other.hasSeenTour == hasSeenTour));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,role,hasSeenTour);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, role: $role, hasSeenTour: $hasSeenTour)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int id,@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "role") String role,@JsonKey(name: "hasSeenTour") bool hasSeenTour
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? hasSeenTour = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,hasSeenTour: null == hasSeenTour ? _self.hasSeenTour : hasSeenTour // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
