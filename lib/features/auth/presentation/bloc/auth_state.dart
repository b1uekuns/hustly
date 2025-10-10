import 'package:equatable/equatable.dart';

import '../../data/models/refresh_token/refresh_token_model.dart';
import '../../data/models/user_model/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String message;
  OtpSentSuccess([
    this.message = 'Gửi OTP thành công, vui lòng kiểm tra email',
  ]);

  @override
  List<Object?> get props => [message];
}

class OtpSentFailure extends AuthState {
  final String message;
  OtpSentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  final RefreshTokenModel tokens;
  AuthSuccess(this.user, this.tokens);

  @override
  List<Object?> get props => [user, tokens];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//logout state
class LogOutLoading extends AuthState {}

class LogOutSuccess extends AuthState {}

class LogOutFailure extends AuthState {}
