// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'OtpResult.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpResult {

 String get message;
/// Create a copy of OtpResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpResultCopyWith<OtpResult> get copyWith => _$OtpResultCopyWithImpl<OtpResult>(this as OtpResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpResult&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OtpResult(message: $message)';
}


}

/// @nodoc
abstract mixin class $OtpResultCopyWith<$Res>  {
  factory $OtpResultCopyWith(OtpResult value, $Res Function(OtpResult) _then) = _$OtpResultCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OtpResultCopyWithImpl<$Res>
    implements $OtpResultCopyWith<$Res> {
  _$OtpResultCopyWithImpl(this._self, this._then);

  final OtpResult _self;
  final $Res Function(OtpResult) _then;

/// Create a copy of OtpResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpResult].
extension OtpResultPatterns on OtpResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpResult value)  $default,){
final _that = this;
switch (_that) {
case _OtpResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpResult value)?  $default,){
final _that = this;
switch (_that) {
case _OtpResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpResult() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _OtpResult():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _OtpResult() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _OtpResult implements OtpResult {
  const _OtpResult({required this.message});
  

@override final  String message;

/// Create a copy of OtpResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpResultCopyWith<_OtpResult> get copyWith => __$OtpResultCopyWithImpl<_OtpResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpResult&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OtpResult(message: $message)';
}


}

/// @nodoc
abstract mixin class _$OtpResultCopyWith<$Res> implements $OtpResultCopyWith<$Res> {
  factory _$OtpResultCopyWith(_OtpResult value, $Res Function(_OtpResult) _then) = __$OtpResultCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$OtpResultCopyWithImpl<$Res>
    implements _$OtpResultCopyWith<$Res> {
  __$OtpResultCopyWithImpl(this._self, this._then);

  final _OtpResult _self;
  final $Res Function(_OtpResult) _then;

/// Create a copy of OtpResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_OtpResult(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
