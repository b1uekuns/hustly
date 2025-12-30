part of 'chat_list_bloc.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState.initial() = _Initial;
  const factory ChatListState.loading() = _Loading;
  const factory ChatListState.loaded(List<ConversationEntity> conversations) =
      _Loaded;
  const factory ChatListState.empty() = _Empty;
  const factory ChatListState.error(String message) = _Error;
}
