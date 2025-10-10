import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/auth/domain/entities/user/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Model/DTO dùng ở Data layer để (de)serialize JSON.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String studentId,
    required String email,
    required String name,
    String? avatar,
    @Default(false) bool isVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Chuyển Model -> Entity (dùng ở RepositoryImpl)
extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        studentId: studentId,
        email: email,
        name: name,
        avatar: avatar,
        isVerified: isVerified,
      );
}

