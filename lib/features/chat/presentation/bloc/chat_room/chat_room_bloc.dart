import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';
import 'package:hust_chill_app/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:hust_chill_app/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:hust_chill_app/features/chat/domain/usecases/mark_as_read_usecase.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';
part 'chat_room_bloc.freezed.dart';

@injectable
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  ChatRoomBloc(
    this.getMessagesUseCase,
    this.sendMessageUseCase,
    this.markAsReadUseCase,
  ) : super(const ChatRoomState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_LoadMessages>(_onLoadMessages);
    on<_SendMessage>(_onSendMessage);
    on<_MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onInitialize(
    _Initialize event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(
      ChatRoomState.loaded(
        conversation: event.conversation,
        messages: const [],
        isLoadingMessages: true,
        isSending: false,
      ),
    );

    add(ChatRoomEvent.loadMessages(event.conversation.id));
    add(ChatRoomEvent.markAsRead(event.conversation.id));
  }

  Future<void> _onLoadMessages(
    _LoadMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final result = await getMessagesUseCase(
      GetMessagesParams(conversationId: event.conversationId),
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isLoadingMessages: false,
            error: failure.message,
          ),
        );
      },
      (messages) {
        // Sắp xếp messages theo thời gian (mới nhất ở cuối)
        final sortedMessages = List<MessageEntity>.from(messages)
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        emit(
          currentState.copyWith(
            messages: sortedMessages,
            isLoadingMessages: false,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onSendMessage(
    _SendMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    if (event.content.trim().isEmpty) return;

    emit(currentState.copyWith(isSending: true));

    final result = await sendMessageUseCase(
      SendMessageParams(
        conversationId: event.conversationId,
        content: event.content,
      ),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isSending: false, error: failure.message));
      },
      (newMessage) {
        final updatedMessages = [...currentState.messages, newMessage];
        emit(
          currentState.copyWith(
            messages: updatedMessages,
            isSending: false,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onMarkAsRead(
    _MarkAsRead event,
    Emitter<ChatRoomState> emit,
  ) async {
    await markAsReadUseCase(MarkAsReadParams(event.conversationId));
  }
}
