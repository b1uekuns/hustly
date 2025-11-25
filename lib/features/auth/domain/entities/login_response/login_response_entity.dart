import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/user_entity.dart';

part 'login_response_entity.freezed.dart';

/// Login Response Entity (Domain Layer)
/// Clean Architecture: Domain entity, independent of data implementation
@freezed
class LoginResponseEntity with _$LoginResponseEntity {
  const factory LoginResponseEntity({
    required UserEntity user,
    required String token,
    required String refreshToken,
    @Default(false) bool isNewUser,
    @Default(false) bool needsApproval,
    @Default(false) bool isApproved,
    @Default(false) bool isRejected,
    String? rejectionReason,
  }) = _LoginResponseEntity;
}

