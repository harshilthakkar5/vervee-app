import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/AuthModule.dart';
import '../../../../domain/model/user/OtpResult.dart';
import '../../../../utils/NetworkResult.dart';

// import '../../../di/AuthModule.dart';
// import '../../../domain/model/user/AuthUser.dart';
// import '../../../utils/NetworkResult.dart';

//part 'OtpViewModel.freezed.dart';
part 'OtpViewModel.g.dart';


// ✅ OTP State
// @freezed
// abstract class OtpState with _$OtpState {
//   const factory OtpState.initial() = _OtpInitial;
//   const factory OtpState.loading() = _OtpLoading;
//   const factory OtpState.success(String message) = _OtpSuccess;
//   const factory OtpState.error(String message) = _OtpError;
// }
//
// // ────────────────────────────────────────
// // OTP ViewModel
// // ────────────────────────────────────────
//
// @riverpod
// class OtpViewModel extends _$OtpViewModel {
//
//   @override
//   OtpState build() => const OtpState.initial();
//
//   Future<void> verifyOtp({
//     required String email,
//     required String otp,
//   }) async {
//
//     // ✅ Validation
//     if (email.trim().isEmpty || otp.trim().isEmpty) {
//       state = const OtpState.error("Email and OTP required.");
//       return;
//     }
//
//     // ✅ OTP length check — usually 4 ya 6 digit hota hai
//     if (otp.trim().length < 4) {
//       state = const OtpState.error("Please enter a valid OTP.");
//       return;
//     }
//
//     state = const OtpState.loading();
//
//     final result = await ref.read(authRepositoryProvider).verifyOtp(
//       email: email.trim(),
//       otp: otp.trim(),
//     );
//
//     switch (result) {
//       case Success(:final data):
//         state = OtpState.success(data.message);
//       case Error(:final message):
//         state = OtpState.error(message);
//     }
//   }
// }

//--------------------------------------- using with network status --------------------------------------->

// ✅ Alag OtpState class HATAI
// ✅ NetworkResult<OtpResult> directly state hai
@riverpod
class OtpViewModel extends _$OtpViewModel {

  // ✅ State type = NetworkResult<OtpResult>
  // ✅ OtpResult = verify success pe milega (message)
  @override
  NetworkResult<OtpResult> build() => const NetworkResult.initial();

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {

    // ✅ Validation pehle
    if (email.trim().isEmpty || otp.trim().isEmpty) {
      state = const NetworkResult.error(message: "Email and OTP required.");
      return;
    }

    // ✅ OTP length check
    if (otp.trim().length < 6) {
      state = const NetworkResult.error(message: "Please enter a valid OTP.");
      return;
    }

    // ✅ Loading set karo
    state = const NetworkResult.loading();

    // ✅ Repository call
    final result = await ref.read(authRepositoryProvider).verifyOtp(
      email: email.trim(),
      otp: otp.trim(),
    );

    // ✅ Direct assign — same as login aur register
    state = result;
  }
}
