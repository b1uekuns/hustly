import '../refresh_token/refresh_token_model.dart';
import '../user_model/user_model.dart';

class VerifyOtpResponseModel {
  final UserModel user;
  final RefreshTokenModel tokens;
  final bool isNewUser;
  final bool isVerified;

  VerifyOtpResponseModel({
    required this.user,
    required this.tokens,
    this.isNewUser = false,
    this.isVerified = false,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      user: UserModel.fromJson(json['user']),
      tokens: RefreshTokenModel(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      ),
      isNewUser: json['isNewUser'] ?? false,
      isVerified: json['isVerified'] ?? false,
    );
  }
}
