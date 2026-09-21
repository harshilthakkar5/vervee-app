
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vervee_app/utils/AuthService.dart';
import 'package:vervee_app/utils/Constants.dart';
import '../data/remort/AuthApi.dart';
import '../data/repository/AuthRepositoryImpl.dart';
import '../domain/repository/AuthRepository.dart';
import '../presentation/screen/LoginScreen.dart';
import '../utils/appNavigatorKey.dart';

part 'AuthModule.g.dart';

// ✅ Fix 1: DioRef → Ref
@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseURL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // dio.interceptors.add(
  //   LogInterceptor(
  //     requestBody: true,
  //     responseBody: true,
  //   ),
  // );
  //
  // return dio;

  // dio.interceptors.add(
  //   InterceptorsWrapper(
  //     onRequest: (options, handler) {
  //       // SecureStorage / SharedPreferences se token lo
  //       final token = AuthService.instance.getToken(); // apna storage util
  //       if (token != null) {
  //         options.headers['Authorization'] = 'Bearer $token';
  //       }
  //       handler.next(options);
  //     },
  //   ),
  // );
  //
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  // return dio;

  bool isHandlingAuthError = false;

  dio.interceptors.add(
    InterceptorsWrapper(
      // ✅ FIX 1: onRequest async banana zaroori hai — getToken() awaitable hai
      onRequest: (options, handler) async {
        // ✅ FIX 2: await lagaya — ab actual token string milegi, Future object nahi
        final token = await AuthService.instance.getToken();

        if (token != null) {
          // ✅ FIX 3: Yahan ab sahi Bearer token set hoga
          options.headers['Authorization'] = 'Bearer $token';
        }

        // ✅ FIX 4: Content-Type override — multipart ke liye Dio khud set karta hai
        // BaseOptions mein 'application/json' set tha jo multipart requests tod raha tha
        // Solution: sirf non-multipart requests pe manually set karo, baaki Dio pe chhodo
        if (options.data is! FormData) {
          options.headers['Content-Type'] = 'application/json';
        } else {
          // ✅ FormData ke liye Content-Type Dio automatic set karega (multipart/form-data + boundary)
          options.headers.remove('Content-Type');
        }

        handler.next(options);
      },

      // ← Bas yeh onError block add karo, baaki sab same hai
      // onError: (DioException err, ErrorInterceptorHandler handler) async {
      //   if (err.response?.statusCode == 401) {
      //     await AuthService.instance.logout(keepCredentials: true);
      //     appNavigatorKey.currentState?.pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (_) => const LoginScreen()),
      //           (route) => false,
      //     );
      //   }
      //   handler.next(err);
      // },
      onError: (DioException err, ErrorInterceptorHandler handler) async {
        if (err.response?.statusCode == 401 && !isHandlingAuthError) {
          isHandlingAuthError = true;

          // Check if we are already at LoginScreen to avoid redundant navigation
          final context = appNavigatorKey.currentContext;
          bool isAlreadyOnLogin = false;
          if (context != null) {
            ModalRoute.of(context)?.settings.name == '/LoginScreen';
          }

          if (!isAlreadyOnLogin) {
            await AuthService.instance.logout(keepCredentials: true);
            appNavigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
          isHandlingAuthError = false;
        }
        handler.next(err);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
}

// ✅ Fix 2: AuthApiRef → Ref
@riverpod
AuthApi authApi(Ref ref) {
  // ✅ Fix 3: ref.watch(dioProvider) — sahi hai
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
}

// ✅ Fix 4: AuthRepositoryRef → Ref
// ✅ Fix 5: Return type = Interface (AuthRepository) — Implementation nahi
@riverpod
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(authApiProvider);
  return AuthRepositoryImpl(api);
}




// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:vervee_app/utils/Constants.dart';
//
// import '../data/remort/AuthApi.dart';
// import '../data/repository/AuthRepositoryImpl.dart';
// import '../domain/repository/AuthRepository.dart';
// // import '../data/remote/auth_api.dart';
// // import '../data/repository/auth_repository_impl.dart';
// // import '../domain/repository/auth_repository.dart';
//
// part 'AuthModule.g.dart';
//
// // ✅ @riverpod annotation use kiya
// // Ye manually Provider<T> likhne se better hai kyunki:
// // - Type safe hai
// // - Build runner automatically provider generate karta hai
// // - Less boilerplate
//
//
// @riverpod
// Dio dio(Ref ref) {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: Constants.baseURL,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {'Content-Type': 'application/json'},
//     ),
//   );
//
//   // Interceptors — logging, auth token inject, etc.
//   dio.interceptors.add(LogInterceptor(
//     requestBody: true,
//     responseBody: true,
//   ));
//
//   return dio;
// }
//
// @riverpod
// AuthApi authApi(Ref ref) {
//   final dio = ref.watch(dioProvider);
//   return AuthApi(dio);
// }
//
// @riverpod
// AuthRepository authRepository(Ref ref) {
//   final api = ref.watch(authApiProvider);
//   return AuthRepositoryImpl(api);
// }
