// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'SelectMascotResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectMascotResponse {

@JsonKey(name: 'message') String get message;@JsonKey(name: 'data') SelectMascotData get data;
/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectMascotResponseCopyWith<SelectMascotResponse> get copyWith => _$SelectMascotResponseCopyWithImpl<SelectMascotResponse>(this as SelectMascotResponse, _$identity);

  /// Serializes this SelectMascotResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectMascotResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'SelectMascotResponse(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $SelectMascotResponseCopyWith<$Res>  {
  factory $SelectMascotResponseCopyWith(SelectMascotResponse value, $Res Function(SelectMascotResponse) _then) = _$SelectMascotResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'data') SelectMascotData data
});


$SelectMascotDataCopyWith<$Res> get data;

}
/// @nodoc
class _$SelectMascotResponseCopyWithImpl<$Res>
    implements $SelectMascotResponseCopyWith<$Res> {
  _$SelectMascotResponseCopyWithImpl(this._self, this._then);

  final SelectMascotResponse _self;
  final $Res Function(SelectMascotResponse) _then;

/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SelectMascotData,
  ));
}
/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectMascotDataCopyWith<$Res> get data {
  
  return $SelectMascotDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SelectMascotResponse].
extension SelectMascotResponsePatterns on SelectMascotResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectMascotResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectMascotResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectMascotResponse value)  $default,){
final _that = this;
switch (_that) {
case _SelectMascotResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectMascotResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SelectMascotResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  SelectMascotData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectMascotResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  SelectMascotData data)  $default,) {final _that = this;
switch (_that) {
case _SelectMascotResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'data')  SelectMascotData data)?  $default,) {final _that = this;
switch (_that) {
case _SelectMascotResponse() when $default != null:
return $default(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectMascotResponse extends SelectMascotResponse {
  const _SelectMascotResponse({@JsonKey(name: 'message') required this.message, @JsonKey(name: 'data') required this.data}): super._();
  factory _SelectMascotResponse.fromJson(Map<String, dynamic> json) => _$SelectMascotResponseFromJson(json);

@override@JsonKey(name: 'message') final  String message;
@override@JsonKey(name: 'data') final  SelectMascotData data;

/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectMascotResponseCopyWith<_SelectMascotResponse> get copyWith => __$SelectMascotResponseCopyWithImpl<_SelectMascotResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectMascotResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectMascotResponse&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,data);

@override
String toString() {
  return 'SelectMascotResponse(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SelectMascotResponseCopyWith<$Res> implements $SelectMascotResponseCopyWith<$Res> {
  factory _$SelectMascotResponseCopyWith(_SelectMascotResponse value, $Res Function(_SelectMascotResponse) _then) = __$SelectMascotResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'data') SelectMascotData data
});


@override $SelectMascotDataCopyWith<$Res> get data;

}
/// @nodoc
class __$SelectMascotResponseCopyWithImpl<$Res>
    implements _$SelectMascotResponseCopyWith<$Res> {
  __$SelectMascotResponseCopyWithImpl(this._self, this._then);

  final _SelectMascotResponse _self;
  final $Res Function(_SelectMascotResponse) _then;

/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? data = null,}) {
  return _then(_SelectMascotResponse(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SelectMascotData,
  ));
}

/// Create a copy of SelectMascotResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SelectMascotDataCopyWith<$Res> get data {
  
  return $SelectMascotDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$SelectMascotData {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'userId') int get userId;@JsonKey(name: 'mascotId') String get mascotId;@JsonKey(name: 'mascotSelected') bool get mascotSelected;@JsonKey(name: 'mascotUrl') String get mascotUrl;@JsonKey(name: 'selectedItems') String? get selectedItems;//@JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
@JsonKey(name: 'timestamp') String get timestamp;
/// Create a copy of SelectMascotData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectMascotDataCopyWith<SelectMascotData> get copyWith => _$SelectMascotDataCopyWithImpl<SelectMascotData>(this as SelectMascotData, _$identity);

  /// Serializes this SelectMascotData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectMascotData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.selectedItems, selectedItems) || other.selectedItems == selectedItems)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mascotId,mascotSelected,mascotUrl,selectedItems,timestamp);

