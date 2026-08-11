import 'package:freezed_annotation/freezed_annotation.dart';

part 'NetworkResult.freezed.dart';

// @freezed
// sealed class NetworkResult<T> with _$NetworkResult<T> {
//   const factory NetworkResult.success(T data) = Success<T>;
//   const factory NetworkResult.error({required String message, int? statusCode,}) = Error<T>;
//   //const factory NetworkResult.loading() = Loading<T>;
// }


// ✅ Ek hi class — Repository, ViewModel, aur UI sab jagah use hogi
// ✅ Android ke sealed class jaisa pattern — Flutter mein bhi same approach
@freezed
sealed class NetworkResult<T> with _$NetworkResult<T> {

  // ✅ API success — data mil gaya
  const factory NetworkResult.success(T data) = Success<T>;

  // ✅ API fail — message dikhao
  const factory NetworkResult.error({required String message, int? statusCode,}) = Error<T>;

  // ✅ API call chal rahi hai — button disable, loader dikhao
  const factory NetworkResult.loading() = Loading<T>;

  // ✅ App open hote hi ya screen init pe — koi action nahi hua abhi
  const factory NetworkResult.initial() = Initial<T>;
}