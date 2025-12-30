// core/network/interceptors/auth_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';

typedef TokenSupplier = Future<String?> Function();
typedef TokenRefresher = Future<String?> Function();
typedef OnRefreshFailed = void Function();

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenSupplier getAccessToken;
  final TokenRefresher? refreshToken;
  final OnRefreshFailed? onRefreshFailed;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required this.dio,
    required this.getAccessToken,
    this.refreshToken,
    this.onRefreshFailed,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // ignore token read errors; request proceeds without Authorization
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // If not auth error or no refresher provided -> pass through
    if ((statusCode != 401 && statusCode != 403) || refreshToken == null) {
      handler.next(err);
      return;
    }

    RequestOptions requestOptions = err.requestOptions;

    // If already refreshing, wait for it to complete then retry
    if (_isRefreshing) {
      try {
        await (_refreshCompleter?.future);
      } catch (_) {
        // refresh failed; forward original error
        handler.next(err);
        return;
      }

      // After refresh done, try to get new token and retry
      final newToken = await _safeGetToken();
      if (newToken == null) {
        handler.next(err);
        return;
      }

      try {
        final opts = _copyRequestOptions(requestOptions);
        opts.headers['Authorization'] = 'Bearer $newToken';
        final response = await dio.fetch(opts);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      } catch (e) {
        return handler.next(
          DioException(requestOptions: requestOptions, error: e),
        );
      }
    }

    // Not currently refreshing -> attempt refresh
    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final newToken = await refreshToken!();
      // Expect refreshToken to also persist the new token (storage) and return it.
      if (newToken == null || newToken.isEmpty) {
        // Refresh didn't return a token -> treat as failure
        _refreshCompleter?.completeError('No token returned');
        _isRefreshing = false;
        onRefreshFailed?.call();
        return handler.next(err);
      }

      // Mark refresh completed for waiting requests
      _refreshCompleter?.complete();
      _isRefreshing = false;

      // Retry original request with new token
      final opts = _copyRequestOptions(requestOptions);
      opts.headers['Authorization'] = 'Bearer $newToken';

      try {
        final response = await dio.fetch(opts);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      } catch (e) {
        return handler.next(
          DioException(requestOptions: requestOptions, error: e),
        );
      }
    } catch (refreshError) {
      // Refresh failed
      _refreshCompleter?.completeError(refreshError);
      _isRefreshing = false;
      onRefreshFailed?.call();
      handler.next(err);
      return;
    } finally {
      // Ensure completer is cleared (avoid leaks)
      _refreshCompleter = null;
      _isRefreshing = false;
    }
  }

  /// Safely read token from supplier (catch errors).
  Future<String?> _safeGetToken() async {
    try {
      return await getAccessToken();
    } catch (_) {
      return null;
    }
  }

  RequestOptions _copyRequestOptions(RequestOptions src) {
    final options = RequestOptions(
      path: src.path,
      method: src.method,
      headers: Map<String, dynamic>.from(src.headers),
      queryParameters: Map<String, dynamic>.from(src.queryParameters),
      data: src.data,
      baseUrl: src.baseUrl,
      connectTimeout: src.connectTimeout,
      receiveTimeout: src.receiveTimeout,
      sendTimeout: src.sendTimeout,
      responseType: src.responseType,
      followRedirects: src.followRedirects,
      maxRedirects: src.maxRedirects,
      requestEncoder: src.requestEncoder,
      responseDecoder: src.responseDecoder,
      validateStatus: src.validateStatus,
      extra: Map<String, dynamic>.from(src.extra),
    );

    options.cancelToken = src.cancelToken;
    return options;
  }
}