@override
String toString() {
  return 'SelectMascotData(id: $id, userId: $userId, mascotId: $mascotId, mascotSelected: $mascotSelected, mascotUrl: $mascotUrl, selectedItems: $selectedItems, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $SelectMascotDataCopyWith<$Res>  {
  factory $SelectMascotDataCopyWith(SelectMascotData value, $Res Function(SelectMascotData) _then) = _$SelectMascotDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'mascotId') String mascotId,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotUrl') String mascotUrl,@JsonKey(name: 'selectedItems') String? selectedItems,@JsonKey(name: 'timestamp') String timestamp
});




}
/// @nodoc
class _$SelectMascotDataCopyWithImpl<$Res>
    implements $SelectMascotDataCopyWith<$Res> {
  _$SelectMascotDataCopyWithImpl(this._self, this._then);

  final SelectMascotData _self;
  final $Res Function(SelectMascotData) _then;

/// Create a copy of SelectMascotData
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


/// Adds pattern-matching-related methods to [SelectMascotData].
extension SelectMascotDataPatterns on SelectMascotData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectMascotData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectMascotData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectMascotData value)  $default,){
final _that = this;
switch (_that) {
case _SelectMascotData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectMascotData value)?  $default,){
final _that = this;
switch (_that) {
case _SelectMascotData() when $default != null:
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
case _SelectMascotData() when $default != null:
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
case _SelectMascotData():
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
case _SelectMascotData() when $default != null:
return $default(_that.id,_that.userId,_that.mascotId,_that.mascotSelected,_that.mascotUrl,_that.selectedItems,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectMascotData implements SelectMascotData {
  const _SelectMascotData({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'mascotId') required this.mascotId, @JsonKey(name: 'mascotSelected') required this.mascotSelected, @JsonKey(name: 'mascotUrl') required this.mascotUrl, @JsonKey(name: 'selectedItems') this.selectedItems, @JsonKey(name: 'timestamp') required this.timestamp});
  factory _SelectMascotData.fromJson(Map<String, dynamic> json) => _$SelectMascotDataFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey(name: 'mascotId') final  String mascotId;
@override@JsonKey(name: 'mascotSelected') final  bool mascotSelected;
@override@JsonKey(name: 'mascotUrl') final  String mascotUrl;
@override@JsonKey(name: 'selectedItems') final  String? selectedItems;
//@JsonKey(name: 'selectedItems') @Default([]) List<dynamic> selectedItems,
@override@JsonKey(name: 'timestamp') final  String timestamp;

/// Create a copy of SelectMascotData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectMascotDataCopyWith<_SelectMascotData> get copyWith => __$SelectMascotDataCopyWithImpl<_SelectMascotData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectMascotDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectMascotData&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&(identical(other.selectedItems, selectedItems) || other.selectedItems == selectedItems)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mascotId,mascotSelected,mascotUrl,selectedItems,timestamp);

@override
String toString() {
  return 'SelectMascotData(id: $id, userId: $userId, mascotId: $mascotId, mascotSelected: $mascotSelected, mascotUrl: $mascotUrl, selectedItems: $selectedItems, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$SelectMascotDataCopyWith<$Res> implements $SelectMascotDataCopyWith<$Res> {
  factory _$SelectMascotDataCopyWith(_SelectMascotData value, $Res Function(_SelectMascotData) _then) = __$SelectMascotDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'userId') int userId,@JsonKey(name: 'mascotId') String mascotId,@JsonKey(name: 'mascotSelected') bool mascotSelected,@JsonKey(name: 'mascotUrl') String mascotUrl,@JsonKey(name: 'selectedItems') String? selectedItems,@JsonKey(name: 'timestamp') String timestamp
});




}
/// @nodoc
class __$SelectMascotDataCopyWithImpl<$Res>
    implements _$SelectMascotDataCopyWith<$Res> {
  __$SelectMascotDataCopyWithImpl(this._self, this._then);

  final _SelectMascotData _self;
  final $Res Function(_SelectMascotData) _then;

/// Create a copy of SelectMascotData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mascotId = null,Object? mascotSelected = null,Object? mascotUrl = null,Object? selectedItems = freezed,Object? timestamp = null,}) {
  return _then(_SelectMascotData(
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
