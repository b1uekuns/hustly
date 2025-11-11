// core/error/handlers/failure_to_message.dart
import '../failures/failure.dart';
import '../failures/network_failure.dart';
import '../failures/server_failure.dart';
import '../failures/cache_failure.dart';
import '../failures/unauthorized_failure.dart';
import '../failures/unknown_failure.dart';

class FailureToMessage {
  const FailureToMessage._();

  static String map(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Không có kết nối mạng. Vui lòng kiểm tra Internet của bạn.';
    } else if (failure is ServerFailure) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    } else if (failure is UnauthorizedFailure) {
      return 'Phiên đăng nhập của bạn đã hết hạn.';
    } else if (failure is CacheFailure) {
      return 'Không thể truy cập bộ nhớ cache.';
    } else if (failure is UnknownFailure) {
      return 'Đã xảy ra lỗi không xác định.';
    } else {
      return failure.message;
    }
  }
}
