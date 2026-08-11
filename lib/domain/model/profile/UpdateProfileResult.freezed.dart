// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UpdateProfileResult.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateProfileResult {

 int get id; String get name; String get email; String get role;
/// Create a copy of UpdateProfileResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileResultCopyWith<UpdateProfileResult> get copyWith => _$UpdateProfileResultCopyWithImpl<UpdateProfileResult>(this as UpdateProfileResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,role);

@override
String toString() {
  return 'UpdateProfileResult(id: $id, name: $name, email: $email, role: $role)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileResultCopyWith<$Res>  {
  factory $UpdateProfileResultCopyWith(UpdateProfileResult value, $Res Function(UpdateProfileResult) _then) = _$UpdateProfileResultCopyWithImpl;
@useResult
$Res call({
 int id, String name, String email, String role
});




}
/// @nodoc
class _$UpdateProfileResultCopyWithImpl<$Res>
    implements $UpdateProfileResultCopyWith<$Res> {
  _$UpdateProfileResultCopyWithImpl(this._self, this._then);

  final UpdateProfileResult _self;
  final $Res Function(UpdateProfileResult) _then;

/// Create a copy of UpdateProfileResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProfileResult].
extension UpdateProfileResultPatterns on UpdateProfileResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProfileResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProfileResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProfileResult value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProfileResult value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String email,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProfileResult() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String email,  String role)  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileResult():
return $default(_that.id,_that.name,_that.email,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String email,  String role)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileResult() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateProfileResult implements UpdateProfileResult {
  const _UpdateProfileResult({required this.id, required this.name, required this.email, required this.role});
  

@override final  int id;
@override final  String name;
@override final  String email;
@override final  String role;

/// Create a copy of UpdateProfileResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProfileResultCopyWith<_UpdateProfileResult> get copyWith => __$UpdateProfileResultCopyWithImpl<_UpdateProfileResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProfileResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,role);

@override
String toString() {
  return 'UpdateProfileResult(id: $id, name: $name, email: $email, role: $role)';
}


}

/// @nodoc
abstract mixin class _$UpdateProfileResultCopyWith<$Res> implements $UpdateProfileResultCopyWith<$Res> {
  factory _$UpdateProfileResultCopyWith(_UpdateProfileResult value, $Res Function(_UpdateProfileResult) _then) = __$UpdateProfileResultCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String email, String role
});




}
/// @nodoc
class __$UpdateProfileResultCopyWithImpl<$Res>
    implements _$UpdateProfileResultCopyWith<$Res> {
  __$UpdateProfileResultCopyWithImpl(this._self, this._then);

  final _UpdateProfileResult _self;
  final $Res Function(_UpdateProfileResult) _then;

/// Create a copy of UpdateProfileResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,}) {
  return _then(_UpdateProfileResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
