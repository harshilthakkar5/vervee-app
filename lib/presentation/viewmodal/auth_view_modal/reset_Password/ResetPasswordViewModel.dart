
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/AuthModule.dart';
import '../../../../utils/NetworkResult.dart';

// TODO: adjust these import paths to match your project structure
// import 'package:vervee_academy/providers/auth_providers.dart'; // authRepositoryProvider
// import 'package:vervee_academy/core/network_result.dart';       // NetworkResult<T>

part 'ResetPasswordViewModel.g.dart';

// ────────────────────────────────────────────────
// Reset Password ViewModel
// State type = NetworkResult<String> (String = server "message")
// Screen: ResetPasswordScreen
// ────────────────────────────────────────────────
@riverpod
class ResetPasswordViewModel extends _$ResetPasswordViewModel {
  @override
  NetworkResult<String> build() => const NetworkResult.initial();

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // ✅ Validation pehle — API call se pehle
    final trimmedOtp = otp.trim();
    if (trimmedOtp.isEmpty) {
      state = const NetworkResult.error(message: "Please enter the OTP.");
      return;
    }
    if (newPassword.length < 8) {
      state = const NetworkResult.error(message: "Password must be at least 8 characters.");
      return;
    }
    if (newPassword != confirmPassword) {
      state = const NetworkResult.error(message: "Passwords do not match.");
      return;
    }

    // ✅ Loading set karo
    state = const NetworkResult.loading();

    // ✅ Repository call
    final result = await ref.read(authRepositoryProvider).resetPassword(
      email: email,
      otp: trimmedOtp,
      newPassword: newPassword,
    );

    state = result;
  }

  void reset() => state = const NetworkResult.initial();
}