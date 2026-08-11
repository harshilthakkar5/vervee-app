import 'package:freezed_annotation/freezed_annotation.dart';

part 'OtpResult.freezed.dart';

// ✅ OTP verification ka result
// Same pattern — success NetworkResult handle karega
// Sirf message Domain Model me

@freezed
abstract class OtpResult with _$OtpResult {
  const factory OtpResult({
    required String message, // "OTP verified successfully!"
  }) = _OtpResult;
}