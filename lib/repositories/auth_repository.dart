import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authServiceProvider));
});

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<void> sendOtp(
    String phone, {
    required void Function() onCodeSent,
    required void Function(AuthResponse) onAutoVerified,
    String? role,
  }) =>
      _authService.sendOtp(
        phoneNumber: phone,
        onCodeSent: onCodeSent,
        onAutoVerified: onAutoVerified,
        role: role,
      );

  Future<AuthResponse> verifyOtp(String code, {String? name, String? role, String? fcmToken}) =>
      _authService.verifyOtp(smsCode: code, name: name, role: role, fcmToken: fcmToken);

  Future<AuthResponse> loginWithPassword({
    required String phone,
    required String password,
    String? role,
  }) =>
      _authService.loginWithPassword(phone: phone, password: password, role: role);

  Future<AuthResponse> register({
    required String phone,
    required String name,
    required String password,
    required String confirmPassword,
    required String role,
    String? garageName,
  }) =>
      _authService.register(
        phone: phone,
        name: name,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
        garageName: garageName,
      );

  Future<AuthResponse> devSignIn({required String phone, String? name, String? role}) =>
      _authService.devSignIn(phone: phone, name: name, role: role);

  Future<void> signOut() => _authService.signOut();

  Future<UserModel?> getCurrentUser() => _authService.getCurrentUser();

  Future<bool> isLoggedIn() => _authService.isLoggedIn();
}
