import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_setup_event.freezed.dart';

@freezed
class ProfileSetupEvent with _$ProfileSetupEvent {
  // Step 1: Basic Info
  const factory ProfileSetupEvent.basicInfoUpdated({
    required String name,
    required String dateOfBirth,
    required String gender,
    required String major,
    required String className,
    required String studentId,
  }) = BasicInfoUpdated;
  
  // Step 2: Photos
  const factory ProfileSetupEvent.uploadPhotoRequested(XFile photo) = UploadPhotoRequested;
  const factory ProfileSetupEvent.deletePhotoRequested(String url) = DeletePhotoRequested;
  
  // Step 3: Interests & Bio
  const factory ProfileSetupEvent.interestsUpdated({
    required List<String> interests,
    required String bio,
  }) = InterestsUpdated;
  
  // Step 4: Interested In
  const factory ProfileSetupEvent.interestedInUpdated(String interestedIn) = InterestedInUpdated;
  
  // Final: Submit
  const factory ProfileSetupEvent.submitProfile() = SubmitProfile;
}

