// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserRegistrationResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRegistrationResponse {

@JsonKey(name: "success") bool get success;@JsonKey(name: "isUnder18") bool get isUnder18;@JsonKey(name: "message") String get message;
/// Create a copy of UserRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRegistrationResponseCopyWith<UserRegistrationResponse> get copyWith => _$UserRegistrationResponseCopyWithImpl<UserRegistrationResponse>(this as UserRegistrationResponse, _$identity);

  /// Serializes this UserRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRegistrationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.isUnder18, isUnder18) || other.isUnder18 == isUnder18)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,isUnder18,message);

@override
String toString() {
  return 'UserRegistrationResponse(success: $success, isUnder18: $isUnder18, message: $message)';
}


}

/// @nodoc
abstract mixin class $UserRegistrationResponseCopyWith<$Res>  {
  factory $UserRegistrationResponseCopyWith(UserRegistrationResponse value, $Res Function(UserRegistrationResponse) _then) = _$UserRegistrationResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "isUnder18") bool isUnder18,@JsonKey(name: "message") String message
});




}
/// @nodoc
class _$UserRegistrationResponseCopyWithImpl<$Res>
    implements $UserRegistrationResponseCopyWith<$Res> {
  _$UserRegistrationResponseCopyWithImpl(this._self, this._then);

  final UserRegistrationResponse _self;
  final $Res Function(UserRegistrationResponse) _then;

/// Create a copy of UserRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? isUnder18 = null,Object? message = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,isUnder18: null == isUnder18 ? _self.isUnder18 : isUnder18 // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRegistrationResponse].
extension UserRegistrationResponsePatterns on UserRegistrationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRegistrationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRegistrationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRegistrationResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRegistrationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "isUnder18")  bool isUnder18, @JsonKey(name: "message")  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRegistrationResponse() when $default != null:
return $default(_that.success,_that.isUnder18,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "isUnder18")  bool isUnder18, @JsonKey(name: "message")  String message)  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationResponse():
return $default(_that.success,_that.isUnder18,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "success")  bool success, @JsonKey(name: "isUnder18")  bool isUnder18, @JsonKey(name: "message")  String message)?  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationResponse() when $default != null:
return $default(_that.success,_that.isUnder18,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRegistrationResponse extends UserRegistrationResponse {
  const _UserRegistrationResponse({@JsonKey(name: "success") required this.success, @JsonKey(name: "isUnder18") this.isUnder18 = false, @JsonKey(name: "message") required this.message}): super._();
  factory _UserRegistrationResponse.fromJson(Map<String, dynamic> json) => _$UserRegistrationResponseFromJson(json);

@override@JsonKey(name: "success") final  bool success;
@override@JsonKey(name: "isUnder18") final  bool isUnder18;
@override@JsonKey(name: "message") final  String message;

/// Create a copy of UserRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRegistrationResponseCopyWith<_UserRegistrationResponse> get copyWith => __$UserRegistrationResponseCopyWithImpl<_UserRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRegistrationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRegistrationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.isUnder18, isUnder18) || other.isUnder18 == isUnder18)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,isUnder18,message);

@override
String toString() {
  return 'UserRegistrationResponse(success: $success, isUnder18: $isUnder18, message: $message)';
}


}

/// @nodoc
abstract mixin class _$UserRegistrationResponseCopyWith<$Res> implements $UserRegistrationResponseCopyWith<$Res> {
  factory _$UserRegistrationResponseCopyWith(_UserRegistrationResponse value, $Res Function(_UserRegistrationResponse) _then) = __$UserRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "success") bool success,@JsonKey(name: "isUnder18") bool isUnder18,@JsonKey(name: "message") String message
});




}
/// @nodoc
class __$UserRegistrationResponseCopyWithImpl<$Res>
    implements _$UserRegistrationResponseCopyWith<$Res> {
  __$UserRegistrationResponseCopyWithImpl(this._self, this._then);

  final _UserRegistrationResponse _self;
  final $Res Function(_UserRegistrationResponse) _then;

/// Create a copy of UserRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? isUnder18 = null,Object? message = null,}) {
  return _then(_UserRegistrationResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,isUnder18: null == isUnder18 ? _self.isUnder18 : isUnder18 // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
