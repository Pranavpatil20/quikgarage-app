import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth_response.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/api_client.dart';
import '../../services/storage_service.dart';

/// Current logged-in user id — data providers watch this so Owner A/B never share cache.
final currentUserIdProvider = Provider<int?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.id;
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  // Use read so AuthNotifier is not recreated when repo providers rebuild.
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(userRepositoryProvider),
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier(this._authRepo, this._userRepo) : super(const AsyncValue.loading()) {
    _init();
  }

  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  Future<void> _init() async {
    try {
      final loggedIn = await _authRepo.isLoggedIn();
      if (!loggedIn) {
        state = const AsyncValue.data(null);
        return;
      }

      // Show cached user immediately to avoid splash flicker / double load.
      final cached = await _authRepo.getCurrentUser();
      if (cached != null) {
        state = AsyncValue.data(cached);
      }

      final user = await _userRepo.getMe();
      state = AsyncValue.data(user);
    } catch (_) {
      await _authRepo.signOut();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> sendOtp(
    String phone, {
    required void Function() onCodeSent,
    required void Function(AuthResponse) onAutoVerified,
    String? role,
  }) async {
    await _authRepo.sendOtp(
      phone,
      onCodeSent: onCodeSent,
      onAutoVerified: (auth) {
        state = AsyncValue.data(auth.user);
        onAutoVerified(auth);
      },
      role: role,
    );
  }

  Future<AuthResponse> loginWithPassword({
    required String phone,
    required String password,
    String? role,
  }) async {
    final auth = await _authRepo.loginWithPassword(
      phone: phone,
      password: password,
      role: role,
    );
    state = AsyncValue.data(auth.user);
    return auth;
  }

  Future<AuthResponse> register({
    required String phone,
    required String name,
    required String password,
    required String confirmPassword,
    required String role,
    String? garageName,
  }) async {
    final auth = await _authRepo.register(
      phone: phone,
      name: name,
      password: password,
      confirmPassword: confirmPassword,
      role: role,
      garageName: garageName,
    );
    state = AsyncValue.data(auth.user);
    return auth;
  }

  Future<AuthResponse> devSignIn({required String phone, String? name, String? role}) async {
    try {
      final auth = await _authRepo.devSignIn(phone: phone, name: name, role: role);
      state = AsyncValue.data(auth.user);
      return auth;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<AuthResponse> verifyOtp(String code, {String? name, String? role}) async {
    try {
      final auth = await _authRepo.verifyOtp(code, name: name, role: role);
      state = AsyncValue.data(auth.user);
      return auth;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> setRole(String role) async {
    final user = await _userRepo.setRole(role);
    state = AsyncValue.data(user);
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshUser() async {
    final user = await _userRepo.getMe();
    state = AsyncValue.data(user);
  }

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier(ref.read(storageServiceProvider));
});

enum AppThemeMode { light, dark, system }

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this._storage) : super(AppThemeMode.light) {
    _load();
  }

  final StorageService _storage;

  Future<void> _load() async {
    try {
      final saved = await _storage.getThemeMode();
      if (saved == 'dark') {
        state = AppThemeMode.dark;
      } else if (saved == 'system') {
        state = AppThemeMode.system;
      } else {
        state = AppThemeMode.light;
      }
    } catch (_) {
      state = AppThemeMode.light;
    }
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    try {
      await _storage.saveThemeMode(mode.name);
    } catch (_) {}
  }

  Future<void> setDark(bool enabled) async {
    await setMode(enabled ? AppThemeMode.dark : AppThemeMode.light);
  }

  Future<void> toggle() async {
    await setDark(state != AppThemeMode.dark);
  }
}
