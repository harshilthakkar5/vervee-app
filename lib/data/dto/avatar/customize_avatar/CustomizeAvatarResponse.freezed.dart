// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CustomizeAvatarResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomizeAvatarResponse {

@JsonKey(name: 'message') String get message;@JsonKey(name: 'data') CustomizeAvatarData get data;
/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomizeAvatarResponseCopyWith<CustomizeAvatarResponse> get copyWith => _$CustomizeAvatarResponseCopyWithImpl<CustomizeAvatarResponse>(this as CustomizeAvatarResponse, _$identity);

  /// Serializes this CustomizeAvatarResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomizeAvatarResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'CustomizeAvatarResponse(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $CustomizeAvatarResponseCopyWith<$Res>  {
  factory $CustomizeAvatarResponseCopyWith(CustomizeAvatarResponse value, $Res Function(CustomizeAvatarResponse) _then) = _$CustomizeAvatarResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'data') CustomizeAvatarData data
});


$CustomizeAvatarDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CustomizeAvatarResponseCopyWithImpl<$Res>
    implements $CustomizeAvatarResponseCopyWith<$Res> {
  _$CustomizeAvatarResponseCopyWithImpl(this._self, this._then);

  final CustomizeAvatarResponse _self;
  final $Res Function(CustomizeAvatarResponse) _then;

/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CustomizeAvatarData,
  ));
}
/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomizeAvatarDataCopyWith<$Res> get data {
  
  return $CustomizeAvatarDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomizeAvatarResponse].
extension CustomizeAvatarResponsePatterns on CustomizeAvatarResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomizeAvatarResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomizeAvatarResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomizeAvatarResponse value)  $default,){
final _that = this;
switch (_that) {
case _CustomizeAvatarResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomizeAvatarResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CustomizeAvatarResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  CustomizeAvatarData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomizeAvatarResponse() when $default != null:
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  CustomizeAvatarData data)  $default,) {final _that = this;
switch (_that) {
case _CustomizeAvatarResponse():
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  CustomizeAvatarData data)?  $default,) {final _that = this;
switch (_that) {
case _CustomizeAvatarResponse() when $default != null:
return $default(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomizeAvatarResponse extends CustomizeAvatarResponse {
  const _CustomizeAvatarResponse({@JsonKey(name: 'message') required this.message, @JsonKey(name: 'data') required this.data}): super._();
  factory _CustomizeAvatarResponse.fromJson(Map<String, dynamic> json) => _$CustomizeAvatarResponseFromJson(json);

@override@JsonKey(name: 'message') final  String message;
@override@JsonKey(name: 'data') final  CustomizeAvatarData data;

/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomizeAvatarResponseCopyWith<_CustomizeAvatarResponse> get copyWith => __$CustomizeAvatarResponseCopyWithImpl<_CustomizeAvatarResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomizeAvatarResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomizeAvatarResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'CustomizeAvatarResponse(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CustomizeAvatarResponseCopyWith<$Res> implements $CustomizeAvatarResponseCopyWith<$Res> {
  factory _$CustomizeAvatarResponseCopyWith(_CustomizeAvatarResponse value, $Res Function(_CustomizeAvatarResponse) _then) = __$CustomizeAvatarResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'data') CustomizeAvatarData data
});


@override $CustomizeAvatarDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CustomizeAvatarResponseCopyWithImpl<$Res>
    implements _$CustomizeAvatarResponseCopyWith<$Res> {
  __$CustomizeAvatarResponseCopyWithImpl(this._self, this._then);

  final _CustomizeAvatarResponse _self;
  final $Res Function(_CustomizeAvatarResponse) _then;

/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(_CustomizeAvatarResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CustomizeAvatarData,
  ));
}

/// Create a copy of CustomizeAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomizeAvatarDataCopyWith<$Res> get data {
  
  return $CustomizeAvatarDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CustomizeAvatarData {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'userId') int get userId;@JsonKey(name: 'mascotId') String get mascotId;@JsonKey(name: 'mascotSelected') bool get mascotSelected;@JsonKey(name: 'mascotUrl') String get mascotUrl;@JsonKey(name: 'selectedItems') String? get selectedItems;//  @JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
@JsonKey(name: 'timestamp') String get timestamp;
/// Create a copy of CustomizeAvatarData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomizeAvatarDataCopyWith<CustomizeAvatarData> get copyWith => _$CustomizeAvatarDataCopyWithImpl<CustomizeAvatarData>(this as CustomizeAvatarData, _$identity);

  /// Serializes this CustomizeAvatarData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomizeAvatarData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.selectedItems, selectedItems) || other.selectedItems == selectedItems)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mascotId,mascotSelected,mascotUrl,selectedItems,timestamp);

