// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserOtpResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserOtpResponse {

@JsonKey(name: "success") bool get success;@JsonKey(name: "message") String get message;
/// Create a copy of UserOtpResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserOtpResponseCopyWith<UserOtpResponse> get copyWith => _$UserOtpResponseCopyWithImpl<UserOtpResponse>(this as UserOtpResponse, _$identity);

  /// Serializes this UserOtpResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message);

@override
String toString() {
  return 'UserOtpResponse(success: $success, message: $message)';
}


}

/// @nodoc
abstract mixin class $UserOtpResponseCopyWith<$Res>  {
  factory $UserOtpResponseCopyWith(UserOtpResponse value, $Res Function(UserOtpResponse) _then) = _$UserOtpResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "message") String message
});




}
/// @nodoc
class _$UserOtpResponseCopyWithImpl<$Res>
    implements $UserOtpResponseCopyWith<$Res> {
  _$UserOtpResponseCopyWithImpl(this._self, this._then);

  final UserOtpResponse _self;
  final $Res Function(UserOtpResponse) _then;

/// Create a copy of UserOtpResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserOtpResponse].
extension UserOtpResponsePatterns on UserOtpResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserOtpResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserOtpResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserOtpResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserOtpResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserOtpResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserOtpResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "message")  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserOtpResponse() when $default != null:
return $default(_that.success,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "message")  String message)  $default,) {final _that = this;
switch (_that) {
case _UserOtpResponse():
return $default(_that.success,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "message")  String message)?  $default,) {final _that = this;
switch (_that) {
case _UserOtpResponse() when $default != null:
return $default(_that.success,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserOtpResponse extends UserOtpResponse {
  const _UserOtpResponse({@JsonKey(name: "success") required this.success, @JsonKey(name: "message") required this.message}): super._();
  factory _UserOtpResponse.fromJson(Map<String, dynamic> json) => _$UserOtpResponseFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "message") final  String message;

/// Create a copy of UserOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserOtpResponseCopyWith<_UserOtpResponse> get copyWith => __$UserOtpResponseCopyWithImpl<_UserOtpResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserOtpResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message);

@override
String toString() {
  return 'UserOtpResponse(success: $success, message: $message)';
}


}

/// @nodoc
abstract mixin class _$UserOtpResponseCopyWith<$Res> implements $UserOtpResponseCopyWith<$Res> {
  factory _$UserOtpResponseCopyWith(_UserOtpResponse value, $Res Function(_UserOtpResponse) _then) = __$UserOtpResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "message") String message
});




}
/// @nodoc
class __$UserOtpResponseCopyWithImpl<$Res>
    implements _$UserOtpResponseCopyWith<$Res> {
  __$UserOtpResponseCopyWithImpl(this._self, this._then);

  final _UserOtpResponse _self;
  final $Res Function(_UserOtpResponse) _then;

/// Create a copy of UserOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,}) {
  return _then(_UserOtpResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
