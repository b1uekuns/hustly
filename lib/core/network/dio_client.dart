// core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../error/exceptions/unknown_exception.dart';
import '../error/mapper/dio_exception_mapper.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 15),
    Map<String, dynamic>? headers,
    Interceptor? authInterceptor,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            sendTimeout: const Duration(seconds: 15),
            responseType: ResponseType.json,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              if (headers != null) ...headers,
            },
          ),
        ) {
    // Thêm interceptors mặc định
    _dio.interceptors.add(LoggingInterceptor());
    if (authInterceptor != null) _dio.interceptors.add(authInterceptor);
  }

  Dio get rawDio => _dio; // cho test/debug nếu cần

  /// --- HTTP Methods tiện dụng ---

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: query, options: options);
    } on DioException catch (e, st) {
      throw DioExceptionMapper.map(e, st: st);
    } catch (e, st) {
      throw UnknownException(message: e.toString(), original: e, stackTrace: st);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: query, options: options);
    } on DioException catch (e, st) {
      throw DioExceptionMapper.map(e, st: st);
    } catch (e, st) {
      throw UnknownException(message: e.toString(), original: e, stackTrace: st);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: query, options: options);
    } on DioException catch (e, st) {
      throw DioExceptionMapper.map(e, st: st);
    } catch (e, st) {
      throw UnknownException(message: e.toString(), original: e, stackTrace: st);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: query, options: options);
    } on DioException catch (e, st) {
      throw DioExceptionMapper.map(e, st: st);
    } catch (e, st) {
      throw UnknownException(message: e.toString(), original: e, stackTrace: st);
    }
  }

  /// Optional: custom request method
  Future<Response<T>> request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      return await _dio.request<T>(
        path,
        data: data,
        queryParameters: query,
        options: options?.copyWith(method: method) ?? Options(method: method),
      );
    } on DioException catch (e, st) {
      throw DioExceptionMapper.map(e, st: st);
    } catch (e, st) {
      throw UnknownException(message: e.toString(), original: e, stackTrace: st);
    }
  }
}
