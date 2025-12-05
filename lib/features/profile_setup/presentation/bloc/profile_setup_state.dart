import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/user/user_entity.dart';
import '../../data/models/interests_response.dart';

part 'profile_setup_state.freezed.dart';

@freezed
class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState.initial({
    @Default('') String name,
    @Default('') String dateOfBirth,
    @Default('') String gender,
    @Default('') String major,
    @Default('') String className,
    @Default('') String studentId,
    @Default([]) List<String> photoUrls,
    @Default([]) List<String> interests,
    @Default('') String bio,
    @Default('') String interestedIn,
    @Default(false) bool isUploading,
    @Default(0.0) double uploadProgress,
    @Default([]) List<String> availableMajors,
    @Default(false) bool isMajorsLoading,
    @Default([]) List<InterestCategory> availableInterests, // Interests from backend
    @Default(false) bool isInterestsLoading,
  }) = ProfileSetupInitial;
  
  const factory ProfileSetupState.loading() = ProfileSetupLoading;
  const factory ProfileSetupState.uploadingPhoto(double progress) = UploadingPhoto;
  const factory ProfileSetupState.photoUploaded(String url) = PhotoUploaded;
  const factory ProfileSetupState.completed(UserEntity user) = ProfileSetupCompleted;
  const factory ProfileSetupState.error(String message) = ProfileSetupError;
}

