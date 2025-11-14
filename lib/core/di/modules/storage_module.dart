import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/storage/storage_service.dart';
import '../../services/storage/preferences_service.dart';

@module
abstract class StorageModule {
  /// SharedPreferences - Async initialization
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// StorageService - Generic wrapper cho SharedPreferences
  /// Low-level, dùng để build các service khác
  @lazySingleton
  StorageService storageService(SharedPreferences prefs) => 
      StorageService(prefs);

  /// PreferencesService - High-level service cho app settings
  /// Dùng cho: theme, language, notifications, etc.
  @lazySingleton
  PreferencesService preferencesService(StorageService storage) => 
      PreferencesService(storage);
}