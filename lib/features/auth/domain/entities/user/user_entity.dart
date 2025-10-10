import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    /// ID sinh viên hoặc ID hệ thống
    required String studentId,
    required String email,
    required String name,
    String? avatar,
    @Default(false) bool isVerified,
  }) = _UserEntity;
}