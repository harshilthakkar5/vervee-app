
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/AuthModule.dart';
import '../../../../utils/NetworkResult.dart';

// TODO: adjust these import paths to match your project structure
// import 'package:vervee_academy/providers/auth_providers.dart'; // authRepositoryProvider
// import 'package:vervee_academy/core/network_result.dart';       // NetworkResult<T>

part 'ForgetPasswordViewModel.g.dart';

// ────────────────────────────────────────────────
// Forget Password ViewModel
// State type = NetworkResult<String> (String = server "message")
// Screen: ForgotPasswordScreen
// ────────────────────────────────────────────────
@riverpod
class ForgetPasswordViewModel extends _$ForgetPasswordViewModel {
  @override
  NetworkResult<String> build() => const NetworkResult.initial();

  Future<void> sendResetOtp({required String email}) async {
    // ✅ Validation pehle — API call se pehle
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      state = const NetworkResult.error(message: "Email is required.");
      return;
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      state = const NetworkResult.error(message: "Enter a valid email address.");
      return;
    }

    // ✅ Loading set karo
    state = const NetworkResult.loading();

    // ✅ Repository call — NetworkResult<String> return karta hai
    final result = await ref.read(authRepositoryProvider).forgetPassword(
      email: trimmedEmail,
    );

    // ✅ Direct assign — koi mapping nahi
    state = result;
  }

  /// Reset state back to initial (e.g. when leaving the screen or
  /// re-attempting after an error).
  void reset() => state = const NetworkResult.initial();
}