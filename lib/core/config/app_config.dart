// lib/core/config/app_config.dart
// MINIMAL VERSION - Cho solo dev

import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  // ==================== App Info ====================
  static const String appName = 'Your App';
  static const String appVersion = '1.0.0';

  // ==================== API ====================
  static const String baseUrl = 'http://localhost:3000';  // Change khi deploy
  
  // ==================== Dev Features ====================
  static final bool isDevMode = kDebugMode;
  static final bool skipAuthGuard = isDevMode;  // Used in app_router

  // ==================== Common Constants ====================
  static const int pageSize = 20;
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxImageSizeMB = 5;

  // ==================== Print Config (Dev only) ====================
  static void printConfig() {
    if (isDevMode) {
      debugPrint('🔷 APP: $appName v$appVersion');
      debugPrint('🔷 API: $baseUrl');
      debugPrint('🔷 DEV MODE: $isDevMode');
    }
  }
}