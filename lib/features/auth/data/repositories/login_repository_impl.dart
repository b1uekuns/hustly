import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/refresh_token/refresh_token_entities.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_api.dart';
import '../models/login_response/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<Either<String, void>> sendOtp(String email) async {
    try {
      final response = await _authApi.sendOtp({
        'email': email,
      });

      if (response.response.statusCode == 200 && response.data.success) {
        return const Right(null);
      } else {
        return Left(response.data.error?.message ?? 'Failed to send OTP');
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, LoginResponseModel>> verifyOtp(
    String email,
    String otp,
  ) async {
    try {
      print('🔵 [DEBUG] Calling verifyOtp API...');
      final response = await _authApi.verifyOtp({
        'email': email,
        'otp': otp,
      });

      print('🔵 [DEBUG] Response status: ${response.response.statusCode}');
      print('🔵 [DEBUG] Response success: ${response.data.success}');
      print('🔵 [DEBUG] Response data: ${response.data.data}');

      if (response.response.statusCode == 200 && response.data.success) {
        print('✅ [DEBUG] Parsing LoginResponseModel...');
        final loginResponse = response.data.data!;
        print('✅ [DEBUG] Login response parsed successfully');
        return Right(loginResponse);
      } else {
        print('❌ [DEBUG] API error: ${response.data.error?.message}');
        return Left(response.data.error?.message ?? 'Invalid OTP');
      }
    } catch (e, stackTrace) {
      print('❌ [DEBUG] Exception in verifyOtp: $e');
      print('❌ [DEBUG] Stack trace: $stackTrace');
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> resendOtp(String email) async {
    try {
      final response = await _authApi.resendOtp({
        'email': email,
      });

      if (response.response.statusCode == 200 && response.data.success) {
        return const Right(null);
      } else {
        return Left(response.data.error?.message ?? 'Failed to resend OTP');
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      // TODO: Get token from secure storage
      const token = 'Bearer YOUR_TOKEN_HERE';
      final response = await _authApi.getCurrentUser(token);

      if (response.response.statusCode == 200 && response.data.success) {
        // TODO: Map response.data.data (UserModel) to UserEntity
        throw UnimplementedError('getCurrentUser not implemented yet');
      } else {
        return Left(response.data.error?.message ?? 'Failed to get user');
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, RefreshTokenEntity>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _authApi.refreshToken({
        'refreshToken': refreshToken,
      });

      if (response.response.statusCode == 200 && response.data.success) {
        // TODO: Map response to RefreshTokenEntity
        throw UnimplementedError('refreshToken not implemented yet');
      } else {
        return Left(response.data.error?.message ?? 'Failed to refresh token');
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      // TODO: Get token from secure storage
      const token = 'Bearer YOUR_TOKEN_HERE';
      final response = await _authApi.logout(token);

      if (response.response.statusCode == 200) {
        // TODO: Clear local storage (token, user data)
        return const Right(null);
      } else {
        return Left(response.data.error?.message ?? 'Failed to logout');
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map<String, dynamic> && data['error'] != null) {
          return data['error']['message'] ?? 'An error occurred';
        }
      }
      return error.message ?? 'Network error';
    }
    return 'An unexpected error occurred';
  }
}