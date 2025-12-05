import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String studentId,
    required String email,
    required String name,
    String? avatar,
    @Default(false) bool isVerified,
    // Approval status
    String? approvalStatus, // 'pending', 'approved', 'rejected'
    String? rejectionReason,
  }) = _UserEntity;
}