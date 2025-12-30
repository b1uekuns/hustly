import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/usecases/app_usecases.dart';
import '../entities/login_response/login_response_entity.dart';
import '../entities/refresh_token/refresh_token_entities.dart';
import '../entities/user/user_entity.dart';
import '../repositories/auth_repository.dart';

/// --------------------
/// Params Classes
/// --------------------
class SendOtpParams {
  final String email;
  SendOtpParams(this.email);
}

class VerifyOtpParams {
  final String email;
  final String otp;
  VerifyOtpParams({required this.email, required this.otp});
}

class RefreshTokenParams {
  final String refreshToken;
  RefreshTokenParams(this.refreshToken);
}

/// --------------------
/// UseCases (Clean Architecture)
/// Repository returns Failure directly, no conversion needed
/// --------------------

// 1. Send OTP
// Clean Architecture: Repository returns Failure, no conversion needed
@injectable
class SendOtpUseCase implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.email);
  }
}

// 2. Verify OTP
@injectable
class VerifyOtpUseCase
    implements UseCase<LoginResponseEntity, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponseEntity>> call(
    VerifyOtpParams params,
  ) async {
    return await repository.verifyOtp(params.email, params.otp);
  }
}

// 3. Get Current User
@injectable
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

// 4. Refresh Token
@injectable
class RefreshTokenUseCase
    implements UseCase<RefreshTokenEntity, RefreshTokenParams> {
  final AuthRepository repository;
  RefreshTokenUseCase(this.repository);

  @override
  Future<Either<Failure, RefreshTokenEntity>> call(
    RefreshTokenParams params,
  ) async {
    return await repository.refreshToken(params.refreshToken);
  }
}

// 5. Logout
@injectable
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
