import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hust_chill_app/core/usecases/app_usecases.dart';
import 'package:hust_chill_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../core/error/failures/failure.dart';

@injectable
class CreateConversationUseCase
    extends UseCase<String, CreateConversationParams> {
  final ChatRepository repository;

  CreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateConversationParams params) {
    return repository.createConversation(params.matchedUserId);
  }
}

class CreateConversationParams extends Equatable {
  final String matchedUserId;

  const CreateConversationParams(this.matchedUserId);

  @override
  List<Object?> get props => [matchedUserId];
}
