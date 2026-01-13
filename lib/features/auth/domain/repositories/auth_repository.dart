import 'package:dartz/dartz.dart';
import '../../../../core/error/failures/failure.dart';
import '../entities/login_response/login_response_entity.dart';
import '../entities/refresh_token/refresh_token_entities.dart';
import '../entities/user/user_entity.dart';

/// Auth Repository Interface (Domain Layer)
/// Clean Architecture: Uses Domain entities only, no Data layer dependencies
abstract class AuthRepository {
  /// Send OTP to email
  Future<Either<Failure, void>> sendOtp(String email);

  /// Verify OTP and login - Returns LoginResponseEntity (Domain entity)
  Future<Either<Failure, LoginResponseEntity>> verifyOtp(
    String email,
    String otp,
  );

  /// Resend OTP
  Future<Either<Failure, void>> resendOtp(String email);

  /// Get current user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Refresh access token
  Future<Either<Failure, RefreshTokenEntity>> refreshToken(String refreshToken);

  /// Logout
  // Future<Either<Failure, void>> logout();
}
