import 'package:flutter/material.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageBubble extends StatefulWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId');
    });
  }

  bool get _isMe => _currentUserId == widget.message.senderId;

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: _isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColor.redLight,
              backgroundImage: widget.message.senderAvatar != null
                  ? NetworkImage(widget.message.senderAvatar!)
                  : null,
              child: widget.message.senderAvatar == null
                  ? Text(
                      widget.message.senderName[0].toUpperCase(),
                      style: AppStyle.def.copyWith(
                        color: AppColor.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isMe
                    ? AppColor.redIcon
                    : AppColor.grey.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(_isMe ? 20 : 4),
                  bottomRight: Radius.circular(_isMe ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.content,
                    style: AppStyle.def.copyWith(
                      color: _isMe ? AppColor.white : AppColor.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(widget.message.createdAt),
                    style: AppStyle.def.copyWith(
                      color: _isMe
                          ? AppColor.white.withOpacity(0.8)
                          : AppColor.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
