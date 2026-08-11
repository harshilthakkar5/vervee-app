// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'FinancialLiteracyState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinancialLiteracyState {

 List<FinancialLiteracyCourse> get courses; bool get isLoading; String? get errorMessage;
/// Create a copy of FinancialLiteracyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialLiteracyStateCopyWith<FinancialLiteracyState> get copyWith => _$FinancialLiteracyStateCopyWithImpl<FinancialLiteracyState>(this as FinancialLiteracyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialLiteracyState&&const DeepCollectionEquality().equals(other.courses, courses)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(courses),isLoading,errorMessage);

@override
String toString() {
  return 'FinancialLiteracyState(courses: $courses, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FinancialLiteracyStateCopyWith<$Res>  {
  factory $FinancialLiteracyStateCopyWith(FinancialLiteracyState value, $Res Function(FinancialLiteracyState) _then) = _$FinancialLiteracyStateCopyWithImpl;
@useResult
$Res call({
 List<FinancialLiteracyCourse> courses, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$FinancialLiteracyStateCopyWithImpl<$Res>
    implements $FinancialLiteracyStateCopyWith<$Res> {
  _$FinancialLiteracyStateCopyWithImpl(this._self, this._then);

  final FinancialLiteracyState _self;
  final $Res Function(FinancialLiteracyState) _then;

/// Create a copy of FinancialLiteracyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courses = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
courses: null == courses ? _self.courses : courses // ignore: cast_nullable_to_non_nullable
as List<FinancialLiteracyCourse>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialLiteracyState].
extension FinancialLiteracyStatePatterns on FinancialLiteracyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialLiteracyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialLiteracyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialLiteracyState value)  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialLiteracyState value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialLiteracyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FinancialLiteracyCourse> courses,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialLiteracyState() when $default != null:
return $default(_that.courses,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FinancialLiteracyCourse> courses,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyState():
return $default(_that.courses,_that.isLoading,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FinancialLiteracyCourse> courses,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _FinancialLiteracyState() when $default != null:
return $default(_that.courses,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _FinancialLiteracyState implements FinancialLiteracyState {
  const _FinancialLiteracyState({final  List<FinancialLiteracyCourse> courses = const [], this.isLoading = false, this.errorMessage}): _courses = courses;
  

 final  List<FinancialLiteracyCourse> _courses;
@override@JsonKey() List<FinancialLiteracyCourse> get courses {
  if (_courses is EqualUnmodifiableListView) return _courses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courses);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of FinancialLiteracyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialLiteracyStateCopyWith<_FinancialLiteracyState> get copyWith => __$FinancialLiteracyStateCopyWithImpl<_FinancialLiteracyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialLiteracyState&&const DeepCollectionEquality().equals(other._courses, _courses)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_courses),isLoading,errorMessage);

@override
String toString() {
  return 'FinancialLiteracyState(courses: $courses, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$FinancialLiteracyStateCopyWith<$Res> implements $FinancialLiteracyStateCopyWith<$Res> {
  factory _$FinancialLiteracyStateCopyWith(_FinancialLiteracyState value, $Res Function(_FinancialLiteracyState) _then) = __$FinancialLiteracyStateCopyWithImpl;
@override @useResult
$Res call({
 List<FinancialLiteracyCourse> courses, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$FinancialLiteracyStateCopyWithImpl<$Res>
    implements _$FinancialLiteracyStateCopyWith<$Res> {
  __$FinancialLiteracyStateCopyWithImpl(this._self, this._then);

  final _FinancialLiteracyState _self;
  final $Res Function(_FinancialLiteracyState) _then;

/// Create a copy of FinancialLiteracyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courses = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_FinancialLiteracyState(
courses: null == courses ? _self._courses : courses // ignore: cast_nullable_to_non_nullable
as List<FinancialLiteracyCourse>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CourseDetailState {

 FinancialLiteracyDetail? get detail; bool get isLoading; String? get errorMessage;
/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseDetailStateCopyWith<CourseDetailState> get copyWith => _$CourseDetailStateCopyWithImpl<CourseDetailState>(this as CourseDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseDetailState&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,detail,isLoading,errorMessage);

@override
String toString() {
  return 'CourseDetailState(detail: $detail, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CourseDetailStateCopyWith<$Res>  {
  factory $CourseDetailStateCopyWith(CourseDetailState value, $Res Function(CourseDetailState) _then) = _$CourseDetailStateCopyWithImpl;
@useResult
$Res call({
 FinancialLiteracyDetail? detail, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$CourseDetailStateCopyWithImpl<$Res>
    implements $CourseDetailStateCopyWith<$Res> {
  _$CourseDetailStateCopyWithImpl(this._self, this._then);

  final CourseDetailState _self;
  final $Res Function(CourseDetailState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? detail = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as FinancialLiteracyDetail?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseDetailState].
extension CourseDetailStatePatterns on CourseDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseDetailState value)  $default,){
final _that = this;
switch (_that) {
case _CourseDetailState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FinancialLiteracyDetail? detail,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
return $default(_that.detail,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FinancialLiteracyDetail? detail,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CourseDetailState():
return $default(_that.detail,_that.isLoading,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FinancialLiteracyDetail? detail,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CourseDetailState() when $default != null:
return $default(_that.detail,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CourseDetailState implements CourseDetailState {
  const _CourseDetailState({this.detail, this.isLoading = false, this.errorMessage});
  

@override final  FinancialLiteracyDetail? detail;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseDetailStateCopyWith<_CourseDetailState> get copyWith => __$CourseDetailStateCopyWithImpl<_CourseDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseDetailState&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,detail,isLoading,errorMessage);

@override
String toString() {
  return 'CourseDetailState(detail: $detail, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CourseDetailStateCopyWith<$Res> implements $CourseDetailStateCopyWith<$Res> {
  factory _$CourseDetailStateCopyWith(_CourseDetailState value, $Res Function(_CourseDetailState) _then) = __$CourseDetailStateCopyWithImpl;
@override @useResult
$Res call({
 FinancialLiteracyDetail? detail, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$CourseDetailStateCopyWithImpl<$Res>
    implements _$CourseDetailStateCopyWith<$Res> {
  __$CourseDetailStateCopyWithImpl(this._self, this._then);

  final _CourseDetailState _self;
  final $Res Function(_CourseDetailState) _then;

/// Create a copy of CourseDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? detail = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_CourseDetailState(
detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as FinancialLiteracyDetail?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
