part of 'chat_room_bloc.dart';

@freezed
class ChatRoomState with _$ChatRoomState {
  const factory ChatRoomState.initial() = _Initial;

  const factory ChatRoomState.loaded({
    required ConversationEntity conversation,
    required List<MessageEntity> messages,
    required bool isLoadingMessages,
    required bool isSending,
    String? error,
  }) = _Loaded;
}
