// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AvatarUserInfoResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvatarUserInfoResponse {

@JsonKey(name: 'userId') int get userId;@JsonKey(name: 'age') int get age;@JsonKey(name: 'gender') String get gender;@JsonKey(name: 'mascotSelected') bool get mascotSelected;@JsonKey(name: 'mascotId') String? get mascotId;@JsonKey(name: 'mascotUrl') String? get mascotUrl;@JsonKey(name: 'selectedItems') List<dynamic> get selectedItems;@JsonKey(name: 'colors') AvatarColorsDto? get colors;
/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarUserInfoResponseCopyWith<AvatarUserInfoResponse> get copyWith => _$AvatarUserInfoResponseCopyWithImpl<AvatarUserInfoResponse>(this as AvatarUserInfoResponse, _$identity);

  /// Serializes this AvatarUserInfoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarUserInfoResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems)&&(identical(other.colors, colors) || other.colors == colors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,age,gender,mascotSelected,mascotId,mascotUrl,const DeepCollectionEquality().hash(selectedItems),colors);

@override
String toString() {
  return 'AvatarUserInfoResponse(userId: $userId, age: $age, gender: $gender, mascotSelected: $mascotSelected, mascotId: $mascotId, mascotUrl: $mascotUrl, selectedItems: $selectedItems, colors: $colors)';
}


}

/// @nodoc
abstract mixin class $AvatarUserInfoResponseCopyWith<$Res>  {
  factory $AvatarUserInfoResponseCopyWith(AvatarUserInfoResponse value, $Res Function(AvatarUserInfoResponse) _then) = _$AvatarUserInfoResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') int userId,@JsonKey(name: 'age') int age,@JsonKey(name: 'gender') String gender,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotId') String? mascotId,@JsonKey(name: 'mascotUrl') String? mascotUrl,@JsonKey(name: 'selectedItems') List<dynamic> selectedItems,@JsonKey(name: 'colors') AvatarColorsDto? colors
});


$AvatarColorsDtoCopyWith<$Res>? get colors;

}
/// @nodoc
class _$AvatarUserInfoResponseCopyWithImpl<$Res>
    implements $AvatarUserInfoResponseCopyWith<$Res> {
  _$AvatarUserInfoResponseCopyWithImpl(this._self, this._then);

  final AvatarUserInfoResponse _self;
  final $Res Function(AvatarUserInfoResponse) _then;

/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? age = null,Object? gender = null,Object? mascotSelected = null,Object? mascotId = freezed,Object? mascotUrl = freezed,Object? selectedItems = null,Object? colors = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotId: freezed == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String?,mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,selectedItems: null == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<dynamic>,colors: freezed == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as AvatarColorsDto?,
  ));
}
/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarColorsDtoCopyWith<$Res>? get colors {
    if (_self.colors == null) {
    return null;
  }

  return $AvatarColorsDtoCopyWith<$Res>(_self.colors!, (value) {
    return _then(_self.copyWith(colors: value));
  });
}
}


