import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/failures/server_failure.dart';
import '../../../../core/error/handlers/error_handler.dart';
import '../../../../core/error/handlers/token_provider.dart';
import '../../domain/entities/login_response/login_response_entity.dart';
import '../../domain/entities/refresh_token/refresh_token_entities.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_api.dart';

/// Auth Repository Implementation (Data Layer)
/// Clean Architecture: Converts Data models to Domain entities before returning
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final TokenProvider _tokenProvider;

  AuthRepositoryImpl(this._authApi, this._tokenProvider);

  @override
  Future<Either<Failure, void>> sendOtp(String email) async {
    try {
      final response = await _authApi.sendOtp({'email': email});

      if (response.response.statusCode == 200 && response.data.success) {
        return const Right(null);
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Failed to send OTP'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> verifyOtp(
    String email,
    String otp,
  ) async {
    try {
      final response = await _authApi.verifyOtp({'email': email, 'otp': otp});

      if (response.response.statusCode == 200 && response.data.success) {
        final loginResponse = response.data.data!;
        
        // Save tokens after successful verification
        await _tokenProvider.setAccessToken(loginResponse.token);
        await _tokenProvider.setRefreshToken(loginResponse.refreshToken);
        
        // Convert Data model → Domain entity
        final entity = LoginResponseEntity(
          user: loginResponse.user.toEntity(),
          token: loginResponse.token,
          refreshToken: loginResponse.refreshToken,
          isNewUser: loginResponse.isNewUser,
          needsApproval: loginResponse.needsApproval,
          isApproved: loginResponse.isApproved,
          isRejected: loginResponse.isRejected,
          rejectionReason: loginResponse.rejectionReason,
        );
        
        return Right(entity);
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Invalid OTP'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      final response = await _authApi.resendOtp({'email': email});

      if (response.response.statusCode == 200 && response.data.success) {
        return const Right(null);
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Failed to resend OTP'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final token = await _tokenProvider.getAccessToken();
      if (token == null) {
        return const Left(ServerFailure('No token available'));
      }

      final response = await _authApi.getCurrentUser('Bearer $token');

      if (response.response.statusCode == 200 && response.data.success) {
        final userModel = response.data.data!;
        return Right(userModel.toEntity());
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Failed to get user'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }

  @override
  Future<Either<Failure, RefreshTokenEntity>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _authApi.refreshToken({'refreshToken': refreshToken});

      if (response.response.statusCode == 200 && response.data.success) {
        final tokenModel = response.data.data!;
        return Right(tokenModel.toEntity());
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Failed to refresh token'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _tokenProvider.getAccessToken();
      if (token == null) {
        return const Left(ServerFailure('No token available'));
      }

      final response = await _authApi.logout('Bearer $token');

      if (response.response.statusCode == 200) {
        await _tokenProvider.clearTokens();
        return const Right(null);
      } else {
        return Left(
          ServerFailure(response.data.error?.message ?? 'Failed to logout'),
        );
      }
    } catch (e) {
      return Left(ErrorHandler.handleException(e as Exception));
    }
  }
}