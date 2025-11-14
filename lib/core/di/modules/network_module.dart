// lib/core/di/modules/network_module.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../network/dio_client.dart';
import '../../network/network_info.dart';
import '../../network/interceptors/auth_interceptor.dart';
import '../../network/interceptors/logging_interceptor.dart';
import '../../error/handlers/token_provider.dart';

/// Module để register các dependencies liên quan đến Network
@module
abstract class NetworkModule {
  /// Kết nối mạng — kiểm tra wifi/mobile
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  NetworkInfo networkInfo(Connectivity connectivity) =>
      NetworkInfo(connectivity);

  /// Logging Interceptor (ẩn Authorization header)
  @lazySingleton
  LoggingInterceptor get loggingInterceptor => const LoggingInterceptor();

  /// Dio riêng cho refresh token — KHÔNG có AuthInterceptor
  /// Tránh circular dependency khi refresh token
  @lazySingleton
  @Named('refreshDio')
  Dio provideRefreshDio(LoggingInterceptor loggingInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'http://localhost:3000',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(loggingInterceptor);
    return dio;
  }

  /// Dio chính dùng cho API — CÓ AuthInterceptor
  @lazySingleton
  @Named('mainDio')
  Dio provideMainDio(
    LoggingInterceptor loggingInterceptor,
    @Named('refreshDio') Dio refreshDio,
    TokenProvider tokenProvider,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'BASE_URL',
          defaultValue: 'http://localhost:3000',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // AuthInterceptor để attach token và refresh nếu 401
    final authInterceptor = AuthInterceptor(
      dio: dio,
      getAccessToken: () => tokenProvider.getAccessToken(),
      refreshToken: () async {
        // Dùng refreshDio để tránh vòng lặp interceptor
        final refresh = await tokenProvider.getRefreshToken();
        if (refresh == null) return null;

        try {
          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refresh},
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccess = response.data['accessToken'] as String?;
            final newRefresh = response.data['refreshToken'] as String?;

            if (newAccess != null) {
              await tokenProvider.setAccessToken(newAccess);
              if (newRefresh != null) {
                await tokenProvider.setRefreshToken(newRefresh);
              }
              return newAccess;
            }
          }
        } catch (_) {
          return null;
        }
        return null;
      },
      onRefreshFailed: () async {
        await tokenProvider.clearTokens();
        // TODO: Navigate to login screen
        // Có thể emit event logout qua BLoC hoặc router redirect
      },
    );

    dio.interceptors.addAll([loggingInterceptor, authInterceptor]);
    return dio;
  }

  @lazySingleton
  DioClient dioClient(@Named('mainDio') Dio dio) {
    return DioClient.fromDio(dio);
  }
}
