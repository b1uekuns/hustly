import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:hust_chill_app/features/chat/data/models/conversation_model.dart';
import 'package:hust_chill_app/features/chat/data/models/message_model.dart';

part 'chat_api.g.dart';

@RestApi(baseUrl: '/api/v1/chat')
abstract class ChatApi {
  factory ChatApi(Dio dio) = _ChatApi;

  /// Lấy danh sách conversations
  @GET('/conversations')
  Future<ConversationsResponse> getConversations();

  /// Lấy chi tiết một conversation
  @GET('/conversations/{id}')
  Future<ConversationDetailResponse> getConversationById(
    @Path('id') String conversationId,
  );

  /// Lấy danh sách messages
  @GET('/conversations/{id}/messages')
  Future<MessagesResponse> getMessages(
    @Path('id') String conversationId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Gửi tin nhắn
  @POST('/conversations/{id}/messages')
  Future<SendMessageResponse> sendMessage(
    @Path('id') String conversationId,
    @Body() Map<String, dynamic> body,
  );

  /// Đánh dấu đã đọc
  @POST('/conversations/{id}/read')
  Future<void> markAsRead(@Path('id') String conversationId);

  /// Xóa conversation (unmatch)
  @DELETE('/conversations/{id}')
  Future<void> deleteConversation(@Path('id') String conversationId);

  /// Tạo conversation mới sau khi match
  @POST('/conversations')
  Future<CreateConversationResponse> createConversation(
    @Body() Map<String, dynamic> body,
  );
}