/// Adds pattern-matching-related methods to [AvatarUserInfoResponse].
extension AvatarUserInfoResponsePatterns on AvatarUserInfoResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarUserInfoResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarUserInfoResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarUserInfoResponse value)  $default,){
final _that = this;
switch (_that) {
case _AvatarUserInfoResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarUserInfoResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarUserInfoResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'age')  int age, @JsonKey(name: 'gender')  String gender, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotId')  String? mascotId, @JsonKey(name: 'mascotUrl')  String? mascotUrl, @JsonKey(name: 'selectedItems')  List<dynamic> selectedItems, @JsonKey(name: 'colors')  AvatarColorsDto? colors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarUserInfoResponse() when $default != null:
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems,_that.colors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'age')  int age, @JsonKey(name: 'gender')  String gender, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotId')  String? mascotId, @JsonKey(name: 'mascotUrl')  String? mascotUrl, @JsonKey(name: 'selectedItems')  List<dynamic> selectedItems, @JsonKey(name: 'colors')  AvatarColorsDto? colors)  $default,) {final _that = this;
switch (_that) {
case _AvatarUserInfoResponse():
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems,_that.colors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  int userId, @JsonKey(name: 'age')  int age, @JsonKey(name: 'gender')  String gender, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotId')  String? mascotId, @JsonKey(name: 'mascotUrl')  String? mascotUrl, @JsonKey(name: 'selectedItems')  List<dynamic> selectedItems, @JsonKey(name: 'colors')  AvatarColorsDto? colors)?  $default,) {final _that = this;
switch (_that) {
case _AvatarUserInfoResponse() when $default != null:
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems,_that.colors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvatarUserInfoResponse extends AvatarUserInfoResponse {
  const _AvatarUserInfoResponse({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'age') required this.age, @JsonKey(name: 'gender') required this.gender, @JsonKey(name: 'mascotSelected') required this.mascotSelected, @JsonKey(name: 'mascotId') this.mascotId, @JsonKey(name: 'mascotUrl') this.mascotUrl, @JsonKey(name: 'selectedItems') final  List<dynamic> selectedItems = const [], @JsonKey(name: 'colors') this.colors}): _selectedItems = selectedItems,super._();
  factory _AvatarUserInfoResponse.fromJson(Map<String, dynamic> json) => _$AvatarUserInfoResponseFromJson(json);

@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey(name: 'age') final  int age;
@override@JsonKey(name: 'gender') final  String gender;
@override@JsonKey(name: 'mascotSelected') final  bool mascotSelected;
@override@JsonKey(name: 'mascotId') final  String? mascotId;
@override@JsonKey(name: 'mascotUrl') final  String? mascotUrl;
 final  List<dynamic> _selectedItems;
@override@JsonKey(name: 'selectedItems') List<dynamic> get selectedItems {
  if (_selectedItems is EqualUnmodifiableListView) return _selectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedItems);
}

@override@JsonKey(name: 'colors') final  AvatarColorsDto? colors;

/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarUserInfoResponseCopyWith<_AvatarUserInfoResponse> get copyWith => __$AvatarUserInfoResponseCopyWithImpl<_AvatarUserInfoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarUserInfoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarUserInfoResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems)&&(identical(other.colors, colors) || other.colors == colors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,age,gender,mascotSelected,mascotId,mascotUrl,const DeepCollectionEquality().hash(_selectedItems),colors);

@override
String toString() {
  return 'AvatarUserInfoResponse(userId: $userId, age: $age, gender: $gender, mascotSelected: $mascotSelected, mascotId: $mascotId, mascotUrl: $mascotUrl, selectedItems: $selectedItems, colors: $colors)';
}


}

/// @nodoc
abstract mixin class _$AvatarUserInfoResponseCopyWith<$Res> implements $AvatarUserInfoResponseCopyWith<$Res> {
  factory _$AvatarUserInfoResponseCopyWith(_AvatarUserInfoResponse value, $Res Function(_AvatarUserInfoResponse) _then) = __$AvatarUserInfoResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') int userId,@JsonKey(name: 'age') int age,@JsonKey(name: 'gender') String gender,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotId') String? mascotId,@JsonKey(name: 'mascotUrl') String? mascotUrl,@JsonKey(name: 'selectedItems') List<dynamic> selectedItems,@JsonKey(name: 'colors') AvatarColorsDto? colors
});


@override $AvatarColorsDtoCopyWith<$Res>? get colors;

}
/// @nodoc
class __$AvatarUserInfoResponseCopyWithImpl<$Res>
    implements _$AvatarUserInfoResponseCopyWith<$Res> {
  __$AvatarUserInfoResponseCopyWithImpl(this._self, this._then);

  final _AvatarUserInfoResponse _self;
  final $Res Function(_AvatarUserInfoResponse) _then;

/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? age = null,Object? gender = null,Object? mascotSelected = null,Object? mascotId = freezed,Object? mascotUrl = freezed,Object? selectedItems = null,Object? colors = freezed,}) {
  return _then(_AvatarUserInfoResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotId: freezed == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String?,mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,selectedItems: null == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<dynamic>,colors: freezed == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as AvatarColorsDto?,
  ));
}

