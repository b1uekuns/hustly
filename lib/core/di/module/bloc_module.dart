import '../../../features/auth/domain/usecases/auth_usecases.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../data/local/share_preferences_manager.dart';
import '../injector.dart';

class BlocModule {
  void provides() {
    sl.registerFactory(
      () => AuthBloc(
        preferencesManager: sl<SharedPreferencesManager>(),
        sendOtpUseCase: sl<SendOtpUseCase>(),
        verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      ),
    );
  }
}
