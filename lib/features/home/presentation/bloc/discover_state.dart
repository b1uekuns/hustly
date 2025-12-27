part of 'discover_bloc.dart';

enum SwipeAction { like, pass }

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState.initial() = Initial;

  const factory DiscoverState.loading() = Loading;

  const factory DiscoverState.loaded({
    required List<DiscoverUserModel> users,
    required int currentIndex,
    PaginationMeta? pagination,
    String? error,
  }) = Loaded;

  const factory DiscoverState.interacting({
    required List<DiscoverUserModel> users,
    required int currentIndex,
    PaginationMeta? pagination,
    required SwipeAction action,
  }) = Interacting;

  const factory DiscoverState.matched({
    required List<DiscoverUserModel> users,
    required int currentIndex,
    PaginationMeta? pagination,
    required MatchedUserData matchedUser,
  }) = Matched;

  const factory DiscoverState.noMoreUsers() = NoMoreUsers;

  const factory DiscoverState.error(String message) = DiscoverError;
}
