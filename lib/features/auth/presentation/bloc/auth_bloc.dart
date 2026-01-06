// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../../../core/error/handlers/token_provider.dart';
import '../../../profile_setup/domain/repositories/profile_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final TokenProvider tokenProvider;
  final ProfileRepository profileRepository;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.tokenProvider,
    required this.profileRepository,
  }) : super(const AuthState.initial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔵 [AUTH_BLOC] SendOtpRequested - email: ${event.email}');
    emit(const AuthState.sendingOtp());

    try {
      print('🔵 [AUTH_BLOC] Calling sendOtpUseCase...');
      final result = await sendOtpUseCase(SendOtpParams(event.email));

      print('🔵 [AUTH_BLOC] Got result from sendOtpUseCase');
      result.fold(
        (failure) {
          print('❌ [AUTH_BLOC] SendOTP failed: ${failure.message}');
          emit(AuthState.sendOtpError("Gửi OTP thất bại"));
        },
        (_) {
          print('✅ [AUTH_BLOC] SendOTP success');
          emit(AuthState.otpSent(email: event.email, expiresIn: 300));
        },
      );
    } catch (e, stackTrace) {
      print('❌ [AUTH_BLOC] Exception: $e');
      print('❌ [AUTH_BLOC] StackTrace: $stackTrace');
      emit(AuthState.sendOtpError('Đã xảy ra lỗi: $e'));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.verifyingOtp());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) {
        emit(AuthState.verifyOtpError("Xác thực OTP thất bại"));
      },
      (response) {
        emit(
          AuthState.authenticated(
            user: response.user,
            token: response.token,
            isNewUser: response.isNewUser,
            needsApproval: response.needsApproval,
            isApproved: response.isApproved,
            isRejected: response.isRejected,
            rejectionReason: response.rejectionReason,
          ),
        );
      },
    );
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.sendingOtp());

    final result = await sendOtpUseCase(SendOtpParams(event.email));

    result.fold((failure) {
      emit(AuthState.sendOtpError("Gửi lại OTP thất bại"));
    }, (_) => emit(AuthState.otpSent(email: event.email, expiresIn: 300)));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.loading());
      await tokenProvider.clearTokens();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.sendOtpError('Logout failed: $e'));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔵 [AUTH_BLOC] AuthCheckRequested - checking approval status...');

    // Only check if we're in an authenticated state
    final currentState = state;
    if (currentState is! Authenticated) {
      print('🔵 [AUTH_BLOC] Not authenticated, skipping check');
      return;
    }

    try {
      final result = await profileRepository.getMyProfile();

      result.fold(
        (failure) {
          print('❌ [AUTH_BLOC] Failed to get profile: ${failure.message}');
          // Don't change state on failure, just log it
        },
        (user) {
          print(
            '✅ [AUTH_BLOC] Got profile, approvalStatus: ${user.approvalStatus}',
          );

          final isApproved = user.approvalStatus == 'approved';
          final isRejected = user.approvalStatus == 'rejected';
          final needsApproval = user.approvalStatus == 'pending';

          // Always emit new state with updated user to ensure UI reflects latest status
          emit(
            AuthState.authenticated(
              user: user, // Update with fresh user data
              token: currentState.token,
              isNewUser: false,
              needsApproval: needsApproval,
              isApproved: isApproved,
              isRejected: isRejected,
              rejectionReason: user.rejectionReason,
            ),
          );
        },
      );
    } catch (e) {
      print('❌ [AUTH_BLOC] Exception checking auth: $e');
    }
  }
}
