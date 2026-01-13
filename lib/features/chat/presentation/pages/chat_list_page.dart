import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hust_chill_app/core/di/injection.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/conversation_card.dart';
import 'package:hust_chill_app/features/chat/presentation/widgets/empty_chat_state.dart';
import 'package:hust_chill_app/widgets/navBar/bottom_nav_bar.dart';

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

class _ChatListView extends StatefulWidget {
  const _ChatListView();

  @override
  State<_ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  int _selectedNavIndex = 3; // Messages tab

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
                    onDelete: () {},
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
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }
}
