import 'package:hust_chill_app/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/models/refresh_token/refresh_token_model.dart';
import '../../data/models/user_model/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:hust_chill_app/core/data/local/share_preferences_manager.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferencesManager preferencesManager;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc({
    required this.preferencesManager,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(AuthInitial()) {
    on<SendOtpRequested>(_sendOtp);
    on<VerifyOtpRequested>(_verifyOtp);
    on<LogOutRequested>(_logOut);
  }

  Future<void> _sendOtp(SendOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(params: SendOtpParams(event.email));
    if (result is DataSuccess) {
      emit(OtpSentSuccess());
    } else if (result is DataError) {
      emit(AuthFailure('Gửi OTP thất bại'));
    }
  }

  Future<void> _verifyOtp(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyOtpUseCase(
      params: VerifyOtpParams(email: event.email, otp: event.otp),
    );
    if (result is DataSuccess && result.data != null) {
      final (user, tokens) = result.data!;
      emit(AuthSuccess(user as UserModel, tokens as RefreshTokenModel));
    } else if (result is DataError) {
      emit(AuthFailure('Xác thực thất bại'));
    }
  }

  Future<void> _logOut(LogOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await preferencesManager.clear();
    emit(LogOutSuccess());
  }
}
