// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserRegistrationRequest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRegistrationRequest {

@JsonKey(name: "name") String get name;@JsonKey(name: "email") String get email;@JsonKey(name: "password") String get password;@JsonKey(name: "confirmPassword") String get confirmPassword;@JsonKey(name: "age") String get age;@JsonKey(name: "country") String get country;@JsonKey(name: "gender") String? get gender;@JsonKey(name: "phoneNo") String get phoneNo;@JsonKey(name: "terms") bool get terms;@JsonKey(name: "parentEmail") String? get parentEmail;@JsonKey(name: "referralCode") String? get referralCode;@JsonKey(name: "referKey") String? get referKey;
/// Create a copy of UserRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRegistrationRequestCopyWith<UserRegistrationRequest> get copyWith => _$UserRegistrationRequestCopyWithImpl<UserRegistrationRequest>(this as UserRegistrationRequest, _$identity);

  /// Serializes this UserRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRegistrationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.age, age) || other.age == age)&&(identical(other.country, country) || other.country == country)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.terms, terms) || other.terms == terms)&&(identical(other.parentEmail, parentEmail) || other.parentEmail == parentEmail)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.referKey, referKey) || other.referKey == referKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,password,confirmPassword,age,country,gender,phoneNo,terms,parentEmail,referralCode,referKey);

@override
String toString() {
  return 'UserRegistrationRequest(name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, age: $age, country: $country, gender: $gender, phoneNo: $phoneNo, terms: $terms, parentEmail: $parentEmail, referralCode: $referralCode, referKey: $referKey)';
}


}

