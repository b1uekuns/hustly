import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/auth/data/models/refresh_token/refresh_token_model.dart';

import '../user_model/user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required UserModel user,
    required String token,
    required String refreshToken,
    @Default(false) bool isNewUser,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}

