import 'package:equatable/equatable.dart';

/// Entity đại diện cho một tin nhắn trong chat
class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    senderName,
    senderAvatar,
    content,
    type,
    createdAt,
    isRead,
  ];
}

enum MessageType {
  text,
  image,
  system, // For "You matched with X"
}
