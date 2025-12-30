import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    @JsonKey(name: '_id') required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String content,
    @JsonKey(unknownEnumValue: MessageType.text) required MessageType type,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content,
      type: type,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

@freezed
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    required bool success,
    required String message,
    required MessagesData data,
  }) = _MessagesResponse;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);
}

@freezed
class MessagesData with _$MessagesData {
  const factory MessagesData({
    required List<MessageModel> messages,
    PaginationMeta? pagination,
  }) = _MessagesData;

  factory MessagesData.fromJson(Map<String, dynamic> json) =>
      _$MessagesDataFromJson(json);
}

@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    required int currentPage,
    required int pageSize,
    required int totalItems,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPrevPage,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

@freezed
class SendMessageResponse with _$SendMessageResponse {
  const factory SendMessageResponse({
    required bool success,
    required String message,
    required MessageModel data,
  }) = _SendMessageResponse;

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
}