/// Create a copy of AvatarUserInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarColorsDtoCopyWith<$Res>? get colors {
    if (_self.colors == null) {
    return null;
  }

  return $AvatarColorsDtoCopyWith<$Res>(_self.colors!, (value) {
    return _then(_self.copyWith(colors: value));
  });
}
}


/// @nodoc
mixin _$AvatarColorsDto {

@JsonKey(name: 'cap') String? get cap;@JsonKey(name: 'shoes') String? get shoes;@JsonKey(name: 'clothes') String? get clothes;@JsonKey(name: 'watch') String? get watch;@JsonKey(name: 'chain') String? get chain;
/// Create a copy of AvatarColorsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarColorsDtoCopyWith<AvatarColorsDto> get copyWith => _$AvatarColorsDtoCopyWithImpl<AvatarColorsDto>(this as AvatarColorsDto, _$identity);

  /// Serializes this AvatarColorsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarColorsDto&&(identical(other.cap, cap) || other.cap == cap)&&(identical(other.shoes, shoes) || other.shoes == shoes)&&(identical(other.clothes, clothes) || other.clothes == clothes)&&(identical(other.watch, watch) || other.watch == watch)&&(identical(other.chain, chain) || other.chain == chain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cap,shoes,clothes,watch,chain);

@override
String toString() {
  return 'AvatarColorsDto(cap: $cap, shoes: $shoes, clothes: $clothes, watch: $watch, chain: $chain)';
}


}

