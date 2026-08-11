import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// ✅ Tere project ke actual paths
import '../../../../di/AuthModule.dart';
import '../../../../domain/model/user/AuthUser.dart';
import '../../../../utils/AuthService.dart';
import '../../../../utils/NetworkResult.dart';
// import '../../di/AuthModule.dart';
// import '../../domain/model/user/AuthUser.dart';
// import '../../utils/NetworkResult.dart';

//part 'LoginViewModel.freezed.dart';
part 'LoginViewModel.g.dart';
// ────────────────────────────────────────
// States — har screen ke liye alag state
// ────────────────────────────────────────

// // ✅ Login State
// @freezed
// abstract class LoginState with _$LoginState {
//   const factory LoginState.initial() = _LoginInitial;
//   const factory LoginState.loading() = _LoginLoading;
//   const factory LoginState.success(AuthUser user) = _LoginSuccess;
//   const factory LoginState.error(String message) = _LoginError;
// }
//
// // ────────────────────────────────────────
// // Login ViewModel
// // ────────────────────────────────────────
//
// @riverpod
// class LoginViewModel extends _$LoginViewModel {
//
//   @override
//   LoginState build() => const LoginState.initial();
//
//   Future<void> login({
//     required String email,
//     required String password,
//   }) async {
//
//     // ✅ Validation
//     if (email.trim().isEmpty || password.isEmpty) {
//       state = const LoginState.error("Email and password required.");
//       return;
//     }
//
//     state = const LoginState.loading();
//
//     final result = await ref.read(authRepositoryProvider).login(
//       email: email.trim(),
//       password: password,
//     );
//
//     switch (result) {
//       case Success(:final data):
//         state = LoginState.success(data);
//       case Error(:final message):
//         state = LoginState.error(message);
//     }
//   }
// }

//--------------------------------------- using with network status --------------------------------------->

@riverpod
class LoginViewModel extends _$LoginViewModel {

  // ✅ State type = NetworkResult<AuthUser>
  // ✅ AuthUser = login success pe milega (token + user info)
  @override
  NetworkResult<AuthUser> build() => const NetworkResult.initial();

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe, // ← CHANGE: LoginScreen se pass hoga
  }) async {

    // ✅ Validation pehle — API call se pehle
    if (email.trim().isEmpty || password.isEmpty) {
      state = const NetworkResult.error(message: "Email and password required.");
      return;
    }

    // ✅ Loading set karo
    state = const NetworkResult.loading();

    // ✅ Repository call — woh bhi NetworkResult return karta hai
    final result = await ref.read(authRepositoryProvider).login(
      email: email.trim(),
      password: password,
    );

    // ── CHANGE: Login success pe token + credentials save karo
    if (result is Success<AuthUser>) {
      // Token save karo — yahi persistent login ka core hai
      await AuthService.instance.saveToken(result.data.accessToken);

      // Remember Me check — ON hai to credentials save, OFF hai to clear
      if (rememberMe) {
        await AuthService.instance.saveCredentials(
          email: email.trim(),
          password: password,
        );
      } else {
        // ── Remember Me OFF — purane saved credentials bhi hata do
        await AuthService.instance.clearCredentials();
      }
    }

    // ✅ Direct assign — koi mapping nahi, koi switch nahi
    state = result;
  }
}


























