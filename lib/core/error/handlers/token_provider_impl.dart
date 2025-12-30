// lib/core/error/handlers/token_provider_impl.dart

import 'package:injectable/injectable.dart';

import '../../services/storage/storage_service.dart';
import 'token_provider.dart';

/// Implementation của TokenProvider sử dụng StorageService
///
/// CÁCH 2: BETTER
/// - Dùng StorageService (SharedPreferences - không mã hóa)
/// - Đơn giản, phù hợp solo dev
/// - Nếu sau này cần bảo mật hơn → Dễ dàng đổi sang SecureStorage
@LazySingleton(as: TokenProvider)
class TokenProviderImpl implements TokenProvider {
  final StorageService _storage;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  TokenProviderImpl(this._storage);

  @override
  Future<String?> getAccessToken() async {
    return await _storage.getString(_keyAccessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.getString(_keyRefreshToken);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _storage.setString(_keyAccessToken, token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _storage.setString(_keyRefreshToken, token);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.remove(_keyAccessToken);
    await _storage.remove(_keyRefreshToken);
  }

  // ========== Helper Methods ==========

  /// Check if user has access token (is authenticated)
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Check if user has refresh token
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }
}
