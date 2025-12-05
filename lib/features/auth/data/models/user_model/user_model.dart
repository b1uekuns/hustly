import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String email,
    String? name,
    String? dateOfBirth,
    String? gender,
    String? bio,
    @Default([]) List<PhotoModel> photos,
    @Default([]) List<String> interests,
    String? interestedIn,
    String? studentId,
    String? major,
    @JsonKey(name: 'class') String? className,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isProfileComplete,
    String? lastActive,
    @Default(false) bool isOnline,
    // Approval status fields
    String? approvalStatus, // 'pending', 'approved', 'rejected'
    String? rejectionReason,
    String? approvedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      studentId: studentId ?? id,
      email: email,
      name: '$name'.isNotEmpty 
          ? '$name' 
          : email.split('@').first,
      avatar: photos.isNotEmpty 
          ? photos.firstWhere((p) => p.isMain, orElse: () => photos.first).url 
          : null,
      isVerified: isEmailVerified,
      approvalStatus: approvalStatus,
      rejectionReason: rejectionReason,
    );
  }
}

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String url,
    String? publicId,
    @Default(false) bool isMain,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}

