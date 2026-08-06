import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/constants/dev_auth_config.dart';
import '../firebase_options.dart';
import '../core/errors/app_exception.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(dioProvider),
    ref.watch(storageServiceProvider),
  );
});

class AuthService {
  AuthService(this._dio, this._storage);

  final Dio _dio;
  final StorageService _storage;

  String? _pendingVerificationId;

  FirebaseAuth get _firebaseAuth {
    if (!DefaultFirebaseOptions.isConfigured) {
      throw const AuthException('Firebase is not configured.');
    }
    return FirebaseAuth.instance;
  }

  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+91$digits';
    if (digits.startsWith('91') && digits.length == 12) return '+$digits';
    if (phone.startsWith('+')) return phone.replaceAll(' ', '');
    return '+$digits';
  }

  String _apiErrorMessage(Object e, {String fallback = 'Request failed'}) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final detail = data['detail'];
        if (detail is String && detail.isNotEmpty) return detail;
        for (final value in data.values) {
          if (value is List && value.isNotEmpty) return value.first.toString();
          if (value is String && value.isNotEmpty) return value;
        }
      }
      if (e.message != null && e.message!.isNotEmpty) return e.message!;
    }
    return fallback;
  }

  Future<AuthResponse> loginWithPassword({
    required String phone,
    required String password,
    String? role,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.authLogin,
        data: {
          'phone': normalizePhone(phone),
          'password': password,
          if (role != null) 'role': role,
        },
      );
      // Clear previous session before saving the new one (prevents Owner A/B bleed).
      await _storage.clearAll();
      final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storage.saveTokens(access: auth.access, refresh: auth.refresh);
      await _storage.saveUser(auth.user);
      return auth;
    } catch (e) {
      throw AuthException(_apiErrorMessage(e, fallback: 'Sign in failed'));
    }
  }

  Future<AuthResponse> register({
    required String phone,
    required String name,
    required String password,
    required String confirmPassword,
    required String role,
    String? garageName,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.authRegister,
        data: {
          'phone': normalizePhone(phone),
          'name': name,
          'password': password,
          'confirm_password': confirmPassword,
          'role': role,
          if (garageName != null && garageName.isNotEmpty) 'garage_name': garageName,
        },
      );
      await _storage.clearAll();
      final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storage.saveTokens(access: auth.access, refresh: auth.refresh);
      await _storage.saveUser(auth.user);
      return auth;
    } catch (e) {
      throw AuthException(_apiErrorMessage(e, fallback: 'Sign up failed'));
    }
  }

  /// Local development when Firebase is not configured (backend DEBUG=True).
  Future<AuthResponse> devSignIn({required String phone, String? name, String? role}) async {
    if (!DevAuthConfig.useDevAuth) {
      throw const AuthException('Dev login is not enabled.');
    }

    final response = await _dio.post(
      ApiConstants.authDev,
      data: {
        'phone': normalizePhone(phone),
        if (name != null && name.isNotEmpty) 'name': name,
        if (role != null) 'role': role,
      },
    );

    final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
    await _storage.saveTokens(access: auth.access, refresh: auth.refresh);
    await _storage.saveUser(auth.user);
    return auth;
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function() onCodeSent,
    required void Function(AuthResponse) onAutoVerified,
    String? role,
  }) async {
    if (!DefaultFirebaseOptions.isConfigured) {
      throw const AuthException(
        'Firebase is not configured. Use Continue (dev login) or run: flutterfire configure',
      );
    }

    final completer = Completer<void>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        final auth = await _completeFirebaseSignIn(credential, role: role);
        onAutoVerified(auth);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.completeError(AuthException(e.message ?? 'Verification failed'));
        }
      },
      codeSent: (verificationId, _) {
        _pendingVerificationId = verificationId;
        onCodeSent();
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  Future<AuthResponse> verifyOtp({
    required String smsCode,
    String? name,
    String? role,
    String? fcmToken,
  }) async {
    final verificationId = _pendingVerificationId;
    if (verificationId == null) {
      throw const AuthException('No pending verification. Request OTP first.');
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _completeFirebaseSignIn(credential, name: name, role: role, fcmToken: fcmToken);
  }

  Future<AuthResponse> _completeFirebaseSignIn(
    PhoneAuthCredential credential, {
    String? name,
    String? role,
    String? fcmToken,
  }) async {
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw const AuthException('Firebase sign-in failed');
    }

    final idToken = await firebaseUser.getIdToken();
    final phone = firebaseUser.phoneNumber ?? '';

    final response = await _dio.post(
      ApiConstants.authFirebase,
      data: {
        'firebase_uid': firebaseUser.uid,
        'phone': phone.replaceAll(' ', ''),
        'id_token': idToken,
        if (name != null) 'name': name,
        if (role != null) 'role': role,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
    );

    final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
    await _storage.saveTokens(access: auth.access, refresh: auth.refresh);
    await _storage.saveUser(auth.user);
    return auth;
  }

  Future<void> signOut() async {
    if (DefaultFirebaseOptions.isConfigured) {
      try {
        await _firebaseAuth.signOut();
      } catch (_) {}
    }
    await _storage.clearAll();
  }

  Future<UserModel?> getCurrentUser() => _storage.getUser();

  Future<bool> isLoggedIn() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
