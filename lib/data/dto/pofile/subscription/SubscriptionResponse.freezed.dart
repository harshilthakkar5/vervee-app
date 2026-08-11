// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'SubscriptionResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionResponse {

@JsonKey(name: 'status') String get status;@JsonKey(name: 'trialEnd') DateTime? get trialEnd;@JsonKey(name: 'cancelAtPeriodEnd') bool get cancelAtPeriodEnd;
/// Create a copy of SubscriptionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionResponseCopyWith<SubscriptionResponse> get copyWith => _$SubscriptionResponseCopyWithImpl<SubscriptionResponse>(this as SubscriptionResponse, _$identity);

  /// Serializes this SubscriptionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.trialEnd, trialEnd) || other.trialEnd == trialEnd)&&(identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) || other.cancelAtPeriodEnd == cancelAtPeriodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,trialEnd,cancelAtPeriodEnd);

@override
String toString() {
  return 'SubscriptionResponse(status: $status, trialEnd: $trialEnd, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
}


}

/// @nodoc
abstract mixin class $SubscriptionResponseCopyWith<$Res>  {
  factory $SubscriptionResponseCopyWith(SubscriptionResponse value, $Res Function(SubscriptionResponse) _then) = _$SubscriptionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'status') String status,@JsonKey(name: 'trialEnd') DateTime? trialEnd,@JsonKey(name: 'cancelAtPeriodEnd') bool cancelAtPeriodEnd
});




}
/// @nodoc
class _$SubscriptionResponseCopyWithImpl<$Res>
    implements $SubscriptionResponseCopyWith<$Res> {
  _$SubscriptionResponseCopyWithImpl(this._self, this._then);

  final SubscriptionResponse _self;
  final $Res Function(SubscriptionResponse) _then;

/// Create a copy of SubscriptionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? trialEnd = freezed,Object? cancelAtPeriodEnd = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,trialEnd: freezed == trialEnd ? _self.trialEnd : trialEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelAtPeriodEnd: null == cancelAtPeriodEnd ? _self.cancelAtPeriodEnd : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionResponse].
extension SubscriptionResponsePatterns on SubscriptionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionResponse value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'status')  String status, @JsonKey(name: 'trialEnd')  DateTime? trialEnd, @JsonKey(name: 'cancelAtPeriodEnd')  bool cancelAtPeriodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionResponse() when $default != null:
return $default(_that.status,_that.trialEnd,_that.cancelAtPeriodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'status')  String status, @JsonKey(name: 'trialEnd')  DateTime? trialEnd, @JsonKey(name: 'cancelAtPeriodEnd')  bool cancelAtPeriodEnd)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionResponse():
return $default(_that.status,_that.trialEnd,_that.cancelAtPeriodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'status')  String status, @JsonKey(name: 'trialEnd')  DateTime? trialEnd, @JsonKey(name: 'cancelAtPeriodEnd')  bool cancelAtPeriodEnd)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionResponse() when $default != null:
return $default(_that.status,_that.trialEnd,_that.cancelAtPeriodEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionResponse extends SubscriptionResponse {
  const _SubscriptionResponse({@JsonKey(name: 'status') required this.status, @JsonKey(name: 'trialEnd') this.trialEnd, @JsonKey(name: 'cancelAtPeriodEnd') this.cancelAtPeriodEnd = false}): super._();
  factory _SubscriptionResponse.fromJson(Map<String, dynamic> json) => _$SubscriptionResponseFromJson(json);

@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'trialEnd') final  DateTime? trialEnd;
@override@JsonKey(name: 'cancelAtPeriodEnd') final  bool cancelAtPeriodEnd;

/// Create a copy of SubscriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionResponseCopyWith<_SubscriptionResponse> get copyWith => __$SubscriptionResponseCopyWithImpl<_SubscriptionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.trialEnd, trialEnd) || other.trialEnd == trialEnd)&&(identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) || other.cancelAtPeriodEnd == cancelAtPeriodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,trialEnd,cancelAtPeriodEnd);

@override
String toString() {
  return 'SubscriptionResponse(status: $status, trialEnd: $trialEnd, cancelAtPeriodEnd: $cancelAtPeriodEnd)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionResponseCopyWith<$Res> implements $SubscriptionResponseCopyWith<$Res> {
  factory _$SubscriptionResponseCopyWith(_SubscriptionResponse value, $Res Function(_SubscriptionResponse) _then) = __$SubscriptionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'status') String status,@JsonKey(name: 'trialEnd') DateTime? trialEnd,@JsonKey(name: 'cancelAtPeriodEnd') bool cancelAtPeriodEnd
});




}
/// @nodoc
class __$SubscriptionResponseCopyWithImpl<$Res>
    implements _$SubscriptionResponseCopyWith<$Res> {
  __$SubscriptionResponseCopyWithImpl(this._self, this._then);

  final _SubscriptionResponse _self;
  final $Res Function(_SubscriptionResponse) _then;

/// Create a copy of SubscriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? trialEnd = freezed,Object? cancelAtPeriodEnd = null,}) {
  return _then(_SubscriptionResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,trialEnd: freezed == trialEnd ? _self.trialEnd : trialEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelAtPeriodEnd: null == cancelAtPeriodEnd ? _self.cancelAtPeriodEnd : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
