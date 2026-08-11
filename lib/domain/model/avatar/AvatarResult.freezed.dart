// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AvatarResult.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvatarResult {

 String get message; String get mascotUrl; String get mascotId;
/// Create a copy of AvatarResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarResultCopyWith<AvatarResult> get copyWith => _$AvatarResultCopyWithImpl<AvatarResult>(this as AvatarResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarResult&&(identical(other.message, message) || other.message == message)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId));
}


@override
int get hashCode => Object.hash(runtimeType,message,mascotUrl,mascotId);

@override
String toString() {
  return 'AvatarResult(message: $message, mascotUrl: $mascotUrl, mascotId: $mascotId)';
}


}

/// @nodoc
abstract mixin class $AvatarResultCopyWith<$Res>  {
  factory $AvatarResultCopyWith(AvatarResult value, $Res Function(AvatarResult) _then) = _$AvatarResultCopyWithImpl;
@useResult
$Res call({
 String message, String mascotUrl, String mascotId
});




}
/// @nodoc
class _$AvatarResultCopyWithImpl<$Res>
    implements $AvatarResultCopyWith<$Res> {
  _$AvatarResultCopyWithImpl(this._self, this._then);

  final AvatarResult _self;
  final $Res Function(AvatarResult) _then;

/// Create a copy of AvatarResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? mascotUrl = null,Object? mascotId = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,mascotUrl: null == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String,mascotId: null == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarResult].
extension AvatarResultPatterns on AvatarResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarResult value)  $default,){
final _that = this;
switch (_that) {
case _AvatarResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarResult value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  String mascotUrl,  String mascotId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarResult() when $default != null:
return $default(_that.message,_that.mascotUrl,_that.mascotId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  String mascotUrl,  String mascotId)  $default,) {final _that = this;
switch (_that) {
case _AvatarResult():
return $default(_that.message,_that.mascotUrl,_that.mascotId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  String mascotUrl,  String mascotId)?  $default,) {final _that = this;
switch (_that) {
case _AvatarResult() when $default != null:
return $default(_that.message,_that.mascotUrl,_that.mascotId);case _:
  return null;

}
}

}

/// @nodoc


class _AvatarResult implements AvatarResult {
  const _AvatarResult({required this.message, required this.mascotUrl, required this.mascotId});
  

@override final  String message;
@override final  String mascotUrl;
@override final  String mascotId;

/// Create a copy of AvatarResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarResultCopyWith<_AvatarResult> get copyWith => __$AvatarResultCopyWithImpl<_AvatarResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarResult&&(identical(other.message, message) || other.message == message)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId));
}


@override
int get hashCode => Object.hash(runtimeType,message,mascotUrl,mascotId);

@override
String toString() {
  return 'AvatarResult(message: $message, mascotUrl: $mascotUrl, mascotId: $mascotId)';
}


}

/// @nodoc
abstract mixin class _$AvatarResultCopyWith<$Res> implements $AvatarResultCopyWith<$Res> {
  factory _$AvatarResultCopyWith(_AvatarResult value, $Res Function(_AvatarResult) _then) = __$AvatarResultCopyWithImpl;
@override @useResult
$Res call({
 String message, String mascotUrl, String mascotId
});




}
/// @nodoc
class __$AvatarResultCopyWithImpl<$Res>
    implements _$AvatarResultCopyWith<$Res> {
  __$AvatarResultCopyWithImpl(this._self, this._then);

  final _AvatarResult _self;
  final $Res Function(_AvatarResult) _then;

/// Create a copy of AvatarResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? mascotUrl = null,Object? mascotId = null,}) {
  return _then(_AvatarResult(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,mascotUrl: null == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String,mascotId: null == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
