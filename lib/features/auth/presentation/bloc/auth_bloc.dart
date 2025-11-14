import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/models/user_model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(const AuthState.initial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.sendingOtp());

    final result = await sendOtpUseCase(params: SendOtpParams(event.email));

    result.fold(
      (error) => emit(AuthState.sendOtpError(error)),
      (_) => emit(AuthState.otpSent(
        email: event.email,
        expiresIn: 300, // 5 minutes
      )),
    );
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🟢 [BLOC] Starting OTP verification...');
    emit(const AuthState.verifyingOtp());

    print('🟢 [BLOC] Calling verifyOtpUseCase...');
    final result = await verifyOtpUseCase(
      params: VerifyOtpParams(email: event.email, otp: event.otp),
    );

    print('🟢 [BLOC] Got result from use case');
    
    // Extract value from Either before async operations
    await result.fold(
      (error) async {
        print('🔴 [BLOC] Verify OTP error: $error');
        emit(AuthState.verifyOtpError(error));
      },
      (response) async {
        print('🟢 [BLOC] Verify OTP success!');
        print('🟢 [BLOC] User: ${response.user.email}');
        print('🟢 [BLOC] Token: ${response.token.substring(0, 20)}...');
        print('🟢 [BLOC] IsNewUser: ${response.isNewUser}');
        
        // Save tokens
        print('🟢 [BLOC] Saving tokens...');
        await preferencesManager.saveAccessToken(response.token);
        await preferencesManager.saveRefreshToken(response.refreshToken);
        print('🟢 [BLOC] Tokens saved!');

        print('🟢 [BLOC] Emitting authenticated state...');
        emit(AuthState.authenticated(
          user: response.user,
          token: response.token,
          isNewUser: response.isNewUser,
        ));
        print('✅ [BLOC] Authenticated state emitted!');
      },
    );
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.sendingOtp());

    final result = await sendOtpUseCase(params: SendOtpParams(event.email));

    result.fold(
      (error) => emit(AuthState.sendOtpError(error)),
      (_) => emit(AuthState.otpSent(
        email: event.email,
        expiresIn: 300,
      )),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      await preferencesManager.clear();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.sendOtpError('Logout failed: $e'));
    }
  }
}