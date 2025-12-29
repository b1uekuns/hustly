import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/discover_repository.dart';
import '../../data/models/discover_user_model.dart';

part 'discover_event.dart';
part 'discover_state.dart';
part 'discover_bloc.freezed.dart';

@injectable
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository repository;

  DiscoverBloc({required this.repository})
    : super(const DiscoverState.initial()) {
    on<LoadDiscover>(_onLoadDiscover);
    on<LikeUser>(_onLikeUser);
    on<PassUser>(_onPassUser);
    on<NextCard>(_onNextCard);
    on<ResetCards>(_onResetCards);
  }

  Future<void> _onLoadDiscover(
    LoadDiscover event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const DiscoverState.loading());

    final result = await repository.getDiscover(page: event.page, limit: 10);

    result.fold(
      (failure) => emit(DiscoverState.error(failure.message)),
      (data) => emit(
        DiscoverState.loaded(
          users: data.users,
          currentIndex: 0,
          pagination: data.pagination,
        ),
      ),
    );
  }

  Future<void> _onLikeUser(LikeUser event, Emitter<DiscoverState> emit) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    // Optimistic next card
    _moveToNextCard(emit, currentState);

    final result = await repository.likeUser(event.userId);

    result.fold(
      (failure) {
        // Optional: show toast/snackbar
        emit(DiscoverState.error(failure.message));
      },
      (likeData) {
        if (likeData.isMatch) {
          emit(
            DiscoverState.matched(
              users: currentState.users,
              currentIndex: currentState.currentIndex + 1,
              pagination: currentState.pagination,
              matchedUser: likeData.matchedUser!,
            ),
          );
        }
      },
    );
  }

  Future<void> _onPassUser(PassUser event, Emitter<DiscoverState> emit) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    _moveToNextCard(emit, currentState);

    final result = await repository.passUser(event.userId);

    result.fold((failure) {
      // Show toast/snackbar cho error
      emit(DiscoverState.error(failure.message));
    }, (_) {});
  }

  void _onNextCard(NextCard event, Emitter<DiscoverState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      _moveToNextCard(emit, currentState);
    } else if (currentState is Matched) {
      _moveToNextCard(
        emit,
        Loaded(
          users: currentState.users,
          currentIndex: currentState.currentIndex,
          pagination: currentState.pagination,
        ),
      );
    }
  }

  void _moveToNextCard(Emitter<DiscoverState> emit, Loaded currentState) {
    final nextIndex = currentState.currentIndex + 1;

    if (nextIndex >= currentState.users.length) {
      // Check if there are more pages
      if (currentState.pagination?.hasNext ?? false) {
        // Load next page
        add(LoadDiscover(page: (currentState.pagination?.page ?? 1) + 1));
      } else {
        emit(const DiscoverState.noMoreUsers());
      }
    } else {
      emit(
        DiscoverState.loaded(
          users: currentState.users,
          currentIndex: nextIndex,
          pagination: currentState.pagination,
        ),
      );
    }
  }

  void _onResetCards(ResetCards event, Emitter<DiscoverState> emit) {
    add(const LoadDiscover(page: 1));
  }
}
