import 'package:dio/dio.dart';
import '../mapper/exception_mapper.dart';
import '../mapper/dio_exception_mapper.dart';

import '../failures/failure.dart';
import '../failures/unknown_failure.dart';
import 'failure_to_message.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure handleException(Exception e) {
    try {
      if (e is DioException) {
        final appEx = DioExceptionMapper.map(e);
        return ExceptionMapper.mapExceptionToFailure(appEx);
      }

      return ExceptionMapper.mapExceptionToFailure(e);
    } catch (_) {
      return UnknownFailure('Unexpected error');
    }
  }

  static String handleFailure(Failure failure) {
    return FailureToMessage.map(failure);
  }
}
