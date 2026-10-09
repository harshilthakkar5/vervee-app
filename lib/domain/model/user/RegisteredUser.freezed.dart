// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'RegisteredUser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisteredUser {

 String get message;// "Registration successful!" dikhayenge UI me
 bool get isUnder18;
/// Create a copy of RegisteredUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisteredUserCopyWith<RegisteredUser> get copyWith => _$RegisteredUserCopyWithImpl<RegisteredUser>(this as RegisteredUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisteredUser&&(identical(other.message, message) || other.message == message)&&(identical(other.isUnder18, isUnder18) || other.isUnder18 == isUnder18));
}


@override
int get hashCode => Object.hash(runtimeType,message,isUnder18);

@override
String toString() {
  return 'RegisteredUser(message: $message, isUnder18: $isUnder18)';
}


}

/// @nodoc
abstract mixin class $RegisteredUserCopyWith<$Res>  {
  factory $RegisteredUserCopyWith(RegisteredUser value, $Res Function(RegisteredUser) _then) = _$RegisteredUserCopyWithImpl;
@useResult
$Res call({
 String message, bool isUnder18
});




}
/// @nodoc
class _$RegisteredUserCopyWithImpl<$Res>
    implements $RegisteredUserCopyWith<$Res> {
  _$RegisteredUserCopyWithImpl(this._self, this._then);

  final RegisteredUser _self;
  final $Res Function(RegisteredUser) _then;

/// Create a copy of RegisteredUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isUnder18 = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isUnder18: null == isUnder18 ? _self.isUnder18 : isUnder18 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisteredUser].
extension RegisteredUserPatterns on RegisteredUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisteredUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisteredUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisteredUser value)  $default,){
final _that = this;
switch (_that) {
case _RegisteredUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisteredUser value)?  $default,){
final _that = this;
switch (_that) {
case _RegisteredUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  bool isUnder18)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisteredUser() when $default != null:
return $default(_that.message,_that.isUnder18);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  bool isUnder18)  $default,) {final _that = this;
switch (_that) {
case _RegisteredUser():
return $default(_that.message,_that.isUnder18);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  bool isUnder18)?  $default,) {final _that = this;
switch (_that) {
case _RegisteredUser() when $default != null:
return $default(_that.message,_that.isUnder18);case _:
  return null;

}
}

}

/// @nodoc


class _RegisteredUser implements RegisteredUser {
  const _RegisteredUser({required this.message, this.isUnder18 = false});
  

@override final  String message;
// "Registration successful!" dikhayenge UI me
@override@JsonKey() final  bool isUnder18;

/// Create a copy of RegisteredUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisteredUserCopyWith<_RegisteredUser> get copyWith => __$RegisteredUserCopyWithImpl<_RegisteredUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisteredUser&&(identical(other.message, message) || other.message == message)&&(identical(other.isUnder18, isUnder18) || other.isUnder18 == isUnder18));
}


@override
int get hashCode => Object.hash(runtimeType,message,isUnder18);

@override
String toString() {
  return 'RegisteredUser(message: $message, isUnder18: $isUnder18)';
}


}

/// @nodoc
abstract mixin class _$RegisteredUserCopyWith<$Res> implements $RegisteredUserCopyWith<$Res> {
  factory _$RegisteredUserCopyWith(_RegisteredUser value, $Res Function(_RegisteredUser) _then) = __$RegisteredUserCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isUnder18
});




}
/// @nodoc
class __$RegisteredUserCopyWithImpl<$Res>
    implements _$RegisteredUserCopyWith<$Res> {
  __$RegisteredUserCopyWithImpl(this._self, this._then);

  final _RegisteredUser _self;
  final $Res Function(_RegisteredUser) _then;

/// Create a copy of RegisteredUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isUnder18 = null,}) {
  return _then(_RegisteredUser(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isUnder18: null == isUnder18 ? _self.isUnder18 : isUnder18 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
