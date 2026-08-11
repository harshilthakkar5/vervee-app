import 'package:freezed_annotation/freezed_annotation.dart';

part 'AuthUser.freezed.dart';

// ✅ Login success ke baad jo data app me use hoga
// "success", "accessToken" raw fields nahi hain —
// wo DTO layer pe filter ho gaye
// Domain model sirf clean user data rakhta hai

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required int id,
    required String name,
    required String email,
    required String role,
    required String accessToken, // ✅ Auth ke liye zaruri hai
    required bool hasSeenTour,   // ✅ App flow ke liye zaruri hai
  }) = _AuthUser;
}

// ❌ JSON annotation nahi — Domain layer ko JSON se
//    koi matlab nahi hota
// ❌ "success" field nahi — wo DTO ka kaam tha
//    success/failure Repository handle karta hai NetworkResult se
