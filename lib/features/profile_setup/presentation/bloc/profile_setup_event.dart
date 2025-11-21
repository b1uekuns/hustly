import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/complete_profile_entity.dart';

part 'profile_setup_event.freezed.dart';

@freezed
class ProfileSetupEvent with _$ProfileSetupEvent {
  const factory ProfileSetupEvent.completeProfileRequested(
    CompleteProfileEntity profile,
  ) = CompleteProfileRequested;
  
  const factory ProfileSetupEvent.loadProfileRequested() = LoadProfileRequested;
}

