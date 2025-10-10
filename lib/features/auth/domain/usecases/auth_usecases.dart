import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/app_usecases.dart';
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
class SendOtpUseCase implements AppUseCases<DataState<void>, SendOtpParams> {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  @override
  Future<DataState<void>> call({SendOtpParams? params}) {
    return repository.sendOtp(params!.email);
  }
}

// 2. Xác thực OTP
class VerifyOtpUseCase
    implements AppUseCases<DataState<(UserEntity, RefreshTokenEntity)>, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  Future<DataState<(UserEntity, RefreshTokenEntity)>> call({VerifyOtpParams? params}) {
    return repository.verifyOtp(email: params!.email, otp: params.otp);
  }
}

// 3. Lấy user hiện tại
class GetCurrentUserUseCase implements AppUseCases<DataState<UserEntity>, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<DataState<UserEntity>> call({NoParams? params}) {
    return repository.getCurrentUser();
  }
}

// 4. Refresh token
class RefreshTokenUseCase
    implements AppUseCases<DataState<RefreshTokenEntity>, RefreshTokenParams> {
  final AuthRepository repository;
  RefreshTokenUseCase(this.repository);

  @override
  Future<DataState<RefreshTokenEntity>> call({RefreshTokenParams? params}) {
    return repository.refreshToken(refreshToken: params!.refreshToken);
  }
}

// 5. Logout
class LogoutUseCase implements AppUseCases<DataState<void>, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<DataState<void>> call({NoParams? params}) {
    return repository.logout();
  }
}
