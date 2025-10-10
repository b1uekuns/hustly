import '../entities/refresh_token/refresh_token_entities.dart';
import '../entities/user/user_entity.dart';
import '../../../../core/resources/data_state.dart';

abstract class AuthRepository {
  /// Gửi OTP đến email để đăng nhập
  Future<DataState<void>> sendOtp(String email);

  /// Xác thực OTP, nếu đúng thì trả về User + Token
  Future<DataState<(UserEntity, RefreshTokenEntity)>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Lấy thông tin user hiện tại
  Future<DataState<UserEntity>> getCurrentUser();

  /// Làm mới access token bằng refresh token
  Future<DataState<RefreshTokenEntity>> refreshToken({
    required String refreshToken,
  });

  /// Đăng xuất
  Future<DataState<void>> logout();
}
