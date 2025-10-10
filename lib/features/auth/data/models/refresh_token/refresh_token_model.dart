import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/auth/domain/entities/refresh_token/refresh_token_entities.dart';

part 'refresh_token_model.freezed.dart';
part 'refresh_token_model.g.dart';

@freezed
class RefreshTokenModel with _$RefreshTokenModel {
  const factory RefreshTokenModel({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) = _RefreshTokenModel;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenModelFromJson(json);
}

extension RefreshTokenMapper on RefreshTokenModel {
  RefreshTokenEntity toEntity() => RefreshTokenEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
}
