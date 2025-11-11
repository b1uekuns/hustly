import 'failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {int? code, Map<String, dynamic>? details})
      : super(message, code: code, details: details);
}