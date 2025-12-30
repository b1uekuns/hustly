abstract class Failure {
  final String message;
  final int? code;
  final Map<String, dynamic>? details;

  const Failure(this.message, {this.code, this.details});

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' (code: $code)' : ''}';
}
