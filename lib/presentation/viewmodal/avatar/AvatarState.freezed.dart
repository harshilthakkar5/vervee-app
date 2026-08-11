// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AvatarState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvatarState {

// ── User info (GET pe aata hai) ─────────────────────────────────────────
 AvatarUserInfo? get userInfo;// ── Current generated mascot URL (POST ke baad aata hai) ───────────────
 String? get generatedMascotUrl; String? get generatedMascotId;// ── Loading states ──────────────────────────────────────────────────────
 bool get isLoadingInfo;// GET user-info
 bool get isSelectingMascot;// POST select-mascot
 bool get isGenerating;// POST customize (Generate btn)
// ── Success flags ───────────────────────────────────────────────────────
 bool get mascotSaved;// select-mascot success
 bool get customizeSuccess;// customize success
// ── Error ───────────────────────────────────────────────────────────────
 String? get errorMessage;
/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarStateCopyWith<AvatarState> get copyWith => _$AvatarStateCopyWithImpl<AvatarState>(this as AvatarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarState&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.generatedMascotUrl, generatedMascotUrl) || other.generatedMascotUrl == generatedMascotUrl)&&(identical(other.generatedMascotId, generatedMascotId) || other.generatedMascotId == generatedMascotId)&&(identical(other.isLoadingInfo, isLoadingInfo) || other.isLoadingInfo == isLoadingInfo)&&(identical(other.isSelectingMascot, isSelectingMascot) || other.isSelectingMascot == isSelectingMascot)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.mascotSaved, mascotSaved) || other.mascotSaved == mascotSaved)&&(identical(other.customizeSuccess, customizeSuccess) || other.customizeSuccess == customizeSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,userInfo,generatedMascotUrl,generatedMascotId,isLoadingInfo,isSelectingMascot,isGenerating,mascotSaved,customizeSuccess,errorMessage);

