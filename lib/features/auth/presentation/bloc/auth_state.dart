// import 'package:equatable/equatable.dart';

// import '../../data/models/refresh_token/refresh_token_model.dart';
// import '../../data/models/user_model/user_model.dart';

// abstract class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object?> get props => [];
// }

// class AuthInitial extends AuthState {}

// class OtpSentSuccess extends AuthState {
//   final String email;
//   final String message;
//   OtpSentSuccess({required this.email, required this.message});

//   @override
//   List<Object?> get props => [email, message];
// }

// class OtpSentFailure extends AuthState {
//   final String message;
//   OtpSentFailure(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class OtpSending extends AuthState {}

// class AuthLoading extends AuthState {}

// class AuthSuccess extends AuthState {
//   final UserModel user;
//   final RefreshTokenModel tokens;
//   final bool isNewUser;
//   final bool isVerified;
//   AuthSuccess(
//     this.user,
//     this.tokens, {
//     this.isNewUser = false,
//     this.isVerified = false,
//   });
//   @override
//   List<Object?> get props => [user, tokens, isNewUser, isVerified];
// }

// class AuthFailure extends AuthState {
//   final String message;
//   AuthFailure(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// //logout state
// class LogOutLoading extends AuthState {}

// class LogOutSuccess extends AuthState {}

// class LogOutFailure extends AuthState {}

part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  // Initial
  const factory AuthState.initial() = Initial;

  // OTP Sending
  const factory AuthState.sendingOtp() = SendingOtp;
  const factory AuthState.otpSent({
    required String email,
    required int expiresIn,
  }) = OtpSent;
  const factory AuthState.sendOtpError(String message) = SendOtpError;

  // OTP Verifying
  const factory AuthState.verifyingOtp() = VerifyingOtp;
  const factory AuthState.authenticated({
    required UserEntity user, // ✅ Use Domain entity
    required String token,
    required bool isNewUser,
    @Default(false) bool needsApproval,
    @Default(false) bool isApproved,
    @Default(false) bool isRejected,
    String? rejectionReason,
  }) = Authenticated;
  const factory AuthState.verifyOtpError(String message) = VerifyOtpError;

  // Logged out
  const factory AuthState.unauthenticated() = Unauthenticated;

  // Loading
  const factory AuthState.loading() = Loading;
}