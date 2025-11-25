import '../refresh_token/refresh_token_model.dart';
import '../user_model/user_model.dart';

class VerifyOtpResponseModel {
  final UserModel user;
  final RefreshTokenModel tokens;
  final bool isNewUser;
  final bool isVerified;
  final bool needsApproval;
  final bool isApproved;
  final bool isRejected;
  final String? rejectionReason;

  VerifyOtpResponseModel({
    required this.user,
    required this.tokens,
    this.isNewUser = false,
    this.isVerified = false,
    this.needsApproval = false,
    this.isApproved = false,
    this.isRejected = false,
    this.rejectionReason,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      user: UserModel.fromJson(json['user']),
      tokens: RefreshTokenModel(
        accessToken: json['token'] ?? json['accessToken'],
        refreshToken: json['refreshToken'],
      ),
      isNewUser: json['isNewUser'] ?? false,
      isVerified: json['isVerified'] ?? false,
      needsApproval: json['needsApproval'] ?? false,
      isApproved: json['isApproved'] ?? false,
      isRejected: json['isRejected'] ?? false,
      rejectionReason: json['rejectionReason'],
    );
  }
}
