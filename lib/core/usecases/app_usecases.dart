import 'package:dartz/dartz.dart';
import '../error/failures/failure.dart';

/// Abstract base class cho tất cả use cases
/// 
/// UseCase đại diện cho 1 business logic operation
/// Input: Params (parameters cần thiết)
/// Output: Either<Failure, Type> (Success or Failure)
/// 
/// [Type] - Return type khi thành công
/// [Params] - Input parameters
abstract class UseCase<Type, Params> {
  /// Execute use case
  Future<Either<Failure, Type>> call(Params params);
}

/// No Params class - Dùng khi use case không cần parameters
class NoParams {
  const NoParams();
}