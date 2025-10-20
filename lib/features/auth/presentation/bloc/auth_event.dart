// import 'package:equatable/equatable.dart';

// abstract class AuthEvent extends Equatable {
//   const AuthEvent();

//   @override
//   List<Object?> get props => [];
// }

// class SendOtpRequested extends AuthEvent {
//   final String email;
//   SendOtpRequested(this.email);

//   @override
//   List<Object?> get props => [email];
// }

// class VerifyOtpRequested extends AuthEvent {
//   final String email;
//   final String otp;
//   VerifyOtpRequested(this.email, this.otp);

//   @override
//   List<Object?> get props => [email, otp];
// }

// class LogOutRequested extends AuthEvent {}

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