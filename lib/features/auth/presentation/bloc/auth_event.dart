import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpRequested extends AuthEvent {
  final String email;
  SendOtpRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;
  VerifyOtpRequested(this.email, this.otp);

  @override
  List<Object?> get props => [email, otp];
}

class LogOutRequested extends AuthEvent {}