abstract class AppException implements Exception {
  /// Human-readable message (for debug or UI display).
  final String? message;

  /// HTTP status code or custom error code.
  final int? code;

  /// The original exception (e.g., DioError, SocketException, FormatException).
  final dynamic original;

  /// Stack trace for debugging (optional, but helpful when logging).
  final StackTrace? stackTrace;

  /// Optional extra data from the error response.
  final Map<String, dynamic>? details;

  const AppException({
    this.message,
    this.code,
    this.original,
    this.stackTrace,
    this.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer('AppException');
    if (code != null) buffer.write(' (code: $code)');
    if (message != null) buffer.write(': $message');
    if (original != null) buffer.write(' | original: $original');
    return buffer.toString();
  }
}
