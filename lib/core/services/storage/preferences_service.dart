// lib/core/services/storage/preferences_service.dart

import 'package:injectable/injectable.dart';
import 'storage_service.dart';

/// Service để quản lý app preferences/settings
/// 
/// Chỉ lo về: theme, language, notifications, font size, etc.
/// KHÔNG lo về: tokens (tokens sẽ dùng TokenProvider)
/// 
/// Không cần @injectable vì đã register trong StorageModule
class PreferencesService {
  final StorageService _storage;

  PreferencesService(this._storage);

  // ========== Theme ==========
  Future<String?> getThemeMode() async {
    return await _storage.getString('theme_mode');
  }

  Future<void> setThemeMode(String mode) async {
    await _storage.setString('theme_mode', mode);
  }

  // ========== Language ==========
  Future<String?> getLanguage() async {
    return await _storage.getString('language');
  }

  Future<void> setLanguage(String languageCode) async {
    await _storage.setString('language', languageCode);
  }

  // ========== Notifications ==========
  Future<bool> getNotificationsEnabled() async {
    return await _storage.getBool('notifications_enabled') ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _storage.setBool('notifications_enabled', enabled);
  }

  // ========== Font Size ==========
  Future<int> getFontSize() async {
    return await _storage.getInt('font_size') ?? 14;
  }

  Future<void> setFontSize(int size) async {
    await _storage.setInt('font_size', size);
  }

  // ========== First Time App Launch ==========
  Future<bool> isFirstTime() async {
    return await _storage.getBool('is_first_time') ?? true;
  }

  Future<void> setFirstTimeCompleted() async {
    await _storage.setBool('is_first_time', false);
  }

  // ========== Remember Login ==========
  Future<bool> getRememberLogin() async {
    return await _storage.getBool('remember_login') ?? false;
  }

  Future<void> setRememberLogin(bool remember) async {
    await _storage.setBool('remember_login', remember);
  }

  // ========== Clear All Preferences ==========
  Future<void> clearPreferences() async {
    await _storage.remove('theme_mode');
    await _storage.remove('language');
    await _storage.remove('notifications_enabled');
    await _storage.remove('font_size');
    // Không clear first_time và remember_login
  }

  // ========== Helper Methods ==========
  
  /// Get theme mode with default
  Future<String> getThemeModeWithDefault() async {
    return await getThemeMode() ?? 'system'; // system, light, dark
  }

  /// Get language with default
  Future<String> getLanguageWithDefault() async {
    return await getLanguage() ?? 'vi'; // vi, en
  }
}