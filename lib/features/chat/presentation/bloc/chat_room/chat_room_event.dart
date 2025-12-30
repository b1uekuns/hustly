part of 'chat_room_bloc.dart';

@freezed
class ChatRoomEvent with _$ChatRoomEvent {
  const factory ChatRoomEvent.initialize(ConversationEntity conversation) =
      _Initialize;
  const factory ChatRoomEvent.loadMessages(String conversationId) =
      _LoadMessages;
  const factory ChatRoomEvent.sendMessage(
    String conversationId,
    String content,
  ) = _SendMessage;
  const factory ChatRoomEvent.markAsRead(String conversationId) = _MarkAsRead;
}
