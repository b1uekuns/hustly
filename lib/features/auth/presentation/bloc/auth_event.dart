part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  // Send OTP
  const factory AuthEvent.sendOtpRequested({
    required String email,
  }) = SendOtpRequested;

  // Verify OTP
  const factory AuthEvent.verifyOtpRequested({
    required String email,
    required String otp,
  }) = VerifyOtpRequested;

  // Resend OTP
  const factory AuthEvent.resendOtpRequested({
    required String email,
  }) = ResendOtpRequested;

  // Logout
  const factory AuthEvent.logoutRequested() = LogoutRequested;

  // Refresh token
  const factory AuthEvent.refreshTokenRequested() = RefreshTokenRequested;

  // Check auth status
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
}