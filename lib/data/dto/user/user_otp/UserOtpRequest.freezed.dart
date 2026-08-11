// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserOtpRequest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserOtpRequest {

@JsonKey(name: "email") String get email;@JsonKey(name: "otp") String get otp;
/// Create a copy of UserOtpRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserOtpRequestCopyWith<UserOtpRequest> get copyWith => _$UserOtpRequestCopyWithImpl<UserOtpRequest>(this as UserOtpRequest, _$identity);

  /// Serializes this UserOtpRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserOtpRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.otp, otp) || other.otp == otp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,otp);

@override
String toString() {
  return 'UserOtpRequest(email: $email, otp: $otp)';
}


}

/// @nodoc
abstract mixin class $UserOtpRequestCopyWith<$Res>  {
  factory $UserOtpRequestCopyWith(UserOtpRequest value, $Res Function(UserOtpRequest) _then) = _$UserOtpRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "email") String email,@JsonKey(name: "otp") String otp
});




}
/// @nodoc
class _$UserOtpRequestCopyWithImpl<$Res>
    implements $UserOtpRequestCopyWith<$Res> {
  _$UserOtpRequestCopyWithImpl(this._self, this._then);

  final UserOtpRequest _self;
  final $Res Function(UserOtpRequest) _then;

/// Create a copy of UserOtpRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? otp = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserOtpRequest].
extension UserOtpRequestPatterns on UserOtpRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserOtpRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserOtpRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserOtpRequest value)  $default,){
final _that = this;
switch (_that) {
case _UserOtpRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserOtpRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UserOtpRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "email")  String email, @JsonKey(name: "otp")  String otp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserOtpRequest() when $default != null:
return $default(_that.email,_that.otp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "email")  String email, @JsonKey(name: "otp")  String otp)  $default,) {final _that = this;
switch (_that) {
case _UserOtpRequest():
return $default(_that.email,_that.otp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "email")  String email, @JsonKey(name: "otp")  String otp)?  $default,) {final _that = this;
switch (_that) {
case _UserOtpRequest() when $default != null:
return $default(_that.email,_that.otp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserOtpRequest implements UserOtpRequest {
  const _UserOtpRequest({@JsonKey(name: "email") required this.email, @JsonKey(name: "otp") required this.otp});
  factory _UserOtpRequest.fromJson(Map<String, dynamic> json) => _$UserOtpRequestFromJson(json);

@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "otp") final  String otp;

/// Create a copy of UserOtpRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserOtpRequestCopyWith<_UserOtpRequest> get copyWith => __$UserOtpRequestCopyWithImpl<_UserOtpRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserOtpRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserOtpRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.otp, otp) || other.otp == otp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,otp);

@override
String toString() {
  return 'UserOtpRequest(email: $email, otp: $otp)';
}


}

/// @nodoc
abstract mixin class _$UserOtpRequestCopyWith<$Res> implements $UserOtpRequestCopyWith<$Res> {
  factory _$UserOtpRequestCopyWith(_UserOtpRequest value, $Res Function(_UserOtpRequest) _then) = __$UserOtpRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "email") String email,@JsonKey(name: "otp") String otp
});




}
/// @nodoc
class __$UserOtpRequestCopyWithImpl<$Res>
    implements _$UserOtpRequestCopyWith<$Res> {
  __$UserOtpRequestCopyWithImpl(this._self, this._then);

  final _UserOtpRequest _self;
  final $Res Function(_UserOtpRequest) _then;

/// Create a copy of UserOtpRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? otp = null,}) {
  return _then(_UserOtpRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
