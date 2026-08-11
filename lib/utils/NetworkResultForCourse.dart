
sealed class NetworkResult<T> {
  const NetworkResult();

  factory NetworkResult.success(T data) = Success<T>;
  factory NetworkResult.error({required String message, int? statusCode}) =
  Failure<T>;
}

class Success<T> extends NetworkResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends NetworkResult<T> {
  final String message;
  final int? statusCode;
  const Failure({required this.message, this.statusCode});
}