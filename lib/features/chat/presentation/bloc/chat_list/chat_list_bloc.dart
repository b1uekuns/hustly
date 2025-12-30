import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:hust_chill_app/features/chat/domain/usecases/delete_conversation_usecase.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';
part 'chat_list_bloc.freezed.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetConversationsUseCase getConversationsUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;

  ChatListBloc(this.getConversationsUseCase, this.deleteConversationUseCase)
    : super(const ChatListState.initial()) {
    on<_LoadConversations>(_onLoadConversations);
    on<_RefreshConversations>(_onRefreshConversations);
    on<_DeleteConversation>(_onDeleteConversation);
  }

  Future<void> _onLoadConversations(
    _LoadConversations event,
    Emitter<ChatListState> emit,
  ) async {
    emit(const ChatListState.loading());

    final result = await getConversationsUseCase(NoParams());

    result.fold((failure) => emit(ChatListState.error(failure.message)), (
      conversations,
    ) {
      if (conversations.isEmpty) {
        emit(const ChatListState.empty());
      } else {
        emit(ChatListState.loaded(conversations));
      }
    });
  }

  Future<void> _onRefreshConversations(
    _RefreshConversations event,
    Emitter<ChatListState> emit,
  ) async {
    final result = await getConversationsUseCase(NoParams());

    result.fold((failure) => emit(ChatListState.error(failure.message)), (
      conversations,
    ) {
      if (conversations.isEmpty) {
        emit(const ChatListState.empty());
      } else {
        emit(ChatListState.loaded(conversations));
      }
    });
  }

  Future<void> _onDeleteConversation(
    _DeleteConversation event,
    Emitter<ChatListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    // Optimistic update
    final updatedList = currentState.conversations
        .where((c) => c.id != event.conversationId)
        .toList();

    if (updatedList.isEmpty) {
      emit(const ChatListState.empty());
    } else {
      emit(ChatListState.loaded(updatedList));
    }

    // Actually delete
    final result = await deleteConversationUseCase(
      DeleteConversationParams(event.conversationId),
    );

    result.fold(
      (failure) {
        // Rollback on failure
        emit(ChatListState.loaded(currentState.conversations));
        emit(ChatListState.error(failure.message));
      },
      (_) {
        // Success - keep the updated list
      },
    );
  }
}
