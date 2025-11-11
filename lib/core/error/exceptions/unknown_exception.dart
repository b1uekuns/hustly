import 'app_exception.dart';

class UnknownException extends AppException {
  const UnknownException({
    String? message,
    int? code,
    dynamic original,
    StackTrace? stackTrace,
    Map<String, dynamic>? details,
  }) : super(
          message: message,
          code: code,
          original: original,
          stackTrace: stackTrace,
          details: details,
        );
}