import 'package:hust_chill_app/features/auth/domain/usecases/auth_usecases.dart';

import '../../../features/auth/data/repositories/login_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../injector.dart';

class UseCaseModule {
  void provides() {
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

    sl.registerLazySingleton(() => SendOtpUseCase(sl()));
    sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
    sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    // ...
  }
}