@override
String toString() {
  return 'CustomizeAvatarData(id: $id, userId: $userId, mascotId: $mascotId, mascotSelected: $mascotSelected, mascotUrl: $mascotUrl, selectedItems: $selectedItems, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $CustomizeAvatarDataCopyWith<$Res>  {
  factory $CustomizeAvatarDataCopyWith(CustomizeAvatarData value, $Res Function(CustomizeAvatarData) _then) = _$CustomizeAvatarDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'mascotId') String mascotId,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotUrl') String mascotUrl,@JsonKey(name: 'selectedItems') String? selectedItems,@JsonKey(name: 'timestamp') String timestamp
});




}
/// @nodoc
class _$CustomizeAvatarDataCopyWithImpl<$Res>
    implements $CustomizeAvatarDataCopyWith<$Res> {
  _$CustomizeAvatarDataCopyWithImpl(this._self, this._then);

  final CustomizeAvatarData _self;
  final $Res Function(CustomizeAvatarData) _then;

/// Create a copy of CustomizeAvatarData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mascotId = null,Object? mascotSelected = null,Object? mascotUrl = null,Object? selectedItems = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mascotId: null == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotUrl: null == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String,selectedItems: freezed == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomizeAvatarData].
extension CustomizeAvatarDataPatterns on CustomizeAvatarData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomizeAvatarData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomizeAvatarData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomizeAvatarData value)  $default,){
final _that = this;
switch (_that) {
case _CustomizeAvatarData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomizeAvatarData value)?  $default,){
final _that = this;
switch (_that) {
case _CustomizeAvatarData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'userId')  int userId, @JsonKey(name: 'mascotId')  String mascotId, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotUrl')  String mascotUrl, @JsonKey(name: 'selectedItems')  String? selectedItems, @JsonKey(name: 'timestamp')  String timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomizeAvatarData() when $default != null:
return $default(_that.id,_that.userId,_that.mascotId,_that.mascotSelected,_that.mascotUrl,_that.selectedItems,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'userId')  int userId, @JsonKey(name: 'mascotId')  String mascotId, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotUrl')  String mascotUrl, @JsonKey(name: 'selectedItems')  String? selectedItems, @JsonKey(name: 'timestamp')  String timestamp)  $default,) {final _that = this;
switch (_that) {
case _CustomizeAvatarData():
return $default(_that.id,_that.userId,_that.mascotId,_that.mascotSelected,_that.mascotUrl,_that.selectedItems,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'userId')  int userId, @JsonKey(name: 'mascotId')  String mascotId, @JsonKey(name: 'mascotSelected')  bool mascotSelected, @JsonKey(name: 'mascotUrl')  String mascotUrl, @JsonKey(name: 'selectedItems')  String? selectedItems, @JsonKey(name: 'timestamp')  String timestamp)?  $default,) {final _that = this;
switch (_that) {
case _CustomizeAvatarData() when $default != null:
return $default(_that.id,_that.userId,_that.mascotId,_that.mascotSelected,_that.mascotUrl,_that.selectedItems,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomizeAvatarData implements CustomizeAvatarData {
  const _CustomizeAvatarData({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'mascotId') required this.mascotId, @JsonKey(name: 'mascotSelected') required this.mascotSelected, @JsonKey(name: 'mascotUrl') required this.mascotUrl, @JsonKey(name: 'selectedItems') this.selectedItems, @JsonKey(name: 'timestamp') required this.timestamp});
  factory _CustomizeAvatarData.fromJson(Map<String, dynamic> json) => _$CustomizeAvatarDataFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey(name: 'mascotId') final  String mascotId;
@override@JsonKey(name: 'mascotSelected') final  bool mascotSelected;
@override@JsonKey(name: 'mascotUrl') final  String mascotUrl;
@override@JsonKey(name: 'selectedItems') final  String? selectedItems;
//  @JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
@override@JsonKey(name: 'timestamp') final  String timestamp;

/// Create a copy of CustomizeAvatarData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomizeAvatarDataCopyWith<_CustomizeAvatarData> get copyWith => __$CustomizeAvatarDataCopyWithImpl<_CustomizeAvatarData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomizeAvatarDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomizeAvatarData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.selectedItems, selectedItems) || other.selectedItems == selectedItems)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mascotId,mascotSelected,mascotUrl,selectedItems,timestamp);

@override
String toString() {
  return 'CustomizeAvatarData(id: $id, userId: $userId, mascotId: $mascotId, mascotSelected: $mascotSelected, mascotUrl: $mascotUrl, selectedItems: $selectedItems, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$CustomizeAvatarDataCopyWith<$Res> implements $CustomizeAvatarDataCopyWith<$Res> {
  factory _$CustomizeAvatarDataCopyWith(_CustomizeAvatarData value, $Res Function(_CustomizeAvatarData) _then) = __$CustomizeAvatarDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'mascotId') String mascotId,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotUrl') String mascotUrl,@JsonKey(name: 'selectedItems') String? selectedItems,@JsonKey(name: 'timestamp') String timestamp
});




}
/// @nodoc
class __$CustomizeAvatarDataCopyWithImpl<$Res>
    implements _$CustomizeAvatarDataCopyWith<$Res> {
  __$CustomizeAvatarDataCopyWithImpl(this._self, this._then);

  final _CustomizeAvatarData _self;
  final $Res Function(_CustomizeAvatarData) _then;

/// Create a copy of CustomizeAvatarData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mascotId = null,Object? mascotSelected = null,Object? mascotUrl = null,Object? selectedItems = freezed,Object? timestamp = null,}) {
  return _then(_CustomizeAvatarData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,mascotId: null == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotUrl: null == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String,selectedItems: freezed == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
