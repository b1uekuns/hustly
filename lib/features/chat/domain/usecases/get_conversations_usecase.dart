import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';

@injectable
class GetConversationsUseCase
    extends UseCase<List<ConversationEntity>, NoParams> {
  final ChatRepository repository;

  GetConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ConversationEntity>>> call(NoParams params) {
    return repository.getConversations();
  }
}
