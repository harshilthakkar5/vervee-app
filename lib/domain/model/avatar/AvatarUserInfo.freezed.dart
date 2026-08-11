// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AvatarUserInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvatarUserInfo {

 int get userId; int get age; String get gender; bool get mascotSelected; String? get mascotId; String? get mascotUrl; List<String> get selectedItems;
/// Create a copy of AvatarUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarUserInfoCopyWith<AvatarUserInfo> get copyWith => _$AvatarUserInfoCopyWithImpl<AvatarUserInfo>(this as AvatarUserInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems));
}


@override
int get hashCode => Object.hash(runtimeType,userId,age,gender,mascotSelected,mascotId,mascotUrl,const DeepCollectionEquality().hash(selectedItems));

@override
String toString() {
  return 'AvatarUserInfo(userId: $userId, age: $age, gender: $gender, mascotSelected: $mascotSelected, mascotId: $mascotId, mascotUrl: $mascotUrl, selectedItems: $selectedItems)';
}


}

/// @nodoc
abstract mixin class $AvatarUserInfoCopyWith<$Res>  {
  factory $AvatarUserInfoCopyWith(AvatarUserInfo value, $Res Function(AvatarUserInfo) _then) = _$AvatarUserInfoCopyWithImpl;
@useResult
$Res call({
 int userId, int age, String gender, bool mascotSelected, String? mascotId, String? mascotUrl, List<String> selectedItems
});




}
/// @nodoc
class _$AvatarUserInfoCopyWithImpl<$Res>
    implements $AvatarUserInfoCopyWith<$Res> {
  _$AvatarUserInfoCopyWithImpl(this._self, this._then);

  final AvatarUserInfo _self;
  final $Res Function(AvatarUserInfo) _then;

/// Create a copy of AvatarUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? age = null,Object? gender = null,Object? mascotSelected = null,Object? mascotId = freezed,Object? mascotUrl = freezed,Object? selectedItems = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotId: freezed == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String?,mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,selectedItems: null == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarUserInfo].
extension AvatarUserInfoPatterns on AvatarUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _AvatarUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int age,  String gender,  bool mascotSelected,  String? mascotId,  String? mascotUrl,  List<String> selectedItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarUserInfo() when $default != null:
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int age,  String gender,  bool mascotSelected,  String? mascotId,  String? mascotUrl,  List<String> selectedItems)  $default,) {final _that = this;
switch (_that) {
case _AvatarUserInfo():
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int age,  String gender,  bool mascotSelected,  String? mascotId,  String? mascotUrl,  List<String> selectedItems)?  $default,) {final _that = this;
switch (_that) {
case _AvatarUserInfo() when $default != null:
return $default(_that.userId,_that.age,_that.gender,_that.mascotSelected,_that.mascotId,_that.mascotUrl,_that.selectedItems);case _:
  return null;

}
}

}

/// @nodoc


class _AvatarUserInfo implements AvatarUserInfo {
  const _AvatarUserInfo({required this.userId, required this.age, required this.gender, required this.mascotSelected, this.mascotId, this.mascotUrl, final  List<String> selectedItems = const []}): _selectedItems = selectedItems;
  

@override final  int userId;
@override final  int age;
@override final  String gender;
@override final  bool mascotSelected;
@override final  String? mascotId;
@override final  String? mascotUrl;
 final  List<String> _selectedItems;
@override@JsonKey() List<String> get selectedItems {
  if (_selectedItems is EqualUnmodifiableListView) return _selectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedItems);
}


/// Create a copy of AvatarUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarUserInfoCopyWith<_AvatarUserInfo> get copyWith => __$AvatarUserInfoCopyWithImpl<_AvatarUserInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.mascotSelected, mascotSelected) || other.mascotSelected == mascotSelected)&&(identical(other.mascotId, mascotId) || other.mascotId == mascotId)&&(identical(other.mascotUrl, mascotUrl) || other.mascotUrl == mascotUrl)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems));
}


@override
int get hashCode => Object.hash(runtimeType,userId,age,gender,mascotSelected,mascotId,mascotUrl,const DeepCollectionEquality().hash(_selectedItems));

@override
String toString() {
  return 'AvatarUserInfo(userId: $userId, age: $age, gender: $gender, mascotSelected: $mascotSelected, mascotId: $mascotId, mascotUrl: $mascotUrl, selectedItems: $selectedItems)';
}


}

/// @nodoc
abstract mixin class _$AvatarUserInfoCopyWith<$Res> implements $AvatarUserInfoCopyWith<$Res> {
  factory _$AvatarUserInfoCopyWith(_AvatarUserInfo value, $Res Function(_AvatarUserInfo) _then) = __$AvatarUserInfoCopyWithImpl;
@override @useResult
$Res call({
 int userId, int age, String gender, bool mascotSelected, String? mascotId, String? mascotUrl, List<String> selectedItems
});




}
/// @nodoc
class __$AvatarUserInfoCopyWithImpl<$Res>
    implements _$AvatarUserInfoCopyWith<$Res> {
  __$AvatarUserInfoCopyWithImpl(this._self, this._then);

  final _AvatarUserInfo _self;
  final $Res Function(_AvatarUserInfo) _then;

/// Create a copy of AvatarUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? age = null,Object? gender = null,Object? mascotSelected = null,Object? mascotId = freezed,Object? mascotUrl = freezed,Object? selectedItems = null,}) {
  return _then(_AvatarUserInfo(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,mascotSelected: null == mascotSelected ? _self.mascotSelected : mascotSelected // ignore: cast_nullable_to_non_nullable
as bool,mascotId: freezed == mascotId ? _self.mascotId : mascotId // ignore: cast_nullable_to_non_nullable
as String?,mascotUrl: freezed == mascotUrl ? _self.mascotUrl : mascotUrl // ignore: cast_nullable_to_non_nullable
as String?,selectedItems: null == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
