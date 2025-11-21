import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/user/user_entity.dart';

part 'profile_setup_state.freezed.dart';

@freezed
class ProfileSetupState with _$ProfileSetupState {
  const factory ProfileSetupState.initial() = ProfileSetupInitial;
  const factory ProfileSetupState.loading() = ProfileSetupLoading;
  const factory ProfileSetupState.completed(UserEntity user) = ProfileSetupCompleted;
  const factory ProfileSetupState.error(String message) = ProfileSetupError;
}

