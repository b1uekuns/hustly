import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/entities/message_entity.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';

@injectable
class GetMessagesUseCase
    extends UseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return repository.getMessages(
      conversationId: params.conversationId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String conversationId;
  final int page;
  final int limit;

  const GetMessagesParams({
    required this.conversationId,
    this.page = 1,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [conversationId, page, limit];
}
