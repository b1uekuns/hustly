import 'failure.dart';

class UnknownFailure extends Failure {
  const UnknownFailure(
    String message, {
    int? code,
    Map<String, dynamic>? details,
  }) : super(message, code: code, details: details);
}
