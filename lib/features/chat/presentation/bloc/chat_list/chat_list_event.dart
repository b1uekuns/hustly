part of 'chat_list_bloc.dart';

@freezed
class ChatListEvent with _$ChatListEvent {
  const factory ChatListEvent.loadConversations() = _LoadConversations;
  const factory ChatListEvent.refreshConversations() = _RefreshConversations;
  const factory ChatListEvent.deleteConversation(String conversationId) =
      _DeleteConversation;
}
