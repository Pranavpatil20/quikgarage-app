import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveTokens({required String access, required String refresh}) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: access);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refresh);
  }

  Future<String?> getAccessToken() => _storage.read(key: AppConstants.accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: AppConstants.refreshTokenKey);

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final raw = await _storage.read(key: AppConstants.userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveThemeMode(String mode) =>
      _storage.write(key: AppConstants.themeModeKey, value: mode);

  Future<String?> getThemeMode() => _storage.read(key: AppConstants.themeModeKey);

  Future<void> saveLocale(String code) =>
      _storage.write(key: AppConstants.localeKey, value: code);

  Future<String?> getLocale() => _storage.read(key: AppConstants.localeKey);

  Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: AppConstants.accessTokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
      _storage.delete(key: AppConstants.userKey),
    ]);
  }
}
