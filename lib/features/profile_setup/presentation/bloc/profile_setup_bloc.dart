import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/upload/upload_service.dart';
import '../../domain/entities/complete_profile_entity.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

@injectable
class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final CompleteProfileUseCase completeProfileUseCase;
  final UploadService uploadService;

  ProfileSetupBloc(
    this.completeProfileUseCase,
    this.uploadService,
  ) : super(const ProfileSetupState.initial()) {
    on<BasicInfoUpdated>(_onBasicInfoUpdated);
    on<UploadPhotoRequested>(_onUploadPhotoRequested);
    on<DeletePhotoRequested>(_onDeletePhotoRequested);
    on<InterestsUpdated>(_onInterestsUpdated);
    on<InterestedInUpdated>(_onInterestedInUpdated);
    on<SubmitProfile>(_onSubmitProfile);
  }

  void _onBasicInfoUpdated(
    BasicInfoUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      emit(currentState.copyWith(
        name: event.name,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
        major: event.major,
        className: event.className,
        studentId: event.studentId,
      ));
    }
  }

  Future<void> _onUploadPhotoRequested(
    UploadPhotoRequested event,
    Emitter<ProfileSetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSetupInitial) return;

    emit(ProfileSetupState.uploadingPhoto(0.0));

    final result = await uploadService.uploadImage(event.photo);

    await result.fold(
      (failure) async {
        emit(ProfileSetupState.error(failure.message));
        // Restore previous state
        emit(currentState);
      },
      (url) async {
        final newPhotos = List<String>.from(currentState.photoUrls)..add(url);
        emit(currentState.copyWith(photoUrls: newPhotos));
      },
    );
  }

  void _onDeletePhotoRequested(
    DeletePhotoRequested event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      final newPhotos = List<String>.from(currentState.photoUrls)
        ..remove(event.url);
      emit(currentState.copyWith(photoUrls: newPhotos));
    }
  }

  void _onInterestsUpdated(
    InterestsUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      emit(currentState.copyWith(
        interests: event.interests,
        bio: event.bio,
      ));
    }
  }

  void _onInterestedInUpdated(
    InterestedInUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      emit(currentState.copyWith(interestedIn: event.interestedIn));
    }
  }

  Future<void> _onSubmitProfile(
    SubmitProfile event,
    Emitter<ProfileSetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSetupInitial) return;

    print('[ProfileSetupBloc] Submitting profile...');
    emit(const ProfileSetupState.loading());

    // Create complete profile entity
    final profile = CompleteProfileEntity(
      name: currentState.name,
      dateOfBirth: DateTime.parse(currentState.dateOfBirth),
      gender: currentState.gender,
      bio: currentState.bio.isEmpty ? null : currentState.bio,
      interests: currentState.interests,
      interestedIn: currentState.interestedIn,
      studentId: currentState.studentId,
      major: currentState.major,
      className: currentState.className,
      photos: currentState.photoUrls
          .asMap()
          .entries
          .map((entry) => PhotoEntity(
                url: entry.value,
                isMain: entry.key == 0, // First photo is main
              ))
          .toList(),
    );

    final result = await completeProfileUseCase(profile);

    await result.fold(
      (failure) async {
        print('[ProfileSetupBloc] Error: ${failure.message}');
        emit(ProfileSetupState.error(failure.message));
        emit(currentState); // Restore state
      },
      (user) async {
        print('[ProfileSetupBloc] Profile completed successfully');
        emit(ProfileSetupState.completed(user));
      },
    );
  }
}

