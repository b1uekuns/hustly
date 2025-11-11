// core/error/mapper/dio_exception_mapper.dart  (Dio v5)
import 'dart:io';
import 'package:dio/dio.dart'; // Dio v5: DioException, DioExceptionType

import '../exceptions/app_exception.dart';
import '../exceptions/server_exception.dart';
import '../exceptions/unauthorized_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/timeout_exception.dart';
import '../exceptions/unknown_exception.dart';

class DioExceptionMapper {
  const DioExceptionMapper._();

  static AppException map(DioException error, {StackTrace? st}) {
    final underlying = error.error;
    final resp = error.response;
    final status = resp?.statusCode;
    final respData = resp?.data;
    final serverMessage = _extractMessage(respData) ?? error.message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: serverMessage ?? 'Request timeout',
          code: status,
          original: error,
          stackTrace: st,
          details: respData is Map ? Map<String, dynamic>.from(respData) : null,
        );

      case DioExceptionType.badResponse:
        if (status == 401 || status == 403) {
          return UnauthorizedException(
            message: serverMessage ?? 'Unauthorized',
            code: status,
            original: error,
            stackTrace: st,
            details: respData is Map ? Map<String, dynamic>.from(respData) : null,
          );
        }
        return ServerException(
          message: serverMessage ?? 'Server error',
          code: status,
          original: error,
          stackTrace: st,
          details: respData is Map ? Map<String, dynamic>.from(respData) : null,
        );

      case DioExceptionType.cancel:
        return UnknownException(
          message: 'Request cancelled',
          original: error,
          stackTrace: st,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'SSL certificate validation failed',
          original: error,
          stackTrace: st,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (underlying is SocketException) {
          final msg = underlying.message.isNotEmpty ? underlying.message : 'No internet connection';
          return NetworkException(
            message: msg,
            original: underlying,
            stackTrace: st,
          );
        }
        return UnknownException(
          message: error.message ?? 'Unknown network error',
          original: error,
          stackTrace: st,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    try {
      if (data == null) return null;
      if (data is String && data.isNotEmpty) return data;
      if (data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['error'] != null) return data['error'].toString();
        if (data['msg'] != null) return data['msg'].toString();
        if (data['errors'] is Map) {
          final first = (data['errors'] as Map).values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
        }
      }
    } catch (_) {}
    return null;
  }
}
