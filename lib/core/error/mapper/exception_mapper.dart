// core/error/mapper/exception_mapper.dart

import '../exceptions/app_exception.dart';
import '../exceptions/cache_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/server_exception.dart';
import '../exceptions/timeout_exception.dart';
import '../exceptions/unauthorized_exception.dart';
import '../exceptions/unknown_exception.dart';

import '../failures/failure.dart';
import '../failures/cache_failure.dart';
import '../failures/network_failure.dart';
import '../failures/server_failure.dart';
import '../failures/unauthorized_failure.dart';
import '../failures/unknown_failure.dart';

class ExceptionMapper {
  const ExceptionMapper._();

  /// Convert an [Exception] (usually AppException) into a domain [Failure].
  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is! AppException) {
      return UnknownFailure(exception.toString());
    }

    // Unauthorized (401/403)
    if (exception is UnauthorizedException) {
      return UnauthorizedFailure(
        exception.message ?? 'Unauthorized',
        code: exception.code,
        details: exception.details,
      );
    }

    // Server (4xx/5xx)
    if (exception is ServerException) {
      return ServerFailure(
        exception.message ?? 'Server error',
        code: exception.code,
        details: exception.details,
      );
    }

    // Network / Timeout
    if (exception is TimeoutException || exception is NetworkException) {
      return NetworkFailure(
        exception.message ?? 'Lỗi mạng',
        code: exception.code,
        details: exception.details,
      );
    }

    // Cache
    if (exception is CacheException) {
      return CacheFailure(exception.message ?? 'Cache error');
    }

    // Unknown
    if (exception is UnknownException) {
      return UnknownFailure(
        exception.message ?? 'Unknown error',
        code: exception.code,
        details: exception.details,
      );
    }

    // Fallback
    return UnknownFailure(
      exception.message ?? 'Unexpected error',
      code: exception.code,
      details: exception.details,
    );
  }
}