@override
String toString() {
  return 'AvatarState(userInfo: $userInfo, generatedMascotUrl: $generatedMascotUrl, generatedMascotId: $generatedMascotId, isLoadingInfo: $isLoadingInfo, isSelectingMascot: $isSelectingMascot, isGenerating: $isGenerating, mascotSaved: $mascotSaved, customizeSuccess: $customizeSuccess, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AvatarStateCopyWith<$Res>  {
  factory $AvatarStateCopyWith(AvatarState value, $Res Function(AvatarState) _then) = _$AvatarStateCopyWithImpl;
@useResult
$Res call({
 AvatarUserInfo? userInfo, String? generatedMascotUrl, String? generatedMascotId, bool isLoadingInfo, bool isSelectingMascot, bool isGenerating, bool mascotSaved, bool customizeSuccess, String? errorMessage
});


$AvatarUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class _$AvatarStateCopyWithImpl<$Res>
    implements $AvatarStateCopyWith<$Res> {
  _$AvatarStateCopyWithImpl(this._self, this._then);

  final AvatarState _self;
  final $Res Function(AvatarState) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userInfo = freezed,Object? generatedMascotUrl = freezed,Object? generatedMascotId = freezed,Object? isLoadingInfo = null,Object? isSelectingMascot = null,Object? isGenerating = null,Object? mascotSaved = null,Object? customizeSuccess = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as AvatarUserInfo?,generatedMascotUrl: freezed == generatedMascotUrl ? _self.generatedMascotUrl : generatedMascotUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedMascotId: freezed == generatedMascotId ? _self.generatedMascotId : generatedMascotId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingInfo: null == isLoadingInfo ? _self.isLoadingInfo : isLoadingInfo // ignore: cast_nullable_to_non_nullable
as bool,isSelectingMascot: null == isSelectingMascot ? _self.isSelectingMascot : isSelectingMascot // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,mascotSaved: null == mascotSaved ? _self.mascotSaved : mascotSaved // ignore: cast_nullable_to_non_nullable
as bool,customizeSuccess: null == customizeSuccess ? _self.customizeSuccess : customizeSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $AvatarUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [AvatarState].
extension AvatarStatePatterns on AvatarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarState value)  $default,){
final _that = this;
switch (_that) {
case _AvatarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarState value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AvatarUserInfo? userInfo,  String? generatedMascotUrl,  String? generatedMascotId,  bool isLoadingInfo,  bool isSelectingMascot,  bool isGenerating,  bool mascotSaved,  bool customizeSuccess,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
return $default(_that.userInfo,_that.generatedMascotUrl,_that.generatedMascotId,_that.isLoadingInfo,_that.isSelectingMascot,_that.isGenerating,_that.mascotSaved,_that.customizeSuccess,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AvatarUserInfo? userInfo,  String? generatedMascotUrl,  String? generatedMascotId,  bool isLoadingInfo,  bool isSelectingMascot,  bool isGenerating,  bool mascotSaved,  bool customizeSuccess,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AvatarState():
return $default(_that.userInfo,_that.generatedMascotUrl,_that.generatedMascotId,_that.isLoadingInfo,_that.isSelectingMascot,_that.isGenerating,_that.mascotSaved,_that.customizeSuccess,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AvatarUserInfo? userInfo,  String? generatedMascotUrl,  String? generatedMascotId,  bool isLoadingInfo,  bool isSelectingMascot,  bool isGenerating,  bool mascotSaved,  bool customizeSuccess,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AvatarState() when $default != null:
return $default(_that.userInfo,_that.generatedMascotUrl,_that.generatedMascotId,_that.isLoadingInfo,_that.isSelectingMascot,_that.isGenerating,_that.mascotSaved,_that.customizeSuccess,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AvatarState implements AvatarState {
  const _AvatarState({this.userInfo, this.generatedMascotUrl, this.generatedMascotId, this.isLoadingInfo = false, this.isSelectingMascot = false, this.isGenerating = false, this.mascotSaved = false, this.customizeSuccess = false, this.errorMessage});
  

// ── User info (GET pe aata hai) ─────────────────────────────────────────
@override final  AvatarUserInfo? userInfo;
// ── Current generated mascot URL (POST ke baad aata hai) ───────────────
@override final  String? generatedMascotUrl;
@override final  String? generatedMascotId;
// ── Loading states ──────────────────────────────────────────────────────
@override@JsonKey() final  bool isLoadingInfo;
// GET user-info
@override@JsonKey() final  bool isSelectingMascot;
// POST select-mascot
@override@JsonKey() final  bool isGenerating;
// POST customize (Generate btn)
// ── Success flags ───────────────────────────────────────────────────────
@override@JsonKey() final  bool mascotSaved;
// select-mascot success
@override@JsonKey() final  bool customizeSuccess;
// customize success
// ── Error ───────────────────────────────────────────────────────────────
@override final  String? errorMessage;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarStateCopyWith<_AvatarState> get copyWith => __$AvatarStateCopyWithImpl<_AvatarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarState&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.generatedMascotUrl, generatedMascotUrl) || other.generatedMascotUrl == generatedMascotUrl)&&(identical(other.generatedMascotId, generatedMascotId) || other.generatedMascotId == generatedMascotId)&&(identical(other.isLoadingInfo, isLoadingInfo) || other.isLoadingInfo == isLoadingInfo)&&(identical(other.isSelectingMascot, isSelectingMascot) || other.isSelectingMascot == isSelectingMascot)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.mascotSaved, mascotSaved) || other.mascotSaved == mascotSaved)&&(identical(other.customizeSuccess, customizeSuccess) || other.customizeSuccess == customizeSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,userInfo,generatedMascotUrl,generatedMascotId,isLoadingInfo,isSelectingMascot,isGenerating,mascotSaved,customizeSuccess,errorMessage);

@override
String toString() {
  return 'AvatarState(userInfo: $userInfo, generatedMascotUrl: $generatedMascotUrl, generatedMascotId: $generatedMascotId, isLoadingInfo: $isLoadingInfo, isSelectingMascot: $isSelectingMascot, isGenerating: $isGenerating, mascotSaved: $mascotSaved, customizeSuccess: $customizeSuccess, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AvatarStateCopyWith<$Res> implements $AvatarStateCopyWith<$Res> {
  factory _$AvatarStateCopyWith(_AvatarState value, $Res Function(_AvatarState) _then) = __$AvatarStateCopyWithImpl;
@override @useResult
$Res call({
 AvatarUserInfo? userInfo, String? generatedMascotUrl, String? generatedMascotId, bool isLoadingInfo, bool isSelectingMascot, bool isGenerating, bool mascotSaved, bool customizeSuccess, String? errorMessage
});


@override $AvatarUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class __$AvatarStateCopyWithImpl<$Res>
    implements _$AvatarStateCopyWith<$Res> {
  __$AvatarStateCopyWithImpl(this._self, this._then);

  final _AvatarState _self;
  final $Res Function(_AvatarState) _then;

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userInfo = freezed,Object? generatedMascotUrl = freezed,Object? generatedMascotId = freezed,Object? isLoadingInfo = null,Object? isSelectingMascot = null,Object? isGenerating = null,Object? mascotSaved = null,Object? customizeSuccess = null,Object? errorMessage = freezed,}) {
  return _then(_AvatarState(
userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as AvatarUserInfo?,generatedMascotUrl: freezed == generatedMascotUrl ? _self.generatedMascotUrl : generatedMascotUrl // ignore: cast_nullable_to_non_nullable
as String?,generatedMascotId: freezed == generatedMascotId ? _self.generatedMascotId : generatedMascotId // ignore: cast_nullable_to_non_nullable
as String?,isLoadingInfo: null == isLoadingInfo ? _self.isLoadingInfo : isLoadingInfo // ignore: cast_nullable_to_non_nullable
as bool,isSelectingMascot: null == isSelectingMascot ? _self.isSelectingMascot : isSelectingMascot // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,mascotSaved: null == mascotSaved ? _self.mascotSaved : mascotSaved // ignore: cast_nullable_to_non_nullable
as bool,customizeSuccess: null == customizeSuccess ? _self.customizeSuccess : customizeSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AvatarState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvatarUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $AvatarUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
