import 'dart:async';
import 'package:dio/dio.dart';
import 'package:hust_chill_app/features/auth/data/data_sources/remote/auth_api.dart';
import 'package:flutter/material.dart';
import '../../data/local/share_preferences_manager.dart';
import '../../utils/key_sharepreferences.dart';
import '../injector.dart';

class ApiModule {
  Future<void> provides(String prodBaseUrl) async {
    final dioProd = await setup(prodBaseUrl);

    // Đăng ký Dio vào DI
    sl.registerLazySingleton<Dio>(() => dioProd);

    // Đăng ký APIs
    sl.registerLazySingleton<AuthApi>(() => AuthApi(sl()));
  }

  static FutureOr<Dio> setup(String baseUrl) async {
    final preferencesManager = sl.get<SharedPreferencesManager>();
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      baseUrl: baseUrl,
    );

    final dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          final String? token = preferencesManager.getString(
            KeySharePreferences.jwtToken,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          debugPrint('${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (e, handler) => handler.reject(e),
      ),
    );

    return dio;
  }
}
