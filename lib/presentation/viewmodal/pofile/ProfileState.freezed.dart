// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ProfileState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileInfoState {

 UserProfile? get profile; bool get isLoading; bool get isUpdating;// Save Profile button ke liye
 String? get errorMessage; String? get successMessage;
/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileInfoStateCopyWith<ProfileInfoState> get copyWith => _$ProfileInfoStateCopyWithImpl<ProfileInfoState>(this as ProfileInfoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInfoState&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,profile,isLoading,isUpdating,errorMessage,successMessage);

@override
String toString() {
  return 'ProfileInfoState(profile: $profile, isLoading: $isLoading, isUpdating: $isUpdating, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileInfoStateCopyWith<$Res>  {
  factory $ProfileInfoStateCopyWith(ProfileInfoState value, $Res Function(ProfileInfoState) _then) = _$ProfileInfoStateCopyWithImpl;
@useResult
$Res call({
 UserProfile? profile, bool isLoading, bool isUpdating, String? errorMessage, String? successMessage
});


$UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ProfileInfoStateCopyWithImpl<$Res>
    implements $ProfileInfoStateCopyWith<$Res> {
  _$ProfileInfoStateCopyWithImpl(this._self, this._then);

  final ProfileInfoState _self;
  final $Res Function(ProfileInfoState) _then;

/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? isLoading = null,Object? isUpdating = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileInfoState].
extension ProfileInfoStatePatterns on ProfileInfoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileInfoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileInfoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileInfoState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileInfoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileInfoState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileInfoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserProfile? profile,  bool isLoading,  bool isUpdating,  String? errorMessage,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileInfoState() when $default != null:
return $default(_that.profile,_that.isLoading,_that.isUpdating,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserProfile? profile,  bool isLoading,  bool isUpdating,  String? errorMessage,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileInfoState():
return $default(_that.profile,_that.isLoading,_that.isUpdating,_that.errorMessage,_that.successMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserProfile? profile,  bool isLoading,  bool isUpdating,  String? errorMessage,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileInfoState() when $default != null:
return $default(_that.profile,_that.isLoading,_that.isUpdating,_that.errorMessage,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileInfoState implements ProfileInfoState {
  const _ProfileInfoState({this.profile, this.isLoading = false, this.isUpdating = false, this.errorMessage, this.successMessage});
  

@override final  UserProfile? profile;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isUpdating;
// Save Profile button ke liye
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileInfoStateCopyWith<_ProfileInfoState> get copyWith => __$ProfileInfoStateCopyWithImpl<_ProfileInfoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileInfoState&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,profile,isLoading,isUpdating,errorMessage,successMessage);

@override
String toString() {
  return 'ProfileInfoState(profile: $profile, isLoading: $isLoading, isUpdating: $isUpdating, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileInfoStateCopyWith<$Res> implements $ProfileInfoStateCopyWith<$Res> {
  factory _$ProfileInfoStateCopyWith(_ProfileInfoState value, $Res Function(_ProfileInfoState) _then) = __$ProfileInfoStateCopyWithImpl;
@override @useResult
$Res call({
 UserProfile? profile, bool isLoading, bool isUpdating, String? errorMessage, String? successMessage
});


@override $UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ProfileInfoStateCopyWithImpl<$Res>
    implements _$ProfileInfoStateCopyWith<$Res> {
  __$ProfileInfoStateCopyWithImpl(this._self, this._then);

  final _ProfileInfoState _self;
  final $Res Function(_ProfileInfoState) _then;

/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? isLoading = null,Object? isUpdating = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_ProfileInfoState(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileInfoState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
mixin _$ChangePasswordState {

 bool get isLoading; String? get errorMessage; String? get successMessage;
/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordStateCopyWith<ChangePasswordState> get copyWith => _$ChangePasswordStateCopyWithImpl<ChangePasswordState>(this as ChangePasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,successMessage);

@override
String toString() {
  return 'ChangePasswordState(isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordStateCopyWith<$Res>  {
  factory $ChangePasswordStateCopyWith(ChangePasswordState value, $Res Function(ChangePasswordState) _then) = _$ChangePasswordStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorMessage, String? successMessage
});




}
/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final ChangePasswordState _self;
  final $Res Function(ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordState].
extension ChangePasswordStatePatterns on ChangePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? errorMessage,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState():
return $default(_that.isLoading,_that.errorMessage,_that.successMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? errorMessage,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.isLoading,_that.errorMessage,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePasswordState implements ChangePasswordState {
  const _ChangePasswordState({this.isLoading = false, this.errorMessage, this.successMessage});
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePasswordStateCopyWith<_ChangePasswordState> get copyWith => __$ChangePasswordStateCopyWithImpl<_ChangePasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePasswordState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorMessage,successMessage);

@override
String toString() {
  return 'ChangePasswordState(isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$ChangePasswordStateCopyWith<$Res> implements $ChangePasswordStateCopyWith<$Res> {
  factory _$ChangePasswordStateCopyWith(_ChangePasswordState value, $Res Function(_ChangePasswordState) _then) = __$ChangePasswordStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorMessage, String? successMessage
});




}
/// @nodoc
class __$ChangePasswordStateCopyWithImpl<$Res>
    implements _$ChangePasswordStateCopyWith<$Res> {
  __$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final _ChangePasswordState _self;
  final $Res Function(_ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_ChangePasswordState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$UserFeedState {

 List<UserFeedPost> get posts; bool get isLoading; String? get errorMessage;
/// Create a copy of UserFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFeedStateCopyWith<UserFeedState> get copyWith => _$UserFeedStateCopyWithImpl<UserFeedState>(this as UserFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFeedState&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),isLoading,errorMessage);

@override
String toString() {
  return 'UserFeedState(posts: $posts, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $UserFeedStateCopyWith<$Res>  {
  factory $UserFeedStateCopyWith(UserFeedState value, $Res Function(UserFeedState) _then) = _$UserFeedStateCopyWithImpl;
@useResult
$Res call({
 List<UserFeedPost> posts, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$UserFeedStateCopyWithImpl<$Res>
    implements $UserFeedStateCopyWith<$Res> {
  _$UserFeedStateCopyWithImpl(this._self, this._then);

  final UserFeedState _self;
  final $Res Function(UserFeedState) _then;

/// Create a copy of UserFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<UserFeedPost>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFeedState].
extension UserFeedStatePatterns on UserFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFeedState value)  $default,){
final _that = this;
switch (_that) {
case _UserFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _UserFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserFeedPost> posts,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFeedState() when $default != null:
return $default(_that.posts,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserFeedPost> posts,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _UserFeedState():
return $default(_that.posts,_that.isLoading,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserFeedPost> posts,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _UserFeedState() when $default != null:
return $default(_that.posts,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _UserFeedState implements UserFeedState {
  const _UserFeedState({final  List<UserFeedPost> posts = const [], this.isLoading = false, this.errorMessage}): _posts = posts;
  

 final  List<UserFeedPost> _posts;
@override@JsonKey() List<UserFeedPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of UserFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFeedStateCopyWith<_UserFeedState> get copyWith => __$UserFeedStateCopyWithImpl<_UserFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFeedState&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),isLoading,errorMessage);

@override
String toString() {
  return 'UserFeedState(posts: $posts, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$UserFeedStateCopyWith<$Res> implements $UserFeedStateCopyWith<$Res> {
  factory _$UserFeedStateCopyWith(_UserFeedState value, $Res Function(_UserFeedState) _then) = __$UserFeedStateCopyWithImpl;
@override @useResult
$Res call({
 List<UserFeedPost> posts, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$UserFeedStateCopyWithImpl<$Res>
    implements _$UserFeedStateCopyWith<$Res> {
  __$UserFeedStateCopyWithImpl(this._self, this._then);

  final _UserFeedState _self;
  final $Res Function(_UserFeedState) _then;

/// Create a copy of UserFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_UserFeedState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<UserFeedPost>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SubscriptionState {

// GET /subscription/my-subscription
 SubscriptionInfo? get subscription; bool get isLoading; String? get errorMessage;// POST /subscription/customer-portal
 bool get isPortalLoading;// Manage Subscription button loading
 String? get portalErrorMessage; String? get portalUrl;// POST /subscription/create-checkout-session (NEW)
 bool get isCheckoutLoading; String? get checkoutErrorMessage; String? get checkoutUrl;// ── Promo checkout (NEW) ──────────────────────────────────────────
 bool get isPromoCheckoutLoading; String? get promoCheckoutErrorMessage; String? get promoCheckoutUrl;
/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<SubscriptionState> get copyWith => _$SubscriptionStateCopyWithImpl<SubscriptionState>(this as SubscriptionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isPortalLoading, isPortalLoading) || other.isPortalLoading == isPortalLoading)&&(identical(other.portalErrorMessage, portalErrorMessage) || other.portalErrorMessage == portalErrorMessage)&&(identical(other.portalUrl, portalUrl) || other.portalUrl == portalUrl)&&(identical(other.isCheckoutLoading, isCheckoutLoading) || other.isCheckoutLoading == isCheckoutLoading)&&(identical(other.checkoutErrorMessage, checkoutErrorMessage) || other.checkoutErrorMessage == checkoutErrorMessage)&&(identical(other.checkoutUrl, checkoutUrl) || other.checkoutUrl == checkoutUrl)&&(identical(other.isPromoCheckoutLoading, isPromoCheckoutLoading) || other.isPromoCheckoutLoading == isPromoCheckoutLoading)&&(identical(other.promoCheckoutErrorMessage, promoCheckoutErrorMessage) || other.promoCheckoutErrorMessage == promoCheckoutErrorMessage)&&(identical(other.promoCheckoutUrl, promoCheckoutUrl) || other.promoCheckoutUrl == promoCheckoutUrl));
}


@override
int get hashCode => Object.hash(runtimeType,subscription,isLoading,errorMessage,isPortalLoading,portalErrorMessage,portalUrl,isCheckoutLoading,checkoutErrorMessage,checkoutUrl,isPromoCheckoutLoading,promoCheckoutErrorMessage,promoCheckoutUrl);

@override
String toString() {
  return 'SubscriptionState(subscription: $subscription, isLoading: $isLoading, errorMessage: $errorMessage, isPortalLoading: $isPortalLoading, portalErrorMessage: $portalErrorMessage, portalUrl: $portalUrl, isCheckoutLoading: $isCheckoutLoading, checkoutErrorMessage: $checkoutErrorMessage, checkoutUrl: $checkoutUrl, isPromoCheckoutLoading: $isPromoCheckoutLoading, promoCheckoutErrorMessage: $promoCheckoutErrorMessage, promoCheckoutUrl: $promoCheckoutUrl)';
}


}

/// @nodoc
abstract mixin class $SubscriptionStateCopyWith<$Res>  {
  factory $SubscriptionStateCopyWith(SubscriptionState value, $Res Function(SubscriptionState) _then) = _$SubscriptionStateCopyWithImpl;
@useResult
$Res call({
 SubscriptionInfo? subscription, bool isLoading, String? errorMessage, bool isPortalLoading, String? portalErrorMessage, String? portalUrl, bool isCheckoutLoading, String? checkoutErrorMessage, String? checkoutUrl, bool isPromoCheckoutLoading, String? promoCheckoutErrorMessage, String? promoCheckoutUrl
});




}
/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._self, this._then);

  final SubscriptionState _self;
  final $Res Function(SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscription = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? isPortalLoading = null,Object? portalErrorMessage = freezed,Object? portalUrl = freezed,Object? isCheckoutLoading = null,Object? checkoutErrorMessage = freezed,Object? checkoutUrl = freezed,Object? isPromoCheckoutLoading = null,Object? promoCheckoutErrorMessage = freezed,Object? promoCheckoutUrl = freezed,}) {
  return _then(_self.copyWith(
subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionInfo?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isPortalLoading: null == isPortalLoading ? _self.isPortalLoading : isPortalLoading // ignore: cast_nullable_to_non_nullable
as bool,portalErrorMessage: freezed == portalErrorMessage ? _self.portalErrorMessage : portalErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,portalUrl: freezed == portalUrl ? _self.portalUrl : portalUrl // ignore: cast_nullable_to_non_nullable
as String?,isCheckoutLoading: null == isCheckoutLoading ? _self.isCheckoutLoading : isCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,checkoutErrorMessage: freezed == checkoutErrorMessage ? _self.checkoutErrorMessage : checkoutErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,checkoutUrl: freezed == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoCheckoutLoading: null == isPromoCheckoutLoading ? _self.isPromoCheckoutLoading : isPromoCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,promoCheckoutErrorMessage: freezed == promoCheckoutErrorMessage ? _self.promoCheckoutErrorMessage : promoCheckoutErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,promoCheckoutUrl: freezed == promoCheckoutUrl ? _self.promoCheckoutUrl : promoCheckoutUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionState value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionState value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SubscriptionInfo? subscription,  bool isLoading,  String? errorMessage,  bool isPortalLoading,  String? portalErrorMessage,  String? portalUrl,  bool isCheckoutLoading,  String? checkoutErrorMessage,  String? checkoutUrl,  bool isPromoCheckoutLoading,  String? promoCheckoutErrorMessage,  String? promoCheckoutUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.subscription,_that.isLoading,_that.errorMessage,_that.isPortalLoading,_that.portalErrorMessage,_that.portalUrl,_that.isCheckoutLoading,_that.checkoutErrorMessage,_that.checkoutUrl,_that.isPromoCheckoutLoading,_that.promoCheckoutErrorMessage,_that.promoCheckoutUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SubscriptionInfo? subscription,  bool isLoading,  String? errorMessage,  bool isPortalLoading,  String? portalErrorMessage,  String? portalUrl,  bool isCheckoutLoading,  String? checkoutErrorMessage,  String? checkoutUrl,  bool isPromoCheckoutLoading,  String? promoCheckoutErrorMessage,  String? promoCheckoutUrl)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState():
return $default(_that.subscription,_that.isLoading,_that.errorMessage,_that.isPortalLoading,_that.portalErrorMessage,_that.portalUrl,_that.isCheckoutLoading,_that.checkoutErrorMessage,_that.checkoutUrl,_that.isPromoCheckoutLoading,_that.promoCheckoutErrorMessage,_that.promoCheckoutUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SubscriptionInfo? subscription,  bool isLoading,  String? errorMessage,  bool isPortalLoading,  String? portalErrorMessage,  String? portalUrl,  bool isCheckoutLoading,  String? checkoutErrorMessage,  String? checkoutUrl,  bool isPromoCheckoutLoading,  String? promoCheckoutErrorMessage,  String? promoCheckoutUrl)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.subscription,_that.isLoading,_that.errorMessage,_that.isPortalLoading,_that.portalErrorMessage,_that.portalUrl,_that.isCheckoutLoading,_that.checkoutErrorMessage,_that.checkoutUrl,_that.isPromoCheckoutLoading,_that.promoCheckoutErrorMessage,_that.promoCheckoutUrl);case _:
  return null;

}
}

}

/// @nodoc


class _SubscriptionState implements SubscriptionState {
  const _SubscriptionState({this.subscription, this.isLoading = false, this.errorMessage, this.isPortalLoading = false, this.portalErrorMessage, this.portalUrl, this.isCheckoutLoading = false, this.checkoutErrorMessage, this.checkoutUrl, this.isPromoCheckoutLoading = false, this.promoCheckoutErrorMessage, this.promoCheckoutUrl});
  

// GET /subscription/my-subscription
@override final  SubscriptionInfo? subscription;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
// POST /subscription/customer-portal
@override@JsonKey() final  bool isPortalLoading;
// Manage Subscription button loading
@override final  String? portalErrorMessage;
@override final  String? portalUrl;
// POST /subscription/create-checkout-session (NEW)
@override@JsonKey() final  bool isCheckoutLoading;
@override final  String? checkoutErrorMessage;
@override final  String? checkoutUrl;
// ── Promo checkout (NEW) ──────────────────────────────────────────
@override@JsonKey() final  bool isPromoCheckoutLoading;
@override final  String? promoCheckoutErrorMessage;
@override final  String? promoCheckoutUrl;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionStateCopyWith<_SubscriptionState> get copyWith => __$SubscriptionStateCopyWithImpl<_SubscriptionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionState&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isPortalLoading, isPortalLoading) || other.isPortalLoading == isPortalLoading)&&(identical(other.portalErrorMessage, portalErrorMessage) || other.portalErrorMessage == portalErrorMessage)&&(identical(other.portalUrl, portalUrl) || other.portalUrl == portalUrl)&&(identical(other.isCheckoutLoading, isCheckoutLoading) || other.isCheckoutLoading == isCheckoutLoading)&&(identical(other.checkoutErrorMessage, checkoutErrorMessage) || other.checkoutErrorMessage == checkoutErrorMessage)&&(identical(other.checkoutUrl, checkoutUrl) || other.checkoutUrl == checkoutUrl)&&(identical(other.isPromoCheckoutLoading, isPromoCheckoutLoading) || other.isPromoCheckoutLoading == isPromoCheckoutLoading)&&(identical(other.promoCheckoutErrorMessage, promoCheckoutErrorMessage) || other.promoCheckoutErrorMessage == promoCheckoutErrorMessage)&&(identical(other.promoCheckoutUrl, promoCheckoutUrl) || other.promoCheckoutUrl == promoCheckoutUrl));
}


@override
int get hashCode => Object.hash(runtimeType,subscription,isLoading,errorMessage,isPortalLoading,portalErrorMessage,portalUrl,isCheckoutLoading,checkoutErrorMessage,checkoutUrl,isPromoCheckoutLoading,promoCheckoutErrorMessage,promoCheckoutUrl);

@override
String toString() {
  return 'SubscriptionState(subscription: $subscription, isLoading: $isLoading, errorMessage: $errorMessage, isPortalLoading: $isPortalLoading, portalErrorMessage: $portalErrorMessage, portalUrl: $portalUrl, isCheckoutLoading: $isCheckoutLoading, checkoutErrorMessage: $checkoutErrorMessage, checkoutUrl: $checkoutUrl, isPromoCheckoutLoading: $isPromoCheckoutLoading, promoCheckoutErrorMessage: $promoCheckoutErrorMessage, promoCheckoutUrl: $promoCheckoutUrl)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionStateCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$SubscriptionStateCopyWith(_SubscriptionState value, $Res Function(_SubscriptionState) _then) = __$SubscriptionStateCopyWithImpl;
@override @useResult
$Res call({
 SubscriptionInfo? subscription, bool isLoading, String? errorMessage, bool isPortalLoading, String? portalErrorMessage, String? portalUrl, bool isCheckoutLoading, String? checkoutErrorMessage, String? checkoutUrl, bool isPromoCheckoutLoading, String? promoCheckoutErrorMessage, String? promoCheckoutUrl
});




}
/// @nodoc
class __$SubscriptionStateCopyWithImpl<$Res>
    implements _$SubscriptionStateCopyWith<$Res> {
  __$SubscriptionStateCopyWithImpl(this._self, this._then);

  final _SubscriptionState _self;
  final $Res Function(_SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscription = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? isPortalLoading = null,Object? portalErrorMessage = freezed,Object? portalUrl = freezed,Object? isCheckoutLoading = null,Object? checkoutErrorMessage = freezed,Object? checkoutUrl = freezed,Object? isPromoCheckoutLoading = null,Object? promoCheckoutErrorMessage = freezed,Object? promoCheckoutUrl = freezed,}) {
  return _then(_SubscriptionState(
subscription: freezed == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as SubscriptionInfo?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isPortalLoading: null == isPortalLoading ? _self.isPortalLoading : isPortalLoading // ignore: cast_nullable_to_non_nullable
as bool,portalErrorMessage: freezed == portalErrorMessage ? _self.portalErrorMessage : portalErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,portalUrl: freezed == portalUrl ? _self.portalUrl : portalUrl // ignore: cast_nullable_to_non_nullable
as String?,isCheckoutLoading: null == isCheckoutLoading ? _self.isCheckoutLoading : isCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,checkoutErrorMessage: freezed == checkoutErrorMessage ? _self.checkoutErrorMessage : checkoutErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,checkoutUrl: freezed == checkoutUrl ? _self.checkoutUrl : checkoutUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoCheckoutLoading: null == isPromoCheckoutLoading ? _self.isPromoCheckoutLoading : isPromoCheckoutLoading // ignore: cast_nullable_to_non_nullable
as bool,promoCheckoutErrorMessage: freezed == promoCheckoutErrorMessage ? _self.promoCheckoutErrorMessage : promoCheckoutErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,promoCheckoutUrl: freezed == promoCheckoutUrl ? _self.promoCheckoutUrl : promoCheckoutUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