/// @nodoc
abstract mixin class $AvatarColorsDtoCopyWith<$Res>  {
  factory $AvatarColorsDtoCopyWith(AvatarColorsDto value, $Res Function(AvatarColorsDto) _then) = _$AvatarColorsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'cap') String? cap,@JsonKey(name: 'shoes') String? shoes,@JsonKey(name: 'clothes') String? clothes,@JsonKey(name: 'watch') String? watch,@JsonKey(name: 'chain') String? chain
});




}
/// @nodoc
class _$AvatarColorsDtoCopyWithImpl<$Res>
    implements $AvatarColorsDtoCopyWith<$Res> {
  _$AvatarColorsDtoCopyWithImpl(this._self, this._then);

  final AvatarColorsDto _self;
  final $Res Function(AvatarColorsDto) _then;

/// Create a copy of AvatarColorsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cap = freezed,Object? shoes = freezed,Object? clothes = freezed,Object? watch = freezed,Object? chain = freezed,}) {
  return _then(_self.copyWith(
cap: freezed == cap ? _self.cap : cap // ignore: cast_nullable_to_non_nullable
as String?,shoes: freezed == shoes ? _self.shoes : shoes // ignore: cast_nullable_to_non_nullable
as String?,clothes: freezed == clothes ? _self.clothes : clothes // ignore: cast_nullable_to_non_nullable
as String?,watch: freezed == watch ? _self.watch : watch // ignore: cast_nullable_to_non_nullable
as String?,chain: freezed == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarColorsDto].
extension AvatarColorsDtoPatterns on AvatarColorsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarColorsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarColorsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarColorsDto value)  $default,){
final _that = this;
switch (_that) {
case _AvatarColorsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarColorsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarColorsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'cap')  String? cap, @JsonKey(name: 'shoes')  String? shoes, @JsonKey(name: 'clothes')  String? clothes, @JsonKey(name: 'watch')  String? watch, @JsonKey(name: 'chain')  String? chain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarColorsDto() when $default != null:
return $default(_that.cap,_that.shoes,_that.clothes,_that.watch,_that.chain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'cap')  String? cap, @JsonKey(name: 'shoes')  String? shoes, @JsonKey(name: 'clothes')  String? clothes, @JsonKey(name: 'watch')  String? watch, @JsonKey(name: 'chain')  String? chain)  $default,) {final _that = this;
switch (_that) {
case _AvatarColorsDto():
return $default(_that.cap,_that.shoes,_that.clothes,_that.watch,_that.chain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'cap')  String? cap, @JsonKey(name: 'shoes')  String? shoes, @JsonKey(name: 'clothes')  String? clothes, @JsonKey(name: 'watch')  String? watch, @JsonKey(name: 'chain')  String? chain)?  $default,) {final _that = this;
switch (_that) {
case _AvatarColorsDto() when $default != null:
return $default(_that.cap,_that.shoes,_that.clothes,_that.watch,_that.chain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvatarColorsDto implements AvatarColorsDto {
  const _AvatarColorsDto({@JsonKey(name: 'cap') this.cap, @JsonKey(name: 'shoes') this.shoes, @JsonKey(name: 'clothes') this.clothes, @JsonKey(name: 'watch') this.watch, @JsonKey(name: 'chain') this.chain});
  factory _AvatarColorsDto.fromJson(Map<String, dynamic> json) => _$AvatarColorsDtoFromJson(json);

@override@JsonKey(name: 'cap') final  String? cap;
@override@JsonKey(name: 'shoes') final  String? shoes;
@override@JsonKey(name: 'clothes') final  String? clothes;
@override@JsonKey(name: 'watch') final  String? watch;
@override@JsonKey(name: 'chain') final  String? chain;

/// Create a copy of AvatarColorsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarColorsDtoCopyWith<_AvatarColorsDto> get copyWith => __$AvatarColorsDtoCopyWithImpl<_AvatarColorsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarColorsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarColorsDto&&(identical(other.cap, cap) || other.cap == cap)&&(identical(other.shoes, shoes) || other.shoes == shoes)&&(identical(other.clothes, clothes) || other.clothes == clothes)&&(identical(other.watch, watch) || other.watch == watch)&&(identical(other.chain, chain) || other.chain == chain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cap,shoes,clothes,watch,chain);

@override
String toString() {
  return 'AvatarColorsDto(cap: $cap, shoes: $shoes, clothes: $clothes, watch: $watch, chain: $chain)';
}


}

/// @nodoc
abstract mixin class _$AvatarColorsDtoCopyWith<$Res> implements $AvatarColorsDtoCopyWith<$Res> {
  factory _$AvatarColorsDtoCopyWith(_AvatarColorsDto value, $Res Function(_AvatarColorsDto) _then) = __$AvatarColorsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'cap') String? cap,@JsonKey(name: 'shoes') String? shoes,@JsonKey(name: 'clothes') String? clothes,@JsonKey(name: 'watch') String? watch,@JsonKey(name: 'chain') String? chain
});




}
/// @nodoc
class __$AvatarColorsDtoCopyWithImpl<$Res>
    implements _$AvatarColorsDtoCopyWith<$Res> {
  __$AvatarColorsDtoCopyWithImpl(this._self, this._then);

  final _AvatarColorsDto _self;
  final $Res Function(_AvatarColorsDto) _then;

/// Create a copy of AvatarColorsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cap = freezed,Object? shoes = freezed,Object? clothes = freezed,Object? watch = freezed,Object? chain = freezed,}) {
  return _then(_AvatarColorsDto(
cap: freezed == cap ? _self.cap : cap // ignore: cast_nullable_to_non_nullable
as String?,shoes: freezed == shoes ? _self.shoes : shoes // ignore: cast_nullable_to_non_nullable
as String?,clothes: freezed == clothes ? _self.clothes : clothes // ignore: cast_nullable_to_non_nullable
as String?,watch: freezed == watch ? _self.watch : watch // ignore: cast_nullable_to_non_nullable
as String?,chain: freezed == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
