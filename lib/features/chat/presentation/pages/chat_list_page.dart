import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hust_chill_app/core/di/injection.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/conversation_card.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/empty_chat_state.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ChatListBloc>()..add(const ChatListEvent.loadConversations()),
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          'Tin nhắn',
          style: AppStyle.def.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.redIcon,
          ),
        ),
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColor.redIcon),
            ),
            loaded: (conversations) => RefreshIndicator(
              onRefresh: () async {
                context.read<ChatListBloc>().add(
                  const ChatListEvent.refreshConversations(),
                );
              },
              color: AppColor.redIcon,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationCard(
                    conversation: conversation,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat/${conversation.id}',
                        arguments: conversation,
                      );
                    },
                    onDelete: () {
                      _showUnmatchDialog(context, conversation.id);
                    },
                  );
                },
              ),
            ),
            empty: () => const EmptyChatState(),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColor.grey),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: AppStyle.def.copyWith(color: AppColor.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatListBloc>().add(
                        const ChatListEvent.loadConversations(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.redIcon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Thử lại',
                      style: AppStyle.def.copyWith(color: AppColor.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUnmatchDialog(BuildContext context, String conversationId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Hủy kết nối',
          style: AppStyle.def.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc muốn hủy kết nối? Bạn sẽ không thể nhắn tin với người này nữa.',
          style: AppStyle.def,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Hủy',
              style: AppStyle.def.copyWith(color: AppColor.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatListBloc>().add(
                ChatListEvent.deleteConversation(conversationId),
              );
            },
            child: Text(
              'Xác nhận',
              style: AppStyle.def.copyWith(color: AppColor.redIcon),
            ),
          ),
        ],
      ),
    );
  }
}
