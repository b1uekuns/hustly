import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/auth/domain/entities/refresh_token/refresh_token_entities.dart';

part 'refresh_token_model.freezed.dart';
part 'refresh_token_model.g.dart';

@freezed
class RefreshTokenModel with _$RefreshTokenModel {
  const RefreshTokenModel._(); // Add private constructor
  
  const factory RefreshTokenModel({
    @JsonKey(name: 'token') required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) = _RefreshTokenModel;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenModelFromJson(json);
  
  // Convert to Entity
  RefreshTokenEntity toEntity() {
    return RefreshTokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
