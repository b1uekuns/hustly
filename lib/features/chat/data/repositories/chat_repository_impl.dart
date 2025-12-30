import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/data/data_sources/remote/chat_api.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/failures/network_failure.dart';
import '../../../../core/error/failures/server_failure.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatApi api;

  ChatRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final response = await api.getConversations();
      final conversations = response.data.conversations
          .map((model) => model.toEntity())
          .toList();
      return Right(conversations);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversationById(
    String conversationId,
  ) async {
    try {
      final response = await api.getConversationById(conversationId);
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await api.getMessages(conversationId, page, limit);
      final messages = response.data.messages
          .map((model) => model.toEntity())
          .toList();
      return Right(messages);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      final body = {'content': content, 'type': type.name};
      final response = await api.sendMessage(conversationId, body);
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      await api.markAsRead(conversationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(
    String conversationId,
  ) async {
    try {
      await api.deleteConversation(conversationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> createConversation(
    String matchedUserId,
  ) async {
    try {
      final body = {'matchedUserId': matchedUserId};
      final response = await api.createConversation(body);
      return Right(response.data.conversationId);
    } on DioException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

  Failure _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      String message = 'Đã xảy ra lỗi';
      if (data is Map && data.containsKey('message')) {
        message = data['message'];
      }

      switch (statusCode) {
        case 400:
          return ServerFailure(message);
        case 401:
          return ServerFailure('Phiên đăng nhập đã hết hạn');
        case 403:
          return ServerFailure('Không có quyền truy cập');
        case 404:
          return ServerFailure('Không tìm thấy cuộc trò chuyện');
        case 500:
          return ServerFailure('Lỗi máy chủ');
        default:
          return ServerFailure(message);
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkFailure('Kết nối quá chậm, vui lòng thử lại');
    }

    if (error.type == DioExceptionType.connectionError) {
      return NetworkFailure('Không có kết nối mạng');
    }

    return ServerFailure('Đã xảy ra lỗi: ${error.message}');
  }
}
