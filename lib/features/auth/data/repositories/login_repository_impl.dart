import 'package:dio/dio.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/refresh_token/refresh_token_entities.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_api.dart';

import '../models/refresh_token/refresh_token_model.dart';
import '../models/user_model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<DataState<void>> sendOtp(String email) async {
    try {
      final res = await api.sendOtp({"email": email});
      if (res.response.statusCode == 200) {
        return const DataSuccess(data: null);
      } else {
        return DataError(
          error: DioException(
            requestOptions: res.response.requestOptions,
            message: res.data.message ?? "Unknown error",
          ),
        );
      }
    } on DioException catch (e) {
      return DataError(error: e);
    }
  }

  @override
  Future<DataState<(UserEntity, RefreshTokenEntity)>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await api.verifyOtp({"email": email, "otp": otp});

      if (res.response.statusCode == 200 && res.data.data != null) {
        final loginResponse = res.data.data!;
        final user = loginResponse.user.toEntity();
        final token = loginResponse.tokens.toEntity();

        return DataSuccess(data: (user, token));
      } else {
        return DataError(
          error: DioException(
            requestOptions: res.response.requestOptions,
            message: res.data.message ?? "Verify OTP failed",
          ),
        );
      }
    } on DioException catch (e) {
      return DataError(error: e);
    }
  }

  @override
  Future<DataState<UserEntity>> getCurrentUser() async {
    try {
      final res = await api.getCurrentUser();
      if (res.response.statusCode == 200 && res.data.data != null) {
        return DataSuccess(data: res.data.data!.toEntity());
      } else {
        return DataError(
          error: DioException(
            requestOptions: res.response.requestOptions,
            message: res.data.message ?? "Get user failed",
          ),
        );
      }
    } on DioException catch (e) {
      return DataError(error: e);
    }
  }

  @override
  Future<DataState<RefreshTokenEntity>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final res = await api.refreshToken({"refreshToken": refreshToken});
      if (res.response.statusCode == 200 && res.data.data != null) {
        return DataSuccess(data: res.data.data!.toEntity());
      } else {
        return DataError(
          error: DioException(
            requestOptions: res.response.requestOptions,
            message: res.data.message ?? "Refresh token failed",
          ),
        );
      }
    } on DioException catch (e) {
      return DataError(error: e);
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      final res = await api.logout();
      if (res.response.statusCode == 200) {
        return const DataSuccess(data: null);
      } else {
        return DataError(
          error: DioException(
            requestOptions: res.response.requestOptions,
            message: res.data.message ?? "Logout failed",
          ),
        );
      }
    } on DioException catch (e) {
      return DataError(error: e);
    }
  }
}
