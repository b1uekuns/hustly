import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    @JsonKey(name: '_id') required String id,
    required UserPreviewModel otherUser,
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default(0) int unreadCount,
    required DateTime matchedAt,
    @Default(true) bool isActive,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  ConversationEntity toEntity() {
    return ConversationEntity(
      id: id,
      otherUser: otherUser.toEntity(),
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
      matchedAt: matchedAt,
      isActive: isActive,
    );
  }
}

@freezed
class UserPreviewModel with _$UserPreviewModel {
  const UserPreviewModel._();

  const factory UserPreviewModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? avatar,
    int? age,
  }) = _UserPreviewModel;

  factory UserPreviewModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreviewModelFromJson(json);

  UserPreview toEntity() {
    return UserPreview(id: id, name: name, avatar: avatar, age: age);
  }
}

@freezed
class ConversationsResponse with _$ConversationsResponse {
  const factory ConversationsResponse({
    required bool success,
    required String message,
    required ConversationsData data,
  }) = _ConversationsResponse;

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationsResponseFromJson(json);
}

@freezed
class ConversationsData with _$ConversationsData {
  const factory ConversationsData({
    required List<ConversationModel> conversations,
  }) = _ConversationsData;

  factory ConversationsData.fromJson(Map<String, dynamic> json) =>
      _$ConversationsDataFromJson(json);
}

@freezed
class ConversationDetailResponse with _$ConversationDetailResponse {
  const factory ConversationDetailResponse({
    required bool success,
    required String message,
    required ConversationModel data,
  }) = _ConversationDetailResponse;

  factory ConversationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailResponseFromJson(json);
}

@freezed
class CreateConversationResponse with _$CreateConversationResponse {
  const factory CreateConversationResponse({
    required bool success,
    required String message,
    required CreateConversationData data,
  }) = _CreateConversationResponse;

  factory CreateConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationResponseFromJson(json);
}

@freezed
class CreateConversationData with _$CreateConversationData {
  const factory CreateConversationData({required String conversationId}) =
      _CreateConversationData;

  factory CreateConversationData.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationDataFromJson(json);
}
