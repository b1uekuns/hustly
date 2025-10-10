import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_entities.freezed.dart'; 

@freezed
class RefreshTokenEntity with _$RefreshTokenEntity {
  const factory RefreshTokenEntity({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) = _RefreshTokenEntity;
}
