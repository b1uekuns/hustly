import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

@injectable
class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final CompleteProfileUseCase completeProfileUseCase;
  final GetMyProfileUseCase getMyProfileUseCase;

  ProfileSetupBloc(
    this.completeProfileUseCase,
    this.getMyProfileUseCase,
  ) : super(const ProfileSetupState.initial()) {
    on<CompleteProfileRequested>(_onCompleteProfileRequested);
    on<LoadProfileRequested>(_onLoadProfileRequested);
  }

  Future<void> _onCompleteProfileRequested(
    CompleteProfileRequested event,
    Emitter<ProfileSetupState> emit,
  ) async {
    print('[ProfileSetupBloc] Complete profile requested');
    
    emit(const ProfileSetupState.loading());

    final result = await completeProfileUseCase(event.profile);

    await result.fold(
      (failure) async {
        print('[ProfileSetupBloc] Error: ${failure.message}');
        emit(ProfileSetupState.error(failure.message));
      },
      (user) async {
        print('[ProfileSetupBloc] Profile completed successfully');
        emit(ProfileSetupState.completed(user));
      },
    );
  }

  Future<void> _onLoadProfileRequested(
    LoadProfileRequested event,
    Emitter<ProfileSetupState> emit,
  ) async {
    emit(const ProfileSetupState.loading());

    final result = await getMyProfileUseCase();

    await result.fold(
      (failure) async {
        emit(ProfileSetupState.error(failure.message));
      },
      (user) async {
        emit(ProfileSetupState.completed(user));
      },
    );
  }
}

