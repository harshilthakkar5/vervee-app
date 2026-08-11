// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ForgetPasswordResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForgetPasswordResponse {

@JsonKey(name: "success") bool get success;@JsonKey(name: "message") String get message;
/// Create a copy of ForgetPasswordResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgetPasswordResponseCopyWith<ForgetPasswordResponse> get copyWith => _$ForgetPasswordResponseCopyWithImpl<ForgetPasswordResponse>(this as ForgetPasswordResponse, _$identity);

  /// Serializes this ForgetPasswordResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgetPasswordResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message);

@override
String toString() {
  return 'ForgetPasswordResponse(success: $success, message: $message)';
}


}

/// @nodoc
abstract mixin class $ForgetPasswordResponseCopyWith<$Res>  {
  factory $ForgetPasswordResponseCopyWith(ForgetPasswordResponse value, $Res Function(ForgetPasswordResponse) _then) = _$ForgetPasswordResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "message") String message
});




}
/// @nodoc
class _$ForgetPasswordResponseCopyWithImpl<$Res>
    implements $ForgetPasswordResponseCopyWith<$Res> {
  _$ForgetPasswordResponseCopyWithImpl(this._self, this._then);

  final ForgetPasswordResponse _self;
  final $Res Function(ForgetPasswordResponse) _then;

/// Create a copy of ForgetPasswordResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ForgetPasswordResponse].
extension ForgetPasswordResponsePatterns on ForgetPasswordResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForgetPasswordResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForgetPasswordResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForgetPasswordResponse value)  $default,){
final _that = this;
switch (_that) {
case _ForgetPasswordResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForgetPasswordResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ForgetPasswordResponse() when $default != null:
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
case _ForgetPasswordResponse() when $default != null:
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
case _ForgetPasswordResponse():
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
case _ForgetPasswordResponse() when $default != null:
return $default(_that.success,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForgetPasswordResponse extends ForgetPasswordResponse {
  const _ForgetPasswordResponse({@JsonKey(name: "success") required this.success, @JsonKey(name: "message") required this.message}): super._();
  factory _ForgetPasswordResponse.fromJson(Map<String, dynamic> json) => _$ForgetPasswordResponseFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "message") final  String message;

/// Create a copy of ForgetPasswordResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgetPasswordResponseCopyWith<_ForgetPasswordResponse> get copyWith => __$ForgetPasswordResponseCopyWithImpl<_ForgetPasswordResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForgetPasswordResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgetPasswordResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message);

@override
String toString() {
  return 'ForgetPasswordResponse(success: $success, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ForgetPasswordResponseCopyWith<$Res> implements $ForgetPasswordResponseCopyWith<$Res> {
  factory _$ForgetPasswordResponseCopyWith(_ForgetPasswordResponse value, $Res Function(_ForgetPasswordResponse) _then) = __$ForgetPasswordResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "message") String message
});




}
/// @nodoc
class __$ForgetPasswordResponseCopyWithImpl<$Res>
    implements _$ForgetPasswordResponseCopyWith<$Res> {
  __$ForgetPasswordResponseCopyWithImpl(this._self, this._then);

  final _ForgetPasswordResponse _self;
  final $Res Function(_ForgetPasswordResponse) _then;

/// Create a copy of ForgetPasswordResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,}) {
  return _then(_ForgetPasswordResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
