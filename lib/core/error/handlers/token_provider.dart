// lib/core/error/handlers/token_provider.dart

/// Interface để quản lý access token và refresh token
/// 
/// Implementation sẽ dùng StorageService
/// Tách riêng interface để dễ test và dễ thay đổi implementation sau này
abstract class TokenProvider {
  /// Lấy access token
  Future<String?> getAccessToken();

  /// Lấy refresh token
  Future<String?> getRefreshToken();

  /// Lưu access token
  Future<void> setAccessToken(String token);

  /// Lưu refresh token
  Future<void> setRefreshToken(String token);

  /// Xóa tất cả tokens (logout)
  Future<void> clearTokens();
}