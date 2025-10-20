import 'package:dartz/dartz.dart';
import '../../data/models/login_response/login_response_model.dart';
import '../../data/models/user_model/user_model.dart';
import '../entities/refresh_token/refresh_token_entities.dart';
import '../entities/user/user_entity.dart';

abstract class AuthRepository {
  // Send OTP
  Future<Either<String, void>> sendOtp(String email);

  // Verify OTP ✅ Return LoginResponseModel
  Future<Either<String, LoginResponseModel>> verifyOtp(String email, String otp);

  // Resend OTP
  Future<Either<String, void>> resendOtp(String email);

  // Get current user
  Future<Either<String, UserEntity>> getCurrentUser();

  // Refresh token
  Future<Either<String, RefreshTokenEntity>> refreshToken(String refreshToken);

  // Logout
  Future<Either<String, void>> logout();
}