// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CustomerPortalResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerPortalResponse {

@JsonKey(name: 'url') String get url;
/// Create a copy of CustomerPortalResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerPortalResponseCopyWith<CustomerPortalResponse> get copyWith => _$CustomerPortalResponseCopyWithImpl<CustomerPortalResponse>(this as CustomerPortalResponse, _$identity);

  /// Serializes this CustomerPortalResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerPortalResponse&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'CustomerPortalResponse(url: $url)';
}


}

/// @nodoc
abstract mixin class $CustomerPortalResponseCopyWith<$Res>  {
  factory $CustomerPortalResponseCopyWith(CustomerPortalResponse value, $Res Function(CustomerPortalResponse) _then) = _$CustomerPortalResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String url
});




}
/// @nodoc
class _$CustomerPortalResponseCopyWithImpl<$Res>
    implements $CustomerPortalResponseCopyWith<$Res> {
  _$CustomerPortalResponseCopyWithImpl(this._self, this._then);

  final CustomerPortalResponse _self;
  final $Res Function(CustomerPortalResponse) _then;

/// Create a copy of CustomerPortalResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerPortalResponse].
extension CustomerPortalResponsePatterns on CustomerPortalResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerPortalResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerPortalResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerPortalResponse value)  $default,){
final _that = this;
switch (_that) {
case _CustomerPortalResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerPortalResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerPortalResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerPortalResponse() when $default != null:
return $default(_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String url)  $default,) {final _that = this;
switch (_that) {
case _CustomerPortalResponse():
return $default(_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String url)?  $default,) {final _that = this;
switch (_that) {
case _CustomerPortalResponse() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerPortalResponse extends CustomerPortalResponse {
  const _CustomerPortalResponse({@JsonKey(name: 'url') required this.url}): super._();
  factory _CustomerPortalResponse.fromJson(Map<String, dynamic> json) => _$CustomerPortalResponseFromJson(json);

@override@JsonKey(name: 'url') final  String url;

/// Create a copy of CustomerPortalResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerPortalResponseCopyWith<_CustomerPortalResponse> get copyWith => __$CustomerPortalResponseCopyWithImpl<_CustomerPortalResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerPortalResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerPortalResponse&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'CustomerPortalResponse(url: $url)';
}


}

/// @nodoc
abstract mixin class _$CustomerPortalResponseCopyWith<$Res> implements $CustomerPortalResponseCopyWith<$Res> {
  factory _$CustomerPortalResponseCopyWith(_CustomerPortalResponse value, $Res Function(_CustomerPortalResponse) _then) = __$CustomerPortalResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String url
});




}
/// @nodoc
class __$CustomerPortalResponseCopyWithImpl<$Res>
    implements _$CustomerPortalResponseCopyWith<$Res> {
  __$CustomerPortalResponseCopyWithImpl(this._self, this._then);

  final _CustomerPortalResponse _self;
  final $Res Function(_CustomerPortalResponse) _then;

/// Create a copy of CustomerPortalResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_CustomerPortalResponse(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
