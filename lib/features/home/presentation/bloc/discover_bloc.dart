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

  DiscoverBloc({required this.repository}) : super(const DiscoverState.initial()) {
    on<LoadDiscover>(_onLoadDiscover);
    on<LikeUser>(_onLikeUser);
    on<PassUser>(_onPassUser);
    on<SuperlikeUser>(_onSuperlikeUser);
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
      (data) => emit(DiscoverState.loaded(
        users: data.users,
        currentIndex: 0,
        pagination: data.pagination,
      )),
    );
  }

  Future<void> _onLikeUser(
    LikeUser event,
    Emitter<DiscoverState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    // Show liking state
    emit(DiscoverState.interacting(
      users: currentState.users,
      currentIndex: currentState.currentIndex,
      pagination: currentState.pagination,
      action: 'like',
    ));

    final result = await repository.likeUser(event.userId);

    result.fold(
      (failure) => emit(DiscoverState.loaded(
        users: currentState.users,
        currentIndex: currentState.currentIndex,
        pagination: currentState.pagination,
        error: failure.message,
      )),
      (likeData) {
        if (likeData.isMatch) {
          emit(DiscoverState.matched(
            users: currentState.users,
            currentIndex: currentState.currentIndex,
            pagination: currentState.pagination,
            matchedUser: likeData.matchedUser!,
          ));
        } else {
          // Move to next card
          _moveToNextCard(emit, currentState);
        }
      },
    );
  }

  Future<void> _onPassUser(
    PassUser event,
    Emitter<DiscoverState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    // Show passing state
    emit(DiscoverState.interacting(
      users: currentState.users,
      currentIndex: currentState.currentIndex,
      pagination: currentState.pagination,
      action: 'pass',
    ));

    final result = await repository.passUser(event.userId);

    result.fold(
      (failure) => emit(DiscoverState.loaded(
        users: currentState.users,
        currentIndex: currentState.currentIndex,
        pagination: currentState.pagination,
        error: failure.message,
      )),
      (_) => _moveToNextCard(emit, currentState),
    );
  }

  Future<void> _onSuperlikeUser(
    SuperlikeUser event,
    Emitter<DiscoverState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Loaded) return;

    // Show superlike state
    emit(DiscoverState.interacting(
      users: currentState.users,
      currentIndex: currentState.currentIndex,
      pagination: currentState.pagination,
      action: 'superlike',
    ));

    final result = await repository.superlikeUser(event.userId);

    result.fold(
      (failure) => emit(DiscoverState.loaded(
        users: currentState.users,
        currentIndex: currentState.currentIndex,
        pagination: currentState.pagination,
        error: failure.message,
      )),
      (likeData) {
        if (likeData.isMatch) {
          emit(DiscoverState.matched(
            users: currentState.users,
            currentIndex: currentState.currentIndex,
            pagination: currentState.pagination,
            matchedUser: likeData.matchedUser!,
          ));
        } else {
          _moveToNextCard(emit, currentState);
        }
      },
    );
  }

  void _onNextCard(NextCard event, Emitter<DiscoverState> emit) {
    final currentState = state;
    if (currentState is Loaded) {
      _moveToNextCard(emit, currentState);
    } else if (currentState is Matched) {
      _moveToNextCard(emit, Loaded(
        users: currentState.users,
        currentIndex: currentState.currentIndex,
        pagination: currentState.pagination,
      ));
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
      emit(DiscoverState.loaded(
        users: currentState.users,
        currentIndex: nextIndex,
        pagination: currentState.pagination,
      ));
    }
  }

  void _onResetCards(ResetCards event, Emitter<DiscoverState> emit) {
    add(const LoadDiscover(page: 1));
  }
}

