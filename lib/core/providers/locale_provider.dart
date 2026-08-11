import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/storage_service.dart';

enum AppLanguage {
  english('en', 'English'),
  hindi('hi', 'Hindi'),
  marathi('mr', 'Marathi');

  const AppLanguage(this.code, this.label);
  final String code;
  final String label;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLanguage>((ref) {
  return LocaleNotifier(ref.read(storageServiceProvider));
});

class LocaleNotifier extends StateNotifier<AppLanguage> {
  LocaleNotifier(this._storage) : super(AppLanguage.english) {
    _load();
  }

  final StorageService _storage;

  Future<void> _load() async {
    try {
      final saved = await _storage.getLocale();
      state = AppLanguage.fromCode(saved);
    } catch (_) {
      state = AppLanguage.english;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    try {
      await _storage.saveLocale(language.code);
    } catch (_) {}
  }
}
