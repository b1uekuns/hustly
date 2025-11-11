import 'app_exception.dart';

class TimeoutException extends AppException {
  const TimeoutException({
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