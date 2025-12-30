import 'failure.dart';

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
    String message, {
    int? code,
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}
