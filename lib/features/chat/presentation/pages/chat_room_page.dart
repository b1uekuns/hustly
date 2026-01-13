import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hust_chill_app/core/di/injection.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/presentation/bloc/chat_room/chat_room_bloc.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/message_bubble.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/chat_input.dart';

class ChatRoomPage extends StatelessWidget {
  final ConversationEntity conversation;

  const ChatRoomPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ChatRoomBloc>()..add(ChatRoomEvent.initialize(conversation)),
      child: _ChatRoomView(conversation: conversation),
    );
  }
}

class _ChatRoomView extends StatefulWidget {
  final ConversationEntity conversation;

  const _ChatRoomView({required this.conversation});

  @override
  State<_ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<_ChatRoomView> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.redIcon),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.redLight,
              backgroundImage: widget.conversation.otherUser.avatar != null
                  ? NetworkImage(widget.conversation.otherUser.avatar!)
                  : null,
              child: widget.conversation.otherUser.avatar == null
                  ? Text(
                      widget.conversation.otherUser.name[0].toUpperCase(),
                      style: AppStyle.def.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.otherUser.name,
                    style: AppStyle.def.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.conversation.otherUser.age != null)
                    Text(
                      '${widget.conversation.otherUser.age} tuổi',
                      style: AppStyle.def.copyWith(
                        fontSize: 12,
                        color: AppColor.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColor.redIcon),
            onSelected: (value) {
              if (value == 'unmatch') {
                _showUnmatchDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'unmatch',
                child: Row(
                  children: [
                    const Icon(Icons.block, color: AppColor.redIcon),
                    const SizedBox(width: 8),
                    Text(
                      'Hủy kết nối',
                      style: AppStyle.def.copyWith(color: AppColor.redIcon),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ChatRoomBloc, ChatRoomState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded:
                (conversation, messages, isLoadingMessages, isSending, error) {
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: AppColor.redIcon,
                      ),
                    );
                  }
                  // Scroll to bottom when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _scrollController.hasClients) {
                      _scrollToBottom();
                    }
                  });
                },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loaded:
                (conversation, messages, isLoadingMessages, isSending, error) {
                  return Column(
                    children: [
                      // Messages list
                      Expanded(
                        child: isLoadingMessages
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.redIcon,
                                ),
                              )
                            : messages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.waving_hand,
                                      size: 64,
                                      color: AppColor.redIcon.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Các bạn đã match!',
                                      style: AppStyle.def.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Hãy gửi tin nhắn đầu tiên',
                                      style: AppStyle.def.copyWith(
                                        color: AppColor.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];
                                  return MessageBubble(message: message);
                                },
                              ),
                      ),
                      // Input
                      ChatInput(
                        controller: _messageController,
                        isSending: isSending,
                        onSend: (content) {
                          context.read<ChatRoomBloc>().add(
                            ChatRoomEvent.sendMessage(conversation.id, content),
                          );
                          _messageController.clear();
                        },
                      ),
                    ],
                  );
                },
            orElse: () => const Center(
              child: CircularProgressIndicator(color: AppColor.redIcon),
            ),
          );
        },
      ),
    );
  }

  void _showUnmatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Hủy kết nối',
          style: AppStyle.def.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc muốn hủy kết nối với ${widget.conversation.otherUser.name}? Bạn sẽ không thể nhắn tin với người này nữa.',
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
              Navigator.pop(context); // Go back to chat list
              // The ChatListBloc will handle the deletion
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
