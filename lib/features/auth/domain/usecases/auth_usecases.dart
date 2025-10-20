import 'package:dartz/dartz.dart';
import '../../../../core/usecases/app_usecases.dart';
import '../../data/models/login_response/login_response_model.dart'; // ✅ Dùng đúng model
import '../entities/refresh_token/refresh_token_entities.dart';
import '../entities/user/user_entity.dart';
import '../repositories/auth_repository.dart';

/// --------------------
/// Params
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
/// UseCases
/// --------------------

// 1. Gửi OTP
class SendOtpUseCase implements AppUseCases<Either<String, void>, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  @override
  Future<Either<String, void>> call({SendOtpParams? params}) {
    return repository.sendOtp(params!.email);
  }
}

// 2. Xác thực OTP ✅ Fixed: Dùng LoginResponseModel
class VerifyOtpUseCase
    implements AppUseCases<Either<String, LoginResponseModel>, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<String, LoginResponseModel>> call({
    VerifyOtpParams? params,
  }) {
    return repository.verifyOtp(params!.email, params.otp);
  }
}

// 3. Lấy user hiện tại
class GetCurrentUserUseCase implements AppUseCases<Either<String, UserEntity>, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<String, UserEntity>> call({NoParams? params}) {
    return repository.getCurrentUser();
  }
}

// 4. Refresh token
class RefreshTokenUseCase
    implements AppUseCases<Either<String, RefreshTokenEntity>, RefreshTokenParams> {
  final AuthRepository repository;
  RefreshTokenUseCase(this.repository);

  @override
  Future<Either<String, RefreshTokenEntity>> call({RefreshTokenParams? params}) {
    return repository.refreshToken(params!.refreshToken);
  }
}

// 5. Logout
class LogoutUseCase implements AppUseCases<Either<String, void>, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<String, void>> call({NoParams? params}) {
    return repository.logout();
  }
}

class NoParams {}