/// @nodoc
abstract mixin class $UserRegistrationRequestCopyWith<$Res>  {
  factory $UserRegistrationRequestCopyWith(UserRegistrationRequest value, $Res Function(UserRegistrationRequest) _then) = _$UserRegistrationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "password") String password,@JsonKey(name: "confirmPassword") String confirmPassword,@JsonKey(name: "age") String age,@JsonKey(name: "country") String country,@JsonKey(name: "gender") String? gender,@JsonKey(name: "phoneNo") String phoneNo,@JsonKey(name: "terms") bool terms,@JsonKey(name: "parentEmail") String? parentEmail,@JsonKey(name: "referralCode") String? referralCode,@JsonKey(name: "referKey") String? referKey
});




}
/// @nodoc
class _$UserRegistrationRequestCopyWithImpl<$Res>
    implements $UserRegistrationRequestCopyWith<$Res> {
  _$UserRegistrationRequestCopyWithImpl(this._self, this._then);

  final UserRegistrationRequest _self;
  final $Res Function(UserRegistrationRequest) _then;

/// Create a copy of UserRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? password = null,Object? confirmPassword = null,Object? age = null,Object? country = null,Object? gender = freezed,Object? phoneNo = null,Object? terms = null,Object? parentEmail = freezed,Object? referralCode = freezed,Object? referKey = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,terms: null == terms ? _self.terms : terms // ignore: cast_nullable_to_non_nullable
as bool,parentEmail: freezed == parentEmail ? _self.parentEmail : parentEmail // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,referKey: freezed == referKey ? _self.referKey : referKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRegistrationRequest].
extension UserRegistrationRequestPatterns on UserRegistrationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRegistrationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRegistrationRequest value)  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRegistrationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UserRegistrationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "password")  String password, @JsonKey(name: "confirmPassword")  String confirmPassword, @JsonKey(name: "age")  String age, @JsonKey(name: "country")  String country, @JsonKey(name: "gender")  String? gender, @JsonKey(name: "phoneNo")  String phoneNo, @JsonKey(name: "terms")  bool terms, @JsonKey(name: "parentEmail")  String? parentEmail, @JsonKey(name: "referralCode")  String? referralCode, @JsonKey(name: "referKey")  String? referKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRegistrationRequest() when $default != null:
return $default(_that.name,_that.email,_that.password,_that.confirmPassword,_that.age,_that.country,_that.gender,_that.phoneNo,_that.terms,_that.parentEmail,_that.referralCode,_that.referKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "password")  String password, @JsonKey(name: "confirmPassword")  String confirmPassword, @JsonKey(name: "age")  String age, @JsonKey(name: "country")  String country, @JsonKey(name: "gender")  String? gender, @JsonKey(name: "phoneNo")  String phoneNo, @JsonKey(name: "terms")  bool terms, @JsonKey(name: "parentEmail")  String? parentEmail, @JsonKey(name: "referralCode")  String? referralCode, @JsonKey(name: "referKey")  String? referKey)  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationRequest():
return $default(_that.name,_that.email,_that.password,_that.confirmPassword,_that.age,_that.country,_that.gender,_that.phoneNo,_that.terms,_that.parentEmail,_that.referralCode,_that.referKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "name")  String name, @JsonKey(name: "email")  String email, @JsonKey(name: "password")  String password, @JsonKey(name: "confirmPassword")  String confirmPassword, @JsonKey(name: "age")  String age, @JsonKey(name: "country")  String country, @JsonKey(name: "gender")  String? gender, @JsonKey(name: "phoneNo")  String phoneNo, @JsonKey(name: "terms")  bool terms, @JsonKey(name: "parentEmail")  String? parentEmail, @JsonKey(name: "referralCode")  String? referralCode, @JsonKey(name: "referKey")  String? referKey)?  $default,) {final _that = this;
switch (_that) {
case _UserRegistrationRequest() when $default != null:
return $default(_that.name,_that.email,_that.password,_that.confirmPassword,_that.age,_that.country,_that.gender,_that.phoneNo,_that.terms,_that.parentEmail,_that.referralCode,_that.referKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRegistrationRequest implements UserRegistrationRequest {
  const _UserRegistrationRequest({@JsonKey(name: "name") required this.name, @JsonKey(name: "email") required this.email, @JsonKey(name: "password") required this.password, @JsonKey(name: "confirmPassword") required this.confirmPassword, @JsonKey(name: "age") required this.age, @JsonKey(name: "country") required this.country, @JsonKey(name: "gender") this.gender, @JsonKey(name: "phoneNo") required this.phoneNo, @JsonKey(name: "terms") required this.terms, @JsonKey(name: "parentEmail") this.parentEmail, @JsonKey(name: "referralCode") this.referralCode, @JsonKey(name: "referKey") this.referKey});
  factory _UserRegistrationRequest.fromJson(Map<String, dynamic> json) => _$UserRegistrationRequestFromJson(json);

@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "email") final  String email;
@override@JsonKey(name: "password") final  String password;
@override@JsonKey(name: "confirmPassword") final  String confirmPassword;
@override@JsonKey(name: "age") final  String age;
@override@JsonKey(name: "country") final  String country;
@override@JsonKey(name: "gender") final  String? gender;
@override@JsonKey(name: "phoneNo") final  String phoneNo;
@override@JsonKey(name: "terms") final  bool terms;
@override@JsonKey(name: "parentEmail") final  String? parentEmail;
@override@JsonKey(name: "referralCode") final  String? referralCode;
@override@JsonKey(name: "referKey") final  String? referKey;

/// Create a copy of UserRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRegistrationRequestCopyWith<_UserRegistrationRequest> get copyWith => __$UserRegistrationRequestCopyWithImpl<_UserRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRegistrationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.age, age) || other.age == age)&&(identical(other.country, country) || other.country == country)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.terms, terms) || other.terms == terms)&&(identical(other.parentEmail, parentEmail) || other.parentEmail == parentEmail)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.referKey, referKey) || other.referKey == referKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,password,confirmPassword,age,country,gender,phoneNo,terms,parentEmail,referralCode,referKey);

@override
String toString() {
  return 'UserRegistrationRequest(name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, age: $age, country: $country, gender: $gender, phoneNo: $phoneNo, terms: $terms, parentEmail: $parentEmail, referralCode: $referralCode, referKey: $referKey)';
}


}

/// @nodoc
abstract mixin class _$UserRegistrationRequestCopyWith<$Res> implements $UserRegistrationRequestCopyWith<$Res> {
  factory _$UserRegistrationRequestCopyWith(_UserRegistrationRequest value, $Res Function(_UserRegistrationRequest) _then) = __$UserRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "email") String email,@JsonKey(name: "password") String password,@JsonKey(name: "confirmPassword") String confirmPassword,@JsonKey(name: "age") String age,@JsonKey(name: "country") String country,@JsonKey(name: "gender") String? gender,@JsonKey(name: "phoneNo") String phoneNo,@JsonKey(name: "terms") bool terms,@JsonKey(name: "parentEmail") String? parentEmail,@JsonKey(name: "referralCode") String? referralCode,@JsonKey(name: "referKey") String? referKey
});




}
/// @nodoc
class __$UserRegistrationRequestCopyWithImpl<$Res>
    implements _$UserRegistrationRequestCopyWith<$Res> {
  __$UserRegistrationRequestCopyWithImpl(this._self, this._then);

  final _UserRegistrationRequest _self;
  final $Res Function(_UserRegistrationRequest) _then;

/// Create a copy of UserRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,Object? confirmPassword = null,Object? age = null,Object? country = null,Object? gender = freezed,Object? phoneNo = null,Object? terms = null,Object? parentEmail = freezed,Object? referralCode = freezed,Object? referKey = freezed,}) {
  return _then(_UserRegistrationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,terms: null == terms ? _self.terms : terms // ignore: cast_nullable_to_non_nullable
as bool,parentEmail: freezed == parentEmail ? _self.parentEmail : parentEmail // ignore: cast_nullable_to_non_nullable
as String?,referralCode: freezed == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String?,referKey: freezed == referKey ? _self.referKey : referKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
