import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/upload/upload_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/complete_profile_entity.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

@injectable
class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final CompleteProfileUseCase completeProfileUseCase;
  final GetMajorsUseCase getMajorsUseCase;
  final GetInterestsUseCase getInterestsUseCase;
  final UploadService uploadService;
  final AuthBloc authBloc;

  ProfileSetupBloc(
    this.completeProfileUseCase,
    this.getMajorsUseCase,
    this.getInterestsUseCase,
    this.uploadService,
    this.authBloc,
  ) : super(const ProfileSetupState.initial()) {
    on<ProfileSetupStarted>(_onStarted);
    on<FetchMajors>(_onFetchMajors);
    on<FetchInterests>(_onFetchInterests);
    on<BasicInfoUpdated>(_onBasicInfoUpdated);
    on<UploadPhotoRequested>(_onUploadPhotoRequested);
    on<DeletePhotoRequested>(_onDeletePhotoRequested);
    on<InterestsUpdated>(_onInterestsUpdated);
    on<InterestedInUpdated>(_onInterestedInUpdated);
    on<DatingPurposeUpdated>(_onDatingPurposeUpdated);
    on<SubmitProfile>(_onSubmitProfile);
  }

  void _onStarted(ProfileSetupStarted event, Emitter<ProfileSetupState> emit) {
    final authState = authBloc.state;

    // Kiểm tra xem user đã login chưa để lấy email
    authState.maybeWhen(
      authenticated: (user, _, __, ___, ____, _____, ______) {
        final studentId = _extractStudentId(user.email);

        // Nếu lấy được MSSV và state hiện tại đang là Initial thì update luôn
        if (studentId.isNotEmpty && state is ProfileSetupInitial) {
          final currentState = state as ProfileSetupInitial;
          // Chỉ update nếu MSSV trong state chưa có (để tránh ghi đè nếu user đã sửa)
          if (currentState.studentId.isEmpty) {
            emit(currentState.copyWith(studentId: studentId));
          }
        }
      },
      orElse: () {},
    );
  }

  Future<void> _onFetchMajors(
    FetchMajors event,
    Emitter<ProfileSetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSetupInitial) return;

    // Set loading state
    emit(currentState.copyWith(isMajorsLoading: true));

    final result = await getMajorsUseCase();

    result.fold(
      (failure) {
        print('[ProfileSetupBloc] Error fetching majors: ${failure.message}');
        // Keep empty list on error
        emit(currentState.copyWith(isMajorsLoading: false));
      },
      (majors) {
        print('[ProfileSetupBloc] Loaded ${majors.length} majors');
        emit(currentState.copyWith(
          availableMajors: majors,
          isMajorsLoading: false,
        ));
      },
    );
  }

  Future<void> _onFetchInterests(
    FetchInterests event,
    Emitter<ProfileSetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSetupInitial) return;

    emit(currentState.copyWith(isInterestsLoading: true));

    final result = await getInterestsUseCase();

    result.fold(
      (failure) {
        print('[ProfileSetupBloc] Error fetching interests: ${failure.message}');
        emit(currentState.copyWith(isInterestsLoading: false));
      },
      (interests) {
        print('[ProfileSetupBloc] Loaded ${interests.length} interest categories');
        emit(currentState.copyWith(
          availableInterests: interests,
          isInterestsLoading: false,
        ));
      },
    );
  }

  String _extractStudentId(String email) {
    try {
      final localPart = email.split('@').first;
      final match = RegExp(
        r'\.([a-z]+)(\d{6})$',
        caseSensitive: false,
      ).firstMatch(localPart);

      if (match != null) {
        final digits = match.group(2)!;
        return '20$digits';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  void _onBasicInfoUpdated(
    BasicInfoUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      emit(
        currentState.copyWith(
          name: event.name,
          dateOfBirth: event.dateOfBirth,
          gender: event.gender,
          major: event.major,
          className: event.className,
          studentId: event.studentId,
        ),
      );
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
      emit(currentState.copyWith(interests: event.interests, bio: event.bio));
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

  void _onDatingPurposeUpdated(
    DatingPurposeUpdated event,
    Emitter<ProfileSetupState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileSetupInitial) {
      emit(currentState.copyWith(datingPurpose: event.datingPurpose));
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
      datingPurpose: currentState.datingPurpose.isEmpty ? null : currentState.datingPurpose,
      studentId: currentState.studentId,
      major: currentState.major,
      className: currentState.className,
      photos: currentState.photoUrls
          .asMap()
          .entries
          .map(
            (entry) => PhotoEntity(
              url: entry.value,
              isMain: entry.key == 0, // First photo is main
            ),
          )
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
