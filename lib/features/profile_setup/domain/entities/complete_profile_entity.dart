import 'package:freezed_annotation/freezed_annotation.dart';

part 'complete_profile_entity.freezed.dart';

@freezed
class CompleteProfileEntity with _$CompleteProfileEntity {
  const factory CompleteProfileEntity({
    required String name,
    required DateTime dateOfBirth,
    required String gender,
    String? bio,
    required List<String> interests,
    required String interestedIn,
    String? datingPurpose, // 'relationship', 'friends', 'casual', 'unsure'
    String? studentId,
    required String major,
    required String className,
    required List<PhotoEntity> photos,
  }) = _CompleteProfileEntity;
}

@freezed
class PhotoEntity with _$PhotoEntity {
  const factory PhotoEntity({
    required String url,
    String? publicId,
    @Default(false) bool isMain,
  }) = _PhotoEntity;
}
