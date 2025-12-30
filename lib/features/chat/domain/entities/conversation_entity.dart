import 'package:equatable/equatable.dart';

/// Entity đại diện cho một cuộc trò chuyện trong danh sách chat
class ConversationEntity extends Equatable {
  final String id;
  final UserPreview otherUser;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime matchedAt;
  final bool isActive;

  const ConversationEntity({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    required this.matchedAt,
    this.isActive = true,
  });

  bool get hasUnread => unreadCount > 0;

  String get displayLastMessage => lastMessage ?? 'Bạn đã match!';

  @override
  List<Object?> get props => [
    id,
    otherUser,
    lastMessage,
    lastMessageTime,
    unreadCount,
    matchedAt,
    isActive,
  ];
}

/// Thông tin preview của user trong conversation
class UserPreview extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final int? age;

  const UserPreview({
    required this.id,
    required this.name,
    this.avatar,
    this.age,
  });

  @override
  List<Object?> get props => [id, name, avatar, age];
}
