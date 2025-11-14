// lib/core/services/storage/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Service để quản lý local storage (wrapper cho SharedPreferences)
/// 
/// Low-level service - Dùng để build các service khác
/// Không cần @injectable vì đã register trong StorageModule
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // ========== String ==========
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  // ========== Int ==========
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  // ========== Bool ==========
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  // ========== Double ==========
  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  // ========== List<String> ==========
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  // ========== Remove & Clear ==========
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // ========== Utilities ==========
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}