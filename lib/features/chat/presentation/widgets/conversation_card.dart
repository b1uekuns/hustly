import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:intl/intl.dart';

class ConversationCard extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColor.redIcon,
        child: const Icon(Icons.delete, color: AppColor.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        onDelete();
        return false; // Don't auto-dismiss, let the bloc handle it
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColor.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.redLight,
                    backgroundImage: conversation.otherUser.avatar != null
                        ? CachedNetworkImageProvider(
                            conversation.otherUser.avatar!,
                          )
                        : null,
                    child: conversation.otherUser.avatar == null
                        ? Text(
                            conversation.otherUser.name[0].toUpperCase(),
                            style: AppStyle.def.copyWith(
                              color: AppColor.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  // Unread badge
                  if (conversation.hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColor.redIcon,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          conversation.unreadCount > 9
                              ? '9+'
                              : conversation.unreadCount.toString(),
                          style: AppStyle.def.copyWith(
                            color: AppColor.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Name and message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation.otherUser.name,
                            style: AppStyle.def.copyWith(
                              fontWeight: conversation.hasUnread
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(conversation.lastMessageTime),
                          style: AppStyle.def.copyWith(
                            fontSize: 12,
                            color: conversation.hasUnread
                                ? AppColor.redIcon
                                : AppColor.grey,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.displayLastMessage,
                      style: AppStyle.def.copyWith(
                        fontSize: 14,
                        color: conversation.hasUnread
                            ? AppColor.black
                            : AppColor.grey,
                        fontWeight: conversation.hasUnread
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
