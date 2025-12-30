import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';

@injectable
class SendMessageUseCase extends UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      type: params.type,
    );
  }
}

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;
  final MessageType type;

  const SendMessageParams({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
  });

  @override
  List<Object?> get props => [conversationId, content, type];
}
