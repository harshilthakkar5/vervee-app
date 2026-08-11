
// lib/core/services/auth_service.dart

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AuthService — Token aur Remember Me credentials manage karta hai
/// Singleton pattern use kiya — poori app mein ek hi instance
class AuthService {
  AuthService._(); // ← private constructor — bahar se new AuthService() nahi ho sakta
  static final AuthService instance = AuthService._(); // ← global access point

  // ── CHANGE: flutter_secure_storage use kar rahe hain
  // Android pe encrypted SharedPreferences, iOS pe Keychain
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Storage keys — magic strings avoid karne ke liye constants
  static const _kToken      = 'auth_token';
  static const _kRemember   = 'remember_me';
  static const _kSavedEmail = 'saved_email';
  static const _kSavedPass  = 'saved_password';

  // ─────────────────────────────────────────────────────────
  //  Token methods — persistent login ke liye
  // ─────────────────────────────────────────────────────────

  /// Login success pe token save karo
  Future<void> saveToken(String token) =>
      _storage.write(key: _kToken, value: token);

  /// Token read karo — null matlab logged out
  Future<String?> getToken() =>
      _storage.read(key: _kToken);

  /// SplashScreen pe yahi check hoga
  Future<bool> isLoggedIn() async =>
      (await getToken()) != null;

  /// Token delete karo — logout pe
  Future<void> clearToken() =>
      _storage.delete(key: _kToken);

  // ─────────────────────────────────────────────────────────
  //  Remember Me methods
  // ─────────────────────────────────────────────────────────

  /// Remember Me ON hone pe email + password securely save karo
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _kRemember,   value: 'true');
    await _storage.write(key: _kSavedEmail, value: email);
    await _storage.write(key: _kSavedPass,  value: password);
  }

  /// Remember Me OFF hone pe credentials delete karo
  Future<void> clearCredentials() async {
    await _storage.delete(key: _kRemember);
    await _storage.delete(key: _kSavedEmail);
    await _storage.delete(key: _kSavedPass);
  }

  /// LoginScreen initState mein yahi call hoga — fields prefill ke liye
  Future<({bool remember, String email, String password})>
  getSavedCredentials() async {
    final remember = await _storage.read(key: _kRemember) == 'true';
    final email    = await _storage.read(key: _kSavedEmail) ?? '';
    final password = await _storage.read(key: _kSavedPass)  ?? '';
    return (remember: remember, email: email, password: password);
  }

  // ─────────────────────────────────────────────────────────
  //  Logout
  // ─────────────────────────────────────────────────────────

  /// Token clear karo
  /// keepCredentials: true → Remember Me data rakho (user dobara login pe prefill milega)
  /// keepCredentials: false → Sab kuch delete karo
  Future<void> logout({bool keepCredentials = true}) async {
    await clearToken();
    if (!keepCredentials) {
      await clearCredentials();
    }
  }

  // ─────────────────────────────────────────────────────────
  //  getUserId
  // ─────────────────────────────────────────────────────────

  /// Current logged-in user ka userId return karta hai.
  /// JWT token se ya local storage se milta hai.
  // ✅ YAHAN ADD KARO ↓
  Future<int?> getUserId() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final parts   = token.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      return (payload['sub'] as num?)?.toInt();
    } catch (_) {
      return null;
    }
  }
}