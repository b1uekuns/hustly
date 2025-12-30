import 'package:dartz/dartz.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';

import '../../../../core/error/failures/failure.dart';

/// Repository interface cho Chat feature
abstract class ChatRepository {
  /// Lấy danh sách tất cả conversations
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  /// Lấy chi tiết một conversation
  Future<Either<Failure, ConversationEntity>> getConversationById(
    String conversationId,
  );

  /// Lấy danh sách messages trong một conversation
  /// [page] - Trang hiện tại (mặc định 1)
  /// [limit] - Số lượng messages mỗi trang (mặc định 50)
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  });

  /// Gửi tin nhắn
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  });

  /// Đánh dấu tin nhắn đã đọc
  Future<Either<Failure, void>> markAsRead(String conversationId);

  /// Xóa conversation (unmatch)
  Future<Either<Failure, void>> deleteConversation(String conversationId);

  /// Tạo conversation mới sau khi match
  /// Trả về conversationId
  Future<Either<Failure, String>> createConversation(String matchedUserId);
}
