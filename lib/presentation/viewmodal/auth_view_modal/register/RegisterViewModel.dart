import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/AuthModule.dart';
import '../../../../domain/model/user/RegisteredUser.dart';
import '../../../../utils/NetworkResult.dart';

// import '../../../di/AuthModule.dart';
// import '../../../domain/model/user/AuthUser.dart';
// import '../../../utils/NetworkResult.dart';

//part 'RegisterViewModel.freezed.dart';
part 'RegisterViewModel.g.dart';


// ✅ Register State
// @freezed
// abstract class RegisterState with _$RegisterState {
//   const factory RegisterState.initial() = _RegisterInitial;
//   const factory RegisterState.loading() = _RegisterLoading;
//   const factory RegisterState.success(String message) = _RegisterSuccess;
//   const factory RegisterState.error(String message) = _RegisterError;
// }

// ────────────────────────────────────────
// Register ViewModel
// ────────────────────────────────────────

// @riverpod
// class RegisterViewModel extends _$RegisterViewModel {
//
//   @override
//   RegisterState build() => const RegisterState.initial();
//
//   Future<void> register({
//     required String name,
//     required String email,
//     required String password,
//     required String confirmPassword,
//     required String age,
//     required String country,
//     required String gender,
//     required String phoneNo,
//     required bool terms,
//   }) async {
//
//     // ✅ Validation
//     if (name.trim().isEmpty ||
//         email.trim().isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       state = const RegisterState.error("Please fill all required fields.");
//       return;
//     }
//
//     // ✅ Password match check
//     if (password != confirmPassword) {
//       state = const RegisterState.error("Passwords do not match.");
//       return;
//     }
//
//     // ✅ Terms check
//     if (!terms) {
//       state = const RegisterState.error("Please accept terms and conditions.");
//       return;
//     }
//
//     state = const RegisterState.loading();
//
//     final result = await ref.read(authRepositoryProvider).register(
//       name: name.trim(),
//       email: email.trim(),
//       password: password,
//       confirmPassword: confirmPassword,
//       age: age.trim(),
//       country: country.trim(),
//       gender: gender.trim(),
//       phoneNo: phoneNo.trim(),
//       terms: terms,
//     );
//
//     switch (result) {
//       case Success(:final data):
//         state = RegisterState.success(data.message);
//       case Error(:final message):
//         state = RegisterState.error(message);
//     }
//   }
// }

//--------------------------------------- using with network status --------------------------------------->

// ✅ Alag RegisterState class HATAI — ab NetworkResult<RegisteredUser> hi state hai
// ✅ Android pattern: ek hi sealed class sab jagah
@riverpod
class RegisterViewModel extends _$RegisterViewModel {

  // ✅ State type ab NetworkResult<RegisteredUser> hai
  // ✅ RegisteredUser = domain model (success me milega)
  @override
  NetworkResult<RegisteredUser> build() => const NetworkResult.initial();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String age,
    required String country,
     String? gender,
    required String phoneNo,
    required bool terms,
    String? parentEmail,    // ✅ NEW
    String? referralCode,
  }) async {

    // ✅ Validation pehle — loading set karne se pehle
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      state = const NetworkResult.error(message: "Please fill all required fields.");
      return;
    }

    if (password != confirmPassword) {
      state = const NetworkResult.error(message: "Passwords do not match.");
      return;
    }

    if (!terms) {
      state = const NetworkResult.error(message: "Please accept terms and conditions.");
      return;
    }

    // ✅ NEW — under 18 ho to parent email zaruri
    final ageInt = int.tryParse(age.trim());
    if (ageInt != null && ageInt < 18 && (parentEmail == null || parentEmail.trim().isEmpty)) {
      state = const NetworkResult.error(message: "Parent's email is required.");
      return;
    }

    // ✅ Validation pass — ab loading dikhao
    state = const NetworkResult.loading();

    // ✅ Repository se result lo — woh bhi NetworkResult return karta hai
    // ✅ Directly assign kar sakte hain — koi mapping nahi chahiye!
    final result = await ref.read(authRepositoryProvider).register(
      name: name.trim(),
      email: email.trim(),
      password: password,
      confirmPassword: confirmPassword,
      age: age.trim(),
      country: country.trim(),
      gender: gender?.trim(),
      phoneNo: phoneNo.trim(),
      terms: terms,
      parentEmail: parentEmail?.trim(),                                   // ✅ NEW
      referralCode: (referralCode?.trim().isEmpty ?? true) ? null : referralCode!.trim(), // ✅ NEW
    );

    // ✅ Repository already NetworkResult return karta hai
    // ✅ Isliye directly state assign karo — no switch/when needed!
    state = result;
  }
}
