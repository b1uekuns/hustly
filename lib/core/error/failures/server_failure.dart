import 'failure.dart';

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? code, Map<String, dynamic>? details})
      : super(message, code: code, details: details);
}