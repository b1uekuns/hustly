import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  /// If provided, overrides default behavior (default: enabled in debug).
  final bool? enableLogging;

  /// Max chars to print for body/debug content (keep logs readable).
  final int maxCharacters;

  const LoggingInterceptor({this.enableLogging, this.maxCharacters = 500});

  bool get _shouldLog {
    if (enableLogging != null) return enableLogging!;
    return !kReleaseMode; // default: log in debug, not in release
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // store time for duration calculation
    options.extra['_startTime'] = DateTime.now().millisecondsSinceEpoch;

    // Mask headers for logging
    final headersToLog = Map<String, dynamic>.from(options.headers);
    if (headersToLog.containsKey('Authorization')) {
      headersToLog['Authorization'] = '***';
    }

    if (_shouldLog) {
      developer.log(
        '--> ${options.method.toUpperCase()} ${options.uri}',
        name: 'ApiRequest',
      );
      developer.log('Headers: $headersToLog', name: 'ApiRequest');
      if (options.queryParameters.isNotEmpty) {
        developer.log('Query: ${options.queryParameters}', name: 'ApiRequest');
      }
      if (options.data != null) {
        developer.log(
          'Request body: ${_truncate(options.data)}',
          name: 'ApiRequest',
        );
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['_startTime'] as int?;
    final elapsed = start != null
        ? (DateTime.now().millisecondsSinceEpoch - start)
        : null;

    if (_shouldLog) {
      developer.log(
        '<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}'
        '${elapsed != null ? ' (${elapsed} ms)' : ''}',
        name: 'ApiResponse',
      );
      if (response.data != null) {
        developer.log(
          'Response body: ${_truncate(response.data)}',
          name: 'ApiResponse',
        );
      }
    } else {
      // in release: log only non-2xx
      if (response.statusCode == null || response.statusCode! >= 400) {
        developer.log(
          '<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}',
          name: 'ApiResponse',
        );
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final req = err.requestOptions;
    final start = req.extra['_startTime'] as int?;
    final elapsed = start != null
        ? (DateTime.now().millisecondsSinceEpoch - start)
        : null;

    // prepare masked headers
    final headersToLog = Map<String, dynamic>.from(req.headers);
    if (headersToLog.containsKey('Authorization')) {
      headersToLog['Authorization'] = '***';
    }

    developer.log(
      '*** DioError ${err.type} ${req.method.toUpperCase()} ${req.uri} ${elapsed != null ? '(${elapsed} ms)' : ''}',
      name: 'ApiError',
      error: err.error,
    );

    if (_shouldLog) {
      developer.log('Headers: $headersToLog', name: 'ApiError');
      if (req.queryParameters.isNotEmpty) {
        developer.log('Query: ${req.queryParameters}', name: 'ApiError');
      }
      if (req.data != null) {
        developer.log('Request body: ${_truncate(req.data)}', name: 'ApiError');
      }
      if (err.response?.data != null) {
        developer.log(
          'Error response: ${_truncate(err.response!.data)}',
          name: 'ApiError',
        );
      }
    } else {
      // minimal error info in release
      developer.log('Error: ${err.message}', name: 'ApiError');
    }

    handler.next(err);
  }

  String _truncate(dynamic obj) {
    try {
      final s = obj is String ? obj : obj.toString();
      if (s.length <= maxCharacters) return s;
      return '${s.substring(0, maxCharacters)}... (truncated, ${s.length} chars)';
    } catch (_) {
      return '<unprintable>';
    }
  }
}
